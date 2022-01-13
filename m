Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC28E48D691
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 12:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiAMLSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 06:18:05 -0500
Received: from foss.arm.com ([217.140.110.172]:43116 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbiAMLSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 06:18:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2469A6D;
        Thu, 13 Jan 2022 03:18:04 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.5.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43C123F774;
        Thu, 13 Jan 2022 03:17:58 -0800 (PST)
Date:   Thu, 13 Jan 2022 11:17:53 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        mingo@redhat.com, mpe@ellerman.id.au, nsaenzju@redhat.com,
        palmer@dabbelt.com, paulmck@kernel.org, paulus@samba.org,
        paul.walmsley@sifive.com, pbonzini@redhat.com, seanjc@google.com,
        suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 2/5] kvm/arm64: rework guest entry logic
Message-ID: <YeAKYUQcHc0+LJ/P@FVFF77S0Q05N>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-3-mark.rutland@arm.com>
 <87tuearwc7.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tuearwc7.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 05:55:20PM +0000, Marc Zyngier wrote:
> On Tue, 11 Jan 2022 15:35:36 +0000,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > In kvm_arch_vcpu_ioctl_run() we enter an RCU extended quiescent state
> > (EQS) by calling guest_enter_irqoff(), and unmasked IRQs prior to
> > exiting the EQS by calling guest_exit(). As the IRQ entry code will not
> > wake RCU in this case, we may run the core IRQ code and IRQ handler
> > without RCU watching, leading to various potential problems.
> > 
> > Additionally, we do not inform lockdep or tracing that interrupts will
> > be enabled during guest execution, which caan lead to misleading traces
> > and warnings that interrupts have been enabled for overly-long periods.
> > 
> > This patch fixes these issues by using the new timing and context
> > entry/exit helpers to ensure that interrupts are handled during guest
> > vtime but with RCU watching, with a sequence:
> > 
> > 	guest_timing_enter_irqoff();
> > 
> > 	exit_to_guest_mode();
> > 	< run the vcpu >
> > 	enter_from_guest_mode();
> > 
> > 	< take any pending IRQs >
> > 
> > 	guest_timing_exit_irqoff();
> > 
> > Since instrumentation may make use of RCU, we must also ensure that no
> > instrumented code is run during the EQS. I've split out the critical
> > section into a new kvm_arm_enter_exit_vcpu() helper which is marked
> > noinstr.
> > 
> > Fixes: 1b3d546daf85ed2b ("arm/arm64: KVM: Properly account for guest CPU time")
> > Reported-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Frederic Weisbecker <frederic@kernel.org>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/arm.c | 51 ++++++++++++++++++++++++++++----------------
> >  1 file changed, 33 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e4727dc771bf..1721df2522c8 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -764,6 +764,24 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
> >  			xfer_to_guest_mode_work_pending();
> >  }
> >  
> > +/*
> > + * Actually run the vCPU, entering an RCU extended quiescent state (EQS) while
> > + * the vCPU is running.
> > + *
> > + * This must be noinstr as instrumentation may make use of RCU, and this is not
> > + * safe during the EQS.
> > + */
> > +static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
> > +{
> > +	int ret;
> > +
> > +	exit_to_guest_mode();
> > +	ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
> > +	enter_from_guest_mode();
> > +
> > +	return ret;
> > +}
> > +
> >  /**
> >   * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
> >   * @vcpu:	The VCPU pointer
> > @@ -854,9 +872,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >  		 * Enter the guest
> >  		 */
> >  		trace_kvm_entry(*vcpu_pc(vcpu));
> > -		guest_enter_irqoff();
> > +		guest_timing_enter_irqoff();
> >  
> > -		ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
> > +		ret = kvm_arm_vcpu_enter_exit(vcpu);
> >  
> >  		vcpu->mode = OUTSIDE_GUEST_MODE;
> >  		vcpu->stat.exits++;
> > @@ -891,26 +909,23 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >  		kvm_arch_vcpu_ctxsync_fp(vcpu);
> >  
> >  		/*
> > -		 * We may have taken a host interrupt in HYP mode (ie
> > -		 * while executing the guest). This interrupt is still
> > -		 * pending, as we haven't serviced it yet!
> > +		 * We must ensure that any pending interrupts are taken before
> > +		 * we exit guest timing so that timer ticks are accounted as
> > +		 * guest time. Transiently unmask interrupts so that any
> > +		 * pending interrupts are taken.
> >  		 *
> > -		 * We're now back in SVC mode, with interrupts
> > -		 * disabled.  Enabling the interrupts now will have
> > -		 * the effect of taking the interrupt again, in SVC
> > -		 * mode this time.
> > +		 * Per ARM DDI 0487G.b section D1.13.4, an ISB (or other
> > +		 * context synchronization event) is necessary to ensure that
> > +		 * pending interrupts are taken.
> >  		 */
> >  		local_irq_enable();
> > +		isb();
> > +		local_irq_disable();
> 
> Small nit: we may be able to elide this enable/isb/disable dance if a
> read of ISR_EL1 returns 0.

Wouldn't that be broken when using GIC priority masking, since that can prevent
IRQS being signalled ot the PE?

I'm happy to rework this, but I'll need to think a bit harder about it. Would
you be happy if we did that as a follow-up?

I suspect we'll want to split that out into a helper, e.g.

static __always_inline handle_pending_host_irqs(void)
{
	/*
	 * TODO: explain PMR masking / signalling here
	 */
	if (!system_uses_irq_prio_masking() &&
	    !read_sysreg(isr_el1))
		return;
	
	local_irq_enable();
	isb();
	local_irq_disable();
}

> 
> > +
> > +		guest_timing_exit_irqoff();
> > +
> > +		local_irq_enable();
> >  
> > -		/*
> > -		 * We do local_irq_enable() before calling guest_exit() so
> > -		 * that if a timer interrupt hits while running the guest we
> > -		 * account that tick as being spent in the guest.  We enable
> > -		 * preemption after calling guest_exit() so that if we get
> > -		 * preempted we make sure ticks after that is not counted as
> > -		 * guest time.
> > -		 */
> > -		guest_exit();
> >  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> >  
> >  		/* Exit types that need handling before we can be preempted */
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks!

Mark.
