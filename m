Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499521D780D
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 13:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgERL7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 07:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgERL7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 07:59:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8917C061A0C;
        Mon, 18 May 2020 04:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xQHGR34Vxc0nHTxCLtZHa0MSq+HYVOsVZrpYxr/SvNA=; b=MULmkb7vDN4xSvMBHhCvTm4ZO+
        zp27RmBhA+ovcozX2ib0ljHRAJXdPC8ORH+hRPR/423fGfP/PrnbyGmXUwRXNEbsi4GLIkJ8iadTf
        l7otTrMcuP+dLA6YfHArOtzbBXmZ4ZBhA6GrofVFrLijvBAW8NVWBvbBcTp3CdM6U5eOt2kg1t+JH
        d4E2bKFlDOPddCr7Gagst2myRo73jpVphVVw3Y55n2zuVO7e3GDSCvHFHqMpQs0ekG+FHOziBqtz9
        IjlQ2VuaftFlhFYJ+SJXXyebhJoQluOWLOnR772CmwxfWHNDa5ZdvtuF7Fp9veJ7jUjj5bulCFrKS
        5CnyuDhg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaeQJ-0002pe-1N; Mon, 18 May 2020 11:59:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AD3A83011F0;
        Mon, 18 May 2020 13:59:08 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 984892B3D079C; Mon, 18 May 2020 13:59:08 +0200 (CEST)
Date:   Mon, 18 May 2020 13:59:08 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v11 05/11] perf/x86: Keep LBR stack unchanged in host
 context for guest LBR event
Message-ID: <20200518115908.GE277222@hirez.programming.kicks-ass.net>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-6-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514083054.62538-6-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Subject: perf/x86: Keep LBR stack unchanged in host context for guest LBR event
From: Like Xu <like.xu@linux.intel.com>
Date: Thu, 14 May 2020 16:30:48 +0800

From: Like Xu <like.xu@linux.intel.com>

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

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200514083054.62538-6-like.xu@linux.intel.com
---
 arch/x86/events/intel/lbr.c  |   16 ++++++++++++++--
 arch/x86/events/perf_event.h |    3 +++
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -383,6 +383,9 @@ static void __intel_pmu_lbr_restore(stru
 
 	wrmsrl(x86_pmu.lbr_tos, tos);
 	task_ctx->lbr_stack_state = LBR_NONE;
+
+	if (cpuc->lbr_select)
+		wrmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
 }
 
 static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
@@ -415,6 +418,9 @@ static void __intel_pmu_lbr_save(struct
 
 	cpuc->last_task_ctx = task_ctx;
 	cpuc->last_log_id = ++task_ctx->log_id;
+
+	if (cpuc->lbr_select)
+		rdmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
 }
 
 void intel_pmu_lbr_swap_task_ctx(struct perf_event_context *prev,
@@ -485,6 +491,9 @@ void intel_pmu_lbr_add(struct perf_event
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	if (event->hw.flags & PERF_X86_EVENT_LBR_SELECT)
+		cpuc->lbr_select = 1;
+
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	if (branch_user_callstack(cpuc->br_sel) && event->ctx->task_ctx_data) {
@@ -532,6 +541,9 @@ void intel_pmu_lbr_del(struct perf_event
 		task_ctx->lbr_callstack_users--;
 	}
 
+	if (event->hw.flags & PERF_X86_EVENT_LBR_SELECT)
+		cpuc->lbr_select = 0;
+
 	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip > 0)
 		cpuc->lbr_pebs_users--;
 	cpuc->lbr_users--;
@@ -1365,5 +1377,5 @@ int x86_perf_get_lbr(struct x86_pmu_lbr
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
 
 struct event_constraint vlbr_constraint =
-	FIXED_EVENT_CONSTRAINT(INTEL_FIXED_VLBR_EVENT,
-			       (INTEL_PMC_IDX_FIXED_VLBR - INTEL_PMC_IDX_FIXED));
+	__EVENT_CONSTRAINT(INTEL_FIXED_VLBR_EVENT, (1ULL << INTEL_PMC_IDX_FIXED_VLBR),
+			  FIXED_EVENT_FLAGS, 1, 0, PERF_X86_EVENT_LBR_SELECT);
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -78,6 +78,7 @@ static inline bool constraint_match(stru
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
