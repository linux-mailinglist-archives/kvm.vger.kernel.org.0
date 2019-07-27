Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058A37770E
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfG0FwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfG0FwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568586"
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
Subject: [RFC PATCH 03/21] x86/sgx: Move provisioning device to common code
Date:   Fri, 26 Jul 2019 22:51:56 -0700
Message-Id: <20190727055214.9282-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the provisioning device to common code in preparation for adding
support for SGX virtualization.  The provisioning device will need to be
instantiated if the native SGX driver *or* the virtual EPC "driver" is
loaded.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 18 ++---------
 arch/x86/kernel/cpu/sgx/driver/main.c  | 24 +-------------
 arch/x86/kernel/cpu/sgx/main.c         | 44 +++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h          |  1 +
 4 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 89b3fb81c15b..b7aa06920d10 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -794,26 +794,12 @@ static long sgx_ioc_enclave_set_attribute(struct file *filep, void __user *arg)
 {
 	struct sgx_encl *encl = filep->private_data;
 	struct sgx_enclave_set_attribute params;
-	struct file *attribute_file;
-	int ret;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
 
-	attribute_file = fget(params.attribute_fd);
-	if (!attribute_file)
-		return -EINVAL;
-
-	if (attribute_file->f_op != &sgx_provision_fops) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
-
-out:
-	fput(attribute_file);
-	return ret;
+	return sgx_set_attribute(&encl->allowed_attributes,
+				 params.attribute_fd);
 }
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index d62bdc7ed4d9..1e107dd0d909 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -154,14 +154,8 @@ static const struct file_operations sgx_encl_fops = {
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
-const struct file_operations sgx_provision_fops = {
-	.owner			= THIS_MODULE,
-};
-
 static struct device sgx_encl_dev;
 static struct cdev sgx_encl_cdev;
-static struct device sgx_provision_dev;
-static struct cdev sgx_provision_cdev;
 
 int __init sgx_drv_init(void)
 {
@@ -202,38 +196,22 @@ int __init sgx_drv_init(void)
 	if (ret)
 		return ret;
 
-	ret = sgx_dev_init("sgx/provision", &sgx_provision_dev,
-			   &sgx_provision_cdev, &sgx_provision_fops,
-			   SGX_PROV_DEV_MINOR);
-	if (ret)
-		goto err_encl_dev;
-
 	sgx_encl_wq = alloc_workqueue("sgx-encl-wq",
 				      WQ_UNBOUND | WQ_FREEZABLE, 1);
 	if (!sgx_encl_wq) {
 		ret = -ENOMEM;
-		goto err_provision_dev;
+		goto err_encl_dev;
 	}
 
 	ret = cdev_device_add(&sgx_encl_cdev, &sgx_encl_dev);
 	if (ret)
 		goto err_encl_wq;
 
-	ret = cdev_device_add(&sgx_provision_cdev, &sgx_provision_dev);
-	if (ret)
-		goto err_encl_cdev;
-
 	return 0;
 
-err_encl_cdev:
-	cdev_device_del(&sgx_encl_cdev, &sgx_encl_dev);
-
 err_encl_wq:
 	destroy_workqueue(sgx_encl_wq);
 
-err_provision_dev:
-	put_device(&sgx_provision_dev);
-
 err_encl_dev:
 	put_device(&sgx_encl_dev);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index edbd465083c7..9f4473597620 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -2,6 +2,7 @@
 // Copyright(c) 2016-17 Intel Corporation.
 
 #include <linux/cdev.h>
+#include <linux/file.h>
 #include <linux/freezer.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
@@ -335,6 +336,31 @@ static struct bus_type sgx_bus_type = {
 };
 static dev_t sgx_devt;
 
+const struct file_operations sgx_provision_fops = {
+	.owner			= THIS_MODULE,
+};
+
+static struct device sgx_provision_dev;
+static struct cdev sgx_provision_cdev;
+
+int sgx_set_attribute(u64 *allowed_attributes, unsigned int attribute_fd)
+{
+	struct file *attribute_file;
+
+	attribute_file = fget(attribute_fd);
+	if (!attribute_file)
+		return -EINVAL;
+
+	if (attribute_file->f_op != &sgx_provision_fops) {
+		fput(attribute_file);
+		return -EINVAL;
+	}
+	fput(attribute_file);
+
+	*allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+	return 0;
+}
+
 static void sgx_dev_release(struct device *dev)
 {
 
@@ -386,12 +412,28 @@ static __init int sgx_init(void)
 	if (ret < 0)
 		goto err_bus;
 
-	ret = sgx_drv_init();
+	ret = sgx_dev_init("sgx/provision", &sgx_provision_dev,
+			   &sgx_provision_cdev, &sgx_provision_fops,
+			   SGX_PROV_DEV_MINOR);
 	if (ret)
 		goto err_chrdev_region;
 
+	ret = cdev_device_add(&sgx_provision_cdev, &sgx_provision_dev);
+	if (ret)
+		goto err_provision_dev;
+
+	ret = sgx_drv_init();
+	if (ret)
+		goto err_provision_cdev;
+
 	return 0;
 
+err_provision_cdev:
+	cdev_device_del(&sgx_provision_cdev, &sgx_provision_dev);
+
+err_provision_dev:
+	put_device(&sgx_provision_dev);
+
 err_chrdev_region:
 	unregister_chrdev_region(sgx_devt, SGX_MAX_NR_DEVICES);
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 85b3674e1d43..a0af8849c7c3 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -96,5 +96,6 @@ int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 __init int sgx_dev_init(const char *name, struct device *dev,
 			struct cdev *cdev, const struct file_operations *fops,
 			int minor);
+int sgx_set_attribute(u64 *allowed_attributes, unsigned int attribute_fd);
 
 #endif /* _X86_SGX_H */
-- 
2.22.0

