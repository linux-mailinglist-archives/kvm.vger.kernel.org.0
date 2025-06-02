Return-Path: <kvm+bounces-48217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D086ACBD29
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 00:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B98016FAEC
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 22:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A961F4CA4;
	Mon,  2 Jun 2025 22:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tTuEyZFt"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1002C3255;
	Mon,  2 Jun 2025 22:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748902569; cv=none; b=acTwWMkP6vDGUxi9dzKZ0QLgTQncMSl6jSqTgao+ncmCa1LuA1MaDuQskaWeTydLbOppiwIWr4+HDujPItcZo41jc+XXSWCa9XI7y1P+7/A3b9hr5NPNE7HinsR88Rb43aiQ83VaUO/7iDCuB2aKr44SlCktkQszjExPo0hRtjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748902569; c=relaxed/simple;
	bh=OP+63dCxPFG+vz6WLxcGM2+JVN5D3VzDZtsJxe45u9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SK7DIigMQew9p0+25yGgaJxBsOAvpU/64AKXqhc6lyBYC/Bolk5b2TyKoAC6oMuPDioX6GzXOVChglSQIDQbuXw9spm69eFMU3zTYHTq5AsZVKleXW5NXS1J35T6EATQo+a63XHg0Eoyl+xwpbAaUjNzgyk7OMil587+lNWt4eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tTuEyZFt; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 2 Jun 2025 15:15:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748902554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JMZY2rnPLYUjm4Au9yd8KB0DTNWhfRQzCwBMACGnhms=;
	b=tTuEyZFtmo7HE+33x7wE6vP4kNqw4C28hL5Snm7XFixdKRD/GuN+jCSaDjmBjyhhfmyII/
	t4WMbe8NVBAKCO3jEiazPalCWz0BPsPaffibJBYMKTax2sR+h7vP8iL3XXjwZcQynvUciS
	IsFAYeIfl42ZZzeoAbwyCMO0XpbhIPk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 01/17] arm64: cpufeature: Add cpucap for HPMN0
Message-ID: <aD4ijUaSGm9b2g5H@linux.dev>
References: <20250602192702.2125115-1-coltonlewis@google.com>
 <20250602192702.2125115-2-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602192702.2125115-2-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Mon, Jun 02, 2025 at 07:26:46PM +0000, Colton Lewis wrote:
> Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
> counters reserved for the guest.
> 
> This required changing HPMN0 to an UnsignedEnum in tools/sysreg
> because otherwise not all the appropriate macros are generated to add
> it to arm64_cpu_capabilities_arm64_features.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/arm64/kernel/cpufeature.c | 8 ++++++++
>  arch/arm64/tools/cpucaps       | 1 +
>  arch/arm64/tools/sysreg        | 6 +++---
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index a3da020f1d1c..578eea321a60 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -541,6 +541,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
>  };
>  
>  static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
>  	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
> @@ -2884,6 +2885,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
>  	},
> +	{
> +		.desc = "Hypervisor PMU Partitioning 0 Guest Counters",

nit: just use the the FEAT_xxx name for the description (i.e. "HPMN0").

Thanks,
Oliver

