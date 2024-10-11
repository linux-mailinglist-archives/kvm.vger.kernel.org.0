Return-Path: <kvm+bounces-28636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA0A299A617
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 16:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C80F81C23702
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 14:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1634E21B44E;
	Fri, 11 Oct 2024 14:14:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B6E21B434;
	Fri, 11 Oct 2024 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728656078; cv=none; b=KVaQQrmIucc9Th3961/8+BFl9NAzDuQKVpSP0oLmR/f9QJUk98YeD08eak51YtpbGAovyRm4tVJZgO+rWk2xabnULBQHiwuHXlYNnPeuCgsodIGClPV6aiS0I5MWBYId2trdSxL8obJK+Kcze4YBdKDe79aMmWz2LOmmReIs8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728656078; c=relaxed/simple;
	bh=DbiVmwouyJNeA7alfmbBFu8o0wUvXSoDNmpEX8DrDl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rIT3gb3J3n7FuZrpwsapS4c8bXRYyA8sQVbbuXcxuGHvkinFxkxLe40bmuZpz78EniuMrZkMEg2RhVoPCg4OxP3Vh6tVA0R8qNiXt9axbOot1S/elDoBwOGjjSiC2YqLmoeQOq5oM7xTOxSfiFGvhb8E93xfRLsG2tI+7ftqub4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A372B152B;
	Fri, 11 Oct 2024 07:15:05 -0700 (PDT)
