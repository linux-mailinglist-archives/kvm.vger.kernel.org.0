Return-Path: <kvm+bounces-7089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EFD783D653
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:30:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A9D4B29C74
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0661512DD86;
	Fri, 26 Jan 2024 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OZnyiE8A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575CF12CDBB;
	Fri, 26 Jan 2024 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259347; cv=none; b=WRFOgiEd6EXZVL02zR+b1fU9O1Pt1gx2q2lC36ba/xmiwwIDqEYIMfM0KSsvIXFqJi7y57yl8W31bTkfpSCnCI+m+IRY+JIqvhVW0frabBpLDBTLLTe25VLWTt8HtVjv7bSFbXzgqv0IU7xfdiyTy1bCC5Ie2iYySpiG86d1j8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259347; c=relaxed/simple;
	bh=2diU2bBu2DJ9zg6Lx1y8mhTFW+B/rdOx/BQIiIlk6EI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nQSzq+z+3yPhlH6d2B+mfFLIug4IgZ1Lk6f40In7AuWcfjpwlA9MUB1Xg7rVIxRcCRhTZ24RAEagvLUBY65Mlx7WTdjqUOz/Kwkmpli7PiJLIENDqb6xY9XDqRTJoBRmFDb9zeol8/mM8/QRMf3PbS81Cv8ccFmbbnodE4oh61A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OZnyiE8A; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259345; x=1737795345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2diU2bBu2DJ9zg6Lx1y8mhTFW+B/rdOx/BQIiIlk6EI=;
  b=OZnyiE8AXLL5jcOGm0Ut6u3OK0mIkXL/7rqHjPzmKv68VXu8e12EADOL
   JvcE5fGZOF/n0nhCthAxZ86VOuMvAtDfD9kxCxjydcp+lxrB97VaGR9zK
   3RA+NFu2/UZRYZiT0p3XwV8Fe0niyTMBvkPcB4pg1NKE4kyEgzzZC2tz2
   WM7M8ZXSu/yyE4C5rLW1p1BcyeaN3VcRhhm0udz4BlLxYZ8Cgeq1JbjR8
   FhEpoIa2nJFr3cgiyAEp9gESIe2Imv8X1Wflhix6KOBB23pFxqfes6ZVu
   cvol514VCuzJG5Q8Vq8/yCymEJKuy+fFI9UEczlOMtq27FkNUpxOmF0Sy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792050"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792050"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309794"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309794"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:39 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
Date: Fri, 26 Jan 2024 16:54:05 +0800
Message-Id: <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

Currently, the guest and host share the PMU resources when a guest is
running. KVM has to create an extra virtual event to simulate the
guest's event, which brings several issues, e.g., high overhead, not
accuracy and etc.

A new pass-through method is proposed to address the issue. It requires
that the PMU resources can be fully occupied by the guest while it's
running. Two new interfaces are implemented to fulfill the requirement.
The hypervisor should invoke the interface while entering/exiting a
guest which wants the pass-through PMU capability.

The PMU resources should only be temporarily occupied when a guest is
running. When the guest is out, the PMU resources are still shared among
different users.

The exclude_guest event modifier is used to guarantee the exclusive
occupation of the PMU resources. When a guest enters, perf forces the
exclude_guest capability. If the pre-existing events with
!exclude_guest, the events are moved to the error state. The new
event-creation of the !exclude_guest event will error out during the
period. So the PMU resources can be safely accessed by the guest
directly.
https://lore.kernel.org/lkml/20231002204017.GB27267@noisy.programming.kicks-ass.net/

Not all PMUs support exclude_guest and vPMU pass-through, e.g., uncore
PMU and SW PMU. The guest enter/exit interfaces should only impact the
supported PMUs. Add a new PERF_PMU_CAP_VPMU_PASSTHROUGH flag to indicate
the PMUs that support the feature.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 include/linux/perf_event.h |   9 ++
 kernel/events/core.c       | 174 +++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 60eff413dbba..9912d1112371 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1392,6 +1392,11 @@ static inline int is_exclusive_pmu(struct pmu *pmu)
 	return pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE;
 }
 
+static inline int has_vpmu_passthrough_cap(struct pmu *pmu)
+{
+	return pmu->capabilities & PERF_PMU_CAP_VPMU_PASSTHROUGH;
+}
+
 extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void ___perf_sw_event(u32, u64, struct pt_regs *, u64);
@@ -1709,6 +1714,8 @@ extern void perf_event_task_tick(void);
 extern int perf_event_account_interrupt(struct perf_event *event);
 extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
+extern void perf_guest_enter(void);
+extern void perf_guest_exit(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1795,6 +1802,8 @@ static inline u64 perf_event_pause(struct perf_event *event, bool reset)
 {
 	return 0;
 }
+static inline void perf_guest_enter(void)				{ }
+static inline void perf_guest_exit(void)				{ }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 683dc086ef10..59471eeec7e4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3803,6 +3803,8 @@ static inline void group_update_userpage(struct perf_event *group_event)
 		event_update_userpage(event);
 }
 
