Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7E248ED0D
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 16:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbiANPUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 10:20:11 -0500
Received: from foss.arm.com ([217.140.110.172]:34788 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242574AbiANPUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 10:20:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 725FF6D;
        Fri, 14 Jan 2022 07:20:08 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.2.91])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37DEB3F774;
        Fri, 14 Jan 2022 07:20:02 -0800 (PST)
Date:   Fri, 14 Jan 2022 15:19:59 +0000
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
Message-ID: <YeGUnwhbSvwJz5pD@FVFF77S0Q05N>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <127a6117-85fb-7477-983c-daf09e91349d@linux.ibm.com>
 <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
 <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
 <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
 <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 02:51:38PM +0100, Christian Borntraeger wrote:
> Am 14.01.22 um 14:32 schrieb Mark Rutland:
> > On Fri, Jan 14, 2022 at 01:29:46PM +0100, Christian Borntraeger wrote:
> > > Am 14.01.22 um 13:19 schrieb Mark Rutland:
> > > > On Thu, Jan 13, 2022 at 04:20:07PM +0100, Christian Borntraeger wrote:
> > > > > Am 11.01.22 um 16:35 schrieb Mark Rutland:

[...]

> > > > One major thing I wasn't sure about for s390 is the sequence:
> > > > 
> > > > 	guest_enter_irqoff();	// Enters an RCU EQS
> > > > 	...
> > > > 	local_irq_enable();
> > > > 	...
> > > > 	sie64a(...);
> > > > 	...
> > > > 	local_irq_disable();
> > > > 	...
> > > > 	guest_exit_irqoff();	// Exits an RCU EQS
> > > > 
> > > > ... since if an IRQ is taken between local_irq_{enable,disable}(), RCU won't be
> > > > watching, and I couldn't spot whether your regular IRQ entry logic would wake
> > > > RCU in this case, or whether there was something else I'm missing that saves
> > > > you here.
> > > > 
> > > > For other architectures, including x86 and arm64, we enter the guest with IRQs
> > > > masked and return from the guest with IRQs masked, and don't actually take IRQs
> > > > until we unmask them in the host, after the guest_exit_*() logic has woken RCU
> > > > and so on.
> > > > 
> > > > I wasn't able to find documentation on the semantics of SIE, so I couldn't spot
> > > > whether the local_irq_{enable,disable}() calls were necessary, or could be
> > > > removed.
> > > 
> > > We run the SIE instruction with interrupts enabled. SIE is interruptible.
> > > The disable/enable pairs are just because  guest_enter/exit_irqoff() require them.
> > 
> > What I was trying to figure out was when an interrupt is taken between
> > guest_enter_irqoff() and guest_exit_irqoff(), where is RCU woken? I couldn't
> > spot that in the s390 entry code (probably simply because I'm not familiar with
> > it), and so AFAICT that means IRQ code could run without RCU watching, which
> > would cause things to explode.
> > 
> > On other architectures that problem is avoided because IRQs asserted during the
> > guest cause a specific guest exit rather than a regular IRQ exception, and the
> > HW enables/disables IRQs when entering/exiting the guest, so the host can leave
> > IRQs masked across guest_enter_irqoff()..guest_exit_irqoff().
> > 
> > Am I right in understanding that SIE itself won't enable (host) interrupts
> > while running the guest, and so it *needs* to be run with interrupts already
> > enabled?
> 
> yes
> 
> > > One thing to be aware of: in our entry.S - after an interrupt - we leave SIE by
> > > setting the return address of the interrupt after the sie instruction so that we
> > > get back into this __vcpu_run loop to check for signals and so.
> > 
> > Just to check, that's after the IRQ handler runs, right?
> 
> and yes.

Thanks for confirming! 

IIUC as above, that means there's a latent RCU bug on s390, and to fix that
we'll need to add something to the IRQ entry logic to wake RCU for any IRQ
taken in the EQS between guest_enter_irqoff() and guest_exit_irqoff(), similar
to what is done for IRQs taken from an idle EQS.

I see s390 uses the common irqentry_{enter,exit}(), so perhaps we could extend
the logic there to check something in addition to is_idle_task()? e.g. add a
noinstr helper to check kvm_running_vcpu, Or add a thread flag that says we're
in this guest EQS.

I also think there is another issue here. When an IRQ is taken from SIE, will
user_mode(regs) always be false, or could it be true if the guest userspace is
running? If it can be true I think tha context tracking checks can complain,
and it *might* be possible to trigger a panic().

In irqentry_enter(), if user_mode(regs) == true, we call
irqentry_enter_from_user_mode -> __enter_from_user_mode(). There we check that
the context is CONTEXT_USER, but IIUC that will be CONTEXT_GUEST at this point.
We also call arch_check_user_regs(), and IIUC this might permit a malicious
guest to trigger a host panic by way of debug_user_asce(), but I may have
misunderstood and that might not be possible.

Thanks,
Mark.
