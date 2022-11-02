Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D8A6170F8
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiKBWwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiKBWwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:52:07 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2DCDE9D
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:58 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36f8318e4d0so174165227b3.20
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mTltgivZw0aQx5y2nw+x1VGJH0qEMCQRGbT8j4GhJXw=;
        b=VIYQ7WCZ1x3hYatufrQ8j6px4bHE+9ePoj9QMUk5Hlk5H19QcVBhOC8J2VPrVY+BI8
         cFz2OZFO7LmBD7Vz/psS7qXFN6Mf6DkAFveA4AzJYAY3sjC6H/X9mmwYqHVfxrRKbtj6
         i8zyDDZpnRzbYEHn+dNt4+T43h9Os78onmcFc+PQ1xigDLTDA5Cc89Zza+UeMrSjsZRn
         osUPiIyh4HIJ0XjuMvZ45w9wE2VwOImu8lLtOEA5QmNVlkwmaSBODq9mRm5AJ7UHWo4y
         pghH71DUpsM58sPmHPPVmTZYTX61MA1itBhFJCcBsb2DpaZxcaW5J0JJcO/44EFazqR8
         3jjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mTltgivZw0aQx5y2nw+x1VGJH0qEMCQRGbT8j4GhJXw=;
        b=BSZxVpBWnqfTtsncoJnDQ1RCAgJ+Vcd3RQAse9jBd3Nqqgu/ZjcXsy/bLO21s3LIm3
         W9rAd9tTzh8IlHYFktGOYo8+DLiHWoevYDsietiCPChF4MWPAhQrOPdjJjxnNsRg3ysw
         yY+nkEdupZUfWG2oLkhbZQYzwpQhBuZlk3IZmlM9/BEVZyx8J4AMPgfDyh7wVSiUX/tL
         qYtEDHXOWx6cpyTcdw1vGAR6xXk/ibCXisJoSzdlQvuEnkEJGO7q2TwIbQV4AXDlmFt/
         1+/uDehIuVeB4SJG5ruMXWF9tj0EypruTGGh3d7sCxVTjnsjsjNX+nHyoTliDFuncikH
         6OWQ==
X-Gm-Message-State: ACrzQf08ECFpkRFxXIiGDIXLJwHV9QmTemsz6O5bS9982Rg9Y40uQg7g
        DIJB7zCRXktpzVNvjCchT+CSfVohCgs=
X-Google-Smtp-Source: AMsMyM6RqggAOK9y1UTuDa8raeAdG/vZiFBvuljCW7Ix6fHkB1X3pXIabrw804bj6pxlxg11VLaLN2kXvjI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1547:b0:6d0:b14e:a666 with SMTP id
 r7-20020a056902154700b006d0b14ea666mr311309ybu.108.1667429517942; Wed, 02 Nov
 2022 15:51:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:09 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-27-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 26/27] x86/pmu: Update testcases to cover
 AMD PMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

From: Like Xu <likexu@tencent.com>

AMD core PMU before Zen4 did not have version numbers, there were
no fixed counters, it had a hard-coded number of generic counters,
bit-width, and only hardware events common across amd generations
(starting with K7) were added to amd_gp_events[] table.

All above differences are instantiated at the detection step, and it
also covers the K7 PMU registers, which is consistent with bare-metal.

Cc: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h       | 17 +++++++++++++
 lib/x86/pmu.c       | 59 ++++++++++++++++++++++++++++-----------------
 lib/x86/pmu.h       | 13 +++++++++-
 lib/x86/processor.h |  1 +
 x86/pmu.c           | 58 +++++++++++++++++++++++++++++++++++---------
 5 files changed, 114 insertions(+), 34 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 68d88371..6cf8f336 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -146,6 +146,23 @@
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
 
