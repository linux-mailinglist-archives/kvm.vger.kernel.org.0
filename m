Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D9B48D642
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 12:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiAMLBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 06:01:45 -0500
Received: from foss.arm.com ([217.140.110.172]:42916 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233905AbiAMLBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 06:01:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 869996D;
        Thu, 13 Jan 2022 03:01:39 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.5.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D18183F5A1;
        Thu, 13 Jan 2022 03:01:33 -0800 (PST)
Date:   Thu, 13 Jan 2022 11:01:30 +0000
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
Subject: Re: [PATCH 1/5] kvm: add exit_to_guest_mode() and
 enter_from_guest_mode()
Message-ID: <YeAGit8JTO/AmAaU@FVFF77S0Q05N>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-2-mark.rutland@arm.com>
 <87v8yqrwcs.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8yqrwcs.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 05:54:59PM +0000, Marc Zyngier wrote:
> Hi Mark,
> 
> On Tue, 11 Jan 2022 15:35:35 +0000,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > When transitioning to/from guest mode, it is necessary to inform
> > lockdep, tracing, and RCU in a specific order, similar to the
> > requirements for transitions to/from user mode. Additionally, it is
> > necessary to perform vtime accounting for a window around running the
> > guest, with RCU enabled, such that timer interrupts taken from the guest
> > can be accounted as guest time.
> > 
> > Most architectures don't handle all the necessary pieces, and a have a
> > number of common bugs, including unsafe usage of RCU during the window
> > between guest_enter() and guest_exit().
> > 
> > On x86, this was dealt with across commits:
> > 
> >   87fa7f3e98a1310e ("x86/kvm: Move context tracking where it belongs")
> >   0642391e2139a2c1 ("x86/kvm/vmx: Add hardirq tracing to guest enter/exit")
> >   9fc975e9efd03e57 ("x86/kvm/svm: Add hardirq tracing on guest enter/exit")
> >   3ebccdf373c21d86 ("x86/kvm/vmx: Move guest enter/exit into .noinstr.text")
> >   135961e0a7d555fc ("x86/kvm/svm: Move guest enter/exit into .noinstr.text")
> >   160457140187c5fb ("KVM: x86: Defer vtime accounting 'til after IRQ handling")
> >   bc908e091b326467 ("KVM: x86: Consolidate guest enter/exit logic to common helpers")
> > 
> > ... but those fixes are specific to x86, and as the resulting logic
> > (while correct) is split across generic helper functions and
> > x86-specific helper functions, it is difficult to see that the
> > entry/exit accounting is balanced.
> > 
> > This patch adds generic helpers which architectures can use to handle
> > guest entry/exit consistently and correctly. The guest_{enter,exit}()
> > helpers are split into guest_timing_{enter,exit}() to perform vtime
> > accounting, and guest_context_{enter,exit}() to perform the necessary
> > context tracking and RCU management. The existing guest_{enter,exit}()
> > heleprs are left as wrappers of these.
> > 
> > Atop this, new exit_to_guest_mode() and enter_from_guest_mode() helpers
> > are added to handle the ordering of lockdep, tracing, and RCU manageent.
> > These are named to align with exit_to_user_mode() and
> > enter_from_user_mode().
> > 
> > Subsequent patches will migrate architectures over to the new helpers,
> > following a sequence:
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
> > This sequences handles all of the above correctly, and more clearly
> > balances the entry and exit portions, making it easier to understand.
> > 
> > The existing helpers are marked as deprecated, and will be removed once
> > all architectures have been converted.
> > 
> > There should be no functional change as a result of this patch.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> 
> Thanks a lot for looking into this and writing this up. I have a
> couple of comments below, but that's pretty much cosmetic and is only
> there to ensure that I actually understand this stuff. FWIW:
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks!

> > ---
> >  include/linux/kvm_host.h | 108 +++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 105 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index c310648cc8f1..13fcf7979880 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -29,6 +29,8 @@
> >  #include <linux/refcount.h>
> >  #include <linux/nospec.h>
> >  #include <linux/notifier.h>
> > +#include <linux/ftrace.h>
> > +#include <linux/instrumentation.h>
> >  #include <asm/signal.h>
> >  
> >  #include <linux/kvm.h>
> > @@ -362,8 +364,11 @@ struct kvm_vcpu {
> >  	int last_used_slot;
> >  };
> >  
> > -/* must be called with irqs disabled */
> > -static __always_inline void guest_enter_irqoff(void)
> > +/*
> > + * Start accounting time towards a guest.
> > + * Must be called before entering guest context.
> > + */
> > +static __always_inline void guest_timing_enter_irqoff(void)
> >  {
> >  	/*
> >  	 * This is running in ioctl context so its safe to assume that it's the
> > @@ -372,7 +377,17 @@ static __always_inline void guest_enter_irqoff(void)
> >  	instrumentation_begin();
> >  	vtime_account_guest_enter();
> >  	instrumentation_end();
> > +}
> >  
> > +/*
> > + * Enter guest context and enter an RCU extended quiescent state.
> > + *
> > + * This should be the last thing called before entering the guest, and must be
> > + * called after any potential use of RCU (including any potentially
> > + * instrumented code).
> 
> nit: "the last thing called" is terribly ambiguous. Any architecture
> obviously calls a ****load of stuff after this point. Should this be
> 'the last thing involving RCU' instead?

I agree this is unclear and I struggled to fing good wording for this. Is the
following any better?

/*
 * Enter guest context and enter an RCU extended quiescent state.
 *
 * Between guest_context_enter_irqoff() and guest_context_exit_irqoff() it is
 * unsafe to use any code which may directly or indirectly use RCU, tracing
 * (including IRQ flag tracing), or lockdep. All code in this period must be
 * non-instrumentable.
 */

If that's good I can add similar to guest_context_exit_irqoff().

[...]

> > +/**
> > + * exit_to_guest_mode - Fixup state when exiting to guest mode
> > + *
> > + * This is analagous to exit_to_user_mode(), and ensures we perform the
> > + * following in order:
> > + *
> > + * 1) Trace interrupts on state
> > + * 2) Invoke context tracking if enabled to adjust RCU state
> > + * 3) Tell lockdep that interrupts are enabled
> 
> nit: or rather, are about to be enabled? Certainly on arm64, the
> enable happens much later, right at the point where we enter the guest
> for real.

True; I'd cribbed the wording from the comment block above exit_to_user_mode(),
but I stripped the context that made that clear. I'll make that:

	/**
	 * exit_to_guest_mode - Fixup state when exiting to guest mode
	 *
	 * Entry to a guest will enable interrupts, but the kernel state is
	 * interrupts disabled when this is invoked. Also tell RCU about it.
	 *
	 * 1) Trace interrupts on state
	 * 2) Invoke context tracking if enabled to adjust RCU state
	 * 3) Tell lockdep that interrupts are enabled
	 *
	 * Invoked from architecture specific code before entering a guest.
	 * Must be called with interrupts disabled and the caller must be
	 * non-instrumentable.
	 * The caller has to invoke guest_timing_enter_irqoff() before this.
	 *
	 * Note: this is analagous to exit_to_user_mode().
	 */

... with likewise for enter_from_guest_mode(), if that's clear enough?

FWIW, the comment blcok for exit_to_user_mode() in
include/linux/entry-common.h says:

	/**
	 * exit_to_user_mode - Fixup state when exiting to user mode
	 *
	 * Syscall/interrupt exit enables interrupts, but the kernel state is
	 * interrupts disabled when this is invoked. Also tell RCU about it.
	 *
	 * 1) Trace interrupts on state
	 * 2) Invoke context tracking if enabled to adjust RCU state
	 * 3) Invoke architecture specific last minute exit code, e.g. speculation
	 *    mitigations, etc.: arch_exit_to_user_mode()
	 * 4) Tell lockdep that interrupts are enabled
	 *
	 * Invoked from architecture specific code when syscall_exit_to_user_mode()
	 * is not suitable as the last step before returning to userspace. Must be
	 * invoked with interrupts disabled and the caller must be
	 * non-instrumentable.
	 * The caller has to invoke syscall_exit_to_user_mode_work() before this.
	 */

Thanks,
Mark.
