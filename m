Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0082F48E96A
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 12:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbiANLsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 06:48:18 -0500
Received: from foss.arm.com ([217.140.110.172]:60442 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234679AbiANLsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 06:48:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A95BDED1;
        Fri, 14 Jan 2022 03:48:16 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.2.91])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFF7F3F5A1;
        Fri, 14 Jan 2022 03:48:10 -0800 (PST)
Date:   Fri, 14 Jan 2022 11:48:04 +0000
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
Subject: Re: [PATCH 1/5] kvm: add exit_to_guest_mode() and
 enter_from_guest_mode()
Message-ID: <YeFi9FTPSyLbQytu@FVFF77S0Q05N>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-2-mark.rutland@arm.com>
 <YeCMVGqiVfTKESzy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeCMVGqiVfTKESzy@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 08:32:20PM +0000, Sean Christopherson wrote:
> On Tue, Jan 11, 2022, Mark Rutland wrote:
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
> 
> I'm not a fan of this nomenclature.  First and foremost, virtualization refers to
> transfers to guest mode as VM-Enter, and transfers from guest mode as VM-Exit.
> It's really, really confusing to read this code from a virtualization perspective.
> The functions themselves are contradictory as the "enter" helper calls functions
> with "exit" in their name, and vice versa.

Sure; FWIW I wasn't happy with the naming either, but I couldn't find anything
that was entirely clear, because it depends on whether you consider this an
entry..exit of guest context or an exit..entry of regular kernel context. I
went with exit_to_guest_mode() and enter_from_guest_mode() because that clearly
corresponded to exit_to_user_mode() and enter_from_user_mode(), and the
convention in the common entry code is to talk in terms of the regular kernel
context.

While I was working on this, I had guest_context_enter_irqoff() for
kernel->guest and guest_context_exit_irqoff() for guest->kernel, which also
matched the style of guest_timing_{enter,exit}_irqoff().

I'm happy to change to that, if that works for you?

> We settled on xfer_to_guest_mode_work() for a similar conundrum in the past, though
> I don't love using xfer_to/from_guest_mode() as that makes it sound like those
> helpers handle the actual transition into guest mode, i.e. runs the vCPU.
> 
> To avoid too much bikeshedding, what about reusing the names we all compromised
> on when we did this for x86 and call them kvm_guest_enter/exit_irqoff()?  If x86
> is converted in the first patch then we could even avoid temporary #ifdefs.

I'd like to keep this somewhat orthogonal to the x86 changes (e.g. as other
architectures will need backports to stable at least for the RCU bug fix), so
I'd rather use a name that isn't immediately coupled with x86 changes.

Does the guest_context_{enter,exit}_irqoff() naming above work for you?

Thanks,
Mark.
