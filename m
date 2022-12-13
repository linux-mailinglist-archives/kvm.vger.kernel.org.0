Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E78E64B97E
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 17:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbiLMQVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 11:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbiLMQV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 11:21:29 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D915F21832
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:21:28 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id m4so292586pls.4
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zlg4jQtTs5EuLNxR1ELdH12CmuYqfllwivdJVwCtjuw=;
        b=lOQZM2cRkOQV9eu3fOEAwoxLKc5n4SNmMK3MP05Ja5xj9NG5b1pxTECLZidvka37h7
         +DJmTjavteXmm53OnyLmbfWihFAX4m8q6Lc4WMWBCOna12Sv1B3mnhHDfPLBTaFY+plK
         Hjk0eY3hAczXwmzhMbn0iFw3r4F5gtrLMaEmwyf4ABzSkj9rI185kxhfliPtfIMqW0u9
         rr621Y0MGmZKdAWZCDb96rlBazDoZ5ZBWA1WAGgRoDiRj8WQ0F9HwtnKiTSUWhlZCocw
         B5VXQjAU+EpAR/ud08YWl+zVFjAABdKikLRupPMps+5fl30reHGMpR42MlurlZ7Cg7IN
         viAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zlg4jQtTs5EuLNxR1ELdH12CmuYqfllwivdJVwCtjuw=;
        b=Kq8X3xf/3U7b1FlgftORJnmxCPy9aio2/DxDYOFV83MZYjEZ8YEdoebqrnItmvGvbh
         VnY8NDlk1e4hY7f2HY6a/fQG4vLQhrjQe8GIPiP5IyWFmHtI3KnEBcZnt01uZwZo5OML
         VUBsM2w8g5IeKePLy1Q9w3aF02lbtDOw4JewcL1jDyFRO8WViyzLkrKgg7fLpoc29p5B
         9nrw/Ly7fL6Z/u94xvT4jXdEIANK+eowG+XaIIgZC0/+v/SdEBZtwztCm6ai/LDJW/gi
         GTJ+bn112t236vGvCdJIzETY+ixb7HvtbtDRDjDtLKiGa8wJ1cRcZwMAFNUUvWBLU4kQ
         AYdA==
X-Gm-Message-State: ANoB5pnijs66aZ6kz2P5qWvxsh67aShkMA7TJQrW1J1aixm9sIGJlQGr
        fCbxUoTvJZ8EqqgFifm3hTwCkQ==
X-Google-Smtp-Source: AA0mqf6aeSlyXEwaXbn3pTOChSbpIcNv8DktV7FmrD7qgXDNh6cBqjhL1TE9+H768oBXbr9L3knt0A==
X-Received: by 2002:a17:90b:3685:b0:219:d1eb:b8ad with SMTP id mj5-20020a17090b368500b00219d1ebb8admr323541pjb.2.1670948488141;
        Tue, 13 Dec 2022 08:21:28 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id nd17-20020a17090b4cd100b002135de3013fsm7400198pjb.32.2022.12.13.08.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 08:21:27 -0800 (PST)
Date:   Tue, 13 Dec 2022 08:21:24 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y5imhKUIJceHDUMD@google.com>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-2-ricarkol@google.com>
 <Y5hxvj6p+mCC2DOs@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5hxvj6p+mCC2DOs@monolith.localdoman>
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

On Tue, Dec 13, 2022 at 12:36:14PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> Some more comments below.
> 
> On Fri, Dec 02, 2022 at 04:55:25AM +0000, Ricardo Koller wrote:
> > PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> > for overflowing at 32 or 64-bits. The consequence is that tests that check
> > the counter values after overflowing should not assume that values will be
> > wrapped around 32-bits: they overflow into the other half of the 64-bit
> > counters on PMUv3p5.
> > 
> > Fix tests by correctly checking overflowing-counters against the expected
> > 64-bit value.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 29 ++++++++++++++++++-----------
> >  1 file changed, 18 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index cd47b14..eeac984 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -54,10 +54,10 @@
> >  #define EXT_COMMON_EVENTS_LOW	0x4000
> >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> >  
> > -#define ALL_SET			0xFFFFFFFF
> > -#define ALL_CLEAR		0x0
> > -#define PRE_OVERFLOW		0xFFFFFFF0
> > -#define PRE_OVERFLOW2		0xFFFFFFDC
> > +#define ALL_SET			0x00000000FFFFFFFFULL
> > +#define ALL_CLEAR		0x0000000000000000ULL
> > +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> >  
> >  #define PMU_PPI			23
> >  
> > @@ -538,6 +538,7 @@ static void test_mem_access(void)
> >  static void test_sw_incr(void)
> >  {
> >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > +	uint64_t cntr0;
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -572,9 +573,9 @@ static void test_sw_incr(void)
> >  		write_sysreg(0x3, pmswinc_el0);
> >  
> >  	isb();
> > -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> > -	report(read_regn_el0(pmevcntr, 1)  == 100,
> > -		"counter #0 after + 100 SW_INCR");
> > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> > +	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> > +	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
> >  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  	report(read_sysreg(pmovsclr_el0) == 0x1,
> > @@ -584,6 +585,7 @@ static void test_sw_incr(void)
> >  static void test_chained_counters(void)
> >  {
> >  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> > +	uint64_t cntr1;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> >  		return;
> > @@ -618,13 +620,16 @@ static void test_chained_counters(void)
> >  
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > +	report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
> 
> It looks to me like the intention of the test was to check that the counter
> programmed with the CHAIN event wraps, judging from the report message.
> 

Ah, right. Yeah, that message is confusing. It should be the short
version of "Inrementing at 32-bits resulted in the right value".

> I think it would be interesting to keep that by programming counter #1 with
> ~0ULL when PMUv3p5 (maybe call it ALL_SET64?) and test the counter value
> against 0.

The last commit adds tests using ALL_SET64.  Tests can be run in two
modes: overflow_at_64bits and not.  However, this test,
test_chained_counters(), and all other chained tests only use the
!overflow_at_64bits mode (even after the last commit). The reason is
that there are no CHAIN events when overflowing at 64-bits (more details
in the commit message). But, don't worry, there are lots of tests that
check wrapping at 64-bits (overflow_at_64bits=true).

> Alternatively, the report message can be modified, and "wrapped"
> replaced with "incremented" (or something like that), to avoid confusion.
> 
> > +
> >  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >  
> >  static void test_chained_sw_incr(void)
> >  {
> >  	uint32_t events[] = {SW_INCR, CHAIN};
> > +	uint64_t cntr0, cntr1;
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -665,10 +670,12 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> >  	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> > -		(read_regn_el0(pmevcntr, 1) == 0) &&
> > -		(read_regn_el0(pmevcntr, 0) == 84),
> > -		"expected overflows and values after 100 SW_INCR/CHAIN");
> > +	       (read_regn_el0(pmevcntr, 1) == cntr0) &&
> > +	       (read_regn_el0(pmevcntr, 0) == cntr1),
> 
> This is hard to parse, it would be better if counter 0 is compared against
> cntr0 and counter 1 against cntr1.

Ah, yes, code is correct but that's indeed confusing.

> 
> Also, same suggestion here, looks like the test wants to check that the
> odd-numbered counter wraps around when counting the CHAIN event.

Ack. Will update for v2.

Thanks!
Ricardo

> 
> Thanks,
> Alex
> 
> > +	       "expected overflows and values after 100 SW_INCR/CHAIN");
> >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  }
> > -- 
> > 2.39.0.rc0.267.gcb52ba06e7-goog
> > 
