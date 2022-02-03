Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976B94A8765
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 16:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351761AbiBCPOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 10:14:10 -0500
Received: from foss.arm.com ([217.140.110.172]:51994 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351767AbiBCPOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 10:14:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CD9D1424;
        Thu,  3 Feb 2022 07:14:04 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5A5F3F40C;
        Thu,  3 Feb 2022 07:14:01 -0800 (PST)
Date:   Thu, 3 Feb 2022 15:14:15 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 16/64] KVM: arm64: nv: Save/Restore vEL2 sysregs
Message-ID: <YfvxMmP03nXsfcTo@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-17-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-17-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jan 28, 2022 at 12:18:24PM +0000, Marc Zyngier wrote:
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
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   5 +-
>  arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   2 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 125 ++++++++++++++++++++-
>  3 files changed, 127 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 7ecca8b07851..283f780f5f56 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -92,9 +92,10 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
>  }
>  
> -static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> +static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
> +					      u64 mpidr)
>  {
> -	write_sysreg(ctxt_sys_reg(ctxt, MPIDR_EL1),	vmpidr_el2);
> +	write_sysreg(mpidr,				vmpidr_el2);
>  	write_sysreg(ctxt_sys_reg(ctxt, CSSELR_EL1),	csselr_el1);
>  
>  	if (has_vhe() ||
> diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> index 29305022bc04..dba101565de3 100644
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
> index 007a12dd4351..3e26a78d00c5 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -13,6 +13,96 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
> +#include <asm/kvm_nested.h>
> +
> +static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
> +{
> +	/* These registers are common with EL1 */
> +	ctxt_sys_reg(ctxt, CSSELR_EL1)	= read_sysreg(csselr_el1);
> +	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg(par_el1);
> +	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
> +
> +	ctxt_sys_reg(ctxt, ESR_EL2)	= read_sysreg_el1(SYS_ESR);
> +	ctxt_sys_reg(ctxt, AFSR0_EL2)	= read_sysreg_el1(SYS_AFSR0);
> +	ctxt_sys_reg(ctxt, AFSR1_EL2)	= read_sysreg_el1(SYS_AFSR1);
> +	ctxt_sys_reg(ctxt, FAR_EL2)	= read_sysreg_el1(SYS_FAR);
> +	ctxt_sys_reg(ctxt, MAIR_EL2)	= read_sysreg_el1(SYS_MAIR);
> +	ctxt_sys_reg(ctxt, VBAR_EL2)	= read_sysreg_el1(SYS_VBAR);
> +	ctxt_sys_reg(ctxt, CONTEXTIDR_EL2) = read_sysreg_el1(SYS_CONTEXTIDR);
> +	ctxt_sys_reg(ctxt, AMAIR_EL2)	= read_sysreg_el1(SYS_AMAIR);
> +
> +	/*
> +	 * In VHE mode those registers are compatible between EL1 and EL2,
> +	 * and the guest uses the _EL1 versions on the CPU naturally.
> +	 * So we save them into their _EL2 versions here.
> +	 * For nVHE mode we trap accesses to those registers, so our
> +	 * _EL2 copy in sys_regs[] is always up-to-date and we don't need
> +	 * to save anything here.
> +	 */
> +	if (__vcpu_el2_e2h_is_set(ctxt)) {
> +		ctxt_sys_reg(ctxt, SCTLR_EL2)	= read_sysreg_el1(SYS_SCTLR);
> +		ctxt_sys_reg(ctxt, CPTR_EL2)	= read_sysreg_el1(SYS_CPACR);
> +		ctxt_sys_reg(ctxt, TTBR0_EL2)	= read_sysreg_el1(SYS_TTBR0);
> +		ctxt_sys_reg(ctxt, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
> +		ctxt_sys_reg(ctxt, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
> +		ctxt_sys_reg(ctxt, CNTHCTL_EL2)	= read_sysreg_el1(SYS_CNTKCTL);
> +	}
> +
> +	ctxt_sys_reg(ctxt, SP_EL2)	= read_sysreg(sp_el1);
> +	ctxt_sys_reg(ctxt, ELR_EL2)	= read_sysreg_el1(SYS_ELR);
> +	ctxt_sys_reg(ctxt, SPSR_EL2)	= __fixup_spsr_el2_read(ctxt, read_sysreg_el1(SYS_SPSR));
> +}
> +
> +static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
> +{
> +	u64 val;
> +
> +	/* These registers are common with EL1 */
> +	write_sysreg(ctxt_sys_reg(ctxt, CSSELR_EL1),	csselr_el1);
> +	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
> +	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
> +
> +	write_sysreg(read_cpuid_id(),			vpidr_el2);

This is sneaky. The the pseudocode for accessing MPDIR_EL1 is:

if PSTATE.EL == EL0 then
    [..]
elsif PSTATE.EL == EL1 then
    if EL2Enabled() && (!HaveEL(EL3) || SCR_EL3.FGTEn == '1') && HFGRTR_EL2.MIDR_EL1 == '1' then
        AArch64.SystemAccessTrap(EL2, 0x18);
    elsif EL2Enabled() then
        return VPIDR_EL2;
    else
        return MIDR_EL1;
elsif PSTATE.EL == EL2 then
    return MIDR_EL1;
[..]

From the guest's point of view, they are running at virtual EL2, a read of
MIDR_EL1 returns MIDR_EL1, and not what they programmed in VPIDR_EL2.

From the host's point of view, the guest is running in hardware EL1 and a
read of MPIDR_EL1 returns the hardware value of the VPIDR_EL2 register.

Because of the above, KVM programs hardware VPIDR_EL2 with the hardware
MPIDR_EL1 value, instead of the L1 hypervisor virtual VPIDR_EL2 value.

I feel that this deserves a comment because it's not immediately obvious
what is happening, perhaps along the lines "Reading MIDR_EL1 from virtual
EL2 returns the hardware MIDR_EL1 value, not the value that the guest
programmed in virtual VPIDR_EL2".

> +	write_sysreg(ctxt_sys_reg(ctxt, MPIDR_EL1),	vmpidr_el2);

But here, the guest will always read the value that KVM computed for the VM
in reset_mpidr(), that's why KVM is writing the shadow MPIDR value.

> +	write_sysreg_el1(ctxt_sys_reg(ctxt, MAIR_EL2),	SYS_MAIR);
> +	write_sysreg_el1(ctxt_sys_reg(ctxt, VBAR_EL2),	SYS_VBAR);
> +	write_sysreg_el1(ctxt_sys_reg(ctxt, CONTEXTIDR_EL2),SYS_CONTEXTIDR);
> +	write_sysreg_el1(ctxt_sys_reg(ctxt, AMAIR_EL2),	SYS_AMAIR);
> +
> +	if (__vcpu_el2_e2h_is_set(ctxt)) {
> +		/*
> +		 * In VHE mode those registers are compatible between
> +		 * EL1 and EL2.
> +		 */
> +		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL2),	SYS_SCTLR);
> +		write_sysreg_el1(ctxt_sys_reg(ctxt, CPTR_EL2),	SYS_CPACR);
> +		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL2),	SYS_TTBR0);
> +		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL2),	SYS_TTBR1);
> +		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL2),	SYS_TCR);
> +		write_sysreg_el1(ctxt_sys_reg(ctxt, CNTHCTL_EL2), SYS_CNTKCTL);
> +	} else {
> +		val = translate_sctlr_el2_to_sctlr_el1(ctxt_sys_reg(ctxt, SCTLR_EL2));
> +		write_sysreg_el1(val, SYS_SCTLR);
> +		val = translate_cptr_el2_to_cpacr_el1(ctxt_sys_reg(ctxt, CPTR_EL2));
> +		write_sysreg_el1(val, SYS_CPACR);
> +		val = translate_ttbr0_el2_to_ttbr0_el1(ctxt_sys_reg(ctxt, TTBR0_EL2));
> +		write_sysreg_el1(val, SYS_TTBR0);
> +		val = translate_tcr_el2_to_tcr_el1(ctxt_sys_reg(ctxt, TCR_EL2));
> +		write_sysreg_el1(val, SYS_TCR);
> +		val = translate_cnthctl_el2_to_cntkctl_el1(ctxt_sys_reg(ctxt, CNTHCTL_EL2));
> +		write_sysreg_el1(val, SYS_CNTKCTL);
> +	}
> +
> +	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL2),	SYS_ESR);
> +	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL2),	SYS_AFSR0);
> +	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL2),	SYS_AFSR1);
> +	write_sysreg_el1(ctxt_sys_reg(ctxt, FAR_EL2),	SYS_FAR);
> +	write_sysreg(ctxt_sys_reg(ctxt, SP_EL2),	sp_el1);
> +	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL2),	SYS_ELR);
> +
> +	val = __fixup_spsr_el2_write(ctxt, ctxt_sys_reg(ctxt, SPSR_EL2));
> +	write_sysreg_el1(val,	SYS_SPSR);
> +}
>  
>  /*
>   * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
> @@ -65,6 +155,7 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
>  	struct kvm_cpu_context *host_ctxt;
> +	u64 mpidr;
>  
>  	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  	__sysreg_save_user_state(host_ctxt);
> @@ -77,7 +168,29 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
>  	 */
>  	__sysreg32_restore_state(vcpu);
>  	__sysreg_restore_user_state(guest_ctxt);
> -	__sysreg_restore_el1_state(guest_ctxt);
> +
> +	if (unlikely(__is_hyp_ctxt(guest_ctxt))) {
> +		__sysreg_restore_vel2_state(guest_ctxt);
> +	} else {
> +		if (vcpu_has_nv(vcpu)) {
> +			/*
> +			 * Only set VPIDR_EL2 for nested VMs, as this is the
> +			 * only time it changes. We'll restore the MIDR_EL1
> +			 * view on put.
> +			 */
> +			write_sysreg(ctxt_sys_reg(guest_ctxt, VPIDR_EL2), vpidr_el2);
> +
> +			/*
> +			 * As we're restoring a nested guest, set the value
> +			 * provided by the guest hypervisor.
> +			 */
> +			mpidr = ctxt_sys_reg(guest_ctxt, VMPIDR_EL2);
> +		} else {
> +			mpidr = ctxt_sys_reg(guest_ctxt, MPIDR_EL1);
> +		}
> +
> +		__sysreg_restore_el1_state(guest_ctxt, mpidr);
> +	}
>  
>  	vcpu->arch.sysregs_loaded_on_cpu = true;
>  
> @@ -103,12 +216,20 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
>  	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  	deactivate_traps_vhe_put(vcpu);
>  
> -	__sysreg_save_el1_state(guest_ctxt);
> +	if (unlikely(__is_hyp_ctxt(guest_ctxt)))
> +		__sysreg_save_vel2_state(guest_ctxt);
> +	else
> +		__sysreg_save_el1_state(guest_ctxt);
> +
>  	__sysreg_save_user_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  
>  	/* Restore host user state */
>  	__sysreg_restore_user_state(host_ctxt);
>  
> +	/* If leaving a nesting guest, restore MPIDR_EL1 default view */
> +	if (vcpu_has_nv(vcpu))
> +		write_sysreg(read_cpuid_id(),	vpidr_el2);
> +
>  	vcpu->arch.sysregs_loaded_on_cpu = false;

Compared __sysreg_{save,restore}_vel2_state() with
__sysreg_{save,restore}_el1_state(), they access the same registers. Also
checked in the Arm ARM that the registers for which KVM doesn't
differentiate between E2H set and cleared in virtual EL2 have the same
encoding regardless of the value of HCR_EL2.E2H:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  }
> -- 
> 2.30.2
> 
