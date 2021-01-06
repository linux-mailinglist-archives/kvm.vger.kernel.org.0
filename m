Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC47A2EC522
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 21:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbhAFUgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 15:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbhAFUgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 15:36:20 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4CFC06134C
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 12:35:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y8so2139161plp.8
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 12:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rpgaHqZdAQi//OLheAHzcPh/oj58gqDnQnAtqDbjIek=;
        b=M2RYLE1u4rg2Tnz3d5Ep1gK13P1bnVWvYie5JNo8jIVoGtoaiQo1UAMBx1jz5KI1h0
         LSQyLDbSNhZy0oH21v1pNuayB0pjudglZwOWk85jlXL8unN1Ax6KIkIdTbg+2nDJu/X1
         uG6T5kyWsoBIK4koqL/H4t8nZl1KRm+y/W6QX27EGGgw6cUbZlswR4eYfpbwdOaWnACG
         OkIET3OfO8tfbY3YtbAyjeedh9PLMGMVfRJBvRefFyw6FFMHV78sv9PQFvErdMxTIaX1
         JStI12dOr4C0J+M1jTNJLLm6LpJf38sIQBacYC7kOIoFiP0zmI1x8jpcaA+FMnEbtNpp
         rd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rpgaHqZdAQi//OLheAHzcPh/oj58gqDnQnAtqDbjIek=;
        b=Kfz4UQITlHoDi89oW4StTZ/LQ0wXi/34FokSKemd3/CLcF68bkQYlMyO+6no8pV4ul
         dKnDlzMomlEhkLskVroGwhtb9FI3xwTiOjF/Xgy4ar6v7rQzeHbZUeiKeFnHecVveotA
         YVZ3n9tbFhj2DyOxUIjJOG4zmt+ujv6b5x4mSbkrsQPwDYby6Se94/V20TmQpcHDzxIE
         jPVwHC7YeB6Spz0vvFbqrtbgvRPbl2SKLp+C46TdC9/QQNLuy60r6PT6IT7vcOKlWSdq
         0Od5XYIaxEGDJkaDMTu6KmTp8PlW7ClRtibKcbJTalyopXWto8bDn77jsrma7jaB61nQ
         47TQ==
X-Gm-Message-State: AOAM5339hIhL8oBKtlCQYH+TP2ROUXCoW+zlOs/G6tzbSaVCRBk3O/Cf
        tdw4WGxkDcEC9Mzn84mH11L7IA==
X-Google-Smtp-Source: ABdhPJzc97vTks5U3qA5TdFKvDCxCCE+oM/a147afORlBA/aZobUGWp0U91i9sQIUm2p5e3DniwyoQ==
X-Received: by 2002:a17:902:b706:b029:dc:3817:4da5 with SMTP id d6-20020a170902b706b02900dc38174da5mr5953028pls.23.1609965339106;
        Wed, 06 Jan 2021 12:35:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id m22sm3839902pgj.46.2021.01.06.12.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 12:35:38 -0800 (PST)
Date:   Wed, 6 Jan 2021 12:35:31 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <X/YfE28guNBxcpui@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
 <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021, Dave Hansen wrote:
> On 1/5/21 5:55 PM, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 95aad183bb65..02993a327a1f 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -9,9 +9,11 @@
> >  #include <linux/sched/mm.h>
> >  #include <linux/sched/signal.h>
> >  #include <linux/slab.h>
> > +#include "arch.h"
> >  #include "driver.h"
> >  #include "encl.h"
> >  #include "encls.h"
> > +#include "virt.h"
> >  
> >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> >  static int sgx_nr_epc_sections;
> > @@ -726,7 +728,8 @@ static void __init sgx_init(void)
> >  	if (!sgx_page_reclaimer_init())
> >  		goto err_page_cache;
> >  
> > -	ret = sgx_drv_init();
> > +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > +	ret = !!sgx_drv_init() & !!sgx_virt_epc_init();
> >  	if (ret)
> >  		goto err_kthread;
> 
> FWIW, I hate that conditional.  But, I tried to write to to be something
> more sane and failed.

Heh, you're welcome :-D

> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> > new file mode 100644
> > index 000000000000..d625551ccf25
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -0,0 +1,263 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*  Copyright(c) 2016-20 Intel Corporation. */
> > +
> > +#include <linux/miscdevice.h>
> > +#include <linux/mm.h>
> > +#include <linux/mman.h>
> > +#include <linux/sched/mm.h>
> > +#include <linux/sched/signal.h>
> > +#include <linux/slab.h>
> > +#include <linux/xarray.h>
> > +#include <asm/sgx.h>
> > +#include <uapi/asm/sgx.h>
> > +
> > +#include "encls.h"
> > +#include "sgx.h"
> > +#include "virt.h"
> > +
> > +struct sgx_virt_epc {
> > +	struct xarray page_array;
> > +	struct mutex lock;
> > +	struct mm_struct *mm;
> > +};
> > +
> > +static struct mutex virt_epc_lock;
> > +static struct list_head virt_epc_zombie_pages;
> 
> What does the lock protect?

Effectively, the list of zombie SECS pages.  Not sure why I used a generic name.

> What are zombie pages?

My own terminology for SECS pages whose virtual EPC has been destroyed but can't
be reclaimed due to them having child EPC pages in other virtual EPCs.

> BTW, if zombies are SECS-only, shouldn't that be in the name rather than
> "epc"?

I used the virt_epc prefix/namespace to tag it as a global list.  I've no
argument against something like zombie_secs_pages.

> > +static int __sgx_virt_epc_fault(struct sgx_virt_epc *epc,
> > +				struct vm_area_struct *vma, unsigned long addr)
> > +{
> > +	struct sgx_epc_page *epc_page;
> > +	unsigned long index, pfn;
> > +	int ret;
> > +
> > +	/* epc->lock must already have been hold */
> 
> 	/* epc->lock must already be held */
> 
> Wouldn't this be better as:
> 
> WARN_ON(!mutex_is_locked(&epc->lock));
> 
> ?

Or just proper lockdep?
 
> > +	/* Calculate index of EPC page in virtual EPC's page_array */
> > +	index = vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
> > +
> > +	epc_page = xa_load(&epc->page_array, index);
> > +	if (epc_page)
> > +		return 0;
> > +
> > +	epc_page = sgx_alloc_epc_page(epc, false);
> > +	if (IS_ERR(epc_page))
> > +		return PTR_ERR(epc_page);
> > +
> > +	ret = xa_err(xa_store(&epc->page_array, index, epc_page, GFP_KERNEL));
> > +	if (ret)
> > +		goto err_free;
> > +
> > +	pfn = PFN_DOWN(sgx_get_epc_phys_addr(epc_page));
> > +
> > +	ret = vmf_insert_pfn(vma, addr, pfn);
> > +	if (ret != VM_FAULT_NOPAGE) {
> > +		ret = -EFAULT;
> > +		goto err_delete;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_delete:
> > +	xa_erase(&epc->page_array, index);
> > +err_free:
> > +	sgx_free_epc_page(epc_page);
> > +	return ret;
> > +}
> > +
> > +static vm_fault_t sgx_virt_epc_fault(struct vm_fault *vmf)
> > +{
> > +	struct vm_area_struct *vma = vmf->vma;
> > +	struct sgx_virt_epc *epc = vma->vm_private_data;
> > +	int ret;
> > +
> > +	mutex_lock(&epc->lock);
> > +	ret = __sgx_virt_epc_fault(epc, vma, vmf->address);
> > +	mutex_unlock(&epc->lock);
> > +
> > +	if (!ret)
> > +		return VM_FAULT_NOPAGE;
> > +
> > +	if (ret == -EBUSY && (vmf->flags & FAULT_FLAG_ALLOW_RETRY)) {
> > +		mmap_read_unlock(vma->vm_mm);
> > +		return VM_FAULT_RETRY;
> > +	}
> > +
> > +	return VM_FAULT_SIGBUS;
> > +}
> > +
> > +const struct vm_operations_struct sgx_virt_epc_vm_ops = {
> > +	.fault = sgx_virt_epc_fault,
> > +};
> > +
> > +static int sgx_virt_epc_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	struct sgx_virt_epc *epc = file->private_data;
> > +
> > +	if (!(vma->vm_flags & VM_SHARED))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Don't allow mmap() from child after fork(), since child and parent
> > +	 * cannot map to the same EPC.
> > +	 */
> > +	if (vma->vm_mm != epc->mm)
> > +		return -EINVAL;
> 
> I mentioned this below, but I'm not buying this logic.  I know it would
> be *bad*, but I don't see why the kernel needs to keep it from happening.

There's no known use case (KVM doesn't support sharing a VM across multiple
mm structs), and supporting multiple mm structs is a nightmare; see the driver
for the amount of pain incurred.

And IIRC, supporting VMM (KVM) EPC oversubscription, which may or may not ever
happen, was borderline impossible if virtual EPC supports multiple mm structs as
the interaction between KVM and virtual EPC is a disaster in that case.

