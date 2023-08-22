Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBBD783902
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjHVFFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjHVFE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:04:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79910CCB;
        Mon, 21 Aug 2023 22:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692680663; x=1724216663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+t0hpZzksitjecx9dpNXxxmhUyXW1qd16Yx5Qj+M7Ps=;
  b=OxoUIs7mqIXTkJG4dRDtBoHL0h8nsiNYf0BfIuv2BecU0BLSZEl6OU7S
   vzTJ/yiz7OQT4gbwfS0AHHYX+m0LQycxQy390VmV3+Zpjc2hwUTem70Z3
   tyHDrJW7b0WMUUqQQZ8qtzpojqIUQn2llMoCNQQ8eg0yVkOegGxU3EMcx
   DsNefgdKmKXNfHOZgBEQ27SiEreDm+pTIUE5HnEtw0EfrGHhJuJirj0ux
   WNjirAXQMgXZbjAIwGolWiFc/qTNmNPIzteEPIbfIGYQ9fQPgoldBDuue
   QjMSTPnUuX0Ws6CXQJOwDTxy96HVYtxUp+5xoCvokQALqy7O6MbjT+HY5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440146544"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440146544"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 22:04:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982736760"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982736760"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2023 22:04:14 -0700
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
Subject: [PATCH RFC v3 05/13] perf/core: Add *group_leader for perf_event_create_group_kernel_counters()
Date:   Tue, 22 Aug 2023 13:11:32 +0800
Message-Id: <20230822051140.512879-6-dapeng1.mi@linux.intel.com>
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

Add a new argument *group_leader for
perf_event_create_group_kernel_counters(), so group events can be
created from Kernel space just like user space does.

Current perf logic requires a perf events group is created to handle the
topdown metrics profiling. To support topdown metrics feature in KVM,
Kernel space also need the capability to create group events.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  4 ++--
 arch/x86/kvm/pmu.c                        |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c              |  4 ++--
 include/linux/perf_event.h                |  1 +
 kernel/events/core.c                      | 17 ++++++++++++++++-
 kernel/events/hw_breakpoint.c             |  4 ++--
 kernel/events/hw_breakpoint_test.c        |  2 +-
 kernel/watchdog_perf.c                    |  2 +-
 8 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 458cb7419502..6494b2701204 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -952,12 +952,12 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	u64 tmp;
 
 	miss_event = perf_event_create_kernel_counter(miss_attr, plr->cpu,
-						      NULL, NULL, NULL);
+						      NULL, NULL, NULL, NULL);
 	if (IS_ERR(miss_event))
 		goto out;
 
 	hit_event = perf_event_create_kernel_counter(hit_attr, plr->cpu,
-						     NULL, NULL, NULL);
+						     NULL, NULL, NULL, NULL);
 	if (IS_ERR(hit_event))
 		goto out_miss;
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..760d293f4a4a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -221,7 +221,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 		attr.precise_ip = pmc_get_pebs_precise_level(pmc);
 	}
 
-	event = perf_event_create_kernel_counter(&attr, -1, current,
+	event = perf_event_create_kernel_counter(&attr, -1, current, NULL,
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 044d61aa63dc..9bf80fee34fb 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -302,8 +302,8 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	event = perf_event_create_kernel_counter(&attr, -1,
-						current, NULL, NULL);
+	event = perf_event_create_kernel_counter(&attr, -1, current,
+						 NULL, NULL, NULL);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("%s: failed %ld\n",
 					__func__, PTR_ERR(event));
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2166a69e3bf2..c182f811f5f8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1102,6 +1102,7 @@ extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				struct task_struct *task,
+				struct perf_event *group_leader,
 				perf_overflow_handler_t callback,
 				void *context);
 extern void perf_pmu_migrate_context(struct pmu *pmu,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 15eb82d1a010..a3af2e740dea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12754,12 +12754,14 @@ SYSCALL_DEFINE5(perf_event_open,
  * @attr: attributes of the counter to create
  * @cpu: cpu in which the counter is bound
  * @task: task to profile (NULL for percpu)
+ * @group_leader: the group leader event of the created event
  * @overflow_handler: callback to trigger when we hit the event
  * @context: context data could be used in overflow_handler callback
  */
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 				 struct task_struct *task,
+				 struct perf_event *group_leader,
 				 perf_overflow_handler_t overflow_handler,
 				 void *context)
 {
@@ -12767,6 +12769,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	struct perf_event_context *ctx;
 	struct perf_event *event;
 	struct pmu *pmu;
+	int move_group = 0;
 	int err;
 
 	/*
@@ -12776,7 +12779,11 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
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
@@ -12806,6 +12813,11 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
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
@@ -12833,6 +12845,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err_pmu_ctx;
 	}
 
+	if (move_group)
+		perf_event_move_group(group_leader, pmu_ctx, ctx);
+
 	perf_install_in_context(ctx, event, event->cpu);
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index c3797701339c..65b5b1421e62 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -771,7 +771,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    void *context,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk, triggered,
+	return perf_event_create_kernel_counter(attr, -1, tsk, NULL, triggered,
 						context);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
@@ -881,7 +881,7 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 
 	cpus_read_lock();
 	for_each_online_cpu(cpu) {
-		bp = perf_event_create_kernel_counter(attr, cpu, NULL,
+		bp = perf_event_create_kernel_counter(attr, cpu, NULL, NULL,
 						      triggered, context);
 		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
diff --git a/kernel/events/hw_breakpoint_test.c b/kernel/events/hw_breakpoint_test.c
index 2cfeeecf8de9..694db7645676 100644
--- a/kernel/events/hw_breakpoint_test.c
+++ b/kernel/events/hw_breakpoint_test.c
@@ -39,7 +39,7 @@ static struct perf_event *register_test_bp(int cpu, struct task_struct *tsk, int
 	attr.bp_addr = (unsigned long)&break_vars[idx];
 	attr.bp_len = HW_BREAKPOINT_LEN_1;
 	attr.bp_type = HW_BREAKPOINT_RW;
-	return perf_event_create_kernel_counter(&attr, cpu, tsk, NULL, NULL);
+	return perf_event_create_kernel_counter(&attr, cpu, tsk, NULL, NULL, NULL);
 }
 
 static void unregister_test_bp(struct perf_event **bp)
diff --git a/kernel/watchdog_perf.c b/kernel/watchdog_perf.c
index 8ea00c4a24b2..f8a52c4df079 100644
--- a/kernel/watchdog_perf.c
+++ b/kernel/watchdog_perf.c
@@ -120,7 +120,7 @@ static int hardlockup_detector_event_create(void)
 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
 
 	/* Try to register using hardware perf events */
-	evt = perf_event_create_kernel_counter(wd_attr, cpu, NULL,
+	evt = perf_event_create_kernel_counter(wd_attr, cpu, NULL, NULL,
 					       watchdog_overflow_callback, NULL);
 	if (IS_ERR(evt)) {
 		pr_debug("Perf event create on CPU %d failed with %ld\n", cpu,
-- 
2.34.1

