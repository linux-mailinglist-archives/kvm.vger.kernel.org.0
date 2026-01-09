Return-Path: <kvm+bounces-67498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CF470D06DE0
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 03:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0306B304613E
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 02:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D50318152;
	Fri,  9 Jan 2026 02:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cr7lGZ3R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A7B315785;
	Fri,  9 Jan 2026 02:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926225; cv=none; b=f75m85xvcyvgZ2Ku5tQokd6P9ehGWLUILdgFTbeQFEXTn3xNlhqB5lOjoqiaewvKzsEenJIvRzofzG6eDFWgLqcXF7VE7XG70GmPLTR1g/IpJo3Kt+zpbkOpXIg2a/fZS0rVOstBNVxDh4+Hkd/l2FXk0mswS5QA7ctj9F2VCFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926225; c=relaxed/simple;
	bh=Lq9pLy6Ito8rpNZvj+hRgf6Z8D3KSAD7ootMrtyY8kY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SMh0J8p2v7EEi96f8NzkBu8j4C5wgP+Q1UQFkBAgr+EaEpfPLFOkgrgHgflxfHyhfHjVnHAd8ZTPDplkBHYNxaDU13C7B5/xmz1knKNU6/DOw/zVErr3OoZ7onFwYJxajnQcFFpdP3eCxz1ihnYtVufLuLybHzfAnKfmUFoaPWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cr7lGZ3R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C14C116C6;
	Fri,  9 Jan 2026 02:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767926225;
	bh=Lq9pLy6Ito8rpNZvj+hRgf6Z8D3KSAD7ootMrtyY8kY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Cr7lGZ3Ru3X9ggfpc9nUyDZ5LXVmdEzdjeYRKZWRRYw1rQZU7bs89mlKd5HOdl7h7
	 SJFAZ5K+2Zid6rC80a31KkeDH7nyUMw5yZ9M3NPwn1UN94MP1EzDXyIGN/evRd1Yn/
	 r+twfu9iltBKgTCFuhcq7G/2ZZroVU639arxjcB/I0dSv40NVzIY4pACxxKF4m+dzu
	 qrnwN517mBiHK2n6R1/idoPoIi0lxu7wuXkWqtwQJsAKWKxrTqOtA/KsMTOJqyWfbm
	 AUgU3E+wrC41+KsurRTNfnPdtozStKiteADk58N4wz+wD0UdJzfz/xjGI216M50EPe
	 1c7NqevYWPliw==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	will@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com,
	steven.price@arm.com, tabba@google.com
Subject: Re: [PATCH kvmtool v4 15/15] arm64: smccc: Start sending PSCI to
 userspace
In-Reply-To: <86344gmbtb.wl-maz@kernel.org>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
 <20250930103130.197534-17-suzuki.poulose@arm.com>
 <86344gmbtb.wl-maz@kernel.org>
Date: Fri, 09 Jan 2026 08:06:57 +0530
Message-ID: <yq5aa4yn5x6e.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Marc Zyngier <maz@kernel.org> writes:

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
>>  arm64/include/kvm/kvm-config-arch.h |  8 +++++--
>>  arm64/smccc.c                       | 37 +++++++++++++++++++++++++++++
>>  2 files changed, 43 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
>> index ee031f01..3158fadf 100644
>> --- a/arm64/include/kvm/kvm-config-arch.h
>> +++ b/arm64/include/kvm/kvm-config-arch.h
>> @@ -15,6 +15,7 @@ struct kvm_config_arch {
>>  	u64		fw_addr;
>>  	unsigned int	sve_max_vq;
>>  	bool		no_pvtime;
>> +	bool		in_kernel_smccc;
>>  };
>>  
>>  int irqchip_parser(const struct option *opt, const char *arg, int unset);
>> @@ -52,11 +53,14 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>>  			   "Force virtio devices to use PCI as their default "	\
>>  			   "transport (Deprecated: Use --virtio-transport "	\
>>  			   "option instead)", virtio_transport_parser, kvm),	\
>> -        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>> +	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>>  		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
>>  		     "Type of interrupt controller to emulate in the guest",	\
>>  		     irqchip_parser, NULL),					\
>>  	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
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
> To that effect, I'd suggest the following instead:
>
> +	OPT_BOOLEAN('\0', "psci", &(cfg)->userspace_psci,		\
> +			"Request userspace handling of PSCI, instead"		\
> +			" relying on the in-kernel implementation"),
>
> and the code modified accordingly.
>

The same option will also be used to handle RHI or may be we could say
--realm implies userspace_psci = true?

-aneesh

