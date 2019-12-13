Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D496911E087
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 10:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfLMJZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 04:25:55 -0500
Received: from foss.arm.com ([217.140.110.172]:51690 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfLMJZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 04:25:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94A801FB;
        Fri, 13 Dec 2019 01:25:54 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 289AE3F52E;
        Fri, 13 Dec 2019 01:25:54 -0800 (PST)
Date:   Fri, 13 Dec 2019 10:25:52 +0100
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     James Morse <james.morse@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a poisoned
 page
Message-ID: <20191213092552.GC28840@e113682-lin.lund.arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-3-maz@kernel.org>
 <88f65ab4ac87f53534fbbfd2410d1cc5@www.loen.fr>
 <b0a2b074-b80f-84ee-bfaa-f81ab345b8c2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0a2b074-b80f-84ee-bfaa-f81ab345b8c2@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On Thu, Dec 12, 2019 at 03:34:31PM +0000, James Morse wrote:
> Hi Marc,
> 
> On 12/12/2019 11:33, Marc Zyngier wrote:
> > On 2019-12-11 16:56, Marc Zyngier wrote:

[...]

> 
> (allocating from a kmemcache while holding current's mmap_sem. I don't want to think about
> it!)
> 
> Can we be lazier? We want the VMA to get the size of the poisoned mapping correct in the
> signal. The bug is that this could change when we drop the lock, before queuing the
> signal, so we report hwpoison on old-vmas:pfn with new-vmas:size.
> 
> Can't it equally change when we drop the lock after queuing the signal? Any time before
> the thread returns to user-space to take the signal gives us a stale value.
> 
> I think all that matters is the size goes with the pfn that was poisoned. If we look the
> vma up by hva again, we have to check if the pfn has changed too... (which you are doing)
> 
> Can we stash the size in the existing mmap_sem region, and use that in
> kvm_send_hwpoison_signal()? We know it matches the pfn we saw as poisoned.
> 
> The vma could be changed before/after we send the signal, but user-space can't know which.
> This is user-spaces' problem for messing with the memslots while a vpcu is running.
> 

(I should clearly have expanded this thread before I replied to the
original patch...)

> 
> How about (untested):
> -------------------------%<-------------------------
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 38b4c910b6c3..80212d4935bd 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1591,16 +1591,8 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned
> long size)
>         __invalidate_icache_guest_page(pfn, size);
>  }
> 
> -static void kvm_send_hwpoison_signal(unsigned long address,
> -                                    struct vm_area_struct *vma)
> +static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>  {
> -       short lsb;
> -
> -       if (is_vm_hugetlb_page(vma))
> -               lsb = huge_page_shift(hstate_vma(vma));
> -       else
> -               lsb = PAGE_SHIFT;
> -
>         send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>  }
> 
> @@ -1673,6 +1665,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         struct kvm *kvm = vcpu->kvm;
>         struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>         struct vm_area_struct *vma;
> +       short stage1_vma_size;
>         kvm_pfn_t pfn;
>         pgprot_t mem_type = PAGE_S2;
>         bool logging_active = memslot_is_logging(memslot);
> 
> @@ -1703,6 +1696,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 vma_pagesize = PAGE_SIZE;
>         }
> 
> +       /* For signals due to hwpoison, we need to use the stage1 size */
> +       if (is_vm_hugetlb_page(vma))
> +               stage1_vma_size = huge_page_shift(hstate_vma(vma));
> +       else
> +               stage1_vma_size = PAGE_SHIFT;
> +

But (see my patch) as far as I can tell, this is already what we have in
vma_pagesize, and do we really have to provide the stage 1 size to user
space if the fault happened within a smaller boundary?  Isn't that just
providing more precise information to the user?


Thanks,

    Christoffer
