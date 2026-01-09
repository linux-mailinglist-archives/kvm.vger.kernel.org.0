Return-Path: <kvm+bounces-67571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 62CA6D0AC59
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 16:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A579C3018309
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 15:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A023126B4;
	Fri,  9 Jan 2026 15:00:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F192135AD
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767970841; cv=none; b=ezGusouXihxsI5hjZliugAFjaJIb69rzlnJ51vuPbVYTPtKQ6hlzgmYKKWaaBJsSAJVHbYg9s0703Fv0qFHgc3ohzUYeDMkeqDoE+AIzuJGjga3T7Q/RUBJU4WDizVXnzxBcYd+7m+W5dwUa/AdaGSaGkEF8V39xFITI7qBu/gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767970841; c=relaxed/simple;
	bh=hKmj/adgE8+4de5/o6tkckhlWEXU/T5Uh01DwBGO0FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBMYgY8kx0LBPbZdKOdRHoNUrehRXCt8TvaFOk193Ceh1aww0/XnMsgEb349hIktjNmhfTZW6exXvTVd+zzZ5pSfblw1KmySbOKWsNQEkw0qOsTeSO6D//cn/jvUoFhiqEUFAjbHDNFwkr1LHC37r0+W8YNTN9+SGQN6L1uLfXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D33DFEC;
	Fri,  9 Jan 2026 07:00:25 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21D6D3F6A8;
	Fri,  9 Jan 2026 07:00:30 -0800 (PST)
Date: Fri, 9 Jan 2026 15:00:27 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 33/36] KVM: arm64: gic-v5: Probe for GICv5 device
Message-ID: <20260109150027.GB223579@e124191.cambridge.arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
 <20251219155222.1383109-34-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219155222.1383109-34-sascha.bischoff@arm.com>

On Fri, Dec 19, 2025 at 03:52:47PM +0000, Sascha Bischoff wrote:
> The basic GICv5 PPI support is now complete. Allow probing for a
> native GICv5 rather than just the legacy support.
> 
> The implementation doesn't support protected VMs with GICv5 at this
> time. Therefore, if KVM has protected mode enabled the native GICv5
> init is skipped, but legacy VMs are allowed if the hardware supports
> it.
> 
> At this stage the GICv5 KVM implementation only supports PPIs, and
> doesn't interact with the host IRS at all. This means that there is no
> need to check how many concurrent VMs or vCPUs per VM are supported by
> the IRS - the PPI support only requires the CPUIF. The support is
> artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.
> 
> With this change it becomes possible to run basic GICv5-based VMs,
> provided that they only use PPIs.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---

Reviewed-by: Joey Gouly <joey.gouly@arm.com>


>  arch/arm64/kvm/vgic/vgic-v5.c | 39 +++++++++++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 97d67c1d16541..bf72982d6a2e8 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -12,22 +12,13 @@ static struct vgic_v5_ppi_caps *ppi_caps;
>  
>  /*
>   * Probe for a vGICv5 compatible interrupt controller, returning 0 on success.
> - * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
> - * registers a VGIC_V3 device.
>   */
>  int vgic_v5_probe(const struct gic_kvm_info *info)
>  {
>  	u64 ich_vtr_el2;
>  	int ret;
>  
> -	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
> -		return -ENODEV;
> -
>  	kvm_vgic_global_state.type = VGIC_V5;
> -	kvm_vgic_global_state.has_gcie_v3_compat = true;
> -
> -	/* We only support v3 compat mode - use vGICv3 limits */
> -	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
>  
>  	kvm_vgic_global_state.vcpu_base = 0;
>  	kvm_vgic_global_state.vctrl_base = NULL;
> @@ -35,6 +26,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  	kvm_vgic_global_state.has_gicv4 = false;
>  	kvm_vgic_global_state.has_gicv4_1 = false;
>  
> +	/*
> +	 * GICv5 is currently not supported in Protected mode. Skip the
> +	 * registration of GICv5 completely to make sure no guests can create a
> +	 * GICv5-based guest.
> +	 */
> +	if (is_protected_kvm_enabled()) {
> +		kvm_info("GICv5-based guests are not supported with pKVM\n");
> +		goto skip_v5;
> +	}
> +
> +	kvm_vgic_global_state.max_gic_vcpus = VGIC_V5_MAX_CPUS;
> +
> +	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
> +	if (ret) {
> +		kvm_err("Cannot register GICv5 KVM device.\n");
> +		goto skip_v5;
> +	}
> +
> +	kvm_info("GCIE system register CPU interface\n");
> +
> +skip_v5:
> +	/* If we don't support the GICv3 compat mode we're done. */
> +	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
> +		return 0;
> +
> +	kvm_vgic_global_state.has_gcie_v3_compat = true;
>  	ich_vtr_el2 =  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
>  	kvm_vgic_global_state.ich_vtr_el2 = (u32)ich_vtr_el2;
>  
> @@ -50,6 +67,10 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  		return ret;
>  	}
>  
> +	/* We potentially limit the max VCPUs further than we need to here */
> +	kvm_vgic_global_state.max_gic_vcpus = min(VGIC_V3_MAX_CPUS,
> +						  VGIC_V5_MAX_CPUS);
> +
>  	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
>  	kvm_info("GCIE legacy system register CPU interface\n");
>  
> -- 
> 2.34.1

