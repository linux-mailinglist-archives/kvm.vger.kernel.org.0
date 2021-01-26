Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DCB30429A
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 16:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392794AbhAZPaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 10:30:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:12818 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389512AbhAZJdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:33:22 -0500
IronPort-SDR: nd/a1V5NlB/V1yBbIKSLDRnIhg+1E//MaWgf+/TNK9XjHVQF2JqqwJc3qmTS61inPMYGke+tv4
 5cvank8aBf6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179954938"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179954938"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:47 -0800
IronPort-SDR: 83M/5GnzLUTzFTGcPLmOZ2beRg+rwVdvs0dneMRkKimHwa01YSpvAJoSUaUw6w752zx7Id1OAH
 izfZ3Spl+rjw==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747767"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:43 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 15/27] x86/sgx: Move provisioning device creation out of SGX driver
Date:   Tue, 26 Jan 2021 22:31:07 +1300
Message-Id: <aa622fdace4bfdaeae9f39530de771127bfb91c5.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
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
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v2->v3:

 - Added kdoc for sgx_set_attribute(), per Jarkko.

---
 arch/x86/include/asm/sgx.h       |  3 ++
 arch/x86/kernel/cpu/sgx/driver.c | 17 ----------
 arch/x86/kernel/cpu/sgx/ioctl.c  | 16 ++-------
 arch/x86/kernel/cpu/sgx/main.c   | 58 +++++++++++++++++++++++++++++++-
 4 files changed, 62 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 8a3ea3e1efbe..d67afb051db3 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -4,6 +4,9 @@
 
 #include <linux/types.h>
 
+int sgx_set_attribute(unsigned long *allowed_attributes,
+		      unsigned int attribute_fd);
+
 #ifdef CONFIG_X86_SGX_KVM
 struct sgx_pageinfo;
 
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f2eac41bb4ff..4f3241109bda 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -133,10 +133,6 @@ static const struct file_operations sgx_encl_fops = {
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
-const struct file_operations sgx_provision_fops = {
-	.owner			= THIS_MODULE,
-};
-
 static struct miscdevice sgx_dev_enclave = {
 	.minor = MISC_DYNAMIC_MINOR,
 	.name = "sgx_enclave",
@@ -144,13 +140,6 @@ static struct miscdevice sgx_dev_enclave = {
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
@@ -184,11 +173,5 @@ int __init sgx_drv_init(void)
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
index b456899a9532..fba3eaf2ae26 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1,14 +1,18 @@
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
+#include <asm/sgx_arch.h>
+#include <asm/sgx.h>
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
@@ -712,6 +716,51 @@ void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
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
@@ -728,13 +777,20 @@ static int __init sgx_init(void)
 		goto err_page_cache;
 	}
 
+	ret = misc_register(&sgx_dev_provision);
+	if (ret)
+		goto err_kthread;
+
 	/* Success if the native *or* virtual EPC driver initialized cleanly. */
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

