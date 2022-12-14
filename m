Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A89564C75D
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 11:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238031AbiLNKpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 05:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238012AbiLNKpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 05:45:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21735FAE5
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:45:16 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45147FEC;
        Wed, 14 Dec 2022 02:45:56 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FD313F5A1;
        Wed, 14 Dec 2022 02:45:14 -0800 (PST)
Date:   Wed, 14 Dec 2022 10:45:07 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Add tests for 64-bit
 overflows
Message-ID: <Y5mpM4uQiM+scQ5l@monolith.localdoman>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-4-ricarkol@google.com>
 <Y5iwbJykRKFQumKi@monolith.localdoman>
 <Y5i+lMQ6/2hWGM47@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5i+lMQ6/2hWGM47@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Dec 13, 2022 at 10:04:04AM -0800, Ricardo Koller wrote:
> On Tue, Dec 13, 2022 at 05:03:40PM +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > Checked that all places where ALL_SET/PRE_OVERFLOW were used are now taking
> > into account the fact that counters are programmed to be 64bit.
> > 
> > In the case of 64bit counters, the printf format specifier is %ld, which
> > means that ALL_SET_64 and PRE_OVERFLOW_64 are now displayed as negative
> > numbers. For example:
> > 
> > INFO: pmu: pmu-sw-incr: 32-bit: SW_INCR counter #0 has value 4294967280
> > PASS: pmu: pmu-sw-incr: 32-bit: PWSYNC does not increment if PMCR.E is unset
> > [..]
> > INFO: pmu: pmu-sw-incr: 64-bit: SW_INCR counter #0 has value -16
> > PASS: pmu: pmu-sw-incr: 64-bit: PWSYNC does not increment if PMCR.E is unset
> > 
> 
> Argh, I didn't notice this. I think this would be more useful if it
> printed %llx in all cases.

Indeed, printing the hex value will make it easier to match it against the
defines.

One more comment below.

