Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C135F669C0F
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjAMP2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 10:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjAMP1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 10:27:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20131820D0
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 07:20:36 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so27304290pjk.3
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 07:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7K8Qtvg+PQqIWEKc8EhPcT6ys1Mcufoxj2dK/duaTvw=;
        b=ZvVkZqcT4KCZ/TmzXW6mk7bDTidf3LDTwbWEfsu/TGg2h5b7XA4j4xwgn8kOIF/v1r
         m4Mj/4A45Y4FKdoEh9z4BC3u9PfTBDOxMwc43cWOo6K6nF+mbOGiLc+FMEM4mhxRn/Od
         pmYPfULHqISs6/mMgHye2uyBIjNm4fB2N2bZgMaU0FKHPt+pO02F/rDbxCdYtpubsRwH
         Y9B1dhNtgaxa48/lccVOCJEiLXp0P3VSyhR3I180DwGpa2Slgw8J8eRWKf4j7wDcwHVU
         GcP5bKV28HXXnWntYvH3LFYE/U2+G8Mv9mHJobsbIEK6/5q5zHDT3sSpzRtVCiy0Jo6j
         1LsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7K8Qtvg+PQqIWEKc8EhPcT6ys1Mcufoxj2dK/duaTvw=;
        b=KbpNXZ8h9KJrlFhRf7JorlM/s083SnY8lXwLOuTMlaYiRFS7le8aqqbE0xIXHQdVx0
         F3obWv5xrlz4jjUMtg2CI7+nU+b/pLGXYGtCvmaY9Y/7Vmd5lRfUpDE81V1560Pa8XBK
         +LF97neqQchmpqGqjtecmy6gDeQeV6apG+C53rZ2i0646A4eepTcLhawZVmDJneT78X1
         WpClBSgvOYNQbuRrPzxcz74agPuQ4ibGlfc+fLoH6MK39VcTU5KNpSZ2sigbUa5JSHI5
         Jf5mwf7P6X4QMliKq3/GuntXFKgthlsOc2evo/EG56w3ITIg2K3WDgFU4yFzPYQ95asS
         tQyQ==
X-Gm-Message-State: AFqh2krwCq4XWHQm0A9rkulHp818jRIYHW9VAfIHj1dDoAd5ROse9PuI
        WSa91PGHh7pIE0g5etdHPAJ9oyEAi9kWJk4i
X-Google-Smtp-Source: AMrXdXvA4PYuP9HsdBbZhKuaxXBmadah71jXjogwnYfebbPa8BCNmxR2KIGYzPNWs193D/2MfcwRnQ==
X-Received: by 2002:a17:90a:9503:b0:227:679:17df with SMTP id t3-20020a17090a950300b00227067917dfmr1357919pjo.0.1673623235414;
        Fri, 13 Jan 2023 07:20:35 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id l15-20020a170902f68f00b0017f592a7eccsm14174163plg.298.2023.01.13.07.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 07:20:35 -0800 (PST)
Date:   Fri, 13 Jan 2023 07:20:31 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev
Subject: Re: [kvm-unit-tests PATCH v3 2/4] arm: pmu: Prepare for testing
 64-bit overflows
Message-ID: <Y8F2v8NbMERMqx0E@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-3-ricarkol@google.com>
 <CAAeT=Fz1PHytw2rhn7pxbr1aFuvWLTJGnr9vidUqNt=tCKpvuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fz1PHytw2rhn7pxbr1aFuvWLTJGnr9vidUqNt=tCKpvuw@mail.gmail.com>
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

