Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D09AC9CDE
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 13:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbfJCLJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 07:09:35 -0400
Received: from foss.arm.com ([217.140.110.172]:41652 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfJCLJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 07:09:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B4371000;
        Thu,  3 Oct 2019 04:09:34 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37C223F706;
        Thu,  3 Oct 2019 04:09:33 -0700 (PDT)
Subject: Re: [PATCH 4/5] arm64: KVM: Prevent speculative S1 PTW when restoring
 vcpu context
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20190925111941.88103-1-maz@kernel.org>
 <20190925111941.88103-5-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <0d52783d-2cff-0d2e-8421-74f815b90c47@arm.com>
Date:   Thu, 3 Oct 2019 12:09:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190925111941.88103-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 25/09/2019 12:19, Marc Zyngier wrote:
> When handling erratum 1319367, we must ensure that the page table
> walker cannot parse the S1 page tables while the guest is in an
> inconsistent state. This is done as follows:
> 
> On guest entry:
> - TCR_EL1.EPD{0,1} are set, ensuring that no PTW can occur
> - all system registers are restored, except for TCR_EL1 and SCTLR_EL1
> - stage-2 is restored
> - SCTLR_EL1 and TCR_EL1 are restored
> 
> On guest exit:
> - SCTLR_EL1.M and TCR_EL1.EPD{0,1} are set, ensuring that no PTW can occur
> - stage-2 is disabled
> - All host system registers are restored

> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index e6adb90c12ae..4df47d013bec 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -156,6 +170,23 @@ static void __hyp_text __deactivate_traps_nvhe(void)
>  {
>  	u64 mdcr_el2 = read_sysreg(mdcr_el2);
>  
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
> +		u64 val;
> +
> +		/*
> +		 * Set the TCR and SCTLR registers in the exact opposite
> +		 * sequence as __activate_traps_nvhe (first prevent walks,
> +		 * then force the MMU on). A generous sprinkling of isb()
> +		 * ensure that things happen in this exact order.
> +		 */
> +		val = read_sysreg_el1(SYS_TCR);
> +		write_sysreg_el1(val | TCR_EPD1_MASK | TCR_EPD0_MASK, SYS_TCR);
> +		isb();
> +		val = read_sysreg_el1(SYS_SCTLR);
> +		write_sysreg_el1(val | SCTLR_ELx_M, SYS_SCTLR);
> +		isb();
> +	}

We are exiting the guest, and heading back to the host.
This change forces stage-1 off. Stage-2 is still enabled, but its about to be disabled and
have the host VMID restore in __deactivate_vm(). All good so far.

Then we hit __sysreg_restore_state_nvhe() for the host, which calls
__sysreg_restore_el1_state()...


> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 7ddbc849b580..adabdceacc10 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -117,12 +117,22 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  {
>  	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
>  	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
> -	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
> +
> +	/* Must only be done for guest registers, hence the context test */
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367) &&
> +	    !ctxt->__hyp_running_vcpu) {
> +		write_sysreg_el1(ctxt->sys_regs[TCR_EL1] |
> +				 TCR_EPD1_MASK | TCR_EPD0_MASK,	SYS_TCR);
> +		isb();
> +	} else {

... which will come in here.

> +		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
> +		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);

This reverses what we did in __deactivate_traps_nvhe(), but we haven't restored the host
TTBRs yet. I don't think the vttbr_el2 write has been sync'd either.

A speculative AT at this point could see the TCR EPDx bits clear, but the guest's TTBR
values. It may also see the guest-VMID.


I think the change to this function needs splitting up. Restore of guest state needs to be
as you have it here, before the guest TTBRs are written.

Restore of the host state needs to only clear the EPDx bits after the TTBRs are written,
and sync'd.


Assuming I'm making sense ... with that:
Reviewed-by: James Morse <james.morse@arm.com>

for the series.


> +	}
> +
>  	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
>  	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
>  	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
>  	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
> -	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
>  	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	SYS_ESR);
>  	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	SYS_AFSR0);
>  	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	SYS_AFSR1);


Thanks,

James
