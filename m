Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F68673174
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 06:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjASF7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 00:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjASF66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 00:58:58 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9807818B12
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 21:58:56 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g205so692947pfb.6
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 21:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JbVMnqUlIZgwpFUhBO/Bav1hYnoypeCQfNbPaXGsQX4=;
        b=TB/tmy9tc8qQAyic8f7WOB0ZVtkf3j6lATCYF/kET4SuzhcBa2wF2cysSHGuhlZQjs
         fOifCbhFeRdQpiG2HSPZbklTtG3+Rf4q60EKRIOcqlbKRlm6EKTGnjH91OZniECo+UlR
         6rjjRkC+gy81qTA4aVUjCj0lNnJWGGq9KKaSIlN2OIbHjlzl2H9qUnglFsZP4EPUZxKS
         rsgi3ERLGGKalCiPP1JA7pwim3LcMSPEDsHvP2HziBcR/OVSAKqo8O/LQpSRZqgGighH
         Jv4t/51iZJ2lrYZugVNU4U0N8x7yg8eEyiL4ZIse0GVCKaMBqn0eIVTa3L6gH9PXAmkw
         PuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JbVMnqUlIZgwpFUhBO/Bav1hYnoypeCQfNbPaXGsQX4=;
        b=jon3fTvVnyqJiu+yF+kuyKWZMhfXl5h3Nc53ttSarAKkBfjeuqf1FGDeOms+k9fsNu
         BIzGlybJzLlI+oJdgNTVyAC1Ye2mDS3M1RlRWpYzmqh97df+Cw30WE3cBrcJCgMxb+XY
         C/bcdBG2Mq3F4lkk8kCIl1talrinQjJBS88ofe2Bs2mCIUvzMOC/mI/K7BmB5Zs1oO4U
         JIVouJEdX3vH3Zw/UwW0cahSgOVkNUEHoYzyM0HRv7BNXdlb0FJ1c2DaWLiJ6jIyFJu/
         /KTWDXCE8VzBYp82lQF5lVxazXNHpuqlkE1BuaksYduVWDRwrAVBqs1EqRLf/teyy8CZ
         BUug==
X-Gm-Message-State: AFqh2krqZNx/ZSuwj32b4fk/F8zwzs6GI04stGrccvwYxPTmSmot8Xcx
        3KpDwuyaY2/7IIzOqFEuWkMirosmRgqX//ZEDQUq5w==
X-Google-Smtp-Source: AMrXdXutlwhX+7hle/4xEnH+H7o8kZXjptYKN2/7q+nDzqngyXgl5UmnwyN8prK5LlYj4IhRodyXhhXvzajHDNNRs7M=
X-Received: by 2002:a05:6a00:9aa:b0:576:a748:8fa3 with SMTP id
 u42-20020a056a0009aa00b00576a7488fa3mr1000265pfg.37.1674107935747; Wed, 18
 Jan 2023 21:58:55 -0800 (PST)
MIME-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com> <20230109211754.67144-4-ricarkol@google.com>
In-Reply-To: <20230109211754.67144-4-ricarkol@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 18 Jan 2023 21:58:38 -0800
Message-ID: <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit overflows
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev
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

Hi Ricardo,

On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
> and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
> supported on PMUv3p5.
>
> Note that chained tests do not implement "overflow_at_64bits == true".
> That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
> details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
> 0487H.a, J1.1.1 "aarch64/debug").
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

I have a few nits below.

> ---
>  arm/pmu.c | 116 +++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 75 insertions(+), 41 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 0d06b59..72d0f50 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -28,6 +28,7 @@
>  #define PMU_PMCR_X         (1 << 4)
>  #define PMU_PMCR_DP        (1 << 5)
>  #define PMU_PMCR_LC        (1 << 6)
> +#define PMU_PMCR_LP        (1 << 7)
>  #define PMU_PMCR_N_SHIFT   11
>  #define PMU_PMCR_N_MASK    0x1f
>  #define PMU_PMCR_ID_SHIFT  16
> @@ -56,9 +57,13 @@
>
>  #define ALL_SET                        0x00000000FFFFFFFFULL

Nit: Perhaps renaming this to ALL_SET_32 might be more clear.
Since the test is now aware of 64 bit counters, the name 'ALL_SET'
makes me think that all 64 bits are set.

