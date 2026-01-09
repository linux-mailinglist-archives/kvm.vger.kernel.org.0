Return-Path: <kvm+bounces-67555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36043D08AD6
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 11:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF372304D8FC
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 10:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C36339863;
	Fri,  9 Jan 2026 10:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTF3d80g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF7C32BF21;
	Fri,  9 Jan 2026 10:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767955413; cv=none; b=kO4g0i8GlNzbMEjtFq4jegkThHGUpgbmJ0r7EWZiV9Q2VanawsVnAo6QC1+qOy1G7RIyAH8VcFuSYPMi3d4SZmYnptyZXSqfxREaOGlBi0cEToILX0UjNRBiKD4Hpsv9gB9XMdNr9NUxjnfXMrduyZQconmnzy4lMjkgmLjoSgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767955413; c=relaxed/simple;
	bh=D9q+W2fgN8+6clvXMyXxcMH38T0JEVhyGKgp8EasESw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hwTgQDwAgNaTFFSvM7LpuCfgzuUTuZaHsh8FKsxr8SnzuNvaZCYMjZsDGr5ZhQgwlV5O2UyOJEAVu8hk9JSwg7qStbH9QlPlkd8bzt8jolIHamvbnDs/Y3a1+SRo0fjrIHd1DzsvzmpJjJAKzLu4sSpcy5afv1lAMGC082kyIFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTF3d80g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51ADC4CEF1;
	Fri,  9 Jan 2026 10:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767955412;
	bh=D9q+W2fgN8+6clvXMyXxcMH38T0JEVhyGKgp8EasESw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BTF3d80gq0STzhCs3NouiHImqDZGG1VdLuiQSV0NzdVBU1yOvQhFDtrYX1riQffsk
	 vchP8qJp9qDUcizBgK13hE+hlIE0DxDX1Fx0vfeorovkGNYF+yAAdzL3lyYweha4eu
	 17jwMVyjkPAs2R8aHLDw9etq/5adxsLALQO9SreO9i2H/h/FAdfqhZUxJG3H0kF0Cm
	 FKGnyA3cjh6DYbZmfTTDp1HqNTEcQchqn3SJeEsOssNzRU9+WSyFWb+nTqSQLrqkJf
	 JtS6eVEBXDj474WW4ztlOBfzTLIEWEHX3jhSv+8rFzxHMmvhcr7Kojd02LB8T3XKAp
	 fbAIz3YqMfZcA==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	will@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com,
	steven.price@arm.com, tabba@google.com
Subject: Re: [PATCH kvmtool v4 15/15] arm64: smccc: Start sending PSCI to
 userspace
In-Reply-To: <e0689753-2d17-4593-a7f6-b8211cc29e8d@arm.com>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
 <20250930103130.197534-17-suzuki.poulose@arm.com>
 <86344gmbtb.wl-maz@kernel.org> <yq5aa4yn5x6e.fsf@kernel.org>
 <e0689753-2d17-4593-a7f6-b8211cc29e8d@arm.com>
Date: Fri, 09 Jan 2026 16:13:26 +0530
Message-ID: <yq5aldi7kqwh.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 09/01/2026 02:36, Aneesh Kumar K.V wrote:
>> Marc Zyngier <maz@kernel.org> writes:
>> 
>>> On Tue, 30 Sep 2025 11:31:30 +0100,
>>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>>
>>>> From: Oliver Upton <oliver.upton@linux.dev>
>>>>
>>>> kvmtool now has a PSCI implementation that complies with v1.0 of the
>>>> specification. Use the SMCCC filter to start sending these calls out to
>>>> userspace for further handling. While at it, shut the door on the
>>>> legacy, KVM-specific v0.1 functions.
>>>>
>>>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> ---
>>>>   arm64/include/kvm/kvm-config-arch.h |  8 +++++--
>>>>   arm64/smccc.c                       | 37 +++++++++++++++++++++++++++++
>>>>   2 files changed, 43 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
>>>> index ee031f01..3158fadf 100644
>>>> --- a/arm64/include/kvm/kvm-config-arch.h
>>>> +++ b/arm64/include/kvm/kvm-config-arch.h
>>>> @@ -15,6 +15,7 @@ struct kvm_config_arch {
>>>>   	u64		fw_addr;
>>>>   	unsigned int	sve_max_vq;
>>>>   	bool		no_pvtime;
>>>> +	bool		in_kernel_smccc;
>>>>   };
>>>>   
>>>>   int irqchip_parser(const struct option *opt, const char *arg, int unset);
>>>> @@ -52,11 +53,14 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>>>>   			   "Force virtio devices to use PCI as their default "	\
>>>>   			   "transport (Deprecated: Use --virtio-transport "	\
>>>>   			   "option instead)", virtio_transport_parser, kvm),	\
>>>> -        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>>>> +	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>>>>   		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
>>>>   		     "Type of interrupt controller to emulate in the guest",	\
>>>>   		     irqchip_parser, NULL),					\
>>>>   	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
>>>> -		"Address where firmware should be loaded"),
>>>> +		"Address where firmware should be loaded"),			\
>>>> +	OPT_BOOLEAN('\0', "in-kernel-smccc", &(cfg)->in_kernel_smccc,		\
>>>> +			"Disable userspace handling of SMCCC, instead"		\
>>>> +			" relying on the in-kernel implementation"),
>>>>
>>>
>>> nit: this really is about PSCI, not SMCCC. The fact that we use the
>>> SMCCC interface to route PSCI calls is an implementation detail,
>>> really. The other thing is that this is a change in default behaviour,
>>> and I'd rather keep in-kernel PSCI to be the default, specially given
>>> that this otherwise silently fails on old kernels.
>>>
>>> To that effect, I'd suggest the following instead:
>>>
>>> +	OPT_BOOLEAN('\0', "psci", &(cfg)->userspace_psci,		\
>>> +			"Request userspace handling of PSCI, instead"		\
>>> +			" relying on the in-kernel implementation"),
>>>
>>> and the code modified accordingly.
>>>
>> 
>> The same option will also be used to handle RHI or may be we could say
>> --realm implies userspace_psci = true?
>
> Not necessarily. For a Realm, we should always handle the RHI calls in
> VMM and VMM must do this irrespective of where the PSCI is emulated.
> i.e., they both are different things. KVM allows controlling the SMCCC
> for FID ranges. For Realm, RHI range can be requested by the VMM.
> Depending on the --psci option, PSCI range can also be requested.
>

We can rename static struct kvm_smccc_filter filter_ranges[] to
psci_filter_ranges[] and for RHI we can have another
rhi_smccc_fid_ranges[]?.

-aneesh

