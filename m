Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D15662AE6
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 17:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjAIQKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 11:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjAIQKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 11:10:40 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD78373BF
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 08:10:40 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c6so10020253pls.4
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 08:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g2v7N0Fv8SASE0T5UxOV5ycouco+YlWoW+IPxm7aMkM=;
        b=PfaIgBdSTG+HBFouOpthI3/H0w4kGhzdaEZ95hUzAaZoF2HGobM23DKJ+UwAoDVvid
         /j9qjzc1qbsb9XWSGWy9KZnPTbPWTQiHrrqfrVgc4xv9SfAWN2w73sJwbJPzBAs67KF9
         zFpl+Z3zUmK65r5fMMzahqCtC43Z63pZtnRgvzXE61aqKqLLgn8jXu0QCveys5Bj/sqZ
         POoUBoWr/D4ienIEyqmpysFrBZ1JdYfypRI039G3DbeRLwRsEiprQFhBKjyHWC2X4yYa
         CNFyvxvTKs9HjFU8me1dFdqPf8TdT31DgoSy8zAGCvu37ZJhYoLOVmYnyp5r+5yuTMFy
         T3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2v7N0Fv8SASE0T5UxOV5ycouco+YlWoW+IPxm7aMkM=;
        b=tHEDwnbAQrUkpvWaOoS38ooq5U7S9wJjNoEaISjTJCXf37O/YImeyW+EFDmx567jtB
         znO1C1sEaXgawkbF40zNiCN2DgAB/JHLgRH3wiFFwdOUTQSNzOI4eiIg2Y6lwazTDtPJ
         TdzCUkaIYi48VakdL1dDIqS+TTwMaJ+TE0703Fh0IUDBHAOKkmjW3ETaizSOiwtIXpMv
         01/kxQurK62hKyLkaxUKcHyTBgeY01wkNhA0DLxVGA+8TFWIkTokCZ5BFZKAfTGYxypE
         maTLwPmWLtVO/8C+3APWBfIsRl+DjPx5OjPuDD7B5LYdPUsMYakqGRdYBpQdeqNR7aVz
         rPyw==
X-Gm-Message-State: AFqh2kqN1M7c1uwfeQDZ9wPnGoHUgBgPY+jSK4XgvsCOzpYPgxCSPKzL
        dzvVneWIMii7FpdAXQXzjK783A==
X-Google-Smtp-Source: AMrXdXvHN/MUj9NHs7OvrMG4XkTL9VZaHYE6/jMHdjLclRCv0e+0Mt4SdMU3pXfdtrAaQNLQfZ8C6w==
X-Received: by 2002:a17:90b:2403:b0:219:f970:5119 with SMTP id nr3-20020a17090b240300b00219f9705119mr591276pjb.1.1673280639423;
        Mon, 09 Jan 2023 08:10:39 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id s88-20020a17090a69e100b002262ab43327sm4337630pjj.26.2023.01.09.08.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:10:39 -0800 (PST)
Date:   Mon, 9 Jan 2023 08:10:35 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y7w8e27/PXbjw153@google.com>
References: <20221220031032.2648701-1-ricarkol@google.com>
 <20221220031032.2648701-2-ricarkol@google.com>
 <Y7h2eQp5oFd/DN7A@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7h2eQp5oFd/DN7A@google.com>
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

On Fri, Jan 06, 2023 at 07:28:57PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Tue, Dec 20, 2022 at 03:10:29AM +0000, Ricardo Koller wrote:
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
> >  arm/pmu.c | 37 +++++++++++++++++++++++++------------
> >  1 file changed, 25 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index cd47b14..1b55e20 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -54,10 +54,13 @@
> >  #define EXT_COMMON_EVENTS_LOW	0x4000
> >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> >  
> > -#define ALL_SET			0xFFFFFFFF
> > -#define ALL_CLEAR		0x0
> > -#define PRE_OVERFLOW		0xFFFFFFF0
> > -#define PRE_OVERFLOW2		0xFFFFFFDC
> > +#define ALL_SET			0x00000000FFFFFFFFULL
> > +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
> > +#define ALL_CLEAR		0x0000000000000000ULL
> > +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> > +
> > +#define ALL_SET_AT(_64b)       (_64b ? ALL_SET_64 : ALL_SET)
> 
> AFAICT, ALL_SET is mostly used to toggle all PMCs in a configuration
> register. 

It's also used as a pre-overflow counter value. And that's mainly the use of
the newly introduced ALL_SET_AT(), and PRE_OVERFLOW_AT(). The ALL_SET_AT()
changes in this commit should be moved to commit 3; I will do that plus use
pmevcntr_mask() instead of ALL_SET_AT():

	uint64_t all_set = pmevcntr_mask();
	...
	/* overflow on odd counter */
	write_regn_el0(pmevcntr, 0, pre_overflow);
	write_regn_el0(pmevcntr, 1, all_set);


> Using it for PMEVCNTR<n> seems a bit odd to me. How about
> introducing a helper for getting the counter mask to avoid the
> open-coded version check?
> 
> static uint64_t pmevcntr_mask(void)
> {
> 	/*
> 	 * Bits [63:0] are always incremented for 64-bit counters,
> 	 * even if the PMU is configured to generate an overflow at
> 	 * bits [31:0]
> 	 *
> 	 * See DDI0487I.a, section D11.3 ("Behavior on overflow") for
> 	 * more details.
> 	 */
> 	if (pmu.version >= ID_DFR0_PMU_V3_8_5)
> 		return ~0;
> 
> 	return (uint32_t)~0;
> }
> 
> I've always found the PMU documentation to be a bit difficult to grok,
> and the above citation only mentions the intended behavior in passing.
> Please feel free to update with a better citation if it exists.
> 
> >  #define PMU_PPI			23
> >  
> > @@ -538,6 +541,7 @@ static void test_mem_access(void)
> >  static void test_sw_incr(void)
> >  {
> >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > +	uint64_t cntr0;
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -572,9 +576,11 @@ static void test_sw_incr(void)
> >  		write_sysreg(0x3, pmswinc_el0);
> >  
> >  	isb();
> > -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> > -	report(read_regn_el0(pmevcntr, 1)  == 100,
> > -		"counter #0 after + 100 SW_INCR");
> > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
> > +		(uint32_t)PRE_OVERFLOW + 100 :
> > +		(uint64_t)PRE_OVERFLOW + 100;
> 
> With the above suggestion, it would be nice to rewrite like so:
> 
> 	cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> 
> If you do go this route, then you'll probably want to drop all the other
> open-coded PMUv3p5 checks in favor of the helper.

Will also use this instead of the uintxx_t casting.

Thanks~
Ricardo

> 
> --
> Thanks,
> Oliver
