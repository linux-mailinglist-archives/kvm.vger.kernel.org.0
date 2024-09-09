Return-Path: <kvm+bounces-26103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1399713C6
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 11:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D69BB249C3
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 09:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B361B375C;
	Mon,  9 Sep 2024 09:31:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14FB81B2501;
	Mon,  9 Sep 2024 09:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725874292; cv=none; b=hlzrMGIxSn3FQFswAImRnW34eIvSh1iTYGi0oUfpgpTz1U/8uFMOabBLuO3IJZ68YHDE1+nZhBgHqh6w7Szs8s7awD1ZkJKfjLLmqIclNsJdBMGPjXBvXI0CZG5uANJiAOFS3gmP1KsV7ddJdM1+cCs3J7rGhiunU9PC4+/NIIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725874292; c=relaxed/simple;
	bh=/LeU09/yb8X79A7M5WmRsenF9Bao67AQn5cY3Xz60kI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M3A/yDqSR/AYb3xVTjgMf9acmerDUC3aZNgAEBZPQlnIH0svg+3Wmd71XY11ShzF+x5dJUSN2ySsi56UcQgKLXf5xYaoSXkzyt90cYz5BylWzc0woyRMV8iVo6vBgOV7+HvjQOEivorPmNKOjPWwHNduk7EGMBpC9QTcLXQcblA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03749FEC;
	Mon,  9 Sep 2024 02:31:58 -0700 (PDT)
Received: from [10.57.74.73] (unknown [10.57.74.73])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66AEB3F66E;
	Mon,  9 Sep 2024 02:31:24 -0700 (PDT)
Message-ID: <00dee9c5-5d5c-4a5e-9a24-22a4c9fe2e67@arm.com>
Date: Mon, 9 Sep 2024 10:31:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/19] arm64: rsi: Add support for checking whether an
 MMIO is protected
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-8-steven.price@arm.com>
 <fe3da777-c6de-451d-8a8a-19fdda8e82e5@redhat.com>
 <8a675a19-52c1-43c7-b560-fbadce0c5145@arm.com>
 <8ed3b6da-8bd2-4c98-9364-8b14c1baae7f@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8ed3b6da-8bd2-4c98-9364-8b14c1baae7f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09/09/2024 00:53, Gavin Shan wrote:
> On 9/6/24 11:55 PM, Steven Price wrote:
>> On 06/09/2024 05:32, Gavin Shan wrote:
>>> On 8/19/24 11:19 PM, Steven Price wrote:
>>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>
>>>> On Arm CCA, with RMM-v1.0, all MMIO regions are shared. However, in
>>>> the future, an Arm CCA-v1.0 compliant guest may be run in a lesser
>>>> privileged partition in the Realm World (with Arm CCA-v1.1 Planes
>>>> feature). In this case, some of the MMIO regions may be emulated
>>>> by a higher privileged component in the Realm world, i.e, protected.
>>>>
>>>> Thus the guest must decide today, whether a given MMIO region is shared
>>>> vs Protected and create the stage1 mapping accordingly. On Arm CCA,
>>>> this
>>>> detection is based on the "IPA State" (RIPAS == RIPAS_IO). Provide a
>>>> helper to run this check on a given range of MMIO.
>>>>
>>>> Also, provide a arm64 helper which may be hooked in by other solutions.
>>>>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> New patch for v5
>>>> ---
>>>>    arch/arm64/include/asm/io.h       |  8 ++++++++
>>>>    arch/arm64/include/asm/rsi.h      |  3 +++
>>>>    arch/arm64/include/asm/rsi_cmds.h | 21 +++++++++++++++++++++
>>>>    arch/arm64/kernel/rsi.c           | 26 ++++++++++++++++++++++++++
>>>>    4 files changed, 58 insertions(+)
> 
> [...]
> 
>>>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>>>> index e968a5c9929e..381a5b9a5333 100644
>>>> --- a/arch/arm64/kernel/rsi.c
>>>> +++ b/arch/arm64/kernel/rsi.c
>>>> @@ -67,6 +67,32 @@ void __init arm64_rsi_setup_memory(void)
>>>>        }
>>>>    }
>>>>    +bool arm64_rsi_is_protected_mmio(phys_addr_t base, size_t size)
>>>> +{
>>>> +    enum ripas ripas;
>>>> +    phys_addr_t end, top;
>>>> +
>>>> +    /* Overflow ? */
>>>> +    if (WARN_ON(base + size < base))
>>>> +        return false;
>>>> +
>>>> +    end = ALIGN(base + size, RSI_GRANULE_SIZE);
>>>> +    base = ALIGN_DOWN(base, RSI_GRANULE_SIZE);
>>>> +
>>>> +    while (base < end) {
>>>> +        if (WARN_ON(rsi_ipa_state_get(base, end, &ripas, &top)))
>>>> +            break;
>>>> +        if (WARN_ON(top <= base))
>>>> +            break;
>>>> +        if (ripas != RSI_RIPAS_IO)
>>>> +            break;
>>>> +        base = top;
>>>> +    }
>>>> +
>>>> +    return (size && base >= end);
>>>> +}
>>>
>>> I don't understand why @size needs to be checked here. Its initial value
>>> taken from the input parameter should be larger than zero and its value
>>> is never updated in the loop. So I'm understanding @size is always
>>> larger
>>> than zero, and the condition would be something like below if I'm
>>> correct.
>>
>> Yes you are correct. I'm not entirely sure why it was written that way.
>> The only change dropping 'size' as you suggest is that a zero-sized
>> region is considered protected. But I'd consider it a bug if this is
>> called with size=0. I'll drop 'size' here.
>>
> 
> The check 'size == 0' could be squeezed to the overflow check if you agree.
> 
>     /* size == 0 or overflow */
>     if (WARN_ON(base + size) <= base)
>         return false;
>     :
>         return (base >= end);
> 

