Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8702F9836
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbhARD2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:28:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:9514 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731605AbhARD2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:28:04 -0500
IronPort-SDR: CzKLVfmZ2xUGbPb7WuaMHOOmiUmXqEHpyOixKU6tSmWe6zRLhoxp4ulow4XWdNLEAylucP1t/8
 zrDRTRS0cmKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="177975338"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="177975338"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:19 -0800
IronPort-SDR: U76wVg0niVgY7p83fW92SavU79ReJSD4naWRSJeC5VtSdCyYrQyDAUN0v0rBG9849P3Dxkf6YJ
 dQSyTY3XDVBw==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150749"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:15 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 05/26] x86/sgx: Introduce virtual EPC for use by KVM guests
Date:   Mon, 18 Jan 2021 16:26:53 +1300
Message-Id: <4597db567351468c360fc810fff5a8232cb96c4c.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
EPC without an associated enclave.  The intended and only known use case
for raw EPC allocation is to expose EPC to a KVM guest, hence the
virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.

More specifically, to allocate a virtual EPC instance with particular
size, the userspace hypervisor opens the device node, and uses mmap()
with the intended size to get an address range of virtual EPC.  Then
it may use the address range to create one KVM memory slot as virtual
EPC for guest.

Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
/dev/sgx_virt_epc rather than in KVM. Doing so has two major advantages:

  - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
    just another memory backend for guests.

  - EPC management is wholly contained in the SGX subsystem, e.g. SGX
    does not have to export any symbols, changes to reclaim flows don't
    need to be routed through KVM, SGX's dirty laundry doesn't have to
    get aired out for the world to see, and so on and so forth.

The virtual EPC pages allocated to guests are currently not reclaimable.
Reclaiming EPC page used by enclave requires a special reclaim mechanism
separate from normal page reclaim, and that mechanism is not supported
for virutal EPC pages.  Due to the complications of handling reclaim
conflicts between guest and host, reclaiming virtual EPC pages is
significantly more complex than basic support for SGX virtualization.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Added one paragraph to explain fops of virtual EPC, per Jarkko's suggestion.
 - Moved change to sgx_init() out of this patch to a separate patch, as stated
   in cover letter.
 - In sgx_virt_epc_init(), return error if VMX is not supported, or
   CONFIG_KVM_INTEL is not enabled, because there's no point to create
   /dev/sgx_virt_epc if KVM is not supported.
 - Removed 'struct mm_struct *mm' in 'struct sgx_virt_epc', and related logic in
   sgx_virt_epc_open/release/mmap(), per Dave's comment.
 - Renamed 'virtual_epc_zombie_pages' and 'virt_epc_lock' to 'zombie_secs_pages'
   'zombie_secs_pages_lock', per Dave's suggestion.
 - Changed __sgx_free_epc_page() to sgx_free_epc_page() due to Jarkko's patch
   removes EREMOVE in sgx_free_epc_page().
 - Changed all struct sgx_virt_epc *epc to struct sgx_virt_epc *vepc.
 - In __sgx_virt_epc_fault(), changed comment to use WARN_ON() to make sure
   vepc->lock has already been hold, per Dave's suggestion.
 - In sgx_virt_epc_free_page(), added comments to explain SGX_ENCLAVE_ACT is not
   expected; and changed to use WARN_ONCE() to dump actual error code, per
   Dave's comment.
 - Removed NULL page check in sgx_virt_epc_free_page(), per Dave's comment.

---
 arch/x86/Kconfig                 |  12 ++
 arch/x86/kernel/cpu/sgx/Makefile |   1 +
 arch/x86/kernel/cpu/sgx/virt.c   | 255 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/virt.h   |  14 ++
 4 files changed, 282 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
 create mode 100644 arch/x86/kernel/cpu/sgx/virt.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 21f851179ff0..d089ddf01846 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1951,6 +1951,18 @@ config X86_SGX
 
 	  If unsure, say N.
 
+config X86_SGX_VIRTUALIZATION
+	bool "Software Guard eXtensions (SGX) Virtualization"
+	depends on X86_SGX && KVM_INTEL
+	help
+
+	  Enables KVM guests to create SGX enclaves.
+
+	  This includes support to expose "raw" unreclaimable enclave memory to
+	  guests via a device node, e.g. /dev/sgx_virt_epc.
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 91d3dc784a29..7a25bf63adfb 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -3,3 +3,4 @@ obj-y += \
 	encl.o \
 	ioctl.o \
 	main.o
