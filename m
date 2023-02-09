Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310B6690C50
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 15:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjBIO7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 09:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBIO7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 09:59:17 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8B518148
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 06:59:16 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id i1so1481564qvo.9
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 06:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=enXepIK1TxuVVTxdvoBrFqlHMmgJSEONjriFyLc0Erc=;
        b=dxfaJlQ0WprHoxZXNo4Z0qZDrHPfx+rheIO1FgS2yv8VDpzjhG8/OcTML637JTy3Wt
         HzdVFILRdyve0nfJ9HpM88Fqt+ouKz5QPFiJ4VStNgS/nFKXqta8E6iTImcLPs+Reh6b
         QxeUtc9nuxKqbEl3nfN24pnljPshlc4LdZU4x+VWO6aK0MuuLyNoLOBwENyv1FHKbuzE
         HU/p9mV2ABfzyRCqh+Jj6zxZu5BqY7+W9JgOCQM21y2li6ip1HDWggeVTtIFGMYbmCXK
         Hwq01hBdC0TCU0NRPZ3wXlNWxMVP5yeoJAzj3WeLEpE2/eApbOrcVF2mcWMsG/mV2IdO
         bboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=enXepIK1TxuVVTxdvoBrFqlHMmgJSEONjriFyLc0Erc=;
        b=RDwM6idI+gqJ8bOmvKlXqZ2CI53fL6sxBZ30y4nE+5o3+Dw9r2H3PhvVdmgpVdgQme
         dsv3k+WFq/PF/1RtDg56KMXoYpmn312wZZWB/nVtsSPaMZAiL91DV1HjrmEq6Wgd60Rp
         h3nAH21qRrnZwuPBQ64HjmCI7f4vVAti2lLwLs33efKXZdjPuBhQgEjrMn8ZPn/4OkcE
         xcKvybXSGxfKj8nAaRD3WfkBPWBAx/Xj6Sw9/UnkNHyG/GDhx+W1YfZVu048LMywQQq6
         CirjOdhXy8LIFt2NgsBkJjF5vKNSsWbq13H4A9pgEMwQcxem/ewv/dzgJ+q5hIq33wvU
         4NXA==
X-Gm-Message-State: AO0yUKWjaDy3kvqXPUdWE44vO/vgCCzIktLInVhstIsguD4XDhnBiMu9
        0Q7+x66NF60oTEtWWCG+dOu/Gd+SUNoR1c+J89LhFQ==
X-Google-Smtp-Source: AK7set9YBn00AUBBW5+UE0rCednnLjgrfinrFi7T3Fj6eZYgDYk0W6xK87HKNY8nGwTGhG+KaPovOjyZXNAY8Yp+Q+A=
X-Received: by 2002:a0c:f20e:0:b0:56c:25fe:d37c with SMTP id
 h14-20020a0cf20e000000b0056c25fed37cmr158051qvk.3.1675954755436; Thu, 09 Feb
 2023 06:59:15 -0800 (PST)
MIME-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com> <20230126165351.2561582-3-ricarkol@google.com>
 <e119c970-8c3f-5d24-08a0-9dfb44fe4679@redhat.com>
In-Reply-To: <e119c970-8c3f-5d24-08a0-9dfb44fe4679@redhat.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 9 Feb 2023 06:59:05 -0800
Message-ID: <CAOHnOry8qWvQi-HHJ3Vx1Yz7ZEBArnZwP6WO6hD8iOZuKwFHDg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/6] arm: pmu: Prepare for testing
 64-bit overflows
To:     eric.auger@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, reijiw@google.com
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Feb 7, 2023 at 7:46 AM Eric Auger <eric.auger@redhat.com> wrote:
>
> Hi Ricardo,
>
> On 1/26/23 17:53, Ricardo Koller wrote:
> > PMUv3p5 adds a knob, PMCR_EL0.LP == 1, that allows overflowing at 64-bits
> > instead of 32. Prepare by doing these 3 things:
> >
> > 1. Add a "bool overflow_at_64bits" argument to all tests checking
> >    overflows.
> Actually test_chained_sw_incr() and test_chained_counters() also test
> overflows but they feature CHAIN events. I guess that's why you don't
> need the LP flag. Just tweek the commit msg if you need to respin.
> > 2. Extend satisfy_prerequisites() to check if the machine supports
> >    "overflow_at_64bits".
> > 3. Refactor the test invocations to use the new "run_test()" which adds a
> >    report prefix indicating whether the test uses 64 or 32-bit overflows.
> >
> > A subsequent commit will actually add the 64-bit overflow tests.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks for the reviews, I'll respin the series with the changes you suggest.

Thanks,
Ricardo

