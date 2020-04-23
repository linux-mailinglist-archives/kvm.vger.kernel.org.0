Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3201B5720
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgDWIR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:17:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:57581 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgDWIRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:17:54 -0400
IronPort-SDR: 5blI6zXFn/zAdc+W8tDKjmy1VlDPhalfkcOT8Ejt5UAuzU+IHXFEjvSycN+Wjvr2oZzLbHVG8x
 +WOgmclKzlzw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:17:52 -0700
IronPort-SDR: Ku4dDri1afvbHVU3DUjJEi8iHFGuvatkjDOk2Gtrxhcmc3mIC0//zr4NKb4lJde092wJOB7aYb
 w0Ay/MKuSA8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910076"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:17:49 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com, Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v10 05/11] perf/x86: Keep LBR stack unchanged in host context for guest LBR event
Date:   Thu, 23 Apr 2020 16:14:06 +0800
Message-Id: <20200423081412.164863-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest wants to use the LBR stack, its hypervisor creates a guest
LBR event and let host perf schedules it. A new 'int guest_lbr_enabled'
field in the 'struct cpu_hw_events', is marked as true when perf adds
a guest LBR event and marked as false on deletion.

The LBR stack msrs are accessible to the guest when its guest LBR event
is scheduled in by the perf subsystem. Before scheduling this event out,
we should avoid host changes on IA32_DEBUGCTLMSR or LBR_SELECT.
Otherwise, some unexpected branch operations may interfere with guest
behavior, pollute LBR records, and even cause host branch data leakage.
In addition, the intel_pmu_lbr_read() on the host is also avoidable.

To ensure that guest LBR records are not lost during the context switch,
the BRANCH_CALL_STACK flag should be configured in the 'branch_sample_type'
for any guest LBR event because the callstack mode could save/restore guest
unread LBR records with the help of intel_pmu_lbr_sched_task() naturally.

However, the regular host LBR perf event doesn't save/restore LBR_SELECT,
because it's configured in the LBR_enable() based on branch_sample_type.
So when a guest LBR is running, the guest LBR_SELECT may changes for its
own use and we have to support LBR_SELECT save/restore to ensure what the
guest LBR_SELECT value doesn't get lost during the context switching.

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/lbr.c  | 33 ++++++++++++++++++++++++++++++---
 arch/x86/events/perf_event.h |  2 ++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 2fca4aff7621..44bb7db6ce02 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -383,6 +383,15 @@ static void __intel_pmu_lbr_restore(struct x86_perf_task_context *task_ctx)
 
 	wrmsrl(x86_pmu.lbr_tos, tos);
 	task_ctx->lbr_stack_state = LBR_NONE;
+
+	/*
+	 * When the LBR hardware is scheduled for a guest LBR event,
+	 * the guest lbr_sel is likely different from event->hw.branch_reg.
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
 
+	if (needs_guest_lbr_without_counter(event))
+		cpuc->guest_lbr_enabled = 1;
+
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	if (branch_user_callstack(cpuc->br_sel) && event->ctx->task_ctx_data) {
@@ -532,6 +547,9 @@ void intel_pmu_lbr_del(struct perf_event *event)
 		task_ctx->lbr_callstack_users--;
 	}
 
+	if (needs_guest_lbr_without_counter(event))
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
 
@@ -693,8 +716,12 @@ void intel_pmu_lbr_read(void)
 	 *
 	 * This could be smarter and actually check the event,
 	 * but this simple approach seems to work for now.
+	 *
+	 * And there is no need to read LBR record here if a guest LBR
+	 * event is using it, because the guest will read them on its own.
 	 */
-	if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
+	if (!cpuc->lbr_users || cpuc->guest_lbr_enabled ||
+	    cpuc->lbr_users == cpuc->lbr_pebs_users)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index e6e8c626ed00..cfd0ba25cac6 100644
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

