Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28AF811D114
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 16:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfLLPee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 10:34:34 -0500
Received: from foss.arm.com ([217.140.110.172]:50906 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbfLLPee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 10:34:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B186F30E;
        Thu, 12 Dec 2019 07:34:33 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D7B93F6CF;
        Thu, 12 Dec 2019 07:34:32 -0800 (PST)
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a poisoned
 page
To:     Marc Zyngier <maz@kernel.org>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-3-maz@kernel.org>
 <88f65ab4ac87f53534fbbfd2410d1cc5@www.loen.fr>
From:   James Morse <james.morse@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Message-ID: <b0a2b074-b80f-84ee-bfaa-f81ab345b8c2@arm.com>
Date:   Thu, 12 Dec 2019 15:34:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <88f65ab4ac87f53534fbbfd2410d1cc5@www.loen.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 12/12/2019 11:33, Marc Zyngier wrote:
> On 2019-12-11 16:56, Marc Zyngier wrote:
>> When we check for a poisoned page, we use the VMA to tell userspace
>> about the looming disaster. But we pass a pointer to this VMA
>> after having released the mmap_sem, which isn't a good idea.

Sounds like a bug! The vma-size might not match the poisoned pfn.


>> Instead, re-check that we have still have a VMA, and that this
>> VMA still points to a poisoned page. If the VMA isn't there,
>> userspace is playing with our nerves, so lety's give it a -EFAULT
>> (it deserves it). If the PFN isn't poisoned anymore, let's restart
>> from the top and handle the fault again.


>>  virt/kvm/arm/mmu.c | 25 +++++++++++++++++++++++--
>>  1 file changed, 23 insertions(+), 2 deletions(-)

... yeah ...

>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 0b32a904a1bb..f73393f5ddb7 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1741,9 +1741,30 @@ static int user_mem_abort(struct kvm_vcpu
>> *vcpu, phys_addr_t fault_ipa,
>>
>>      pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>>      if (pfn == KVM_PFN_ERR_HWPOISON) {
>> -        kvm_send_hwpoison_signal(hva, vma);
>> -        return 0;
>> +        /*
>> +         * Search for the VMA again, as it may have been
>> +         * removed in the interval...
>> +         */
>> +        down_read(&current->mm->mmap_sem);
>> +        vma = find_vma_intersection(current->mm, hva, hva + 1);
>> +        if (vma) {
>> +            /*
>> +             * Recheck for a poisoned page. If something changed
>> +             * behind our back, don't do a thing and take the
>> +             * fault again.
>> +             */
>> +            pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>> +            if (pfn == KVM_PFN_ERR_HWPOISON)
>> +                kvm_send_hwpoison_signal(hva, vma);
>> +
>> +            ret = 0;
>> +        } else {
>> +            ret = -EFAULT;
>> +        }
>> +        up_read(&current->mm->mmap_sem);
>> +        return ret;
>>      }
>> +
>>      if (is_error_noslot_pfn(pfn))
>>          return -EFAULT;


> Revisiting this, I wonder if we're not better off just holding the mmap_sem
> for a bit longer. Something like:
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 0b32a904a1bb..87d416d000c6 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1719,13 +1719,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t
> fault_ipa,
>      if (vma_pagesize == PMD_SIZE ||
>          (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
>          gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> -    up_read(&current->mm->mmap_sem);
> -
>      /* We need minimum second+third level pages */
>      ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
>                       KVM_NR_MEM_OBJS);
> -    if (ret)
> +    if (ret) {
> +        up_read(&current->mm->mmap_sem);
>          return ret;
> +    }
> 
>      mmu_seq = vcpu->kvm->mmu_notifier_seq;
>      /*
> @@ -1742,8 +1742,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t
> fault_ipa,
>      pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>      if (pfn == KVM_PFN_ERR_HWPOISON) {
>          kvm_send_hwpoison_signal(hva, vma);
> +        up_read(&current->mm->mmap_sem);
>          return 0;
>      }
> +
> +    up_read(&current->mm->mmap_sem);
> +
>      if (is_error_noslot_pfn(pfn))
>          return -EFAULT;
> 
> 
> James, what do you think?

(allocating from a kmemcache while holding current's mmap_sem. I don't want to think about
it!)

Can we be lazier? We want the VMA to get the size of the poisoned mapping correct in the
signal. The bug is that this could change when we drop the lock, before queuing the
signal, so we report hwpoison on old-vmas:pfn with new-vmas:size.

Can't it equally change when we drop the lock after queuing the signal? Any time before
the thread returns to user-space to take the signal gives us a stale value.

I think all that matters is the size goes with the pfn that was poisoned. If we look the
vma up by hva again, we have to check if the pfn has changed too... (which you are doing)

Can we stash the size in the existing mmap_sem region, and use that in
kvm_send_hwpoison_signal()? We know it matches the pfn we saw as poisoned.

The vma could be changed before/after we send the signal, but user-space can't know which.
This is user-spaces' problem for messing with the memslots while a vpcu is running.


How about (untested):
-------------------------%<-------------------------
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 38b4c910b6c3..80212d4935bd 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1591,16 +1591,8 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned
long size)
        __invalidate_icache_guest_page(pfn, size);
 }

-static void kvm_send_hwpoison_signal(unsigned long address,
-                                    struct vm_area_struct *vma)
+static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
-       short lsb;
-
-       if (is_vm_hugetlb_page(vma))
-               lsb = huge_page_shift(hstate_vma(vma));
-       else
-               lsb = PAGE_SHIFT;
-
        send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }

@@ -1673,6 +1665,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
        struct kvm *kvm = vcpu->kvm;
        struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
        struct vm_area_struct *vma;
+       short stage1_vma_size;
        kvm_pfn_t pfn;
        pgprot_t mem_type = PAGE_S2;
        bool logging_active = memslot_is_logging(memslot);

@@ -1703,6 +1696,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
                vma_pagesize = PAGE_SIZE;
        }

+       /* For signals due to hwpoison, we need to use the stage1 size */
+       if (is_vm_hugetlb_page(vma))
+               stage1_vma_size = huge_page_shift(hstate_vma(vma));
+       else
+               stage1_vma_size = PAGE_SHIFT;
+
        /*
         * The stage2 has a minimum of 2 level table (For arm64 see
         * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
@@ -1735,7 +1734,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,

        pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
        if (pfn == KVM_PFN_ERR_HWPOISON) {
-               kvm_send_hwpoison_signal(hva, vma);
+               kvm_send_hwpoison_signal(hva, stage1_vma_size);
                return 0;
        }
        if (is_error_noslot_pfn(pfn))
-------------------------%<-------------------------

Its possible this could even be the original output of vma_kernel_pagesize()... (Punit
supplied the original huge_page_shift(hstate_vma()) runes...)



Thanks,

James
