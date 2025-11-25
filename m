Return-Path: <kvm+bounces-64515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C8AC85DF7
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 27124350D86
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE0C225779;
	Tue, 25 Nov 2025 16:07:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B0F20A5F3
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764086876; cv=none; b=glo7vZih+FP1kPXhs32F6R1iXomZBUzlEwtHwbIc33/FYPdHzvymBCdFFNmzvwUKQH3zl2Fv2UBt0gw/3lfzM0W9a4xHbsis6MyJB5V55W5OfpgEx6k4edIpvMkXg0x42E9tJY3VzHYBYnSm2tr60XZUSCxHAfrGPOdD38/3dF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764086876; c=relaxed/simple;
	bh=uXZEsbRH4ootT51fZGGwUeSG599PUM1FDESs9g5qi+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/S/gOhAyXWI2qxU9UFauChcK9NNytQ9twX+BqTwSJQgQ7UNdk7QkPBr/2ehdgzhklHamxN8mQb/4QsxbTAKMRkV6649bXQI2E4QLC5jt8xpewu/IwUExcwc/vADxefm9MHVVJ3zx+wdEWyMqXpxA0Cw3KkEMx0+uy2nOqEewrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36089168F;
	Tue, 25 Nov 2025 08:07:41 -0800 (PST)
Received: from [10.57.74.181] (unknown [10.57.74.181])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F5C83F6A8;
	Tue, 25 Nov 2025 08:07:47 -0800 (PST)
Message-ID: <39801881-0e48-4daf-a195-4af0603a5bf9@arm.com>
Date: Tue, 25 Nov 2025 16:07:45 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Convert ICH_HCR_EL2_TDIR cap to
 EARLY_LOCAL_CPU_FEATURE
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20251125160144.1086511-1-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251125160144.1086511-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/11/2025 16:01, Marc Zyngier wrote:
> Suzuki notices that making the ICH_HCR_EL2_TDIR capability a system
> one isn't a very good idea, should we end-up with CPUs that have
> asymmetric TDIR support (somehow unlikely, but you never know what
> level of stupidity vendors are up to). For this hypothetical setup,
> making this an "EARLY_LOCAL_CPU_FEATURE" is a much better option.
> 
> This is actually consistent with what we already do with GICv5
> legacy interface, so flip the capability over.
> 
> Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: 2a28810cbb8b2 ("KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping")
> Link: https://lore.kerenl.org/r/5df713d4-8b79-4456-8fd1-707ca89a61b6@arm.com

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   arch/arm64/kernel/cpufeature.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 5de51cb1b8fe2..75fb9a0efcc8e 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2325,14 +2325,14 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
>   
>   	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV3_CPUIF);
>   	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV5_LEGACY);
> -	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) &&
> +	if (!this_cpu_has_cap(ARM64_HAS_GICV3_CPUIF) &&
>   	    !is_midr_in_range_list(has_vgic_v3))
>   		return false;
>   
>   	if (!is_hyp_mode_available())
>   		return false;
>   
> -	if (cpus_have_cap(ARM64_HAS_GICV5_LEGACY))
> +	if (this_cpu_has_cap(ARM64_HAS_GICV5_LEGACY))
>   		return true;
>   
>   	if (is_kernel_in_hyp_mode())
> @@ -2863,7 +2863,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		 */
>   		.desc = "ICV_DIR_EL1 trapping",
>   		.capability = ARM64_HAS_ICH_HCR_EL2_TDIR,
> -		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
>   		.matches = can_trap_icv_dir_el1,
>   	},
>   #ifdef CONFIG_ARM64_E0PD


