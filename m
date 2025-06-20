Return-Path: <kvm+bounces-50057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D5EEAE19A1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:10:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26CBD7AAD97
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0BE28A3F3;
	Fri, 20 Jun 2025 11:09:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136B02853F1
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 11:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417785; cv=none; b=Cy7ZLDMn1xn7jXgpUQefYbSPSedXdN4Ge5/slMVP1vV3QxlQSqND7KdRRXQx5FHM/fFtDDDvojUPLnvTFpFy9f47+S5zarQKN5T8aq4uKatlRTSoIvZrp6Q9knmDNzo1lkWcK0IxMvHKWBRbi6WLHRM8CStxqZJrNrlCF8tL9qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417785; c=relaxed/simple;
	bh=XtEIMypRw8Qdyi11x4fP4NT+j4V5Mtuo+X/nndkhTKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cNDHMXktBRnLUV0uKpJHuRUQ5Z2VqCz4S1CqRlmclYiq9c5p5DnaGUrrq2IzHk0WMYdZLE5xmLtUWR1eiX+zi6Xq1aMBfg42rgpoTpMGX0cGh8OGW07eghWPezt4WFV6camwiBKDAIeOaY8aZzNpDQLucmlHoLHA5Qi7BTHZpCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B35AC176A;
	Fri, 20 Jun 2025 04:09:23 -0700 (PDT)
Received: from arm.com (e134078.arm.com [10.1.28.39])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1C513F673;
	Fri, 20 Jun 2025 04:09:41 -0700 (PDT)
Date: Fri, 20 Jun 2025 12:09:38 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool 2/3] arm64: Initial nested virt support
Message-ID: <aFVBckcGYQgF+UXO@arm.com>
References: <20250620104454.1384132-1-andre.przywara@arm.com>
 <20250620104454.1384132-3-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620104454.1384132-3-andre.przywara@arm.com>

Hi Andre,

Thanks for doing this, it was needed. Haven't given this a proper look (I'm
planning to do that though!), but something jumped at me, below.

On Fri, Jun 20, 2025 at 11:44:53AM +0100, Andre Przywara wrote:
> The ARMv8.3 architecture update includes support for nested
> virtualization. Allow the user to specify "--nested" to start a guest in

'./vm help run' shows:

--pmu             Create PMUv3 device
--disable-mte     Disable Memory Tagging Extension
--no-pvtime       Disable stolen time

Where:

--pmu checks for KVM_CAP_ARM_PMU_V3.
--disable-mte is there because MTE is enabled automatically for a guest when
KVM_CAP_ARM_MTE is present.
--no-pvtime is there because pvtime is enabled automatically; no capability
check is needed, but the control group for pvtime is called
KVM_ARM_VCPU_PVTIME_CTRL.

What I'm trying to get at is that the name for the kvmtool command line option
matches KVM's name for the capability. What do you think about naming the
parameter --el2 to match KVM_CAP_ARM_EL2 instead of --nested?

 Also, I seem to remember that the command line option for enabling
 KVM_CAP_ARM_EL2_E2H0 in Marc's repo is --e2h0, so having --el2 instead of
 --nested looks somewhat more consistent to me.

 Thoughts?

 Thanks,
 Alex

> (virtual) EL2 instead of EL1.
> This will also change the PSCI conduit from HVC to SMC in the device
> tree.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm64/fdt.c                         |  5 ++++-
>  arm64/include/kvm/kvm-config-arch.h |  5 ++++-
>  arm64/kvm-cpu.c                     | 12 +++++++++++-
>  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arm64/fdt.c b/arm64/fdt.c
> index df7775876..98f1dd9d4 100644
> --- a/arm64/fdt.c
> +++ b/arm64/fdt.c
> @@ -205,7 +205,10 @@ static int setup_fdt(struct kvm *kvm)
>  		_FDT(fdt_property_string(fdt, "compatible", "arm,psci"));
>  		fns = &psci_0_1_fns;
>  	}
> -	_FDT(fdt_property_string(fdt, "method", "hvc"));
> +	if (kvm->cfg.arch.nested_virt)
> +		_FDT(fdt_property_string(fdt, "method", "smc"));
> +	else
> +		_FDT(fdt_property_string(fdt, "method", "hvc"));
>  	_FDT(fdt_property_cell(fdt, "cpu_suspend", fns->cpu_suspend));
>  	_FDT(fdt_property_cell(fdt, "cpu_off", fns->cpu_off));
>  	_FDT(fdt_property_cell(fdt, "cpu_on", fns->cpu_on));
> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> index ee031f010..a1dac28e6 100644
> --- a/arm64/include/kvm/kvm-config-arch.h
> +++ b/arm64/include/kvm/kvm-config-arch.h
> @@ -10,6 +10,7 @@ struct kvm_config_arch {
>  	bool		aarch32_guest;
>  	bool		has_pmuv3;
>  	bool		mte_disabled;
> +	bool		nested_virt;
>  	u64		kaslr_seed;
>  	enum irqchip_type irqchip;
>  	u64		fw_addr;
> @@ -57,6 +58,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>  		     "Type of interrupt controller to emulate in the guest",	\
>  		     irqchip_parser, NULL),					\
>  	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
> -		"Address where firmware should be loaded"),
> +		"Address where firmware should be loaded"),			\
> +	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
> +		    "Start VCPUs in EL2 (for nested virt)"),
>  
>  #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
> index 94c08a4d7..42dc11dad 100644
> --- a/arm64/kvm-cpu.c
> +++ b/arm64/kvm-cpu.c
> @@ -71,6 +71,12 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
>  	/* Enable SVE if available */
>  	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
>  		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
> +
> +	if (kvm->cfg.arch.nested_virt) {
> +		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
> +			die("EL2 (nested virt) is not supported");
> +		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
> +	}
>  }
>  
>  static int vcpu_configure_sve(struct kvm_cpu *vcpu)
> @@ -313,7 +319,11 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
>  	reg.addr = (u64)&data;
>  
>  	/* pstate = all interrupts masked */
> -	data	= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT | PSR_MODE_EL1h;
> +	data	= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
> +	if (vcpu->kvm->cfg.arch.nested_virt)
> +		data |= PSR_MODE_EL2h;
> +	else
> +		data |= PSR_MODE_EL1h;
>  	reg.id	= ARM64_CORE_REG(regs.pstate);
>  	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
>  		die_perror("KVM_SET_ONE_REG failed (spsr[EL1])");
> -- 
> 2.25.1
> 
> 

