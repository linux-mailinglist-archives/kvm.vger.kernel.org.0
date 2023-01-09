Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B326632A6
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjAIVTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbjAIVSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:18:13 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1136BC17
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:18:02 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id y37-20020a634b25000000b004b1d90ea947so2106697pga.15
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CJQNWPzLiYpvoONucZmav/nAQaGyt7nBiXyk/5nAE3k=;
        b=DPCAI7WgaOtmk7gZ0DCOk97deFpglitPGj7y+JbNTjGd7ugy2gjAm88yqY2QcXqpwT
         K2Wh3DOZn4PYZ7iEw9pcrRe5Rkv9RDr/RhVjolF5YoHWsupnry+9GcClTkM82LEuBQ5e
         lftWsJzf13W4dqErdybNMbRHZSREqSqURD6Iafd1Qldss7aOBgC1/Vd0zXqhc+iSx3Pt
         RRd9LOOH+IvEPELb2kKqnwoYCWcaHu2iiNxSa3cLEvpwVfzzN/tRvDUyp6cd5Atf/WGF
         IoKoVqE/3y3sGHNda8jSb+EPuXCrACfbyy3tJqC1sYwBl/L5B/etkq8rcaH1L9DQQTCL
         OvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJQNWPzLiYpvoONucZmav/nAQaGyt7nBiXyk/5nAE3k=;
        b=BNVU9jkGd5F11b3Vzm41IBRzsYJo0aVaj9SmPGKQg00D4yadFpjhTZidESlQfQ6Br2
         7kZwS2PBUthnaAVB8ynf4KnR0WDjS5/ktuIr+/AjQfccdLUXN6zjJQ38/0lNe7WeGWZu
         I+PHr1PHgaCb/FM/H4lmSbo5qFGXxvq9ImYgfBJGVyKwqQXQmxz+7q/a4o0c4n2wFIV6
         5JSytD+FRtdYNv0toxsw9WT+HSkjvojDeYvgq5FLjOXAbdlUoFjpZ2jKml92zgTMhB6A
         eUqbGhD8jPsg+MMm/FaZTfuD1djEGb0jFzTioDlvm9WEMW/JHd75fR6BO05R1Ymc48ki
         vf8A==
X-Gm-Message-State: AFqh2kpkeLcyAbBBxMGSPKTzxUEjv2zYRneXoAOtUAzR49DzUplzbKVU
        +YB3/Rz4KxYCIxzHAIKp89Y8AVfX1TQWhoUIty2w/l1136Cmor4WI7KLtVQVW+Wh66oY+IvgYbY
        0sRn7DDQ9W3Xe/57rqDaHvEqORI4cjAOOvJeKR+29t9LGgX2t8qva1CK+rqK8IvU=
X-Google-Smtp-Source: AMrXdXsE7Q6sw4uH8YuOdABoQBPiBSN/VdyhR+nCEh0oScCtDM8cx6/zmJ+kYAn3qjtHyH9PcJ3UdyRa8K2dAA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:f313:b0:192:6b69:27ff with SMTP
 id c19-20020a170902f31300b001926b6927ffmr3245451ple.57.1673299080983; Mon, 09
 Jan 2023 13:18:00 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:17:52 +0000
In-Reply-To: <20230109211754.67144-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109211754.67144-3-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v3 2/4] arm: pmu: Prepare for testing 64-bit overflows
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

PMUv3p5 adds a knob, PMCR_EL0.LP == 1, that allows overflowing at 64-bits
instead of 32. Prepare by doing these 3 things:

1. Add a "bool overflow_at_64bits" argument to all tests checking
   overflows.
2. Extend satisfy_prerequisites() to check if the machine supports
   "overflow_at_64bits".
3. Refactor the test invocations to use the new "run_test()" which adds a
   report prefix indicating whether the test uses 64 or 32-bit overflows.

A subsequent commit will actually add the 64-bit overflow tests.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 92 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 39 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 7f0794d..0d06b59 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -164,13 +164,13 @@ static void pmu_reset(void)
 /* event counter tests only implemented for aarch64 */
 static void test_event_introspection(void) {}
 static void test_event_counter_config(void) {}
