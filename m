Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7919139A18B
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhFCMy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:54:26 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4293 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhFCMyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:54:25 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fwlzt02B3z1BH07;
        Thu,  3 Jun 2021 20:47:54 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:52:38 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:52:37 +0800
Subject: Re: [PATCH v5 6/6] KVM: arm64: Distinguish cases of memcache
 allocations completely
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
 <20210415115032.35760-7-wangyanan55@huawei.com> <YLdmiTfgz1EqBsJd@google.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <7412ce3d-1144-e2ba-d897-79b0059be453@huawei.com>
Date:   Thu, 3 Jun 2021 20:52:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YLdmiTfgz1EqBsJd@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Quentin,

On 2021/6/2 19:07, Quentin Perret wrote:
> On Thursday 15 Apr 2021 at 19:50:32 (+0800), Yanan Wang wrote:
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
>> index aa536392b308..9e35aa5d29f2 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -895,19 +895,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
>> @@ -970,6 +957,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
> You're now doing the top-up in the kvm->mmu_lock critical section. Isn't
> this more or less what we try to avoid by using a memory cache?
Oh, right!

This patch intended to clean up the code and avoid the unnecessary top-ups,
but it's a bad idea to do the top-up when holding mmu_lock. I will rearrange
this part and keep it where it should be.

Thanks,
Yanan
> Thanks,
> Quentin
> .

