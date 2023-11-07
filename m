Return-Path: <kvm+bounces-889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E04F77E4169
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 074631C20C8B
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40BE30F92;
	Tue,  7 Nov 2023 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BA13212
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:05:11 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D21AB3
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 06:05:09 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69D4513D5;
	Tue,  7 Nov 2023 06:05:53 -0800 (PST)
Received: from monolith (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58CD63F703;
	Tue,  7 Nov 2023 06:05:07 -0800 (PST)
Date: Tue, 7 Nov 2023 14:05:49 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	andrew.jones@linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	jarichte@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm: pmu-overflow-interrupt: Increase
 count values
Message-ID: <ZUpEPbILA-idXISd@monolith>
References: <20231103100139.55807-1-eric.auger@redhat.com>
 <ZUoIxznZwPyti254@monolith>
 <5d93f447-c2c5-4c41-b0ea-9108736a2372@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d93f447-c2c5-4c41-b0ea-9108736a2372@redhat.com>

On Tue, Nov 07, 2023 at 02:34:05PM +0100, Eric Auger wrote:
> Hi Alexandru,
> 
> On 11/7/23 10:52, Alexandru Elisei wrote:
> > Hi Eric,
> >
> > On Fri, Nov 03, 2023 at 11:01:39AM +0100, Eric Auger wrote:
> >> On some hardware, some pmu-overflow-interrupt failures can be observed.
> >> Although the even counter overflows, the interrupt is not seen as
> >> expected. This happens in the subtest after "promote to 64-b" comment.
> >> After analysis, the PMU overflow interrupt actually hits, ie.
> >> kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
> >> as expected. However the PMCR.E is reset by the handle_exit path, at
> >> kvm_pmu_handle_pmcr() before the next guest entry and
> >> kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
> >> There, since the enable bit has been reset, kvm_pmu_update_state() does
> >> not inject the interrupt into the guest.
> >>
> >> This does not seem to be a KVM bug but rather an unfortunate
> >> scenario where the test disables the PMCR.E too closely to the
> >> advent of the overflow interrupt.
> > If I understand correctly, the KVM PMU, after receiving the hardware PMUIRQ and
> > before injecting the interrupt, checks that the PMU is enabled according to the
> > pseudocode for the function CheckForPMUOverflow(). CheckForPMUOverflow() returns
> > false because PMCR_EL1.E is 0, so the KVM PMU decides not to inject the
> > interrupt.
> >
> > Is that correct?
> 
> Yes that's correct
> >
> > Changing the number of SW_INCR events might not be optimal - for example,
> > COUNT_INT > 100 might hide an error that otherwise would have been triggered if
> > the number of events were 100. Not very likely, but still a possibility.
> I also changed the COUNT for SW_INCR events to unify the code. However
> this is not strictly necessary to fix the issue I encounter. I can
> revert that change if you prefer.

I don't understand how that would solve the problem. As I see it, the problem is
that PMCR_EL1.E is cleared too fast after the PMU asserts the interrupt on
overflow, not the time it takes to get to the overflow condition (i.e, the
number of iterations mem_access_loop() does).

> >
> > Another approach would be to wait for a set amount of time for the CPU to take
> > the interrupt. There's something similar in timer.c::{test_timer_tval(),
> > timer_do_wfi()}.
> you're right. However this would urge me to have a separate asm code
> that loops with wfi after doing the mem_access loop. I am not sure this
> is worth the candle here?

I think plain C would work, I was thinking something like this:

diff --git a/arm/pmu.c b/arm/pmu.c
index a91a7b1fd4be..fb2eb5fa2e50 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -979,6 +979,23 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
        /* interrupts are disabled (PMINTENSET_EL1 == 0) */

        mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+
+       if (!expect_interrupts(0)) {
+                for (i = 0; i < 10; i++) {
+                       local_irq_disable();
+                       if (expect_interrupts(0)) {
+                               local_irq_enable();
+                               break;
+                       }
+                       report_info("waiting for interrupt...");
+                       wfi();
+                       local_irq_enable();
+                       if (expect_interrupts(0))
+                               break;
+                        mdelay(100);
+                }
+       }
+
        report(expect_interrupts(0), "no overflow interrupt after preset");

        set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);

Can be cleaned up by moving it to separate function, etc. Has the downside that
it may performs extra memory accesses in expect_interrupts(). Your choice.

By the way, pmu_stats is not declared volatile, which means that the
compiler is free to optimize accesses to the struct by caching previously
read values in registers. Have you tried declaring it as volatile, in case
that fixes the issues you were seeing?

If you do decide to go with the above suggestion, I strongly suggest
pmu_stats is declared as volatile, otherwise the compiler will likely end
up not reading from memory on every iteration.

Thanks,
Alex
> 
> Thanks!
> 
> Eric
> >
> > Thanks,
> > Alex
> >
> >> Since it looks like a benign and inlikely case, let's resize the number
> >> of iterations to prevent the PMCR enable bit from being resetted
> >> at the same time as the actual overflow event.
> >>
> >> COUNT_INT is introduced, arbitrarily set to 1000 iterations and is
> >> used in this test.
> >>
> >> Reported-by: Jan Richter <jarichte@redhat.com>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> ---
> >>  arm/pmu.c | 15 ++++++++-------
> >>  1 file changed, 8 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/arm/pmu.c b/arm/pmu.c
> >> index a91a7b1f..acd88571 100644
> >> --- a/arm/pmu.c
> >> +++ b/arm/pmu.c
> >> @@ -66,6 +66,7 @@
> >>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
> >>  #define COUNT 250
> >>  #define MARGIN 100
> >> +#define COUNT_INT 1000
> >>  /*
> >>   * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
> >>   * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
> >> @@ -978,13 +979,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >>  
> >>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> >>  
> >> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >>  	report(expect_interrupts(0), "no overflow interrupt after preset");
> >>  
> >>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >>  	isb();
> >>  
> >> -	for (i = 0; i < 100; i++)
> >> +	for (i = 0; i < COUNT_INT; i++)
> >>  		write_sysreg(0x2, pmswinc_el0);
> >>  
> >>  	isb();
> >> @@ -1002,15 +1003,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >>  	write_sysreg(ALL_SET_32, pmintenset_el1);
> >>  	isb();
> >>  
> >> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >>  
> >>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >>  	isb();
> >>  
> >> -	for (i = 0; i < 100; i++)
> >> +	for (i = 0; i < COUNT_INT; i++)
> >>  		write_sysreg(0x3, pmswinc_el0);
> >>  
> >> -	mem_access_loop(addr, 200, pmu.pmcr_ro);
> >> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro);
> >>  	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
> >>  	report(expect_interrupts(0x3),
> >>  		"overflow interrupts expected on #0 and #1");
> >> @@ -1029,7 +1030,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> >>  	write_regn_el0(pmevcntr, 0, pre_overflow);
> >>  	isb();
> >> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >>  	report(expect_interrupts(0x1), "expect overflow interrupt");
> >>  
> >>  	/* overflow on odd counter */
> >> @@ -1037,7 +1038,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >>  	write_regn_el0(pmevcntr, 0, pre_overflow);
> >>  	write_regn_el0(pmevcntr, 1, all_set);
> >>  	isb();
> >> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >>  	if (overflow_at_64bits) {
> >>  		report(expect_interrupts(0x1),
> >>  		       "expect overflow interrupt on even counter");
> >> -- 
> >> 2.41.0
> >>
> 

