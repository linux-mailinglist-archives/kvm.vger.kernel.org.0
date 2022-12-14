Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE5464C760
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 11:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbiLNKqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 05:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiLNKqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 05:46:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51BD823BC8
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:46:10 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C703FEC;
        Wed, 14 Dec 2022 02:46:50 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 987053F5A1;
        Wed, 14 Dec 2022 02:46:08 -0800 (PST)
Date:   Wed, 14 Dec 2022 10:46:05 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y5mpbWmhTi41Rmni@monolith.localdoman>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-2-ricarkol@google.com>
 <Y5hxvj6p+mCC2DOs@monolith.localdoman>
 <Y5imhKUIJceHDUMD@google.com>
 <Y5irunF72esHzOWj@monolith.localdoman>
 <Y5i94ojqRTJMWu8U@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5i94ojqRTJMWu8U@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Dec 13, 2022 at 10:01:06AM -0800, Ricardo Koller wrote:
> On Tue, Dec 13, 2022 at 04:43:38PM +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Tue, Dec 13, 2022 at 08:21:24AM -0800, Ricardo Koller wrote:
> > > On Tue, Dec 13, 2022 at 12:36:14PM +0000, Alexandru Elisei wrote:
> > > > Hi,
> > > > 
> > > > Some more comments below.
> > > > 
> > > > On Fri, Dec 02, 2022 at 04:55:25AM +0000, Ricardo Koller wrote:
> > > > > PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> > > > > for overflowing at 32 or 64-bits. The consequence is that tests that check
> > > > > the counter values after overflowing should not assume that values will be
> > > > > wrapped around 32-bits: they overflow into the other half of the 64-bit
> > > > > counters on PMUv3p5.
> > > > > 
> > > > > Fix tests by correctly checking overflowing-counters against the expected
> > > > > 64-bit value.
> > > > > 
> > > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > > ---
> > > > >  arm/pmu.c | 29 ++++++++++++++++++-----------
> > > > >  1 file changed, 18 insertions(+), 11 deletions(-)
> > > > > 
> > > > > diff --git a/arm/pmu.c b/arm/pmu.c
> > > > > index cd47b14..eeac984 100644
> > > > > --- a/arm/pmu.c
> > > > > +++ b/arm/pmu.c
> > > > > @@ -54,10 +54,10 @@
> > > > >  #define EXT_COMMON_EVENTS_LOW	0x4000
> > > > >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> > > > >  
> > > > > -#define ALL_SET			0xFFFFFFFF
> > > > > -#define ALL_CLEAR		0x0
> > > > > -#define PRE_OVERFLOW		0xFFFFFFF0
> > > > > -#define PRE_OVERFLOW2		0xFFFFFFDC
> > > > > +#define ALL_SET			0x00000000FFFFFFFFULL
> > > > > +#define ALL_CLEAR		0x0000000000000000ULL
> > > > > +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > > > > +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> > > > >  
> > > > >  #define PMU_PPI			23
> > > > >  
> > > > > @@ -538,6 +538,7 @@ static void test_mem_access(void)
> > > > >  static void test_sw_incr(void)
> > > > >  {
> > > > >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > > > > +	uint64_t cntr0;
> > > > >  	int i;
> > > > >  
> > > > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > > > > @@ -572,9 +573,9 @@ static void test_sw_incr(void)
> > > > >  		write_sysreg(0x3, pmswinc_el0);
> > > > >  
> > > > >  	isb();
> > > > > -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> > > > > -	report(read_regn_el0(pmevcntr, 1)  == 100,
> > > > > -		"counter #0 after + 100 SW_INCR");
> > > > > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> > > > > +	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> > > > > +	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
> > > > >  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> > > > >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> > > > >  	report(read_sysreg(pmovsclr_el0) == 0x1,
> > > > > @@ -584,6 +585,7 @@ static void test_sw_incr(void)
> > > > >  static void test_chained_counters(void)
> > > > >  {
> > > > >  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> > > > > +	uint64_t cntr1;
> > > > >  
> > > > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > > > >  		return;
> > > > > @@ -618,13 +620,16 @@ static void test_chained_counters(void)
> > > > >  
> > > > >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> > > > >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > > > > -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > > > > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > > > > +	report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
> > > > 
> > > > It looks to me like the intention of the test was to check that the counter
> > > > programmed with the CHAIN event wraps, judging from the report message.
> > > > 
> > > 
> > > Ah, right. Yeah, that message is confusing. It should be the short
> > > version of "Inrementing at 32-bits resulted in the right value".
> > > 
> > > > I think it would be interesting to keep that by programming counter #1 with
> > > > ~0ULL when PMUv3p5 (maybe call it ALL_SET64?) and test the counter value
> > > > against 0.
> > > 
> > > The last commit adds tests using ALL_SET64.  Tests can be run in two
> > > modes: overflow_at_64bits and not.  However, this test,
> > > test_chained_counters(), and all other chained tests only use the
> > > !overflow_at_64bits mode (even after the last commit). The reason is
> > > that there are no CHAIN events when overflowing at 64-bits (more details
> > > in the commit message). But, don't worry, there are lots of tests that
> > > check wrapping at 64-bits (overflow_at_64bits=true).
> > 
> > What I was suggesting is this (change on top of this series, not on top of
> > this patch, to get access to ALL_SET_AT):
> 
> Ooh, I see, I agree: it would be better to check that the odd counter
> increments from ~0ULL to 0 when using 64-bit counters.
> 
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 3cb563b1abe4..fd7f20fc6c52 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -607,7 +607,6 @@ static void test_sw_incr(bool overflow_at_64bits)
> >  static void test_chained_counters(bool overflow_at_64bits)
> >  {
> >         uint32_t events[] = {CPU_CYCLES, CHAIN};
> > -       uint64_t cntr1;
> > 
> >         if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
> >                                    overflow_at_64bits))
> > @@ -639,12 +638,11 @@ static void test_chained_counters(bool overflow_at_64bits)
> >         report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
> > 
> >         write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -       write_regn_el0(pmevcntr, 1, ALL_SET);
> > +       write_regn_el0(pmevcntr, 1, ALL_SET_AT(overflow_at_64bits));
> 
> The only change is that this should be:
> 
> 	ALL_SET_AT(pmu.version >= ID_DFR0_PMU_V3_8_5)
> 
> Because "overflow_at_64bits" implies PMCR_EL0.LP = 1.

Right, and test_chained_counters() is never called with overflow_at_64bits
== true.

How about renaming the parameter overflow_at_64bits -> unused (or something
like that) to make it clear that the function does the same thing
regardless of the value?

Thanks,
Alex

> 
> > 
> >         precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >         report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > -       cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > -       report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
> > +       report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
> > 
> >         report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> > 
> > The counters are 64bit, but the CHAIN event should still work because
> > PMCR_EL0.LP is 0, according to the event description in the Arm ARM (ARM
> > DDI 0487I.a, page D17-6461).
> > 
> > Thanks,
> > Alex
> > 
> > > 
> > > > Alternatively, the report message can be modified, and "wrapped"
> > > > replaced with "incremented" (or something like that), to avoid confusion.
> > > > 
> > > > > +
> > > > >  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> > > > >  }
> > > > >  
> > > > >  static void test_chained_sw_incr(void)
> > > > >  {
> > > > >  	uint32_t events[] = {SW_INCR, CHAIN};
> > > > > +	uint64_t cntr0, cntr1;
> > > > >  	int i;
> > > > >  
> > > > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > > > > @@ -665,10 +670,12 @@ static void test_chained_sw_incr(void)
> > > > >  		write_sysreg(0x1, pmswinc_el0);
> > > > >  
> > > > >  	isb();
> > > > > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > > > > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> > > > >  	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> > > > > -		(read_regn_el0(pmevcntr, 1) == 0) &&
> > > > > -		(read_regn_el0(pmevcntr, 0) == 84),
> > > > > -		"expected overflows and values after 100 SW_INCR/CHAIN");
> > > > > +	       (read_regn_el0(pmevcntr, 1) == cntr0) &&
> > > > > +	       (read_regn_el0(pmevcntr, 0) == cntr1),
> > > > 
> > > > This is hard to parse, it would be better if counter 0 is compared against
> > > > cntr0 and counter 1 against cntr1.
> > > 
> > > Ah, yes, code is correct but that's indeed confusing.
> > > 
> > > > 
> > > > Also, same suggestion here, looks like the test wants to check that the
> > > > odd-numbered counter wraps around when counting the CHAIN event.
> > > 
> > > Ack. Will update for v2.
> > > 
> > > Thanks!
> > > Ricardo
> > > 
> > > > 
> > > > Thanks,
> > > > Alex
> > > > 
> > > > > +	       "expected overflows and values after 100 SW_INCR/CHAIN");
> > > > >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> > > > >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> > > > >  }
> > > > > -- 
> > > > > 2.39.0.rc0.267.gcb52ba06e7-goog
> > > > > 
