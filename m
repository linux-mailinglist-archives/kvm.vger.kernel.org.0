Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F0B2F241E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391740AbhALAZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 19:25:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404138AbhAKXjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 18:39:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C1522D00;
        Mon, 11 Jan 2021 23:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610408309;
        bh=iYlq45b2M16oXwLtM5yWb7DqRQLNMMPVkCrv0fVTkpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l8mErDsrgu2BledvjudBV/KPbv04od5k/nq+0Y+pRzp2tg7b2Of+oH6x9fB/CvtYh
         WY+8KfKw2UDoduDXezQK5QdOEhG+hX8sGSD4JPq9mO+yeqRrlMPcOL7hFy0cpIfkwE
         BbGSvn1/J4NzQ+GXuUQJO7YXzJdTVOIhuHCJS9PHnRglH2gFV9nGLPWUcP2BSzlNue
         iHyUJL1TRSJSBYYtVd2MSaQn8gLXAhDslDbgoHOOt+ukE/aGPofiLOEK0r1JPs1Hvl
         XOE8CdAKBryHBB4qn5vRXriN8eD98sS1JMMLM7NVcabRDQ/JsnIzQWTUNRPD+gKwaH
         0kF/KFtgxFvrg==
Date:   Tue, 12 Jan 2021 01:38:23 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <X/zhbyoWBnV1ESQx@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021 at 02:55:20PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> EPC without an associated enclave.  The intended and only known use case
> for raw EPC allocation is to expose EPC to a KVM guest, hence the
> virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.
> 
> Modify sgx_init() to always try to initialize virtual EPC driver, even
> when SGX driver is disabled due to SGX Launch Control is in locked mode,
> or not present at all, since SGX virtualization allows to expose SGX to
> guests that support non-LC configurations.
> 
> Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> /dev/sgx_virt_epc rather than in KVM. Doing so has two major advantages:
> 
>   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
>     just another memory backend for guests.
> 
>   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
>     does not have to export any symbols, changes to reclaim flows don't
>     need to be routed through KVM, SGX's dirty laundry doesn't have to
>     get aired out for the world to see, and so on and so forth.
> 
> The virtual EPC allocated to guests is currently not reclaimable, due to
> oversubscription of EPC for KVM guests is not currently supported. Due
> to the complications of handling reclaim conflicts between guest and
> host, KVM EPC oversubscription is significantly more complex than basic
> support for SGX virtualization.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

The commit message does not describe the code changes. It should
have an understandable explanation of fops. There is nothing about
the implementation right now.

/Jarkko

