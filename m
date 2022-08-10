Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835EA58F257
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiHJS27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 14:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiHJS26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 14:28:58 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF29086C16
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 11:28:56 -0700 (PDT)
Date:   Wed, 10 Aug 2022 20:28:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660156135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jC9+zzRpG9jGa7Z38m4jyPIwEIqPCOKTMO3d7gOb51Q=;
        b=PsT3rFdq4TXBx6oWprCKpewsOyw3wG4C3uYeND6dhVYv4WaCPev0D5l23GS1dDrzKeRNtr
        Lp3IiNgktHARn0FTvziSIMUuy7Bv63L1oDpRdkr+UpONcoSg7jKqyMuKEHG+I5y9aLdBXp
        UdTzn/dRCE3FdU0tsvNiddhkJjiBDMU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 3/3] arm: pmu: Check for overflow in
 the low counter in chained counters tests
Message-ID: <20220810182850.crt7rvaxfjuzmrej@kamzik>
References: <20220805004139.990531-1-ricarkol@google.com>
 <20220805004139.990531-4-ricarkol@google.com>
 <YvPrMtKkrVc8HhOA@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvPrMtKkrVc8HhOA@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 12:30:26PM -0500, Oliver Upton wrote:
> On Thu, Aug 04, 2022 at 05:41:39PM -0700, Ricardo Koller wrote:
> > A chained event overflowing on the low counter can set the overflow flag
> > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > overflow.
> > 
> > The pmu chain tests fail on bare metal when checking the overflow flag
> > of the low counter _not_ being set on overflow.  Fix by checking for
> > overflow. Note that this test fails in KVM without the respective fix.
> > 
> 
> It'd be good to link out to the respective KVM fix, either by commit or
> lore link if this patch lands before the kernel patches:
> 
> Link: http://lore.kernel.org/r/20220805135813.2102034-1-maz@kernel.org

I'll pick that up with the tags when preparing to push.

Thanks,
drew

> 
> --
> Thanks,
> Oliver
> 
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 33 ++++++++++++++++++---------------
> >  1 file changed, 18 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 12e7d84e..0a7e12f8 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -583,7 +583,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  
> >  	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
> > -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
> > +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #1");
> >  
> >  	/* test 64b overflow */
> >  
> > @@ -595,7 +595,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> >  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> > -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
> > +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
> >  
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> > @@ -603,7 +603,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> >  	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > -	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
> > +	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >  
> >  static void test_chained_sw_incr(void)
> > @@ -629,8 +629,9 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > -	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
> > -		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> > +	report((read_sysreg(pmovsclr_el0) == 0x1) &&
> > +		(read_regn_el0(pmevcntr, 1) == 1),
> > +		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  
> > @@ -648,10 +649,10 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > -	report((read_sysreg(pmovsclr_el0) == 0x2) &&
> > +	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> >  		(read_regn_el0(pmevcntr, 1) == 0) &&
> >  		(read_regn_el0(pmevcntr, 0) == 84),
> > -		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
> > +		"expected overflows and values after 100 SW_INCR/CHAIN");
> >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  }
> > @@ -731,8 +732,9 @@ static void test_chain_promotion(void)
> >  	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> >  		    read_regn_el0(pmevcntr, 0));
> >  
> > -	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> > -		"CHAIN counter enabled: CHAIN counter was incremented and no overflow");
> > +	report((read_regn_el0(pmevcntr, 1) == 1) &&
> > +		(read_sysreg(pmovsclr_el0) == 0x1),
> > +		"CHAIN counter enabled: CHAIN counter was incremented and overflow");
> >  
> >  	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> >  		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> > @@ -759,8 +761,9 @@ static void test_chain_promotion(void)
> >  	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> >  		    read_regn_el0(pmevcntr, 0));
> >  
> > -	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> > -		"32b->64b: CHAIN counter incremented and no overflow");
> > +	report((read_regn_el0(pmevcntr, 1) == 1) &&
> > +		(read_sysreg(pmovsclr_el0) == 0x1),
> > +		"32b->64b: CHAIN counter incremented and overflow");
> >  
> >  	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> >  		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> > @@ -868,8 +871,8 @@ static void test_overflow_interrupt(void)
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	isb();
> >  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > -	report(expect_interrupts(0),
> > -		"no overflow interrupt expected on 32b boundary");
> > +	report(expect_interrupts(0x1),
> > +		"expect overflow interrupt on 32b boundary");
> >  
> >  	/* overflow on odd counter */
> >  	pmu_reset_stats();
> > @@ -877,8 +880,8 @@ static void test_overflow_interrupt(void)
> >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> >  	isb();
> >  	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> > -	report(expect_interrupts(0x2),
> > -		"expect overflow interrupt on odd counter");
> > +	report(expect_interrupts(0x3),
> > +		"expect overflow interrupt on even and odd counter");
> >  }
> >  #endif
> >  
> > -- 
> > 2.37.1.559.g78731f0fdb-goog
> > 