On Wed, Jan 11, 2023 at 09:56:45PM -0800, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > PMUv3p5 adds a knob, PMCR_EL0.LP == 1, that allows overflowing at 64-bits
> > instead of 32. Prepare by doing these 3 things:
> >
> > 1. Add a "bool overflow_at_64bits" argument to all tests checking
> >    overflows.
> > 2. Extend satisfy_prerequisites() to check if the machine supports
> >    "overflow_at_64bits".
> > 3. Refactor the test invocations to use the new "run_test()" which adds a
> >    report prefix indicating whether the test uses 64 or 32-bit overflows.
> >
> > A subsequent commit will actually add the 64-bit overflow tests.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 92 ++++++++++++++++++++++++++++++++-----------------------
> >  1 file changed, 53 insertions(+), 39 deletions(-)
> >
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 7f0794d..0d06b59 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -164,13 +164,13 @@ static void pmu_reset(void)
> >  /* event counter tests only implemented for aarch64 */
> >  static void test_event_introspection(void) {}
> >  static void test_event_counter_config(void) {}
> > -static void test_basic_event_count(void) {}
> > -static void test_mem_access(void) {}
> > -static void test_sw_incr(void) {}
> > -static void test_chained_counters(void) {}
> > -static void test_chained_sw_incr(void) {}
> > -static void test_chain_promotion(void) {}
> > -static void test_overflow_interrupt(void) {}
> > +static void test_basic_event_count(bool overflow_at_64bits) {}
> > +static void test_mem_access(bool overflow_at_64bits) {}
> > +static void test_sw_incr(bool overflow_at_64bits) {}
> > +static void test_chained_counters(bool unused) {}
> > +static void test_chained_sw_incr(bool unused) {}
> > +static void test_chain_promotion(bool unused) {}
> > +static void test_overflow_interrupt(bool overflow_at_64bits) {}
> >
> >  #elif defined(__aarch64__)
> >  #define ID_AA64DFR0_PERFMON_SHIFT 8
> > @@ -416,6 +416,7 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
> >                         return false;
> >                 }
> >         }
> > +
> 
> Nit: Unnecessary addition of the line.
> 
> >         return true;
> >  }
> >
> > @@ -435,13 +436,24 @@ static uint64_t pmevcntr_mask(void)
> >         return (uint32_t)~0;
> >  }
> >
> > -static void test_basic_event_count(void)
> > +static bool check_overflow_prerequisites(bool overflow_at_64bits)
> > +{
> > +       if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
> > +               report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
> > +               return false;
> > +       }
> > +
> > +       return true;
> > +}
> > +
> > +static void test_basic_event_count(bool overflow_at_64bits)
> >  {
> >         uint32_t implemented_counter_mask, non_implemented_counter_mask;
> >         uint32_t counter_mask;
> >         uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
> >
> > -       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > +       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > +           !check_overflow_prerequisites(overflow_at_64bits))
> >                 return;
> >
> >         implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
> > @@ -515,12 +527,13 @@ static void test_basic_event_count(void)
> >                 "check overflow happened on #0 only");
> >  }
> >
> > -static void test_mem_access(void)
> > +static void test_mem_access(bool overflow_at_64bits)
> >  {
> >         void *addr = malloc(PAGE_SIZE);
> >         uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
> >
> > -       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > +       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > +           !check_overflow_prerequisites(overflow_at_64bits))
> >                 return;
> >
> >         pmu_reset();
> > @@ -551,13 +564,14 @@ static void test_mem_access(void)
> >                         read_sysreg(pmovsclr_el0));
> >  }
> >
> > -static void test_sw_incr(void)
> > +static void test_sw_incr(bool overflow_at_64bits)
> >  {
> >         uint32_t events[] = {SW_INCR, SW_INCR};
> >         uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> >         int i;
> >
> > -       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > +       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > +           !check_overflow_prerequisites(overflow_at_64bits))
> >                 return;
> >
> >         pmu_reset();
> > @@ -597,7 +611,7 @@ static void test_sw_incr(void)
> >                 "overflow on counter #0 after 100 SW_INCR");
> >  }
> >
> > -static void test_chained_counters(void)
> > +static void test_chained_counters(bool unused)
> >  {
> >         uint32_t events[] = {CPU_CYCLES, CHAIN};
> >
> > @@ -638,7 +652,7 @@ static void test_chained_counters(void)
> >         report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >
> > -static void test_chained_sw_incr(void)
> > +static void test_chained_sw_incr(bool unused)
> >  {
> >         uint32_t events[] = {SW_INCR, CHAIN};
> >         uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> > @@ -691,7 +705,7 @@ static void test_chained_sw_incr(void)
> >                     read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  }
> >
> > -static void test_chain_promotion(void)
> > +static void test_chain_promotion(bool unused)
> >  {
> >         uint32_t events[] = {MEM_ACCESS, CHAIN};
> >         void *addr = malloc(PAGE_SIZE);
> > @@ -840,13 +854,14 @@ static bool expect_interrupts(uint32_t bitmap)
> >         return true;
> >  }
> >
> > -static void test_overflow_interrupt(void)
> > +static void test_overflow_interrupt(bool overflow_at_64bits)
> >  {
> >         uint32_t events[] = {MEM_ACCESS, SW_INCR};
> >         void *addr = malloc(PAGE_SIZE);
> >         int i;
> >
> > -       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > +       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > +           !check_overflow_prerequisites(overflow_at_64bits))
> >                 return;
> >
> >         gic_enable_defaults();
> > @@ -1070,6 +1085,19 @@ static bool pmu_probe(void)
> >         return true;
> >  }
> >
> > +static void run_test(char *name, void (*test)(bool), bool overflow_at_64bits)
> > +{
> > +       const char *prefix = overflow_at_64bits ? "64-bit overflows" : "32-bit overflows";
> > +
> > +       report_prefix_push(name);
> > +       report_prefix_push(prefix);
> > +
> > +       test(overflow_at_64bits);
> > +
> > +       report_prefix_pop();
> > +       report_prefix_pop();
> > +}
> > +
> >  int main(int argc, char *argv[])
> >  {
> >         int cpi = 0;
> > @@ -1102,33 +1130,19 @@ int main(int argc, char *argv[])
> >                 test_event_counter_config();
> >                 report_prefix_pop();
> >         } else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
> > -               report_prefix_push(argv[1]);
> > -               test_basic_event_count();
> > -               report_prefix_pop();
> > +               run_test(argv[1], test_basic_event_count, false);
> >         } else if (strcmp(argv[1], "pmu-mem-access") == 0) {
> > -               report_prefix_push(argv[1]);
> > -               test_mem_access();
> > -               report_prefix_pop();
> > +               run_test(argv[1], test_mem_access, false);
> >         } else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
> > -               report_prefix_push(argv[1]);
> > -               test_sw_incr();
> > -               report_prefix_pop();
> > +               run_test(argv[1], test_sw_incr, false);
> >         } else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
> > -               report_prefix_push(argv[1]);
> > -               test_chained_counters();
> > -               report_prefix_pop();
> > +               run_test(argv[1], test_chained_counters, false);
> >         } else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> > -               report_prefix_push(argv[1]);
> > -               test_chained_sw_incr();
> > -               report_prefix_pop();
> > +               run_test(argv[1], test_chained_sw_incr, false);
> >         } else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
> > -               report_prefix_push(argv[1]);
> > -               test_chain_promotion();
> > -               report_prefix_pop();
> > +               run_test(argv[1], test_chain_promotion, false);
> >         } else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
> > -               report_prefix_push(argv[1]);
> > -               test_overflow_interrupt();
> > -               report_prefix_pop();
> > +               run_test(argv[1], test_overflow_interrupt, false);
> >         } else {
> >                 report_abort("Unknown sub-test '%s'", argv[1]);
> >         }
> 
> Perhaps it might be useful to generalize run_test() a bit more so that it
> can be used for other existing test cases as well ?

Good idea, that's much better. Will send a v4 with this sugestion.

> (e.g. "pmu-event-counter-config", etc)
> ---
> i.e (The following are not all of the changes though).
> 
> -static void run_test(char *name, void (*test)(bool), bool overflow_at_64bits)
> +static void run_test(const char *name, const char *prefix, void
> (*test)(bool), void *arg)
>  {
> -       const char *prefix = overflow_at_64bits ? "64-bit overflows" :
> "32-bit overflows";
> -
>         report_prefix_push(name);
>         report_prefix_push(prefix);
> 
> -       test(overflow_at_64bits);
> +       test(arg);
> 
>         report_prefix_pop();
>         report_prefix_pop();
>  }
> 
> +static void run_event_test(char *name, void (*test)(bool), bool
> overflow_at_64bits)
> +{
> +       const char *prefix = overflow_at_64bits ? "64-bit overflows" :
> "32-bit overflows";
> +
> +       run_test(name, prefix, test, (void *)overflow_at_64bits);
> +}
> ---
> 
> Having said that, the patch already improves the code,
> and I don't see any issue.
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> 
> Thank you,
> Reiji
