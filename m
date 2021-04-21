Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAADC36657F
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 08:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhDUGhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 02:37:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17020 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhDUGhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 02:37:39 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FQ9kN3TrFzPshQ;
        Wed, 21 Apr 2021 14:34:04 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Wed, 21 Apr 2021 14:36:56 +0800
Subject: Re: [PATCH v4 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     Gavin Shan <gshan@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-3-zhukeqian1@huawei.com>
 <960e097d-818b-00bc-b2ee-0da17857f862@redhat.com>
CC:     Marc Zyngier <maz@kernel.org>, <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <105a403a-e48b-15bc-44ff-0ff34f7d2194@huawei.com>
Date:   Wed, 21 Apr 2021 14:36:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <960e097d-818b-00bc-b2ee-0da17857f862@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/21 15:52, Gavin Shan wrote:
> Hi Keqian,
> 
> On 4/16/21 12:03 AM, Keqian Zhu wrote:
>> The MMIO region of a device maybe huge (GB level), try to use
>> block mapping in stage2 to speedup both map and unmap.
>>
>> Compared to normal memory mapping, we should consider two more
>> points when try block mapping for MMIO region:
>>
>> 1. For normal memory mapping, the PA(host physical address) and
>> HVA have same alignment within PUD_SIZE or PMD_SIZE when we use
>> the HVA to request hugepage, so we don't need to consider PA
>> alignment when verifing block mapping. But for device memory
>> mapping, the PA and HVA may have different alignment.
>>
>> 2. For normal memory mapping, we are sure hugepage size properly
>> fit into vma, so we don't check whether the mapping size exceeds
>> the boundary of vma. But for device memory mapping, we should pay
>> attention to this.
>>
>> This adds get_vma_page_shift() to get page shift for both normal
>> memory and device MMIO region, and check these two points when
>> selecting block mapping size for MMIO region.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 51 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c59af5ca01b0..5a1cc7751e6d 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -738,6 +738,35 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>>       return PAGE_SIZE;
>>   }
>>   +static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>> +{
>> +    unsigned long pa;
>> +
>> +    if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
>> +        return huge_page_shift(hstate_vma(vma));
>> +
>> +    if (!(vma->vm_flags & VM_PFNMAP))
>> +        return PAGE_SHIFT;
>> +
>> +    VM_BUG_ON(is_vm_hugetlb_page(vma));
>> +
> 
> I don't understand how VM_PFNMAP is set for hugetlbfs related vma.
> I think they are exclusive, meaning the flag is never set for
> hugetlbfs vma. If it's true, VM_PFNMAP needn't be checked on hugetlbfs
> vma and the VM_BUG_ON() becomes unnecessary.
Yes, but we're not sure all drivers follow this rule. Add a BUG_ON() is
a way to catch issue.

> 
>> +    pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>> +
>> +#ifndef __PAGETABLE_PMD_FOLDED
>> +    if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
>> +        ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
>> +        ALIGN(hva, PUD_SIZE) <= vma->vm_end)
>> +        return PUD_SHIFT;
>> +#endif
>> +
>> +    if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
>> +        ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
>> +        ALIGN(hva, PMD_SIZE) <= vma->vm_end)
>> +        return PMD_SHIFT;
>> +
>> +    return PAGE_SHIFT;
>> +}
>> +
> 
> There is "switch(...)" fallback mechanism in user_mem_abort(). PUD_SIZE/PMD_SIZE
> can be downgraded accordingly if the addresses fails in the alignment check
> by fault_supports_stage2_huge_mapping(). I think it would make user_mem_abort()
> simplified if the logic can be moved to get_vma_page_shift().
> 
> Another question if we need the check from fault_supports_stage2_huge_mapping()
> if VM_PFNMAP area is going to be covered by block mapping. If so, the "switch(...)"
> fallback mechanism needs to be part of get_vma_page_shift().
Yes, Good suggestion. My idea is that we can keep this series simpler and do further
optimization in another patch series. Do you mind to send a patch?

Thanks,
Keqian
