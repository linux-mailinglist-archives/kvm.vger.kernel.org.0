Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28137495255
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiATQ2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:28:46 -0500
Received: from foss.arm.com ([217.140.110.172]:44202 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376939AbiATQ2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 11:28:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6D3FED1;
        Thu, 20 Jan 2022 08:28:44 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDB443F73D;
        Thu, 20 Jan 2022 08:28:42 -0800 (PST)
Date:   Thu, 20 Jan 2022 16:28:47 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v5 19/69] KVM: arm64: nv: Handle SPSR_EL2 specially
Message-ID: <YemNv+Bmr4hXmi3P@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-20-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-20-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Nov 29, 2021 at 08:01:00PM +0000, Marc Zyngier wrote:
> SPSR_EL2 needs special attention when running nested on ARMv8.3:
> 
> If taking an exception while running at vEL2 (actually EL1), the
> HW will update the SPSR_EL1 register with the EL1 mode. We need
> to track this in order to make sure that accesses to the virtual
> view of SPSR_EL2 is correct.
> 
> To do so, we place an illegal value in SPSR_EL1.M, and patch it
> accordingly if required when accessing it.

When KVM runs a L1 guest hypervisor with hardware HCR_EL2.NV1 clear (virtual
HCR_EL2.E2H set), when an exception is taken from vEL2 to vEL2, SPSR_EL1.M is
automatically set to CurrentEL_EL2. But this doesn't happen when hardware NV1 is
set (virtual HCR_EL2.E2H unset) and as far as I can tell this patch does the
right thing to emulate it in software:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 37 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c            | 23 +++++++++++++++--
>  2 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 46c849ba281e..2db11ff3fdad 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -241,6 +241,43 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
>  	return __is_hyp_ctxt(&vcpu->arch.ctxt);
>  }
>  
> +static inline u64 __fixup_spsr_el2_write(struct kvm_cpu_context *ctxt, u64 val)
> +{
> +	if (!__vcpu_el2_e2h_is_set(ctxt)) {
> +		/*
> +		 * Clear the .M field when writing SPSR to the CPU, so that we
> +		 * can detect when the CPU clobbered our SPSR copy during a
> +		 * local exception.
> +		 */
> +		val &= ~0xc;
> +	}
> +
> +	return val;
> +}
> +
> +static inline u64 __fixup_spsr_el2_read(const struct kvm_cpu_context *ctxt, u64 val)
> +{
> +	if (__vcpu_el2_e2h_is_set(ctxt))
> +		return val;
> +
> +	/*
> +	 * SPSR.M == 0 means the CPU has not touched the SPSR, so the
> +	 * register has still the value we saved on the last write.
> +	 */
> +	if ((val & 0xc) == 0)
> +		return ctxt_sys_reg(ctxt, SPSR_EL2);
> +
> +	/*
> +	 * Otherwise there was a "local" exception on the CPU,
> +	 * which from the guest's point of view was being taken from
> +	 * EL2 to EL2, although it actually happened to be from
> +	 * EL1 to EL1.
> +	 * So we need to fix the .M field in SPSR, to make it look
> +	 * like EL2, which is what the guest would expect.
> +	 */
> +	return (val & ~0x0c) | CurrentEL_EL2;
> +}
> +
>  /*
>   * The layout of SPSR for an AArch32 state is different when observed from an
>   * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 61596355e42d..875040bcfbe1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -133,11 +133,14 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>  			goto memory_read;
>  
>  		/*
> -		 * ELR_EL2 is special cased for now.
> +		 * ELR_EL2 and SPSR_EL2 are special cased for now.
>  		 */
>  		switch (reg) {
>  		case ELR_EL2:
>  			return read_sysreg_el1(SYS_ELR);
> +		case SPSR_EL2:
> +			val = read_sysreg_el1(SYS_SPSR);
> +			return __fixup_spsr_el2_read(&vcpu->arch.ctxt, val);
>  		}
>  
>  		/*
> @@ -194,6 +197,10 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>  		case ELR_EL2:
>  			write_sysreg_el1(val, SYS_ELR);
>  			return;
> +		case SPSR_EL2:
> +			val = __fixup_spsr_el2_write(&vcpu->arch.ctxt, val);
> +			write_sysreg_el1(val, SYS_SPSR);
> +			return;
>  		}
>  
>  		/* No EL1 counterpart? We're done here.? */
> @@ -1620,6 +1627,18 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_spsr_el2(struct kvm_vcpu *vcpu,
> +			    struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
> +	else
> +		p->regval = vcpu_read_sys_reg(vcpu, SPSR_EL2);
> +
> +	return true;
> +}
> +
>  /*
>   * Architected system registers.
>   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> @@ -2052,7 +2071,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_VTCR_EL2), access_rw, reset_val, VTCR_EL2, 0 },
>  
>  	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> -	{ SYS_DESC(SYS_SPSR_EL2), access_rw, reset_val, SPSR_EL2, 0 },
> +	{ SYS_DESC(SYS_SPSR_EL2), access_spsr_el2, reset_val, SPSR_EL2, 0 },
>  	{ SYS_DESC(SYS_ELR_EL2), access_rw, reset_val, ELR_EL2, 0 },
>  	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
>  
> -- 
> 2.30.2
> 
