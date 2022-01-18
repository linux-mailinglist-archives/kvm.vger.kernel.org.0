Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6CC492CA9
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347541AbiARRvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:51:05 -0500
Received: from foss.arm.com ([217.140.110.172]:34458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbiARRvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 12:51:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34280D6E;
        Tue, 18 Jan 2022 09:51:04 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.37.52])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4186C3F774;
        Tue, 18 Jan 2022 09:50:55 -0800 (PST)
Date:   Tue, 18 Jan 2022 17:50:51 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
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
        seanjc@google.com, suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Message-ID: <20220118175051.GE17938@C02TD0UTHF1T.local>
References: <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
 <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
 <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
 <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
 <YeGUnwhbSvwJz5pD@FVFF77S0Q05N>
 <8aa0cada-7f00-47b3-41e4-8a9e7beaae47@redhat.com>
 <20220118120154.GA17938@C02TD0UTHF1T.local>
 <6b6b8a2b-202c-8966-b3f7-5ce35cf40a7e@linux.ibm.com>
 <20220118131223.GC17938@C02TD0UTHF1T.local>
 <yt9dfsplc9fu.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yt9dfsplc9fu.fsf@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 05:09:25PM +0100, Sven Schnelle wrote:
> Hi Mark,

Hi Sven,

> Mark Rutland <mark.rutland@arm.com> writes:
> > On Tue, Jan 18, 2022 at 01:42:26PM +0100, Christian Borntraeger wrote:
> >> Will you provide an s390 patch in your next iteration or shall we then do
> >> one as soon as there is a v2? We also need to look into vsie.c where we
> >> also call sie64a
> >
> > I'm having a go at that now; my plan is to try to have an s390 patch as
> > part of v2 in the next day or so.
> >
> > Now that I have a rough idea of how SIE and exception handling works on
> > s390, I think the structural changes to kvm-s390.c:__vcpu_run() and
> > vsie.c:do_vsie_run() are fairly simple.
> >
> > The only open bit is exactly how/where to identify when the interrupt
> > entry code needs to wake RCU. I can add a per-cpu variable or thread
> > flag to indicate that we're inside that EQS, or or I could move the irq
> > enable/disable into the sie64a asm and identify that as with the OUTSIDE
> > macro in the entry asm.
> 
> I wonder whether the code in irqentry_enter() should call a function
> is_eqs() instead of is_idle_task(). The default implementation would
> be just a
> 
> #ifndef is_eqs
> #define is_eqs is_idle_task
> #endif
> 
> and if an architecture has special requirements, it could just define
> is_eqs() and do the required checks there. This way the architecture
> could define whether it's a percpu bit, a cpu flag or something else.

I had come to almost the same approach: I've added an arch_in_rcu_eqs()
which is checked in addition to the existing is_idle_thread() check.

In the case of checking is_idle_thread() and checking for PF_VCPU, I'm
assuming the compiler can merge the loads of current->flags, and there's
little gain by making this entirely architecture specific, but we can
always check that and/or reconsider in future.

Thanks,
Mark.
