Return-Path: <kvm+bounces-65275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE008CA3669
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 12:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08C9830D330D
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 11:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE21B33B6EE;
	Thu,  4 Dec 2025 11:13:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683EA33B6E4
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764846826; cv=none; b=azkMfHAjBCnLAlq++TfvnnIHcaGP4gw6/fhb0/X+xAY4BpQwXSwFpc5fsKg0TAiyrDXa85s4ImqFZDGBBMsjMxQkL8VB2WwihKsQ6134HlQNJtHWnVuyg93IYCBOmvXGxsZOYu7+qiq0jGei0Pkl8nSAL4hwFzxV8/pGWe1p2ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764846826; c=relaxed/simple;
	bh=Jtcp3r0WNqzXRgdkHBjgmGfRCz2YadtJ1D0+V4sBvKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ek0CT1NWKe+c9rtCAw4SRNIkVqpI0aS757jOcd5pnoVNAEbTMgyDaOe1FCCaxqHDhluSLertkt/sOEubSF4vQ9nDo3RCkM95OOhSav0EslWHlgNh6SodROQzVg/H6/6vvNrA/NBMcOGATk+VroM4Z/gD1zsEGPMhlaUz+slQu48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70617339;
	Thu,  4 Dec 2025 03:13:36 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 851183F59E;
	Thu,  4 Dec 2025 03:13:42 -0800 (PST)
Message-ID: <d546725b-e96f-461e-887d-8679cf747c7d@arm.com>
Date: Thu, 4 Dec 2025 11:13:41 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] arm64: Repaint ID_AA64MMFR2_EL1.IDS description
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-2-maz@kernel.org>
 <b98c154a-1658-4501-bfa5-a93303aa5b3f@arm.com> <86cy4uplo5.wl-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <86cy4uplo5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 12/4/25 10:48, Marc Zyngier wrote:
> On Thu, 04 Dec 2025 10:36:54 +0000,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> Hi Marc,
>>
>> On 12/4/25 09:47, Marc Zyngier wrote:
>>> ID_AA64MMFR2_EL1.IDS, as described in the sysreg file, is pretty horrible
>>> as it diesctly give the ESR value. Repaint it using the usual NI/IMP
>>> identifiers to describe the absence/presence of FEAT_IDST.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
>>>  arch/arm64/tools/sysreg            | 4 ++--
>>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
>>> index 82da9b03692d4..107d62921b168 100644
>>> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
>>> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
>>> @@ -134,7 +134,7 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
>>>  	MAX_FEAT(ID_AA64MMFR2_EL1, UAO, IMP),
>>>  	MAX_FEAT(ID_AA64MMFR2_EL1, IESB, IMP),
>>>  	MAX_FEAT(ID_AA64MMFR2_EL1, AT, IMP),
>>> -	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, 0x18),
>>> +	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, IMP),
>>>  	MAX_FEAT(ID_AA64MMFR2_EL1, TTL, IMP),
>>>  	MAX_FEAT(ID_AA64MMFR2_EL1, BBM, 2),
>>>  	MAX_FEAT(ID_AA64MMFR2_EL1, E0PD, IMP),
>>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>>> index 1c6cdf9d54bba..3261e8791ac03 100644
>>> --- a/arch/arm64/tools/sysreg
>>> +++ b/arch/arm64/tools/sysreg
>>> @@ -2257,8 +2257,8 @@ UnsignedEnum	43:40	FWB
>>>  	0b0001	IMP
>>>  EndEnum
>>>  Enum	39:36	IDS
>>
>> Should this also be changed to an UnsignedEnum?
> 
> I'm not sure this brings much when you only have two values. If IDS
> was growing a third value, and that there was an actual order in the
> numbering scheme, then yes, that'd be useful.

Joey just pointed out to me that there is a new third field. Not in the
arm reference manual yet, but mentioned in the xml. I'm unsure if it's
necessary to consider this at the moment though.

https://developer.arm.com/documentation/ddi0601/2025-09/AArch64-Registers/ID-AA64MMFR2-EL1--AArch64-Memory-Model-Feature-Register-2?lang=en

> 
> But at this stage, I'm not confident that this is desirable, let alone
> necessary.
> 
> Thanks,
> 
> 	M.
> 

Thanks,

Ben


