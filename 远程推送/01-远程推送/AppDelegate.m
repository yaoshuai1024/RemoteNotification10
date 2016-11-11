//
//  AppDelegate.m
//  01-远程推送
//
//  Created by HM on 16/11/9.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

//应用退出,点击横幅接收远程推送
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.请求授权
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
//    
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            NSLog(@"授权成功");
            //设置用户通知中心的代理
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            
        }else {
            NSLog(@"授权失败");
        }
        
    }];
    
    //2.获取deviceToken
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

//接收到deviceToken后调用
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"%@", deviceToken);
}

//iOS7之前  前后台接收到远程通知都会响应(前台直接响应/后台需要点击横幅)
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//
//}

//iOS7  前后台(前台直接响应/后台需要点击横幅)&静默通知接收到远程通知都会响应    iOS10开始,该方法主要用于接收静默通知(如果没有实现willPresentNotification方法,则应用在前台时接收通知会调用该方法)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{

}

#pragma mark - UNUserNotificationCenterDelegate

//iOS10 应用在前台时接收到通知后会调用该方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{

    //获取远程通知发送的数据
    NSString *userinfo = notification.request.content.userInfo.description;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 800)];
    label.numberOfLines = 0;
    label.text = userinfo;
    label.backgroundColor = [UIColor redColor];
    [self.window.rootViewController.view addSubview:label];
    
    
    //iOS10开始,应用在前台也可以显示横幅
    completionHandler(UNNotificationPresentationOptionAlert);
}

//iOS10 应用在前台&后台&应用关闭后,点击横幅/横幅中按钮后调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{

    NSString *userinfo = response.notification.request.content.userInfo.description;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 800)];
    label.numberOfLines = 0;
    label.text = userinfo;
    label.backgroundColor = [UIColor blueColor];
    [self.window.rootViewController.view addSubview:label];
}






@end
