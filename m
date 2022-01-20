Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEA2495121
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 16:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346406AbiATPNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 10:13:07 -0500
Received: from foss.arm.com ([217.140.110.172]:41592 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376604AbiATPMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 10:12:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08029101E;
        Thu, 20 Jan 2022 07:12:48 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D04C83F73D;
        Thu, 20 Jan 2022 07:12:45 -0800 (PST)
Date:   Thu, 20 Jan 2022 15:12:54 +0000
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
Subject: Re: [PATCH v5 18/69] KVM: arm64: nv: Handle virtual EL2 registers in
 vcpu_read/write_sys_reg()
Message-ID: <Yel79mQSV/8iINrS@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-19-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-19-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Nov 29, 2021 at 08:00:59PM +0000, Marc Zyngier wrote:
> KVM internally uses accessor functions when reading or writing the
> guest's system registers. This takes care of accessing either the stored
> copy or using the "live" EL1 system registers when the host uses VHE.
> 
> With the introduction of virtual EL2 we add a bunch of EL2 system
> registers, which now must also be taken care of:
> - If the guest is running in vEL2, and we access an EL1 sysreg, we must
>   revert to the stored version of that, and not use the CPU's copy.
> - If the guest is running in vEL1, and we access an EL2 sysreg, we must
>   also use the stored version, since the CPU carries the EL1 copy.
> - Some EL2 system registers are supposed to affect the current execution
>   of the system, so we need to put them into their respective EL1
>   counterparts. For this we need to define a mapping between the two.
>   This is done using the newly introduced struct el2_sysreg_map.
> - Some EL2 system registers have a different format than their EL1
>   counterpart, so we need to translate them before writing them to the
>   CPU. This is done using an (optional) translate function in the map.
> - There are the three special registers SP_EL2, SPSR_EL2 and ELR_EL2,
>   which need some separate handling (SPSR_EL2 is being handled in a
>   separate patch).
> 
> All of these cases are now wrapped into the existing accessor functions,
> so KVM users wouldn't need to care whether they access EL2 or EL1
> registers and also which state the guest is in.
> 
> This handles what was formerly known as the "shadow state" dynamically,
> without requiring a separate copy for each vCPU EL.
> 
> Co-developed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 143 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 139 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 730a24468915..61596355e42d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -24,6 +24,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/perf_event.h>
>  #include <asm/sysreg.h>
>  
> @@ -64,23 +65,157 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>  	return false;
>  }
>  
> +#define PURE_EL2_SYSREG(el2)						\
> +	case el2: {							\
> +		*el1r = el2;						\
> +		return true;						\
> +	}
> +
> +#define MAPPED_EL2_SYSREG(el2, el1, fn)					\
> +	case el2: {							\
> +		*xlate = fn;						\
> +		*el1r = el1;						\
> +		return true;						\
> +	}
> +
> +static bool get_el2_mapping(unsigned int reg,
> +			    unsigned int *el1r, u64 (**xlate)(u64))

