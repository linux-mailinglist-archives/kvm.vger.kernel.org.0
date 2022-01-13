Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C28848D856
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiAMM6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:58:14 -0500
Received: from foss.arm.com ([217.140.110.172]:44488 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234818AbiAMM6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 07:58:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D85B7106F;
        Thu, 13 Jan 2022 04:58:12 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.5.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CE4E3F766;
        Thu, 13 Jan 2022 04:58:07 -0800 (PST)
Date:   Thu, 13 Jan 2022 12:58:00 +0000
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
Message-ID: <YeAh2PX5PFcBl9y6@FVFF77S0Q05N>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-3-mark.rutland@arm.com>
 <87tuearwc7.wl-maz@kernel.org>
 <YeAKYUQcHc0+LJ/P@FVFF77S0Q05N>
 <87r19b97z1.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r19b97z1.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 11:43:30AM +0000, Marc Zyngier wrote:
> On Thu, 13 Jan 2022 11:17:53 +0000,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > On Tue, Jan 11, 2022 at 05:55:20PM +0000, Marc Zyngier wrote:
> > > On Tue, 11 Jan 2022 15:35:36 +0000,
> > > Mark Rutland <mark.rutland@arm.com> wrote:
> 
> [...]
> 
> > > > @@ -891,26 +909,23 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> > > >  		kvm_arch_vcpu_ctxsync_fp(vcpu);
> > > >  
> > > >  		/*
> > > > -		 * We may have taken a host interrupt in HYP mode (ie
> > > > -		 * while executing the guest). This interrupt is still
> > > > -		 * pending, as we haven't serviced it yet!
> > > > +		 * We must ensure that any pending interrupts are taken before
> > > > +		 * we exit guest timing so that timer ticks are accounted as
> > > > +		 * guest time. Transiently unmask interrupts so that any
> > > > +		 * pending interrupts are taken.
> > > >  		 *
> > > > -		 * We're now back in SVC mode, with interrupts
> > > > -		 * disabled.  Enabling the interrupts now will have
> > > > -		 * the effect of taking the interrupt again, in SVC
> > > > -		 * mode this time.
> > > > +		 * Per ARM DDI 0487G.b section D1.13.4, an ISB (or other
> > > > +		 * context synchronization event) is necessary to ensure that
> > > > +		 * pending interrupts are taken.
> > > >  		 */
> > > >  		local_irq_enable();
> > > > +		isb();
> > > > +		local_irq_disable();
> > > 
> > > Small nit: we may be able to elide this enable/isb/disable dance if a
> > > read of ISR_EL1 returns 0.
> > 
> > Wouldn't that be broken when using GIC priority masking, since that
> > can prevent IRQS being signalled ot the PE?
> 
> You're right. But this can be made even simpler. We already know if
> we've exited the guest because of an IRQ (ret tells us that), and
> that's true whether we're using priority masking or not. It could be
> as simple as:
> 
> 	if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
> 		// We exited because of an interrupt. Let's take
> 		// it now to account timer ticks to the guest.
> 	 	local_irq_enable();
>  		isb();
>  		local_irq_disable();
> 	}
> 
> and that would avoid accounting the interrupt to the guest if it fired
> after the exit took place.
> 
> > I'm happy to rework this, but I'll need to think a bit harder about
> > it. Would you be happy if we did that as a follow-up?
> 
> Oh, absolutely. I want the flow to be correct before we make it
> fast(-ish).

Cool; I'll leave that for now on the assumption we'll address that with a
follow-up patch, though your suggestion above looks "obviously" correct to me.

Thanks,
Mark.
