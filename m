Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D936696D50
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 19:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjBNSvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 13:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBNSvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 13:51:10 -0500
Received: from out-247.mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9BB1B0
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:51:08 -0800 (PST)
Date:   Tue, 14 Feb 2023 19:51:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676400666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vvYtQlrKp6AyeIZUDX2DrxovjnFtUq+IwEDZrW6/imE=;
        b=SnQDmKWCy9cvbps8WxNkrzrRq23UcKbebz2BLCWcB0KZUlAaScQ5rPmxvKgWYBOsvXTIZo
        1YDgWdaUxaFQTu6Q4coMAqyKANWGdXdAEfoyDL2PvZdtcdYaWAT4uH0JkYiUO3XjT1MLos
        to/dOdHEktfDZ48HUhBKS6tsP5uBKOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v4 3/6] arm: pmu: Rename ALL_SET and
 PRE_OVERFLOW
Message-ID: <20230214185104.bmofxz32e7yu4xaq@orel>
References: <20230126165351.2561582-1-ricarkol@google.com>
 <20230126165351.2561582-4-ricarkol@google.com>
 <ea888a30-9247-de34-9f8e-9cc1702fa021@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea888a30-9247-de34-9f8e-9cc1702fa021@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 04:48:59PM +0100, Eric Auger wrote:
> Hi Rocardo,
> 
> On 1/26/23 17:53, Ricardo Koller wrote:
> > Given that the arm PMU tests now handle 64-bit counters and overflows,
> > it's better to be precise about what the ALL_SET and PRE_OVERFLOW
> > macros actually are. Given that they are both 32-bit counters,
> > just add _32 to both of them.
> nit: wouldn't have hurt to rename OVERFLOW2 too even if it is only used
> in tests using chain events.

I'll rename OVERFLOW2 when merging.

Thanks,
drew

