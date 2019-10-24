Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13EACE3780
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 18:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436800AbfJXQLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 12:11:00 -0400
Received: from foss.arm.com ([217.140.110.172]:55488 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436675AbfJXQLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 12:11:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2834228;
        Thu, 24 Oct 2019 09:10:47 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09B8D3F71F;
        Thu, 24 Oct 2019 09:10:45 -0700 (PDT)
Subject: Re: [PATCH v2 4/5] arm64: KVM: Prevent speculative S1 PTW when
 restoring vcpu context
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20191019095521.31722-1-maz@kernel.org>
 <20191019095521.31722-5-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <151fc868-6709-3017-e34d-649ec0e1812c@arm.com>
Date:   Thu, 24 Oct 2019 17:10:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191019095521.31722-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 19/10/2019 10:55, Marc Zyngier wrote:
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

Reviewed-by: James Morse <james.morse@arm.com>

(whitespace nit below)


> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 69e10b29cbd0..5765b17c38c7 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -118,6 +118,20 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  	}
>  
>  	write_sysreg(val, cptr_el2);
> +
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
> +		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> +
> +		isb();
> +		/*
> +		 * At this stage, and thanks to the above isb(), S2 is
> +		 * configured and enabled. We can now restore the guest's S1
> +		 * configuration: SCTLR, and only then TCR.
> +		 */

(note for my future self: because the guest may have had M=0 and rubbish in the TTBRs)

> +		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
> +		isb();
> +		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
> +	}
>  }
>  


> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 7ddbc849b580..fb97547bfa79 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -117,12 +117,26 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  {
>  	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
>  	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
> -	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
> +
> +	if (!cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
> +		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
> +		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
> +	} else	if (!ctxt->__hyp_running_vcpu) {
> +		/*
> +		 * Must only be done for guest registers, hence the context
> +		 * test. We'recoming from the host, so SCTLR.M is already

(Nit: We'recoming?)

> +		 * set. Pairs with __activate_traps_nvhe().
> +		 */
> +		write_sysreg_el1((ctxt->sys_regs[TCR_EL1] |
> +				  TCR_EPD1_MASK | TCR_EPD0_MASK),
> +				 SYS_TCR);
> +		isb();
> +	}



Thanks,

James