> 
> > I was thinking that the format specifiers could be changed to unsigned
> > long.  The counters only increment, they don't decrement, and I can't think
> > how printing them as signed could be useful.
> > 
> > One more comment below.
> > 
> > On Fri, Dec 02, 2022 at 04:55:27AM +0000, Ricardo Koller wrote:
> > > Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
> > > and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
> > > supported on PMUv3p5.
> > > 
> > > Note that chained tests do not implement "overflow_at_64bits == true".
> > > That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
> > > details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
> > > 0487H.a, J1.1.1 "aarch64/debug").
> > > 
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > ---
> > >  arm/pmu.c | 91 ++++++++++++++++++++++++++++++++++++-------------------
> > >  1 file changed, 60 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/arm/pmu.c b/arm/pmu.c
> > > index 59e5bfe..3cb563b 100644
> > > --- a/arm/pmu.c
> > > +++ b/arm/pmu.c
> > > @@ -28,6 +28,7 @@
> > >  #define PMU_PMCR_X         (1 << 4)
> > >  #define PMU_PMCR_DP        (1 << 5)
> > >  #define PMU_PMCR_LC        (1 << 6)
> > > +#define PMU_PMCR_LP        (1 << 7)
> > >  #define PMU_PMCR_N_SHIFT   11
> > >  #define PMU_PMCR_N_MASK    0x1f
> > >  #define PMU_PMCR_ID_SHIFT  16
> > > @@ -55,10 +56,15 @@
> > >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> > >  
> > >  #define ALL_SET			0x00000000FFFFFFFFULL
> > > +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
> > >  #define ALL_CLEAR		0x0000000000000000ULL
> > >  #define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > > +#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
> > >  #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> > >  
> > > +#define PRE_OVERFLOW_AT(_64b)	(_64b ? PRE_OVERFLOW_64 : PRE_OVERFLOW)
> > > +#define ALL_SET_AT(_64b)	(_64b ? ALL_SET_64 : ALL_SET)
> > > +
> > >  #define PMU_PPI			23
> > >  
> > >  struct pmu {
> > > @@ -429,8 +435,10 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events,
> > >  static void test_basic_event_count(bool overflow_at_64bits)
> > >  {
> > >  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
> > > -	uint32_t counter_mask;
> > > +	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
> > > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> > >  	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
> > > +	uint32_t counter_mask;
> > >  
> > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
> > >  				   overflow_at_64bits))
> > > @@ -452,13 +460,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
> > >  	 * clear cycle and all event counters and allow counter enablement
> > >  	 * through PMCNTENSET. LC is RES1.
> > >  	 */
> > > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> > > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
> > >  	isb();
> > > -	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
> > > +	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
> > >  
> > >  	/* Preset counter #0 to pre overflow value to trigger an overflow */
> > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
> > >  		"counter #0 preset to pre-overflow value");
> > >  	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
> > >  
> > > @@ -511,6 +519,8 @@ static void test_mem_access(bool overflow_at_64bits)
> > >  {
> > >  	void *addr = malloc(PAGE_SIZE);
> > >  	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
> > > +	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
> > > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> > >  
> > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
> > >  				   overflow_at_64bits))
> > > @@ -522,7 +532,7 @@ static void test_mem_access(bool overflow_at_64bits)
> > >  	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > >  	isb();
> > > -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> > > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > >  	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
> > >  	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
> > >  	/* We may measure more than 20 mem access depending on the core */
> > > @@ -532,11 +542,11 @@ static void test_mem_access(bool overflow_at_64bits)
> > >  
> > >  	pmu_reset();
> > >  
> > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > >  	isb();
> > > -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> > > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > >  	report(read_sysreg(pmovsclr_el0) == 0x3,
> > >  	       "Ran 20 mem accesses with expected overflows on both counters");
> > >  	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
> > > @@ -546,6 +556,8 @@ static void test_mem_access(bool overflow_at_64bits)
> > >  
> > >  static void test_sw_incr(bool overflow_at_64bits)
> > >  {
> > > +	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
> > > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> > >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > >  	uint64_t cntr0;
> > >  	int i;
> > > @@ -561,7 +573,7 @@ static void test_sw_incr(bool overflow_at_64bits)
> > >  	/* enable counters #0 and #1 */
> > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > >  
> > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > >  	isb();
> > >  
> > >  	for (i = 0; i < 100; i++)
> > > @@ -569,21 +581,21 @@ static void test_sw_incr(bool overflow_at_64bits)
> > >  
> > >  	isb();
> > >  	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> > > -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> > > +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
> > >  		"PWSYNC does not increment if PMCR.E is unset");
> > >  
> > >  	pmu_reset();
> > >  
> > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > >  	isb();
> > >  
> > >  	for (i = 0; i < 100; i++)
> > >  		write_sysreg(0x3, pmswinc_el0);
> > >  
> > >  	isb();
> > > -	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> > > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : pre_overflow + 100;
> > >  	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> > >  	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
> > >  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> > > @@ -844,6 +856,9 @@ static bool expect_interrupts(uint32_t bitmap)
> > >  
> > >  static void test_overflow_interrupt(bool overflow_at_64bits)
> > >  {
> > > +	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
> > > +	uint64_t all_set = ALL_SET_AT(overflow_at_64bits);
> > > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> > >  	uint32_t events[] = {MEM_ACCESS, SW_INCR};
> > >  	void *addr = malloc(PAGE_SIZE);
> > >  	int i;
> > > @@ -862,16 +877,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> > >  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> > >  	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
> > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> > >  	isb();
> > >  
> > >  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> > >  
> > > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> > >  
> > > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > >  	isb();
> > >  
> > >  	for (i = 0; i < 100; i++)
> > > @@ -886,12 +901,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> > >  
> > >  	pmu_reset_stats();
> > >  
> > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> > >  	write_sysreg(ALL_SET, pmintenset_el1);
> > >  	isb();
> > >  
> > > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > > +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > >  	for (i = 0; i < 100; i++)
> > >  		write_sysreg(0x3, pmswinc_el0);
> > >  
> > > @@ -900,25 +915,35 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> > >  	report(expect_interrupts(0x3),
> > >  		"overflow interrupts expected on #0 and #1");
> > >  
> > > -	/* promote to 64-b */
> > > +	/*
> > > +	 * promote to 64-b:
> > > +	 *
> > > +	 * This only applies to the !overflow_at_64bits case, as
> > > +	 * overflow_at_64bits doesn't implement CHAIN events. The
> > > +	 * overflow_at_64bits case just checks that chained counters are
> > > +	 * not incremented when PMCR.LP == 1.
> > > +	 */
> > 
> > If this doesn't do anything for when overflow_at_64bits, and since the
> > interrupt is already tested before this part, why not exit early?
> > 
> > Or the test could check that the CHAIN event indeed does not increment when
> > LP=1 at the end of this function.
> 
> That's precisely what it's doing.

Where? Are you referring to this part?

	if (overflow_at_64bits)
		report(expect_interrupts(0x1),
		       "expect overflow interrupt on even counter");

My suggestion was to check that the counter that counts the CHAIN event
didn't increment (PMEVCNTR1_EL0 == all_set). I was thinking that since KVM
emulates the CHAIN event in software, it might be useful to check that the
final state of all registers is consistent. I'll leave it up to you to
decide if you want to add this extra check.

Thanks,
Alex

> 
> Thanks!
> Ricardo
> 
> > 
> > Thanks,
> > Alex
> > 
> > >  
> > >  	pmu_reset_stats();
> > >  
> > >  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > >  	isb();
> > > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > > -	report(expect_interrupts(0x1),
> > > -		"expect overflow interrupt on 32b boundary");
> > > +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > +	report(expect_interrupts(0x1), "expect overflow interrupt");
> > >  
> > >  	/* overflow on odd counter */
> > >  	pmu_reset_stats();
> > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > -	write_regn_el0(pmevcntr, 1, ALL_SET);
> > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > +	write_regn_el0(pmevcntr, 1, all_set);
> > >  	isb();
> > > -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> > > -	report(expect_interrupts(0x3),
> > > -		"expect overflow interrupt on even and odd counter");
> > > +	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > +	if (overflow_at_64bits)
> > > +		report(expect_interrupts(0x1),
> > > +		       "expect overflow interrupt on even counter");
> > > +	else
> > > +		report(expect_interrupts(0x3),
> > > +		       "expect overflow interrupt on even and odd counter");
> > >  }
> > >  #endif
> > >  
> > > @@ -1119,10 +1144,13 @@ int main(int argc, char *argv[])
> > >  		report_prefix_pop();
> > >  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
> > >  		run_test(argv[1], test_basic_event_count, false);
> > > +		run_test(argv[1], test_basic_event_count, true);
> > >  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
> > >  		run_test(argv[1], test_mem_access, false);
> > > +		run_test(argv[1], test_mem_access, true);
> > >  	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
> > >  		run_test(argv[1], test_sw_incr, false);
> > > +		run_test(argv[1], test_sw_incr, true);
> > >  	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
> > >  		run_test(argv[1], test_chained_counters, false);
> > >  	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> > > @@ -1131,6 +1159,7 @@ int main(int argc, char *argv[])
> > >  		run_test(argv[1], test_chain_promotion, false);
> > >  	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
> > >  		run_test(argv[1], test_overflow_interrupt, false);
> > > +		run_test(argv[1], test_overflow_interrupt, true);
> > >  	} else {
> > >  		report_abort("Unknown sub-test '%s'", argv[1]);
> > >  	}
> > > -- 
> > > 2.39.0.rc0.267.gcb52ba06e7-goog
> > > 
