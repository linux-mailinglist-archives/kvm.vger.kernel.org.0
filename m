Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00548327B33
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 10:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhCAJwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 04:52:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:12503 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234138AbhCAJqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 04:46:30 -0500
IronPort-SDR: u+Iyz5F4rxbYhwnlqGA5xZ1DBOC9Btl4uxH9gh/vSBCunAFv43K39H1hjUpuJsdbZ/wq/LN6+O
 URszKYPvKisQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="173542513"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="173542513"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:45:02 -0800
IronPort-SDR: qsaXeJFpDdhaknOgI3loYPWBacBczDrevzw4dXy8W/ONGZ34QsK3Q9ay0fFTQ9TRVYar/3llD3
 mRPnhiN+kvTQ==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="599267367"
Received: from jscomeax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.139.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:44:58 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH 05/25] x86/sgx: Introduce virtual EPC for use by KVM guests
Date:   Mon,  1 Mar 2021 22:44:32 +1300
Message-Id: <aade4006c3474175f97ec149a969eb02f1720a89.1614590788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614590788.git.kai.huang@intel.com>
References: <cover.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a misc device /dev/sgx_vepc to allow userspace to allocate "raw" EPC
without an associated enclave.  The intended and only known use case for
raw EPC allocation is to expose EPC to a KVM guest, hence the 'vepc'
moniker, virt.{c,h} files and X86_SGX_KVM Kconfig.

SGX driver uses misc device /dev/sgx_enclave to support userspace to
create enclave.  Each file descriptor from opening /dev/sgx_enclave
represents an enclave.  Unlike SGX driver, KVM doesn't control how guest
uses EPC, therefore EPC allocated to KVM guest is not associated to an
enclave, and /dev/sgx_enclave is not suitable for allocating EPC for KVM
guest.

Having separate device nodes for SGX driver and KVM virtual EPC also
allows separate permission control for running host SGX enclaves and
KVM SGX guests.

To use /dev/sgx_vepc to allocate a virtual EPC instance with particular
size, the userspace hypervisor opens /dev/sgx_vepc, and uses mmap()
with the intended size to get an address range of virtual EPC.  Then
it may use the address range to create one KVM memory slot as virtual
EPC for guest.

Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
/dev/sgx_vepc rather than in KVM. Doing so has two major advantages:

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
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/Kconfig                 |  12 ++
 arch/x86/kernel/cpu/sgx/Makefile |   1 +
 arch/x86/kernel/cpu/sgx/sgx.h    |   9 ++
 arch/x86/kernel/cpu/sgx/virt.c   | 260 +++++++++++++++++++++++++++++++
 4 files changed, 282 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/sgx/virt.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2792879d398e..0ea36eedadf0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1941,6 +1941,18 @@ config X86_SGX
 
 	  If unsure, say N.
 
+config X86_SGX_KVM
+	bool "Software Guard eXtensions (SGX) Virtualization"
+	depends on X86_SGX && KVM_INTEL
+	help
+
+	  Enables KVM guests to create SGX enclaves.
+
+	  This includes support to expose "raw" unreclaimable enclave memory to
+	  guests via a device node, e.g. /dev/sgx_vepc.
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 91d3dc784a29..9c1656779b2a 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -3,3 +3,4 @@ obj-y += \
 	encl.o \
 	ioctl.o \
 	main.o
+obj-$(CONFIG_X86_SGX_KVM)	+= virt.o
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5fa42d143feb..1bff93be7bf4 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -83,4 +83,13 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
 
+#ifdef CONFIG_X86_SGX_KVM
+int __init sgx_vepc_init(void);
+#else
+static inline int __init sgx_vepc_init(void)
+{
+	return -ENODEV;
+}
+#endif
+
 #endif /* _X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
