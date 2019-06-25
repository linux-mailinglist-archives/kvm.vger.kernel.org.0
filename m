Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A233152707
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 10:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbfFYIsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 04:48:55 -0400
Received: from foss.arm.com ([217.140.110.172]:35754 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfFYIsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 04:48:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88A232B;
        Tue, 25 Jun 2019 01:48:54 -0700 (PDT)
Received: from [10.37.8.194] (unknown [10.37.8.194])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E5D03F718;
        Tue, 25 Jun 2019 01:48:52 -0700 (PDT)
Subject: Re: [PATCH 16/59] KVM: arm64: nv: Save/Restore vEL2 sysregs
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-17-marc.zyngier@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <800f3e9a-5b67-951b-34c2-60367c0697f9@arm.com>
Date:   Tue, 25 Jun 2019 09:48:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-17-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/21/2019 10:38 AM, Marc Zyngier wrote:
> From: Andre Przywara <andre.przywara@arm.com>
> 
> Whenever we need to restore the guest's system registers to the CPU, we
> now need to take care of the EL2 system registers as well. Most of them
> are accessed via traps only, but some have an immediate effect and also
> a guest running in VHE mode would expect them to be accessible via their
> EL1 encoding, which we do not trap.
> 
> Split the current __sysreg_{save,restore}_el1_state() functions into
> handling common sysregs, then differentiate between the guest running in
> vEL2 and vEL1.
> 
> For vEL2 we write the virtual EL2 registers with an identical format directly
> into their EL1 counterpart, and translate the few registers that have a
> different format for the same effect on the execution when running a
> non-VHE guest guest hypervisor.
> 
>   [ Commit message reworked and many bug fixes applied by Marc Zyngier
>     and Christoffer Dall. ]
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 160 +++++++++++++++++++++++++++++++--
>  1 file changed, 153 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 62866a68e852..2abb9c3ff24f 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c

[...]

> @@ -124,10 +167,91 @@ static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
>  }
>  
> -static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> +static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
>  {
> +	u64 val;
> +
> +	write_sysreg(read_cpuid_id(),			vpidr_el2);
>  	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
> -	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
> +	write_sysreg_el1(ctxt->sys_regs[MAIR_EL2],	SYS_MAIR);
> +	write_sysreg_el1(ctxt->sys_regs[VBAR_EL2],	SYS_VBAR);
> +	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL2],SYS_CONTEXTIDR);
> +	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL2],	SYS_AMAIR);
> +
> +	if (__vcpu_el2_e2h_is_set(ctxt)) {
> +		/*
> +		 * In VHE mode those registers are compatible between
> +		 * EL1 and EL2.
> +		 */
> +		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL2],	SYS_SCTLR);
> +		write_sysreg_el1(ctxt->sys_regs[CPTR_EL2],	SYS_CPACR);
> +		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
> +		write_sysreg_el1(ctxt->sys_regs[TTBR1_EL2],	SYS_TTBR1);
> +		write_sysreg_el1(ctxt->sys_regs[TCR_EL2],	SYS_TCR);
> +		write_sysreg_el1(ctxt->sys_regs[CNTHCTL_EL2],	SYS_CNTKCTL);
> +	} else {
> +		write_sysreg_el1(translate_sctlr(ctxt->sys_regs[SCTLR_EL2]),
> +				 SYS_SCTLR);
> +		write_sysreg_el1(translate_cptr(ctxt->sys_regs[CPTR_EL2]),
> +				 SYS_CPACR);
> +		write_sysreg_el1(translate_ttbr0(ctxt->sys_regs[TTBR0_EL2]),
> +				 SYS_TTBR0);
> +		write_sysreg_el1(translate_tcr(ctxt->sys_regs[TCR_EL2]),
> +				 SYS_TCR);
> +		write_sysreg_el1(translate_cnthctl(ctxt->sys_regs[CNTHCTL_EL2]),
> +				 SYS_CNTKCTL);
> +	}
> +
> +	/*
> +	 * These registers can be modified behind our back by a fault
> +	 * taken inside vEL2. Save them, always.
> +	 */
> +	write_sysreg_el1(ctxt->sys_regs[ESR_EL2],	SYS_ESR);
> +	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL2],	SYS_AFSR0);
> +	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL2],	SYS_AFSR1);
> +	write_sysreg_el1(ctxt->sys_regs[FAR_EL2],	SYS_FAR);
> +	write_sysreg(ctxt->sys_regs[SP_EL2],		sp_el1);
> +	write_sysreg_el1(ctxt->sys_regs[ELR_EL2],	SYS_ELR);
> +
> +	val = __fixup_spsr_el2_write(ctxt, ctxt->sys_regs[SPSR_EL2]);
> +	write_sysreg_el1(val,	SYS_SPSR);
> +}
> +
> +static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
> +{
> +	u64 mpidr;
> +
> +	if (has_vhe()) {
> +		struct kvm_vcpu *vcpu;
> +
> +		/*
> +		 * Warning: this hack only works on VHE, because we only
> +		 * call this with the *guest* context, which is part of
> +		 * struct kvm_vcpu. On a host context, you'd get pure junk.
> +		 */
> +		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);

This seems very fragile, just to find out whether the guest has hyp
capabilities. It would be at least nice to make sure this is indeed a
guest context.

The *clean* way to do it could be to have a pointer to kvm_vcpu in the
kvm_cpu_context which would be NULL for host contexts.

Otherwise, I'm under the impression that for a host context,
ctxt->sys_reg[HCR_EL2] == 0 and that this would also be true for a guest
without nested virt capability. Could we use something like that here?

Cheers,

Julien