+obj-$(CONFIG_X86_SGX_VIRTUALIZATION)	+= virt.o
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
new file mode 100644
index 000000000000..1e8620f20651
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2016-20 Intel Corporation. */
+
+#define pr_fmt(fmt)	"SGX virtual EPC: " fmt
+
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/sched/mm.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include <asm/sgx.h>
+#include <uapi/asm/sgx.h>
+
+#include "encls.h"
+#include "sgx.h"
+#include "virt.h"
+
+struct sgx_virt_epc {
+	struct xarray page_array;
+	struct mutex lock;
+};
+
+static struct mutex zombie_secs_pages_lock;
+static struct list_head zombie_secs_pages;
+
+static int __sgx_virt_epc_fault(struct sgx_virt_epc *vepc,
+				struct vm_area_struct *vma, unsigned long addr)
+{
+	struct sgx_epc_page *epc_page;
+	unsigned long index, pfn;
+	int ret;
+
+	WARN_ON(!mutex_is_locked(&vepc->lock));
+
+	/* Calculate index of EPC page in virtual EPC's page_array */
+	index = vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
+
+	epc_page = xa_load(&vepc->page_array, index);
+	if (epc_page)
+		return 0;
+
+	epc_page = sgx_alloc_epc_page(vepc, false);
+	if (IS_ERR(epc_page))
+		return PTR_ERR(epc_page);
+
+	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
+	if (ret)
+		goto err_free;
+
+	pfn = PFN_DOWN(sgx_get_epc_phys_addr(epc_page));
+
+	ret = vmf_insert_pfn(vma, addr, pfn);
+	if (ret != VM_FAULT_NOPAGE) {
+		ret = -EFAULT;
+		goto err_delete;
+	}
+
+	return 0;
+
+err_delete:
+	xa_erase(&vepc->page_array, index);
+err_free:
+	sgx_free_epc_page(epc_page);
+	return ret;
+}
+
+static vm_fault_t sgx_virt_epc_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct sgx_virt_epc *vepc = vma->vm_private_data;
+	int ret;
+
+	mutex_lock(&vepc->lock);
+	ret = __sgx_virt_epc_fault(vepc, vma, vmf->address);
+	mutex_unlock(&vepc->lock);
+
+	if (!ret)
+		return VM_FAULT_NOPAGE;
+
+	if (ret == -EBUSY && (vmf->flags & FAULT_FLAG_ALLOW_RETRY)) {
+		mmap_read_unlock(vma->vm_mm);
+		return VM_FAULT_RETRY;
+	}
+
+	return VM_FAULT_SIGBUS;
+}
+
+const struct vm_operations_struct sgx_virt_epc_vm_ops = {
+	.fault = sgx_virt_epc_fault,
+};
+
+static int sgx_virt_epc_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct sgx_virt_epc *vepc = file->private_data;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	vma->vm_ops = &sgx_virt_epc_vm_ops;
+	/* Don't copy VMA in fork() */
+	vma->vm_flags |= VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY;
+	vma->vm_private_data = vepc;
+
+	return 0;
+}
+
+static int sgx_virt_epc_free_page(struct sgx_epc_page *epc_page)
+{
+	int ret;
+
+	/*
+	 * Take a previously guest-owned EPC page and return it to the
+	 * general EPC page pool.
+	 *
+	 * Guests can not be trusted to have left this page in a good
+	 * state, so run EREMOVE on the page unconditionally.  In the
+	 * case that a guest properly EREMOVE'd this page, a superfluous
+	 * EREMOVE is harmless.
+	 */
+	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
+	if (ret) {
+		/*
+		 * Only SGX_CHILD_PRESENT is expected, which is because of
+		 * EREMOVE'ing an SECS still with child, in which case it can
+		 * be handled by EREMOVE'ing the SECS again after all pages in
+		 * virtual EPC have been EREMOVE'd. See comments in below in
+		 * sgx_virt_epc_release().
+		 *
+		 * The user of virtual EPC (KVM) needs to guarantee there's no
+		 * logical processor is still running in the enclave in guest,
+		 * otherwise EREMOVE will get SGX_ENCLAVE_ACT which cannot be
+		 * handled here.
+		 */
+		WARN_ONCE(ret != SGX_CHILD_PRESENT,
+			  "EREMOVE (EPC page 0x%lx): unexpected error: %d\n",
+			  sgx_get_epc_phys_addr(epc_page), ret);
+		return ret;
+	}
+
+	sgx_free_epc_page(epc_page);
+	return 0;
+}
+
+static int sgx_virt_epc_release(struct inode *inode, struct file *file)
+{
+	struct sgx_virt_epc *vepc = file->private_data;
+	struct sgx_epc_page *epc_page, *tmp, *entry;
+	unsigned long index;
+
+	LIST_HEAD(secs_pages);
+
+	xa_for_each(&vepc->page_array, index, entry) {
+		/*
+		 * Remove all normal, child pages.  sgx_virt_epc_free_page()
+		 * will fail if EREMOVE fails, but this is OK and expected on
+		 * SECS pages.  Those can only be EREMOVE'd *after* all their
+		 * child pages. Retries below will clean them up.
+		 */
+		if (sgx_virt_epc_free_page(entry))
+			continue;
+
+		xa_erase(&vepc->page_array, index);
+	}
+
+	/*
+	 * Retry EREMOVE'ing pages.  This will clean up any SECS pages that
+	 * only had children in this 'epc' area.
+	 */
+	xa_for_each(&vepc->page_array, index, entry) {
+		epc_page = entry;
+		/*
+		 * An EREMOVE failure here means that the SECS page
+		 * still has children.  But, since all children in this
+		 * 'sgx_virt_epc' have been removed, the SECS page must
+		 * have a child on another instance.
+		 */
+		if (sgx_virt_epc_free_page(epc_page))
+			list_add_tail(&epc_page->list, &secs_pages);
+
+		xa_erase(&vepc->page_array, index);
+	}
+
+	/*
+	 * SECS pages are "pinned" by child pages, an unpinned once all
+	 * children have been EREMOVE'd.  A child page in this instance
+	 * may have pinned an SECS page encountered in an earlier
+	 * release(), creating a zombie.  Since some children were
+	 * EREMOVE'd above, try to EREMOVE all zombies in the hopes that
+	 * one was unpinned.
+	 */
+	mutex_lock(&zombie_secs_pages_lock);
+	list_for_each_entry_safe(epc_page, tmp, &zombie_secs_pages, list) {
+		/*
+		 * Speculatively remove the page from the list of zombies, if
+		 * the page is successfully EREMOVE it will be added to the
+		 * list of free pages.  If EREMOVE fails, throw the page on the
+		 * local list, which will be spliced on at the end.
+		 */
+		list_del(&epc_page->list);
+
+		if (sgx_virt_epc_free_page(epc_page))
+			list_add_tail(&epc_page->list, &secs_pages);
+	}
+
+	if (!list_empty(&secs_pages))
+		list_splice_tail(&secs_pages, &zombie_secs_pages);
+	mutex_unlock(&zombie_secs_pages_lock);
+
+	kfree(vepc);
+
+	return 0;
+}
+
+static int sgx_virt_epc_open(struct inode *inode, struct file *file)
+{
+	struct sgx_virt_epc *vepc;
+
+	vepc = kzalloc(sizeof(struct sgx_virt_epc), GFP_KERNEL);
+	if (!vepc)
+		return -ENOMEM;
+	mutex_init(&vepc->lock);
+	xa_init(&vepc->page_array);
+
+	file->private_data = vepc;
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
+static struct miscdevice sgx_virt_epc_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "sgx_virt_epc",
+	.nodename = "sgx_virt_epc",
+	.fops = &sgx_virt_epc_fops,
+};
+
+int __init sgx_virt_epc_init(void)
+{
+	/* SGX virtualization requires KVM to work */
+	if (!boot_cpu_has(X86_FEATURE_VMX) || !IS_ENABLED(CONFIG_KVM_INTEL))
+		return -ENODEV;
+
+	INIT_LIST_HEAD(&zombie_secs_pages);
+	mutex_init(&zombie_secs_pages_lock);
+
+	return misc_register(&sgx_virt_epc_dev);
+}
diff --git a/arch/x86/kernel/cpu/sgx/virt.h b/arch/x86/kernel/cpu/sgx/virt.h
new file mode 100644
index 000000000000..e5434541a122
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/virt.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+#ifndef _ASM_X86_SGX_VIRT_H
+#define _ASM_X86_SGX_VIRT_H
+
+#ifdef CONFIG_X86_SGX_VIRTUALIZATION
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
2.29.2

