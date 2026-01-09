Return-Path: <kvm+bounces-67626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D4ED0B966
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0F0D3069D66
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032BD364E87;
	Fri,  9 Jan 2026 17:14:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BC33644A6;
	Fri,  9 Jan 2026 17:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978865; cv=none; b=r5mMUZilTt+p2ElVA//UmM6mStRkNDxRD0xTWdEemDSpfGpw941nmjIZsEQmQ5wlXr9BbBHQME84nnUaQi7+RjhFxo1/nzV1BUV1E9jAJYXlbmpSpkx1MUYwYJTgAaKihacLKYYCvw+u9Iz1LiOpOqXG3jvY+TAFVHHiZSf510w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978865; c=relaxed/simple;
	bh=p3ZjVbx05E5fZ6b96lEtc9aw4qmKhsdsGzNejQl2Sew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DomCDwYb0EbZPH2wF+IX4mmAc9cKKfjErX481bUccGWOsUzueDXa4ndjfDbey48lVKZtRKb+/47vhYKxIfKrA6GJe9mf/llO+beb6Oeh0ZgZuIM1yCWSU8dn0gSQHWBxB4172Ufcoz7BK1kr0jxBLEIPQsflaNxk+rROVeOjqYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61F0AFEC;
	Fri,  9 Jan 2026 09:14:16 -0800 (PST)
Received: from [10.57.64.234] (unknown [10.57.64.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F8F23F6A8;
	Fri,  9 Jan 2026 09:14:21 -0800 (PST)
Message-ID: <26ed270e-a9b2-4c4a-afbe-53c1919934c4@arm.com>
Date: Fri, 9 Jan 2026 17:14:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v4 15/15] arm64: smccc: Start sending PSCI to
 userspace
Content-Language: en-GB
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, oliver.upton@linux.dev,
 alexandru.elisei@arm.com, steven.price@arm.com, tabba@google.com
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
 <20250930103130.197534-17-suzuki.poulose@arm.com>
 <86344gmbtb.wl-maz@kernel.org> <yq5aa4yn5x6e.fsf@kernel.org>
 <e0689753-2d17-4593-a7f6-b8211cc29e8d@arm.com> <yq5aldi7kqwh.fsf@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <yq5aldi7kqwh.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/01/2026 10:43, Aneesh Kumar K.V wrote:
> Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> 
>> On 09/01/2026 02:36, Aneesh Kumar K.V wrote:
>>> Marc Zyngier <maz@kernel.org> writes:
>>>
>>>> On Tue, 30 Sep 2025 11:31:30 +0100,
>>>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>>>
>>>>> From: Oliver Upton <oliver.upton@linux.dev>
>>>>>
>>>>> kvmtool now has a PSCI implementation that complies with v1.0 of the
>>>>> specification. Use the SMCCC filter to start sending these calls out to
>>>>> userspace for further handling. While at it, shut the door on the
>>>>> legacy, KVM-specific v0.1 functions.
>>>>>
>>>>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>> ---
>>>>>    arm64/include/kvm/kvm-config-arch.h |  8 +++++--
>>>>>    arm64/smccc.c                       | 37 +++++++++++++++++++++++++++++
>>>>>    2 files changed, 43 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
>>>>> index ee031f01..3158fadf 100644
>>>>> --- a/arm64/include/kvm/kvm-config-arch.h
>>>>> +++ b/arm64/include/kvm/kvm-config-arch.h
>>>>> @@ -15,6 +15,7 @@ struct kvm_config_arch {
>>>>>    	u64		fw_addr;
>>>>>    	unsigned int	sve_max_vq;
>>>>>    	bool		no_pvtime;
>>>>> +	bool		in_kernel_smccc;
>>>>>    };
>>>>>    
>>>>>    int irqchip_parser(const struct option *opt, const char *arg, int unset);
>>>>> @@ -52,11 +53,14 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>>>>>    			   "Force virtio devices to use PCI as their default "	\
>>>>>    			   "transport (Deprecated: Use --virtio-transport "	\
>>>>>    			   "option instead)", virtio_transport_parser, kvm),	\
>>>>> -        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>>>>> +	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>>>>>    		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
>>>>>    		     "Type of interrupt controller to emulate in the guest",	\
>>>>>    		     irqchip_parser, NULL),					\
>>>>>    	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
>>>>> -		"Address where firmware should be loaded"),
>>>>> +		"Address where firmware should be loaded"),			\
>>>>> +	OPT_BOOLEAN('\0', "in-kernel-smccc", &(cfg)->in_kernel_smccc,		\
>>>>> +			"Disable userspace handling of SMCCC, instead"		\
>>>>> +			" relying on the in-kernel implementation"),
>>>>>
>>>>
>>>> nit: this really is about PSCI, not SMCCC. The fact that we use the
>>>> SMCCC interface to route PSCI calls is an implementation detail,
>>>> really. The other thing is that this is a change in default behaviour,
>>>> and I'd rather keep in-kernel PSCI to be the default, specially given
>>>> that this otherwise silently fails on old kernels.
>>>>
>>>> To that effect, I'd suggest the following instead:
>>>>
>>>> +	OPT_BOOLEAN('\0', "psci", &(cfg)->userspace_psci,		\
>>>> +			"Request userspace handling of PSCI, instead"		\
>>>> +			" relying on the in-kernel implementation"),
>>>>
>>>> and the code modified accordingly.
>>>>
>>>
>>> The same option will also be used to handle RHI or may be we could say
>>> --realm implies userspace_psci = true?
>>
>> Not necessarily. For a Realm, we should always handle the RHI calls in
>> VMM and VMM must do this irrespective of where the PSCI is emulated.
>> i.e., they both are different things. KVM allows controlling the SMCCC
>> for FID ranges. For Realm, RHI range can be requested by the VMM.
>> Depending on the --psci option, PSCI range can also be requested.
>>
> 
> We can rename static struct kvm_smccc_filter filter_ranges[] to
> psci_filter_ranges[] and for RHI we can have another
> rhi_smccc_fid_ranges[]?.

Yep, that can done in respective patches, where we add RHI. Since we
only have psci in the ranges, I am a bit lazy/reluctant to rename it.

Cheers
Suzuki

> 
> -aneesh


