Return-Path: <kvm+bounces-56542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 950D1B3F83B
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A98B17684B
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084C52E7BDF;
	Tue,  2 Sep 2025 08:23:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5A82E6CB0;
	Tue,  2 Sep 2025 08:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756801426; cv=none; b=VqRAPigujVgZtE3V5P95NJlx0HMqWlFAidJSI9RNIEpxILpbntfev3j4M0R3bHnz5HGgOKreRN5WovW/uyG5WVpxmRKfhcRdTKT41fu9yJX+QIf0RWBifF3yHNZebEsmxRbSgVhrkHF1TtZwXSFT5htr8135XA4dS/SkQOk2OJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756801426; c=relaxed/simple;
	bh=/Fc93HJyTsls3mqFSuyCskutbKEm0Sfk24vuIXo3Fw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XrB7f9tRa4piAFt0xReA/eCapwR0RZolchyAcS9z1hHjLEIX5pGO/sKPtVWLPS3/aO/N47omHsE3IcXxQX389k+ygCWUaav8IkcleVzb+xrlg6qWQvIpMT5BKEtW1hW1d2WWLlif8Mv3VC6iVFZa1mXtD5uf1tYuVKqoLlULVMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B6D82720;
	Tue,  2 Sep 2025 01:23:29 -0700 (PDT)
Received: from [10.57.4.221] (unknown [10.57.4.221])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5EA903F6A8;
	Tue,  2 Sep 2025 01:23:35 -0700 (PDT)
Message-ID: <e823610a-e145-4627-9968-6d2dcc873184@arm.com>
Date: Tue, 2 Sep 2025 09:23:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] arm64: cpucaps: Add GICv5 Legacy vCPU interface
 (GCIE_LEGACY) capability
Content-Language: en-GB
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 Joey Gouly <Joey.Gouly@arm.com>, "yuzenghui@huawei.com"
 <yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 Timothy Hayes <Timothy.Hayes@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
 <20250828105925.3865158-4-sascha.bischoff@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250828105925.3865158-4-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/08/2025 11:59, Sascha Bischoff wrote:
> Implement the GCIE_LEGACY capability as a system feature to be able to
> check for support from KVM. The type is explicitly
> ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE, which means that the capability
> is enabled early if all boot CPUs support it. Additionally, if this
> capability is enabled during boot, it prevents late onlining of CPUs
> that lack it, thereby avoiding potential mismatched configurations
> which would break KVM.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>


> ---
>   arch/arm64/kernel/cpufeature.c | 15 +++++++++++++++
>   arch/arm64/tools/cpucaps       |  1 +
>   2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9ad065f15f1d..afb3b10afd75 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2520,6 +2520,15 @@ test_has_mpam_hcr(const struct arm64_cpu_capabilities *entry, int scope)
>   	return idr & MPAMIDR_EL1_HAS_HCR;
>   }
>   
> +static bool
> +test_has_gicv5_legacy(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	if (!this_cpu_has_cap(ARM64_HAS_GICV5_CPUIF))
> +		return false;
> +
> +	return !!(read_sysreg_s(SYS_ICC_IDR0_EL1) & ICC_IDR0_EL1_GCIE_LEGACY);
> +}
> +
>   static const struct arm64_cpu_capabilities arm64_features[] = {
>   	{
>   		.capability = ARM64_ALWAYS_BOOT,
> @@ -3131,6 +3140,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.matches = has_cpuid_feature,
>   		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, GCIE, IMP)
>   	},
> +	{
> +		.desc = "GICv5 Legacy vCPU interface",
> +		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,

This is the right type for the capability intended, running the test on 
each boot time CPUs and setting the cap accordingly.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