Nitpick: this could be renamed to get_el2_to_el1_mapping() to remove any
ambiguities regarding what is being mapped to what (and to match the
translate_* functions). With our without this change, the patch looks
correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> +{
> +	switch (reg) {
> +		PURE_EL2_SYSREG(  VPIDR_EL2	);
> +		PURE_EL2_SYSREG(  VMPIDR_EL2	);
> +		PURE_EL2_SYSREG(  ACTLR_EL2	);
> +		PURE_EL2_SYSREG(  HCR_EL2	);
> +		PURE_EL2_SYSREG(  MDCR_EL2	);
> +		PURE_EL2_SYSREG(  HSTR_EL2	);
> +		PURE_EL2_SYSREG(  HACR_EL2	);
> +		PURE_EL2_SYSREG(  VTTBR_EL2	);
> +		PURE_EL2_SYSREG(  VTCR_EL2	);
> +		PURE_EL2_SYSREG(  RVBAR_EL2	);
> +		PURE_EL2_SYSREG(  TPIDR_EL2	);
> +		PURE_EL2_SYSREG(  HPFAR_EL2	);
> +		PURE_EL2_SYSREG(  ELR_EL2	);
> +		PURE_EL2_SYSREG(  SPSR_EL2	);
> +		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
> +				  translate_sctlr_el2_to_sctlr_el1	     );
> +		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,
> +				  translate_cptr_el2_to_cpacr_el1	     );
> +		MAPPED_EL2_SYSREG(TTBR0_EL2,   TTBR0_EL1,
> +				  translate_ttbr0_el2_to_ttbr0_el1	     );
> +		MAPPED_EL2_SYSREG(TTBR1_EL2,   TTBR1_EL1,   NULL	     );
> +		MAPPED_EL2_SYSREG(TCR_EL2,     TCR_EL1,
> +				  translate_tcr_el2_to_tcr_el1		     );
> +		MAPPED_EL2_SYSREG(VBAR_EL2,    VBAR_EL1,    NULL	     );
> +		MAPPED_EL2_SYSREG(AFSR0_EL2,   AFSR0_EL1,   NULL	     );
> +		MAPPED_EL2_SYSREG(AFSR1_EL2,   AFSR1_EL1,   NULL	     );
> +		MAPPED_EL2_SYSREG(ESR_EL2,     ESR_EL1,     NULL	     );
> +		MAPPED_EL2_SYSREG(FAR_EL2,     FAR_EL1,     NULL	     );
> +		MAPPED_EL2_SYSREG(MAIR_EL2,    MAIR_EL1,    NULL	     );
> +		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
> +		MAPPED_EL2_SYSREG(CNTHCTL_EL2, CNTKCTL_EL1,
> +				  translate_cnthctl_el2_to_cntkctl_el1	     );
> +	default:
> +		return false;
> +	}
> +}
> +
>  u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>  {
>  	u64 val = 0x8badf00d8badf00d;
> +	u64 (*xlate)(u64) = NULL;
> +	unsigned int el1r;
> +
> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> +		goto memory_read;
> +
> +	if (unlikely(get_el2_mapping(reg, &el1r, &xlate))) {
> +		if (!is_hyp_ctxt(vcpu))
> +			goto memory_read;
> +
> +		/*
> +		 * ELR_EL2 is special cased for now.
> +		 */
> +		switch (reg) {
> +		case ELR_EL2:
> +			return read_sysreg_el1(SYS_ELR);
> +		}
> +
> +		/*
> +		 * If this register does not have an EL1 counterpart,
> +		 * then read the stored EL2 version.
> +		 */
> +		if (reg == el1r)
> +			goto memory_read;
> +
> +		/*
> +		 * If we have a non-VHE guest and that the sysreg
> +		 * requires translation to be used at EL1, use the
> +		 * in-memory copy instead.
> +		 */
> +		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
> +			goto memory_read;
> +
> +		/* Get the current version of the EL1 counterpart. */
> +		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
> +		return val;
> +	}
> +
> +	/* EL1 register can't be on the CPU if the guest is in vEL2. */
> +	if (unlikely(is_hyp_ctxt(vcpu)))
> +		goto memory_read;
>  
> -	if (vcpu->arch.sysregs_loaded_on_cpu &&
> -	    __vcpu_read_sys_reg_from_cpu(reg, &val))
> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
>  		return val;
>  
> +memory_read:
>  	return __vcpu_sys_reg(vcpu, reg);
>  }
>  
>  void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>  {
> -	if (vcpu->arch.sysregs_loaded_on_cpu &&
> -	    __vcpu_write_sys_reg_to_cpu(val, reg))
> +	u64 (*xlate)(u64) = NULL;
> +	unsigned int el1r;
> +
> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> +		goto memory_write;
> +
> +	if (unlikely(get_el2_mapping(reg, &el1r, &xlate))) {
> +		if (!is_hyp_ctxt(vcpu))
> +			goto memory_write;
> +
> +		/*
> +		 * Always store a copy of the write to memory to avoid having
> +		 * to reverse-translate virtual EL2 system registers for a
> +		 * non-VHE guest hypervisor.
> +		 */
> +		__vcpu_sys_reg(vcpu, reg) = val;
> +
> +		switch (reg) {
> +		case ELR_EL2:
> +			write_sysreg_el1(val, SYS_ELR);
> +			return;
> +		}
> +
> +		/* No EL1 counterpart? We're done here.? */
> +		if (reg == el1r)
> +			return;
> +
> +		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
> +			val = xlate(val);
> +
> +		/* Redirect this to the EL1 version of the register. */
> +		WARN_ON(!__vcpu_write_sys_reg_to_cpu(val, el1r));
> +		return;
> +	}
> +
> +	/* EL1 register can't be on the CPU if the guest is in vEL2. */
> +	if (unlikely(is_hyp_ctxt(vcpu)))
> +		goto memory_write;
> +
> +	if (__vcpu_write_sys_reg_to_cpu(val, reg))
>  		return;
>  
> +memory_write:
>  	 __vcpu_sys_reg(vcpu, reg) = val;
>  }
>  
> -- 
> 2.30.2
> 
