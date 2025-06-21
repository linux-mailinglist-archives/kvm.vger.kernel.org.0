Return-Path: <kvm+bounces-50243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D9CAE26B1
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 02:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 076357ABE83
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 00:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C16618E1A;
	Sat, 21 Jun 2025 00:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vCuYaekT"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526C27482
	for <kvm@vger.kernel.org>; Sat, 21 Jun 2025 00:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750466753; cv=none; b=rvbwa5FGHHFeUIIgUnA9iQfak6nEvl8KfNUViN/K5gj11movY2a6toFNRLZisENQyMhEIrytMAoSy6EPr1uZA93sver0z6wFlGlWeJRPFLBf61d2kQ1jUyP3iw4Bq964rDkjPfWasp8aSZSDzlhM7VFX8iHRat7Ko7JrcVTExbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750466753; c=relaxed/simple;
	bh=gZwTwTPyqRpkCFq9WA1MOuL8c25/H11PvOt+lNRUy0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mU1gVW1SAHLkpV0NECzM8va9R6QrnDxjTYn4mBdDQGs7MqGdhbzeGp2sOQ4Nt5h6PxEXkfJHTqgUwehgbZvtoBXEHGxnnT4fynN3wk8PuU2s6RgBQVRjeb9DrR9EFaFV3Ibb2TshukAQljYeOqMUaS40UaSrJH9O+Zm80lOs940=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vCuYaekT; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 20 Jun 2025 17:45:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750466738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kpi3z/hNG1omr0pyfwgE93KYt7IiamCkriHdc1+ZtYI=;
	b=vCuYaekTWBlPi19QjJ6BkAuNfYaHJHZpoZH6fyYfCKbSeZ3TbNq0iuiNshL0PH0BNKBq6s
	FXYMCBwxw/y1EmA2UzvuntJoB0IpgIMBryhmTdlEx+Raib3BifedgKp08j9RSP940/ctKF
	dS8wOC5a5WYT+OkVB0l8XRSb9/GZTFM=
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
Subject: Re: [PATCH v2 03/23] arm64: cpufeature: Add cpucap for PMICNTR
Message-ID: <aFYAq7GcSx4pTK9Y@linux.dev>
References: <20250620221326.1261128-1-coltonlewis@google.com>
 <20250620221326.1261128-4-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620221326.1261128-4-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 10:13:03PM +0000, Colton Lewis wrote:
> Add a cpucap for FEAT_PMUv3_PMICNTR, meaning there is a dedicated
> instruction counter as well as the cycle counter.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

I don't see this capability being used in this series.

Thanks,
Oliver

> ---
>  arch/arm64/kernel/cpufeature.c | 7 +++++++
>  arch/arm64/tools/cpucaps       | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 278294fdc97d..85dea9714928 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2904,6 +2904,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
>  	},
> +	{
> +		.desc = "PMU Dedicated Instruction Counter",
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.capability = ARM64_HAS_PMICNTR,
> +		.matches = has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64DFR1_EL1, PMICNTR, IMP)
> +	},
>  #ifdef CONFIG_ARM64_SME
>  	{
>  		.desc = "Scalable Matrix Extension",
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 5b196ba21629..6dd72fcdd612 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -47,6 +47,7 @@ HAS_LSE_ATOMICS
>  HAS_MOPS
>  HAS_NESTED_VIRT
>  HAS_PAN
> +HAS_PMICNTR
>  HAS_PMUV3
>  HAS_S1PIE
>  HAS_S1POE
> -- 
> 2.50.0.714.g196bf9f422-goog
> 

