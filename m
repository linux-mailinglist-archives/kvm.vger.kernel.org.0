Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A26327B1D
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 10:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhCAJs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 04:48:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:63206 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234153AbhCAJqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 04:46:51 -0500
IronPort-SDR: sU1wdtHHSKrIT88s4jI1dC0jd/jNZF2IKZLHLcpsG3AKySl8L/3287czgMV88jehL5a0vU1+fh
 8+LF3cCOX81A==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="183012448"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="183012448"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:45:57 -0800
IronPort-SDR: WlvztwN9VSSqVqjLtKldWKorYVt0/S6IfjP7DOPHNdWDGf/pRgLFnIs/xuow1tOPjqeJ7EeEne
 n/LUe8B+oWBw==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="599267550"
Received: from jscomeax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.139.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:45:53 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH 14/25] x86/sgx: Move provisioning device creation out of SGX driver
Date:   Mon,  1 Mar 2021 22:45:14 +1300
Message-Id: <4002e29a139e3edd63f3ff65af08de1a2944e57f.1614590788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614590788.git.kai.huang@intel.com>
References: <cover.1614590788.git.kai.huang@intel.com>
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
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx.h       |  3 ++
 arch/x86/kernel/cpu/sgx/driver.c | 17 ----------
 arch/x86/kernel/cpu/sgx/ioctl.c  | 16 ++-------
 arch/x86/kernel/cpu/sgx/main.c   | 57 +++++++++++++++++++++++++++++++-
 4 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index d2e1f9a6dd4d..c20df3b37f6c 100644
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
index 1bae754268d1..4714de12422d 100644
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
index 276220d0e4b5..c70bcdb9ef14 100644
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
@@ -711,6 +714,51 @@ void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
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
+ * @allowed_attributes: 	Pointer to allowed enclave attributes
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
@@ -727,6 +775,10 @@ static int __init sgx_init(void)
 		goto err_page_cache;
 	}
 
+	ret = misc_register(&sgx_dev_provision);
+	if (ret)
+		goto err_kthread;
+
 	/*
 	 * Always try to initialize the native *and* KVM drivers.
 	 * The KVM driver is less picky than the native one and
@@ -737,10 +789,13 @@ static int __init sgx_init(void)
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
2.29.2

