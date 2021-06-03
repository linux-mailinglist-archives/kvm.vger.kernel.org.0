Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A1139A128
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhFCMhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:37:07 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3408 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhFCMhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:37:06 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fwld12rD8z67cK;
        Thu,  3 Jun 2021 20:31:33 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:35:18 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:35:17 +0800
Subject: Re: [PATCH v5 5/6] KVM: arm64: Move I-cache flush to the fault
 handlers
To:     Quentin Perret <qperret@google.com>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
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
 <20210415115032.35760-6-wangyanan55@huawei.com> <YLdkVH0G2Lq9vPc5@google.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <66c15129-5f55-58ed-b0ff-801412fe6439@huawei.com>
Date:   Thu, 3 Jun 2021 20:35:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YLdkVH0G2Lq9vPc5@google.com>
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

Hi Quentin,

On 2021/6/2 18:58, Quentin Perret wrote:
> On Thursday 15 Apr 2021 at 19:50:31 (+0800), Yanan Wang wrote:
>> In this patch, we move invalidation of I-cache to the fault handlers to
> Nit: please avoid using 'This patch' in commit messages, see
> Documentation/process/submitting-patches.rst.
Thanks!
I will get rid of this.
>> avoid unnecessary I-cache maintenances. On the map path, invalidate the
>> I-cache if we are going to create an executable stage-2 mapping for guest.
>> And on the permission path, invalidate the I-cache if we are going to add
>> an executable permission to the existing guest stage-2 mapping.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_mmu.h | 15 --------------
>>   arch/arm64/kvm/hyp/pgtable.c     | 35 +++++++++++++++++++++++++++++++-
>>   arch/arm64/kvm/mmu.c             |  9 +-------
>>   3 files changed, 35 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index e9b163c5f023..155492fe5b15 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -187,21 +187,6 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>>   	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
>>   }
>>   
>> -static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
>> -						  unsigned long size)
>> -{
>> -	if (icache_is_aliasing()) {
>> -		/* any kind of VIPT cache */
>> -		__flush_icache_all();
>> -	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
>> -		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
>> -		void *va = page_address(pfn_to_page(pfn));
>> -
>> -		invalidate_icache_range((unsigned long)va,
>> -					(unsigned long)va + size);
>> -	}
>> -}
>> -
>>   void kvm_set_way_flush(struct kvm_vcpu *vcpu);
>>   void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
>>   
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index b480f6d1171e..9f4429d80df0 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -568,6 +568,26 @@ static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
>>   	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
>>   }
>>   
>> +static bool stage2_pte_executable(kvm_pte_t pte)
>> +{
>> +	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
>> +}
>> +
>> +static void stage2_invalidate_icache(void *addr, u64 size)
>> +{
>> +	if (icache_is_aliasing()) {
>> +		/* Any kind of VIPT cache */
>> +		__flush_icache_all();
>> +	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
>
>> +		/*
>> +		 * See comment in __kvm_tlb_flush_vmid_ipa().
>> +		 * Invalidate PIPT, or VPIPT at EL2.
>> +		 */
>> +		invalidate_icache_range((unsigned long)addr,
>> +					(unsigned long)addr + size);
>> +	}
>> +}
>> +
>>   static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>>   			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
>>   {
>> @@ -618,6 +638,10 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>>   		if (stage2_pte_cacheable(pgt, new) && !stage2_has_fwb(pgt))
>>   			__flush_dcache_area(mm_ops->phys_to_virt(phys),
>>   					    granule);
>> +
>> +		if (stage2_pte_executable(new))
>> +			stage2_invalidate_icache(mm_ops->phys_to_virt(phys),
>> +						 granule);
>>   	}
>>   
>>   	smp_store_release(ptep, new);
>> @@ -896,8 +920,17 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>>   	 * but worst-case the access flag update gets lost and will be
>>   	 * set on the next access instead.
>>   	 */
>> -	if (data->pte != pte)
>> +	if (data->pte != pte) {
>> +		/*
>> +		 * Invalidate the instruction cache before updating
>> +		 * if we are going to add the executable permission
>> +		 * for the guest stage-2 PTE.
>> +		 */
>> +		if (!stage2_pte_executable(*ptep) && stage2_pte_executable(pte))
>> +			stage2_invalidate_icache(kvm_pte_follow(pte, data->mm_ops),
>> +						 kvm_granule_size(level));
>>   		WRITE_ONCE(*ptep, pte);
>> +	}
> As for the dcache stuff, it seems like this would be best placed in an
> optional mm_ops callback, and have the kernel implement it.
I think so, that is the preferred way.

Thanks,
Yanan
> Thanks,
> Quentin
> .

