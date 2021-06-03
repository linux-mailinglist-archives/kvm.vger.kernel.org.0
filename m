Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCF339A10E
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhFCMfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:35:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2977 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhFCMfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:35:38 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FwlcD5fQjz6tv8;
        Thu,  3 Jun 2021 20:30:52 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:33:51 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:33:49 +0800
Subject: Re: [PATCH v5 2/6] KVM: arm64: Move D-cache flush to the fault
 handlers
To:     Marc Zyngier <maz@kernel.org>
CC:     Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-3-wangyanan55@huawei.com>
 <877djc1sca.wl-maz@kernel.org>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <693f645e-f860-4563-e91f-a71efa39d042@huawei.com>
Date:   Thu, 3 Jun 2021 20:33:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <877djc1sca.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/6/2 18:19, Marc Zyngier wrote:
> On Thu, 15 Apr 2021 12:50:28 +0100,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> We currently uniformly permorm CMOs of D-cache and I-cache in function
>> user_mem_abort before calling the fault handlers. If we get concurrent
>> guest faults(e.g. translation faults, permission faults) or some really
>> unnecessary guest faults caused by BBM, CMOs for the first vcpu are
>> necessary while the others later are not.
>>
>> By moving CMOs to the fault handlers, we can easily identify conditions
>> where they are really needed and avoid the unnecessary ones. As it's a
>> time consuming process to perform CMOs especially when flushing a block
>> range, so this solution reduces much load of kvm and improve efficiency
>> of the page table code.
>>
>> This patch only moves clean of D-cache to the map path, and drop the
>> original APIs in mmu.c/mmu.h for D-cache maintenance by using what we
>> already have in pgtable.c. Change about the I-side will come from a
>> later patch.
> But this means that until patch #5, this is broken (invalidation on
> the i-side will happen before the clean to PoU on the d-side). You
> need to keep the series bisectable and not break things in the middle.
> It would be OK to have two set of D-cache CMOs in the interval, for
> example.
Indeed. The D-side change and the I-side changebe put together
into one single patch.
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_mmu.h | 16 ----------------
>>   arch/arm64/kvm/hyp/pgtable.c     | 20 ++++++++++++++------
>>   arch/arm64/kvm/mmu.c             | 14 +++-----------
>>   3 files changed, 17 insertions(+), 33 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 25ed956f9af1..e9b163c5f023 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -187,22 +187,6 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>>   	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
>>   }
>>   
>> -static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
>> -{
>> -	void *va = page_address(pfn_to_page(pfn));
>> -
>> -	/*
>> -	 * With FWB, we ensure that the guest always accesses memory using
>> -	 * cacheable attributes, and we don't have to clean to PoC when
>> -	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
>> -	 * PoU is not required either in this case.
>> -	 */
>> -	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>> -		return;
>> -
>> -	kvm_flush_dcache_to_poc(va, size);
>> -}
>> -
>>   static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
>>   						  unsigned long size)
>>   {
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index c37c1dc4feaf..e3606c9dcec7 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -562,6 +562,12 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>>   	return !!pte;
>>   }
>>   
>> +static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
>> +{
>> +	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
>> +	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
>> +}
>> +
>>   static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>>   			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
>>   {
>> @@ -583,6 +589,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>>   {
>>   	kvm_pte_t new, old = *ptep;
>>   	u64 granule = kvm_granule_size(level), phys = data->phys;
>> +	struct kvm_pgtable *pgt = data->mmu->pgt;
>>   	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>>   
>>   	if (!kvm_block_mapping_supported(addr, end, phys, level))
>> @@ -606,6 +613,13 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>>   		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
>>   	}
>>   
>> +	/* Perform CMOs before installation of the guest stage-2 PTE */
>> +	if (pgt->flags & KVM_PGTABLE_S2_GUEST) {
>> +		if (stage2_pte_cacheable(pgt, new) && !stage2_has_fwb(pgt))
>> +			__flush_dcache_area(mm_ops->phys_to_virt(phys),
>> +					    granule);
>> +	}
> Rather than this, why not provide new callbacks in mm_ops, even if we
> have to provide one that is specific to guests (and let the protected
> stuff do its own thing)?
Thanks!
It's obviously a better idea! By introducing two new optional callbacks
(D-cache handler and I-cache handler), we can avoid code duplication
and make the generic pgtable code much cleaner.
> One thing I really dislike though is that the page-table code is
> starting to be littered with things that are not directly related to
> page tables. We are re-creating the user_mem_abort() mess in a
> different place.
I agree with this too. For the long run, we should try to avoid adding
more and more unrelated things into the page-table code, given that
it is developing to be generic (also supports host S2 now).

As for this series, it does introduce some performance improvement,
although the cost is moving the guest specific cache maintenance to
the page-table handlers. But I think the page-table code will be well
isolated if we put the CMOs as optional callbacks in mm_ops as you
have suggested above.

Thanks,
Yanan
>> +
>>   	smp_store_release(ptep, new);
>>   	if (stage2_pte_is_counted(new))
>>   		mm_ops->get_page(ptep);
>> @@ -798,12 +812,6 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>   	return ret;
>>   }
>>   
>> -static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
>> -{
>> -	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
>> -	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
>> -}
>> -
>>   static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>>   			       enum kvm_pgtable_walk_flags flag,
>>   			       void * const arg)
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 2cfcfc5f4e4e..86f7dd1c234f 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -694,11 +694,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>>   	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>>   }
>>   
>> -static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
>> -{
>> -	__clean_dcache_guest_page(pfn, size);
>> -}
>> -
>>   static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>>   {
>>   	__invalidate_icache_guest_page(pfn, size);
>> @@ -972,9 +967,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	if (writable)
>>   		prot |= KVM_PGTABLE_PROT_W;
>>   
>> -	if (fault_status != FSC_PERM && !device)
>> -		clean_dcache_guest_page(pfn, vma_pagesize);
>> -
>>   	if (exec_fault) {
>>   		prot |= KVM_PGTABLE_PROT_X;
>>   		invalidate_icache_guest_page(pfn, vma_pagesize);
>> @@ -1234,10 +1226,10 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>>   	trace_kvm_set_spte_hva(hva);
>>   
>>   	/*
>> -	 * We've moved a page around, probably through CoW, so let's treat it
>> -	 * just like a translation fault and clean the cache to the PoC.
>> +	 * We've moved a page around, probably through CoW, so let's treat
>> +	 * it just like a translation fault and the map handler will clean
>> +	 * the cache to the PoC.
>>   	 */
>> -	clean_dcache_guest_page(pfn, PAGE_SIZE);
>>   	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
>>   	return 0;
>>   }
> Thanks,
>
> 	M.
>

