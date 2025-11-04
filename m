Return-Path: <kvm+bounces-61951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E16AC30175
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 09:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 00B5C4F8336
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 08:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8AFD26A08A;
	Tue,  4 Nov 2025 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NBb/BZVT"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242A523D7D4
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 08:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762246239; cv=none; b=l5VWM3fngx5vNleW5oYPyculrBBr/ka0PmA3RULk25t4drlpABtOMzzG9/fHzF86OKyL4VpTImD8mfdcQhA3yV6imEuPbHK3DotySw4dTjSPczyjK/qf1UFLC8Mcf+aoxRO9syGogJCTS1PUfPbaL0JqxTVdjvxzwJZ7XqpnOpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762246239; c=relaxed/simple;
	bh=soGesaofbZljclF8W2Zm3bonsPZqu5WbEtAViCwuPsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQ0BXQfyPAVkaWEHQKG9v4fG44Ju1SLnV+ijxqPQmGj9YXmhiFTD7V+5NkX/ZY9dx8RvvzMg+FaAXMZIHL5w84HuyklXbTjGvIpr4BhUESuHnXcTX87CzhfooprL0MEVl0SvzkWUspI8R1OTQUHwmi10pDpEGWKjvGbVCWNaGzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NBb/BZVT; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762246228; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=a6gOAz78r5vvYxw3j29DNoIm+CngnMkAn2hvO8B4UoM=;
	b=NBb/BZVTivofn7dwRNQmdMFPs2bop4MZ88YXLsAYD5nfbMV1R/6ieyRD7A1iDTr5IK+4cmhttCQTzWDYds2j/ndnD4KJjBrMFKNRJBPreAdQid0TMACglZt5bXOX9o8WoSZJLynV7ZHEjA2igGlSrbTK/8EA32ji1yxDlaq8Kb8=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Wrgcs7Z_1762246227 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Nov 2025 16:50:27 +0800
Date: Tue, 4 Nov 2025 16:50:26 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: Re: [PATCH 05/33] KVM: arm64: GICv3: Detect and work around the lack
 of ICV_DIR_EL1 trapping
Message-ID: <eossoxorxj5knjyx2xglsrzhrbi6rry3rcr2xryfmft3q7up4b@tr5yrg6lljzq>
References: <20251103165517.2960148-1-maz@kernel.org>
 <20251103165517.2960148-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103165517.2960148-6-maz@kernel.org>

On Mon, Nov 03, 2025 at 04:54:49PM +0800, Marc Zyngier wrote:
> A long time ago, an unsuspecting architect forgot to add a trap
> bit for ICV_DIR_EL1 in ICH_HCR_EL2. Which was unfortunate, but
> what's a bit of spec between friends? Thankfully, this was fixed
> in a later revision, and ARM "deprecates" the lack of trapping
> ability.
>
> Unfortuantely, a few (billion) CPUs went out with that defect,
> anything ARMv8.0 from ARM, give or take. And on these CPUs,
> you can't trap DIR on its own, full stop.
>
> As the next best thing, we can trap everything in the common group,
> which is a tad expensive, but hey ho, that's what you get. You can
> otherwise recycle the HW in the neaby bin.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/virt.h  |  7 ++++++-
>  arch/arm64/kernel/cpufeature.c | 34 ++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/hyp-stub.S   |  5 +++++
>  arch/arm64/kvm/vgic/vgic-v3.c  |  3 +++
>  arch/arm64/tools/cpucaps       |  1 +
>  5 files changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index aa280f356b96a..8eb63d3294974 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -40,8 +40,13 @@
>   */
>  #define HVC_FINALISE_EL2	3
>
> +/*
> + * HVC_GET_ICH_VTR_EL2 - Retrieve the ICH_VTR_EL2 value
> + */
> +#define HVC_GET_ICH_VTR_EL2	4
> +
>  /* Max number of HYP stub hypercalls */
> -#define HVC_STUB_HCALL_NR 4
> +#define HVC_STUB_HCALL_NR 5
>
>  /* Error returned when an invalid stub number is passed into x0 */
>  #define HVC_STUB_ERR	0xbadca11
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 5ed401ff79e3e..44103ad98805d 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2303,6 +2303,31 @@ static bool has_gic_prio_relaxed_sync(const struct arm64_cpu_capabilities *entry
>  }
>  #endif
>
> +static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
> +				 int scope)
> +{
> +	struct arm_smccc_res res = {};
> +
> +	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDS <= ARM64_HAS_GICV3_CPUIF);
> +	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDS <= ARM64_HAS_GICV5_LEGACY);
> +	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) ||
> +	    !cpus_have_cap(ARM64_HAS_GICV3_CPUIF))

Duplicated checking ?

> +		return false;
> +
> +	if (!is_hyp_mode_available())
> +		return false;
> +
> +	if (is_kernel_in_hyp_mode())
> +		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
> +	else
> +		arm_smccc_1_1_hvc(HVC_GET_ICH_VTR_EL2, &res);
> +
> +	if (res.a0 == HVC_STUB_ERR)
> +		return false;
> +
> +	return res.a1 & ICH_VTR_EL2_TDS;
> +}
> +
>  #ifdef CONFIG_ARM64_BTI
>  static void bti_enable(const struct arm64_cpu_capabilities *__unused)
>  {
> @@ -2814,6 +2839,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_gic_prio_relaxed_sync,
>  	},
>  #endif
> +	{
> +		/*
> +		 * Depends on having GICv3
> +		 */
> +		.desc = "ICV_DIR_EL1 trapping",
> +		.capability = ARM64_HAS_ICH_HCR_EL2_TDS,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = can_trap_icv_dir_el1,
> +	},
>  #ifdef CONFIG_ARM64_E0PD
>  	{
>  		.desc = "E0PD",
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 36e2d26b54f5c..ab60fa685f6d8 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -54,6 +54,11 @@ SYM_CODE_START_LOCAL(elx_sync)
>  1:	cmp	x0, #HVC_FINALISE_EL2
>  	b.eq	__finalise_el2
>
> +	cmp	x0, #HVC_GET_ICH_VTR_EL2
> +	b.ne	2f
> +	mrs	x1, ich_vtr_el2
> +	b	9f
> +
>  2:	cmp	x0, #HVC_SOFT_RESTART
>  	b.ne	3f
>  	mov	x0, x2
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 236d0beef561d..e0c6e03bf9411 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -648,6 +648,9 @@ void noinstr kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
>  		dir_trap = true;
>  	}
>
> +	if (!cpus_have_cap(ARM64_HAS_ICH_HCR_EL2_TDS))
> +		common_trap = true;
> +
>  	if (group0_trap)
>  		hcr |= ICH_HCR_EL2_TALL0;
>  	if (group1_trap)
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 1b32c1232d28d..77f1bd230722d 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -40,6 +40,7 @@ HAS_GICV5_CPUIF
>  HAS_GICV5_LEGACY
>  HAS_GIC_PRIO_MASKING
>  HAS_GIC_PRIO_RELAXED_SYNC
> +HAS_ICH_HCR_EL2_TDS
>  HAS_HCR_NV1
>  HAS_HCX
>  HAS_LDAPR
> --
> 2.47.3
>

