Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D20035FFEE
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 04:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhDOCV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 22:21:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16920 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhDOCVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 22:21:25 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FLNLz5HXXzjZtV;
        Thu, 15 Apr 2021 10:19:07 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 10:20:52 +0800
Subject: Re: [PATCH v3 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     Marc Zyngier <maz@kernel.org>
References: <20210414065109.8616-1-zhukeqian1@huawei.com>
 <20210414065109.8616-3-zhukeqian1@huawei.com> <87pmyxme2m.wl-maz@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <wanghaibin.wang@huawei.com>,
        Santosh Shukla <sashukla@nvidia.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <b434317f-ef6d-1d91-0189-8343c404c88c@huawei.com>
Date:   Thu, 15 Apr 2021 10:20:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <87pmyxme2m.wl-maz@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/4/14 17:05, Marc Zyngier wrote:
> + Santosh, who found some interesting bugs in that area before.
> 
> On Wed, 14 Apr 2021 07:51:09 +0100,
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
>>  arch/arm64/kvm/mmu.c | 37 +++++++++++++++++++++++++++++++++----
>>  1 file changed, 33 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c59af5ca01b0..1a6d96169d60 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -624,6 +624,31 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>>  }
>>  
>> +/*
>> + * Find a max mapping size that properly insides the vma. And hva and pa must
>> + * have the same alignment to this mapping size. It's rough as there are still
>> + * other restrictions, will be checked by fault_supports_stage2_huge_mapping().
>> + */
>> +static short device_rough_page_shift(struct vm_area_struct *vma,
>> +				     unsigned long hva)
> 
> My earlier question still stands. Under which circumstances would this
> function return something that is *not* the final mapping size? I
> really don't see a reason why this would not return the final mapping
> size.

IIUC, all the restrictions are about alignment and area boundary.

That's to say, HVA, IPA and PA must have same alignment within the mapping size.
And the areas are memslot and vma, which means the mapping size must properly fit
into the memslot and vma.

In this function, we just checked the alignment of HVA and PA, and the boundary of vma.
So we still need to check the alignment of HVA and IPA, and the boundary of memslot.
These will be checked by fault_supports_stage2_huge_mapping().

> 
>> +{
>> +	phys_addr_t pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>> +
>> +#ifndef __PAGETABLE_PMD_FOLDED
>> +	if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
>> +	    ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
>> +	    ALIGN(hva, PUD_SIZE) <= vma->vm_end)
>> +		return PUD_SHIFT;
>> +#endif
>> +
>> +	if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
>> +	    ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
>> +	    ALIGN(hva, PMD_SIZE) <= vma->vm_end)
>> +		return PMD_SHIFT;
>> +
>> +	return PAGE_SHIFT;
>> +}
>> +
>>  static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>>  					       unsigned long hva,
>>  					       unsigned long map_size)
>> @@ -769,7 +794,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
>> @@ -780,11 +808,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  	if (is_vm_hugetlb_page(vma))
>>  		vma_shift = huge_page_shift(hstate_vma(vma));
>> +	else if (vma->vm_flags & VM_PFNMAP)
>> +		vma_shift = device_rough_page_shift(vma, hva);
> 
> What prevents a VMA from having both VM_HUGETLB and VM_PFNMAP? This is
> pretty unlikely, but I'd like to see this case catered for.
> 
I'm not sure whether VM_HUGETLB and VM_PFNMAP are compatible, and I failed to find a case.

VM_PFNMAP is used for page-ranges managed without "struct page", just pure PFN.
IIUC, VM_HUGETLB is used for hugetlbfs, which always has "struct page".
So I think they should not be compatible, otherwise it's a bug of driver.

>>  	else
>>  		vma_shift = PAGE_SHIFT;
>>  
>> -	if (logging_active ||
>> -	    (vma->vm_flags & VM_PFNMAP)) {
>> +	if (logging_active) {
>>  		force_pte = true;
>>  		vma_shift = PAGE_SHIFT;
>>  	}
>> @@ -855,7 +884,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  	if (kvm_is_device_pfn(pfn)) {
>>  		device = true;
>> -		force_pte = true;
>> +		force_pte = (vma_pagesize == PAGE_SIZE);
> 
> Why do we need to set force_pte if we are already dealing with
> PAGE_SIZE? I guess you are doing this for the sake of avoiding the
> call to transparent_hugepage_adjust(), right?
Yes.

> 
> I'd rather you simply don't try to upgrade a device mapping by
> explicitly checking for this and keep force_pte for *memory*
> exclusively.
Agree, that's better.

> 
> Santosh, can you please take a look at this series and try to see if
> the problem you fixed in [1] (which ended up as commit 91a2c34b7d6f)
> is still OK with this series?
I searched the initial version[*], VM_PFNMAP is set when we call gfn_to_pfn_prot()->vma_mmio_fault()->remap_pfn_range().
Then the check of VM_PFNMAP in user_mem_abort() failed, so we will try to call transparent_hugepage_adjust() for device pfn.

In that case, our logic of trying block mapping for MMIO is not used. And we still set force_pte for device pfn, so
this bugfix is not affected. Santosh, do you agree that?

I still found that the reason vfio_pci does not have this bug. vfio_pci set VM_PFNMAP for vma when userspace calls mmap().
I will apply this logic for vfio_mdev too, let's see what vfio maintainer think about it.


Thanks,
Keqian.

[*] https://lore.kernel.org/kvmarm/1603297010-18787-1-git-send-email-sashukla@nvidia.com/

> 
>>  	} else if (logging_active && !write_fault) {
>>  		/*
>>  		 * Only actually map the page as writable if this was a write
> 
> Thanks,
> 
> 	M.
> 
> [1] https://lore.kernel.org/kvmarm/1603711447-11998-1-git-send-email-sashukla@nvidia.com/
> 