> > +	vma->vm_ops = &sgx_virt_epc_vm_ops;
> > +	/* Don't copy VMA in fork() */
> > +	vma->vm_flags |= VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY;
> > +	vma->vm_private_data = file->private_data;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sgx_virt_epc_free_page(struct sgx_epc_page *epc_page)
> > +{
> > +	int ret;
> > +
> > +	if (!epc_page)
> > +		return 0;
> 
> I always worry about these.  Why is passing NULL around OK?

I suspect I did it to mimic kfree() behavior.  I don't _think_ the radix (now
xarray) usage will ever encounter a NULL entry.

> 
> > +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> > +	if (ret) {
> > +		/*
> > +		 * Only SGX_CHILD_PRESENT is expected, which is because of
> > +		 * EREMOVE-ing an SECS still with child, in which case it can
> > +		 * be handled by EREMOVE-ing the SECS again after all pages in
> > +		 * virtual EPC have been EREMOVE-ed. See comments in below in
> > +		 * sgx_virt_epc_release().
> > +		 */
> > +		WARN_ON_ONCE(ret != SGX_CHILD_PRESENT);
> > +		return ret;
> > +	}
> 
> I find myself wondering what errors could cause the WARN_ON_ONCE() to be
> hit.  The SDM indicates that it's only:
> 
> 	SGX_ENCLAVE_ACT If there are still logical processors executing
> 			inside the enclave.
> 
> Should that be mentioned in the comment?

And faults, which are also spliced into the return value by the ENCLS macros.
I do remember hitting this WARN when I broke things, though I can't remember
whether it was a fault or the SGX_ENCLAVE_ACT scenario.  Probably the latter?

> > +
> > +	__sgx_free_epc_page(epc_page);
> > +	return 0;
> > +}
> > +

...

> > +	xa_for_each(&epc->page_array, index, entry) {
> > +		epc_page = entry;
> 
> Then, talk about the error condition here:
> 
> > +		/*
> > +		 * Error here means that EREMOVE failed due to a SECS page
> > +		 * still has child on *another* EPC instance.  Put it to a
> > +		 * temporary SECS list which will be spliced to 'zombie page
> > +		 * list' and will be EREMOVE-ed again when freeing another
> > +		 * virtual EPC instance.
> > +		 */
> 
> Surprise, I've got another rewrite:
> 
> 		/*
> 		 * An EREMOVE failure here means that the SECS page
> 		 * still has children.  But, since all children in this
> 		 * 'sgx_virt_epc' have been removed, the SECS page must
> 		 * have a child on another instance.
> 		 */
> 
> > +		if (sgx_virt_epc_free_page(epc_page))
> > +			list_add_tail(&epc_page->list, &secs_pages);
> 
> Why move these over to &secs_list here?  I think it's to avoid another
> xa_for_each() below, but it's not clear.

Yes?  IIRC, the sole motivation is to make the list_split_tail() operation as
short as possible while holding the global virt_epc_lock.
 
> > +		xa_erase(&epc->page_array, index);
> > +	}
> > +

...
 	
> > +	mutex_lock(&virt_epc_lock);
> > +	list_for_each_entry_safe(epc_page, tmp, &virt_epc_zombie_pages, list) {
> > +		/*
> > +		 * Speculatively remove the page from the list of zombies, if
> > +		 * the page is successfully EREMOVE it will be added to the
> > +		 * list of free pages.  If EREMOVE fails, throw the page on the
> > +		 * local list, which will be spliced on at the end.
> > +		 */
> > +		list_del(&epc_page->list);
> > +
> > +		if (sgx_virt_epc_free_page(epc_page))
> > +			list_add_tail(&epc_page->list, &secs_pages);
> 
> I don't get this.  Couldn't you do without the unconditional list_del()
> and instead just do:
> 
> 		if (!sgx_virt_epc_free_page(epc_page))
> 			list_del(&epc_page->list);
> 
> Or does the free() code clobber the list_head?  If that's the case,
> maybe you should say that explicitly.

More or less.  EPC pages need to be removed from their list before freeing, once
a page is freed it is owned by the allocator.  Deleting after freeing leads to
list corruption if a different thread allocates the page and adds it to a
different list.
 
> > +	}
> > +
> > +	if (!list_empty(&secs_pages))
> > +		list_splice_tail(&secs_pages, &virt_epc_zombie_pages);
> > +	mutex_unlock(&virt_epc_lock);
> > +
> > +	kfree(epc);
> > +
> > +	return 0;
> > +}
