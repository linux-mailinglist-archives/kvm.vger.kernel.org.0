Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE397AF94E
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjI0EZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjI0EXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:23:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9189C140CD;
        Tue, 26 Sep 2023 20:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695785074; x=1727321074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kF4DhZt8pErot/RT4yIRmpZuAvHJlxj64wy/EpFCWTQ=;
  b=A7ITNZhR0WyeYjmCqdxKo8ktMntAcwpCPi3wE3GGELbViwwPr+qW/gDc
   BQpWTHzRa62rHcAYur94xQmZiByg0egwLfiXvfq8IxbgQqf1XBaviOs9W
   O5IYnLC+AOWzmZdFyaBvF0udZmgqihdjWCpWqoIAO2JaNvfrRtT9Kj0Us
   //LXYmyXAtVrkPgdFIiLRWwrzceTMoQNzRuN2TxbgPlF8xmnBq/M0pm5r
   yE45h6m1rN5xjzBPUx0cAScsIW1ZHI2RN0x2ayNKhzhsmSq7XbW7llN+R
   9D8+asnAjTo/9Lkkgq0EbM+bFYlorzrpwHcVqhw0be0WK4BvZEIe479A/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="366780778"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="366780778"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:24:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864637104"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864637104"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2023 20:24:29 -0700
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
Subject: [Patch v4 04/13] perf/core: Add function perf_event_move_group()
Date:   Wed, 27 Sep 2023 11:31:15 +0800
Message-Id: <20230927033124.1226509-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index d485dac2b55f..953e3d3a1664 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12388,6 +12388,48 @@ static int perf_event_group_leader_check(struct perf_event *group_leader,
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
@@ -12403,7 +12445,7 @@ SYSCALL_DEFINE5(perf_event_open,
 {
 	struct perf_event *group_leader = NULL, *output_event = NULL;
 	struct perf_event_pmu_context *pmu_ctx;
-	struct perf_event *event, *sibling;
+	struct perf_event *event;
 	struct perf_event_attr attr;
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
@@ -12635,42 +12677,8 @@ SYSCALL_DEFINE5(perf_event_open,
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

