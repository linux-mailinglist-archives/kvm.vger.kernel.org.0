Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323B94882A9
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 10:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiAHJBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Jan 2022 04:01:19 -0500
Received: from mxhk.zte.com.cn ([63.216.63.35]:47458 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231402AbiAHJBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Jan 2022 04:01:19 -0500
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4JWDbK2847z8131k;
        Sat,  8 Jan 2022 17:01:17 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
        by mse-fl1.zte.com.cn with SMTP id 20890qAW079364;
        Sat, 8 Jan 2022 17:00:52 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-cloudhost8.localdomain (unknown [10.234.72.110])
        by smtp (Zmail) with SMTP;
        Mon, 8 Jan 2022 17:00:52 +0800
X-Zmail-TransId: 3e8161d952c3001-c1ba5
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        wang.liang82@zte.com.cn, ZhaoQiang <zhao.qiang11@zte.com.cn>
Subject: [PATCH] KVM: Fix OOM vulnerability caused by continuously creating devices
Date:   Sun,  9 Jan 2022 00:49:48 +0800
Message-Id: <20220108164948.42112-1-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 2.33.0.rc0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 20890qAW079364
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 61D952DD.000 by FangMail milter!
X-FangMail-Envelope: 1641632477/4JWDbK2847z8131k/61D952DD.000/10.30.14.238/[10.30.14.238]/mse-fl1.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 61D952DD.000/4JWDbK2847z8131k
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ZhaoQiang <zhao.qiang11@zte.com.cn>

When processing the ioctl request for creating a device in the
kvm_vm_ioctl()function,the branch did not reclaim the successfully
created device,which caused memory leak.

Signed-off-by: ZhaoQiang <zhao.qiang11@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 virt/kvm/kvm_main.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72c4e6b39389..f4fbc935faea 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
+#include <linux/syscalls.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -4092,6 +4093,40 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	return 0;
 }
 
+static int kvm_ioctl_destroy_device(struct kvm *kvm,
+				    struct kvm_create_device *cd)
+{
+	struct kvm_device_ops *ops = NULL;
+	struct kvm_device *dev;
+	struct file *file;
+	int type;
+
+	if (cd->type >= ARRAY_SIZE(kvm_device_ops_table))
+		return -ENODEV;
+
+	type = array_index_nospec(cd->type, ARRAY_SIZE(kvm_device_ops_table));
+	ops = kvm_device_ops_table[type];
+	if (ops == NULL)
+		return -ENODEV;
+
+	file = fget(cd->fd);
+	if (!file)
+		return -ENODEV;
+
+	dev = file->private_data;
+	if (!dev)
+		return -ENODEV;
+
+	kvm_put_kvm(kvm);
+	mutex_lock(&kvm->lock);
+	list_del(&device->vm_node);
+	mutex_unlock(&kvm->lock);
+	ops->destroy(dev);
+	ksys_close(cd->fd);
+
+	return 0;
+}
+
 static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 {
 	switch (arg) {
@@ -4448,8 +4483,10 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -EFAULT;
-		if (copy_to_user(argp, &cd, sizeof(cd)))
+		if (copy_to_user(argp, &cd, sizeof(cd))) {
+			kvm_ioctl_destroy_device(kvm, &cd);
 			goto out;
+		}
 
 		r = 0;
 		break;
-- 
2.27.0
