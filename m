Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4371A609DA6
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiJXJO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiJXJOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:14:04 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7C868CD1
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:44 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id b5so8184106pgb.6
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sefsVn/KyRtcLJhX7LG0gKatFJ95SB2+vN4YB2WOoh8=;
        b=MMtep/gwA5IJdcAjGR+yqgxvNBtX8NNAULQar8HRWxxnt7CLYC8y7XWhISgLUv2rxy
         GQbrfuyLF3r+sXzVpy2vKFMYEyoqttGMku96mFb2+au11tNOXBAhU9xfjeRc6GcHDDSY
         uBLYHkqIvpFci0FYBIPcfr07VljR/ANt8w0z8xDkmcGENyfd5f2iIqKUdyhZUtU5NYjn
         aySKHe95zeGRZ8V63nd8mwHCgouo9ASwery5agqvWOPr5ozQkQEKhbV9cxEV9YIF8s7D
         tZVGW9VO/IrIm5zg2s5X01qVba4mzGU8cuD2ZflYhHZXeFPgYEGepiWiTL8eghDPK4sB
         FbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sefsVn/KyRtcLJhX7LG0gKatFJ95SB2+vN4YB2WOoh8=;
        b=oRN4zMlndrBQWtBg8dwtlJBdk43YKooQkWe3ViG8Uh17Rsijoyhm3F6tCgxaXX373y
         4vtGuYs5MXA16M8NIg+KfMN43xI9+EkjHk9R55JgdwjPf9pKRupfFsc7I9WWJkk7lVe+
         ldN7lDObhBqVPK7Kw+75fG9Oa0K9TWz21RVdY1IH4yFhS+Hon3V1wHDYhEkSdvsRR5Ax
         1e+u9ls31fEv8Ls9GopRnsHqM1HIEOmM6mfx/keOur3ikh9Egmzuw2GIIVex7nn9VF+Q
         RBayQQ2FegwluOLZftfadgj+kPfrV43v1lbUWalFfSYvFUwc2jBan+bz8PhAlivRuH6d
         Pt7g==
X-Gm-Message-State: ACrzQf2zm5wpdlGGVFrPpuyJeawtIT1TrDuRkiJYom9bNmLA0PbAT2vE
        RKYovUftsDDfg6mOJ1wB+AA=
X-Google-Smtp-Source: AMsMyM4S6Bh/PynIW2ANQJbYgKvWwc0IOzISsgRT2CFbrEMPuR23qClBwpatca0HPHXBsRGPr0VnJA==
X-Received: by 2002:a63:516:0:b0:46e:d2ea:22cb with SMTP id 22-20020a630516000000b0046ed2ea22cbmr10760849pgf.144.1666602819549;
        Mon, 24 Oct 2022 02:13:39 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:39 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>
Subject: [kvm-unit-tests PATCH v4 23/24] x86/pmu: Update testcases to cover AMD PMU
Date:   Mon, 24 Oct 2022 17:12:22 +0800
Message-Id: <20221024091223.42631-24-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
---
 lib/x86/msr.h       | 17 +++++++++++++
 lib/x86/pmu.c       | 29 +++++++++++++++--------
 lib/x86/pmu.h       | 35 +++++++++++++++++++++++++--
 lib/x86/processor.h |  1 +
 x86/pmu.c           | 58 ++++++++++++++++++++++++++++++++++++---------
 5 files changed, 117 insertions(+), 23 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 68d8837..6cf8f33 100644
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
index 25e21e5..7fd2279 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -5,16 +5,25 @@ struct pmu_caps pmu;
 
 void pmu_init(void)
 {
-    cpuid_10 = cpuid(10);
-    if (this_cpu_has(X86_FEATURE_PDCM))
-        pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
-    pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
-    pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
-    pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
-    if (this_cpu_support_perf_status()) {
-        pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
-        pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
-        pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+    if (is_intel()) {
+        cpuid_10 = cpuid(10);
+        if (this_cpu_has(X86_FEATURE_PDCM))
+            pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+        pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
+        pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
+        pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
+        if (this_cpu_support_perf_status()) {
+            pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
+            pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
+            pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+        }
+    } else {
+        pmu.msr_gp_counter_base = MSR_F15H_PERF_CTR0;
+        pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
+        if (!has_amd_perfctr_core())
+            pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
+        else
+            pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
     }
     reset_all_counters();
 }
\ No newline at end of file
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 4312b6e..a4e00c5 100644
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
@@ -84,11 +89,17 @@ static inline void set_gp_event_select_base(u32 new_base)
 
 static inline u32 gp_counter_msr(unsigned int i)
 {
+	if (gp_counter_base() == MSR_F15H_PERF_CTR0)
+		return gp_counter_base() + 2 * i;
+
 	return gp_counter_base() + i;
 }
 
 static inline u32 gp_event_select_msr(unsigned int i)
 {
+	if (gp_event_select_base() == MSR_F15H_PERF_CTL0)
+		return gp_event_select_base() + 2 * i;
+
 	return gp_event_select_base() + i;
 }
 
@@ -104,11 +115,17 @@ static inline void write_gp_event_select(unsigned int i, u64 value)
 
 static inline u8 pmu_version(void)
 {
+	if (!is_intel())
+		return 0;
+
 	return cpuid_10.a & 0xff;
 }
 
 static inline bool this_cpu_has_pmu(void)
 {
+	if (!is_intel())
+		return true;
+
 	return !!pmu_version();
 }
 
@@ -135,12 +152,18 @@ static inline void set_nr_gp_counters(u8 new_num)
 
 static inline u8 pmu_gp_counter_width(void)
 {
-	return (cpuid_10.a >> 16) & 0xff;
+	if (is_intel())
+		return (cpuid_10.a >> 16) & 0xff;
+	else
+		return PMC_DEFAULT_WIDTH;
 }
 
 static inline u8 pmu_gp_counter_mask_length(void)
 {
-	return (cpuid_10.a >> 24) & 0xff;
+	if (is_intel())
+		return (cpuid_10.a >> 24) & 0xff;
+	else
+		return pmu_nr_gp_counters();
 }
 
 static inline u8 pmu_nr_fixed_counters(void)
@@ -161,6 +184,9 @@ static inline u8 pmu_fixed_counter_width(void)
 
 static inline bool pmu_gp_counter_is_available(int i)
 {
+	if (!is_intel())
+		return i < pmu_nr_gp_counters();
+
 	/* CPUID.0xA.EBX bit is '1 if they counter is NOT available. */
 	return !(cpuid_10.b & BIT(i));
 }
@@ -268,4 +294,9 @@ static inline bool pebs_has_baseline(void)
 	return pmu.perf_cap & PMU_CAP_PEBS_BASELINE;
 }
 
