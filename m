Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EAB67D22B
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 17:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjAZQyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 11:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjAZQyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 11:54:03 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2157A5EF9B
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:54:01 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id bb5-20020a17090b008500b0022c04c51749so1103698pjb.0
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+qpoFxT5bGi671ATjgpVRNYqlsRSMwNrYoRRIZd0yxA=;
        b=NMakbLiNriJ0GR9sKDK6acX68ECIkL/QbsB8Dj7ijDtb3YWHAWdJHJBWAdk69w5/6U
         DmqbelOe7QALjOCkOD4OqGVHRdaqKgg681Q41sHhc6cEvKbD1PpPqTYwhtsrZz55oW6v
         j1H70pJJmDejv7QD6OEEfEc0aWNALuubYzbEPlYxIJN9o3WX8kLnNbxxAo5//ISKEpgI
         tjfo6saqHshunrYkkJqkmeKkvcaiO1JHsB4fW0Mf/aiaRZ4dIi2S7dsOWbxC4rVboICq
         dTx64SNeeIZu7wW3Je6PvCIyS/rMWZPqYctsVlxpI0JuinnjyxBOFDtF46p3fbebGH5e
         hHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+qpoFxT5bGi671ATjgpVRNYqlsRSMwNrYoRRIZd0yxA=;
        b=Kjtz0dNfJ/NjDq6Z1f/ki86sgQcdQFRKYyVnWtP+yspBwoWF3isQ6/5oAdsy+nVvEg
         5wQz1gsE9ZULd/DW7MUGmaSJcQ9J+EQD53O7kXO+HDZL21U7IFnvNJeJploYf6BGz3Bc
         5k3ohGg4hpHLxq8A+iVtvrCTLMzuJBQJQpvY32i0X3aWD9e6qvpcWgG4EtB8jlo8RRWg
         JJjm7tXq/bqrFOA7veGMIJ+IDajZ50kG9Rs+gN5bDZcu/+memJXU0xn0LUp8eQMx9msc
         doIE+BsZ1a9oHCZBgyia6PfM86rRuo/z89zhEnhhGKm/Gxu5hM2mHrNQzIRNn3vpjJTL
         bJuQ==
X-Gm-Message-State: AFqh2kp9m6PFPISRK1iFwbuKTmS0VWCGcPPG3ZJmiRiGVOFxC6IRu/v2
        RCiK55GVXUwX0cgUDVGvcoG/1VYxJd65X+tHLowMbUY8KZQZ95UPw472ff12P585NWP6QCShIOP
        mThAfGTD25gZdsMN4loMq4PigNblcbFP9Wo8OSPufAm90KY2AW2cL88Ko1tuWpgo=
X-Google-Smtp-Source: AMrXdXsqIrf58M2oEuYZ9S2XiUP9K1dLUxgzBFg0bfbTgu+RZg45ESq4etsxNclrlk3YNvi24uP9R/ehGMdlcA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:70b:b0:58d:c1cb:3ab3 with SMTP
 id 11-20020a056a00070b00b0058dc1cb3ab3mr4177864pfl.64.1674752040334; Thu, 26
 Jan 2023 08:54:00 -0800 (PST)
Date:   Thu, 26 Jan 2023 16:53:49 +0000
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-5-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 4/6] arm: pmu: Add tests for 64-bit overflows
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
supported on PMUv3p5.

Note that chained tests do not implement "overflow_at_64bits == true".
That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
0487H.a, J1.1.1 "aarch64/debug").

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arm/pmu.c | 100 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 67 insertions(+), 33 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 08e956d..082fb41 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -28,6 +28,7 @@
 #define PMU_PMCR_X         (1 << 4)
 #define PMU_PMCR_DP        (1 << 5)
 #define PMU_PMCR_LC        (1 << 6)
+#define PMU_PMCR_LP        (1 << 7)
 #define PMU_PMCR_N_SHIFT   11
 #define PMU_PMCR_N_MASK    0x1f
 #define PMU_PMCR_ID_SHIFT  16
@@ -57,8 +58,12 @@
 #define ALL_SET_32			0x00000000FFFFFFFFULL
 #define ALL_CLEAR		0x0000000000000000ULL
 #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
 #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
 
+#define PRE_OVERFLOW(__overflow_at_64bits)				\
+	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
+
 #define PMU_PPI			23
 
 struct pmu {
@@ -448,8 +453,10 @@ static bool check_overflow_prerequisites(bool overflow_at_64bits)
 static void test_basic_event_count(bool overflow_at_64bits)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
-	uint32_t counter_mask;
+	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
+	uint32_t counter_mask;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
 	    !check_overflow_prerequisites(overflow_at_64bits))
@@ -471,13 +478,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
 	 * clear cycle and all event counters and allow counter enablement
 	 * through PMCNTENSET. LC is RES1.
 	 */
-	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
 	isb();
-	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
+	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
 
 	/* Preset counter #0 to pre overflow value to trigger an overflow */
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
-	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"counter #0 preset to pre-overflow value");
 	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
 
