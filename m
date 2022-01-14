Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAF548EABB
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiANNc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:32:56 -0500
Received: from foss.arm.com ([217.140.110.172]:33390 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231860AbiANNcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 08:32:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF0E6ED1;
        Fri, 14 Jan 2022 05:32:54 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.2.91])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C58E3F774;
        Fri, 14 Jan 2022 05:32:49 -0800 (PST)
Date:   Fri, 14 Jan 2022 13:32:10 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        chenhuacai@kernel.org, dave.hansen@linux.intel.com,
        david@redhat.com, frankja@linux.ibm.com, frederic@kernel.org,
        gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        james.morse@arm.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        pbonzini@redhat.com, seanjc@google.com, suzuki.poulose@arm.com,
        tglx@linutronix.de, tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Message-ID: <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <127a6117-85fb-7477-983c-daf09e91349d@linux.ibm.com>
 <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
 <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 01:29:46PM +0100, Christian Borntraeger wrote:
> 
> 
> Am 14.01.22 um 13:19 schrieb Mark Rutland:
> > On Thu, Jan 13, 2022 at 04:20:07PM +0100, Christian Borntraeger wrote:
> > > Am 11.01.22 um 16:35 schrieb Mark Rutland:
> > > > Several architectures have latent bugs around guest entry/exit, most
> > > > notably:
> > > > 
> > > > 1) Several architectures enable interrupts between guest_enter() and
> > > >      guest_exit(). As this period is an RCU extended quiescent state (EQS) this
> > > >      is unsound unless the irq entry code explicitly wakes RCU, which most
> > > >      architectures only do for entry from usersapce or idle.
> > > > 
> > > >      I believe this affects: arm64, riscv, s390
> > > > 
> > > >      I am not sure about powerpc.
> > > > 
> > > > 2) Several architectures permit instrumentation of code between
> > > >      guest_enter() and guest_exit(), e.g. KASAN, KCOV, KCSAN, etc. As
> > > >      instrumentation may directly o indirectly use RCU, this has the same
> > > >      problems as with interrupts.
> > > > 
> > > >      I believe this affects: arm64, mips, powerpc, riscv, s390
> > > > 
> > > > 3) Several architectures do not inform lockdep and tracing that
> > > >      interrupts are enabled during the execution of the guest, or do so in
> > > >      an incorrect order. Generally
> > > >      this means that logs will report IRQs being masked for much longer
> > > >      than is actually the case, which is not ideal for debugging. I don't
> > > >      know whether this affects the correctness of lockdep.
> > > > 
> > > >      I believe this affects: arm64, mips, powerpc, riscv, s390
> > > > 
> > > > This was previously fixed for x86 specifically in a series of commits:
> > > > 
> > > >     87fa7f3e98a1310e ("x86/kvm: Move context tracking where it belongs")
> > > >     0642391e2139a2c1 ("x86/kvm/vmx: Add hardirq tracing to guest enter/exit")
> > > >     9fc975e9efd03e57 ("x86/kvm/svm: Add hardirq tracing on guest enter/exit")
> > > >     3ebccdf373c21d86 ("x86/kvm/vmx: Move guest enter/exit into .noinstr.text")
> > > >     135961e0a7d555fc ("x86/kvm/svm: Move guest enter/exit into .noinstr.text")
> > > >     160457140187c5fb ("KVM: x86: Defer vtime accounting 'til after IRQ handling")
> > > >     bc908e091b326467 ("KVM: x86: Consolidate guest enter/exit logic to common helpers")
> > > > 
> > > > But other architectures were left broken, and the infrastructure for
> > > > handling this correctly is x86-specific.
> > > > 
> > > > This series introduces generic helper functions which can be used to
> > > > handle the problems above, and migrates architectures over to these,
> > > > fixing the latent issues.
> > > > 
> > > > I wasn't able to figure my way around powerpc and s390, so I have not
> > > 
> > > I think 2 later patches have moved the guest_enter/exit a bit out.
> > > Does this make the s390 code clearer?
> > 
> > Yes; that's much simpler to follow!
> > 
> > One major thing I wasn't sure about for s390 is the sequence:
> > 
> > 	guest_enter_irqoff();	// Enters an RCU EQS
> > 	...
> > 	local_irq_enable();
> > 	...
> > 	sie64a(...);
> > 	...
> > 	local_irq_disable();
> > 	...
> > 	guest_exit_irqoff();	// Exits an RCU EQS
> > 
> > ... since if an IRQ is taken between local_irq_{enable,disable}(), RCU won't be
> > watching, and I couldn't spot whether your regular IRQ entry logic would wake
> > RCU in this case, or whether there was something else I'm missing that saves
> > you here.
> > 
> > For other architectures, including x86 and arm64, we enter the guest with IRQs
> > masked and return from the guest with IRQs masked, and don't actually take IRQs
> > until we unmask them in the host, after the guest_exit_*() logic has woken RCU
> > and so on.
> > 
> > I wasn't able to find documentation on the semantics of SIE, so I couldn't spot
> > whether the local_irq_{enable,disable}() calls were necessary, or could be
> > removed.
> 
> We run the SIE instruction with interrupts enabled. SIE is interruptible.
> The disable/enable pairs are just because  guest_enter/exit_irqoff() require them.

What I was trying to figure out was when an interrupt is taken between
guest_enter_irqoff() and guest_exit_irqoff(), where is RCU woken? I couldn't
spot that in the s390 entry code (probably simply because I'm not familiar with
it), and so AFAICT that means IRQ code could run without RCU watching, which
would cause things to explode.

On other architectures that problem is avoided because IRQs asserted during the
guest cause a specific guest exit rather than a regular IRQ exception, and the
HW enables/disables IRQs when entering/exiting the guest, so the host can leave
IRQs masked across guest_enter_irqoff()..guest_exit_irqoff().

Am I right in understanding that SIE itself won't enable (host) interrupts
while running the guest, and so it *needs* to be run with interrupts already
enabled?

> One thing to be aware of: in our entry.S - after an interrupt - we leave SIE by
> setting the return address of the interrupt after the sie instruction so that we
> get back into this __vcpu_run loop to check for signals and so.

Just to check, that's after the IRQ handler runs, right?

Thanks,
Mark.