+static inline bool has_amd_perfctr_core(void)
+{
+	return this_cpu_has(X86_FEATURE_PERFCTR_CORE);
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index ee2b5a2..64b36cf 100644
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
index 24d015e..d4ef685 100644
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
+	if (!is_intel())
+		return true;
+
 	return evt->ctr < MSR_CORE_PERF_FIXED_CTR0 ||
 		evt->ctr >= MSR_IA32_PMC0;
 }
 
 static int event_to_global_idx(pmu_counter_t *cnt)
 {
-	return cnt->ctr - (is_gp(cnt) ? gp_counter_base() :
-		(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
+	if (is_intel())
+		return cnt->ctr - (is_gp(cnt) ? gp_counter_base() :
+			(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
+
+	if (gp_counter_base() == MSR_F15H_PERF_CTR0)
+		return (cnt->ctr - gp_counter_base()) / 2;
+	else
+		return cnt->ctr - gp_counter_base();
 }
 
 static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
@@ -309,6 +323,9 @@ static void check_counter_overflow(void)
 			cnt.count &= (1ull << pmu_gp_counter_width()) - 1;
 
 		if (i == nr_gp_counters) {
+			if (!is_intel())
+				break;
+
 			cnt.ctr = fixed_events[0].unit_sel;
 			cnt.count = measure_for_overflow(&cnt);
 			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
@@ -322,7 +339,10 @@ static void check_counter_overflow(void)
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
-		report(cnt.count == 1, "cntr-%d", i);
+		if (is_intel())
+			report(cnt.count == 1, "cntr-%d", i);
+		else
+			report(cnt.count == 0xffffffffffff || cnt.count < 7, "cntr-%d", i);
 
 		if (!this_cpu_support_perf_status())
 			continue;
@@ -464,10 +484,11 @@ static void check_running_counter_wrmsr(void)
 static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
+	unsigned int branch_idx = is_intel() ? 5 : 2;
 	pmu_counter_t brnch_cnt = {
 		.ctr = gp_counter_msr(0),
 		/* branch instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[5].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[branch_idx].unit_sel,
 	};
 	pmu_counter_t instr_cnt = {
 		.ctr = gp_counter_msr(1),
@@ -662,15 +683,21 @@ int main(int ac, char **av)
 
 	check_invalid_rdpmc_gp();
 
-	if (!pmu_version()) {
-		report_skip("No Intel Arch PMU is detected!");
-		return report_summary();
+	if (is_intel()) {
+		if (!pmu_version()) {
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
 	printf("PMU version:         %d\n", pmu_version());
 	printf("GP counters:         %d\n", pmu_nr_gp_counters());
 	printf("GP counter width:    %d\n", pmu_gp_counter_width());
@@ -690,5 +717,14 @@ int main(int ac, char **av)
 		report_prefix_pop();
 	}
 
+	if (!is_intel()) {
+		report_prefix_push("K7");
+		set_nr_gp_counters(AMD64_NUM_COUNTERS);
+		set_gp_counter_base(MSR_K7_PERFCTR0);
+		set_gp_event_select_base(MSR_K7_EVNTSEL0);
+		check_counters();
+		report_prefix_pop();
+	}
+
 	return report_summary();
 }
-- 
2.38.1