@@ -530,6 +537,8 @@ static void test_mem_access(bool overflow_at_64bits)
 {
 	void *addr = malloc(PAGE_SIZE);
 	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
+	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
 	    !check_overflow_prerequisites(overflow_at_64bits))
@@ -541,7 +550,7 @@ static void test_mem_access(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
 	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
 	/* We may measure more than 20 mem access depending on the core */
@@ -551,11 +560,11 @@ static void test_mem_access(bool overflow_at_64bits)
 
 	pmu_reset();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	write_regn_el0(pmevcntr, 1, pre_overflow);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(read_sysreg(pmovsclr_el0) == 0x3,
 	       "Ran 20 mem accesses with expected overflows on both counters");
 	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
@@ -565,8 +574,10 @@ static void test_mem_access(bool overflow_at_64bits)
 
 static void test_sw_incr(bool overflow_at_64bits)
 {
+	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {SW_INCR, SW_INCR};
-	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
+	uint64_t cntr0 = (pre_overflow + 100) & pmevcntr_mask();
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
@@ -580,7 +591,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 	/* enable counters #0 and #1 */
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
 	isb();
 
 	for (i = 0; i < 100; i++)
@@ -588,14 +599,14 @@ static void test_sw_incr(bool overflow_at_64bits)
 
 	isb();
 	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
-	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
+	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"PWSYNC does not increment if PMCR.E is unset");
 
 	pmu_reset();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
-	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	isb();
 
 	for (i = 0; i < 100; i++)
@@ -613,6 +624,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 static void test_chained_counters(bool unused)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
+	uint64_t all_set = pmevcntr_mask();
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
 		return;
@@ -643,11 +655,11 @@ static void test_chained_counters(bool unused)
 	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
-	write_regn_el0(pmevcntr, 1, ALL_SET_32);
+	write_regn_el0(pmevcntr, 1, all_set);
 
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
-	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
+	report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
 	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
@@ -855,6 +867,9 @@ static bool expect_interrupts(uint32_t bitmap)
 
 static void test_overflow_interrupt(bool overflow_at_64bits)
 {
+	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
+	uint64_t all_set = pmevcntr_mask();
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {MEM_ACCESS, SW_INCR};
 	void *addr = malloc(PAGE_SIZE);
 	int i;
@@ -873,16 +888,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	write_regn_el0(pmevcntr, 1, pre_overflow);
 	isb();
 
 	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
-	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	isb();
 
 	for (i = 0; i < 100; i++)
@@ -897,12 +912,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 
 	pmu_reset_stats();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	write_regn_el0(pmevcntr, 1, pre_overflow);
 	write_sysreg(ALL_SET_32, pmintenset_el1);
 	isb();
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
@@ -911,25 +926,40 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	report(expect_interrupts(0x3),
 		"overflow interrupts expected on #0 and #1");
 
-	/* promote to 64-b */
+	/*
+	 * promote to 64-b:
+	 *
+	 * This only applies to the !overflow_at_64bits case, as
+	 * overflow_at_64bits doesn't implement CHAIN events. The
+	 * overflow_at_64bits case just checks that chained counters are
+	 * not incremented when PMCR.LP == 1.
+	 */
 
 	pmu_reset_stats();
 
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
 	isb();
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0x1),
-		"expect overflow interrupt on 32b boundary");
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	report(expect_interrupts(0x1), "expect overflow interrupt");
 
 	/* overflow on odd counter */
 	pmu_reset_stats();
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
-	write_regn_el0(pmevcntr, 1, ALL_SET_32);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	write_regn_el0(pmevcntr, 1, all_set);
 	isb();
-	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0x3),
-		"expect overflow interrupt on even and odd counter");
+	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	if (overflow_at_64bits) {
+		report(expect_interrupts(0x1),
+		       "expect overflow interrupt on even counter");
+		report(read_regn_el0(pmevcntr, 1) == all_set,
+		       "Odd counter did not change");
+	} else {
+		report(expect_interrupts(0x3),
+		       "expect overflow interrupt on even and odd counter");
+		report(read_regn_el0(pmevcntr, 1) != all_set,
+		       "Odd counter wrapped");
+	}
 }
 #endif
 
@@ -1138,10 +1168,13 @@ int main(int argc, char *argv[])
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
 		run_event_test(argv[1], test_basic_event_count, false);
+		run_event_test(argv[1], test_basic_event_count, true);
 	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
 		run_event_test(argv[1], test_mem_access, false);
+		run_event_test(argv[1], test_mem_access, true);
 	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
 		run_event_test(argv[1], test_sw_incr, false);
+		run_event_test(argv[1], test_sw_incr, true);
 	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
 		run_event_test(argv[1], test_chained_counters, false);
 	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
@@ -1150,6 +1183,7 @@ int main(int argc, char *argv[])
 		run_event_test(argv[1], test_chain_promotion, false);
 	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
 		run_event_test(argv[1], test_overflow_interrupt, false);
+		run_event_test(argv[1], test_overflow_interrupt, true);
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
-- 
2.39.1.456.gfc5497dd1b-goog

