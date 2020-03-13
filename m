Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FAC183F17
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 03:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCMCTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 22:19:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:25868 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgCMCTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 22:19:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 19:19:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261743817"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 19:18:59 -0700
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
Subject: [PATCH v9 04/10] perf/x86: Keep LBR stack unchanged on the host for guest LBR event
Date:   Fri, 13 Mar 2020 10:16:10 +0800
Message-Id: <20200313021616.112322-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200313021616.112322-1-like.xu@linux.intel.com>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest wants to use the LBR stack, its hypervisor creates a guest
LBR event and let host perf schedules it. A new 'int guest_lbr_enabled'
field in the "struct cpu_hw_events", is marked as true when perf adds
a guest LBR event and false on deletion.

The LBR stack msrs are accessible to the guest when its guest LBR event
is scheduled in by the perf subsystem. Before scheduling out the event,
we should avoid host changes on IA32_DEBUGCTLMSR or LBR_SELECT. Otherwise,
some unexpected branch operations may interfere with guest behavior,
pollute LBR records, and even cause host branch data leakage. In addition,
the intel_pmu_lbr_read() on the host is also avoidable for guest usage.

On v4 PMU or later, the LBR stack are frozen on the overflowed condition
if Freeze_LBR_On_PMI is true and resume recording via acking LBRS_FROZEN
to global status msr instead of re-enabling IA32_DEBUGCTL.LBR. So when a
guest LBR event is running, the host PMI handler has to keep LBRS_FROZEN
bit set (thus LBR being frozen) until the guest enables it. Otherwise,
when the guest enters non-root mode, the LBR will start recording and
the guest PMI handler code will also pollute the LBR stack.

To ensure that guest LBR records are not lost during the context switch,
the BRANCH_CALL_STACK flag should be configured in the 'branch_sample_type'
for a guest LBR event because a callstack event could save/restore guest
unread records with the help of intel_pmu_lbr_sched_task() naturally.

However, the regular host LBR perf event doesn't save/restore LBR_SELECT,
because it's configured in the LBR_enable() based on branch_sample_type.
So when a guest LBR is running, the guest LBR_SELECT may changes for its
own use and we have to add the LBR_SELECT save/restore to ensure what the
guest LBR_SELECT value doesn't get lost during the context switching.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c | 10 ++++++++++
 arch/x86/events/intel/lbr.c  | 33 ++++++++++++++++++++++++++++++---
 arch/x86/events/perf_event.h |  2 ++
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 901c82032f4a..66a0fedb9948 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2126,6 +2126,16 @@ static inline u64 intel_pmu_get_status(void)
 
 static inline void intel_pmu_ack_status(u64 ack)
 {
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+
+	/*
+	 * When the LBR hardware is scheduled for a guest LBR event,
+	 * it should remain disabled until the guest enables it. Otherwise,
+	 * the guest PMI handler may contaminate the LBR records.
+	 */
+	if (cpuc->guest_lbr_enabled)
+		ack &= ~GLOBAL_STATUS_LBRS_FROZEN;
+
 	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
 }
 
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index ff1f35b4f420..48538702f3f2 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -383,6 +383,15 @@ static void __intel_pmu_lbr_restore(struct x86_perf_task_context *task_ctx)
 
 	wrmsrl(x86_pmu.lbr_tos, tos);
 	task_ctx->lbr_stack_state = LBR_NONE;
+
+	/*
+	 * When the LBR hardware is scheduled for a guest LBR event,
+	 * the guest LBR_sel is likely different from event->hw.branch_reg.
+	 * Therefore, it’s necessary to save/restore MSR_LBR_SELECT written
+	 * by the guest so that it's not lost during the context switch.
+	 */
+	if (cpuc->guest_lbr_enabled)
+		wrmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
 }
 
 static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
@@ -415,6 +424,9 @@ static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
 
 	cpuc->last_task_ctx = task_ctx;
 	cpuc->last_log_id = ++task_ctx->log_id;
+
+	if (cpuc->guest_lbr_enabled)
+		rdmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
 }
 
 void intel_pmu_lbr_swap_task_ctx(struct perf_event_context *prev,
@@ -485,6 +497,9 @@ void intel_pmu_lbr_add(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	if (is_guest_lbr_event(event))
+		cpuc->guest_lbr_enabled = 1;
+
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	if (branch_user_callstack(cpuc->br_sel) && event->ctx->task_ctx_data) {
@@ -532,6 +547,9 @@ void intel_pmu_lbr_del(struct perf_event *event)
 		task_ctx->lbr_callstack_users--;
 	}
 
+	if (is_guest_lbr_event(event))
+		cpuc->guest_lbr_enabled = 0;
+
 	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip > 0)
 		cpuc->lbr_pebs_users--;
 	cpuc->lbr_users--;
@@ -544,7 +562,12 @@ void intel_pmu_lbr_enable_all(bool pmi)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (cpuc->lbr_users)
+	/*
+	 * When the LBR hardware is scheduled for a guest LBR event,
+	 * the guest will dis/enables LBR itself at the appropriate time,
+	 * including configuring MSR_LBR_SELECT.
+	 */
+	if (cpuc->lbr_users && !cpuc->guest_lbr_enabled)
 		__intel_pmu_lbr_enable(pmi);
 }
 
@@ -552,7 +575,7 @@ void intel_pmu_lbr_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (cpuc->lbr_users)
+	if (cpuc->lbr_users && !cpuc->guest_lbr_enabled)
 		__intel_pmu_lbr_disable();
 }
 
@@ -691,8 +714,12 @@ void intel_pmu_lbr_read(void)
 	 *
 	 * This could be smarter and actually check the event,
 	 * but this simple approach seems to work for now.
+	 *
+	 * And there is no need to read lbr here if a guest LBR event
+	 * is using it, because the guest will read them on its own.
 	 */
-	if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
+	if (!cpuc->lbr_users || cpuc->guest_lbr_enabled ||
+		cpuc->lbr_users == cpuc->lbr_pebs_users)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 9a62264a3068..cb7288361f34 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -237,6 +237,7 @@ struct cpu_hw_events {
 	u64				br_sel;
 	struct x86_perf_task_context	*last_task_ctx;
 	int				last_log_id;
+	int				guest_lbr_enabled;
 
 	/*
 	 * Intel host/guest exclude bits
@@ -721,6 +722,7 @@ struct x86_perf_task_context {
 	u64 lbr_from[MAX_LBR_ENTRIES];
 	u64 lbr_to[MAX_LBR_ENTRIES];
 	u64 lbr_info[MAX_LBR_ENTRIES];
+	u64 lbr_sel;
 	int tos;
 	int valid_lbrs;
 	int lbr_callstack_users;
-- 
2.21.1

