Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F7B32549B
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 18:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBYRjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 12:39:39 -0500
Received: from foss.arm.com ([217.140.110.172]:42924 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhBYRji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 12:39:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA6731063;
        Thu, 25 Feb 2021 09:38:52 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C06A73F73D;
        Thu, 25 Feb 2021 09:38:51 -0800 (PST)
Subject: Re: [RFC PATCH 1/4] KVM: arm64: Move the clean of dcache to the map
 handler
To:     Marc Zyngier <maz@kernel.org>, Yanan Wang <wangyanan55@huawei.com>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20210208112250.163568-1-wangyanan55@huawei.com>
 <20210208112250.163568-2-wangyanan55@huawei.com>
 <871rd41ngf.wl-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <43f05bfa-6b8b-a7d3-4355-0f1486aa6634@arm.com>
Date:   Thu, 25 Feb 2021 17:39:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <871rd41ngf.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2/25/21 9:55 AM, Marc Zyngier wrote:
> Hi Yanan,
>
> On Mon, 08 Feb 2021 11:22:47 +0000,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> We currently uniformly clean dcache in user_mem_abort() before calling the
>> fault handlers, if we take a translation fault and the pfn is cacheable.
>> But if there are concurrent translation faults on the same page or block,
>> clean of dcache for the first time is necessary while the others are not.
>>
>> By moving clean of dcache to the map handler, we can easily identify the
>> conditions where CMOs are really needed and avoid the unnecessary ones.
>> As it's a time consuming process to perform CMOs especially when flushing
>> a block range, so this solution reduces much load of kvm and improve the
>> efficiency of creating mappings.
> That's an interesting approach. However, wouldn't it be better to
> identify early that there is already something mapped, and return to
> the guest ASAP?

Wouldn't that introduce overhead for the common case, when there's only one VCPU
that faults on an address? For each data abort caused by a missing stage 2 entry
we would now have to determine if the IPA isn't already mapped and that means
walking the stage 2 tables.

Or am I mistaken and either:

(a) The common case is multiple simultaneous translation faults from different
VCPUs on the same IPA. Or

(b) There's a fast way to check if an IPA is mapped at stage 2 and the overhead
would be negligible.

>
> Can you quantify the benefit of this patch alone?
>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>  arch/arm64/include/asm/kvm_mmu.h | 16 --------------
>>  arch/arm64/kvm/hyp/pgtable.c     | 38 ++++++++++++++++++++------------
>>  arch/arm64/kvm/mmu.c             | 14 +++---------
>>  3 files changed, 27 insertions(+), 41 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index e52d82aeadca..4ec9879e82ed 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -204,22 +204,6 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>>  	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
>>  }
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
>>  static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
>>  						  unsigned long size)
>>  {
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index 4d177ce1d536..2f4f87021980 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -464,6 +464,26 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
>>  	return 0;
>>  }
>>  
>> +static bool stage2_pte_cacheable(kvm_pte_t pte)
>> +{
>> +	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
>> +	return memattr == PAGE_S2_MEMATTR(NORMAL);
>> +}
>> +
>> +static void stage2_flush_dcache(void *addr, u64 size)
>> +{
>> +	/*
>> +	 * With FWB, we ensure that the guest always accesses memory using
>> +	 * cacheable attributes, and we don't have to clean to PoC when
>> +	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
>> +	 * PoU is not required either in this case.
>> +	 */
>> +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>> +		return;
>> +
>> +	__flush_dcache_area(addr, size);
>> +}
>> +
>>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>>  				      kvm_pte_t *ptep,
>>  				      struct stage2_map_data *data)
>> @@ -495,6 +515,10 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>>  		put_page(page);
>>  	}
>>  
>> +	/* Flush data cache before installation of the new PTE */
>> +	if (stage2_pte_cacheable(new))
>> +		stage2_flush_dcache(__va(phys), granule);
>> +
>>  	smp_store_release(ptep, new);
>>  	get_page(page);
>>  	data->phys += granule;
>> @@ -651,20 +675,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>  	return ret;
>>  }
>>  
>> -static void stage2_flush_dcache(void *addr, u64 size)
>> -{
>> -	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>> -		return;
>> -
>> -	__flush_dcache_area(addr, size);
>> -}
>> -
>> -static bool stage2_pte_cacheable(kvm_pte_t pte)
>> -{
>> -	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
>> -	return memattr == PAGE_S2_MEMATTR(NORMAL);
>> -}
>> -
>>  static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>>  			       enum kvm_pgtable_walk_flags flag,
>>  			       void * const arg)
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 77cb2d28f2a4..d151927a7d62 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -609,11 +609,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>>  	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>>  }
>>  
>> -static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
>> -{
>> -	__clean_dcache_guest_page(pfn, size);
>> -}
>> -
>>  static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>>  {
>>  	__invalidate_icache_guest_page(pfn, size);
>> @@ -882,9 +877,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (writable)
>>  		prot |= KVM_PGTABLE_PROT_W;
>>  
>> -	if (fault_status != FSC_PERM && !device)
>> -		clean_dcache_guest_page(pfn, vma_pagesize);
>> -
>>  	if (exec_fault) {
>>  		prot |= KVM_PGTABLE_PROT_X;
>>  		invalidate_icache_guest_page(pfn, vma_pagesize);
> It seems that the I-side CMO now happens *before* the D-side, which
> seems odd. What prevents the CPU from speculatively fetching
> instructions in the interval? I would also feel much more confident if
> the two were kept close together.

I noticed yet another thing which I don't understand. When the CPU has the
ARM64_HAS_CACHE_DIC featue (CTR_EL0.DIC = 1), which means instruction invalidation
is not required for data to instruction coherence, we still do the icache
invalidation. I am wondering if the invalidation is necessary in this case.

If it's not, then I think it's correct (and straightforward) to move the icache
invalidation to stage2_map_walker_try_leaf() after the dcache clean+inval and make
it depend on the new mapping being executable *and*
!cpus_have_const_cap(ARM64_HAS_CACHE_DIC).

If the icache invalidation is required even if ARM64_HAS_CACHE_DIC is present,
then I'm not sure how we can distinguish between setting the executable
permissions because exec_fault (the code above) and setting the same permissions
because cpus_have_const_cap(ARM64_HAS_CACHE_DIC) (the code immediately following
the snippet above).

Thanks,

Alex

>
> Thanks,
>
> 	M.
>
