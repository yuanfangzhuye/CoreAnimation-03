//
//  ViewController.m
//  CoreAnimation-03
//
//  Created by tlab on 2020/8/6.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CAEmitterLayer *rainLayer;
@property (nonatomic, strong) UIImageView * backgroundImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.backgroundImageView];
    [self setupUI];
    [self setupEmitter];
}

- (void)setupUI
{
    float spaceWidth = ([[UIScreen mainScreen] bounds].size.width - 80 * 3) / 4;
    // 下雨按钮
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:startBtn];
    startBtn.frame = CGRectMake(spaceWidth, self.view.bounds.size.height - 60, 80, 40);
    startBtn.backgroundColor = [UIColor whiteColor];
    [startBtn setTitle:@"雨停了" forState:UIControlStateNormal];
    [startBtn setTitle:@"下雨" forState:UIControlStateSelected];
    [startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [startBtn addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 雨量按钮
    UIButton *rainBIgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:rainBIgBtn];
    rainBIgBtn.tag = 100;
    rainBIgBtn.frame = CGRectMake(spaceWidth * 2 + 80, self.view.bounds.size.height - 60, 80, 40);
    rainBIgBtn.backgroundColor = [UIColor whiteColor];
    [rainBIgBtn setTitle:@"下大点" forState:UIControlStateNormal];
    [rainBIgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rainBIgBtn addTarget:self action:@selector(rainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rainSmallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:rainSmallBtn];
    rainSmallBtn.tag = 200;
    rainSmallBtn.frame = CGRectMake(spaceWidth * 3 + 80 * 2, self.view.bounds.size.height - 60, 80, 40);
    rainSmallBtn.backgroundColor = [UIColor whiteColor];
    [rainSmallBtn setTitle:@"太大了" forState:UIControlStateNormal];
    [rainSmallBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rainSmallBtn addTarget:self action:@selector(rainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupEmitter
{
    // 1. 设置CAEmitterLayer
    self.rainLayer = [CAEmitterLayer layer];
    
    // 2.在背景图上添加粒子图层
    [self.backgroundImageView.layer addSublayer:self.rainLayer];
    
    //3.发射形状--线性
    self.rainLayer.emitterShape = kCAEmitterLayerLine;
    //发射模式
    self.rainLayer.emitterMode = kCAEmitterLayerSurface;
    //发射源大小
    self.rainLayer.emitterSize = self.view.frame.size;
    //发射源位置 y最好不要设置为0 最好<0
    self.rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    
    // 2. 配置cell
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    //粒子内容
    cell.contents = (id)[[UIImage imageNamed:@"rain_white"] CGImage];
    //每秒产生的粒子数量的系数
    cell.birthRate = 25.f;
    //粒子的生命周期
    cell.lifetime = 20.f;
    //speed粒子速度.图层的速率。用于将父时间缩放为本地时间，例如，如果速率是2，则本地时间的进度是父时间的两倍。默认值为1。
    cell.speed = 10.f;
    //粒子速度系数, 默认1.0
    cell.velocity = 10.f;
    //每个发射物体的初始平均范围,默认等于0
    cell.velocityRange = 10.f;
    //粒子在y方向的加速的
    cell.yAcceleration = 1000.f;
    //粒子缩放比例: scale
    cell.scale = 0.1;
    //粒子缩放比例范围:scaleRange
    cell.scaleRange = 0.f;
    
    // 3.添加到图层上
    self.rainLayer.emitterCells = @[cell];
}

#pragma mark ------ Actions

- (void)startButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (!sender.selected) {
        NSLog(@"开始下雨了");
        [self.rainLayer setValue:@1.f forKeyPath:@"birthRate"];
    }
    else {
        NSLog(@"雨停了");
        [self.rainLayer setValue:@0.f forKeyPath:@"birthRate"];
    }
}

- (void)rainButtonClick:(UIButton *)sender
{
    NSInteger rate = 1;
    CGFloat scale = 0.1;
    
    if (sender.tag == 100) {
        NSLog(@"下大了");
        
        if (self.rainLayer.birthRate < 30) {
            [self.rainLayer setValue:@(self.rainLayer.birthRate + rate) forKeyPath:@"birthRate"];
            [self.rainLayer setValue:@(self.rainLayer.scale + scale) forKeyPath:@"scale"];
        }
    }
    else if (sender.tag == 200) {
        NSLog(@"变小了");
        
        if (self.rainLayer.birthRate > 1) {
            [self.rainLayer setValue:@(self.rainLayer.birthRate - rate) forKeyPath:@"birthRate"];
            [self.rainLayer setValue:@(self.rainLayer.scale - scale) forKeyPath:@"scale"];
        }
    }
}

#pragma mark ------ setter&getter

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"rain"];
    }
    
    return _backgroundImageView;
}


@end
