Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC33096B2
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 17:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhA3QYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 11:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhA3OmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 09:42:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BC3164E0F;
        Sat, 30 Jan 2021 14:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612017680;
        bh=FHWp0ZsnkeE/SCgjm4BWBG9iO3R5Tce7agUrvcVpBIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S9H1nFwH2m0JtsYmg09xdxhirPDrIX8iSFlfiOs0OlAb9sPbRY5TT7tPvFhNWMGIh
         g/7vY5dEbU7meUg1UMuygcIjSKPV7zPSu51WGNmIvBSiO8eWulnzW6K0icSEvrm5J2
         2AEbmdNY2KI3bgacRYmPuVbXxScoudh/GmycIi6hB/m/uDKTvzWszdXLDXuF9FaZmk
         RcS5zXZz+YiLQqK6NlU3ERIAOuhBISjUoRIy+xPwiLRa34ATE1vQR6sQODI8X15LAV
         +fF0gv3GR2uW6c/C0u5HJ0mfHhqOjE8ivSRqIFUtogOg+XW2Si2c4acg2eVuG229w6
         BvrCu0EvuZHmQ==
Date:   Sat, 30 Jan 2021 16:41:16 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 06/27] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YBVwDAOYfsDFZ1CY@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <8492ee41e947aa8151007e5ecbd9ef8914dd8827.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8492ee41e947aa8151007e5ecbd9ef8914dd8827.1611634586.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 10:30:21PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a misc device /dev/sgx_vepc to allow userspace to allocate "raw" EPC
> without an associated enclave.  The intended and only known use case for
> raw EPC allocation is to expose EPC to a KVM guest, hence the 'vepc'
> moniker, virt.{c,h} files and X86_SGX_KVM Kconfig.
> 
> More specifically, to allocate a virtual EPC instance with particular
> size, the userspace hypervisor opens the device node, and uses mmap()
> with the intended size to get an address range of virtual EPC.  Then
> it may use the address range to create one KVM memory slot as virtual
> EPC for guest.
> 
> Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> /dev/sgx_vepc rather than in KVM. Doing so has two major advantages:
> 
>   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
>     just another memory backend for guests.
> 
>   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
>     does not have to export any symbols, changes to reclaim flows don't
>     need to be routed through KVM, SGX's dirty laundry doesn't have to
>     get aired out for the world to see, and so on and so forth.
> 
> The virtual EPC pages allocated to guests are currently not reclaimable.
> Reclaiming EPC page used by enclave requires a special reclaim mechanism
> separate from normal page reclaim, and that mechanism is not supported
> for virutal EPC pages.  Due to the complications of handling reclaim
> conflicts between guest and host, reclaiming virtual EPC pages is
> significantly more complex than basic support for SGX virtualization.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v2->v3:
> 
>  - Changed from /dev/sgx_virt_epc to /dev/sgx_vepc, per Jarkko. Accordingly,
>    renamed 'sgx_virt_epc_xx' to 'sgx_vepc_xx' for various functions and
>    structrues.
>  - Changed CONFIG_X86_SGX_VIRTUALIZATION to CONFIG_X86_SGX_KVM, per Dave.
> 
> v1->v2:
> 
>  - Added one paragraph to explain fops of virtual EPC, per Jarkko's suggestion.
>  - Moved change to sgx_init() out of this patch to a separate patch, as stated
>    in cover letter.
>  - In sgx_virt_epc_init(), return error if VMX is not supported, or
>    CONFIG_KVM_INTEL is not enabled, because there's no point to create
>    /dev/sgx_virt_epc if KVM is not supported.
>  - Removed 'struct mm_struct *mm' in 'struct sgx_virt_epc', and related logic in
>    sgx_virt_epc_open/release/mmap(), per Dave's comment.
>  - Renamed 'virtual_epc_zombie_pages' and 'virt_epc_lock' to 'zombie_secs_pages'
>    'zombie_secs_pages_lock', per Dave's suggestion.
>  - Changed __sgx_free_epc_page() to sgx_free_epc_page() due to Jarkko's patch
>    removes EREMOVE in sgx_free_epc_page().
>  - Changed all struct sgx_virt_epc *epc to struct sgx_virt_epc *vepc.
>  - In __sgx_virt_epc_fault(), changed comment to use WARN_ON() to make sure
>    vepc->lock has already been hold, per Dave's suggestion.
>  - In sgx_virt_epc_free_page(), added comments to explain SGX_ENCLAVE_ACT is not
>    expected; and changed to use WARN_ONCE() to dump actual error code, per
>    Dave's comment.
>  - Removed NULL page check in sgx_virt_epc_free_page(), per Dave's comment.
> 
> ---
>  arch/x86/Kconfig                 |  12 ++
>  arch/x86/kernel/cpu/sgx/Makefile |   1 +
>  arch/x86/kernel/cpu/sgx/virt.c   | 254 +++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/virt.h   |  14 ++
>  4 files changed, 281 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/virt.h
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 21f851179ff0..ccb35d14c297 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1951,6 +1951,18 @@ config X86_SGX
>  
>  	  If unsure, say N.
>  
> +config X86_SGX_KVM
> +	bool "Software Guard eXtensions (SGX) Virtualization"
> +	depends on X86_SGX && KVM_INTEL
> +	help
> +
> +	  Enables KVM guests to create SGX enclaves.
> +
> +	  This includes support to expose "raw" unreclaimable enclave memory to
> +	  guests via a device node, e.g. /dev/sgx_vepc.
> +
> +	  If unsure, say N.
> +
>  config EFI
>  	bool "EFI runtime service support"
>  	depends on ACPI
> diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> index 91d3dc784a29..9c1656779b2a 100644
> --- a/arch/x86/kernel/cpu/sgx/Makefile
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -3,3 +3,4 @@ obj-y += \
>  	encl.o \
>  	ioctl.o \
>  	main.o
> +obj-$(CONFIG_X86_SGX_KVM)	+= virt.o
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> new file mode 100644
> index 000000000000..e1ad7856d878
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -0,0 +1,254 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*  Copyright(c) 2016-20 Intel Corporation. */
> +
> +#define pr_fmt(fmt)	"SGX virtual EPC: " fmt