Yes that makes sense, thanks for the suggestion.

>>>         return (base >= end);     /* RSI_RIPAS_IO returned for all
>>> granules */
>>>
>>> Another issue is @top is always zero with the latest tf-rmm. More
>>> details
>>> are provided below.
>>
>> That suggests that you are not actually using the 'latest' tf-rmm ;)
>> (for some definition of 'latest' which might not be obvious!)
>>
>>> From the cover letter:
>>
>>> As mentioned above the new RMM specification means that corresponding
>>> changes need to be made in the RMM, at this time these changes are still
>>> in review (see 'topics/rmm-1.0-rel0-rc1'). So you'll need to fetch the
>>> changes[3] from the gerrit instance until they are pushed to the main
>>> branch.
>>>
>>> [3] https://review.trustedfirmware.org/c/TF-RMM/tf-rmm/+/30485
>>
>> Sorry, I should probably have made this much more prominent in the cover
>> letter.
>>
>> Running something like...
>>
>>   git fetch https://git.trustedfirmware.org/TF-RMM/tf-rmm.git \
>>     refs/changes/85/30485/11
>>
>> ... should get you the latest. Hopefully these changes will get merged
>> to the main branch soon.
>>
> 
> My bad. I didn't check the cover letter in time. With this specific
> TF-RMM branch,
> I'm able to boot the guest with cca/host-v4 and cca/guest-v5. However,
> there are
> messages indicating unhandled system register accesses, as below.

To some extent unhandled system register accesses are expected. The
kernel will probe for features, and if the RMM doesn't support them it
will be emulating those registers as RAZ/WI. I believe RAZ/WI is an
appropriate emulation, so Linux won't have any trouble here, and I don't
think there's anything wrong with Linux probing these registers.

So the question really is whether the RMM needs to have dummy handlers
to silence the 'warnings'. They are currently output using 'INFO' so
priority - so will only be visible in a 'debug' build (or if the log
level has been explicitly set).

Steve

> # ./start.sh
>   Info: # lkvm run -k Image -m 256 -c 2 --name guest-152
>   Info: Removed ghost socket file "/root/.lkvm//guest-152.sock".
> [   rmm ] SMC_RMI_REALM_CREATE          882860000 880856000 > RMI_SUCCESS
> [   rmm ] SMC_RMI_REC_AUX_COUNT         882860000 > RMI_SUCCESS 10
> [   rmm ] SMC_RMI_REC_CREATE            882860000 88bdc5000 88bdc4000 >
> RMI_SUCCESS
> [   rmm ] SMC_RMI_REC_CREATE            882860000 88bdd7000 88bdc4000 >
> RMI_SUCCESS
> [   rmm ] SMC_RMI_REALM_ACTIVATE        882860000 > RMI_SUCCESS
> [   rmm ] Unhandled write S2_0_C0_C2_2
> [   rmm ] Unhandled write S3_3_C9_C14_0
> [   rmm ] SMC_RSI_VERSION               10000 > RSI_SUCCESS 10000 10000
> [   rmm ] SMC_RSI_REALM_CONFIG          82b2b000 > RSI_SUCCESS
> [   rmm ] SMC_RSI_IPA_STATE_SET         80000000 90000000 1 0 >
> RSI_SUCCESS 90000000 0
> [   rmm ] SMC_RSI_IPA_STATE_GET         1000000 1001000 > RSI_SUCCESS
> 1001000 0
>      :
> [    1.835570] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for
> atomic allocations
> [    1.865993] audit: initializing netlink subsys (disabled)
> [    1.891218] audit: type=2000 audit(0.492:1): state=initialized
> audit_enabled=0 res=1
> [    1.899066] thermal_sys: Registered thermal governor 'step_wise'
> [    1.920869] thermal_sys: Registered thermal governor 'power_allocator'
> [    1.944151] cpuidle: using governor menu
> [    1.988588] hw-breakpoint: found 16 breakpoint and 16 watchpoint
> registers.
> [   rmm ] Unhandled write S2_0_C0_C0_5
> [   rmm ] Unhandled write S2_0_C0_C0_4
> [   rmm ] Unhandled write S2_0_C0_C1_5
> [   rmm ] Unhandled write S2_0_C0_C1_4
> [   rmm ] Unhandled write S2_0_C0_C2_5
>      :
> [   rmm ] Unhandled write S2_0_C0_C13_6
> [   rmm ] Unhandled write S2_0_C0_C14_7
> [   rmm ] Unhandled write S2_0_C0_C14_6
> [   rmm ] Unhandled write S2_0_C0_C15_7
> [   rmm ] Unhandled write S2_0_C0_C15_6
> 
> Thanks,
> Gavin
> 


