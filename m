Return-Path: <kvm+bounces-64498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9E1C8557E
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B68953B2A68
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 14:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA18324B0A;
	Tue, 25 Nov 2025 14:14:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B6D3246FE
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 14:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080070; cv=none; b=UtMA+o4tBG1zPRyC7JYal1cluxp0ijG7+0421vbI1AKLmsYDgJ+ZoKbEkw3NVJqUZgwPVcqHBE87SFhUFavWCoPjZQSy76ZnayYptEQib3Gb1XMIa/hQMur+rcAAzREX8hbQAToP/rdX89wsEkKYn7A8eo6GtCQsXXpCDiY3yLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080070; c=relaxed/simple;
	bh=5WPAAEAVbcWlB/llxwu+yBT/5JsRuhtT4pi9J/qzp+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnKIdn1X0lRRT3B4/4GDPO57C3KCGirCr+8nMfI0pr1siqVdK0X33E4g5CmcVlJSFVLieHxVh3Q5H8rgXj4mxIdWdB0K9lEyIpRkGt9h8AToYYRIQtxEYXXsdHV9lIqRnVTOhQFwSILED5kuZFMAuXbsQOeUbB5YhqBKhY9EoZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B82B168F;
	Tue, 25 Nov 2025 06:14:20 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6D883F86F;
	Tue, 25 Nov 2025 06:14:26 -0800 (PST)
Message-ID: <e67decb6-20a5-4659-8401-8534049f9229@arm.com>
Date: Tue, 25 Nov 2025 14:14:25 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/49] KVM: arm64: GICv3: Detect and work around the
 lack of ICV_DIR_EL1 trapping
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 Mark Brown <broonie@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
 <20251120172540.2267180-7-maz@kernel.org>
 <5df713d4-8b79-4456-8fd1-707ca89a61b6@arm.com> <86h5uiql4b.wl-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86h5uiql4b.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/11/2025 13:48, Marc Zyngier wrote:
> On Tue, 25 Nov 2025 11:26:10 +0000,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On 20/11/2025 17:24, Marc Zyngier wrote:
>>> A long time ago, an unsuspecting architect forgot to add a trap
>>> bit for ICV_DIR_EL1 in ICH_HCR_EL2. Which was unfortunate, but
>>> what's a bit of spec between friends? Thankfully, this was fixed
>>> in a later revision, and ARM "deprecates" the lack of trapping
>>> ability.
>>>
>>> Unfortuantely, a few (billion) CPUs went out with that defect,
>>> anything ARMv8.0 from ARM, give or take. And on these CPUs,
>>> you can't trap DIR on its own, full stop.
>>>
>>> As the next best thing, we can trap everything in the common group,
>>> which is a tad expensive, but hey ho, that's what you get. You can
>>> otherwise recycle the HW in the neaby bin.
>>>
>>> Tested-by: Fuad Tabba <tabba@google.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>    arch/arm64/include/asm/virt.h  |  7 ++++-
>>>    arch/arm64/kernel/cpufeature.c | 52 ++++++++++++++++++++++++++++++++++
>>>    arch/arm64/kernel/hyp-stub.S   |  5 ++++
>>>    arch/arm64/kvm/vgic/vgic-v3.c  |  3 ++
>>>    arch/arm64/tools/cpucaps       |  1 +
>>>    5 files changed, 67 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
>>> index aa280f356b96a..8eb63d3294974 100644
>>> --- a/arch/arm64/include/asm/virt.h
>>> +++ b/arch/arm64/include/asm/virt.h
>>> @@ -40,8 +40,13 @@
>>>     */
>>>    #define HVC_FINALISE_EL2	3
>>>    +/*
>>> + * HVC_GET_ICH_VTR_EL2 - Retrieve the ICH_VTR_EL2 value
>>> + */
>>> +#define HVC_GET_ICH_VTR_EL2	4
>>> +
>>>    /* Max number of HYP stub hypercalls */
>>> -#define HVC_STUB_HCALL_NR 4
>>> +#define HVC_STUB_HCALL_NR 5
>>>      /* Error returned when an invalid stub number is passed into x0
>>> */
>>>    #define HVC_STUB_ERR	0xbadca11
>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>> index 5ed401ff79e3e..5de51cb1b8fe2 100644
>>> --- a/arch/arm64/kernel/cpufeature.c
>>> +++ b/arch/arm64/kernel/cpufeature.c
>>> @@ -2303,6 +2303,49 @@ static bool has_gic_prio_relaxed_sync(const struct arm64_cpu_capabilities *entry
>>>    }
>>>    #endif
>>>    +static bool can_trap_icv_dir_el1(const struct
>>> arm64_cpu_capabilities *entry,
>>> +				 int scope)
>>> +{
>>> +	static const struct midr_range has_vgic_v3[] = {
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
>>> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
>>> +		{},
>>> +	};
>>> +	struct arm_smccc_res res = {};
>>> +
>>> +	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV3_CPUIF);
>>> +	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV5_LEGACY);
>>> +	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) &&
>>> +	    !is_midr_in_range_list(has_vgic_v3))
>>> +		return false;
>>> +
>>> +	if (!is_hyp_mode_available())
>>> +		return false;
>>> +
>>> +	if (cpus_have_cap(ARM64_HAS_GICV5_LEGACY))
>>> +		return true;
>>> +
>>> +	if (is_kernel_in_hyp_mode())
>>> +		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
>>> +	else
>>> +		arm_smccc_1_1_hvc(HVC_GET_ICH_VTR_EL2, &res);
>>
>> We are reading the register on the current CPU and this capability,
>> being a SYSTEM_FEATURE, relies on the "probing CPU". If there CPUs
>> with differing values (which I don't think is practical, but hey,
>> never say..). This is would better be a
>> ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE, which would run through all
>> boot CPUs and would set the capability when it matches.
> 
> While I agree that SYSTEM_FEATURE is most probably the wrong thing, I
> can't help but notice that
> 
> - ARM64_HAS_GICV3_CPUIF,
> - ARM64_HAS_GIC_PRIO_MASKING
> - ARM64_HAS_GIC_PRIO_RELAXED_SYNC
> 
> are all ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE.

Which means, if GICV3_CPUIF is set any booting CPU must have them.

> 
> On the other ARM64_HAS_GICV5_LEGACY is ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE.
> 
> Given that ARM64_HAS_ICH_HCR_EL2_TDIR is dependent on both
> ARM64_HAS_GICV3_CPUIF and ARM64_HAS_GICV5_LEGACY, shouldn't these two
> (and their dependencies) be aligned to have the same behaviour?

Yes, but it also depends on how you are detecting the feature.

BOOT_CPU_FEATURES are finalized with BOOT CPU and thusanything that 
boots up later must have it. So it is fine, as long
as a SYSTEM cap depends on it and can do its own additional checks
in a system wide safe manner.

But in your case, we a have SYSTEM cap, which only performs the check
on the "running CPU" and not considering a system wide safe value for
ICH_VTR_EL2_TDS. In order to do this, we need to switch to something
like the GICV5_LEGACY cap, which chooses to perform the check on all
booting CPUs (as we don't keep the system wide safe value for the
bit it is looking for).

e.g., your cap may be incorrectly SET, when the BOOT cpu (which
mostly runs the SYSTEM scope), but another CPU didn't have the
ICH_VTR_EL2_TDS.

Does that help ?

Suzuki

> 
> Thanks,
> 
> 	M.
> 


