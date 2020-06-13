Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFF71F81A4
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgFMILS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:11:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:50471 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgFMILK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:10 -0400
IronPort-SDR: SNlDmWGLBRL3C1Jr+887w2N+ACUCftzxuJXoXssnE0WwrAfRIOSksV9ZJxpjxsMqoHsFxTZ01S
 zMNmqHnCJxVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:07 -0700
IronPort-SDR: WeL8M1hRhkUvyOHKT0gYVvXemPP+ekilcQpX5Jh7DcTrseHj22lAQmjiDGfX/QOvsMQPUACY2L
 TSTzqmIXPJnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467328"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:02 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 02/11] perf/x86/core: Refactor hw->idx checks and cleanup
Date:   Sat, 13 Jun 2020 16:09:47 +0800
Message-Id: <20200613080958.132489-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For intel_pmu_en/disable_event(), reorder the branches checks for hw->idx
and make them sorted by probability: gp,fixed,bts,others.

Clean up the x86_assign_hw_event() by converting multiple if-else
statements to a switch statement.

To skip x86_perf_event_update() and x86_perf_event_set_period(),
it's generic to replace "idx == INTEL_PMC_IDX_FIXED_BTS" check with
'!hwc->event_base' because that should be 0 for all non-gp/fixed cases.

Wrap related bit operations into intel_set/clear_masks() and make the main
path more cleaner and readable.

No functional changes.

Original-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/core.c       | 25 +++++++----
 arch/x86/events/intel/core.c | 85 +++++++++++++++++++-----------------
 2 files changed, 62 insertions(+), 48 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 9e63ee50b19a..9a5056472b67 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -71,10 +71,9 @@ u64 x86_perf_event_update(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int shift = 64 - x86_pmu.cntval_bits;
 	u64 prev_raw_count, new_raw_count;
-	int idx = hwc->idx;
 	u64 delta;
 
-	if (idx == INTEL_PMC_IDX_FIXED_BTS)
+	if (unlikely(!hwc->event_base))
 		return 0;
 
 	/*
@@ -1097,22 +1096,30 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 				struct cpu_hw_events *cpuc, int i)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	int idx;
 
-	hwc->idx = cpuc->assign[i];
+	idx = hwc->idx = cpuc->assign[i];
 	hwc->last_cpu = smp_processor_id();
 	hwc->last_tag = ++cpuc->tags[i];
 
-	if (hwc->idx == INTEL_PMC_IDX_FIXED_BTS) {
+	switch (hwc->idx) {
+	case INTEL_PMC_IDX_FIXED_BTS:
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
-	} else if (hwc->idx >= INTEL_PMC_IDX_FIXED) {
+		break;
+
+	case INTEL_PMC_IDX_FIXED ... INTEL_PMC_IDX_FIXED_BTS-1:
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
-		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - INTEL_PMC_IDX_FIXED);
-		hwc->event_base_rdpmc = (hwc->idx - INTEL_PMC_IDX_FIXED) | 1<<30;
-	} else {
+		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 +
+				(idx - INTEL_PMC_IDX_FIXED);
+		hwc->event_base_rdpmc = (idx - INTEL_PMC_IDX_FIXED) | 1<<30;
+		break;
+
+	default:
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
 		hwc->event_base_rdpmc = x86_pmu_rdpmc_index(hwc->idx);
+		break;
 	}
 }
 
@@ -1233,7 +1240,7 @@ int x86_perf_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
-	if (idx == INTEL_PMC_IDX_FIXED_BTS)
+	if (unlikely(!hwc->event_base))
 		return 0;
 
 	/*
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ca35c8b5ee10..8dac4c61bf76 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2136,8 +2136,35 @@ static inline void intel_pmu_ack_status(u64 ack)
 	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
 }
 
-static void intel_pmu_disable_fixed(struct hw_perf_event *hwc)
+static inline bool event_is_checkpointed(struct perf_event *event)
+{
+	return unlikely(event->hw.config & HSW_IN_TX_CHECKPOINTED) != 0;
+}
+
+static inline void intel_set_masks(struct perf_event *event, int idx)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+
+	if (event->attr.exclude_host)
+		__set_bit(idx, (unsigned long *)&cpuc->intel_ctrl_guest_mask);
+	if (event->attr.exclude_guest)
+		__set_bit(idx, (unsigned long *)&cpuc->intel_ctrl_host_mask);
+	if (event_is_checkpointed(event))
+		__set_bit(idx, (unsigned long *)&cpuc->intel_cp_status);
+}
+
+static inline void intel_clear_masks(struct perf_event *event, int idx)
 {
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+
+	__clear_bit(idx, (unsigned long *)&cpuc->intel_ctrl_guest_mask);
+	__clear_bit(idx, (unsigned long *)&cpuc->intel_ctrl_host_mask);
+	__clear_bit(idx, (unsigned long *)&cpuc->intel_cp_status);
+}
+
+static void intel_pmu_disable_fixed(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx - INTEL_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
 
@@ -2148,31 +2175,22 @@ static void intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 	wrmsrl(hwc->config_base, ctrl_val);
 }
 
-static inline bool event_is_checkpointed(struct perf_event *event)
-{
-	return (event->hw.config & HSW_IN_TX_CHECKPOINTED) != 0;
-}
-
 static void intel_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	int idx = hwc->idx;
 
-	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
+	if (idx < INTEL_PMC_IDX_FIXED) {
+		intel_clear_masks(event, idx);
+		x86_pmu_disable_event(event);
+	} else if (idx < INTEL_PMC_IDX_FIXED_BTS) {
+		intel_clear_masks(event, idx);
+		intel_pmu_disable_fixed(event);
+	} else if (idx == INTEL_PMC_IDX_FIXED_BTS) {
 		intel_pmu_disable_bts();
 		intel_pmu_drain_bts_buffer();
-		return;
 	}
 
-	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
-	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
-	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
-
-	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
-		intel_pmu_disable_fixed(hwc);
-	else
-		x86_pmu_disable_event(event);
-
 	/*
 	 * Needs to be called after x86_pmu_disable_event,
 	 * so we don't trigger the event without PEBS bit set.
@@ -2238,33 +2256,22 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 static void intel_pmu_enable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-
-	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
-		if (!__this_cpu_read(cpu_hw_events.enabled))
-			return;
-
-		intel_pmu_enable_bts(hwc->config);
-		return;
-	}
-
-	if (event->attr.exclude_host)
-		cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
-	if (event->attr.exclude_guest)
-		cpuc->intel_ctrl_host_mask |= (1ull << hwc->idx);
-
-	if (unlikely(event_is_checkpointed(event)))
-		cpuc->intel_cp_status |= (1ull << hwc->idx);
+	int idx = hwc->idx;
 
 	if (unlikely(event->attr.precise_ip))
 		intel_pmu_pebs_enable(event);
 
-	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
+	if (idx < INTEL_PMC_IDX_FIXED) {
+		intel_set_masks(event, idx);
+		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
+	} else if (idx < INTEL_PMC_IDX_FIXED_BTS) {
+		intel_set_masks(event, idx);
 		intel_pmu_enable_fixed(event);
-		return;
+	} else if (idx == INTEL_PMC_IDX_FIXED_BTS) {
+		if (!__this_cpu_read(cpu_hw_events.enabled))
+			return;
+		intel_pmu_enable_bts(hwc->config);
 	}
-
-	__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 static void intel_pmu_add_event(struct perf_event *event)
-- 
2.21.3

