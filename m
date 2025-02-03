Return-Path: <kvm+bounces-37125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81750A257F2
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 12:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6A3518881D0
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 11:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E07202C5A;
	Mon,  3 Feb 2025 11:18:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCAFE20102A;
	Mon,  3 Feb 2025 11:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738581493; cv=none; b=Wpd732fJfm8vMb5Is65iU6XBBj+Ts3De2TP4ENRpJaYve9ky8QDXvVvxon+ZeQX9xp7mMiUF7pss2+i4LM4lHmmIVoNRN02OZzT8D0YaQatUvOi2ylgy3cODLdLjg+DiUIwHIzaMY2ZK41nwtMHCfRW9Myq5tOY6wyjMx+fpry8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738581493; c=relaxed/simple;
	bh=Q0vtxORNYakjV7JbkbI4UxGVRUQsNGTkfnbh8NdEeD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+E6CDW5PXfK0pTXAgqSGkBHQpD/oF5dRwKHgYknYEdoZhMp3NixgLd7dyT6SvqZcVfvo7IY2E4wUMbMjxAcIU5EdY+TDxQ9zRW0snhc+Dlu8ypFmRp5MY0P0lAxFqFUTkALq86BfjkDF0A3eDDlEhCL45Nj76PoExL6zgyXcO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EA5811FB;
	Mon,  3 Feb 2025 03:18:34 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 457093F58B;
	Mon,  3 Feb 2025 03:18:07 -0800 (PST)
Message-ID: <d499c3e7-cc0f-467a-8401-bc53b70259f7@arm.com>
Date: Mon, 3 Feb 2025 11:18:06 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/43] arm64: RME: Allocate/free RECs to match vCPUs
To: Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-13-steven.price@arm.com>
 <9a543b6f-5487-4159-89fb-73d9b6749a01@redhat.com>
 <9174bc24-6217-4663-a370-291d4790a212@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <9174bc24-6217-4663-a370-291d4790a212@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/01/2025 16:40, Steven Price wrote:
> On 29/01/2025 04:50, Gavin Shan wrote:
>> On 12/13/24 1:55 AM, Steven Price wrote:
>>> The RMM maintains a data structure known as the Realm Execution Context
>>> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
>>> virtual CPUs. KVM must delegate memory and request the structures are
>>> created when vCPUs are created, and suitably tear down on destruction.
>>>
>>> RECs must also be supplied with addition pages - auxiliary (or AUX)
>>> granules - for storing the larger registers state (e.g. for SVE). The
>>> number of AUX granules for a REC depends on the parameters with which
>>> the Realm was created - the RMM makes this information available via the
>>> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor
>>> (RD).
>>>
>>> Note that only some of register state for the REC can be set by KVM, the
>>> rest is defined by the RMM (zeroed). The register state then cannot be
>>> changed by KVM after the REC is created (except when the guest
>>> explicitly requests this e.g. by performing a PSCI call). The RMM also
>>> requires that the VMM creates RECs in ascending order of the MPIDR.
>>>
>>> See Realm Management Monitor specification (DEN0137) for more
>>> information:
>>> https://developer.arm.com/documentation/den0137/
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v5:
>>>    * Separate the concept of vcpu_is_rec() and
>>>      kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
>>>      the indication that the VCPU is a REC.
>>> Changes since v2:
>>>    * Free rec->run earlier in kvm_destroy_realm() and adapt to previous
>>> patches.
>>> ---
>>>    arch/arm64/include/asm/kvm_emulate.h |   7 ++
>>>    arch/arm64/include/asm/kvm_host.h    |   3 +
>>>    arch/arm64/include/asm/kvm_rme.h     |  18 ++++
>>>    arch/arm64/kvm/arm.c                 |   9 ++
>>>    arch/arm64/kvm/reset.c               |  11 ++
>>>    arch/arm64/kvm/rme.c                 | 144 +++++++++++++++++++++++++++
>>>    6 files changed, 192 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/
>>> include/asm/kvm_emulate.h
>>> index 27f54a7778aa..ec2b6d9c9c07 100644
>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>> @@ -722,7 +722,14 @@ static inline bool kvm_realm_is_created(struct
>>> kvm *kvm)
>>>      static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>>>    {
>>> +    if (static_branch_unlikely(&kvm_rme_is_available))
>>> +        return vcpu_has_feature(vcpu, KVM_ARM_VCPU_REC);
>>>        return false;
>>>    }
>>>    
>>
>> It seems the check on kvm_rme_is_available is unnecessary because
>> KVM_ARM_VCPU_REC
>> is possible to be true only when kvm_rme_is_available is true.
> 
> Similar to a previous patch - the check of the static key is to avoid
> overhead on systems without RME.
> 
>>> +static inline bool kvm_arm_vcpu_rec_finalized(struct kvm_vcpu *vcpu)
>>> +{
>>> +    return vcpu->arch.rec.mpidr != INVALID_HWID;
>>> +}
>>> +
>>>    #endif /* __ARM64_KVM_EMULATE_H__ */
>>
>> I would suggest to rename to kvm_arm_rec_finalized() since vCPU and REC are
>> similar objects at the same level. It'd better to avoid duplicate object
>> name reference in the function name.
> 
> Ack
> 
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/
>>> asm/kvm_host.h
>>> index 8482638dce3b..220195c727ef 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -789,6 +789,9 @@ struct kvm_vcpu_arch {
>>>          /* Per-vcpu CCSIDR override or NULL */
>>>        u32 *ccsidr;
>>> +
>>> +    /* Realm meta data */
>>> +    struct realm_rec rec;
>>>    };
>>>      /*
>>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>>> asm/kvm_rme.h
>>> index 32bdedf1d866..62d4a63d3035 100644
>>> --- a/arch/arm64/include/asm/kvm_rme.h
>>> +++ b/arch/arm64/include/asm/kvm_rme.h
>>> @@ -6,6 +6,7 @@
>>>    #ifndef __ASM_KVM_RME_H
>>>    #define __ASM_KVM_RME_H
>>>    +#include <asm/rmi_smc.h>
>>>    #include <uapi/linux/kvm.h>
>>>      /**
>>> @@ -65,6 +66,21 @@ struct realm {
>>>        unsigned int ia_bits;
>>>    };
>>>    +/**
>>> + * struct realm_rec - Additional per VCPU data for a Realm
>>> + *
>>> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify
>>> this VCPU
>>> + * @rec_page: Kernel VA of the RMM's private page for this REC
>>> + * @aux_pages: Additional pages private to the RMM for this REC
>>> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
>>> + */
>>> +struct realm_rec {
>>> +    unsigned long mpidr;
>>> +    void *rec_page;
>>> +    struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
>>> +    struct rec_run *run;
>>> +};
>>> +
>>>    void kvm_init_rme(void);
>>>    u32 kvm_realm_ipa_limit(void);
>>>    @@ -72,6 +88,8 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct
>>> kvm_enable_cap *cap);
>>>    int kvm_init_realm_vm(struct kvm *kvm);
>>>    void kvm_destroy_realm(struct kvm *kvm);
>>>    void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>>> +int kvm_create_rec(struct kvm_vcpu *vcpu);
>>> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>>      #define RMM_RTT_BLOCK_LEVEL    2
>>>    #define RMM_RTT_MAX_LEVEL    3
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 73016e1e0067..2d97147651be 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -525,6 +525,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>>        /* Force users to call KVM_ARM_VCPU_INIT */
>>>        vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>>>    +    vcpu->arch.rec.mpidr = INVALID_HWID;
>>> +
>>>        vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>>>          /* Set up the timer */
>>> @@ -1467,6 +1469,9 @@ static unsigned long
>>> system_supported_vcpu_features(void)
>>>        if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>>>            clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
>>>    +    if (!static_branch_unlikely(&kvm_rme_is_available))
>>> +        clear_bit(KVM_ARM_VCPU_REC, &features);
>>> +
>>>        return features;
>>>    }
>>>    @@ -1506,6 +1511,10 @@ static int
>>> kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>>>        if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
>>>            return -EINVAL;
>>>    +    /* RME is incompatible with AArch32 */
>>> +    if (test_bit(KVM_ARM_VCPU_REC, &features))
>>> +        return -EINVAL;
>>> +
>>>        return 0;
>>>    }
>>>    
>>
>> One corner case seems missed in kvm_vcpu_init_check_features(). It's
>> allowed to
>> initialize a vCPU with REC feature even kvm_is_realm(kvm) is false.
>> Hopefully,
>> I didn't miss something.
> 
> Ah, yes good point. I'll pass a kvm pointer to
> kvm_vcpu_init_check_features() and use kvm_is_realm() in there.

nit: kvm is available from the VCPU via vcpu->kvm

Cheers
Suzuki



