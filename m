Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0477770B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfG0Fxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:53:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfG0FwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568589"
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
Subject: [RFC PATCH 04/21] x86/sgx: Add /dev/sgx/virt_epc device to allocate "raw" EPC for VMs
Date:   Fri, 26 Jul 2019 22:51:57 -0700
Message-Id: <20190727055214.9282-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an SGX device to enable userspace to allocate EPC without an
associated enclave.  The intended and only known use case for direct EPC
allocation is to expose EPC to a KVM guest, hence the virt_epc moniker,
virt.{c,h} files and INTEL_SGX_VIRTUALIZATION Kconfig.

Although KVM is the end consumer of EPC, and will need hooks into the
virtual EPC management if oversubscription of EPC for guest is ever
supported (see below), implement direct access to EPC in the SGX
subsystem instead of in KVM.  Doing so has two major advantages:

  - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
    just another memory backend for guests.

  - EPC management is wholly contained in the SGX subsystem, e.g. SGX
    does not have to export any symbols, changes to reclaim flows don't
    need to be routed through KVM, SGX's dirty laundry doesn't have to
    get aired out for the world to see, and so on and so forth.

Oversubscription of EPC for KVM guests is not currently supported.  Due
to the complications of handling reclaim conflicts between guest and
host, KVM EPC oversubscription is expected to be at least an order of
magnitude more complex than basic support for SGX virtualization.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/Kconfig                 |  10 ++
 arch/x86/kernel/cpu/sgx/Makefile |   1 +
 arch/x86/kernel/cpu/sgx/main.c   |   3 +
 arch/x86/kernel/cpu/sgx/sgx.h    |   3 +-
 arch/x86/kernel/cpu/sgx/virt.c   | 253 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/virt.h   |  14 ++
 6 files changed, 283 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
 create mode 100644 arch/x86/kernel/cpu/sgx/virt.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 74ccb1bdea16..c1bdb9f85928 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1961,6 +1961,16 @@ config INTEL_SGX_DRIVER
 
 	  If unsure, say N.
 
+config INTEL_SGX_VIRTUALIZATION
+	bool "Intel SGX Virtualization"
+	depends on INTEL_SGX && KVM_INTEL
+	help
+	  Enabling support for SGX virtualization enables userspace to allocate
+	  "raw" EPC for the purpose of exposing EPC to a KVM guest, i.e. a
+	  virtual machine, via a device node (/dev/sgx/virt_epc by default).
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index e5d1e862969c..559fd0f9be50 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,2 +1,3 @@
 obj-y += encl.o encls.o main.o reclaim.o
 obj-$(CONFIG_INTEL_SGX_DRIVER) += driver/
+obj-$(CONFIG_INTEL_SGX_VIRTUALIZATION) += virt.o
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 9f4473597620..ead827371139 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -14,6 +14,7 @@
 #include "arch.h"
 #include "encls.h"
 #include "sgx.h"
+#include "virt.h"
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
@@ -422,7 +423,9 @@ static __init int sgx_init(void)
 	if (ret)
 		goto err_provision_dev;
 
+	/* Success if the native *or* virtual driver initialized cleanly. */
 	ret = sgx_drv_init();
+	ret = sgx_virt_epc_init() ? ret : 0;
 	if (ret)
 		goto err_provision_cdev;
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index a0af8849c7c3..16cdb935aaa7 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -91,7 +91,8 @@ int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 
 #define SGX_ENCL_DEV_MINOR	0
 #define SGX_PROV_DEV_MINOR	1
