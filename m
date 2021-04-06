Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323DA354F62
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 11:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhDFJFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 05:05:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:29829 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233952AbhDFJFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 05:05:07 -0400
IronPort-SDR: 84tUf0CnMzUAsuk6PVUhlBXgz79/AjTgTXRtx3cPjwnjsEUXOy/6rzsODngSrt9upneCQJ5ARi
 Slp+hs41Lqhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="193065669"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="193065669"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:04:59 -0700
IronPort-SDR: i9Zkk7yyN+ayjOp6QpH6cwpXT9bM0TwqqRJYhjgqsblV8vBI8mi7sZOce8M379+MjVxOg0M7jk
 3eeb/yopG9ZQ==
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="612474076"
Received: from nkanakap-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.6.197])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:04:55 -0700
Date:   Tue, 6 Apr 2021 21:04:53 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210406210453.c4744c09b5adfb7bf5e0e239@intel.com>
In-Reply-To: <20210406082800.GD17806@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
        <20210405090151.GA19485@zn.tnic>
        <20210406094634.9f5e8c9d6bd2b61690c887cf@intel.com>
        <20210406082800.GD17806@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Apr 2021 10:28:00 +0200 Borislav Petkov wrote:
> On Tue, Apr 06, 2021 at 09:46:34AM +1200, Kai Huang wrote:
> > Fine to me. Please let me know if you want me to resend patches. Thanks.
> 
> Patch updated:

Looks fine. Thank you!

