Return-Path: <kvm+bounces-28995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C37519A0B16
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 15:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9FEC1C224B3
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 13:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FA220968C;
	Wed, 16 Oct 2024 13:12:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD6220966C
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 13:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729084376; cv=none; b=Q+XrJf9ie68E4fBfGBHEHhD0BGcnY/uxpIryspu6Kecc7PfGuJoxPskdXF3mR9Vu8iE+yT/5SLOOwb11GvboXJCDIjN970Sb4s9PrStJtSwzCptSRkR0u+uxap6YWRnviMjTrF2D/c/L2ucjXNnNrDRHb0opAVbOCELxbgPz0N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729084376; c=relaxed/simple;
	bh=HU9U5QZ0a2UXLsRPStAGsxlBL2YCiBiLE/ramke5q+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZnlLp95iiinEMwUxZjiK64wX31sv9r9t319v5QvtbKeWnTkHhFSSB8dVb/Sc+QWvGmn3OAqO7FRbdrNSDVUZJi698e5LDX24ar1cwovDplbN402+aM172x40ObjMRCwIso6jfaCcuYLg2IPWYkG80Of8KgQWlQkHoCd+p/hBtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE820FEC;
	Wed, 16 Oct 2024 06:13:23 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D9253F528;
	Wed, 16 Oct 2024 06:12:52 -0700 (PDT)
Date: Wed, 16 Oct 2024 14:12:49 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 07/36] KVM: arm64: nv: Save/Restore vEL2 sysregs
Message-ID: <Zw-70Uocs5JvXz7e@raptor>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-8-maz@kernel.org>

Hi Marc,

