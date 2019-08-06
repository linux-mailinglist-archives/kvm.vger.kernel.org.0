Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F101C82D77
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbfHFIGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:06:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:5861 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732338AbfHFIGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:06:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:00:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337365"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:00:52 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 08/14] perf/core: set the event->owner before event_init
Date:   Tue,  6 Aug 2019 15:16:08 +0800
Message-Id: <1565075774-26671-9-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel and user events can be distinguished by checking event->owner. Some
pmu driver implementation may need to know event->owner in event_init. For
example, intel_pmu_setup_lbr_filter treats a kernel event with
exclude_host set as an lbr event created for guest lbr emulation, which
doesn't need a pmu counter.

So move the event->owner assignment into perf_event_alloc to have it
set before event_init is called.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 kernel/events/core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0463c11..7663f85 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10288,6 +10288,7 @@ static void account_event(struct perf_event *event)
 static struct perf_event *
 perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct task_struct *task,
+		 struct task_struct *owner,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
 		 perf_overflow_handler_t overflow_handler,
@@ -10340,6 +10341,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	event->group_leader	= group_leader;
 	event->pmu		= NULL;
 	event->oncpu		= -1;
+	event->owner		= owner;
 
 	event->parent		= parent_event;
 
@@ -10891,7 +10893,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & PERF_FLAG_PID_CGROUP)
 		cgroup_fd = pid;
 
-	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
+	event = perf_event_alloc(&attr, cpu, task, current, group_leader, NULL,
 				 NULL, NULL, cgroup_fd);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
@@ -11153,8 +11155,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	perf_event__header_size(event);
 	perf_event__id_header_size(event);
 
-	event->owner = current;
-
 	perf_install_in_context(ctx, event, event->cpu);
 	perf_unpin_context(ctx);
 
@@ -11231,16 +11231,13 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
+	event = perf_event_alloc(attr, cpu, task, TASK_TOMBSTONE, NULL, NULL,
 				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
 	}
 
-	/* Mark owner so we could distinguish it from user events. */
-	event->owner = TASK_TOMBSTONE;
-
 	ctx = find_get_context(event->pmu, task, event);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
@@ -11677,6 +11674,7 @@ inherit_event(struct perf_event *parent_event,
 
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu,
+					   parent_event->owner,
 					   child,
 					   group_leader, parent_event,
 					   NULL, NULL, -1);
-- 
2.7.4

