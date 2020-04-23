Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BE61B570D
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgDWIRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:17:44 -0400
Received: from mga18.intel.com ([134.134.136.126]:57581 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgDWIRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:17:43 -0400
IronPort-SDR: Dd2MEjJAUsmqAgPQ4AfuE+L5Z+5yLidNs58bx1KC4JTGUWH1UIExWzJ4AmSm68oxJZKVszH3hj
 msIEzI5dA2TA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:17:42 -0700
IronPort-SDR: IsU+N7gEYBPuSPBbRNvRbvbNZQhwQ0rsg5nH9XmwClFFxvjZ1d8FGB3Ra4YhGe7BURCA4bEbsM
 3BAO4sfXZKRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910046"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:17:39 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com, Like Xu <like.xu@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v10 02/11] perf/x86/core: Refactor hw->idx checks and cleanup
Date:   Thu, 23 Apr 2020 16:14:03 +0800
Message-Id: <20200423081412.164863-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For intel_pmu_en/disable_event(), reorder the branches checks for
hw->idx and make them sorted by probability: gp,fixed,bts,others.

Clean up the x86_assign_hw_event() by converting multiple if-else
statements to a switch statement.

To skip x86_perf_event_update() and x86_perf_event_set_period(),
it's generic to replace "idx == INTEL_PMC_IDX_FIXED_BTS" check with
'!hwc->event_base' because that should be 0 for all non-gp/fixed cases.

Wrap related bit operations into intel_set/clear_masks() and
make the main path more cleaner and readable.

No functional changes.

Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Original-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/core.c       | 25 +++++++----
 arch/x86/events/intel/core.c | 85 +++++++++++++++++++-----------------
 2 files changed, 62 insertions(+), 48 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index a619763e96e1..f7a259dcbb06 100644
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
index 332954cccece..f1439acbf7e6 100644
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
2.21.1

