Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACED71F81B8
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgFMIMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:12:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:64588 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgFMIL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:26 -0400
IronPort-SDR: djlHTgaFUm1ujGv1ucsBrDTphlUfpxVD9vH8VmpEldU0FnGJoWnPnVBR1vNuNAaAi0h3bSW+hd
 F9Oy1XYZeKGg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:22 -0700
IronPort-SDR: DdZKjpsButtjhrf5IMP5F+XZkTpElM1eY5xak5IPAKJSlhxEytJJkKm1rJYEo0SRyePsqhLAFZ
 5nL68bUazhnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467378"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:16 -0700
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
Subject: [PATCH v12 05/11] perf/x86: Keep LBR records unchanged in host context for guest usage
Date:   Sat, 13 Jun 2020 16:09:50 +0800
Message-Id: <20200613080958.132489-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest wants to use the LBR registers, its hypervisor creates a guest
LBR event and let host perf schedules it. The LBR records msrs are
accessible to the guest when its guest LBR event is scheduled on
by the perf subsystem.

Before scheduling this event out, we should avoid host changes on
IA32_DEBUGCTLMSR or LBR_SELECT. Otherwise, some unexpected branch
operations may interfere with guest behavior, pollute LBR records, and even
cause host branches leakage. In addition, the read operation
on host is also avoidable.

To ensure that guest LBR records are not lost during the context switch,
the guest LBR event would enable the callstack mode which could
save/restore guest unread LBR records with the help of
intel_pmu_lbr_sched_task() naturally.

However, the guest LBR_SELECT may changes for its own use and the host
LBR event doesn't save/restore it. To ensure that we doesn't lost the guest
LBR_SELECT value when the guest LBR event is running, the vlbr_constraint
is bound up with a new constraint flag PERF_X86_EVENT_LBR_SELECT.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200514083054.62538-6-like.xu@linux.intel.com
---
 arch/x86/events/intel/core.c |  6 ++++--
 arch/x86/events/intel/lbr.c  | 31 ++++++++++++++++++++++++++-----
 arch/x86/events/perf_event.h |  3 +++
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 51e1fba7b1d1..582ddff9a359 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2189,7 +2189,8 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	} else if (idx == INTEL_PMC_IDX_FIXED_BTS) {
 		intel_pmu_disable_bts();
 		intel_pmu_drain_bts_buffer();
-	}
+	} else if (idx == INTEL_PMC_IDX_FIXED_VLBR)
+		intel_clear_masks(event, idx);
 
 	/*
 	 * Needs to be called after x86_pmu_disable_event,
@@ -2271,7 +2272,8 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		if (!__this_cpu_read(cpu_hw_events.enabled))
 			return;
 		intel_pmu_enable_bts(hwc->config);
-	}
+	} else if (idx == INTEL_PMC_IDX_FIXED_VLBR)
+		intel_set_masks(event, idx);
 }
 
 static void intel_pmu_add_event(struct perf_event *event)
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index d285d26c1578..d03de7539957 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -383,6 +383,9 @@ static void __intel_pmu_lbr_restore(struct x86_perf_task_context *task_ctx)
 
 	wrmsrl(x86_pmu.lbr_tos, tos);
 	task_ctx->lbr_stack_state = LBR_NONE;
+
+	if (cpuc->lbr_select)
+		wrmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
 }
 
 static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
@@ -415,6 +418,9 @@ static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
 
 	cpuc->last_task_ctx = task_ctx;
 	cpuc->last_log_id = ++task_ctx->log_id;
+
+	if (cpuc->lbr_select)
+		rdmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
 }
 
 void intel_pmu_lbr_swap_task_ctx(struct perf_event_context *prev,
@@ -485,6 +491,9 @@ void intel_pmu_lbr_add(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	if (event->hw.flags & PERF_X86_EVENT_LBR_SELECT)
+		cpuc->lbr_select = 1;
+
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	if (branch_user_callstack(cpuc->br_sel) && event->ctx->task_ctx_data) {
@@ -532,6 +541,9 @@ void intel_pmu_lbr_del(struct perf_event *event)
 		task_ctx->lbr_callstack_users--;
 	}
 
+	if (event->hw.flags & PERF_X86_EVENT_LBR_SELECT)
+		cpuc->lbr_select = 0;
+
 	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip > 0)
 		cpuc->lbr_pebs_users--;
 	cpuc->lbr_users--;
@@ -540,11 +552,19 @@ void intel_pmu_lbr_del(struct perf_event *event)
 	perf_sched_cb_dec(event->ctx->pmu);
 }
 
+static inline bool vlbr_exclude_host(void)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+
+	return test_bit(INTEL_PMC_IDX_FIXED_VLBR,
+		(unsigned long *)&cpuc->intel_ctrl_guest_mask);
+}
+
 void intel_pmu_lbr_enable_all(bool pmi)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (cpuc->lbr_users)
+	if (cpuc->lbr_users && !vlbr_exclude_host())
 		__intel_pmu_lbr_enable(pmi);
 }
 
@@ -552,7 +572,7 @@ void intel_pmu_lbr_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (cpuc->lbr_users)
+	if (cpuc->lbr_users && !vlbr_exclude_host())
 		__intel_pmu_lbr_disable();
 }
 
@@ -694,7 +714,8 @@ void intel_pmu_lbr_read(void)
 	 * This could be smarter and actually check the event,
 	 * but this simple approach seems to work for now.
 	 */
-	if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
+	if (!cpuc->lbr_users || vlbr_exclude_host() ||
+	    cpuc->lbr_users == cpuc->lbr_pebs_users)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
@@ -1365,5 +1386,5 @@ int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
 
 struct event_constraint vlbr_constraint =
-	FIXED_EVENT_CONSTRAINT(INTEL_FIXED_VLBR_EVENT,
-			       (INTEL_PMC_IDX_FIXED_VLBR - INTEL_PMC_IDX_FIXED));
+	__EVENT_CONSTRAINT(INTEL_FIXED_VLBR_EVENT, (1ULL << INTEL_PMC_IDX_FIXED_VLBR),
+			  FIXED_EVENT_FLAGS, 1, 0, PERF_X86_EVENT_LBR_SELECT);
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 77a6dd66bd9a..81475963df99 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -78,6 +78,7 @@ static inline bool constraint_match(struct event_constraint *c, u64 ecode)
 #define PERF_X86_EVENT_LARGE_PEBS	0x0400 /* use large PEBS */
 #define PERF_X86_EVENT_PEBS_VIA_PT	0x0800 /* use PT buffer for PEBS */
 #define PERF_X86_EVENT_PAIR		0x1000 /* Large Increment per Cycle */
+#define PERF_X86_EVENT_LBR_SELECT	0x2000 /* Save/Restore MSR_LBR_SELECT */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -237,6 +238,7 @@ struct cpu_hw_events {
 	u64				br_sel;
 	struct x86_perf_task_context	*last_task_ctx;
 	int				last_log_id;
+	int				lbr_select;
 
 	/*
 	 * Intel host/guest exclude bits
@@ -722,6 +724,7 @@ struct x86_perf_task_context {
 	u64 lbr_from[MAX_LBR_ENTRIES];
 	u64 lbr_to[MAX_LBR_ENTRIES];
 	u64 lbr_info[MAX_LBR_ENTRIES];
+	u64 lbr_sel;
 	int tos;
 	int valid_lbrs;
 	int lbr_callstack_users;
-- 
2.21.3