> 
> Besides:
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 
> Thanks
> 
> Eric
> 
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 78 +++++++++++++++++++++++++++----------------------------
> >  1 file changed, 39 insertions(+), 39 deletions(-)
> >
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 06cbd73..08e956d 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -54,9 +54,9 @@
> >  #define EXT_COMMON_EVENTS_LOW	0x4000
> >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> >  
> > -#define ALL_SET			0x00000000FFFFFFFFULL
> > +#define ALL_SET_32			0x00000000FFFFFFFFULL
> >  #define ALL_CLEAR		0x0000000000000000ULL
> > -#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > +#define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
> >  #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> >  
> >  #define PMU_PPI			23
> > @@ -153,11 +153,11 @@ static void pmu_reset(void)
> >  	/* reset all counters, counting disabled at PMCR level*/
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> >  	/* Disable all counters */
> > -	write_sysreg(ALL_SET, PMCNTENCLR);
> > +	write_sysreg(ALL_SET_32, PMCNTENCLR);
> >  	/* clear overflow reg */
> > -	write_sysreg(ALL_SET, PMOVSR);
> > +	write_sysreg(ALL_SET_32, PMOVSR);
> >  	/* disable overflow interrupts on all counters */
> > -	write_sysreg(ALL_SET, PMINTENCLR);
> > +	write_sysreg(ALL_SET_32, PMINTENCLR);
> >  	isb();
> >  }
> >  
> > @@ -322,7 +322,7 @@ static void irq_handler(struct pt_regs *regs)
> >  				pmu_stats.bitmap |= 1 << i;
> >  			}
> >  		}
> > -		write_sysreg(ALL_SET, pmovsclr_el0);
> > +		write_sysreg(ALL_SET_32, pmovsclr_el0);
> >  		isb();
> >  	} else {
> >  		pmu_stats.unexpected = true;
> > @@ -346,11 +346,11 @@ static void pmu_reset(void)
> >  	/* reset all counters, counting disabled at PMCR level*/
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> >  	/* Disable all counters */
> > -	write_sysreg_s(ALL_SET, PMCNTENCLR_EL0);
> > +	write_sysreg_s(ALL_SET_32, PMCNTENCLR_EL0);
> >  	/* clear overflow reg */
> > -	write_sysreg(ALL_SET, pmovsclr_el0);
> > +	write_sysreg(ALL_SET_32, pmovsclr_el0);
> >  	/* disable overflow interrupts on all counters */
> > -	write_sysreg(ALL_SET, pmintenclr_el1);
> > +	write_sysreg(ALL_SET_32, pmintenclr_el1);
> >  	pmu_reset_stats();
> >  	isb();
> >  }
> > @@ -463,7 +463,7 @@ static void test_basic_event_count(bool overflow_at_64bits)
> >  	write_regn_el0(pmevtyper, 1, INST_RETIRED | PMEVTYPER_EXCLUDE_EL0);
> >  
> >  	/* disable all counters */
> > -	write_sysreg_s(ALL_SET, PMCNTENCLR_EL0);
> > +	write_sysreg_s(ALL_SET_32, PMCNTENCLR_EL0);
> >  	report(!read_sysreg_s(PMCNTENCLR_EL0) && !read_sysreg_s(PMCNTENSET_EL0),
> >  		"pmcntenclr: disable all counters");
> >  
> > @@ -476,8 +476,8 @@ static void test_basic_event_count(bool overflow_at_64bits)
> >  	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
> >  
> >  	/* Preset counter #0 to pre overflow value to trigger an overflow */
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> > +	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
> >  		"counter #0 preset to pre-overflow value");
> >  	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
> >  
> > @@ -499,11 +499,11 @@ static void test_basic_event_count(bool overflow_at_64bits)
> >  		"pmcntenset: just enabled #0 and #1");
> >  
> >  	/* clear overflow register */
> > -	write_sysreg(ALL_SET, pmovsclr_el0);
> > +	write_sysreg(ALL_SET_32, pmovsclr_el0);
> >  	report(!read_sysreg(pmovsclr_el0), "check overflow reg is 0");
> >  
> >  	/* disable overflow interrupts on all counters*/
> > -	write_sysreg(ALL_SET, pmintenclr_el1);
> > +	write_sysreg(ALL_SET_32, pmintenclr_el1);
> >  	report(!read_sysreg(pmintenclr_el1),
> >  		"pmintenclr_el1=0, all interrupts disabled");
> >  
> > @@ -551,8 +551,8 @@ static void test_mem_access(bool overflow_at_64bits)
> >  
> >  	pmu_reset();
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> > +	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	isb();
> >  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> > @@ -566,7 +566,7 @@ static void test_mem_access(bool overflow_at_64bits)
> >  static void test_sw_incr(bool overflow_at_64bits)
> >  {
> >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> > +	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > @@ -580,7 +580,7 @@ static void test_sw_incr(bool overflow_at_64bits)
> >  	/* enable counters #0 and #1 */
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> > @@ -588,12 +588,12 @@ static void test_sw_incr(bool overflow_at_64bits)
> >  
> >  	isb();
> >  	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> > -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> > +	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
> >  		"PWSYNC does not increment if PMCR.E is unset");
> >  
> >  	pmu_reset();
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> >  	isb();
> > @@ -623,7 +623,7 @@ static void test_chained_counters(bool unused)
> >  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> >  	/* enable counters #0 and #1 */
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  
> > @@ -635,15 +635,15 @@ static void test_chained_counters(bool unused)
> >  	pmu_reset();
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	write_regn_el0(pmevcntr, 1, 0x1);
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> >  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> >  	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, ALL_SET);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> > +	write_regn_el0(pmevcntr, 1, ALL_SET_32);
> >  
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > @@ -654,8 +654,8 @@ static void test_chained_counters(bool unused)
> >  static void test_chained_sw_incr(bool unused)
> >  {
> >  	uint32_t events[] = {SW_INCR, CHAIN};
> > -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> > -	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
> > +	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
> > +	uint64_t cntr1 = (ALL_SET_32 + 1) & pmevcntr_mask();
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -668,7 +668,7 @@ static void test_chained_sw_incr(bool unused)
> >  	/* enable counters #0 and #1 */
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> >  	isb();
> >  
> > @@ -686,8 +686,8 @@ static void test_chained_sw_incr(bool unused)
> >  	pmu_reset();
> >  
> >  	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, ALL_SET);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> > +	write_regn_el0(pmevcntr, 1, ALL_SET_32);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> >  	isb();
> > @@ -725,7 +725,7 @@ static void test_chain_promotion(bool unused)
> >  
> >  	/* Only enable even counter */
> >  	pmu_reset();
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	write_sysreg_s(0x1, PMCNTENSET_EL0);
> >  	isb();
> >  
> > @@ -873,8 +873,8 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> >  	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> > +	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
> >  	isb();
> >  
> >  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> > @@ -893,13 +893,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >  	isb();
> >  	report(expect_interrupts(0), "no overflow interrupt after counting");
> >  
> > -	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
> > +	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET_32) */
> >  
> >  	pmu_reset_stats();
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > -	write_sysreg(ALL_SET, pmintenset_el1);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> > +	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
> > +	write_sysreg(ALL_SET_32, pmintenset_el1);
> >  	isb();
> >  
> >  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > @@ -916,7 +916,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >  	pmu_reset_stats();
> >  
> >  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	isb();
> >  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report(expect_interrupts(0x1),
> > @@ -924,8 +924,8 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >  
> >  	/* overflow on odd counter */
> >  	pmu_reset_stats();
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, ALL_SET);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> > +	write_regn_el0(pmevcntr, 1, ALL_SET_32);
> >  	isb();
> >  	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report(expect_interrupts(0x3),
> 
