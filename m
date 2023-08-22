Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BB7783900
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjHVFEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbjHVFEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:04:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416F81A5;
        Mon, 21 Aug 2023 22:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692680652; x=1724216652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7C56/gt/RGvreA0L41MZxGhb9elLWu8ezfqy+Cf9NVY=;
  b=h2HjlYv52c9hY4CpO79OQfpyXKmx0MvZfjaqJ9pi/5I5y5bvkjFYX5dr
   OYJvx5lh8QOj3GqWclDBQnlQx5lsRiwLHWDRlMROR/bEiQURkdozddUta
   v6A+of6wmKTwDfp4eIh9Pbjc0qefc2qrLGaGST+IutdJvYrebWQDiJIbq
   rQBYoIfHyR44roCg67sgcNPHqs37R70q5O10GKS3uofnbAZSSUKKZaKav
   /qxrt01gXGed+744vrUy2hVkIhdfJIxcyQ216AR2GXpIV8hnKo2MEzyau
   Iot8iVOUC7p3nG+9OOAYVQeQggQLspTAdINMibX6BOVV85vdPTWhoDiI6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440146528"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440146528"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 22:04:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982736736"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982736736"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2023 22:04:06 -0700
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
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH RFC v3 04/13] perf/core: Add function perf_event_move_group()
Date:   Tue, 22 Aug 2023 13:11:31 +0800
Message-Id: <20230822051140.512879-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
References: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
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

Extract the group moving code in function sys_perf_event_open() to create
a new function perf_event_move_group().

The subsequent change would add a new function
perf_event_create_group_kernel_counters() which is used to create group
events in kernel space. The function also needs to do same group moving
for group leader event just like function sys_perf_event_open() does. So
extract the moving code into a separate function to avoid the code
duplication.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 kernel/events/core.c | 82 ++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 616391158d7c..15eb82d1a010 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12399,6 +12399,48 @@ static int perf_event_group_leader_check(struct perf_event *group_leader,
 	return 0;
 }
 
+static void perf_event_move_group(struct perf_event *group_leader,
+				  struct perf_event_pmu_context *pmu_ctx,
+				  struct perf_event_context *ctx)
+{
+	struct perf_event *sibling;
+
+	perf_remove_from_context(group_leader, 0);
+	put_pmu_ctx(group_leader->pmu_ctx);
+
+	for_each_sibling_event(sibling, group_leader) {
+		perf_remove_from_context(sibling, 0);
+		put_pmu_ctx(sibling->pmu_ctx);
+	}
+
+	/*
+	 * Install the group siblings before the group leader.
+	 *
+	 * Because a group leader will try and install the entire group
+	 * (through the sibling list, which is still in-tact), we can
+	 * end up with siblings installed in the wrong context.
+	 *
+	 * By installing siblings first we NO-OP because they're not
+	 * reachable through the group lists.
+	 */
+	for_each_sibling_event(sibling, group_leader) {
+		sibling->pmu_ctx = pmu_ctx;
+		get_pmu_ctx(pmu_ctx);
+		perf_event__state_init(sibling);
+		perf_install_in_context(ctx, sibling, sibling->cpu);
+	}
+
+	/*
+	 * Removing from the context ends up with disabled
+	 * event. What we want here is event in the initial
+	 * startup state, ready to be add into new context.
+	 */
+	group_leader->pmu_ctx = pmu_ctx;
+	get_pmu_ctx(pmu_ctx);
+	perf_event__state_init(group_leader);
+	perf_install_in_context(ctx, group_leader, group_leader->cpu);
+}
+
 /**
  * sys_perf_event_open - open a performance event, associate it to a task/cpu
  *
@@ -12414,7 +12456,7 @@ SYSCALL_DEFINE5(perf_event_open,
 {
 	struct perf_event *group_leader = NULL, *output_event = NULL;
 	struct perf_event_pmu_context *pmu_ctx;
-	struct perf_event *event, *sibling;
+	struct perf_event *event;
 	struct perf_event_attr attr;
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
@@ -12646,42 +12688,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * where we start modifying current state.
 	 */
 
-	if (move_group) {
-		perf_remove_from_context(group_leader, 0);
-		put_pmu_ctx(group_leader->pmu_ctx);
-
-		for_each_sibling_event(sibling, group_leader) {
-			perf_remove_from_context(sibling, 0);
-			put_pmu_ctx(sibling->pmu_ctx);
-		}
-
-		/*
-		 * Install the group siblings before the group leader.
-		 *
-		 * Because a group leader will try and install the entire group
-		 * (through the sibling list, which is still in-tact), we can
-		 * end up with siblings installed in the wrong context.
-		 *
-		 * By installing siblings first we NO-OP because they're not
-		 * reachable through the group lists.
-		 */
-		for_each_sibling_event(sibling, group_leader) {
-			sibling->pmu_ctx = pmu_ctx;
-			get_pmu_ctx(pmu_ctx);
-			perf_event__state_init(sibling);
-			perf_install_in_context(ctx, sibling, sibling->cpu);
-		}
-
-		/*
-		 * Removing from the context ends up with disabled
-		 * event. What we want here is event in the initial
-		 * startup state, ready to be add into new context.
-		 */
-		group_leader->pmu_ctx = pmu_ctx;
-		get_pmu_ctx(pmu_ctx);
-		perf_event__state_init(group_leader);
-		perf_install_in_context(ctx, group_leader, group_leader->cpu);
-	}
+	if (move_group)
+		perf_event_move_group(group_leader, pmu_ctx, ctx);
 
 	/*
 	 * Precalculate sample_data sizes; do while holding ctx::mutex such
-- 
2.34.1

