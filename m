Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1EF366569
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 08:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhDUG2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 02:28:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:17807 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbhDUG2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 02:28:51 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FQ9Xt2LtZz7wjD;
        Wed, 21 Apr 2021 14:25:50 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Wed, 21 Apr 2021 14:28:08 +0800
Subject: Re: [PATCH v4 1/2] kvm/arm64: Remove the creation time's mapping of
 MMIO regions
To:     Gavin Shan <gshan@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-2-zhukeqian1@huawei.com>
 <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <bd4d2cfc-37b9-f20a-5a5c-ed352d1a46dc@huawei.com>
Date:   Wed, 21 Apr 2021 14:28:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 2021/4/21 14:38, Gavin Shan wrote:
> Hi Keqian,
> 
> On 4/16/21 12:03 AM, Keqian Zhu wrote:
>> The MMIO regions may be unmapped for many reasons and can be remapped
>> by stage2 fault path. Map MMIO regions at creation time becomes a
>> minor optimization and makes these two mapping path hard to sync.
>>
>> Remove the mapping code while keep the useful sanity check.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
>>   1 file changed, 3 insertions(+), 35 deletions(-)
>>
> 
> After removing the logic to create stage2 mapping for VM_PFNMAP region,
> I think the "do { } while" loop becomes unnecessary and can be dropped
> completely. It means the only sanity check is to see if the memory slot
> overflows IPA space or not. In that case, KVM_MR_FLAGS_ONLY can be
> ignored because the memory slot's base address and length aren't changed
> when we have KVM_MR_FLAGS_ONLY.
Maybe not exactly. Here we do an important sanity check that we shouldn't
log dirty for memslots with VM_PFNMAP.


> 
> It seems the patch isn't based on "next" branch because find_vma() was
> replaced by find_vma_intersection() by one of my patches :)
Yep, I remember it. I will replace it at next merge window...

Thanks,
Keqian

> 
> Thanks,
> Gavin
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 8711894db8c2..c59af5ca01b0 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1301,7 +1301,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>   {
>>       hva_t hva = mem->userspace_addr;
>>       hva_t reg_end = hva + mem->memory_size;
>> -    bool writable = !(mem->flags & KVM_MEM_READONLY);
>>       int ret = 0;
>>         if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
>> @@ -1318,8 +1317,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>       mmap_read_lock(current->mm);
>>       /*
>>        * A memory region could potentially cover multiple VMAs, and any holes
>> -     * between them, so iterate over all of them to find out if we can map
>> -     * any of them right now.
>> +     * between them, so iterate over all of them.
>>        *
>>        *     +--------------------------------------------+
>>        * +---------------+----------------+   +----------------+
>> @@ -1330,50 +1328,20 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>        */
>>       do {
>>           struct vm_area_struct *vma = find_vma(current->mm, hva);
>> -        hva_t vm_start, vm_end;
>>             if (!vma || vma->vm_start >= reg_end)
>>               break;
>>   -        /*
>> -         * Take the intersection of this VMA with the memory region
>> -         */
>> -        vm_start = max(hva, vma->vm_start);
>> -        vm_end = min(reg_end, vma->vm_end);
>> -
>>           if (vma->vm_flags & VM_PFNMAP) {
>> -            gpa_t gpa = mem->guest_phys_addr +
>> -                    (vm_start - mem->userspace_addr);
>> -            phys_addr_t pa;
>> -
>> -            pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
>> -            pa += vm_start - vma->vm_start;
>> -
>>               /* IO region dirty page logging not allowed */
>>               if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>>                   ret = -EINVAL;
>> -                goto out;
>> -            }
>> -
>> -            ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
>> -                            vm_end - vm_start,
>> -                            writable);
>> -            if (ret)
>>                   break;
>> +            }
>>           }
>> -        hva = vm_end;
>> +        hva = min(reg_end, vma->vm_end);
>>       } while (hva < reg_end);
>>   -    if (change == KVM_MR_FLAGS_ONLY)
>> -        goto out;
>> -
>> -    spin_lock(&kvm->mmu_lock);
>> -    if (ret)
>> -        unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
>> -    else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
>> -        stage2_flush_memslot(kvm, memslot);
>> -    spin_unlock(&kvm->mmu_lock);
>> -out:
>>       mmap_read_unlock(current->mm);
>>       return ret;
>>   }
>>
> 
> .
> 
