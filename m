Return-Path: <kvm+bounces-67396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 987E1D0478D
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 17:41:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9496337C5E3
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 15:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4F947AF5F;
	Thu,  8 Jan 2026 14:23:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC7A47BCE8;
	Thu,  8 Jan 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882198; cv=none; b=n+ORWQ2JMwbNrKaD43UVQU6KUfkqLs5PCHpS+8/11iK0it9YFB0MNGK8WSJG7vTsHRCz4EXBHfjWltLtHs65Ee7iuWhm3zaUGQaJPlE31/EplnwbjJuvHp4WFsZbJPWLEAwxLuQJWiejnu0je9YTZvKyeGHXUly9juz+Ru+cr9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882198; c=relaxed/simple;
	bh=zp/83stCCwa0ccWfXiPgYHVgHpqygUIPCOZUndMQGfc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nwkt3fKIJO3q+arRM2ulCco1CUrJZrwWpsvuu5Dypo+TyzAYzfytNrFCHsxp/o7TgNn/7HrfeSsUr9bDYEeljdbF+zX4nGdF0bYopvioKwBexTF1rQdF4s32jsz8M543UOQIgSYxbQqT2lCiclqq+8//wVlF7X2veysSgsr0YUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89F34497;
	Thu,  8 Jan 2026 06:23:03 -0800 (PST)
Received: from [10.57.67.29] (unknown [10.57.67.29])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88CB23F5A1;
	Thu,  8 Jan 2026 06:23:07 -0800 (PST)
Message-ID: <6afdf188-a82e-4c46-a518-8d007cc85d23@arm.com>
Date: Thu, 8 Jan 2026 14:23:04 +0000
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
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, oliver.upton@linux.dev,
 alexandru.elisei@arm.com, aneesh.kumar@kernel.org, steven.price@arm.com,
 tabba@google.com
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
 <20250930103130.197534-17-suzuki.poulose@arm.com>
 <86344gmbtb.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86344gmbtb.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/01/2026 14:14, Marc Zyngier wrote:
> On Tue, 30 Sep 2025 11:31:30 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> From: Oliver Upton <oliver.upton@linux.dev>
>>
>> kvmtool now has a PSCI implementation that complies with v1.0 of the
>> specification. Use the SMCCC filter to start sending these calls out to
>> userspace for further handling. While at it, shut the door on the
>> legacy, KVM-specific v0.1 functions.
>>
>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arm64/include/kvm/kvm-config-arch.h |  8 +++++--
>>   arm64/smccc.c                       | 37 +++++++++++++++++++++++++++++
>>   2 files changed, 43 insertions(+), 2 deletions(-)
>>
>> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
>> index ee031f01..3158fadf 100644
>> --- a/arm64/include/kvm/kvm-config-arch.h
>> +++ b/arm64/include/kvm/kvm-config-arch.h
>> @@ -15,6 +15,7 @@ struct kvm_config_arch {
>>   	u64		fw_addr;
>>   	unsigned int	sve_max_vq;
>>   	bool		no_pvtime;
>> +	bool		in_kernel_smccc;
>>   };
>>   
>>   int irqchip_parser(const struct option *opt, const char *arg, int unset);
>> @@ -52,11 +53,14 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>>   			   "Force virtio devices to use PCI as their default "	\
>>   			   "transport (Deprecated: Use --virtio-transport "	\
>>   			   "option instead)", virtio_transport_parser, kvm),	\
>> -        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>> +	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>>   		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
>>   		     "Type of interrupt controller to emulate in the guest",	\
>>   		     irqchip_parser, NULL),					\
>>   	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
>> -		"Address where firmware should be loaded"),
>> +		"Address where firmware should be loaded"),			\
>> +	OPT_BOOLEAN('\0', "in-kernel-smccc", &(cfg)->in_kernel_smccc,		\
>> +			"Disable userspace handling of SMCCC, instead"		\
>> +			" relying on the in-kernel implementation"),
>>
> 
> nit: this really is about PSCI, not SMCCC. The fact that we use the
> SMCCC interface to route PSCI calls is an implementation detail,
> really. The other thing is that this is a change in default behaviour,
> and I'd rather keep in-kernel PSCI to be the default, specially given
> that this otherwise silently fails on old kernels.
> 

Agreed, I will address this.

> To that effect, I'd suggest the following instead:
> 
> +	OPT_BOOLEAN('\0', "psci", &(cfg)->userspace_psci,		\
> +			"Request userspace handling of PSCI, instead"		\
> +			" relying on the in-kernel implementation"),
> 
> and the code modified accordingly.
> 

Cheers
Suzuki