+static DEFINE_PER_CPU(bool, __perf_force_exclude_guest);
+
 static int merge_sched_in(struct perf_event *event, void *data)
 {
 	struct perf_event_context *ctx = event->ctx;
@@ -3814,6 +3816,14 @@ static int merge_sched_in(struct perf_event *event, void *data)
 	if (!event_filter_match(event))
 		return 0;
 
+	/*
+	 * The __perf_force_exclude_guest indicates entering the guest.
+	 * No events of the passthrough PMU should be scheduled.
+	 */
+	if (__this_cpu_read(__perf_force_exclude_guest) &&
+	    has_vpmu_passthrough_cap(event->pmu))
+		return 0;
+
 	if (group_can_go_on(event, *can_add_hw)) {
 		if (!group_sched_in(event, ctx))
 			list_add_tail(&event->active_list, get_event_list(event));
@@ -5707,6 +5717,165 @@ u64 perf_event_pause(struct perf_event *event, bool reset)
 }
 EXPORT_SYMBOL_GPL(perf_event_pause);
 
+static void __perf_force_exclude_guest_pmu(struct perf_event_pmu_context *pmu_ctx,
+					   struct perf_event *event)
+{
+	struct perf_event_context *ctx = pmu_ctx->ctx;
+	struct perf_event *sibling;
+	bool include_guest = false;
+
+	event_sched_out(event, ctx);
+	if (!event->attr.exclude_guest)
+		include_guest = true;
+	for_each_sibling_event(sibling, event) {
+		event_sched_out(sibling, ctx);
+		if (!sibling->attr.exclude_guest)
+			include_guest = true;
+	}
+	if (include_guest) {
+		perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
+		for_each_sibling_event(sibling, event)
+			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
+	}
+}
+
+static void perf_force_exclude_guest_pmu(struct perf_event_pmu_context *pmu_ctx)
+{
+	struct perf_event *event, *tmp;
+	struct pmu *pmu = pmu_ctx->pmu;
+
+	perf_pmu_disable(pmu);
+
+	/*
+	 * Sched out all active events.
+	 * For the !exclude_guest events, they are forced to be sched out and
+	 * moved to the error state.
+	 * For the exclude_guest events, they should be scheduled out anyway
+	 * when the guest is running.
+	 */
+	list_for_each_entry_safe(event, tmp, &pmu_ctx->pinned_active, active_list)
+		__perf_force_exclude_guest_pmu(pmu_ctx, event);
+
+	list_for_each_entry_safe(event, tmp, &pmu_ctx->flexible_active, active_list)
+		__perf_force_exclude_guest_pmu(pmu_ctx, event);
+
+	pmu_ctx->rotate_necessary = 0;
+
+	perf_pmu_enable(pmu);
+}
+
+static void perf_force_exclude_guest_enter(struct perf_event_context *ctx)
+{
+	struct perf_event_pmu_context *pmu_ctx;
+
+	update_context_time(ctx);
+	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
+		/*
+		 * The PMU, which doesn't have the capability of excluding guest
+		 * e.g., uncore PMU, is not impacted.
+		 */
+		if (!has_vpmu_passthrough_cap(pmu_ctx->pmu))
+			continue;
+		perf_force_exclude_guest_pmu(pmu_ctx);
+	}
+}
+
+/*
+ * When a guest enters, force all active events of the PMU, which supports
+ * the VPMU_PASSTHROUGH feature, to be scheduled out. The events of other
+ * PMUs, such as uncore PMU, should not be impacted. The guest can
+ * temporarily own all counters of the PMU.
+ * During the period, all the creation of the new event of the PMU with
+ * !exclude_guest are error out.
+ */
+void perf_guest_enter(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	if (__this_cpu_read(__perf_force_exclude_guest))
+		return;
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+	perf_force_exclude_guest_enter(&cpuctx->ctx);
+	if (cpuctx->task_ctx)
+		perf_force_exclude_guest_enter(cpuctx->task_ctx);
+
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+
+	__this_cpu_write(__perf_force_exclude_guest, true);
+}
+EXPORT_SYMBOL_GPL(perf_guest_enter);
+
+static void perf_force_exclude_guest_exit(struct perf_event_context *ctx)
+{
+	struct perf_event_pmu_context *pmu_ctx;
+	struct pmu *pmu;
+
+	update_context_time(ctx);
+	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
+		pmu = pmu_ctx->pmu;
+		if (!has_vpmu_passthrough_cap(pmu))
+			continue;
+
+		perf_pmu_disable(pmu);
+		pmu_groups_sched_in(ctx, &ctx->pinned_groups, pmu);
+		pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu);
+		perf_pmu_enable(pmu);
+	}
+}
+
+void perf_guest_exit(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	if (!__this_cpu_read(__perf_force_exclude_guest))
+		return;
+
+	__this_cpu_write(__perf_force_exclude_guest, false);
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+	perf_force_exclude_guest_exit(&cpuctx->ctx);
+	if (cpuctx->task_ctx)
+		perf_force_exclude_guest_exit(cpuctx->task_ctx);
+
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+}
+EXPORT_SYMBOL_GPL(perf_guest_exit);
+
+static inline int perf_force_exclude_guest_check(struct perf_event *event,
+						 int cpu, struct task_struct *task)
+{
+	bool *force_exclude_guest = NULL;
+
+	if (!has_vpmu_passthrough_cap(event->pmu))
+		return 0;
+
+	if (event->attr.exclude_guest)
+		return 0;
+
+	if (cpu != -1) {
+		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, cpu);
+	} else if (task && (task->flags & PF_VCPU)) {
+		/*
+		 * Just need to check the running CPU in the event creation. If the
+		 * task is moved to another CPU which supports the force_exclude_guest.
+		 * The event will filtered out and be moved to the error stage. See
+		 * merge_sched_in().
+		 */
+		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, task_cpu(task));
+	}
+
+	if (force_exclude_guest && *force_exclude_guest)
+		return -EBUSY;
+	return 0;
+}
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
@@ -11973,6 +12142,11 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		goto err_ns;
 	}
 
+	if (perf_force_exclude_guest_check(event, cpu, task)) {
+		err = -EBUSY;
+		goto err_pmu;
+	}
+
 	/*
 	 * Disallow uncore-task events. Similarly, disallow uncore-cgroup
 	 * events (they don't make sense as the cgroup will be different
-- 
2.34.1


