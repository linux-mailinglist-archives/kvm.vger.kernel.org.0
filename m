Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C048F128953
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 14:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfLUN6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 08:58:00 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:55558 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbfLUN57 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 21 Dec 2019 08:57:59 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iifGW-00047r-QW; Sat, 21 Dec 2019 14:57:57 +0100
Date:   Sat, 21 Dec 2019 13:57:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 08/18] arm64: KVM: add support to save/restore SPE
 profiling buffer controls
Message-ID: <20191221135755.70a6e8df@why>
In-Reply-To: <20191220143025.33853-9-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
        <20191220143025.33853-9-andrew.murray@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, catalin.marinas@arm.com, will@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Dec 2019 14:30:15 +0000
Andrew Murray <andrew.murray@arm.com> wrote:

> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> Currently since we don't support profiling using SPE in the guests,
> we just save the PMSCR_EL1, flush the profiling buffers and disable
> sampling. However in order to support simultaneous sampling both in

Is the sampling actually simultaneous? I don't believe so (the whole
series would be much simpler if it was).

> the host and guests, we need to save and reatore the complete SPE

s/reatore/restore/

> profiling buffer controls' context.
> 
> Let's add the support for the same and keep it disabled for now.
> We can enable it conditionally only if guests are allowed to use
> SPE.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> [ Clear PMBSR bit when saving state to prevent spurious interrupts ]
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c | 51 +++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index 8a70a493345e..12429b212a3a 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -85,7 +85,8 @@
>  	default:	write_debug(ptr[0], reg, 0);			\
>  	}
>  
> -static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
> +static void __hyp_text
> +__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)

nit: don't split lines like this if you can avoid it. You can put the
full_ctxt parameter on a separate line instead.

>  {
>  	u64 reg;
>  
> @@ -102,22 +103,46 @@ static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
>  	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
>  		return;
>  
> -	/* No; is the host actually using the thing? */
> -	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
> -	if (!(reg & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)))
> +	/* Save the control register and disable data generation */
> +	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);
> +
> +	if (!ctxt->sys_regs[PMSCR_EL1])

Shouldn't you check the enable bits instead of relying on the whole
thing being zero?

>  		return;
>  
>  	/* Yes; save the control register and disable data generation */
> -	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);

You've already saved the control register...

>  	write_sysreg_el1(0, SYS_PMSCR);
>  	isb();
>  
>  	/* Now drain all buffered data to memory */
>  	psb_csync();
>  	dsb(nsh);
> +
> +	if (!full_ctxt)
> +		return;
> +
> +	ctxt->sys_regs[PMBLIMITR_EL1] = read_sysreg_s(SYS_PMBLIMITR_EL1);
> +	write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> +
> +	/*
> +	 * As PMBSR is conditionally restored when returning to the host we
> +	 * must ensure the service bit is unset here to prevent a spurious
> +	 * host SPE interrupt from being raised.
> +	 */
> +	ctxt->sys_regs[PMBSR_EL1] = read_sysreg_s(SYS_PMBSR_EL1);
> +	write_sysreg_s(0, SYS_PMBSR_EL1);
> +
> +	isb();
> +
> +	ctxt->sys_regs[PMSICR_EL1] = read_sysreg_s(SYS_PMSICR_EL1);
> +	ctxt->sys_regs[PMSIRR_EL1] = read_sysreg_s(SYS_PMSIRR_EL1);
> +	ctxt->sys_regs[PMSFCR_EL1] = read_sysreg_s(SYS_PMSFCR_EL1);
> +	ctxt->sys_regs[PMSEVFR_EL1] = read_sysreg_s(SYS_PMSEVFR_EL1);
> +	ctxt->sys_regs[PMSLATFR_EL1] = read_sysreg_s(SYS_PMSLATFR_EL1);
> +	ctxt->sys_regs[PMBPTR_EL1] = read_sysreg_s(SYS_PMBPTR_EL1);
>  }
>  
> -static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
> +static void __hyp_text
> +__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
>  {
>  	if (!ctxt->sys_regs[PMSCR_EL1])
>  		return;
> @@ -126,6 +151,16 @@ static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
>  	isb();
>  
>  	/* Re-enable data generation */
> +	if (full_ctxt) {
> +		write_sysreg_s(ctxt->sys_regs[PMBPTR_EL1], SYS_PMBPTR_EL1);
> +		write_sysreg_s(ctxt->sys_regs[PMBLIMITR_EL1], SYS_PMBLIMITR_EL1);
> +		write_sysreg_s(ctxt->sys_regs[PMSFCR_EL1], SYS_PMSFCR_EL1);
> +		write_sysreg_s(ctxt->sys_regs[PMSEVFR_EL1], SYS_PMSEVFR_EL1);
> +		write_sysreg_s(ctxt->sys_regs[PMSLATFR_EL1], SYS_PMSLATFR_EL1);
> +		write_sysreg_s(ctxt->sys_regs[PMSIRR_EL1], SYS_PMSIRR_EL1);
> +		write_sysreg_s(ctxt->sys_regs[PMSICR_EL1], SYS_PMSICR_EL1);
> +		write_sysreg_s(ctxt->sys_regs[PMBSR_EL1], SYS_PMBSR_EL1);
> +	}
>  	write_sysreg_el1(ctxt->sys_regs[PMSCR_EL1], SYS_PMSCR);
>  }
>  
> @@ -198,7 +233,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
>  	if (!has_vhe())
> -		__debug_restore_spe_nvhe(host_ctxt);
> +		__debug_restore_spe_nvhe(host_ctxt, false);
>  
>  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
>  		return;
> @@ -222,7 +257,7 @@ void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
>  
>  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
>  	if (!has_vhe())
> -		__debug_save_spe_nvhe(host_ctxt);
> +		__debug_save_spe_nvhe(host_ctxt, false);
>  }
>  
>  void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)

So all of this is for non-VHE. What happens in the VHE case?

	M.
-- 
Jazz is not dead. It just smells funny...
