Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3021C12A031
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 11:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfLXKtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 05:49:33 -0500
Received: from foss.arm.com ([217.140.110.172]:51014 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfLXKtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 05:49:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9018331B;
        Tue, 24 Dec 2019 02:49:32 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 046BC3F534;
        Tue, 24 Dec 2019 02:49:31 -0800 (PST)
Date:   Tue, 24 Dec 2019 10:49:30 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 08/18] arm64: KVM: add support to save/restore SPE
 profiling buffer controls
Message-ID: <20191224104929.GE42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-9-andrew.murray@arm.com>
 <20191221135755.70a6e8df@why>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191221135755.70a6e8df@why>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 21, 2019 at 01:57:55PM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:15 +0000
> Andrew Murray <andrew.murray@arm.com> wrote:
> 
> > From: Sudeep Holla <sudeep.holla@arm.com>
> > 
> > Currently since we don't support profiling using SPE in the guests,
> > we just save the PMSCR_EL1, flush the profiling buffers and disable
> > sampling. However in order to support simultaneous sampling both in
> 
> Is the sampling actually simultaneous? I don't believe so (the whole
> series would be much simpler if it was).

No the SPE is used by either the guest or host at any one time. I guess
the term simultaneous was used to refer to illusion given to both guest
and host that they are able to use it whenever they like. I'll update
the commit message to drop the magic.
 

> 
> > the host and guests, we need to save and reatore the complete SPE
> 
> s/reatore/restore/

Noted.


> 
> > profiling buffer controls' context.
> > 
> > Let's add the support for the same and keep it disabled for now.
> > We can enable it conditionally only if guests are allowed to use
> > SPE.
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > [ Clear PMBSR bit when saving state to prevent spurious interrupts ]
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/debug-sr.c | 51 +++++++++++++++++++++++++++++------
> >  1 file changed, 43 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> > index 8a70a493345e..12429b212a3a 100644
> > --- a/arch/arm64/kvm/hyp/debug-sr.c
> > +++ b/arch/arm64/kvm/hyp/debug-sr.c
> > @@ -85,7 +85,8 @@
> >  	default:	write_debug(ptr[0], reg, 0);			\
> >  	}
> >  
> > -static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
> > +static void __hyp_text
> > +__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> 
> nit: don't split lines like this if you can avoid it. You can put the
> full_ctxt parameter on a separate line instead.

Yes understood.


> 
> >  {
> >  	u64 reg;
> >  
> > @@ -102,22 +103,46 @@ static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
> >  	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
> >  		return;
> >  
> > -	/* No; is the host actually using the thing? */
> > -	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
> > -	if (!(reg & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)))
> > +	/* Save the control register and disable data generation */
> > +	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);
> > +
> > +	if (!ctxt->sys_regs[PMSCR_EL1])
> 
> Shouldn't you check the enable bits instead of relying on the whole
> thing being zero?

Yes that would make more sense (E1SPE and E0SPE).

I feel that this check makes an assumption about the guest/host SPE
driver... What happens if the SPE driver writes to some SPE registers
but doesn't enable PMSCR? If the guest is also using SPE then those
writes will be lost, when the host returns and the SPE driver enables
SPE it won't work.

With a quick look at the SPE driver I'm not sure this will happen, but
even so it makes me nervous relying on these assumptions. I wonder if
this risk is present in other devices?


> 
> >  		return;
> >  
> >  	/* Yes; save the control register and disable data generation */
> > -	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);
> 
> You've already saved the control register...

I'll remove that.


> 
> >  	write_sysreg_el1(0, SYS_PMSCR);
> >  	isb();
> >  
> >  	/* Now drain all buffered data to memory */
> >  	psb_csync();
> >  	dsb(nsh);
> > +
> > +	if (!full_ctxt)
> > +		return;
> > +
> > +	ctxt->sys_regs[PMBLIMITR_EL1] = read_sysreg_s(SYS_PMBLIMITR_EL1);
> > +	write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> > +
> > +	/*
> > +	 * As PMBSR is conditionally restored when returning to the host we
> > +	 * must ensure the service bit is unset here to prevent a spurious
> > +	 * host SPE interrupt from being raised.
> > +	 */
> > +	ctxt->sys_regs[PMBSR_EL1] = read_sysreg_s(SYS_PMBSR_EL1);
> > +	write_sysreg_s(0, SYS_PMBSR_EL1);
> > +
> > +	isb();
> > +
> > +	ctxt->sys_regs[PMSICR_EL1] = read_sysreg_s(SYS_PMSICR_EL1);
> > +	ctxt->sys_regs[PMSIRR_EL1] = read_sysreg_s(SYS_PMSIRR_EL1);
> > +	ctxt->sys_regs[PMSFCR_EL1] = read_sysreg_s(SYS_PMSFCR_EL1);
> > +	ctxt->sys_regs[PMSEVFR_EL1] = read_sysreg_s(SYS_PMSEVFR_EL1);
> > +	ctxt->sys_regs[PMSLATFR_EL1] = read_sysreg_s(SYS_PMSLATFR_EL1);
> > +	ctxt->sys_regs[PMBPTR_EL1] = read_sysreg_s(SYS_PMBPTR_EL1);
> >  }
> >  
> > -static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
> > +static void __hyp_text
> > +__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> >  {
> >  	if (!ctxt->sys_regs[PMSCR_EL1])
> >  		return;
> > @@ -126,6 +151,16 @@ static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
> >  	isb();
> >  
> >  	/* Re-enable data generation */
> > +	if (full_ctxt) {
> > +		write_sysreg_s(ctxt->sys_regs[PMBPTR_EL1], SYS_PMBPTR_EL1);
> > +		write_sysreg_s(ctxt->sys_regs[PMBLIMITR_EL1], SYS_PMBLIMITR_EL1);
> > +		write_sysreg_s(ctxt->sys_regs[PMSFCR_EL1], SYS_PMSFCR_EL1);
> > +		write_sysreg_s(ctxt->sys_regs[PMSEVFR_EL1], SYS_PMSEVFR_EL1);
> > +		write_sysreg_s(ctxt->sys_regs[PMSLATFR_EL1], SYS_PMSLATFR_EL1);
> > +		write_sysreg_s(ctxt->sys_regs[PMSIRR_EL1], SYS_PMSIRR_EL1);
> > +		write_sysreg_s(ctxt->sys_regs[PMSICR_EL1], SYS_PMSICR_EL1);
> > +		write_sysreg_s(ctxt->sys_regs[PMBSR_EL1], SYS_PMBSR_EL1);
> > +	}
> >  	write_sysreg_el1(ctxt->sys_regs[PMSCR_EL1], SYS_PMSCR);
> >  }
> >  
> > @@ -198,7 +233,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
> >  	guest_ctxt = &vcpu->arch.ctxt;
> >  
> >  	if (!has_vhe())
> > -		__debug_restore_spe_nvhe(host_ctxt);
> > +		__debug_restore_spe_nvhe(host_ctxt, false);
> >  
> >  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
> >  		return;
> > @@ -222,7 +257,7 @@ void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
> >  
> >  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> >  	if (!has_vhe())
> > -		__debug_save_spe_nvhe(host_ctxt);
> > +		__debug_save_spe_nvhe(host_ctxt, false);
> >  }
> >  
> >  void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
> 
> So all of this is for non-VHE. What happens in the VHE case?

By the end of the series this ends up in __debug_save_host_context which is
called for both VHE/nVHE - on the re-spin I'll make it not look so confusing.

Thanks,

Andrew Murray

> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
