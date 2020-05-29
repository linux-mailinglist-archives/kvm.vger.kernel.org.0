Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6641E7758
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgE2Hof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:44:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:51936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgE2Hob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:44:31 -0400
IronPort-SDR: +80ku7H/44UC6FoYahamMgcy9OO7nS7NcKb8KspMvRI/3qsQpYmjiMnQN1pCh/RRarldNv9Uvi
 2cvxkAoVDZuA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:44:29 -0700
IronPort-SDR: kh8e1JaVGwo3U0lQvu22yLYJ6sIVTXL0BH5pKwMsSYsUcCgVzPRcNvw/e+sglNAjosJtqxSsfk
 WQdMbHlb3wVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="302754553"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 29 May 2020 00:44:27 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [kvm-unit-tests PATCH] x86: pmu: Test full-width counter writes support
Date:   Fri, 29 May 2020 15:43:46 +0800
Message-Id: <20200529074347.124619-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200529074347.124619-1-like.xu@linux.intel.com>
References: <20200529074347.124619-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the full-width writes capability is set, use the alternative MSR
range to write larger sign counter values (up to GP counter width).

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 lib/x86/msr.h |   1 +
 x86/pmu.c     | 125 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 102 insertions(+), 24 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 8dca964..6ef5502 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -35,6 +35,7 @@
 #define MSR_IA32_SPEC_CTRL              0x00000048
 #define MSR_IA32_PRED_CMD               0x00000049
 
+#define MSR_IA32_PMC0                  0x000004c1
 #define MSR_IA32_PERFCTR0		0x000000c1
 #define MSR_IA32_PERFCTR1		0x000000c2
 #define MSR_FSB_FREQ			0x000000cd