+/* Fam 15h MSRs */
+#define MSR_F15H_PERF_CTL              0xc0010200
+#define MSR_F15H_PERF_CTL0             MSR_F15H_PERF_CTL
+#define MSR_F15H_PERF_CTL1             (MSR_F15H_PERF_CTL + 2)
+#define MSR_F15H_PERF_CTL2             (MSR_F15H_PERF_CTL + 4)
+#define MSR_F15H_PERF_CTL3             (MSR_F15H_PERF_CTL + 6)
+#define MSR_F15H_PERF_CTL4             (MSR_F15H_PERF_CTL + 8)
+#define MSR_F15H_PERF_CTL5             (MSR_F15H_PERF_CTL + 10)
+
+#define MSR_F15H_PERF_CTR              0xc0010201
+#define MSR_F15H_PERF_CTR0             MSR_F15H_PERF_CTR
+#define MSR_F15H_PERF_CTR1             (MSR_F15H_PERF_CTR + 2)
+#define MSR_F15H_PERF_CTR2             (MSR_F15H_PERF_CTR + 4)
+#define MSR_F15H_PERF_CTR3             (MSR_F15H_PERF_CTR + 6)
+#define MSR_F15H_PERF_CTR4             (MSR_F15H_PERF_CTR + 8)
+#define MSR_F15H_PERF_CTR5             (MSR_F15H_PERF_CTR + 10)
+
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 837d2a6c..090e1115 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -4,36 +4,51 @@ struct pmu_caps pmu;
 
 void pmu_init(void)
 {
-	struct cpuid cpuid_10 = cpuid(10);
-
 	pmu.is_intel = is_intel();
 
-	if (!pmu.is_intel)
-		return;
+	if (pmu.is_intel) {
+		struct cpuid cpuid_10 = cpuid(10);
 
-	pmu.version = cpuid_10.a & 0xff;
+		pmu.version = cpuid_10.a & 0xff;
 
-	if (pmu.version > 1) {
-		pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
-		pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
-	}
+		if (pmu.version > 1) {
+			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
+			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
+		}
 
-	pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
-	pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
-	pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
+		if (pmu.version > 1) {
+			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
+			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
+		}
 
-	/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
-	pmu.gp_counter_available = ~cpuid_10.b;
+		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
+		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
+		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
 
-	if (this_cpu_has(X86_FEATURE_PDCM))
-		pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
-	pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
-	pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
+		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
+		pmu.gp_counter_available = ~cpuid_10.b;
 
-	if (this_cpu_has_perf_global_status()) {
-		pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
-		pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
-		pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+		if (this_cpu_has(X86_FEATURE_PDCM))
+			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+		pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
+		pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
+
+		if (this_cpu_has_perf_global_status()) {
+			pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
+			pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
+			pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+		}
+	} else {
+		pmu.msr_gp_counter_base = MSR_F15H_PERF_CTR0;
+		pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
+		if (!this_cpu_has(X86_FEATURE_PERFCTR_CORE))
+			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
+		else
+			pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
+
+		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
+		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
+		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
 	}
 
 	pmu_reset_all_counters();
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 460e2a19..8465e3c9 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -10,6 +10,11 @@
 /* Performance Counter Vector for the LVT PC Register */
 #define PMI_VECTOR	32
 
+#define AMD64_NUM_COUNTERS	4
+#define AMD64_NUM_COUNTERS_CORE	6
+
+#define PMC_DEFAULT_WIDTH	48
+
 #define DEBUGCTLMSR_LBR	  (1UL <<  0)
 
 #define PMU_CAP_LBR_FMT	  0x3f
@@ -72,17 +77,23 @@ void pmu_init(void);
 
 static inline u32 MSR_GP_COUNTERx(unsigned int i)
 {
+	if (pmu.msr_gp_counter_base == MSR_F15H_PERF_CTR0)
+		return pmu.msr_gp_counter_base + 2 * i;
+
 	return pmu.msr_gp_counter_base + i;
 }
 
 static inline u32 MSR_GP_EVENT_SELECTx(unsigned int i)
 {
+	if (pmu.msr_gp_event_select_base == MSR_F15H_PERF_CTL0)
+		return pmu.msr_gp_event_select_base + 2 * i;
+
 	return pmu.msr_gp_event_select_base + i;
 }
 
 static inline bool this_cpu_has_pmu(void)
 {
-	return !!pmu.version;
+	return !pmu.is_intel || !!pmu.version;
 }
 
 static inline bool this_cpu_has_perf_global_ctrl(void)
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index c0716663..681e1675 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -252,6 +252,7 @@ static inline bool is_intel(void)
  * Extended Leafs, a.k.a. AMD defined
  */
 #define	X86_FEATURE_SVM			(CPUID(0x80000001, 0, ECX, 2))
+#define	X86_FEATURE_PERFCTR_CORE	(CPUID(0x80000001, 0, ECX, 23))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
 #define	X86_FEATURE_GBPAGES		(CPUID(0x80000001, 0, EDX, 26))
 #define	X86_FEATURE_RDTSCP		(CPUID(0x80000001, 0, EDX, 27))
diff --git a/x86/pmu.c b/x86/pmu.c
index c40e2a96..72c2c9cf 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -38,6 +38,11 @@ struct pmu_event {
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 0, 0.1*N},
+}, amd_gp_events[] = {
+	{"core cycles", 0x0076, 1*N, 50*N},
+	{"instructions", 0x00c0, 10*N, 10.2*N},
+	{"branches", 0x00c2, 1*N, 1.1*N},
+	{"branch misses", 0x00c3, 0, 0.1*N},
 }, fixed_events[] = {
 	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
 	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
@@ -79,14 +84,23 @@ static bool check_irq(void)
 
 static bool is_gp(pmu_counter_t *evt)
 {
+	if (!pmu.is_intel)
+		return true;
+
 	return evt->ctr < MSR_CORE_PERF_FIXED_CTR0 ||
 		evt->ctr >= MSR_IA32_PMC0;
 }
 
 static int event_to_global_idx(pmu_counter_t *cnt)
 {
-	return cnt->ctr - (is_gp(cnt) ? pmu.msr_gp_counter_base :
-		(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
+	if (pmu.is_intel)
+		return cnt->ctr - (is_gp(cnt) ? pmu.msr_gp_counter_base :
+			(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
+
+	if (pmu.msr_gp_counter_base == MSR_F15H_PERF_CTR0)
+		return (cnt->ctr - pmu.msr_gp_counter_base) / 2;
+	else
+		return cnt->ctr - pmu.msr_gp_counter_base;
 }
 
 static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
@@ -306,6 +320,9 @@ static void check_counter_overflow(void)
 			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
 
 		if (i == pmu.nr_gp_counters) {
+			if (!pmu.is_intel)
+				break;
+
 			cnt.ctr = fixed_events[0].unit_sel;
 			cnt.count = measure_for_overflow(&cnt);
 			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
@@ -319,7 +336,10 @@ static void check_counter_overflow(void)
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
-		report(cnt.count == 1, "cntr-%d", i);
+		if (pmu.is_intel)
+			report(cnt.count == 1, "cntr-%d", i);
+		else
+			report(cnt.count == 0xffffffffffff || cnt.count < 7, "cntr-%d", i);
 
 		if (!this_cpu_has_perf_global_status())
 			continue;
@@ -457,10 +477,11 @@ static void check_running_counter_wrmsr(void)
 static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
+	unsigned int branch_idx = pmu.is_intel ? 5 : 2;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[5].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[branch_idx].unit_sel,
 	};
 	pmu_counter_t instr_cnt = {
 		.ctr = MSR_GP_COUNTERx(1),
@@ -654,15 +675,21 @@ int main(int ac, char **av)
 
 	check_invalid_rdpmc_gp();
 
-	if (!pmu.version) {
-		report_skip("No Intel Arch PMU is detected!");
-		return report_summary();
+	if (pmu.is_intel) {
+		if (!pmu.version) {
+			report_skip("No Intel Arch PMU is detected!");
+			return report_summary();
+		}
+		gp_events = (struct pmu_event *)intel_gp_events;
+		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
+		report_prefix_push("Intel");
+		set_ref_cycle_expectations();
+	} else {
+		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
+		gp_events = (struct pmu_event *)amd_gp_events;
+		report_prefix_push("AMD");
 	}
 
-	gp_events = (struct pmu_event *)intel_gp_events;
-	gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
-	set_ref_cycle_expectations();
-
 	printf("PMU version:         %d\n", pmu.version);
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
 	printf("GP counter width:    %d\n", pmu.gp_counter_width);
@@ -683,5 +710,14 @@ int main(int ac, char **av)
 		report_prefix_pop();
 	}
 
+	if (!pmu.is_intel) {
+		report_prefix_push("K7");
+		pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
+		pmu.msr_gp_counter_base = MSR_K7_PERFCTR0;
+		pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
+		check_counters();
+		report_prefix_pop();
+	}
+
 	return report_summary();
 }
-- 
2.38.1.431.g37b22c650d-goog

