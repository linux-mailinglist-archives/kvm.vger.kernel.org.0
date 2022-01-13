Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6253E48D870
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 14:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiAMNBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 08:01:19 -0500
Received: from foss.arm.com ([217.140.110.172]:44622 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234951AbiAMNBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 08:01:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0ECC9ED1;
        Thu, 13 Jan 2022 05:01:17 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.5.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FC7F3F766;
        Thu, 13 Jan 2022 05:01:11 -0800 (PST)
Date:   Thu, 13 Jan 2022 13:01:08 +0000
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
Message-ID: <YeAilN3qR6siMKah@FVFF77S0Q05N>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-2-mark.rutland@arm.com>
 <87v8yqrwcs.wl-maz@kernel.org>
 <YeAGit8JTO/AmAaU@FVFF77S0Q05N>
 <87pmov97fk.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmov97fk.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 11:55:11AM +0000, Marc Zyngier wrote:
> On Thu, 13 Jan 2022 11:01:30 +0000,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > On Tue, Jan 11, 2022 at 05:54:59PM +0000, Marc Zyngier wrote:
> > > Hi Mark,
> > > 
> > > On Tue, 11 Jan 2022 15:35:35 +0000,
> > > Mark Rutland <mark.rutland@arm.com> wrote:
> 
> [...]
> 
> > > > +/*
> > > > + * Enter guest context and enter an RCU extended quiescent state.
> > > > + *
> > > > + * This should be the last thing called before entering the guest, and must be
> > > > + * called after any potential use of RCU (including any potentially
> > > > + * instrumented code).
> > > 
> > > nit: "the last thing called" is terribly ambiguous. Any architecture
> > > obviously calls a ****load of stuff after this point. Should this be
> > > 'the last thing involving RCU' instead?
> > 
> > I agree this is unclear and I struggled to fing good wording for this. Is the
> > following any better?
> > 
> > /*
> >  * Enter guest context and enter an RCU extended quiescent state.
> >  *
> >  * Between guest_context_enter_irqoff() and guest_context_exit_irqoff() it is
> >  * unsafe to use any code which may directly or indirectly use RCU, tracing
> >  * (including IRQ flag tracing), or lockdep. All code in this period must be
> >  * non-instrumentable.
> >  */
> > 
> > If that's good I can add similar to guest_context_exit_irqoff().
> 
> Yes, that's much clearer, thanks.
> 
> >
> > [...]
> > 
> > > > +/**
> > > > + * exit_to_guest_mode - Fixup state when exiting to guest mode
> > > > + *
> > > > + * This is analagous to exit_to_user_mode(), and ensures we perform the
> > > > + * following in order:
> > > > + *
> > > > + * 1) Trace interrupts on state
> > > > + * 2) Invoke context tracking if enabled to adjust RCU state
> > > > + * 3) Tell lockdep that interrupts are enabled
> > > 
> > > nit: or rather, are about to be enabled? Certainly on arm64, the
> > > enable happens much later, right at the point where we enter the guest
> > > for real.
> > 
> > True; I'd cribbed the wording from the comment block above exit_to_user_mode(),
> > but I stripped the context that made that clear. I'll make that:
> > 
> > 	/**
> > 	 * exit_to_guest_mode - Fixup state when exiting to guest mode
> > 	 *
> > 	 * Entry to a guest will enable interrupts, but the kernel state is
> > 	 * interrupts disabled when this is invoked. Also tell RCU about it.
> > 	 *
> > 	 * 1) Trace interrupts on state
> > 	 * 2) Invoke context tracking if enabled to adjust RCU state
> > 	 * 3) Tell lockdep that interrupts are enabled
> > 	 *
> > 	 * Invoked from architecture specific code before entering a guest.
> > 	 * Must be called with interrupts disabled and the caller must be
> > 	 * non-instrumentable.
> > 	 * The caller has to invoke guest_timing_enter_irqoff() before this.
> > 	 *
> > 	 * Note: this is analagous to exit_to_user_mode().
> 
> nit: analogous
> 
> > 	 */
> > 
> > ... with likewise for enter_from_guest_mode(), if that's clear enough?
> 
> Yes, that's great.

Thanks; I've pushed out an updated branch with those changes (including the
typo fixes). I'll wait until next week before sending out a v2 since I don't
think that meaningfully affects the arch bits for other architectures.

Mark.