diff --git a/x86/pmu.c b/x86/pmu.c
index f45621a..fb9bf0a 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -91,6 +91,9 @@ struct pmu_event {
 	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
+#define PMU_CAP_FW_WRITES	(1ULL << 13)
+static u64 gp_counter_base = MSR_IA32_PERFCTR0;
+
 static int num_counters;
 
 char *buf;
@@ -125,12 +128,13 @@ static bool check_irq(void)
 
 static bool is_gp(pmu_counter_t *evt)
 {
-	return evt->ctr < MSR_CORE_PERF_FIXED_CTR0;
+	return evt->ctr < MSR_CORE_PERF_FIXED_CTR0 ||
+		evt->ctr >= MSR_IA32_PMC0;
 }
 
 static int event_to_global_idx(pmu_counter_t *cnt)
 {
-	return cnt->ctr - (is_gp(cnt) ? MSR_IA32_PERFCTR0 :
+	return cnt->ctr - (is_gp(cnt) ? gp_counter_base :
 		(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
 }
 
@@ -226,7 +230,7 @@ static bool verify_counter(pmu_counter_t *cnt)
 static void check_gp_counter(struct pmu_event *evt)
 {
 	pmu_counter_t cnt = {
-		.ctr = MSR_IA32_PERFCTR0,
+		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | evt->unit_sel,
 	};
 	int i;
@@ -276,7 +280,7 @@ static void check_counters_many(void)
 			continue;
 
 		cnt[n].count = 0;
-		cnt[n].ctr = MSR_IA32_PERFCTR0 + n;
+		cnt[n].ctr = gp_counter_base + n;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
 			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
 		n++;
@@ -302,7 +306,7 @@ static void check_counter_overflow(void)
 	uint64_t count;
 	int i;
 	pmu_counter_t cnt = {
-		.ctr = MSR_IA32_PERFCTR0,
+		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 		.count = 0,
 	};
@@ -319,6 +323,8 @@ static void check_counter_overflow(void)
 		int idx;
 
 		cnt.count = 1 - count;
+		if (gp_counter_base == MSR_IA32_PMC0)
+			cnt.count &= (1ul << eax.split.bit_width) - 1;
 
 		if (i == num_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
@@ -346,7 +352,7 @@ static void check_counter_overflow(void)
 static void check_gp_counter_cmask(void)
 {
 	pmu_counter_t cnt = {
-		.ctr = MSR_IA32_PERFCTR0,
+		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 		.count = 0,
 	};
@@ -369,7 +375,7 @@ static void do_rdpmc_fast(void *ptr)
 
 static void check_rdpmc(void)
 {
-	uint64_t val = 0x1f3456789ull;
+	uint64_t val = 0xff0123456789ull;
 	bool exc;
 	int i;
 
@@ -378,20 +384,23 @@ static void check_rdpmc(void)
 	for (i = 0; i < num_counters; i++) {
 		uint64_t x;
 		pmu_counter_t cnt = {
-			.ctr = MSR_IA32_PERFCTR0 + i,
+			.ctr = gp_counter_base + i,
 			.idx = i
 		};
 
-		/*
-		 * Only the low 32 bits are writable, and the value is
-		 * sign-extended.
-		 */
-		x = (uint64_t)(int64_t)(int32_t)val;
+	        /*
+	         * Without full-width writes, only the low 32 bits are writable,
+	         * and the value is sign-extended.
+	         */
+		if (gp_counter_base == MSR_IA32_PERFCTR0)
+			x = (uint64_t)(int64_t)(int32_t)val;
+		else
+			x = (uint64_t)(int64_t)val;
 
 		/* Mask according to the number of supported bits */
 		x &= (1ull << eax.split.bit_width) - 1;
 
-		wrmsr(MSR_IA32_PERFCTR0 + i, val);
+		wrmsr(gp_counter_base + i, val);
 		report(rdpmc(i) == x, "cntr-%d", i);
 
 		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
@@ -423,8 +432,9 @@ static void check_rdpmc(void)
 static void check_running_counter_wrmsr(void)
 {
 	uint64_t status;
+	uint64_t count;
 	pmu_counter_t evt = {
-		.ctr = MSR_IA32_PERFCTR0,
+		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
 		.count = 0,
 	};
@@ -433,7 +443,7 @@ static void check_running_counter_wrmsr(void)
 
 	start_event(&evt);
 	loop();
-	wrmsr(MSR_IA32_PERFCTR0, 0);
+	wrmsr(gp_counter_base, 0);
 	stop_event(&evt);
 	report(evt.count < gp_events[1].min, "cntr");
 
@@ -443,7 +453,13 @@ static void check_running_counter_wrmsr(void)
 
 	evt.count = 0;
 	start_event(&evt);
-	wrmsr(MSR_IA32_PERFCTR0, -1);
+
+	count = -1;
+	if (gp_counter_base == MSR_IA32_PMC0)
+		count &= (1ul << eax.split.bit_width) - 1;
+
+	wrmsr(gp_counter_base, count);
+
 	loop();
 	stop_event(&evt);
 	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
@@ -452,6 +468,66 @@ static void check_running_counter_wrmsr(void)
 	report_prefix_pop();
 }
 
+static void check_counters(void)
+{
+	check_gp_counters();
+	check_fixed_counters();
+	check_rdpmc();
+	check_counters_many();
+	check_counter_overflow();
+	check_gp_counter_cmask();
+	check_running_counter_wrmsr();
+}
+
+static void do_unsupported_width_counter_write(void *index)
+{
+	wrmsr(MSR_IA32_PMC0 + *((int *) index), 0xffffff0123456789ull);
+}
+
+static void  check_gp_counters_write_width(void)
+{
+	u64 val_64 = 0xffffff0123456789ull;
+	u64 val_32 = val_64 & ((1ul << 32) - 1);
+	u64 val_max_width = val_64 & ((1ul << eax.split.bit_width) - 1);
+	int i;
+
+	/*
+	 * MSR_IA32_PERFCTRn supports 64-bit writes,
+	 * but only the lowest 32 bits are valid.
+	 */
+	for (i = 0; i < num_counters; i++) {
+		wrmsr(MSR_IA32_PERFCTR0 + i, val_32);
+		assert(rdmsr(MSR_IA32_PERFCTR0 + i) == val_32);
+		assert(rdmsr(MSR_IA32_PMC0 + i) == val_32);
+
+		wrmsr(MSR_IA32_PERFCTR0 + i, val_max_width);
+		assert(rdmsr(MSR_IA32_PERFCTR0 + i) == val_32);
+		assert(rdmsr(MSR_IA32_PMC0 + i) == val_32);
+
+		wrmsr(MSR_IA32_PERFCTR0 + i, val_64);
+		assert(rdmsr(MSR_IA32_PERFCTR0 + i) == val_32);
+		assert(rdmsr(MSR_IA32_PMC0 + i) == val_32);
+	}
+
+	/*
+	 * MSR_IA32_PMCn supports writing values â€‹â€‹up to GP counter width,
+	 * and only the lowest bits of GP counter width are valid.
+	 */
+	for (i = 0; i < num_counters; i++) {
+		wrmsr(MSR_IA32_PMC0 + i, val_32);
+		assert(rdmsr(MSR_IA32_PMC0 + i) == val_32);
+		assert(rdmsr(MSR_IA32_PERFCTR0 + i) == val_32);
+
+		wrmsr(MSR_IA32_PMC0 + i, val_max_width);
+		assert(rdmsr(MSR_IA32_PMC0 + i) == val_max_width);
+		assert(rdmsr(MSR_IA32_PERFCTR0 + i) == val_max_width);
+
+		report(test_for_exception(GP_VECTOR,
+			do_unsupported_width_counter_write, &i),
+		"writing unsupported width to MSR_IA32_PMC%d raises #GP", i);
+	}
+}
+
 int main(int ac, char **av)
 {
 	struct cpuid id = cpuid(10);
@@ -480,13 +556,14 @@ int main(int ac, char **av)
 
 	apic_write(APIC_LVTPC, PC_VECTOR);
 
-	check_gp_counters();
-	check_fixed_counters();
-	check_rdpmc();
-	check_counters_many();
-	check_counter_overflow();
-	check_gp_counter_cmask();
-	check_running_counter_wrmsr();
+	check_counters();
+
+	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
+		gp_counter_base = MSR_IA32_PMC0;
+		report_prefix_push("full-width writes");
+		check_counters();
+		check_gp_counters_write_width();
+	}
 
 	return report_summary();
 }
-- 
2.21.3