-#define SGX_MAX_NR_DEVICES	2
+#define SGX_VIRT_DEV_MINOR	2
+#define SGX_MAX_NR_DEVICES	3
 
 __init int sgx_dev_init(const char *name, struct device *dev,
 			struct cdev *cdev, const struct file_operations *fops,
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
new file mode 100644
index 000000000000..79ee5917a4fc
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/cdev.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include <uapi/asm/sgx.h>
+
+#include "encls.h"
+#include "sgx.h"
+#include "virt.h"
+
+struct sgx_virt_epc_page {
+	struct sgx_epc_page *epc_page;
+};
+
+struct sgx_virt_epc {
+	struct radix_tree_root page_tree;
+	struct rw_semaphore lock;
+};
+
+static inline unsigned long sgx_virt_epc_calc_index(struct vm_area_struct *vma,
+						    unsigned long addr)
+{
+	return vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
+}
+
+static struct sgx_virt_epc_page *__sgx_virt_epc_fault(struct sgx_virt_epc *epc,
+						      struct vm_area_struct *vma,
+						      unsigned long addr)
+{
+	struct sgx_virt_epc_page *page;
+	struct sgx_epc_page *epc_page;
+	unsigned long index;
+	int ret;
+
+	index = sgx_virt_epc_calc_index(vma, addr);
+
+	page = radix_tree_lookup(&epc->page_tree, index);
+	if (page) {
+		if (page->epc_page)
+			return page;
+	} else {
+		page = kzalloc(sizeof(*page), GFP_KERNEL);
+		if (!page)
+			return ERR_PTR(-ENOMEM);
+
+		ret = radix_tree_insert(&epc->page_tree, index, page);
+		if (unlikely(ret)) {
+			kfree(page);
+			return ERR_PTR(ret);
+		}
+	}
+
+	epc_page = sgx_alloc_page(&epc, false);
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
+
+	ret = vmf_insert_pfn(vma, addr, PFN_DOWN(epc_page->desc));
+	if (unlikely(ret != VM_FAULT_NOPAGE)) {
+		sgx_free_page(epc_page);
+		return ERR_PTR(-EFAULT);
+	}
+
+	page->epc_page = epc_page;
+
+	return page;
+}
+
+static vm_fault_t sgx_virt_epc_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct sgx_virt_epc *epc = (struct sgx_virt_epc *)vma->vm_private_data;
+	struct sgx_virt_epc_page *page;
+
+	down_write(&epc->lock);
+	page = __sgx_virt_epc_fault(epc, vma, vmf->address);
+	up_write(&epc->lock);
+
+	if (!IS_ERR(page) || signal_pending(current))
+		return VM_FAULT_NOPAGE;
+
+	if (PTR_ERR(page) == -EBUSY && (vmf->flags & FAULT_FLAG_ALLOW_RETRY)) {
+		up_read(&vma->vm_mm->mmap_sem);
+		return VM_FAULT_RETRY;
+	}
+
+	return VM_FAULT_SIGBUS;
+}
+
+static struct sgx_virt_epc_page *sgx_virt_epc_get_page(struct sgx_virt_epc *epc,
+						       unsigned long index)
+{
+	struct sgx_virt_epc_page *page;
+
+	down_read(&epc->lock);
+	page = radix_tree_lookup(&epc->page_tree, index);
+	if (!page || !page->epc_page)
+		page = ERR_PTR(-EFAULT);
+	up_read(&epc->lock);
+
+	return page;
+}
+
+static int sgx_virt_epc_access(struct vm_area_struct *vma, unsigned long start,
+			       void *buf, int len, int write)
+{
+	/* EDBG{RD,WR} are naturally sized, i.e. always 8-byte on 64-bit. */
+	unsigned char data[sizeof(unsigned long)];
+	struct sgx_virt_epc_page *page;
+	struct sgx_virt_epc *epc;
+	unsigned long addr, index;
+	int offset, cnt, i;
+	int ret = 0;
+	void *p;
+
+	epc = vma->vm_private_data;
+
+	for (i = 0; i < len && !ret; i += cnt) {
+		addr = start + i;
+		if (i == 0 || PFN_DOWN(addr) != PFN_DOWN(addr - cnt))
+			index = sgx_virt_epc_calc_index(vma, addr);
+
+		page = sgx_virt_epc_get_page(epc, index);
+
+		/*
+		 * EDBG{RD,WR} require an active enclave, and given that VMM
+		 * EPC oversubscription isn't supported, a not-present EPC page
+		 * means the guest hasn't accessed the page and therefore can't
+		 * possibility have added the page to an enclave.
+		 */
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+
+		offset = addr & (sizeof(unsigned long) - 1);
+		addr = ALIGN_DOWN(addr, sizeof(unsigned long));
+		cnt = min((int)sizeof(unsigned long) - offset, len - i);
+
+		p = sgx_epc_addr(page->epc_page) + (addr & ~PAGE_MASK);
+
+		/* EDBGRD for read, or to do RMW for a partial write. */
+		if (!write || cnt != sizeof(unsigned long))
+			ret = __edbgrd(p, (void *)data);
+
+		if (!ret) {
+			if (write) {
+				memcpy(data + offset, buf + i, cnt);
+				ret = __edbgwr(p, (void *)data);
+			} else {
+				memcpy(buf + i, data + offset, cnt);
+			}
+		}
+	}
+
+	if (ret)
+		return -EIO;
+	return i;
+}
+
+const struct vm_operations_struct sgx_virt_epc_vm_ops = {
+	.fault = sgx_virt_epc_fault,
+	.access = sgx_virt_epc_access,
+};
+
+static int sgx_virt_epc_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	vma->vm_ops = &sgx_virt_epc_vm_ops;
+	vma->vm_flags |= VM_PFNMAP | VM_IO | VM_DONTDUMP;
+	vma->vm_private_data = file->private_data;
+
+	return 0;
+}
+
+static int sgx_virt_epc_release(struct inode *inode, struct file *file)
+{
+	struct sgx_virt_epc *epc = file->private_data;
+	struct radix_tree_iter iter;
+	struct sgx_virt_epc_page *page;
+	void **slot;
+
+	LIST_HEAD(secs_pages);
+
+	radix_tree_for_each_slot(slot, &epc->page_tree, &iter, 0) {
+		page = *slot;
+		if (page->epc_page && __sgx_free_page(page->epc_page))
+			continue;
+		kfree(page);
+		radix_tree_delete(&epc->page_tree, iter.index);
+	}
+
+	/*
+	 * Because we don't track which pages are SECS pages, it's possible
+	 * for EREMOVE to fail, e.g. a SECS page can have children if a VM
+	 * shutdown unexpectedly.  Retry all failed pages after iterating
+	 * through the entire tree, at which point all children should be
+	 * removed and the SECS pages can be nuked as well.
+	 */
+	radix_tree_for_each_slot(slot, &epc->page_tree, &iter, 0) {
+		page = *slot;
+		if (!(WARN_ON(!page->epc_page)))
+			sgx_free_page(page->epc_page);
+		radix_tree_delete(&epc->page_tree, iter.index);
+	}
+
+	kfree(epc);
+
+	return 0;
+}
+
+static int sgx_virt_epc_open(struct inode *inode, struct file *file)
+{
+	struct sgx_virt_epc *epc;
+
+	epc = kzalloc(sizeof(struct sgx_virt_epc), GFP_KERNEL);
+	if (!epc)
+		return -ENOMEM;
+
+	init_rwsem(&epc->lock);
+	INIT_RADIX_TREE(&epc->page_tree, GFP_KERNEL);
+
+	file->private_data = epc;
+
+	return 0;
+}
+
+static const struct file_operations sgx_virt_epc_fops = {
+	.owner			= THIS_MODULE,
+	.open			= sgx_virt_epc_open,
+	.release		= sgx_virt_epc_release,
+	.mmap			= sgx_virt_epc_mmap,
+};
+
+static struct device sgx_virt_epc_dev;
+static struct cdev sgx_virt_epc_cdev;
+
+int __init sgx_virt_epc_init(void)
+{
+	int ret = sgx_dev_init("sgx/virt_epc", &sgx_virt_epc_dev,
+			       &sgx_virt_epc_cdev, &sgx_virt_epc_fops,
+			       SGX_VIRT_DEV_MINOR);
+	if (ret)
+		return ret;
+
+	ret = cdev_device_add(&sgx_virt_epc_cdev, &sgx_virt_epc_dev);
+	if (ret)
+		put_device(&sgx_virt_epc_dev);
+
+	return ret;
+}
diff --git a/arch/x86/kernel/cpu/sgx/virt.h b/arch/x86/kernel/cpu/sgx/virt.h
new file mode 100644
index 000000000000..436170412b98
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/virt.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+#ifndef _ASM_X86_SGX_VIRT_H
+#define _ASM_X86_SGX_VIRT_H
+
+#ifdef CONFIG_INTEL_SGX_VIRTUALIZATION
+int __init sgx_virt_epc_init(void);
+#else
+static inline int __init sgx_virt_epc_init(void)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif /* _ASM_X86_SGX_VIRT_H */
-- 
2.22.0

