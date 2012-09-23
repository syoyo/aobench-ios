//
//  ViewController.m
//  aobench
//
//  Created by syoyo on 9/23/12.
//  Copyright (c) 2012 Syoyo Fujita. All rights reserved.
//

#import "ViewController.h"

//@interface ViewController ()

//@end

extern void ao_render(unsigned char*img, int w, int h, int stride, int s);

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  NSLog(@"viewDidLoad");
  
  UIImage *img = [UIImage imageNamed:@"Default@2x.png"];
  
  CGImageRef cgImage = [img CGImage];
  size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
  
  CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
  CFDataRef data = CGDataProviderCopyData(dataProvider);
  UInt8* pixels = (UInt8*)CFDataGetBytePtr(data);

  int w = img.size.width;
  int h = img.size.height;
  
  if (w > 256) w = 256;
  if (h > 256) h = 256;
  
  int subsamples = 2;
  
  
  NSDate *firstTime = [NSDate date];
  
  
  //ao_init_scene();
  ao_render(pixels, w, h, bytesPerRow / 4, subsamples);

  NSDate *SecondTime = [NSDate date];
  double elapsedSec = [SecondTime timeIntervalSinceDate:firstTime];
  double elapsedMSec = elapsedSec * 1000.0;
  NSLog(@"Time elapsed: %f msec", elapsedSec * 1000.0);

  
  CFDataRef resultData = CFDataCreate(NULL, pixels, CFDataGetLength(data));
  CGDataProviderRef resultDataProvider = CGDataProviderCreateWithCFData(resultData);
  CGImageRef resultCgImage = CGImageCreate(
                                           CGImageGetWidth(cgImage), CGImageGetHeight(cgImage),
                                           CGImageGetBitsPerComponent(cgImage), CGImageGetBitsPerPixel(cgImage), bytesPerRow,
                                           CGImageGetColorSpace(cgImage), CGImageGetBitmapInfo(cgImage), resultDataProvider,
                                           NULL, CGImageGetShouldInterpolate(cgImage), CGImageGetRenderingIntent(cgImage));
  UIImage* result = [[UIImage alloc] initWithCGImage:resultCgImage];

  
  _imageView.image = result;

  _lbl.textColor = [UIColor whiteColor];
  _lbl.text = [NSString stringWithFormat:@"%f sec(s)", elapsedSec];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
