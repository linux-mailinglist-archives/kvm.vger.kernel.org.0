Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB28657BF83
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 23:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiGTVVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 17:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiGTVVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 17:21:04 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29F84D4C5
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:21:03 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w185so17605333pfb.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nETyZes6r+WdTkVJmCqdkDrl1X+qF+WpOLPfuydDKY8=;
        b=Qw9fnyif/telTEQCY2VpLgCg9Q7ckWB0iPYTwQogaBB300de+or1r+oCWaZsNTtlmM
         96fWLzLb8pz5+fV5ZPj8qZw5GwOJBRce9RdjVU5P5/xDV5pJ9vTT1TJsvH6DU/Sk4RWI
         CVA/GYc7BbZsffDmACXZ91Awy3NiL/t7oPfgmaYGOdf+BBHFPlll1qcn3j23U1qi5QLV
         F9KwBUuFzSxQ7CJe1J6eHI8jfx53e9zgqXdPl1vS2owxJcW18TgDly9Ox6R1rdQlp2fc
         Cj2EXCcbLdGffMVRikafFTelWUX79IBOlMv9CMe+3PgNh5C/RU0FcfAcGLG+B1pyXjTX
         IB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nETyZes6r+WdTkVJmCqdkDrl1X+qF+WpOLPfuydDKY8=;
        b=azhrA2peLGTvUa+2tVb1g4Sbxp90SK8q8MxYh5OT8cczbbOzfoMyriimhTwgggZVzf
         iKaKc9Vw8BgkyJz74gy6Vo3xJ5dMCFQM9T+Zmn7U6bGbl3uRh9+ETXJHgIO8zcF1q9pT
         ZVmJoUOol/hisKhgit44c/sKCSVWEDLj4LqftKnN2x8O6Dv/qYiKZxx2uW++NJzO0Mf+
         zLXcUuNj0/WHcbvens+A8BRv9sg1RyP9neSuQqHzlPjV4w+it1JKRI1YvNi6yVQRmaO3
         qWtXktMwqI40cS+a14KYzH4DGewRpQsIxZBsJVml/eXu1iUOoOPB9BosFFRpnoCgalOh
         YEgw==
X-Gm-Message-State: AJIora+GbfMtRINuytGmYGlwesaIwqO8MJDKa4eEF5jeHyMKLdKqn7Z8
        XMFTPIrftv3zOFWSVn/DmA/fnA==
X-Google-Smtp-Source: AGRyM1vu3nT98pOKmBmQ0Vagol839niHDAst1eMkt1TOrXj71moRImGgoRNuZw3N1jS75gy9Pt6TWQ==
X-Received: by 2002:a63:4604:0:b0:40d:a0ec:5dc4 with SMTP id t4-20020a634604000000b0040da0ec5dc4mr35503558pga.510.1658352063143;
        Wed, 20 Jul 2022 14:21:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id 12-20020a630c4c000000b0040dd052ab11sm12094688pgm.58.2022.07.20.14.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 14:21:02 -0700 (PDT)
Date:   Wed, 20 Jul 2022 14:20:58 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Add missing isb()'s after
 sys register writing
Message-ID: <YthxunT37Sxt/Nei@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-2-ricarkol@google.com>
 <YtaSDhj2SXEzh8QI@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtaSDhj2SXEzh8QI@monolith.localdoman>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19, 2022 at 12:14:37PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> Since you're touching the PMU tests, I took the liberty to suggest changes
> somewhat related to this patch. If you don't want to implement them, let me
> know and I'll try to make a patch/series out of them.
> 
> On Mon, Jul 18, 2022 at 08:49:08AM -0700, Ricardo Koller wrote:
> > There are various pmu tests that require an isb() between enabling
> > counting and the actual counting. This can lead to count registers
> > reporting less events than expected; the actual enabling happens after
> > some events have happened.  For example, some missing isb()'s in the
> > pmu-sw-incr test lead to the following errors on bare-metal:
> > 
> > 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
> >         PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
> >         FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
> >         FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
> >         INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
> >         PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
> >         SUMMARY: 4 tests, 2 unexpected failures
> > 
> > Add the missing isb()'s on all failing tests, plus some others that are
> > not currently required but might in the future (like an isb() after
> > clearing the overflow signal in the IRQ handler).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 15c542a2..fd838392 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -307,6 +307,7 @@ static void irq_handler(struct pt_regs *regs)
> >  			}
> >  		}
> >  		write_sysreg(ALL_SET, pmovsclr_el0);
> > +		isb();
> >  	} else {
> >  		pmu_stats.unexpected = true;
> >  	}
> > @@ -534,6 +535,7 @@ static void test_sw_incr(void)
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x1, pmswinc_el0);
> > @@ -547,6 +549,7 @@ static void test_sw_incr(void)
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x3, pmswinc_el0);
> > @@ -618,6 +621,8 @@ static void test_chained_sw_incr(void)
> >  
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> > +
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> > @@ -634,6 +639,8 @@ static void test_chained_sw_incr(void)
> >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> > +
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> > @@ -821,6 +828,8 @@ static void test_overflow_interrupt(void)
> >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> >  
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> > +
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x2, pmswinc_el0);
> 
> You missed the set_pmcr(pmu.pmcr_ro) call on the next line.

Will add this in V2.

> 
> Also the comment "enable interrupts" below:
> 
> [..]
>         report(expect_interrupts(0), "no overflow interrupt after preset");
> 
>         set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>         for (i = 0; i < 100; i++)
>                 write_sysreg(0x2, pmswinc_el0);
> 
>         set_pmcr(pmu.pmcr_ro);
>         report(expect_interrupts(0), "no overflow interrupt after counting");
> 
>         /* enable interrupts */
> 
>         pmu_reset_stats();
> [..]
> 
> is misleading, because pmu_reset_stats() doesn't enable the PMU. Unless the
> intention was to call pmu_reset(), in which case the comment is correct and
> the code is wrong. My guess is that the comment is incorrect, the test
> seems to be working fine when the PMU is enabled in the mem_access_loop()
> call.

Yes, it seems that the comment is incorrect. Will fix this in V2.

> 
> >  
> > @@ -879,6 +888,7 @@ static bool check_cycles_increase(void)
> >  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> >  
> >  	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
> > +	isb();
> >  
> >  	for (int i = 0; i < NR_SAMPLES; i++) {
> >  		uint64_t a, b;
> > @@ -894,6 +904,7 @@ static bool check_cycles_increase(void)
> >  	}
> >  
> >  	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
> > +	isb();
> 
> Those look good to me.
> 
> Thanks,
> Alex

Thanks for the reviews,
Ricardo

> 
> >  
> >  	return success;
> >  }
> > -- 
> > 2.37.0.170.g444d1eabd0-goog
> > 
