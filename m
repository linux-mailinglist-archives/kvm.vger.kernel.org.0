Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D28B48E99C
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 13:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240933AbiANMFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 07:05:46 -0500
Received: from foss.arm.com ([217.140.110.172]:60646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234308AbiANMFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 07:05:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 297D3ED1;
        Fri, 14 Jan 2022 04:05:44 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.2.91])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 921713F774;
        Fri, 14 Jan 2022 04:05:38 -0800 (PST)
Date:   Fri, 14 Jan 2022 12:05:35 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        maz@kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        nsaenzju@redhat.com, palmer@dabbelt.com, paulmck@kernel.org,
        paulus@samba.org, paul.walmsley@sifive.com, pbonzini@redhat.com,
        suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 5/5] kvm/x86: rework guest entry logic
Message-ID: <YeFnD8l/OoMtPYvh@FVFF77S0Q05N>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-6-mark.rutland@arm.com>
 <YeCQeHbswboaosoV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeCQeHbswboaosoV@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 08:50:00PM +0000, Sean Christopherson wrote:
> On Tue, Jan 11, 2022, Mark Rutland wrote:
> > For consistency and clarity, migrate x86 over to the generic helpers for
> > guest timing and lockdep/RCU/tracing management, and remove the
> > x86-specific helpers.
> > 
> > Prior to this patch, the guest timing was entered in
> > kvm_guest_enter_irqoff() (called by svm_vcpu_enter_exit() and
> > svm_vcpu_enter_exit()), and was exited by the call to
> > vtime_account_guest_exit() within vcpu_enter_guest().
> > 
> > To minimize duplication and to more clearly balance entry and exit, both
> > entry and exit of guest timing are placed in vcpu_enter_guest(), using
> > the new guest_timing_{enter,exit}_irqoff() helpers. This may result in a
> > small amount of additional time being acounted towards guests.
> 
> This can be further qualified to state that it only affects time accounting when
> using context tracking; tick-based accounting is unaffected because IRQs are
> disabled the entire time.

Ok. I'll replace that last sentence with:

  When context tracking is used a small amount of additional time will be
  accounted towards guests; tick-based accounting is unnaffected as IRQs are
  disabled at this point and not enabled until after the return from the guest.

> 
> And this might actually be a (benign?) bug fix for context tracking accounting in
> the EXIT_FASTPATH_REENTER_GUEST case (commits ae95f566b3d2 "KVM: X86: TSCDEADLINE
> MSR emulation fastpath" and 26efe2fd92e5, "KVM: VMX: Handle preemption timer
> fastpath").  In those cases, KVM will enter the guest multiple times without
> bouncing through vtime_account_guest_exit().  That means vtime_guest_enter() will
> be called when the CPU is already "in guest", and call vtime_account_system()
> when it really should call vtime_account_guest().  account_system_time() does
> check PF_VCPU and redirect to account_guest_time(), so it appears to be benign,
> but it's at least odd.
> 
> > Other than this, there should be no functional change as a result of
> > this patch.

I've added wording:

  This also corrects (benign) mis-balanced context tracking accounting
  introduced in commits:
  
    ae95f566b3d22ade ("KVM: X86: TSCDEADLINE MSR emulation fastpath")
    26efe2fd92e50822 ("KVM: VMX: Handle preemption timer fastpath")
  
  Where KVM can enter a guest multiple times, calling vtime_guest_enter()
  without a corresponding call to vtime_account_guest_exit(), and with
  vtime_account_system() called when vtime_account_guest() should be used.
  As account_system_time() checks PF_VCPU and calls account_guest_time(),
  this doesn't result in any functional problem, but is unnecessarily
  confusing.

... and deleted the "no functional change" line for now.

I assume that other than the naming of the entry/exit functions you're happy
with this patch?

Thanks,
Mark.

> ...
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e50e97ac4408..bd3873b90889 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9876,6 +9876,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >  		set_debugreg(0, 7);
> >  	}
> >  
> > +	guest_timing_enter_irqoff();
> > +
> >  	for (;;) {
> >  		/*
> >  		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
> > @@ -9949,7 +9951,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >  	 * of accounting via context tracking, but the loss of accuracy is
> >  	 * acceptable for all known use cases.
> >  	 */
> > -	vtime_account_guest_exit();
> > +	guest_timing_exit_irqoff();
> >  
> >  	if (lapic_in_kernel(vcpu)) {
> >  		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
