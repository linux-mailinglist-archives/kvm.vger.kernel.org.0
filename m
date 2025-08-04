Return-Path: <kvm+bounces-53920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 764F8B1A520
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 16:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB9623ADAF3
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 14:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5345E273805;
	Mon,  4 Aug 2025 14:41:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7432A2737F0
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754318515; cv=none; b=nF/lD8kctcEifmYlKfGvwcInhJNUqpStU19fCJ2/8vKxeSI0L83/UhqZ4yDqKOaqxrzgJLEfC2rfNQAmfVEIXud701GawCVT2ZMisaAn3pR0DF1wou0Xv4Jeb429/3bqHHhA8jfmKTicVJYdtipxXeFY7+iXg/5/OnSDpAOpSXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754318515; c=relaxed/simple;
	bh=7qCAh8qP0L+gSnzIH/mfkqApCJ7zFf0nFTVIU2xKsEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCg6UtL/gmGcH77sagQ/YP3ivUIYTDcvuaDE910FPLeQm5f4bInkppkfc2/ScfAs4AmamFmjacBJWZ77s3iX80fYqnwBrGg1RNytUKzQJqeJIZ+1da0x7PkelXYgdpkuizpdxgJMWaFXmUlO+IuU9ZZkao50juFpDzgztAKczTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EB01150C;
	Mon,  4 Aug 2025 07:41:44 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1EAD3F738;
	Mon,  4 Aug 2025 07:41:51 -0700 (PDT)
Date: Mon, 4 Aug 2025 15:41:48 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool v3 2/6] arm64: Initial nested virt support
Message-ID: <aJDGrFj003YkVVZs@raptor>
References: <20250729095745.3148294-1-andre.przywara@arm.com>
 <20250729095745.3148294-3-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729095745.3148294-3-andre.przywara@arm.com>

Hi Andre,

On Tue, Jul 29, 2025 at 10:57:41AM +0100, Andre Przywara wrote:
> The ARMv8.3 architecture update includes support for nested
> virtualization. Allow the user to specify "--nested" to start a guest in
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

--nested sounds a bit vague (what if KVM decides to nest something else in the
future?) and the variable that keeps track of the parameter is called
'nested_virt'. Is it too late to rename --nested to --nested-virt for
consistency and better clarity?

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

Marc pointed out that KVM_CAP_ARM_EL2 does more that enable EL2, it exposes
nested virtualization to a level 1 guest. How about rewording the error message
to something like this: "Nested virt is not supported"?

Thanks,
Alex

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

