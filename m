Return-Path: <kvm+bounces-9202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A18585BFA8
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:16:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 410A21F23ABE
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9D67602A;
	Tue, 20 Feb 2024 15:16:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B224774E30
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708442166; cv=none; b=s5cdYll8qHp2L5iZSu5G3/mVvA4shOx5ygEb6v0Qi9W0Xiv5T2fbvMNBxPPq2EiA/NBkkbJvfuos6hYCJZrZL32XTHpBDXE1OPBG8DqBhVDR40kHItgyFxojIVxbRCncLZB+3vH6D76PCJe/W1iaMB0y3JH8aqHOgx1o7I6VIS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708442166; c=relaxed/simple;
	bh=R2L5t2PPpijixcH4eTUlchi9RHZP1nmoGuV8hs5450s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJ6M17YbgHbj2g//t5zHb0SSsy3bK/9u5UPzuX3nSMYLe5C4kf2+z2dYWOdbJDRP+/ElycxKa7Tcn5WD0wRuSX9WW/vYW/igocDs7swvTthFeQ56zLZdFWfzxLJJ0hs3Rdvs5KuivexlQxPUXhDmArylTaB/fNxr7tldPZfjfDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 008E4FEC;
	Tue, 20 Feb 2024 07:16:43 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A34E53F73F;
	Tue, 20 Feb 2024 07:16:02 -0800 (PST)
Date: Tue, 20 Feb 2024 15:16:00 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 04/13] KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
Message-ID: <20240220151600.GC8575@e124191.cambridge.arm.com>
References: <20240219092014.783809-1-maz@kernel.org>
 <20240219092014.783809-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219092014.783809-5-maz@kernel.org>

Hi,

On Mon, Feb 19, 2024 at 09:20:05AM +0000, Marc Zyngier wrote:
> Add the HCR_EL2 configuration for FEAT_NV2, adding the required
> bits for running a guest hypervisor, and overall merging the
> allowed bits provided by the guest.
> 
> This heavily replies on unavaliable features being sanitised
> when the HCR_EL2 shadow register is accessed, and only a couple
> of bits must be explicitly disabled.
> 
> Non-NV guests are completely unaffected by any of this.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h         |  1 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +--
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c         | 34 ++++++++++++++++++++++++-
>  4 files changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9e8999592f3a..a5361d9032a4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -498,6 +498,7 @@
>  #define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
>  #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
>  #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
> +#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
>  
>  #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
>  #define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)

I'm seeing double! (SYS_VNCR_EL2 is already defined a few lines down)

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e3fcf8c4d5b4..f5f701f309a9 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -271,10 +271,8 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  	__deactivate_traps_hfgxtr(vcpu);
>  }
>  
> -static inline void ___activate_traps(struct kvm_vcpu *vcpu)
> +static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
>  {
> -	u64 hcr = vcpu->arch.hcr_el2;
> -
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
>  		hcr |= HCR_TVM;
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index c50f8459e4fc..4103625e46c5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -40,7 +40,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
> -	___activate_traps(vcpu);
> +	___activate_traps(vcpu, vcpu->arch.hcr_el2);
>  	__activate_traps_common(vcpu);
>  
>  	val = vcpu->arch.cptr_el2;
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 58415783fd53..29f59c374f7a 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -33,11 +33,43 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
>  DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>  
> +/*
> + * HCR_EL2 bits that the NV guest can freely change (no RES0/RES1
> + * semantics, irrespective of the configuration), but that cannot be
> + * applied to the actual HW as things would otherwise break badly.
> + *
> + * - TGE: we want to use EL1, which is incompatible with it being set

Can you make this a bit clearer:

	we want the guest to use EL1

Assuming I've understood correctly. I first read it as 'we' == kvm.

> + *
> + * - API/APK: for hysterical raisins, we enable PAuth lazily, which
> + *   means that the guest's bits cannot be directly applied (we really
> + *   want to see the traps). Revisit this at some point.
> + */
> +#define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK)
> +
> +static u64 __compute_hcr(struct kvm_vcpu *vcpu)
> +{
> +	u64 hcr = vcpu->arch.hcr_el2;
> +
> +	if (!vcpu_has_nv(vcpu))
> +		return hcr;
> +
> +	if (is_hyp_ctxt(vcpu)) {
> +		hcr |= HCR_NV | HCR_NV2 | HCR_AT | HCR_TTLB;
> +
> +		if (!vcpu_el2_e2h_is_set(vcpu))
> +			hcr |= HCR_NV1;
> +
> +		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
> +	}
> +
> +	return hcr | (__vcpu_sys_reg(vcpu, HCR_EL2) & ~NV_HCR_GUEST_EXCLUDE);
> +}
> +
>  static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
> -	___activate_traps(vcpu);
> +	___activate_traps(vcpu, __compute_hcr(vcpu));
>  
>  	if (has_cntpoff()) {
>  		struct timer_map map;

Otherwise,

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

