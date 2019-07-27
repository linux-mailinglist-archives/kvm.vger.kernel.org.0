Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EA17770F
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfG0FyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:54:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfG0FwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568584"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 02/21] x86/sgx: Move bus registration and device init to common code
Date:   Fri, 26 Jul 2019 22:51:55 -0700
Message-Id: <20190727055214.9282-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the SGX bus registration and initialization into common code in
preparation for adding a virtual EPC device, which will reside outside
of the native SGX userspace driver.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/main.c | 48 +------------------------
 arch/x86/kernel/cpu/sgx/main.c        | 50 ++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h         |  4 +++
 3 files changed, 54 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index a2506a49c95a..d62bdc7ed4d9 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -158,42 +158,10 @@ const struct file_operations sgx_provision_fops = {
 	.owner			= THIS_MODULE,
 };
 
-static struct bus_type sgx_bus_type = {
-	.name	= "sgx",
-};
-
 static struct device sgx_encl_dev;
 static struct cdev sgx_encl_cdev;
 static struct device sgx_provision_dev;
 static struct cdev sgx_provision_cdev;
-static dev_t sgx_devt;
-
-static void sgx_dev_release(struct device *dev)
-{
-}
-
-static __init int sgx_dev_init(const char *name, struct device *dev,
-			       struct cdev *cdev,
-			       const struct file_operations *fops, int minor)
-{
-	int ret;
-
-	device_initialize(dev);
-
-	dev->bus = &sgx_bus_type;
-	dev->devt = MKDEV(MAJOR(sgx_devt), minor);
-	dev->release = sgx_dev_release;
-
-	ret = dev_set_name(dev, name);
-	if (ret) {
-		put_device(dev);
-		return ret;
-	}
-
-	cdev_init(cdev, fops);
-	cdev->owner = THIS_MODULE;
-	return 0;
-}
 
 int __init sgx_drv_init(void)
 {
@@ -207,14 +175,6 @@ int __init sgx_drv_init(void)
 		return -ENODEV;
 	}
 
-	ret = bus_register(&sgx_bus_type);
-	if (ret)
-		return ret;
-
-	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_MAX_NR_DEVICES, "sgx");
-	if (ret < 0)
-		goto err_bus;
-
 	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
 	sgx_misc_reserved_mask = ~ebx | SGX_MISC_RESERVED_MASK;
 	sgx_encl_size_max_64 = 1ULL << ((edx >> 8) & 0xFF);
@@ -240,7 +200,7 @@ int __init sgx_drv_init(void)
 	ret = sgx_dev_init("sgx/enclave", &sgx_encl_dev, &sgx_encl_cdev,
 			   &sgx_encl_fops, SGX_ENCL_DEV_MINOR);
 	if (ret)
-		goto err_chrdev_region;
+		return ret;
 
 	ret = sgx_dev_init("sgx/provision", &sgx_provision_dev,
 			   &sgx_provision_cdev, &sgx_provision_fops,
@@ -277,11 +237,5 @@ int __init sgx_drv_init(void)
 err_encl_dev:
 	put_device(&sgx_encl_dev);
 
-err_chrdev_region:
-	unregister_chrdev_region(sgx_devt, SGX_MAX_NR_DEVICES);
-
-err_bus:
-	bus_unregister(&sgx_bus_type);
-
 	return ret;
 }
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index f790a03571c5..edbd465083c7 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 // Copyright(c) 2016-17 Intel Corporation.
 
+#include <linux/cdev.h>
 #include <linux/freezer.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
@@ -329,6 +330,39 @@ static __init int sgx_page_cache_init(void)
 	return 0;
 }
 
+static struct bus_type sgx_bus_type = {
+	.name	= "sgx",
+};
+static dev_t sgx_devt;
+
+static void sgx_dev_release(struct device *dev)
+{
+
+}
+
+__init int sgx_dev_init(const char *name, struct device *dev,
+			struct cdev *cdev, const struct file_operations *fops,
+			int minor)
+{
+	int ret;
+
+	device_initialize(dev);
+
+	dev->bus = &sgx_bus_type;
+	dev->devt = MKDEV(MAJOR(sgx_devt), minor);
+	dev->release = sgx_dev_release;
+
+	ret = dev_set_name(dev, name);
+	if (ret) {
+		put_device(dev);
+		return ret;
+	}
+
+	cdev_init(cdev, fops);
+	cdev->owner = THIS_MODULE;
+	return 0;
+}
+
 static __init int sgx_init(void)
 {
 	int ret;
@@ -344,12 +378,26 @@ static __init int sgx_init(void)
 	if (ret)
 		goto err_page_cache;
 
-	ret = sgx_drv_init();
+	ret = bus_register(&sgx_bus_type);
 	if (ret)
 		goto err_kthread;
 
+	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_MAX_NR_DEVICES, "sgx");
+	if (ret < 0)
+		goto err_bus;
+
+	ret = sgx_drv_init();
+	if (ret)
+		goto err_chrdev_region;
+
 	return 0;
 
+err_chrdev_region:
+	unregister_chrdev_region(sgx_devt, SGX_MAX_NR_DEVICES);
+
+err_bus:
+	bus_unregister(&sgx_bus_type);
+
 err_kthread:
 	kthread_stop(ksgxswapd_tsk);
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 4e2c3ce94f63..85b3674e1d43 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -93,4 +93,8 @@ int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 #define SGX_PROV_DEV_MINOR	1
 #define SGX_MAX_NR_DEVICES	2
 
+__init int sgx_dev_init(const char *name, struct device *dev,
+			struct cdev *cdev, const struct file_operations *fops,
+			int minor);
+
 #endif /* _X86_SGX_H */
-- 
2.22.0

