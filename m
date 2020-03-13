Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBEA183F06
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 03:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgCMCTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 22:19:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:25868 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgCMCS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 22:18:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 19:18:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261743789"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 19:18:54 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Like Xu <like.xu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v9 03/10] perf/x86: Add constraint to create guest LBR event without hw counter
Date:   Fri, 13 Mar 2020 10:16:09 +0800
Message-Id: <20200313021616.112322-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200313021616.112322-1-like.xu@linux.intel.com>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypervisor may request the perf subsystem to schedule a time window
to directly access the LBR stack msrs for its own use. Normally, it would
create a guest LBR event with callstack mode enabled, which is scheduled
along with other LBR events on the host but in an exclusive way.

To avoid wasting a counter for the guest LBR event, the perf tracks it via
is_guest_lbr_event() and assigns it with a fake INTEL_PMC_IDX_FIXED_VLBR
counter with the help of new guest_lbr_constraint. Inspired by BTS event,
there is actually no hardware counter allocated for guest LBR events.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/core.c            |  9 ++++++---
 arch/x86/events/intel/core.c      | 19 +++++++++++++++++++
 arch/x86/events/intel/lbr.c       |  3 +++
 arch/x86/events/perf_event.h      | 15 +++++++++++++++
 arch/x86/include/asm/perf_event.h | 12 +++++++++++-
 include/linux/perf_event.h        |  7 +++++++
 kernel/events/core.c              |  7 -------
 7 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 3bb738f5a472..e919187a0751 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -74,7 +74,8 @@ u64 x86_perf_event_update(struct perf_event *event)
 	int idx = hwc->idx;
 	u64 delta;
 
-	if (idx == INTEL_PMC_IDX_FIXED_BTS)
+	if ((idx == INTEL_PMC_IDX_FIXED_BTS) ||
+		(idx == INTEL_PMC_IDX_FIXED_VLBR))
 		return 0;
 
 	/*
@@ -1102,7 +1103,8 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	hwc->last_cpu = smp_processor_id();
 	hwc->last_tag = ++cpuc->tags[i];
 
-	if (hwc->idx == INTEL_PMC_IDX_FIXED_BTS) {
+	if ((hwc->idx == INTEL_PMC_IDX_FIXED_BTS) ||
+		(hwc->idx == INTEL_PMC_IDX_FIXED_VLBR)) {
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
 	} else if (hwc->idx >= INTEL_PMC_IDX_FIXED) {
@@ -1233,7 +1235,8 @@ int x86_perf_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
-	if (idx == INTEL_PMC_IDX_FIXED_BTS)
+	if ((idx == INTEL_PMC_IDX_FIXED_BTS) ||
+		(idx == INTEL_PMC_IDX_FIXED_VLBR))
 		return 0;
 
 	/*
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 3be51aa06e67..901c82032f4a 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2157,6 +2157,9 @@ static void intel_pmu_disable_event(struct perf_event *event)
 		return;
 	}
 
+	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_VLBR))
+		return;
+
 	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
@@ -2241,6 +2244,9 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		return;
 	}
 
+	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_VLBR))
+		return;
+
 	if (event->attr.exclude_host)
 		cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
 	if (event->attr.exclude_guest)
@@ -2595,6 +2601,15 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
+static struct event_constraint *
+intel_guest_event_constraints(struct perf_event *event)
+{
+	if (unlikely(is_guest_lbr_event(event)))
+		return &guest_lbr_constraint;
+
+	return NULL;
+}
+
 static int intel_alt_er(int idx, u64 config)
 {
 	int alt_idx = idx;
@@ -2785,6 +2800,10 @@ __intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
 {
 	struct event_constraint *c;
 
+	c = intel_guest_event_constraints(event);
+	if (c)
+		return c;
+
 	c = intel_bts_constraints(event);
 	if (c)
 		return c;
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 5ed88e578eaa..ff1f35b4f420 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1353,3 +1353,6 @@ int x86_perf_get_lbr(struct x86_pmu_lbr *stack)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
+
+struct event_constraint guest_lbr_constraint =
+	EVENT_CONSTRAINT(0, 1ULL << GLOBAL_STATUS_LBRS_FROZEN_BIT, 0);
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 1025bc6eb04f..9a62264a3068 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -969,6 +969,20 @@ static inline bool intel_pmu_has_bts(struct perf_event *event)
 	return intel_pmu_has_bts_period(event, hwc->sample_period);
 }
 
+static inline bool is_guest_event(struct perf_event *event)
+{
+	if (event->attr.exclude_host && is_kernel_event(event))
+		return true;
+	return false;
+}
+
+static inline bool is_guest_lbr_event(struct perf_event *event)
+{
+	if (is_guest_event(event) && needs_branch_stack(event))
+		return true;
+	return false;
+}
+
 int intel_pmu_save_and_restart(struct perf_event *event);
 
 struct event_constraint *
@@ -989,6 +1003,7 @@ void release_ds_buffers(void);
 void reserve_ds_buffers(void);
 
 extern struct event_constraint bts_constraint;
+extern struct event_constraint guest_lbr_constraint;
 
 void intel_pmu_enable_bts(u64 config);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index e018a1cf604c..674130aca75a 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -181,9 +181,19 @@ struct x86_pmu_capability {
 #define GLOBAL_STATUS_UNC_OVF				BIT_ULL(61)
 #define GLOBAL_STATUS_ASIF				BIT_ULL(60)
 #define GLOBAL_STATUS_COUNTERS_FROZEN			BIT_ULL(59)
-#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(58)
+#define GLOBAL_STATUS_LBRS_FROZEN_BIT			58
+#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(GLOBAL_STATUS_LBRS_FROZEN_BIT)
 #define GLOBAL_STATUS_TRACE_TOPAPMI			BIT_ULL(55)
 
+/*
+ * We model guest LBR event tracing as another fixed-mode PMC like BTS.
+ *
+ * We choose bit 58 (LBRS_FROZEN_BIT) which is used to indicate that the LBR
+ * stack is frozen on a hardware PMI request in the PERF_GLOBAL_STATUS msr,
+ * and the 59th PMC counter (if any) is not supposed to use it as well.
+ */
+#define INTEL_PMC_IDX_FIXED_VLBR	GLOBAL_STATUS_LBRS_FROZEN_BIT
+
 /*
  * Adaptive PEBS v4
  */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 547773f5894e..b94b695f2d7e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1082,6 +1082,13 @@ static inline bool is_sampling_event(struct perf_event *event)
 	return event->attr.sample_period != 0;
 }
 
+#define TASK_TOMBSTONE ((void *)-1L)
+
+static inline bool is_kernel_event(struct perf_event *event)
+{
+	return READ_ONCE(event->owner) == TASK_TOMBSTONE;
+}
+
 /*
  * Return 1 for a software event, 0 for a hardware event
  */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e453589da97c..75d47fcb9a0d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -164,13 +164,6 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 	raw_spin_unlock(&cpuctx->ctx.lock);
 }
 
-#define TASK_TOMBSTONE ((void *)-1L)
-
-static bool is_kernel_event(struct perf_event *event)
-{
-	return READ_ONCE(event->owner) == TASK_TOMBSTONE;
-}
-
 /*
  * On task ctx scheduling...
  *
-- 
2.21.1