new file mode 100644
index 000000000000..d206d81280cf
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Device driver to expose SGX enclave memory to KVM guests.
+ *
+ * Copyright(c) 2021 Intel Corporation.
+ */
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
+
+struct sgx_vepc {
+	struct xarray page_array;
+	struct mutex lock;
+};
+
+/*
+ * Temporary SECS pages that cannot be EREMOVE'd due to having child in other
+ * virtual EPC instances, and the lock to protect it.
+ */
+static struct mutex zombie_secs_pages_lock;
+static struct list_head zombie_secs_pages;
+
+static int __sgx_vepc_fault(struct sgx_vepc *vepc,
+			    struct vm_area_struct *vma, unsigned long addr)
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
+static vm_fault_t sgx_vepc_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct sgx_vepc *vepc = vma->vm_private_data;
+	int ret;
+
+	mutex_lock(&vepc->lock);
+	ret = __sgx_vepc_fault(vepc, vma, vmf->address);
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
+const struct vm_operations_struct sgx_vepc_vm_ops = {
+	.fault = sgx_vepc_fault,
+};
+
+static int sgx_vepc_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct sgx_vepc *vepc = file->private_data;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	vma->vm_ops = &sgx_vepc_vm_ops;
+	/* Don't copy VMA in fork() */
+	vma->vm_flags |= VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY;
+	vma->vm_private_data = vepc;
+
+	return 0;
+}
+
+static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
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
+		 * sgx_vepc_release().
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
+
+	return 0;
+}
+
+static int sgx_vepc_release(struct inode *inode, struct file *file)
+{
+	struct sgx_vepc *vepc = file->private_data;
+	struct sgx_epc_page *epc_page, *tmp, *entry;
+	unsigned long index;
+
+	LIST_HEAD(secs_pages);
+
+	xa_for_each(&vepc->page_array, index, entry) {
+		/*
+		 * Remove all normal, child pages.  sgx_vepc_free_page()
+		 * will fail if EREMOVE fails, but this is OK and expected on
+		 * SECS pages.  Those can only be EREMOVE'd *after* all their
+		 * child pages. Retries below will clean them up.
+		 */
+		if (sgx_vepc_free_page(entry))
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
+		 * An EREMOVE failure here means that the SECS page still
+		 * has children.  But, since all children in this 'sgx_vepc'
+		 * have been removed, the SECS page must have a child on
+		 * another instance.
+		 */
+		if (sgx_vepc_free_page(epc_page))
+			list_add_tail(&epc_page->list, &secs_pages);
+
+		xa_erase(&vepc->page_array, index);
+	}
+
+	/*
+	 * SECS pages are "pinned" by child pages, an unpinned once all
+	 * children have been EREMOVE'd.  A child page in this instance
+	 * may have pinned an SECS page encountered in an earlier release(),
+	 * creating a zombie.  Since some children were EREMOVE'd above,
+	 * try to EREMOVE all zombies in the hopes that one was unpinned.
+	 */
+	mutex_lock(&zombie_secs_pages_lock);
+	list_for_each_entry_safe(epc_page, tmp, &zombie_secs_pages, list) {
+		/*
+		 * Speculatively remove the page from the list of zombies,
+		 * if the page is successfully EREMOVE it will be added to
+		 * the list of free pages.  If EREMOVE fails, throw the page
+		 * on the local list, which will be spliced on at the end.
+		 */
+		list_del(&epc_page->list);
+
+		if (sgx_vepc_free_page(epc_page))
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
+static int sgx_vepc_open(struct inode *inode, struct file *file)
+{
+	struct sgx_vepc *vepc;
+
+	vepc = kzalloc(sizeof(struct sgx_vepc), GFP_KERNEL);
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
+static const struct file_operations sgx_vepc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= sgx_vepc_open,
+	.release	= sgx_vepc_release,
+	.mmap		= sgx_vepc_mmap,
+};
+
+static struct miscdevice sgx_vepc_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "sgx_vepc",
+	.nodename = "sgx_vepc",
+	.fops = &sgx_vepc_fops,
+};
+
+int __init sgx_vepc_init(void)
+{
+	/* SGX virtualization requires KVM to work */
+	if (!boot_cpu_has(X86_FEATURE_VMX))
+		return -ENODEV;
+
+	INIT_LIST_HEAD(&zombie_secs_pages);
+	mutex_init(&zombie_secs_pages_lock);
+
+	return misc_register(&sgx_vepc_dev);
+}
-- 
2.29.2

