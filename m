Return-Path: <kvm+bounces-50167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B38AE2385
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 22:25:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E5E616532B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8619328CF41;
	Fri, 20 Jun 2025 20:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WNCqy5yC"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBECF17A2FC
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 20:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750451118; cv=none; b=RcTUE9ljGRHg+x/7iTi3nFqDD3APb2kcS7mA1xiYQD4HN4Nk0D6jltmyiKoDilUtksDG6jixK07wePQXjAlPpsrJYHQpUfsJq4CNwC5jA9qBc7tgqBaLM3wiHsqJHko4OpuZTQ/5ssR8OhNDaORTVuzMjdsURNmNS9k19wWxCYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750451118; c=relaxed/simple;
	bh=HwN6CYiF0rZePsTxb/2sKbBfHY3pCsWVzYsRSiKV5hE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ky9IO+Vce58SdC3AR5VX2cq9GftED/ABo28YL9QP4IMf9QfozCSLYh46AlR+HswnXOGHRww5HDFjUTm63Mi7EURtVG0h65YkZTR2oG51Vi+/HB797t8/oZ7Ms94kcuJP1ntzlbTy38Ymf8kSpPECu0yDtKGB/4jbPo4+A59hZ+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WNCqy5yC; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 20 Jun 2025 13:25:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750451114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gzFkdvKaxH4Hel5gdQlPGogDXbokx4DTWEowJWNszls=;
	b=WNCqy5yC5MX/HewEIIsCqlmZEpdwRBR7Eu9ebrC5gbzo0wO891VjXDboDIhMH/JvlSc97B
	HbOotk0k+L9BOaQZfdEbVCIgUE3YI5dKoAxwqSeQVk1x/sRb9+g4/qKO4G3tmcCve82DXF
	pkT8e0KeLMe843FhbKYPHU9TMSzzPFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 5/5] KVM: arm64: gic-v5: Probe for GICv5
Message-ID: <aFXDobZ2GXPC4wOJ@linux.dev>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
 <20250620160741.3513940-6-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620160741.3513940-6-sascha.bischoff@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 04:07:52PM +0000, Sascha Bischoff wrote:
> +/**
> + * vgic_v5_probe - probe for a VGICv5 compatible interrupt controller
> + * @info:	pointer to the GIC description
> + *
> + * Returns 0 if the VGICv5 has been probed successfully, returns an error code
> + * otherwise.
> + */

nit: avoid kerneldoc style

This actually generates documentation as well as build warnings when we
screw up the format. I'd only do this sort of thing for sufficiently
public functions.

Thanks,
Oliver

> +int vgic_v5_probe(const struct gic_kvm_info *info)
> +{
> +	u64 ich_vtr_el2;
> +	int ret;
> +
> +	if (!info->has_gcie_v3_compat)
> +		return -ENODEV;
> +
> +	kvm_vgic_global_state.type = VGIC_V5;
> +	kvm_vgic_global_state.has_gcie_v3_compat = true;
> +	static_branch_enable(&kvm_vgic_global_state.gicv5_cpuif);
> +
> +	/* We only support v3 compat mode - use vGICv3 limits */
> +	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
> +
> +	kvm_vgic_global_state.vcpu_base = 0;
> +	kvm_vgic_global_state.vctrl_base = NULL;
> +	kvm_vgic_global_state.can_emulate_gicv2 = false;
> +	kvm_vgic_global_state.has_gicv4 = false;
> +	kvm_vgic_global_state.has_gicv4_1 = false;
> +
> +	ich_vtr_el2 =  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
> +	kvm_vgic_global_state.ich_vtr_el2 = (u32)ich_vtr_el2;
> +
> +	/*
> +	 * The ListRegs field is 5 bits, but there is an architectural
> +	 * maximum of 16 list registers. Just ignore bit 4...
> +	 */
> +	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
> +
> +	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
> +	if (ret) {
> +		kvm_err("Cannot register GICv3-legacy KVM device.\n");
> +		return ret;
> +	}
> +
> +	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
> +	kvm_info("GCIE legacy system register CPU interface\n");
> +
> +	return 0;
> +}
> +
>  inline bool kvm_vgic_in_v3_compat_mode(void)
>  {
>  	if (static_branch_unlikely(&kvm_vgic_global_state.gicv5_cpuif) &&
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 5c78eb915a22..a5292cad60ff 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -308,6 +308,8 @@ int vgic_init(struct kvm *kvm);
>  void vgic_debug_init(struct kvm *kvm);
>  void vgic_debug_destroy(struct kvm *kvm);
>  
> +int vgic_v5_probe(const struct gic_kvm_info *info);
> +
>  static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *cpu_if = &vcpu->arch.vgic_cpu;
> -- 
> 2.34.1

