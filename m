Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17A963E786
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiLACL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiLACLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:11:24 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDD49D830;
        Wed, 30 Nov 2022 18:11:22 -0800 (PST)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NN00b3JrpzRpfH;
        Thu,  1 Dec 2022 10:10:39 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 10:11:20 +0800
Message-ID: <27c96875-eacd-e6da-5c9c-25cad7c5bab7@huawei.com>
Date:   Thu, 1 Dec 2022 10:11:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] vfio/mdev: fix possible memory leak in module init funcs
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <kwankhede@nvidia.com>, <kraxel@redhat.com>, <cjia@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akrowiak@linux.ibm.com>, <pasic@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>
References: <20221118032827.3725190-1-ruanjinjie@huawei.com>
 <20221130160622.0cf3e47d.alex.williamson@redhat.com>
From:   Ruan Jinjie <ruanjinjie@huawei.com>
In-Reply-To: <20221130160622.0cf3e47d.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/12/1 7:06, Alex Williamson wrote:
> [Cc +vfio-ap, vfio-ccw]
> 
> On Fri, 18 Nov 2022 11:28:27 +0800
> ruanjinjie <ruanjinjie@huawei.com> wrote:
> 
>> Inject fault while probing module, if device_register() fails,
>> but the refcount of kobject is not decreased to 0, the name
>> allocated in dev_set_name() is leaked. Fix this by calling
>> put_device(), so that name can be freed in callback function
>> kobject_cleanup().
>>
>> unreferenced object 0xffff88807d687008 (size 8):
>>   comm "modprobe", pid 8280, jiffies 4294807686 (age 12.378s)
>>   hex dump (first 8 bytes):
>>     6d 64 70 79 00 6b 6b a5                          mdpy.kk.
>>   backtrace:
>>     [<ffffffff8174f19e>] __kmalloc_node_track_caller+0x4e/0x150
>>     [<ffffffff81731d53>] kstrdup+0x33/0x60
>>     [<ffffffff83aa1421>] kobject_set_name_vargs+0x41/0x110
>>     [<ffffffff82d91abb>] dev_set_name+0xab/0xe0
>>     [<ffffffffa0260105>] 0xffffffffa0260105
>>     [<ffffffff81001c27>] do_one_initcall+0x87/0x2e0
>>     [<ffffffff813739cb>] do_init_module+0x1ab/0x640
>>     [<ffffffff81379d20>] load_module+0x5d00/0x77f0
>>     [<ffffffff8137bc40>] __do_sys_finit_module+0x110/0x1b0
>>     [<ffffffff83c944a5>] do_syscall_64+0x35/0x80
>>     [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>> unreferenced object 0xffff888101ccbcf8 (size 8):
>>   comm "modprobe", pid 15662, jiffies 4295164481 (age 13.282s)
>>   hex dump (first 8 bytes):
>>     6d 74 74 79 00 6b 6b a5                          mtty.kk.
>>   backtrace:
>>     [<ffffffff8174f19e>] __kmalloc_node_track_caller+0x4e/0x150
>>     [<ffffffff81731d53>] kstrdup+0x33/0x60
>>     [<ffffffff83aa1421>] kobject_set_name_vargs+0x41/0x110
>>     [<ffffffff82d91abb>] dev_set_name+0xab/0xe0
>>     [<ffffffffa0248134>] 0xffffffffa0248134
>>     [<ffffffff81001c27>] do_one_initcall+0x87/0x2e0
>>     [<ffffffff813739cb>] do_init_module+0x1ab/0x640
>>     [<ffffffff81379d20>] load_module+0x5d00/0x77f0
>>     [<ffffffff8137bc40>] __do_sys_finit_module+0x110/0x1b0
>>     [<ffffffff83c944a5>] do_syscall_64+0x35/0x80
>>     [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>> unreferenced object 0xffff88810177c6c8 (size 8):
>>   comm "modprobe", pid 23657, jiffies 4295314656 (age 13.227s)
>>   hex dump (first 8 bytes):
>>     6d 62 6f 63 68 73 00 a5                          mbochs..
>>   backtrace:
>>     [<ffffffff8174f19e>] __kmalloc_node_track_caller+0x4e/0x150
>>     [<ffffffff81731d53>] kstrdup+0x33/0x60
>>     [<ffffffff83aa1421>] kobject_set_name_vargs+0x41/0x110
>>     [<ffffffff82d91abb>] dev_set_name+0xab/0xe0
>>     [<ffffffffa0248124>] 0xffffffffa0248124
>>     [<ffffffff81001c27>] do_one_initcall+0x87/0x2e0
>>     [<ffffffff813739cb>] do_init_module+0x1ab/0x640
>>     [<ffffffff81379d20>] load_module+0x5d00/0x77f0
>>     [<ffffffff8137bc40>] __do_sys_finit_module+0x110/0x1b0
>>     [<ffffffff83c944a5>] do_syscall_64+0x35/0x80
>>     [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>> Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
>> Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
>> Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
>> Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
>> ---
>>  samples/vfio-mdev/mbochs.c | 4 +++-
>>  samples/vfio-mdev/mdpy.c   | 4 +++-
>>  samples/vfio-mdev/mtty.c   | 4 +++-
>>  3 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
>> index 117a8d799f71..1c47672be815 100644
>> --- a/samples/vfio-mdev/mbochs.c
>> +++ b/samples/vfio-mdev/mbochs.c
>> @@ -1430,8 +1430,10 @@ static int __init mbochs_dev_init(void)
>>  	dev_set_name(&mbochs_dev, "%s", MBOCHS_NAME);
>>  
>>  	ret = device_register(&mbochs_dev);
>> -	if (ret)
>> +	if (ret) {
>> +		put_device(&mbochs_dev);
>>  		goto err_class;
>> +	}
>>  
>>  	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver,
>>  				   mbochs_mdev_types,
> 
> 
> vfio-ap has a similar unwind as the sample drivers, but actually makes
> an attempt to catch this ex:
I think the reason is vfio-ap driver error path has common unwind to do
before device_register, otherwise it can return just after put_device or
device_unregister.
> 
> 	...
>         ret = device_register(&matrix_dev->device);
>         if (ret)
>                 goto matrix_reg_err;
> 
>         ret = driver_register(&matrix_driver);
>         if (ret)
>                 goto matrix_drv_err;
> 
>         return 0;
> 
> matrix_drv_err:
>         device_unregister(&matrix_dev->device);
> matrix_reg_err:
>         put_device(&matrix_dev->device);
> 	...
> 
> So of the vfio drivers calling device_register(), vfio-ap is the only
> one that does a put_device() if device_register() fails, but it also
> seems sketchy to call both device_unregister() and put_device() in the
> case that we exit via matrix_drv_err.
The patch do not change the original error path, just add missing
put_device out of the normal error path if device_register fails , so
there is no risk of calling both device_unregister() and put_device().
> 
> I wonder if all of these shouldn't adopt a flow like:
> 
> 	ret = device_register(&dev);
> 	if (ret)
> 		goto err1;
> 
> 	....
> 
> 	return 0;
> 
> err2:
> 	device_del(&dev);
> err1:
> 	put_device(&dev);
> 
> Thanks,
> 
> Alex
> 
>> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
>> index 946e8cfde6fd..bfb93eaf535b 100644
>> --- a/samples/vfio-mdev/mdpy.c
>> +++ b/samples/vfio-mdev/mdpy.c
>> @@ -717,8 +717,10 @@ static int __init mdpy_dev_init(void)
>>  	dev_set_name(&mdpy_dev, "%s", MDPY_NAME);
>>  
>>  	ret = device_register(&mdpy_dev);
>> -	if (ret)
>> +	if (ret) {
>> +		put_device(&mdpy_dev);
>>  		goto err_class;
>> +	}
>>  
>>  	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver,
>>  				   mdpy_mdev_types,
>> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
>> index e72085fc1376..dddb0619846c 100644
>> --- a/samples/vfio-mdev/mtty.c
>> +++ b/samples/vfio-mdev/mtty.c
>> @@ -1330,8 +1330,10 @@ static int __init mtty_dev_init(void)
>>  	dev_set_name(&mtty_dev.dev, "%s", MTTY_NAME);
>>  
>>  	ret = device_register(&mtty_dev.dev);
>> -	if (ret)
>> +	if (ret) {
>> +		put_device(&mtty_dev.dev);
>>  		goto err_class;
>> +	}
>>  
>>  	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
>>  				   &mtty_driver, mtty_mdev_types,
> 