> 
> ---
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> Date: Fri, 19 Mar 2021 20:22:21 +1300
> Subject: [PATCH] x86/sgx: Introduce virtual EPC for use by KVM guests
> 
> Add a misc device /dev/sgx_vepc to allow userspace to allocate "raw"
> Enclave Page Cache (EPC) without an associated enclave. The intended
> and only known use case for raw EPC allocation is to expose EPC to a
> KVM guest, hence the 'vepc' moniker, virt.{c,h} files and X86_SGX_KVM
> Kconfig.
> 
> The SGX driver uses the misc device /dev/sgx_enclave to support
> userspace in creating an enclave. Each file descriptor returned from
> opening /dev/sgx_enclave represents an enclave. Unlike the SGX driver,
> KVM doesn't control how the guest uses the EPC, therefore EPC allocated
> to a KVM guest is not associated with an enclave, and /dev/sgx_enclave
> is not suitable for allocating EPC for a KVM guest.
> 
> Having separate device nodes for the SGX driver and KVM virtual EPC also
> allows separate permission control for running host SGX enclaves and KVM
> SGX guests.
> 
> To use /dev/sgx_vepc to allocate a virtual EPC instance with particular
> size, the hypervisor opens /dev/sgx_vepc, and uses mmap() with the
> intended size to get an address range of virtual EPC. Then it may use
> the address range to create one KVM memory slot as virtual EPC for
> a guest.
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
> Reclaiming an EPC page used by enclave requires a special reclaim
> mechanism separate from normal page reclaim, and that mechanism is not
> supported for virutal EPC pages. Due to the complications of handling
> reclaim conflicts between guest and host, reclaiming virtual EPC pages
> is significantly more complex than basic support for SGX virtualization.
> 
>  [ bp:
>    - Massage commit message and comments
>    - use cpu_feature_enabled()
>    - vertically align struct members init
>    - massage Virtual EPC clarification text
>    - move Kconfig prompt to Virtualization ]
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Link: https://lkml.kernel.org/r/0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com
> ---
>  Documentation/x86/sgx.rst        |  16 ++
>  arch/x86/kernel/cpu/sgx/Makefile |   1 +
>  arch/x86/kernel/cpu/sgx/sgx.h    |   9 ++
>  arch/x86/kernel/cpu/sgx/virt.c   | 259 +++++++++++++++++++++++++++++++
>  arch/x86/kvm/Kconfig             |  12 ++
>  5 files changed, 297 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
> 
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> index f90076e67cde..dd0ac96ff9ef 100644
> --- a/Documentation/x86/sgx.rst
> +++ b/Documentation/x86/sgx.rst
> @@ -234,3 +234,19 @@ As a result, when this happpens, user should stop running any new
>  SGX workloads, (or just any new workloads), and migrate all valuable
>  workloads. Although a machine reboot can recover all EPC memory, the bug
>  should be reported to Linux developers.
> +
> +
> +Virtual EPC
> +===========
> +
> +The implementation has also a virtual EPC driver to support SGX enclaves
> +in guests. Unlike the SGX driver, an EPC page allocated by the virtual
> +EPC driver doesn't have a specific enclave associated with it. This is
> +because KVM doesn't track how a guest uses EPC pages.
> +
> +As a result, the SGX core page reclaimer doesn't support reclaiming EPC
> +pages allocated to KVM guests through the virtual EPC driver. If the
> +user wants to deploy SGX applications both on the host and in guests
> +on the same machine, the user should reserve enough EPC (by taking out
> +total virtual EPC size of all SGX VMs from the physical EPC size) for
> +host SGX applications so they can run with acceptable performance.
> diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> index 91d3dc784a29..9c1656779b2a 100644
> --- a/arch/x86/kernel/cpu/sgx/Makefile
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -3,3 +3,4 @@ obj-y += \
>  	encl.o \
>  	ioctl.o \
>  	main.o
> +obj-$(CONFIG_X86_SGX_KVM)	+= virt.o
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 4aa40c627819..4854f3980edd 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -84,4 +84,13 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
>  int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
>  struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
>  
> +#ifdef CONFIG_X86_SGX_KVM
> +int __init sgx_vepc_init(void);
> +#else
> +static inline int __init sgx_vepc_init(void)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
>  #endif /* _X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> new file mode 100644
> index 000000000000..259cc46ad78c
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -0,0 +1,259 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Device driver to expose SGX enclave memory to KVM guests.
> + *
> + * Copyright(c) 2021 Intel Corporation.
> + */
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
> +
> +struct sgx_vepc {
> +	struct xarray page_array;
> +	struct mutex lock;
> +};
> +
> +/*
> + * Temporary SECS pages that cannot be EREMOVE'd due to having child in other
> + * virtual EPC instances, and the lock to protect it.
> + */
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
> +		WARN_ONCE(ret != SGX_CHILD_PRESENT, EREMOVE_ERROR_MESSAGE,
> +			  ret, ret);
> +		return ret;
> +	}
> +
> +	sgx_free_epc_page(epc_page);
> +
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
> +	 * SECS pages are "pinned" by child pages, and "unpinned" once all
> +	 * children have been EREMOVE'd.  A child page in this instance
> +	 * may have pinned an SECS page encountered in an earlier release(),
> +	 * creating a zombie.  Since some children were EREMOVE'd above,
> +	 * try to EREMOVE all zombies in the hopes that one was unpinned.
> +	 */
> +	mutex_lock(&zombie_secs_pages_lock);
> +	list_for_each_entry_safe(epc_page, tmp, &zombie_secs_pages, list) {
> +		/*
> +		 * Speculatively remove the page from the list of zombies,
> +		 * if the page is successfully EREMOVE'd it will be added to
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
> +	.minor		= MISC_DYNAMIC_MINOR,
> +	.name		= "sgx_vepc",
> +	.nodename	= "sgx_vepc",
> +	.fops		= &sgx_vepc_fops,
> +};
> +
> +int __init sgx_vepc_init(void)
> +{
> +	/* SGX virtualization requires KVM to work */
> +	if (!cpu_feature_enabled(X86_FEATURE_VMX))
> +		return -ENODEV;
> +
> +	INIT_LIST_HEAD(&zombie_secs_pages);
> +	mutex_init(&zombie_secs_pages_lock);
> +
> +	return misc_register(&sgx_vepc_dev);
> +}
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index a788d5120d4d..f6b93a35ce14 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -84,6 +84,18 @@ config KVM_INTEL
>  	  To compile this as a module, choose M here: the module
>  	  will be called kvm-intel.
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
>  config KVM_AMD
>  	tristate "KVM for AMD processors support"
>  	depends on KVM
> -- 
> 2.29.2
> 
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