> ---
>  arch/x86/Kconfig                 |  12 ++
>  arch/x86/kernel/cpu/sgx/Makefile |   1 +
>  arch/x86/kernel/cpu/sgx/main.c   |   5 +-
>  arch/x86/kernel/cpu/sgx/virt.c   | 263 +++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/virt.h   |  14 ++
>  5 files changed, 294 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/virt.h
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 618d1aabccb8..a7318175509b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1947,6 +1947,18 @@ config X86_SGX
>  
>  	  If unsure, say N.
>  
> +config X86_SGX_VIRTUALIZATION
> +	bool "Software Guard eXtensions (SGX) Virtualization"
> +	depends on X86_SGX && KVM_INTEL
> +	help
> +
> +	  Enables KVM guests to create SGX enclaves.
> +
> +	  This includes support to expose "raw" unreclaimable enclave memory to
> +	  guests via a device node, e.g. /dev/sgx_virt_epc.
> +
> +	  If unsure, say N.
> +
>  config EFI
>  	bool "EFI runtime service support"
>  	depends on ACPI
> diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> index 91d3dc784a29..7a25bf63adfb 100644
> --- a/arch/x86/kernel/cpu/sgx/Makefile
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -3,3 +3,4 @@ obj-y += \
>  	encl.o \
>  	ioctl.o \
>  	main.o
> +obj-$(CONFIG_X86_SGX_VIRTUALIZATION)	+= virt.o
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 95aad183bb65..02993a327a1f 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -9,9 +9,11 @@
>  #include <linux/sched/mm.h>
>  #include <linux/sched/signal.h>
>  #include <linux/slab.h>
> +#include "arch.h"
>  #include "driver.h"
>  #include "encl.h"
>  #include "encls.h"
> +#include "virt.h"
>  
>  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
>  static int sgx_nr_epc_sections;
> @@ -726,7 +728,8 @@ static void __init sgx_init(void)
>  	if (!sgx_page_reclaimer_init())
>  		goto err_page_cache;
>  
> -	ret = sgx_drv_init();
> +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> +	ret = !!sgx_drv_init() & !!sgx_virt_epc_init();
>  	if (ret)
>  		goto err_kthread;
>  
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> new file mode 100644
> index 000000000000..d625551ccf25
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -0,0 +1,263 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*  Copyright(c) 2016-20 Intel Corporation. */
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
> +struct sgx_virt_epc {
> +	struct xarray page_array;
> +	struct mutex lock;
> +	struct mm_struct *mm;
> +};
> +
> +static struct mutex virt_epc_lock;
> +static struct list_head virt_epc_zombie_pages;
> +
> +static int __sgx_virt_epc_fault(struct sgx_virt_epc *epc,
> +				struct vm_area_struct *vma, unsigned long addr)
> +{
> +	struct sgx_epc_page *epc_page;
> +	unsigned long index, pfn;
> +	int ret;
> +
> +	/* epc->lock must already have been hold */
> +
> +	/* Calculate index of EPC page in virtual EPC's page_array */
> +	index = vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
> +
> +	epc_page = xa_load(&epc->page_array, index);
> +	if (epc_page)
> +		return 0;
> +
> +	epc_page = sgx_alloc_epc_page(epc, false);
> +	if (IS_ERR(epc_page))
> +		return PTR_ERR(epc_page);
> +
> +	ret = xa_err(xa_store(&epc->page_array, index, epc_page, GFP_KERNEL));
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
> +	xa_erase(&epc->page_array, index);
> +err_free:
> +	sgx_free_epc_page(epc_page);
> +	return ret;
> +}
> +
> +static vm_fault_t sgx_virt_epc_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct sgx_virt_epc *epc = vma->vm_private_data;
> +	int ret;
> +
> +	mutex_lock(&epc->lock);
> +	ret = __sgx_virt_epc_fault(epc, vma, vmf->address);
> +	mutex_unlock(&epc->lock);
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
> +const struct vm_operations_struct sgx_virt_epc_vm_ops = {
> +	.fault = sgx_virt_epc_fault,
> +};
> +
> +static int sgx_virt_epc_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct sgx_virt_epc *epc = file->private_data;
> +
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +
> +	/*
> +	 * Don't allow mmap() from child after fork(), since child and parent
> +	 * cannot map to the same EPC.
> +	 */
> +	if (vma->vm_mm != epc->mm)
> +		return -EINVAL;
> +
> +	vma->vm_ops = &sgx_virt_epc_vm_ops;
> +	/* Don't copy VMA in fork() */
> +	vma->vm_flags |= VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY;
> +	vma->vm_private_data = file->private_data;
> +
> +	return 0;
> +}
> +
> +static int sgx_virt_epc_free_page(struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +
> +	if (!epc_page)
> +		return 0;
> +
> +	/*
> +	 * Explicitly EREMOVE virtual EPC page. Virtual EPC is only used by
> +	 * guest, and in normal condition guest should have done EREMOVE for
> +	 * all EPC pages before they are freed here. But it's possible guest
> +	 * is killed or crashed unnormally in which case EREMOVE has not been
> +	 * done. Do EREMOVE unconditionally here to cover both cases, because
> +	 * it's not possible to tell whether guest has done EREMOVE, since
> +	 * virtual EPC page status is not tracked. And it is fine to EREMOVE
> +	 * EPC page multiple times.
> +	 */
> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> +	if (ret) {
> +		/*
> +		 * Only SGX_CHILD_PRESENT is expected, which is because of
> +		 * EREMOVE-ing an SECS still with child, in which case it can
> +		 * be handled by EREMOVE-ing the SECS again after all pages in
> +		 * virtual EPC have been EREMOVE-ed. See comments in below in
> +		 * sgx_virt_epc_release().
> +		 */
> +		WARN_ON_ONCE(ret != SGX_CHILD_PRESENT);
> +		return ret;
> +	}
> +
> +	__sgx_free_epc_page(epc_page);
> +	return 0;
> +}
> +
> +static int sgx_virt_epc_release(struct inode *inode, struct file *file)
> +{
> +	struct sgx_virt_epc *epc = file->private_data;
> +	struct sgx_epc_page *epc_page, *tmp, *entry;
> +	unsigned long index;
> +
> +	LIST_HEAD(secs_pages);
> +
> +	mmdrop(epc->mm);
> +
> +	xa_for_each(&epc->page_array, index, entry) {
> +		/*
> +		 * Virtual EPC pages are not tracked, so it's possible for
> +		 * EREMOVE to fail due to, e.g. a SECS page still has children
> +		 * if guest was shutdown unexpectedly. If it is the case, leave
> +		 * it in the xarray and retry EREMOVE below later.
> +		 */
> +		if (sgx_virt_epc_free_page(entry))
> +			continue;
> +
> +		xa_erase(&epc->page_array, index);
> +	}
> +
> +	/*
> +	 * Retry all failed pages after iterating through the entire tree, at
> +	 * which point all children should be removed and the SECS pages can be
> +	 * nuked as well...unless userspace has exposed multiple instance of
> +	 * virtual EPC to a single VM.
> +	 */
> +	xa_for_each(&epc->page_array, index, entry) {
> +		epc_page = entry;
> +		/*
> +		 * Error here means that EREMOVE failed due to a SECS page
> +		 * still has child on *another* EPC instance.  Put it to a
> +		 * temporary SECS list which will be spliced to 'zombie page
> +		 * list' and will be EREMOVE-ed again when freeing another
> +		 * virtual EPC instance.
> +		 */
> +		if (sgx_virt_epc_free_page(epc_page))
> +			list_add_tail(&epc_page->list, &secs_pages);
> +
> +		xa_erase(&epc->page_array, index);
> +	}
> +
> +	/*
> +	 * Third time's a charm.  Try to EREMOVE zombie SECS pages from virtual
> +	 * EPC instances that were previously released, i.e. free SECS pages
> +	 * that were in limbo due to having children in *this* EPC instance.
> +	 */
> +	mutex_lock(&virt_epc_lock);
> +	list_for_each_entry_safe(epc_page, tmp, &virt_epc_zombie_pages, list) {
> +		/*
> +		 * Speculatively remove the page from the list of zombies, if
> +		 * the page is successfully EREMOVE it will be added to the
> +		 * list of free pages.  If EREMOVE fails, throw the page on the
> +		 * local list, which will be spliced on at the end.
> +		 */
> +		list_del(&epc_page->list);
> +
> +		if (sgx_virt_epc_free_page(epc_page))
> +			list_add_tail(&epc_page->list, &secs_pages);
> +	}
> +
> +	if (!list_empty(&secs_pages))
> +		list_splice_tail(&secs_pages, &virt_epc_zombie_pages);
> +	mutex_unlock(&virt_epc_lock);
> +
> +	kfree(epc);
> +
> +	return 0;
> +}
> +
> +static int sgx_virt_epc_open(struct inode *inode, struct file *file)
> +{
> +	struct sgx_virt_epc *epc;
> +
> +	epc = kzalloc(sizeof(struct sgx_virt_epc), GFP_KERNEL);
> +	if (!epc)
> +		return -ENOMEM;
> +	/*
> +	 * Keep the current->mm to virtual EPC. It will be checked in
> +	 * sgx_virt_epc_mmap() to prevent, in case of fork, child being
> +	 * able to mmap() to the same virtual EPC pages.
> +	 */
> +	mmgrab(current->mm);
> +	epc->mm = current->mm;
> +	mutex_init(&epc->lock);
> +	xa_init(&epc->page_array);
> +
> +	file->private_data = epc;
> +
> +	return 0;
> +}
> +
> +static const struct file_operations sgx_virt_epc_fops = {
> +	.owner			= THIS_MODULE,
> +	.open			= sgx_virt_epc_open,
> +	.release		= sgx_virt_epc_release,
> +	.mmap			= sgx_virt_epc_mmap,
> +};
> +
> +static struct miscdevice sgx_virt_epc_dev = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "sgx_virt_epc",
> +	.nodename = "sgx_virt_epc",
> +	.fops = &sgx_virt_epc_fops,
> +};
> +
> +int __init sgx_virt_epc_init(void)
> +{
> +	INIT_LIST_HEAD(&virt_epc_zombie_pages);
> +	mutex_init(&virt_epc_lock);
> +
> +	return misc_register(&sgx_virt_epc_dev);
> +}
> diff --git a/arch/x86/kernel/cpu/sgx/virt.h b/arch/x86/kernel/cpu/sgx/virt.h
> new file mode 100644
> index 000000000000..e5434541a122
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/virt.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +#ifndef _ASM_X86_SGX_VIRT_H
> +#define _ASM_X86_SGX_VIRT_H
> +
> +#ifdef CONFIG_X86_SGX_VIRTUALIZATION
> +int __init sgx_virt_epc_init(void);
> +#else
> +static inline int __init sgx_virt_epc_init(void)
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
