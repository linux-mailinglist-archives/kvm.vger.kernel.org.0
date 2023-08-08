Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918827746CF
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbjHHTCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbjHHTBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:01:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252A58DCDA;
        Tue,  8 Aug 2023 10:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691515898; x=1723051898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O8pf7f7oxoXEvzdcueT5j+AnOqZhPfLnr6A/Hm2lt40=;
  b=MnR6ttFqU/yBONXExwo7HPpz4k62UzQHpaSzXS0VjcYQTkZnynRKpv+t
   TM7Vu9ilFSoxsz2XwMdWnsHsZC88YJMx9tBCxu3bRZ1ngHQhHuHv3U0I3
   4R1acUNy5zY/eVwes8vebLeEMD0POoLWVkXKWmDWVlQrakCAwdGxFIw9D
   AtszYK7i/QSTpfwh/jv5a1BjMhPhbc6sx17BpDol6otH2frBFPZjYJtwm
   JRoyEUHS2ZQkp461l/zXyRejSli0ERphQMtAII/g9gVxK16Jf0MrHndHe
   Bvc5sChVf4P6oj6/weQYgTkLvQoSCyu8X/ephhg2YqUupbDNLp/4Hzi1h
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434581921"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="434581921"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 23:26:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734377629"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734377629"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2023 23:26:12 -0700
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
Subject: [PATCH RFV v2 03/13] perf/core: Add function perf_event_group_leader_check()
Date:   Tue,  8 Aug 2023 14:31:01 +0800
Message-Id: <20230808063111.1870070-4-dapeng1.mi@linux.intel.com>
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

Extract the group leader checking code in function sys_perf_event_open()
to create a new function perf_event_group_leader_check().

The subsequent change would add a new function
perf_event_create_group_kernel_counters() which is used to create group
events in kernel space. The function also needs to do same check for group
leader event just like function sys_perf_event_open() does. So extract
the checking code into a separate function and avoid the code
duplication.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 kernel/events/core.c | 143 +++++++++++++++++++++++--------------------
 1 file changed, 78 insertions(+), 65 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 78ae7b6f90fd..616391158d7c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12324,6 +12324,81 @@ perf_check_permission(struct perf_event_attr *attr, struct task_struct *task)
 	return is_capable || ptrace_may_access(task, ptrace_mode);
 }
 
+static int perf_event_group_leader_check(struct perf_event *group_leader,
+					 struct perf_event *event,
+					 struct perf_event_attr *attr,
+					 struct perf_event_context *ctx,
+					 struct pmu **pmu,
+					 int *move_group)
+{
+	if (!group_leader)
+		return 0;
+
+	/*
+	 * Do not allow a recursive hierarchy (this new sibling
+	 * becoming part of another group-sibling):
+	 */
+	if (group_leader->group_leader != group_leader)
+		return -EINVAL;
+
+	/* All events in a group should have the same clock */
+	if (group_leader->clock != event->clock)
+		return -EINVAL;
+
+	/*
+	 * Make sure we're both events for the same CPU;
+	 * grouping events for different CPUs is broken; since
+	 * you can never concurrently schedule them anyhow.
+	 */
+	if (group_leader->cpu != event->cpu)
+		return -EINVAL;
+
+	/*
+	 * Make sure we're both on the same context; either task or cpu.
+	 */
+	if (group_leader->ctx != ctx)
+		return -EINVAL;
+
+	/*
+	 * Only a group leader can be exclusive or pinned
+	 */
+	if (attr->exclusive || attr->pinned)
+		return -EINVAL;
+
+	if (is_software_event(event) &&
+	    !in_software_context(group_leader)) {
+		/*
+		 * If the event is a sw event, but the group_leader
+		 * is on hw context.
+		 *
+		 * Allow the addition of software events to hw
+		 * groups, this is safe because software events
+		 * never fail to schedule.
+		 *
+		 * Note the comment that goes with struct
+		 * perf_event_pmu_context.
+		 */
+		*pmu = group_leader->pmu_ctx->pmu;
+	} else if (!is_software_event(event)) {
+		if (is_software_event(group_leader) &&
+		    (group_leader->group_caps & PERF_EV_CAP_SOFTWARE)) {
+			/*
+			 * In case the group is a pure software group, and we
+			 * try to add a hardware event, move the whole group to
+			 * the hardware context.
+			 */
+			*move_group = 1;
+		}
+
+		/* Don't allow group of multiple hw events from different pmus */
+		if (!in_software_context(group_leader) &&
+		    group_leader->pmu_ctx->pmu != *pmu)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * sys_perf_event_open - open a performance event, associate it to a task/cpu
  *
@@ -12518,71 +12593,9 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	if (group_leader) {
-		err = -EINVAL;
-
-		/*
-		 * Do not allow a recursive hierarchy (this new sibling
-		 * becoming part of another group-sibling):
-		 */
-		if (group_leader->group_leader != group_leader)
-			goto err_locked;
-
-		/* All events in a group should have the same clock */
-		if (group_leader->clock != event->clock)
-			goto err_locked;
-
-		/*
-		 * Make sure we're both events for the same CPU;
-		 * grouping events for different CPUs is broken; since
-		 * you can never concurrently schedule them anyhow.
-		 */
-		if (group_leader->cpu != event->cpu)
-			goto err_locked;
-
-		/*
-		 * Make sure we're both on the same context; either task or cpu.
-		 */
-		if (group_leader->ctx != ctx)
-			goto err_locked;
-
-		/*
-		 * Only a group leader can be exclusive or pinned
-		 */
-		if (attr.exclusive || attr.pinned)
-			goto err_locked;
-
-		if (is_software_event(event) &&
-		    !in_software_context(group_leader)) {
-			/*
-			 * If the event is a sw event, but the group_leader
-			 * is on hw context.
-			 *
-			 * Allow the addition of software events to hw
-			 * groups, this is safe because software events
-			 * never fail to schedule.
-			 *
-			 * Note the comment that goes with struct
-			 * perf_event_pmu_context.
-			 */
-			pmu = group_leader->pmu_ctx->pmu;
-		} else if (!is_software_event(event)) {
-			if (is_software_event(group_leader) &&
-			    (group_leader->group_caps & PERF_EV_CAP_SOFTWARE)) {
-				/*
-				 * In case the group is a pure software group, and we
-				 * try to add a hardware event, move the whole group to
-				 * the hardware context.
-				 */
-				move_group = 1;
-			}
-
-			/* Don't allow group of multiple hw events from different pmus */
-			if (!in_software_context(group_leader) &&
-			    group_leader->pmu_ctx->pmu != pmu)
-				goto err_locked;
-		}
-	}
+	err = perf_event_group_leader_check(group_leader, event, &attr, ctx, &pmu, &move_group);
+	if (err)
+		goto err_locked;
 
 	/*
 	 * Now that we're certain of the pmu; find the pmu_ctx.
-- 
2.34.1

