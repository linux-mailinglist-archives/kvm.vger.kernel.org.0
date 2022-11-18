Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A399762EC5C
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 04:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240635AbiKRDbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 22:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiKRDbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 22:31:42 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D07B5132F;
        Thu, 17 Nov 2022 19:31:40 -0800 (PST)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ND2PP6fV7zHvtg;
        Fri, 18 Nov 2022 11:31:05 +0800 (CST)
Received: from huawei.com (10.67.175.83) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 18 Nov
 2022 11:31:37 +0800
From:   ruanjinjie <ruanjinjie@huawei.com>
To:     <kwankhede@nvidia.com>, <alex.williamson@redhat.com>,
        <kraxel@redhat.com>, <cjia@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH] vfio/mdev: fix possible memory leak in module init funcs
Date:   Fri, 18 Nov 2022 11:28:27 +0800
Message-ID: <20221118032827.3725190-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.83]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject fault while probing module, if device_register() fails,
but the refcount of kobject is not decreased to 0, the name
allocated in dev_set_name() is leaked. Fix this by calling
put_device(), so that name can be freed in callback function
kobject_cleanup().

unreferenced object 0xffff88807d687008 (size 8):
  comm "modprobe", pid 8280, jiffies 4294807686 (age 12.378s)
  hex dump (first 8 bytes):
    6d 64 70 79 00 6b 6b a5                          mdpy.kk.
  backtrace:
    [<ffffffff8174f19e>] __kmalloc_node_track_caller+0x4e/0x150
    [<ffffffff81731d53>] kstrdup+0x33/0x60
    [<ffffffff83aa1421>] kobject_set_name_vargs+0x41/0x110
    [<ffffffff82d91abb>] dev_set_name+0xab/0xe0
    [<ffffffffa0260105>] 0xffffffffa0260105
    [<ffffffff81001c27>] do_one_initcall+0x87/0x2e0
    [<ffffffff813739cb>] do_init_module+0x1ab/0x640
    [<ffffffff81379d20>] load_module+0x5d00/0x77f0
    [<ffffffff8137bc40>] __do_sys_finit_module+0x110/0x1b0
    [<ffffffff83c944a5>] do_syscall_64+0x35/0x80
    [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

unreferenced object 0xffff888101ccbcf8 (size 8):
  comm "modprobe", pid 15662, jiffies 4295164481 (age 13.282s)
  hex dump (first 8 bytes):
    6d 74 74 79 00 6b 6b a5                          mtty.kk.
  backtrace:
    [<ffffffff8174f19e>] __kmalloc_node_track_caller+0x4e/0x150
    [<ffffffff81731d53>] kstrdup+0x33/0x60
    [<ffffffff83aa1421>] kobject_set_name_vargs+0x41/0x110
    [<ffffffff82d91abb>] dev_set_name+0xab/0xe0
    [<ffffffffa0248134>] 0xffffffffa0248134
    [<ffffffff81001c27>] do_one_initcall+0x87/0x2e0
    [<ffffffff813739cb>] do_init_module+0x1ab/0x640
    [<ffffffff81379d20>] load_module+0x5d00/0x77f0
    [<ffffffff8137bc40>] __do_sys_finit_module+0x110/0x1b0
    [<ffffffff83c944a5>] do_syscall_64+0x35/0x80
    [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

unreferenced object 0xffff88810177c6c8 (size 8):
  comm "modprobe", pid 23657, jiffies 4295314656 (age 13.227s)
  hex dump (first 8 bytes):
    6d 62 6f 63 68 73 00 a5                          mbochs..
  backtrace:
    [<ffffffff8174f19e>] __kmalloc_node_track_caller+0x4e/0x150
    [<ffffffff81731d53>] kstrdup+0x33/0x60
    [<ffffffff83aa1421>] kobject_set_name_vargs+0x41/0x110
    [<ffffffff82d91abb>] dev_set_name+0xab/0xe0
    [<ffffffffa0248124>] 0xffffffffa0248124
    [<ffffffff81001c27>] do_one_initcall+0x87/0x2e0
    [<ffffffff813739cb>] do_init_module+0x1ab/0x640
    [<ffffffff81379d20>] load_module+0x5d00/0x77f0
    [<ffffffff8137bc40>] __do_sys_finit_module+0x110/0x1b0
    [<ffffffff83c944a5>] do_syscall_64+0x35/0x80
    [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
---
 samples/vfio-mdev/mbochs.c | 4 +++-
 samples/vfio-mdev/mdpy.c   | 4 +++-
 samples/vfio-mdev/mtty.c   | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 117a8d799f71..1c47672be815 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1430,8 +1430,10 @@ static int __init mbochs_dev_init(void)
 	dev_set_name(&mbochs_dev, "%s", MBOCHS_NAME);
 
 	ret = device_register(&mbochs_dev);
-	if (ret)
+	if (ret) {
+		put_device(&mbochs_dev);
 		goto err_class;
+	}
 
 	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver,
 				   mbochs_mdev_types,
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 946e8cfde6fd..bfb93eaf535b 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -717,8 +717,10 @@ static int __init mdpy_dev_init(void)
 	dev_set_name(&mdpy_dev, "%s", MDPY_NAME);
 
 	ret = device_register(&mdpy_dev);
-	if (ret)
+	if (ret) {
+		put_device(&mdpy_dev);
 		goto err_class;
+	}
 
 	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver,
 				   mdpy_mdev_types,
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index e72085fc1376..dddb0619846c 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1330,8 +1330,10 @@ static int __init mtty_dev_init(void)
 	dev_set_name(&mtty_dev.dev, "%s", MTTY_NAME);
 
 	ret = device_register(&mtty_dev.dev);
-	if (ret)
+	if (ret) {
+		put_device(&mtty_dev.dev);
 		goto err_class;
+	}
 
 	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
 				   &mtty_driver, mtty_mdev_types,
-- 
2.25.1