>
> Thanks
>
> Eric
>
> > ---
> >  arm/pmu.c | 99 +++++++++++++++++++++++++++++++++----------------------
> >  1 file changed, 60 insertions(+), 39 deletions(-)
> >
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 7f0794d..06cbd73 100644
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
> > @@ -435,13 +435,24 @@ static uint64_t pmevcntr_mask(void)
> >       return (uint32_t)~0;
> >  }
> >
> > -static void test_basic_event_count(void)
> > +static bool check_overflow_prerequisites(bool overflow_at_64bits)
> > +{
> > +     if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
> > +             report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
> > +             return false;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +static void test_basic_event_count(bool overflow_at_64bits)
> >  {
> >       uint32_t implemented_counter_mask, non_implemented_counter_mask;
> >       uint32_t counter_mask;
> >       uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
> >
> > -     if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > +     if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > +         !check_overflow_prerequisites(overflow_at_64bits))
> >               return;
> >
> >       implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
> > @@ -515,12 +526,13 @@ static void test_basic_event_count(void)
> >               "check overflow happened on #0 only");
> >  }
> >
> > -static void test_mem_access(void)
> > +static void test_mem_access(bool overflow_at_64bits)
> >  {
> >       void *addr = malloc(PAGE_SIZE);
> >       uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
> >
> > -     if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > +     if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > +         !check_overflow_prerequisites(overflow_at_64bits))
> >               return;
> >
> >       pmu_reset();
> > @@ -551,13 +563,14 @@ static void test_mem_access(void)
> >                       read_sysreg(pmovsclr_el0));
> >  }
> >
> > -static void test_sw_incr(void)
> > +static void test_sw_incr(bool overflow_at_64bits)
> >  {
> >       uint32_t events[] = {SW_INCR, SW_INCR};
> >       uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> >       int i;
> >
> > -     if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > +     if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > +         !check_overflow_prerequisites(overflow_at_64bits))
> >               return;
> >
> >       pmu_reset();
> > @@ -597,7 +610,7 @@ static void test_sw_incr(void)
> >               "overflow on counter #0 after 100 SW_INCR");
> >  }
> >
> > -static void test_chained_counters(void)
> > +static void test_chained_counters(bool unused)
> >  {
> >       uint32_t events[] = {CPU_CYCLES, CHAIN};
> >
> > @@ -638,7 +651,7 @@ static void test_chained_counters(void)
> >       report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >
> > -static void test_chained_sw_incr(void)
> > +static void test_chained_sw_incr(bool unused)
> >  {
> >       uint32_t events[] = {SW_INCR, CHAIN};
> >       uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> > @@ -691,7 +704,7 @@ static void test_chained_sw_incr(void)
> >                   read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  }
> >
> > -static void test_chain_promotion(void)
> > +static void test_chain_promotion(bool unused)
> >  {
> >       uint32_t events[] = {MEM_ACCESS, CHAIN};
> >       void *addr = malloc(PAGE_SIZE);
> > @@ -840,13 +853,14 @@ static bool expect_interrupts(uint32_t bitmap)
> >       return true;
> >  }
> >
> > -static void test_overflow_interrupt(void)
> > +static void test_overflow_interrupt(bool overflow_at_64bits)
> >  {
> >       uint32_t events[] = {MEM_ACCESS, SW_INCR};
> >       void *addr = malloc(PAGE_SIZE);
> >       int i;
> >
> > -     if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > +     if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > +         !check_overflow_prerequisites(overflow_at_64bits))
> >               return;
> >
> >       gic_enable_defaults();
> > @@ -1070,6 +1084,27 @@ static bool pmu_probe(void)
> >       return true;
> >  }
> >
> > +static void run_test(const char *name, const char *prefix,
> > +                  void (*test)(bool), void *arg)
> > +{
> > +     report_prefix_push(name);
> > +     report_prefix_push(prefix);
> > +
> > +     test(arg);
> > +
> > +     report_prefix_pop();
> > +     report_prefix_pop();
> > +}
> > +
> > +static void run_event_test(char *name, void (*test)(bool),
> > +                        bool overflow_at_64bits)
> > +{
> > +     const char *prefix = overflow_at_64bits ? "64-bit overflows"
> > +                                             : "32-bit overflows";
> > +
> > +     run_test(name, prefix, test, (void *)overflow_at_64bits);
> > +}
> > +
> >  int main(int argc, char *argv[])
> >  {
> >       int cpi = 0;
> > @@ -1102,33 +1137,19 @@ int main(int argc, char *argv[])
> >               test_event_counter_config();
> >               report_prefix_pop();
> >       } else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
> > -             report_prefix_push(argv[1]);
> > -             test_basic_event_count();
> > -             report_prefix_pop();
> > +             run_event_test(argv[1], test_basic_event_count, false);
> >       } else if (strcmp(argv[1], "pmu-mem-access") == 0) {
> > -             report_prefix_push(argv[1]);
> > -             test_mem_access();
> > -             report_prefix_pop();
> > +             run_event_test(argv[1], test_mem_access, false);
> >       } else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
> > -             report_prefix_push(argv[1]);
> > -             test_sw_incr();
> > -             report_prefix_pop();
> > +             run_event_test(argv[1], test_sw_incr, false);
> >       } else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
> > -             report_prefix_push(argv[1]);
> > -             test_chained_counters();
> > -             report_prefix_pop();
> > +             run_event_test(argv[1], test_chained_counters, false);
> >       } else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> > -             report_prefix_push(argv[1]);
> > -             test_chained_sw_incr();
> > -             report_prefix_pop();
> > +             run_event_test(argv[1], test_chained_sw_incr, false);
> >       } else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
> > -             report_prefix_push(argv[1]);
> > -             test_chain_promotion();
> > -             report_prefix_pop();
> > +             run_event_test(argv[1], test_chain_promotion, false);
> >       } else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
> > -             report_prefix_push(argv[1]);
> > -             test_overflow_interrupt();
> > -             report_prefix_pop();
> > +             run_event_test(argv[1], test_overflow_interrupt, false);
> >       } else {
> >               report_abort("Unknown sub-test '%s'", argv[1]);
> >       }
>
