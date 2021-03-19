Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C586341676
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhCSHYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:24:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:22827 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234330AbhCSHXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:23:48 -0400
IronPort-SDR: PlOre4642FeYsUG0fK0HR1V5MS1Bx2GAIGQ6VtWiqSgGCp/Vi8Ao6+zLmSVtT2AxwRQh/9Za50
 7NgYMtry90eA==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="274910952"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="274910952"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:48 -0700
IronPort-SDR: k/Vh6bsy1HSv366ebGrhGeTTEUxShLH6sFeB3XbDUu/8sxg0pfNPXaMfXG7rr+Gg0o+ITgPTG+
 69aHHWzrhSGQ==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409695"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:44 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 14/25] x86/sgx: Move provisioning device creation out of SGX driver
Date:   Fri, 19 Mar 2021 20:23:09 +1300
Message-Id: <0f4d044d621561f26d5f4ef73e8dc6cd18cc7e79.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

And extract sgx_set_attribute() out of sgx_ioc_enclave_provision() and
export it as symbol for KVM to use.

Provisioning key is sensitive. SGX driver only allows to create enclave
which can access provisioning key when enclave creator has permission to
open /dev/sgx_provision.  It should apply to VM as well, as provisioning
key is platform specific, thus unrestricted VM can also potentially
compromise provisioning key.

Move provisioning device creation out of sgx_drv_init() to sgx_init() as
preparation for adding SGX virtualization support, so that even SGX
driver is not enabled due to flexible launch control is not available,
SGX virtualization can still be enabled, and use it to restrict VM's
capability of being able to access provisioning key.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx.h       |  3 ++
 arch/x86/kernel/cpu/sgx/driver.c | 17 ----------
 arch/x86/kernel/cpu/sgx/ioctl.c  | 16 ++-------
 arch/x86/kernel/cpu/sgx/main.c   | 57 +++++++++++++++++++++++++++++++-
 4 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 954042e04102..a16e2c9154a3 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -372,4 +372,7 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
 #endif
 
+int sgx_set_attribute(unsigned long *allowed_attributes,
+		      unsigned int attribute_fd);
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 8ce6d8371cfb..aa9b8b868867 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -136,10 +136,6 @@ static const struct file_operations sgx_encl_fops = {
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
-const struct file_operations sgx_provision_fops = {
-	.owner			= THIS_MODULE,
-};
-
 static struct miscdevice sgx_dev_enclave = {
 	.minor = MISC_DYNAMIC_MINOR,
 	.name = "sgx_enclave",
@@ -147,13 +143,6 @@ static struct miscdevice sgx_dev_enclave = {
 	.fops = &sgx_encl_fops,
 };
 
-static struct miscdevice sgx_dev_provision = {
-	.minor = MISC_DYNAMIC_MINOR,
-	.name = "sgx_provision",
-	.nodename = "sgx_provision",
-	.fops = &sgx_provision_fops,
-};
-
 int __init sgx_drv_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
@@ -187,11 +176,5 @@ int __init sgx_drv_init(void)
 	if (ret)
 		return ret;
 
-	ret = misc_register(&sgx_dev_provision);
-	if (ret) {
-		misc_deregister(&sgx_dev_enclave);
-		return ret;
-	}
-
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 2a0aed446d6c..7f573e37f4d4 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -2,6 +2,7 @@
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
 #include <asm/mman.h>
+#include <asm/sgx.h>
 #include <linux/mman.h>
 #include <linux/delay.h>
 #include <linux/file.h>
@@ -664,24 +665,11 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 static long sgx_ioc_enclave_provision(struct sgx_encl *encl, void __user *arg)
 {
 	struct sgx_enclave_provision params;
-	struct file *file;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
 
-	file = fget(params.fd);
-	if (!file)
-		return -EINVAL;
-
-	if (file->f_op != &sgx_provision_fops) {
-		fput(file);
-		return -EINVAL;
-	}
-
-	encl->attributes_mask |= SGX_ATTR_PROVISIONKEY;
-
-	fput(file);
-	return 0;
+	return sgx_set_attribute(&encl->attributes_mask, params.fd);
 }
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b95168427056..7105e34da530 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1,14 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
+#include <linux/file.h>
 #include <linux/freezer.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
+#include <linux/miscdevice.h>
 #include <linux/pagemap.h>
 #include <linux/ratelimit.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
+#include <asm/sgx.h>
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
@@ -744,6 +747,51 @@ void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
 		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
 }
 
+const struct file_operations sgx_provision_fops = {
+	.owner			= THIS_MODULE,
+};
+
+static struct miscdevice sgx_dev_provision = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "sgx_provision",
+	.nodename = "sgx_provision",
+	.fops = &sgx_provision_fops,
+};
+
+/**
+ * sgx_set_attribute() - Update allowed attributes given file descriptor
+ * @allowed_attributes:		Pointer to allowed enclave attributes
+ * @attribute_fd:		File descriptor for specific attribute
+ *
+ * Append enclave attribute indicated by file descriptor to allowed
+ * attributes. Currently only SGX_ATTR_PROVISIONKEY indicated by
+ * /dev/sgx_provision is supported.
+ *
+ * Return:
+ * -0:		SGX_ATTR_PROVISIONKEY is appended to allowed_attributes
+ * -EINVAL:	Invalid, or not supported file descriptor
+ */
+int sgx_set_attribute(unsigned long *allowed_attributes,
+		      unsigned int attribute_fd)
+{
+	struct file *file;
+
+	file = fget(attribute_fd);
+	if (!file)
+		return -EINVAL;
+
+	if (file->f_op != &sgx_provision_fops) {
+		fput(file);
+		return -EINVAL;
+	}
+
+	*allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+
+	fput(file);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sgx_set_attribute);
+
 static int __init sgx_init(void)
 {
 	int ret;
@@ -760,6 +808,10 @@ static int __init sgx_init(void)
 		goto err_page_cache;
 	}
 
+	ret = misc_register(&sgx_dev_provision);
+	if (ret)
+		goto err_kthread;
+
 	/*
 	 * Always try to initialize the native *and* KVM drivers.
 	 * The KVM driver is less picky than the native one and
@@ -770,10 +822,13 @@ static int __init sgx_init(void)
 	 */
 	ret = !!sgx_drv_init() & !!sgx_vepc_init();
 	if (ret)
-		goto err_kthread;
+		goto err_provision;
 
 	return 0;
 
+err_provision:
+	misc_deregister(&sgx_dev_provision);
+
 err_kthread:
 	kthread_stop(ksgxd_tsk);
 
-- 
2.30.2