-static void test_basic_event_count(void) {}
-static void test_mem_access(void) {}
-static void test_sw_incr(void) {}
-static void test_chained_counters(void) {}
-static void test_chained_sw_incr(void) {}
-static void test_chain_promotion(void) {}
-static void test_overflow_interrupt(void) {}
+static void test_basic_event_count(bool overflow_at_64bits) {}
+static void test_mem_access(bool overflow_at_64bits) {}
+static void test_sw_incr(bool overflow_at_64bits) {}
+static void test_chained_counters(bool unused) {}
+static void test_chained_sw_incr(bool unused) {}
+static void test_chain_promotion(bool unused) {}
+static void test_overflow_interrupt(bool overflow_at_64bits) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -416,6 +416,7 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
 			return false;
 		}
 	}
+
 	return true;
 }
 
@@ -435,13 +436,24 @@ static uint64_t pmevcntr_mask(void)
 	return (uint32_t)~0;
 }
 
-static void test_basic_event_count(void)
+static bool check_overflow_prerequisites(bool overflow_at_64bits)
+{
+	if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
+		report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
+		return false;
+	}
+
+	return true;
+}
+
+static void test_basic_event_count(bool overflow_at_64bits)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
 	uint32_t counter_mask;
 	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
 		return;
 
 	implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
@@ -515,12 +527,13 @@ static void test_basic_event_count(void)
 		"check overflow happened on #0 only");
 }
 
-static void test_mem_access(void)
+static void test_mem_access(bool overflow_at_64bits)
 {
 	void *addr = malloc(PAGE_SIZE);
 	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -551,13 +564,14 @@ static void test_mem_access(void)
 			read_sysreg(pmovsclr_el0));
 }
 
-static void test_sw_incr(void)
+static void test_sw_incr(bool overflow_at_64bits)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
 	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -597,7 +611,7 @@ static void test_sw_incr(void)
 		"overflow on counter #0 after 100 SW_INCR");
 }
 
-static void test_chained_counters(void)
+static void test_chained_counters(bool unused)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
 
@@ -638,7 +652,7 @@ static void test_chained_counters(void)
 	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
-static void test_chained_sw_incr(void)
+static void test_chained_sw_incr(bool unused)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
 	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
@@ -691,7 +705,7 @@ static void test_chained_sw_incr(void)
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
-static void test_chain_promotion(void)
+static void test_chain_promotion(bool unused)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
 	void *addr = malloc(PAGE_SIZE);
@@ -840,13 +854,14 @@ static bool expect_interrupts(uint32_t bitmap)
 	return true;
 }
 
-static void test_overflow_interrupt(void)
+static void test_overflow_interrupt(bool overflow_at_64bits)
 {
 	uint32_t events[] = {MEM_ACCESS, SW_INCR};
 	void *addr = malloc(PAGE_SIZE);
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
 		return;
 
 	gic_enable_defaults();
@@ -1070,6 +1085,19 @@ static bool pmu_probe(void)
 	return true;
 }
 
+static void run_test(char *name, void (*test)(bool), bool overflow_at_64bits)
+{
+	const char *prefix = overflow_at_64bits ? "64-bit overflows" : "32-bit overflows";
+
+	report_prefix_push(name);
+	report_prefix_push(prefix);
+
+	test(overflow_at_64bits);
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
 int main(int argc, char *argv[])
 {
 	int cpi = 0;
@@ -1102,33 +1130,19 @@ int main(int argc, char *argv[])
 		test_event_counter_config();
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
-		report_prefix_push(argv[1]);
-		test_basic_event_count();
-		report_prefix_pop();
+		run_test(argv[1], test_basic_event_count, false);
 	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
-		report_prefix_push(argv[1]);
-		test_mem_access();
-		report_prefix_pop();
+		run_test(argv[1], test_mem_access, false);
 	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
-		report_prefix_push(argv[1]);
-		test_sw_incr();
-		report_prefix_pop();
+		run_test(argv[1], test_sw_incr, false);
 	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
-		report_prefix_push(argv[1]);
-		test_chained_counters();
-		report_prefix_pop();
+		run_test(argv[1], test_chained_counters, false);
 	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
-		report_prefix_push(argv[1]);
-		test_chained_sw_incr();
-		report_prefix_pop();
+		run_test(argv[1], test_chained_sw_incr, false);
 	} else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
-		report_prefix_push(argv[1]);
-		test_chain_promotion();
-		report_prefix_pop();
+		run_test(argv[1], test_chain_promotion, false);
 	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
-		report_prefix_push(argv[1]);
-		test_overflow_interrupt();
-		report_prefix_pop();
+		run_test(argv[1], test_overflow_interrupt, false);
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
-- 
2.39.0.314.g84b9a713c41-goog

