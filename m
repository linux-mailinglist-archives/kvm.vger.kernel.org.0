Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B658308C22
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 19:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhA2SHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 13:07:02 -0500
Received: from foss.arm.com ([217.140.110.172]:52380 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232486AbhA2SGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 13:06:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F0D11424;
        Fri, 29 Jan 2021 10:05:58 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1023C3F885;
        Fri, 29 Jan 2021 10:05:55 -0800 (PST)
Date:   Fri, 29 Jan 2021 18:05:14 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [PATCH v3 07/66] KVM: arm64: nv: Handle HCR_EL2.NV system
 register traps
Message-ID: <20210129180514.58d7a261@slackpad.fritz.box>
In-Reply-To: <20201210160002.1407373-8-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
        <20201210160002.1407373-8-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Dec 2020 15:59:03 +0000
Marc Zyngier <maz@kernel.org> wrote:

Hi,

> From: Jintack Lim <jintack.lim@linaro.org>
> 
> ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
> this bit is set, accessing EL2 registers in EL1 traps to EL2. In
> addition, executing the following instructions in EL1 will trap to EL2:
> tlbi, at, eret, and msr/mrs instructions to access SP_EL1. Most of the
> instructions that trap to EL2 with the NV bit were undef at EL1 prior to
> ARM v8.3. The only instruction that was not undef is eret.
> 
> This patch sets up a handler for EL2 registers and SP_EL1 register
> accesses at EL1. The host hypervisor keeps those register values in
> memory, and will emulate their behavior.
> 
> This patch doesn't set the NV bit yet. It will be set in a later patch
> once nested virtualization support is completed.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: added SCTLR_EL2 RES0/RES1 handling]
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I compared the system register encodings in the first hunk against the
ARMv8 ARM, they are all fine.
I also checked the last hunk for (copy&paste) typos, all good as well.

Some comments below:

> ---
>  arch/arm64/include/asm/sysreg.h |  44 ++++++++++++-
>  arch/arm64/kvm/sys_regs.c       | 112 ++++++++++++++++++++++++++++++--
>  2 files changed, 150 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 82521cdbfc1c..05b49eafbb49 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -469,19 +469,50 @@
>  
>  #define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
>  
> +#define SYS_VPIDR_EL2			sys_reg(3, 4, 0, 0, 0)
> +#define SYS_VMPIDR_EL2			sys_reg(3, 4, 0, 0, 5)
> +
>  #define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
> +#define SYS_ACTLR_EL2			sys_reg(3, 4, 1, 0, 1)
> +#define SYS_HCR_EL2			sys_reg(3, 4, 1, 1, 0)
> +#define SYS_MDCR_EL2			sys_reg(3, 4, 1, 1, 1)
> +#define SYS_CPTR_EL2			sys_reg(3, 4, 1, 1, 2)
> +#define SYS_HSTR_EL2			sys_reg(3, 4, 1, 1, 3)
> +#define SYS_HACR_EL2			sys_reg(3, 4, 1, 1, 7)
> +
>  #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
> +
> +#define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
> +#define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
> +#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
> +#define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
> +#define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
> +
>  #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
> +
>  #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
>  #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
> +#define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
> +
>  #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
> +#define SYS_AFSR0_EL2			sys_reg(3, 4, 5, 1, 0)
> +#define SYS_AFSR1_EL2			sys_reg(3, 4, 5, 1, 1)
>  #define SYS_ESR_EL2			sys_reg(3, 4, 5, 2, 0)
>  #define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
>  #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
>  #define SYS_TFSR_EL2			sys_reg(3, 4, 5, 6, 0)
>  #define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
>  
> -#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1,  1)
> +#define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
> +#define SYS_HPFAR_EL2			sys_reg(3, 4, 6, 0, 4)
> +
> +#define SYS_MAIR_EL2			sys_reg(3, 4, 10, 2, 0)
> +#define SYS_AMAIR_EL2			sys_reg(3, 4, 10, 3, 0)
> +
> +#define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
> +#define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
> +#define SYS_RMR_EL2			sys_reg(3, 4, 12, 0, 2)
> +#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1, 1)
>  #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
>  #define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
>  #define SYS_ICH_AP0R1_EL2		__SYS__AP0Rx_EL2(1)
> @@ -523,15 +554,24 @@
>  #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
>  #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
>  
> +#define SYS_CONTEXTIDR_EL2		sys_reg(3, 4, 13, 0, 1)
> +#define SYS_TPIDR_EL2			sys_reg(3, 4, 13, 0, 2)
> +
> +#define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
> +#define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
> +
>  /* VHE encodings for architectural EL0/1 system registers */
>  #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
>  #define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
>  #define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
> +
>  #define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
>  #define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
>  #define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
> +
>  #define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
>  #define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
> +
>  #define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
>  #define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
>  #define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
> @@ -549,6 +589,8 @@
>  #define SYS_CNTV_CTL_EL02		sys_reg(3, 5, 14, 3, 1)
>  #define SYS_CNTV_CVAL_EL02		sys_reg(3, 5, 14, 3, 2)
>  
> +#define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_DSSBS	(BIT(44))
>  #define SCTLR_ELx_ATA	(BIT(43))
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3313dedfa505..c049867a39bc 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -104,6 +104,57 @@ static u32 get_ccsidr(u32 csselr)
>  	return ccsidr;
>  }
>  
> +static bool access_rw(struct kvm_vcpu *vcpu,
> +		      struct sys_reg_params *p,
> +		      const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
> +	else
> +		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> +
> +	return true;
> +}
> +
> +static bool access_wi(struct kvm_vcpu *vcpu,
> +		      struct sys_reg_params *p,
> +		      const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		return ignore_write(vcpu, p);
> +
> +	p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> +	return true;
> +}
> +
> +static bool access_sctlr_el2(struct kvm_vcpu *vcpu,
> +			     struct sys_reg_params *p,
> +			     const struct sys_reg_desc *r)
> +{
> +	if (p->is_write) {
> +		u64 val = p->regval;
> +
> +		if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) {
> +			val &= ~(GENMASK_ULL(63,45) | GENMASK_ULL(34, 32) |

In ARMv8 ARM F.c bits 49-45 are used for the TWE delay value. The
manual says it's RES0 when FEAT_TWED is not implemented, but this is
true for a lot of other feature bits we don't implement? So shall we
let a guest set them, reducing the mask to (63,50)?

> +				 BIT_ULL(17));

The ARMv8 ARM F.c lists bit 9 as RES0 as well for (E2H,TGE)=(1,1).

> +			val |=  SCTLR_EL1_RES1;
> +		} else {
> +			val &= ~(GENMASK_ULL(63,45) | BIT_ULL(42) |
> +				 GENMASK_ULL(39, 38) | GENMASK_ULL(35, 32) |
> +				 BIT_ULL(26) | BIT_ULL(24) | BIT_ULL(20) |
> +				 BIT_ULL(17) | GENMASK_ULL(15, 14) |
> +				 GENMASK(10, 7));
> +			val |=  SCTLR_EL2_RES1;
> +		}
> +
> +		vcpu_write_sys_reg(vcpu, val, r->reg);
> +	} else {
> +		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
>   */
> @@ -342,12 +393,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> -	if (p->is_write) {
> -		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
> +	access_rw(vcpu, p, r);
> +	if (p->is_write)
>  		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
> -	} else {
> -		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> -	}
>  
>  	trace_trap_reg(__func__, r->reg, p->is_write, p->regval);
>  
> @@ -1314,6 +1362,18 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	.set_user = set_raz_id_reg,		\
>  }
>  
> +static bool access_sp_el1(struct kvm_vcpu *vcpu,
> +			  struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		__vcpu_sys_reg(vcpu, SP_EL1) = p->regval;
> +	else
> +		p->regval = __vcpu_sys_reg(vcpu, SP_EL1);
> +
> +	return true;
> +}
> +
>  /*
>   * Architected system registers.
>   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> @@ -1692,9 +1752,51 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	 */
>  	{ SYS_DESC(SYS_PMCCFILTR_EL0), access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
>  
> +	{ SYS_DESC(SYS_VPIDR_EL2), access_rw, reset_val, VPIDR_EL2, 0 },
> +	{ SYS_DESC(SYS_VMPIDR_EL2), access_rw, reset_val, VMPIDR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_SCTLR_EL2), access_sctlr_el2, reset_val, SCTLR_EL2, SCTLR_EL2_RES1 },
> +	{ SYS_DESC(SYS_ACTLR_EL2), access_rw, reset_val, ACTLR_EL2, 0 },
> +	{ SYS_DESC(SYS_HCR_EL2), access_rw, reset_val, HCR_EL2, 0 },
> +	{ SYS_DESC(SYS_MDCR_EL2), access_rw, reset_val, MDCR_EL2, 0 },
> +	{ SYS_DESC(SYS_CPTR_EL2), access_rw, reset_val, CPTR_EL2, CPTR_EL2_RES1 },
> +	{ SYS_DESC(SYS_HSTR_EL2), access_rw, reset_val, HSTR_EL2, 0 },
> +	{ SYS_DESC(SYS_HACR_EL2), access_rw, reset_val, HACR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_TTBR0_EL2), access_rw, reset_val, TTBR0_EL2, 0 },
> +	{ SYS_DESC(SYS_TTBR1_EL2), access_rw, reset_val, TTBR1_EL2, 0 },
> +	{ SYS_DESC(SYS_TCR_EL2), access_rw, reset_val, TCR_EL2, TCR_EL2_RES1 },
> +	{ SYS_DESC(SYS_VTTBR_EL2), access_rw, reset_val, VTTBR_EL2, 0 },
> +	{ SYS_DESC(SYS_VTCR_EL2), access_rw, reset_val, VTCR_EL2, 0 },
> +
>  	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> +	{ SYS_DESC(SYS_SPSR_EL2), access_rw, reset_val, SPSR_EL2, 0 },
> +	{ SYS_DESC(SYS_ELR_EL2), access_rw, reset_val, ELR_EL2, 0 },
> +	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
> +
>  	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
> +	{ SYS_DESC(SYS_AFSR0_EL2), access_rw, reset_val, AFSR0_EL2, 0 },
> +	{ SYS_DESC(SYS_AFSR1_EL2), access_rw, reset_val, AFSR1_EL2, 0 },
> +	{ SYS_DESC(SYS_ESR_EL2), access_rw, reset_val, ESR_EL2, 0 },
>  	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
> +
> +	{ SYS_DESC(SYS_FAR_EL2), access_rw, reset_val, FAR_EL2, 0 },
> +	{ SYS_DESC(SYS_HPFAR_EL2), access_rw, reset_val, HPFAR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_MAIR_EL2), access_rw, reset_val, MAIR_EL2, 0 },
> +	{ SYS_DESC(SYS_AMAIR_EL2), access_rw, reset_val, AMAIR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_VBAR_EL2), access_rw, reset_val, VBAR_EL2, 0 },
> +	{ SYS_DESC(SYS_RVBAR_EL2), access_rw, reset_val, RVBAR_EL2, 0 },
> +	{ SYS_DESC(SYS_RMR_EL2), access_wi, reset_val, RMR_EL2, 1 },


Why is this WI, exactly? Isn't EL2 the highest implemented EL from a
guest's point of view, and thus a write to RMR_EL2 with bit 1 set should
trigger a reset (to AArch64)?
I see that we don't NEED to implement this register (as we don't
support AArch32), but that should look differently here then?

The rest looks alright to me.

Cheers,
Andre

> +
> +	{ SYS_DESC(SYS_CONTEXTIDR_EL2), access_rw, reset_val, CONTEXTIDR_EL2, 0 },
> +	{ SYS_DESC(SYS_TPIDR_EL2), access_rw, reset_val, TPIDR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_CNTVOFF_EL2), access_rw, reset_val, CNTVOFF_EL2, 0 },
> +	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },
>  };
>  
>  static bool trap_dbgidr(struct kvm_vcpu *vcpu,

