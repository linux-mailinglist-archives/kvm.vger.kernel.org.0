Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69182D84
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732275AbfHFIGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:06:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:5858 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732068AbfHFIGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:06:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:00:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337350"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:00:49 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 07/14] perf/x86: support to create a perf event without counter allocation
Date:   Tue,  6 Aug 2019 15:16:07 +0800
Message-Id: <1565075774-26671-8-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hypervisors may create an lbr event for a vcpu's lbr emulation, and the
emulation doesn't need a counter fundamentally. This makes the emulation
follow the x86 SDM's description about lbr, which doesn't include a
counter, and also avoids wasting a counter.

The perf scheduler is supported to not assign a counter for a perf event
which doesn't need a counter. Define a macro, X86_PMC_IDX_NA, to replace
"-1", which represents a never assigned counter id.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
https://lkml.kernel.org/r/20180920162407.GA24124@hirez.programming.kicks-ass.net
---
 arch/x86/events/core.c            | 36 +++++++++++++++++++++++++++---------
 arch/x86/events/intel/core.c      |  3 +++
 arch/x86/include/asm/perf_event.h |  1 +
 include/linux/perf_event.h        | 11 +++++++++++
 4 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 81b005e..ffa27bb 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -73,7 +73,7 @@ u64 x86_perf_event_update(struct perf_event *event)
 	int idx = hwc->idx;
 	u64 delta;
 