Received: from [10.1.31.21] (e122027.cambridge.arm.com [10.1.31.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 045923F5A1;
	Fri, 11 Oct 2024 07:14:32 -0700 (PDT)
Message-ID: <6c7c7409-c3d2-4e77-b4d4-1e0042466fc0@arm.com>
Date: Fri, 11 Oct 2024 15:14:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/11] arm64: rsi: Add support for checking whether an
 MMIO is protected
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-5-steven.price@arm.com>
 <2b161369-b9b3-4103-9cf4-fa316dec0ca1@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <2b161369-b9b3-4103-9cf4-fa316dec0ca1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 08/10/2024 01:24, Gavin Shan wrote:
> On 10/5/24 12:42 AM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> On Arm CCA, with RMM-v1.0, all MMIO regions are shared. However, in
>> the future, an Arm CCA-v1.0 compliant guest may be run in a lesser
>> privileged partition in the Realm World (with Arm CCA-v1.1 Planes
>> feature). In this case, some of the MMIO regions may be emulated
>> by a higher privileged component in the Realm world, i.e, protected.
>>
>> Thus the guest must decide today, whether a given MMIO region is shared
>> vs Protected and create the stage1 mapping accordingly. On Arm CCA, this
>> detection is based on the "IPA State" (RIPAS == RIPAS_IO). Provide a
>> helper to run this check on a given range of MMIO.
>>
>> Also, provide a arm64 helper which may be hooked in by other solutions.
>>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v5
>> ---
>>   arch/arm64/include/asm/io.h       |  8 ++++++++
>>   arch/arm64/include/asm/rsi.h      |  2 ++
>>   arch/arm64/include/asm/rsi_cmds.h | 21 +++++++++++++++++++++
>>   arch/arm64/kernel/rsi.c           | 26 ++++++++++++++++++++++++++
>>   4 files changed, 57 insertions(+)
>>
> 
> With the following nitpick addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>> index 1ada23a6ec19..cce445ff8e3f 100644
>> --- a/arch/arm64/include/asm/io.h
>> +++ b/arch/arm64/include/asm/io.h
>> @@ -17,6 +17,7 @@
>>   #include <asm/early_ioremap.h>
>>   #include <asm/alternative.h>
>>   #include <asm/cpufeature.h>
>> +#include <asm/rsi.h>
>>     /*
>>    * Generic IO read/write.  These perform native-endian accesses.
>> @@ -318,4 +319,11 @@ extern bool
>> arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
>>                       unsigned long flags);
>>   #define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
>>   +static inline bool arm64_is_mmio_private(phys_addr_t phys_addr,
>> size_t size)
>> +{
>> +    if (unlikely(is_realm_world()))
>> +        return arm64_is_protected_mmio(phys_addr, size);
>> +    return false;
>> +}
>> +
> 
> The function names (arm64_is_{mmio_private, protected_mmio} are
> indicators to the
> MMIO region's state or property. arm64_is_mmio_private() indicates the
> MMIO region
> is 'private MMIO' while arm64_is_protected_mmio() indicates the MMIO
> region is
> 'protected MMIO'. They are equivalent and it may be worthy to unify the
> function
> names (indicators) as below.
> 
>   option#1                         option#2
>   --------                         --------
>   arm64_is_private_mmio            arm64_is_protected_mmio
>   __arm64_is_private_mmio          __arm64_is_protected_mmio
> 

Very valid point, I think I prefer option #2 here - "protected" is the
architectural term in CCA.

Thanks,
Steve

>>   #endif    /* __ASM_IO_H */
>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>> index acba065eb00e..42ff93c7b0ba 100644
>> --- a/arch/arm64/include/asm/rsi.h
>> +++ b/arch/arm64/include/asm/rsi.h
>> @@ -14,6 +14,8 @@ DECLARE_STATIC_KEY_FALSE(rsi_present);
>>     void __init arm64_rsi_init(void);
>>   +bool arm64_is_protected_mmio(phys_addr_t base, size_t size);
>> +
>>   static inline bool is_realm_world(void)
>>   {
>>       return static_branch_unlikely(&rsi_present);
>> diff --git a/arch/arm64/include/asm/rsi_cmds.h
>> b/arch/arm64/include/asm/rsi_cmds.h
>> index b661331c9204..fdb47f690307 100644
>> --- a/arch/arm64/include/asm/rsi_cmds.h
>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>> @@ -45,6 +45,27 @@ static inline unsigned long
>> rsi_get_realm_config(struct realm_config *cfg)
>>       return res.a0;
>>   }
>>   +static inline unsigned long rsi_ipa_state_get(phys_addr_t start,
>> +                          phys_addr_t end,
>> +                          enum ripas *state,
>> +                          phys_addr_t *top)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_smc(SMC_RSI_IPA_STATE_GET,
>> +              start, end, 0, 0, 0, 0, 0,
>> +              &res);
>> +
>> +    if (res.a0 == RSI_SUCCESS) {
>> +        if (top)
>> +            *top = res.a1;
>> +        if (state)
>> +            *state = res.a2;
>> +    }
>> +
>> +    return res.a0;
>> +}
>> +
>>   static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
>>                                phys_addr_t end,
>>                                enum ripas state,
>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> index a6495a64d9bb..d7bba4cee627 100644
>> --- a/arch/arm64/kernel/rsi.c
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -66,6 +66,32 @@ static void __init arm64_rsi_setup_memory(void)
>>       }
>>   }
>>   +bool arm64_is_protected_mmio(phys_addr_t base, size_t size)
>> +{
>> +    enum ripas ripas;
>> +    phys_addr_t end, top;
>> +
>> +    /* Overflow ? */
>> +    if (WARN_ON(base + size <= base))
>> +        return false;
>> +
>> +    end = ALIGN(base + size, RSI_GRANULE_SIZE);
>> +    base = ALIGN_DOWN(base, RSI_GRANULE_SIZE);
>> +
>> +    while (base < end) {
>> +        if (WARN_ON(rsi_ipa_state_get(base, end, &ripas, &top)))
>> +            break;
>> +        if (WARN_ON(top <= base))
>> +            break;
>> +        if (ripas != RSI_RIPAS_DEV)
>> +            break;
>> +        base = top;
>> +    }
>> +
>> +    return base >= end;
>> +}
>> +EXPORT_SYMBOL(arm64_is_protected_mmio);
>> +
> 
> The function may be worthy to be renamed to __arm64_is_private_mmio, as
> explained
> as above.
> 
>>   void __init arm64_rsi_init(void)
>>   {
>>       if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
> 
> Thanks,
> Gavin
> 


