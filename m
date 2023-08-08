Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CF47746D0
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjHHTCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbjHHTBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:01:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C745187EB0;
        Tue,  8 Aug 2023 10:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691515899; x=1723051899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v2TBA06nKy1Tjy6kQhxIeqPQoJIb6eI5+/NRpk5Kagw=;
  b=FaCNBzbTwFWhkl/78MOtcK+M2XR3pmGMrQEJT3vLf7OkZmm1mwOgLNPH
   pz58ek8JCbt6dvReUgRQrQkpNL8xp8+J0U96H6K08xltOdTFlR/9ihdw0
   L9qVq6pTUnkfmypNlzlQhWwEH9UrLWs2ZdVBTQKdAfTDN8vJiAU7tpCBp
   S0U//fgCwOpXl4wSJ0HkwkmgArYxwfQG28eB7JVFO3BdF2A7c+IXcprHJ
   miRP3eTdvXOl6n8QgF0q1w6hAXy+mg0xiaF2jWlwiXYRE/ypcpQMU1omH
   l9dcIlyONEokgUt5oCA6OF15U1nOFvghbzznlnXbLMywy7fCvX/QuLj+h
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434582015"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="434582015"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 23:26:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734377719"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734377719"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2023 23:26:40 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH RFV v2 05/13] perf/core: Add function perf_event_create_group_kernel_counters()
Date:   Tue,  8 Aug 2023 14:31:03 +0800
Message-Id: <20230808063111.1870070-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
References: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add function perf_event_create_group_kernel_counters() which can be used
to create group perf events from kernel space.

Comparing with modifying function perf_event_create_kernel_counter()
directly to support create group events, creating a new function looks a
better method since function perf_event_create_kernel_counter() is called
by many places in kernel and modifying directly this function introduces
lots of changes.

Kernel space may want to create group events just like user space perf
tool does. One example is to support topdown metrics feature in KVM.

Current perf logic requires perf tool creates an perf events group to
handle the topdown metrics profiling. The events group couples one slots
event acting as group leader and multiple metric events.

To support topdown metrics feature in KVM, KVM has to follow this
requirement to create the events group from kernel space. That's why we
need to add this new function.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 include/linux/perf_event.h |  6 ++++++
 kernel/events/core.c       | 39 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2166a69e3bf2..e95152531f4c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1104,6 +1104,12 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				struct task_struct *task,
 				perf_overflow_handler_t callback,
 				void *context);
+extern struct perf_event *
+perf_event_create_group_kernel_counters(struct perf_event_attr *attr,
+					int cpu, struct task_struct *task,
+					struct perf_event *group_leader,
+					perf_overflow_handler_t overflow_handler,
+					void *context);
 extern void perf_pmu_migrate_context(struct pmu *pmu,
 				int src_cpu, int dst_cpu);
 int perf_event_read_local(struct perf_event *event, u64 *value,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 15eb82d1a010..1877171e9590 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12762,11 +12762,34 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 				 struct task_struct *task,
 				 perf_overflow_handler_t overflow_handler,
 				 void *context)
+{
+	return perf_event_create_group_kernel_counters(attr, cpu, task,
+			NULL, overflow_handler, context);
+}
+EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
+
+/**
+ * perf_event_create_group_kernel_counters
+ *
+ * @attr: attributes of the counter to create
+ * @cpu: cpu in which the counter is bound
+ * @task: task to profile (NULL for percpu)
+ * @group_leader: the group leader event of the created event
+ * @overflow_handler: callback to trigger when we hit the event
+ * @context: context data could be used in overflow_handler callback
+ */
+struct perf_event *
+perf_event_create_group_kernel_counters(struct perf_event_attr *attr,
+					int cpu, struct task_struct *task,
+					struct perf_event *group_leader,
+					perf_overflow_handler_t overflow_handler,
+					void *context)
 {
 	struct perf_event_pmu_context *pmu_ctx;
 	struct perf_event_context *ctx;
 	struct perf_event *event;
 	struct pmu *pmu;
+	int move_group = 0;
 	int err;
 
 	/*
@@ -12776,7 +12799,11 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	if (attr->aux_output)
 		return ERR_PTR(-EINVAL);
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
+	if (task && group_leader &&
+	    group_leader->attr.inherit != attr->inherit)
+		return ERR_PTR(-EINVAL);
+
+	event = perf_event_alloc(attr, cpu, task, group_leader, NULL,
 				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
@@ -12806,6 +12833,11 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err_unlock;
 	}
 
+	err = perf_event_group_leader_check(group_leader, event, attr, ctx,
+					    &pmu, &move_group);
+	if (err)
+		goto err_unlock;
+
 	pmu_ctx = find_get_pmu_context(pmu, ctx, event);
 	if (IS_ERR(pmu_ctx)) {
 		err = PTR_ERR(pmu_ctx);
@@ -12833,6 +12865,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err_pmu_ctx;
 	}
 
+	if (move_group)
+		perf_event_move_group(group_leader, pmu_ctx, ctx);
+
 	perf_install_in_context(ctx, event, event->cpu);
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
@@ -12851,7 +12886,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 err:
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
+EXPORT_SYMBOL_GPL(perf_event_create_group_kernel_counters);
 
 static void __perf_pmu_remove(struct perf_event_context *ctx,
 			      int cpu, struct pmu *pmu,
-- 
2.34.1