On Wed, Oct 09, 2024 at 07:59:50PM +0100, Marc Zyngier wrote:
> Whenever we need to restore the guest's system registers to the CPU, we
> now need to take care of the EL2 system registers as well. Most of them
> are accessed via traps only, but some have an immediate effect and also
> a guest running in VHE mode would expect them to be accessible via their
> EL1 encoding, which we do not trap.
> 
> For vEL2 we write the virtual EL2 registers with an identical format directly
> into their EL1 counterpart, and translate the few registers that have a
> different format for the same effect on the execution when running a
> non-VHE guest guest hypervisor.
> 
> Based on an initial patch from Andre Przywara, rewritten many times
> since.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   5 +-
>  arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   2 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 137 ++++++++++++++++++++-
>  3 files changed, 139 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 1579a3c08a36b..d67628d01bf5e 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -152,9 +152,10 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
>  }
>  
> -static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> +static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
> +					      u64 mpidr)
>  {
> -	write_sysreg(ctxt_sys_reg(ctxt, MPIDR_EL1),	vmpidr_el2);
> +	write_sysreg(mpidr,				vmpidr_el2);
>  
>  	if (has_vhe() ||
>  	    !cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> index 29305022bc048..dba101565de36 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> @@ -28,7 +28,7 @@ void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
>  
>  void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
>  {
> -	__sysreg_restore_el1_state(ctxt);
> +	__sysreg_restore_el1_state(ctxt, ctxt_sys_reg(ctxt, MPIDR_EL1));
>  	__sysreg_restore_common_state(ctxt);
>  	__sysreg_restore_user_state(ctxt);
>  	__sysreg_restore_el2_return_state(ctxt);
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index e12bd7d6d2dce..e0df14ead2657 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -15,6 +15,108 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_nested.h>
>  
> +static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
> +{
> +	/* These registers are common with EL1 */
> +	__vcpu_sys_reg(vcpu, PAR_EL1)	= read_sysreg(par_el1);
> +	__vcpu_sys_reg(vcpu, TPIDR_EL1)	= read_sysreg(tpidr_el1);
> +
> +	__vcpu_sys_reg(vcpu, ESR_EL2)	= read_sysreg_el1(SYS_ESR);
> +	__vcpu_sys_reg(vcpu, AFSR0_EL2)	= read_sysreg_el1(SYS_AFSR0);
> +	__vcpu_sys_reg(vcpu, AFSR1_EL2)	= read_sysreg_el1(SYS_AFSR1);
> +	__vcpu_sys_reg(vcpu, FAR_EL2)	= read_sysreg_el1(SYS_FAR);
> +	__vcpu_sys_reg(vcpu, MAIR_EL2)	= read_sysreg_el1(SYS_MAIR);
> +	__vcpu_sys_reg(vcpu, VBAR_EL2)	= read_sysreg_el1(SYS_VBAR);
> +	__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2) = read_sysreg_el1(SYS_CONTEXTIDR);
> +	__vcpu_sys_reg(vcpu, AMAIR_EL2)	= read_sysreg_el1(SYS_AMAIR);
> +
> +	/*
> +	 * In VHE mode those registers are compatible between EL1 and EL2,
> +	 * and the guest uses the _EL1 versions on the CPU naturally.
> +	 * So we save them into their _EL2 versions here.
> +	 * For nVHE mode we trap accesses to those registers, so our
> +	 * _EL2 copy in sys_regs[] is always up-to-date and we don't need
> +	 * to save anything here.
> +	 */
> +	if (vcpu_el2_e2h_is_set(vcpu)) {
> +		u64 val;
> +
> +		/*
> +		 * We don't save CPTR_EL2, as accesses to CPACR_EL1
> +		 * are always trapped, ensuring that the in-memory
> +		 * copy is always up-to-date. A small blessing...
> +		 */
> +		__vcpu_sys_reg(vcpu, SCTLR_EL2)	= read_sysreg_el1(SYS_SCTLR);
> +		__vcpu_sys_reg(vcpu, TTBR0_EL2)	= read_sysreg_el1(SYS_TTBR0);
> +		__vcpu_sys_reg(vcpu, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
> +		__vcpu_sys_reg(vcpu, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
> +
> +		/*
> +		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
> +		 * the interesting CNTHCTL_EL2 bits live. So preserve these
> +		 * bits when reading back the guest-visible value.
> +		 */
> +		val = read_sysreg_el1(SYS_CNTKCTL);
> +		val &= CNTKCTL_VALID_BITS;
> +		__vcpu_sys_reg(vcpu, CNTHCTL_EL2) &= ~CNTKCTL_VALID_BITS;
> +		__vcpu_sys_reg(vcpu, CNTHCTL_EL2) |= val;
> +	}
> +
> +	__vcpu_sys_reg(vcpu, SP_EL2)	= read_sysreg(sp_el1);
> +	__vcpu_sys_reg(vcpu, ELR_EL2)	= read_sysreg_el1(SYS_ELR);
> +	__vcpu_sys_reg(vcpu, SPSR_EL2)	= read_sysreg_el1(SYS_SPSR);
> +}
> +
> +static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
> +{
> +	u64 val;
> +
> +	/* These registers are common with EL1 */
> +	write_sysreg(__vcpu_sys_reg(vcpu, PAR_EL1),	par_el1);
> +	write_sysreg(__vcpu_sys_reg(vcpu, TPIDR_EL1),	tpidr_el1);
> +
> +	write_sysreg(read_cpuid_id(),				vpidr_el2);
> +	write_sysreg(__vcpu_sys_reg(vcpu, MPIDR_EL1),		vmpidr_el2);
> +	write_sysreg_el1(__vcpu_sys_reg(vcpu, MAIR_EL2),	SYS_MAIR);
> +	write_sysreg_el1(__vcpu_sys_reg(vcpu, VBAR_EL2),	SYS_VBAR);
> +	write_sysreg_el1(__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2),	SYS_CONTEXTIDR);
> +	write_sysreg_el1(__vcpu_sys_reg(vcpu, AMAIR_EL2),	SYS_AMAIR);
> +
> +	if (vcpu_el2_e2h_is_set(vcpu)) {
> +		/*
> +		 * In VHE mode those registers are compatible between
> +		 * EL1 and EL2.
> +		 */
> +		write_sysreg_el1(__vcpu_sys_reg(vcpu, SCTLR_EL2),   SYS_SCTLR);
> +		write_sysreg_el1(__vcpu_sys_reg(vcpu, CPTR_EL2),    SYS_CPACR);
> +		write_sysreg_el1(__vcpu_sys_reg(vcpu, TTBR0_EL2),   SYS_TTBR0);
> +		write_sysreg_el1(__vcpu_sys_reg(vcpu, TTBR1_EL2),   SYS_TTBR1);
> +		write_sysreg_el1(__vcpu_sys_reg(vcpu, TCR_EL2),	    SYS_TCR);
> +		write_sysreg_el1(__vcpu_sys_reg(vcpu, CNTHCTL_EL2), SYS_CNTKCTL);
> +	} else {
> +		/*
> +		 * CNTHCTL_EL2 only affects EL1 when running nVHE, so
> +		 * no need to restore it.
> +		 */

I'm having such a hard time parsing the comment - might be just me coming back to
this code after such a long time.

If CNTHCTL_EL2 only affects EL1 when running nVHE, and the else branch deals
with the nVHE case, why isn't CNTHCTL_EL2 restored?

As for the 'only' part of the comment: when E2H=1, bits 10 and 11, EL1PCTEN and
EL1PTEN (why isn't this named EL1PCEN if it does the same thing as bit 1 when
E2H=0?), trap EL1 and EL0 accesses to physical counter and timer registers.

Or 'only' in this context means only EL1, and not EL2 also?

Thanks,
Alex

> +		val = translate_sctlr_el2_to_sctlr_el1(__vcpu_sys_reg(vcpu, SCTLR_EL2));
> +		write_sysreg_el1(val, SYS_SCTLR);
> +		val = translate_cptr_el2_to_cpacr_el1(__vcpu_sys_reg(vcpu, CPTR_EL2));
> +		write_sysreg_el1(val, SYS_CPACR);
> +		val = translate_ttbr0_el2_to_ttbr0_el1(__vcpu_sys_reg(vcpu, TTBR0_EL2));
> +		write_sysreg_el1(val, SYS_TTBR0);
> +		val = translate_tcr_el2_to_tcr_el1(__vcpu_sys_reg(vcpu, TCR_EL2));
> +		write_sysreg_el1(val, SYS_TCR);
> +	}

