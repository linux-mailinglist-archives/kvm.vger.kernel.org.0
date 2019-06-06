Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E88536DB5
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfFFHpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:45:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:25012 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbfFFHoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:41 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:38 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 07/12] perf/x86: no counter allocation support
Date:   Thu,  6 Jun 2019 15:02:26 +0800
Message-Id: <1559804551-42271-8-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
References: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases, an event may be created without needing a counter
allocation. For example, an lbr event may be created by the host
only to help save/restore the lbr stack on the vCPU context switching.

This patch adds a new interface to allow users to create a perf event
without the need of counter assignment.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/events/core.c     | 12 ++++++++++++
 include/linux/perf_event.h | 13 +++++++++++++
 kernel/events/core.c       | 37 +++++++++++++++++++++++++------------
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index f315425..eebbd65 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -410,6 +410,9 @@ int x86_setup_perfctr(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	u64 config;
 
+	if (is_no_counter_event(event))
+		return 0;
+
 	if (!is_sampling_event(event)) {
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
@@ -1248,6 +1251,12 @@ static int x86_pmu_add(struct perf_event *event, int flags)
 	hwc = &event->hw;
 
 	n0 = cpuc->n_events;
+
+	if (is_no_counter_event(event)) {
+		n = n0;
+		goto done_collect;
+	}
+
 	ret = n = collect_events(cpuc, event, false);
 	if (ret < 0)
 		goto out;
@@ -1422,6 +1431,9 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	if (cpuc->txn_flags & PERF_PMU_TXN_ADD)
 		goto do_del;
 
+	if (is_no_counter_event(event))
+		goto do_del;
+
 	/*
 	 * Not a TXN, therefore cleanup properly.
 	 */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0ab99c7..19e6593 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -528,6 +528,7 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *,
  */
 #define PERF_EV_CAP_SOFTWARE		BIT(0)
 #define PERF_EV_CAP_READ_ACTIVE_PKG	BIT(1)
+#define PERF_EV_CAP_NO_COUNTER		BIT(2)
 
 #define SWEVENT_HLIST_BITS		8
 #define SWEVENT_HLIST_SIZE		(1 << SWEVENT_HLIST_BITS)
@@ -895,6 +896,13 @@ extern int perf_event_refresh(struct perf_event *event, int refresh);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
+perf_event_create(struct perf_event_attr *attr,
+		  int cpu,
+		  struct task_struct *task,
+		  perf_overflow_handler_t overflow_handler,
+		  void *context,
+		  bool counter_assignment);
+extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				struct task_struct *task,
@@ -1032,6 +1040,11 @@ static inline bool is_sampling_event(struct perf_event *event)
 	return event->attr.sample_period != 0;
 }
 
+static inline bool is_no_counter_event(struct perf_event *event)
+{
+	return !!(event->event_caps & PERF_EV_CAP_NO_COUNTER);
+}
+
 /*
  * Return 1 for a software event, 0 for a hardware event
  */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index abbd4b3..70884df 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11162,18 +11162,10 @@ SYSCALL_DEFINE5(perf_event_open,
 	return err;
 }
 
-/**
- * perf_event_create_kernel_counter
- *
- * @attr: attributes of the counter to create
- * @cpu: cpu in which the counter is bound
- * @task: task to profile (NULL for percpu)
- */
-struct perf_event *
-perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
-				 struct task_struct *task,
-				 perf_overflow_handler_t overflow_handler,
-				 void *context)
+struct perf_event *perf_event_create(struct perf_event_attr *attr, int cpu,
+				     struct task_struct *task,
+				     perf_overflow_handler_t overflow_handler,
+				     void *context, bool need_counter)
 {
 	struct perf_event_context *ctx;
 	struct perf_event *event;
@@ -11193,6 +11185,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	/* Mark owner so we could distinguish it from user events. */
 	event->owner = TASK_TOMBSTONE;
 
+	if (!need_counter)
+		event->event_caps |= PERF_EV_CAP_NO_COUNTER;
+
 	ctx = find_get_context(event->pmu, task, event);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
@@ -11241,6 +11236,24 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 err:
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL_GPL(perf_event_create);
+
+/**
+ * perf_event_create_kernel_counter
+ *
+ * @attr: attributes of the counter to create
+ * @cpu: cpu in which the counter is bound
+ * @task: task to profile (NULL for percpu)
+ */
+struct perf_event *
+perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
+				 struct task_struct *task,
+				 perf_overflow_handler_t overflow_handler,
+				 void *context)
+{
+	return perf_event_create(attr, cpu, task, overflow_handler,
+				 context, true);
+}
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
 void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
-- 
2.7.4