-	if (idx == INTEL_PMC_IDX_FIXED_BTS)
+	if ((idx == INTEL_PMC_IDX_FIXED_BTS) || (idx == X86_PMC_IDX_NA))
 		return 0;
 
 	/*
@@ -595,7 +595,7 @@ static int __x86_pmu_event_init(struct perf_event *event)
 	atomic_inc(&active_events);
 	event->destroy = hw_perf_event_destroy;
 
-	event->hw.idx = -1;
+	event->hw.idx = X86_PMC_IDX_NA;
 	event->hw.last_cpu = -1;
 	event->hw.last_tag = ~0ULL;
 
@@ -763,6 +763,8 @@ static bool perf_sched_restore_state(struct perf_sched *sched)
 static bool __perf_sched_find_counter(struct perf_sched *sched)
 {
 	struct event_constraint *c;
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	struct perf_event *e = cpuc->event_list[sched->state.event];
 	int idx;
 
 	if (!sched->state.unassigned)
@@ -772,6 +774,14 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 		return false;
 
 	c = sched->constraints[sched->state.event];
+	if (c == &emptyconstraint)
+		return false;
+
+	if (is_no_counter_event(e)) {
+		idx = X86_PMC_IDX_NA;
+		goto done;
+	}
+
 	/* Prefer fixed purpose counters */
 	if (c->idxmsk64 & (~0ULL << INTEL_PMC_IDX_FIXED)) {
 		idx = INTEL_PMC_IDX_FIXED;
@@ -797,7 +807,7 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 done:
 	sched->state.counter = idx;
 
-	if (c->overlap)
+	if ((idx != X86_PMC_IDX_NA) && c->overlap)
 		perf_sched_save_state(sched);
 
 	return true;
@@ -918,7 +928,7 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		c = cpuc->event_constraint[i];
 
 		/* never assigned */
-		if (hwc->idx == -1)
+		if (hwc->idx == X86_PMC_IDX_NA)
 			break;
 
 		/* constraint still honored */
@@ -969,7 +979,8 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	if (!unsched && assign) {
 		for (i = 0; i < n; i++) {
 			e = cpuc->event_list[i];
-			if (x86_pmu.commit_scheduling)
+			if (x86_pmu.commit_scheduling &&
+			    (assign[i] != X86_PMC_IDX_NA))
 				x86_pmu.commit_scheduling(cpuc, i, assign[i]);
 		}
 	} else {
@@ -1038,7 +1049,8 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	hwc->last_cpu = smp_processor_id();
 	hwc->last_tag = ++cpuc->tags[i];
 
-	if (hwc->idx == INTEL_PMC_IDX_FIXED_BTS) {
+	if ((hwc->idx == INTEL_PMC_IDX_FIXED_BTS) ||
+	    (hwc->idx == X86_PMC_IDX_NA)) {
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
 	} else if (hwc->idx >= INTEL_PMC_IDX_FIXED) {
@@ -1115,7 +1127,7 @@ static void x86_pmu_enable(struct pmu *pmu)
 			 * - running on same CPU as last time
 			 * - no other event has used the counter since
 			 */
-			if (hwc->idx == -1 ||
+			if (hwc->idx == X86_PMC_IDX_NA ||
 			    match_prev_assignment(hwc, cpuc, i))
 				continue;
 
@@ -1169,7 +1181,7 @@ int x86_perf_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
-	if (idx == INTEL_PMC_IDX_FIXED_BTS)
+	if ((idx == INTEL_PMC_IDX_FIXED_BTS) || (idx == X86_PMC_IDX_NA))
 		return 0;
 
 	/*
@@ -1306,7 +1318,7 @@ static void x86_pmu_start(struct perf_event *event, int flags)
 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
 		return;
 
-	if (WARN_ON_ONCE(idx == -1))
+	if (idx == X86_PMC_IDX_NA)
 		return;
 
 	if (flags & PERF_EF_RELOAD) {
@@ -1388,6 +1400,9 @@ void x86_pmu_stop(struct perf_event *event, int flags)
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
+	if (hwc->idx == X86_PMC_IDX_NA)
+		return;
+
 	if (test_bit(hwc->idx, cpuc->active_mask)) {
 		x86_pmu.disable(event);
 		__clear_bit(hwc->idx, cpuc->active_mask);
@@ -2128,6 +2143,9 @@ static int x86_pmu_event_idx(struct perf_event *event)
 	if (!(event->hw.flags & PERF_X86_EVENT_RDPMC_ALLOWED))
 		return 0;
 
+	if (idx == X86_PMC_IDX_NA)
+		return X86_PMC_IDX_NA;
+
 	if (x86_pmu.num_counters_fixed && idx >= INTEL_PMC_IDX_FIXED) {
 		idx -= INTEL_PMC_IDX_FIXED;
 		idx |= 1 << 30;
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 648260b5..177c321 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2156,6 +2156,9 @@ static void intel_pmu_disable_event(struct perf_event *event)
 		return;
 	}
 
+	if (hwc->idx == X86_PMC_IDX_NA)
+		return;
+
 	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index aa77da2..23ab90c 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -11,6 +11,7 @@
 #define INTEL_PMC_IDX_FIXED				       32
 
 #define X86_PMC_IDX_MAX					       64
+#define X86_PMC_IDX_NA					       -1
 
 #define MSR_ARCH_PERFMON_PERFCTR0			      0xc1
 #define MSR_ARCH_PERFMON_PERFCTR1			      0xc2
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e8ad3c5..2cae06a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -530,6 +530,7 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *,
  */
 #define PERF_EV_CAP_SOFTWARE		BIT(0)
 #define PERF_EV_CAP_READ_ACTIVE_PKG	BIT(1)
+#define PERF_EV_CAP_NO_COUNTER		BIT(2)
 
 #define SWEVENT_HLIST_BITS		8
 #define SWEVENT_HLIST_SIZE		(1 << SWEVENT_HLIST_BITS)
@@ -1039,6 +1040,16 @@ static inline bool is_sampling_event(struct perf_event *event)
 	return event->attr.sample_period != 0;
 }
 
+static inline bool is_no_counter_event(struct perf_event *event)
+{
+	return !!(event->event_caps & PERF_EV_CAP_NO_COUNTER);
+}
+
+static inline void perf_event_set_no_counter(struct perf_event *event)
+{
+	event->event_caps |= PERF_EV_CAP_NO_COUNTER;
+}
+
 /*
  * Return 1 for a software event, 0 for a hardware event
  */
-- 
2.7.4