>  #define ALL_CLEAR              0x0000000000000000ULL
> -#define PRE_OVERFLOW           0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW_32                0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW_64                0xFFFFFFFFFFFFFFF0ULL
>  #define PRE_OVERFLOW2          0x00000000FFFFFFDCULL
>
> +#define PRE_OVERFLOW(__overflow_at_64bits)                             \
> +       (__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
> +
>  #define PMU_PPI                        23
>
>  struct pmu {
> @@ -449,8 +454,10 @@ static bool check_overflow_prerequisites(bool overflow_at_64bits)
>  static void test_basic_event_count(bool overflow_at_64bits)
>  {
>         uint32_t implemented_counter_mask, non_implemented_counter_mask;
> -       uint32_t counter_mask;
> +       uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +       uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>         uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
> +       uint32_t counter_mask;
>
>         if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>             !check_overflow_prerequisites(overflow_at_64bits))
> @@ -472,13 +479,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
>          * clear cycle and all event counters and allow counter enablement
>          * through PMCNTENSET. LC is RES1.
>          */
> -       set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> +       set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
>         isb();
> -       report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
> +       report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
>
>         /* Preset counter #0 to pre overflow value to trigger an overflow */
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -       report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> +       write_regn_el0(pmevcntr, 0, pre_overflow);
> +       report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>                 "counter #0 preset to pre-overflow value");
>         report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
>
> @@ -531,6 +538,8 @@ static void test_mem_access(bool overflow_at_64bits)
>  {
>         void *addr = malloc(PAGE_SIZE);
>         uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
> +       uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +       uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>
>         if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>             !check_overflow_prerequisites(overflow_at_64bits))
> @@ -542,7 +551,7 @@ static void test_mem_access(bool overflow_at_64bits)
>         write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
>         isb();
> -       mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +       mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>         report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
>         report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
>         /* We may measure more than 20 mem access depending on the core */
> @@ -552,11 +561,11 @@ static void test_mem_access(bool overflow_at_64bits)
>
>         pmu_reset();
>
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, pre_overflow);
> +       write_regn_el0(pmevcntr, 1, pre_overflow);
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
>         isb();
> -       mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +       mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>         report(read_sysreg(pmovsclr_el0) == 0x3,
>                "Ran 20 mem accesses with expected overflows on both counters");
>         report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
> @@ -566,8 +575,10 @@ static void test_mem_access(bool overflow_at_64bits)
>
>  static void test_sw_incr(bool overflow_at_64bits)
>  {
> +       uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +       uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>         uint32_t events[] = {SW_INCR, SW_INCR};
> -       uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> +       uint64_t cntr0 = (pre_overflow + 100) & pmevcntr_mask();
>         int i;
>
>         if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> @@ -581,7 +592,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>         /* enable counters #0 and #1 */
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
>
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, pre_overflow);
>         isb();
>
>         for (i = 0; i < 100; i++)
> @@ -589,14 +600,14 @@ static void test_sw_incr(bool overflow_at_64bits)
>
>         isb();
>         report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> -       report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> +       report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>                 "PWSYNC does not increment if PMCR.E is unset");
>
>         pmu_reset();
>
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, pre_overflow);
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
> -       set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +       set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>         isb();
>
>         for (i = 0; i < 100; i++)
> @@ -614,6 +625,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>  static void test_chained_counters(bool unused)
>  {
>         uint32_t events[] = {CPU_CYCLES, CHAIN};
> +       uint64_t all_set = pmevcntr_mask();
>
>         if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
>                 return;
> @@ -624,7 +636,7 @@ static void test_chained_counters(bool unused)
>         write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>         /* enable counters #0 and #1 */
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>
>         precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>
> @@ -636,26 +648,26 @@ static void test_chained_counters(bool unused)
>         pmu_reset();
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
>
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>         write_regn_el0(pmevcntr, 1, 0x1);
>         precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>         report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>         report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
>         report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
>
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -       write_regn_el0(pmevcntr, 1, ALL_SET);
> +       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +       write_regn_el0(pmevcntr, 1, all_set);
>
>         precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>         report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> -       report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> +       report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
>         report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>
>  static void test_chained_sw_incr(bool unused)
>  {
>         uint32_t events[] = {SW_INCR, CHAIN};
> -       uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> +       uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
>         uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
>         int i;
>
> @@ -669,7 +681,7 @@ static void test_chained_sw_incr(bool unused)
>         /* enable counters #0 and #1 */
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
>
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>         set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>         isb();
>
> @@ -687,7 +699,7 @@ static void test_chained_sw_incr(bool unused)
>         pmu_reset();
>
>         write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>         write_regn_el0(pmevcntr, 1, ALL_SET);
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
>         set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> @@ -726,7 +738,7 @@ static void test_chain_promotion(bool unused)
>
>         /* Only enable even counter */
>         pmu_reset();
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>         write_sysreg_s(0x1, PMCNTENSET_EL0);
>         isb();
>
> @@ -856,6 +868,9 @@ static bool expect_interrupts(uint32_t bitmap)
>
>  static void test_overflow_interrupt(bool overflow_at_64bits)
>  {
> +       uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +       uint64_t all_set = pmevcntr_mask();
> +       uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>         uint32_t events[] = {MEM_ACCESS, SW_INCR};
>         void *addr = malloc(PAGE_SIZE);
>         int i;
> @@ -874,16 +889,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>         write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>         write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, pre_overflow);
> +       write_regn_el0(pmevcntr, 1, pre_overflow);
>         isb();
>
>         /* interrupts are disabled (PMINTENSET_EL1 == 0) */
>
> -       mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +       mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>         report(expect_interrupts(0), "no overflow interrupt after preset");
>
> -       set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +       set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>         isb();
>
>         for (i = 0; i < 100; i++)
> @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>
>         pmu_reset_stats();

This isn't directly related to the patch.
But, as bits of pmovsclr_el0 are already set (although interrupts
are disabled), I would think it's good to clear pmovsclr_el0 here.

Thank you,
Reiji



>
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, pre_overflow);
> +       write_regn_el0(pmevcntr, 1, pre_overflow);
>         write_sysreg(ALL_SET, pmintenset_el1);
>         isb();
>
> -       mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +       mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>         for (i = 0; i < 100; i++)
>                 write_sysreg(0x3, pmswinc_el0);
>
> @@ -912,25 +927,40 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>         report(expect_interrupts(0x3),
>                 "overflow interrupts expected on #0 and #1");
>
> -       /* promote to 64-b */
> +       /*
> +        * promote to 64-b:
> +        *
> +        * This only applies to the !overflow_at_64bits case, as
> +        * overflow_at_64bits doesn't implement CHAIN events. The
> +        * overflow_at_64bits case just checks that chained counters are
> +        * not incremented when PMCR.LP == 1.
> +        */
>
>         pmu_reset_stats();
>
>         write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +       write_regn_el0(pmevcntr, 0, pre_overflow);
>         isb();
> -       mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> -       report(expect_interrupts(0x1),
> -               "expect overflow interrupt on 32b boundary");
> +       mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +       report(expect_interrupts(0x1), "expect overflow interrupt");
>
>         /* overflow on odd counter */
>         pmu_reset_stats();
> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -       write_regn_el0(pmevcntr, 1, ALL_SET);
> +       write_regn_el0(pmevcntr, 0, pre_overflow);
> +       write_regn_el0(pmevcntr, 1, all_set);
>         isb();
> -       mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> -       report(expect_interrupts(0x3),
> -               "expect overflow interrupt on even and odd counter");
> +       mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +       if (overflow_at_64bits) {
> +               report(expect_interrupts(0x1),
> +                      "expect overflow interrupt on even counter");
> +               report(read_regn_el0(pmevcntr, 1) == all_set,
> +                      "Odd counter did not change");
> +       } else {
> +               report(expect_interrupts(0x3),
> +                      "expect overflow interrupt on even and odd counter");
> +               report(read_regn_el0(pmevcntr, 1) != all_set,
> +                      "Odd counter wrapped");
> +       }
>  }
>  #endif
>
> @@ -1131,10 +1161,13 @@ int main(int argc, char *argv[])
>                 report_prefix_pop();
>         } else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>                 run_test(argv[1], test_basic_event_count, false);
> +               run_test(argv[1], test_basic_event_count, true);
>         } else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>                 run_test(argv[1], test_mem_access, false);
> +               run_test(argv[1], test_mem_access, true);
>         } else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
>                 run_test(argv[1], test_sw_incr, false);
> +               run_test(argv[1], test_sw_incr, true);
>         } else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
>                 run_test(argv[1], test_chained_counters, false);
>         } else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> @@ -1143,6 +1176,7 @@ int main(int argc, char *argv[])
>                 run_test(argv[1], test_chain_promotion, false);
>         } else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
>                 run_test(argv[1], test_overflow_interrupt, false);
> +               run_test(argv[1], test_overflow_interrupt, true);
>         } else {
>                 report_abort("Unknown sub-test '%s'", argv[1]);
>         }
> --
> 2.39.0.314.g84b9a713c41-goog
>