Remove this. It's fine to use "sgx:" also for these messages and
easens grepping.

> +
> +#include <linux/miscdevice.h>
> +#include <linux/mm.h>
> +#include <linux/mman.h>
> +#include <linux/sched/mm.h>
> +#include <linux/sched/signal.h>
> +#include <linux/slab.h>
> +#include <linux/xarray.h>
> +#include <asm/sgx.h>
> +#include <uapi/asm/sgx.h>
> +
> +#include "encls.h"
> +#include "sgx.h"
> +#include "virt.h"
> +
> +struct sgx_vepc {
> +	struct xarray page_array;
> +	struct mutex lock;
> +};
> +
> +static struct mutex zombie_secs_pages_lock;
> +static struct list_head zombie_secs_pages;
> +
> +static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> +			    struct vm_area_struct *vma, unsigned long addr)
> +{
> +	struct sgx_epc_page *epc_page;
> +	unsigned long index, pfn;
> +	int ret;
> +
> +	WARN_ON(!mutex_is_locked(&vepc->lock));
> +
> +	/* Calculate index of EPC page in virtual EPC's page_array */
> +	index = vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
> +
> +	epc_page = xa_load(&vepc->page_array, index);
> +	if (epc_page)
> +		return 0;
> +
> +	epc_page = sgx_alloc_epc_page(vepc, false);
> +	if (IS_ERR(epc_page))
> +		return PTR_ERR(epc_page);
> +
> +	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
> +	if (ret)
> +		goto err_free;
> +
> +	pfn = PFN_DOWN(sgx_get_epc_phys_addr(epc_page));
> +
> +	ret = vmf_insert_pfn(vma, addr, pfn);
> +	if (ret != VM_FAULT_NOPAGE) {
> +		ret = -EFAULT;
> +		goto err_delete;
> +	}
> +
> +	return 0;
> +
> +err_delete:
> +	xa_erase(&vepc->page_array, index);
> +err_free:
> +	sgx_free_epc_page(epc_page);
> +	return ret;
> +}
> +
> +static vm_fault_t sgx_vepc_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct sgx_vepc *vepc = vma->vm_private_data;
> +	int ret;
> +
> +	mutex_lock(&vepc->lock);
> +	ret = __sgx_vepc_fault(vepc, vma, vmf->address);
> +	mutex_unlock(&vepc->lock);
> +
> +	if (!ret)
> +		return VM_FAULT_NOPAGE;
> +
> +	if (ret == -EBUSY && (vmf->flags & FAULT_FLAG_ALLOW_RETRY)) {
> +		mmap_read_unlock(vma->vm_mm);
> +		return VM_FAULT_RETRY;
> +	}
> +
> +	return VM_FAULT_SIGBUS;
> +}
> +
> +const struct vm_operations_struct sgx_vepc_vm_ops = {
> +	.fault = sgx_vepc_fault,
> +};
> +
> +static int sgx_vepc_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct sgx_vepc *vepc = file->private_data;
> +
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +
> +	vma->vm_ops = &sgx_vepc_vm_ops;
> +	/* Don't copy VMA in fork() */
> +	vma->vm_flags |= VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY;
> +	vma->vm_private_data = vepc;
> +
> +	return 0;
> +}
> +
> +static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +
> +	/*
> +	 * Take a previously guest-owned EPC page and return it to the
> +	 * general EPC page pool.
> +	 *
> +	 * Guests can not be trusted to have left this page in a good
> +	 * state, so run EREMOVE on the page unconditionally.  In the
> +	 * case that a guest properly EREMOVE'd this page, a superfluous
> +	 * EREMOVE is harmless.
> +	 */
> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> +	if (ret) {
> +		/*
> +		 * Only SGX_CHILD_PRESENT is expected, which is because of
> +		 * EREMOVE'ing an SECS still with child, in which case it can
> +		 * be handled by EREMOVE'ing the SECS again after all pages in
> +		 * virtual EPC have been EREMOVE'd. See comments in below in
> +		 * sgx_vepc_release().
> +		 *
> +		 * The user of virtual EPC (KVM) needs to guarantee there's no
> +		 * logical processor is still running in the enclave in guest,
> +		 * otherwise EREMOVE will get SGX_ENCLAVE_ACT which cannot be
> +		 * handled here.
> +		 */
> +		WARN_ONCE(ret != SGX_CHILD_PRESENT,
> +			  "EREMOVE (EPC page 0x%lx): unexpected error: %d\n",
> +			  sgx_get_epc_phys_addr(epc_page), ret);
> +		return ret;
> +	}
> +
> +	sgx_free_epc_page(epc_page);
> +	return 0;
> +}
> +
> +static int sgx_vepc_release(struct inode *inode, struct file *file)
> +{
> +	struct sgx_vepc *vepc = file->private_data;
> +	struct sgx_epc_page *epc_page, *tmp, *entry;
> +	unsigned long index;
> +
> +	LIST_HEAD(secs_pages);
> +
> +	xa_for_each(&vepc->page_array, index, entry) {
> +		/*
> +		 * Remove all normal, child pages.  sgx_vepc_free_page()
> +		 * will fail if EREMOVE fails, but this is OK and expected on
> +		 * SECS pages.  Those can only be EREMOVE'd *after* all their
> +		 * child pages. Retries below will clean them up.
> +		 */
> +		if (sgx_vepc_free_page(entry))
> +			continue;
> +
> +		xa_erase(&vepc->page_array, index);
> +	}
> +
> +	/*
> +	 * Retry EREMOVE'ing pages.  This will clean up any SECS pages that
> +	 * only had children in this 'epc' area.
> +	 */
> +	xa_for_each(&vepc->page_array, index, entry) {
> +		epc_page = entry;
> +		/*
> +		 * An EREMOVE failure here means that the SECS page still
> +		 * has children.  But, since all children in this 'sgx_vepc'
> +		 * have been removed, the SECS page must have a child on
> +		 * another instance.
> +		 */
> +		if (sgx_vepc_free_page(epc_page))
> +			list_add_tail(&epc_page->list, &secs_pages);
> +
> +		xa_erase(&vepc->page_array, index);
> +	}
> +
> +	/*
> +	 * SECS pages are "pinned" by child pages, an unpinned once all
> +	 * children have been EREMOVE'd.  A child page in this instance
> +	 * may have pinned an SECS page encountered in an earlier release(),
> +	 * creating a zombie.  Since some children were EREMOVE'd above,
> +	 * try to EREMOVE all zombies in the hopes that one was unpinned.
> +	 */
> +	mutex_lock(&zombie_secs_pages_lock);
> +	list_for_each_entry_safe(epc_page, tmp, &zombie_secs_pages, list) {
> +		/*
> +		 * Speculatively remove the page from the list of zombies,
> +		 * if the page is successfully EREMOVE it will be added to
> +		 * the list of free pages.  If EREMOVE fails, throw the page
> +		 * on the local list, which will be spliced on at the end.
> +		 */
> +		list_del(&epc_page->list);
> +
> +		if (sgx_vepc_free_page(epc_page))
> +			list_add_tail(&epc_page->list, &secs_pages);
> +	}
> +
> +	if (!list_empty(&secs_pages))
> +		list_splice_tail(&secs_pages, &zombie_secs_pages);
> +	mutex_unlock(&zombie_secs_pages_lock);
> +
> +	kfree(vepc);
> +
> +	return 0;
> +}
> +
> +static int sgx_vepc_open(struct inode *inode, struct file *file)
> +{
> +	struct sgx_vepc *vepc;
> +
> +	vepc = kzalloc(sizeof(struct sgx_vepc), GFP_KERNEL);
> +	if (!vepc)
> +		return -ENOMEM;
> +	mutex_init(&vepc->lock);
> +	xa_init(&vepc->page_array);
> +
> +	file->private_data = vepc;
> +
> +	return 0;
> +}
> +
> +static const struct file_operations sgx_vepc_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= sgx_vepc_open,
> +	.release	= sgx_vepc_release,
> +	.mmap		= sgx_vepc_mmap,
> +};
> +
> +static struct miscdevice sgx_vepc_dev = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "sgx_vepc",
> +	.nodename = "sgx_vepc",
> +	.fops = &sgx_vepc_fops,
> +};
> +
> +int __init sgx_vepc_init(void)
> +{
> +	/* SGX virtualization requires KVM to work */
> +	if (!boot_cpu_has(X86_FEATURE_VMX) || !IS_ENABLED(CONFIG_KVM_INTEL))
> +		return -ENODEV;
> +
> +	INIT_LIST_HEAD(&zombie_secs_pages);
> +	mutex_init(&zombie_secs_pages_lock);
> +
> +	return misc_register(&sgx_vepc_dev);
> +}
> diff --git a/arch/x86/kernel/cpu/sgx/virt.h b/arch/x86/kernel/cpu/sgx/virt.h
> new file mode 100644
> index 000000000000..44d872380ca1
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/virt.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +#ifndef _ASM_X86_SGX_VIRT_H
> +#define _ASM_X86_SGX_VIRT_H
> +
> +#ifdef CONFIG_X86_SGX_KVM
> +int __init sgx_vepc_init(void);
> +#else
> +static inline int __init sgx_vepc_init(void)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
> +#endif /* _ASM_X86_SGX_VIRT_H */
> -- 
> 2.29.2
> 
> 

Other than that, this starts to be in shape.

/Jarkko
