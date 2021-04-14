Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4445635EB18
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 04:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239707AbhDNCt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 22:49:27 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15674 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346823AbhDNCtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 22:49:21 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FKn0Z05DMzpXFS;
        Wed, 14 Apr 2021 10:46:06 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 10:48:50 +0800
Subject: Re: [RFC PATCH v2 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     Marc Zyngier <maz@kernel.org>
References: <20210316134338.18052-1-zhukeqian1@huawei.com>
 <20210316134338.18052-3-zhukeqian1@huawei.com> <878s5up71v.wl-maz@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <a72d4b34-1088-70b8-2cf9-628119fbbb74@huawei.com>
Date:   Wed, 14 Apr 2021 10:48:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <878s5up71v.wl-maz@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

I think I have fully tested this patch. The next step is to do some restriction on
HVA in vfio module, so we can build block mapping for it with a higher probability.

Is there anything to improve? If not, could you apply it? ^_^

Thanks,
Keqian

On 2021/4/7 21:18, Marc Zyngier wrote:
> On Tue, 16 Mar 2021 13:43:38 +0000,
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>
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
>> This adds device_rough_page_shift() to check these two points when
>> selecting block mapping size.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>
>> Mainly for RFC, not fully tested. I will fully test it when the
>> code logic is well accepted.
>>
>> ---
>>  arch/arm64/kvm/mmu.c | 42 ++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 38 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c59af5ca01b0..224aa15eb4d9 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -624,6 +624,36 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>>  }
>>  
>> +/*
>> + * Find a mapping size that properly insides the intersection of vma and
>> + * memslot. And hva and pa have the same alignment to this mapping size.
>> + * It's rough because there are still other restrictions, which will be
>> + * checked by the following fault_supports_stage2_huge_mapping().
> 
> I don't think these restrictions make complete sense to me. If this is
> a PFNMAP VMA, we should use the biggest mapping size that covers the
> VMA, and not more than the VMA.
> 
>> + */
>> +static short device_rough_page_shift(struct kvm_memory_slot *memslot,
>> +				     struct vm_area_struct *vma,
>> +				     unsigned long hva)
>> +{
>> +	size_t size = memslot->npages * PAGE_SIZE;
>> +	hva_t sec_start = max(memslot->userspace_addr, vma->vm_start);
>> +	hva_t sec_end = min(memslot->userspace_addr + size, vma->vm_end);
>> +	phys_addr_t pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>> +
>> +#ifndef __PAGETABLE_PMD_FOLDED
>> +	if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
>> +	    ALIGN_DOWN(hva, PUD_SIZE) >= sec_start &&
>> +	    ALIGN(hva, PUD_SIZE) <= sec_end)
>> +		return PUD_SHIFT;
>> +#endif
>> +
>> +	if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
>> +	    ALIGN_DOWN(hva, PMD_SIZE) >= sec_start &&
>> +	    ALIGN(hva, PMD_SIZE) <= sec_end)
>> +		return PMD_SHIFT;
>> +
>> +	return PAGE_SHIFT;
>> +}
>> +
>>  static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>>  					       unsigned long hva,
>>  					       unsigned long map_size)
>> @@ -769,7 +799,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  		return -EFAULT;
>>  	}
>>  
>> -	/* Let's check if we will get back a huge page backed by hugetlbfs */
>> +	/*
>> +	 * Let's check if we will get back a huge page backed by hugetlbfs, or
>> +	 * get block mapping for device MMIO region.
>> +	 */
>>  	mmap_read_lock(current->mm);
>>  	vma = find_vma_intersection(current->mm, hva, hva + 1);
>>  	if (unlikely(!vma)) {
>> @@ -780,11 +813,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  	if (is_vm_hugetlb_page(vma))
>>  		vma_shift = huge_page_shift(hstate_vma(vma));
>> +	else if (vma->vm_flags & VM_PFNMAP)
>> +		vma_shift = device_rough_page_shift(memslot, vma, hva);
>>  	else
>>  		vma_shift = PAGE_SHIFT;
>>  
>> -	if (logging_active ||
>> -	    (vma->vm_flags & VM_PFNMAP)) {
>> +	if (logging_active) {
>>  		force_pte = true;
>>  		vma_shift = PAGE_SHIFT;
> 
> But why should we downgrade to page-size mappings if logging? This is
> a device, and you aren't moving the device around, are you? Or is your
> device actually memory with a device mapping that you are trying to
> migrate?
> 
>>  	}
>> @@ -855,7 +889,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  	if (kvm_is_device_pfn(pfn)) {
>>  		device = true;
>> -		force_pte = true;
>> +		force_pte = (vma_pagesize == PAGE_SIZE);
>>  	} else if (logging_active && !write_fault) {
>>  		/*
>>  		 * Only actually map the page as writable if this was a write
>> -- 
>> 2.19.1
>>
>>
> 
> Thanks,
> 
> 	M.
> 
