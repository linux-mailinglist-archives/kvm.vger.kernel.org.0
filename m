Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40A0357F2E
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 11:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhDHJbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 05:31:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3080 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhDHJbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 05:31:34 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FGGBt1gFkzWVRR;
        Thu,  8 Apr 2021 17:27:50 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 8 Apr 2021 17:31:19 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 17:31:18 +0800
Subject: Re: [RFC PATCH v3 2/2] KVM: arm64: Distinguish cases of memcache
 allocations completely
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        <wanghaibin.wang@huawei.com>, <zhukeqian1@huawei.com>,
        <yuzenghui@huawei.com>
References: <20210326031654.3716-1-wangyanan55@huawei.com>
 <20210326031654.3716-3-wangyanan55@huawei.com>
 <4348b555-2a38-6f00-8ef0-0d5fd801d753@arm.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <2f7872af-b5dc-9e81-574d-928849ad473c@huawei.com>
Date:   Thu, 8 Apr 2021 17:31:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4348b555-2a38-6f00-8ef0-0d5fd801d753@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/4/7 23:35, Alexandru Elisei wrote:
> Hi Yanan,
>
> On 3/26/21 3:16 AM, Yanan Wang wrote:
>> With a guest translation fault, the memcache pages are not needed if KVM
>> is only about to install a new leaf entry into the existing page table.
>> And with a guest permission fault, the memcache pages are also not needed
>> for a write_fault in dirty-logging time if KVM is only about to update
>> the existing leaf entry instead of collapsing a block entry into a table.
>>
>> By comparing fault_granule and vma_pagesize, cases that require allocations
>> from memcache and cases that don't can be distinguished completely.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 25 ++++++++++++-------------
>>   1 file changed, 12 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 1eec9f63bc6f..05af40dc60c1 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -810,19 +810,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	gfn = fault_ipa >> PAGE_SHIFT;
>>   	mmap_read_unlock(current->mm);
>>   
>> -	/*
>> -	 * Permission faults just need to update the existing leaf entry,
>> -	 * and so normally don't require allocations from the memcache. The
>> -	 * only exception to this is when dirty logging is enabled at runtime
>> -	 * and a write fault needs to collapse a block entry into a table.
>> -	 */
>> -	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
>> -		ret = kvm_mmu_topup_memory_cache(memcache,
>> -						 kvm_mmu_cache_min_pages(kvm));
>> -		if (ret)
>> -			return ret;
>> -	}
>> -
>>   	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>>   	/*
>>   	 * Ensure the read of mmu_notifier_seq happens before we call
>> @@ -880,6 +867,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
>>   		prot |= KVM_PGTABLE_PROT_X;
>>   
>> +	/*
>> +	 * Allocations from the memcache are required only when granule of the
>> +	 * lookup level where the guest fault happened exceeds vma_pagesize,
>> +	 * which means new page tables will be created in the fault handlers.
>> +	 */
>> +	if (fault_granule > vma_pagesize) {
>> +		ret = kvm_mmu_topup_memory_cache(memcache,
>> +						 kvm_mmu_cache_min_pages(kvm));
>> +		if (ret)
>> +			return ret;
>> +	}
> As I explained in v1 [1], this looks correct to me. I still think that someone
> else should have a look, but if Marc decides to pick up this patch as-is, he can
> add my Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>.
Thanks again for this, Alex!

Hi Marc, Will,
Any thoughts about this patch?

Thanks,
Yanan
> [1] https://lore.kernel.org/lkml/2c65bff2-be7f-b20c-9265-939bc73185b6@arm.com/
>
> Thanks,
>
> Alex
>
>> +
>>   	/*
>>   	 * Under the premise of getting a FSC_PERM fault, we just need to relax
>>   	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
> .
