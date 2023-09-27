Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3FF7AF969
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjI0Ebn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjI0EbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:31:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9492AD2D;
        Tue, 26 Sep 2023 20:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695785109; x=1727321109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CTHF121PR7xhMS1XUtU5zQj11Uetgzp+urrA6+B41Dw=;
  b=MgvIEfITSWLci4BxE46aJLiv/HxEjSQm3KvDHtcNB6lrDcEPRbGSAGVe
   975nTNl5ex1Np0XadfkLOwMpF74dV8FvgNPkjd0Q4gavCXNvnpMgI9sk7
   cdpF7ywuZLJZKbJZLY7si/nTgqJpvzcpMPTTlya5Ez/W0q4v7jY0MGASe
   08PVkYecU3in56asXqIWUcuaHro7agcGR+ZyDwErCyy7SpMgYE+jsLi1Y
   0criGJYvDcAjqWrkySDtHuZBDUfauiaa1rrG637WFuHxLwFgzcNzRSUef
   3uuNVsdKcLJCCCs7dtjCKUZt0BC0AK35wFhhyjFk0ZXURRlKvJedpzMzb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="366780866"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="366780866"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:25:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864637224"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864637224"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2023 20:24:58 -0700
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
Subject: [Patch v4 10/13] KVM: x86/pmu: Extend pmc_reprogram_counter() to create group events
Date:   Wed, 27 Sep 2023 11:31:21 +0800
Message-Id: <20230927033124.1226509-11-dapeng1.mi@linux.intel.com>
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

Current perf code creates a events group which contains a slots event
that acts as group leader and multiple metric events to support the
topdown perf metrics feature. To support the topdown metrics feature
in KVM and reduce the changes for perf system at the same time, we
follow this mature mechanism and create a events group in KVM. The
events group contains a slots event which claims the fixed counter 3
and act as group leader as perf system requires, and a virtual metrics
event which claims PERF_METRICS MSR. This events group would be
scheduled as a whole by the perf system.

Unfortunately the function pmc_reprogram_counter() can only create a
single event for every counter, so this change extends the function and
makes it have the capability to create a events group.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++++-
 arch/x86/kvm/pmu.c              | 64 ++++++++++++++++++++++++++-------
 arch/x86/kvm/pmu.h              | 22 ++++++++----
 arch/x86/kvm/svm/pmu.c          |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c    |  4 +++
 5 files changed, 83 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 90ecd3f7a9c3..bf1626b2b553 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -490,12 +490,12 @@ enum pmc_type {
 struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
+	u8 max_nr_events;
 	bool is_paused;
 	bool intr;
 	u64 counter;
 	u64 prev_counter;
 	u64 eventsel;
-	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
 	 * only for creating or reusing perf_event,
@@ -503,6 +503,15 @@ struct kvm_pmc {
 	 * ctrl value for fixed counters.
 	 */
 	u64 current_config;
+	/*
+	 * Non-leader events may need some extra information,
+	 * this field can be used to store this information.
+	 */
+	u64 extra_config;
+	union {
+		struct perf_event *perf_event;
+		DECLARE_FLEX_ARRAY(struct perf_event *, perf_events);
+	};
 };
 
 /* More counters may conflict with other existing Architectural MSRs */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 760d293f4a4a..b02a56c77647 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -187,7 +187,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 				 bool intr)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	struct perf_event *event;
+	struct perf_event *event, *group_leader;
 	struct perf_event_attr attr = {
 		.type = type,
 		.size = sizeof(attr),
@@ -199,6 +199,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 		.config = config,
 	};
 	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
+	unsigned int i, j;
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
@@ -221,36 +222,73 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 		attr.precise_ip = pmc_get_pebs_precise_level(pmc);
 	}
 
-	event = perf_event_create_kernel_counter(&attr, -1, current, NULL,
-						 kvm_perf_overflow, pmc);
-	if (IS_ERR(event)) {
-		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
-			    PTR_ERR(event), pmc->idx);
-		return PTR_ERR(event);
+	/*
+	 * To create grouped events, the first created perf_event doesn't
+	 * know it will be the group_leader and may move to an unexpected
+	 * enabling path, thus delay all enablement until after creation,
+	 * not affecting non-grouped events to save one perf interface call.
+	 */
+	if (pmc->max_nr_events > 1)
+		attr.disabled = 1;
+
+	for (i = 0; i < pmc->max_nr_events; i++) {
+		group_leader = i ? pmc->perf_event : NULL;
+		event = perf_event_create_kernel_counter(&attr, -1,
+							 current, group_leader,
+							 kvm_perf_overflow, pmc);
+		if (IS_ERR(event)) {
+			pr_err_ratelimited("kvm_pmu: event %u of pmc %u creation failed %ld\n",
+					   i, pmc->idx, PTR_ERR(event));
+
+			for (j = 0; j < i; j++) {
+				perf_event_release_kernel(pmc->perf_events[j]);
+				pmc->perf_events[j] = NULL;
+				pmc_to_pmu(pmc)->event_count--;
+			}
+
+			return PTR_ERR(event);
+		}
+
+		pmc->perf_events[i] = event;
+		pmc_to_pmu(pmc)->event_count++;
 	}
 
-	pmc->perf_event = event;
-	pmc_to_pmu(pmc)->event_count++;
 	pmc->is_paused = false;
 	pmc->intr = intr || pebs;
+
+	if (!attr.disabled)
+		return 0;
+
+	for (i = 0; pmc->perf_events[i] && i < pmc->max_nr_events; i++)
+		perf_event_enable(pmc->perf_events[i]);
+
 	return 0;
 }
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
 {
 	u64 counter = pmc->counter;
+	unsigned int i;
 
 	if (!pmc->perf_event || pmc->is_paused)
 		return;
 
-	/* update counter, reset event value to avoid redundant accumulation */
+	/*
+	 * Update counter, reset event value to avoid redundant
+	 * accumulation. Disable group leader event firstly and
+	 * then disable non-group leader events.
+	 */
 	counter += perf_event_pause(pmc->perf_event, true);
+	for (i = 1; pmc->perf_events[i] && i < pmc->max_nr_events; i++)
+		perf_event_pause(pmc->perf_events[i], true);
 	pmc->counter = counter & pmc_bitmask(pmc);
 	pmc->is_paused = true;
 }
 
 static bool pmc_resume_counter(struct kvm_pmc *pmc)
 {
+	unsigned int i;
+
 	if (!pmc->perf_event)
 		return false;
 
@@ -264,8 +302,8 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	    (!!pmc->perf_event->attr.precise_ip))
 		return false;
 
-	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
-	perf_event_enable(pmc->perf_event);
+	for (i = 0; pmc->perf_events[i] && i < pmc->max_nr_events; i++)
+		perf_event_enable(pmc->perf_events[i]);
 	pmc->is_paused = false;
 
 	return true;
@@ -432,7 +470,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
 		goto reprogram_complete;
 
-	pmc_release_perf_event(pmc);
+	pmc_release_perf_event(pmc, false);
 
 	pmc->current_config = new_config;
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7d9ba301c090..3dc0deb83096 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -74,21 +74,31 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 	return counter & pmc_bitmask(pmc);
 }
 
-static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
+static inline void pmc_release_perf_event(struct kvm_pmc *pmc, bool reset)
 {
-	if (pmc->perf_event) {
-		perf_event_release_kernel(pmc->perf_event);
-		pmc->perf_event = NULL;
-		pmc->current_config = 0;
+	unsigned int i;
+
+	if (!pmc->perf_event)
+		return;
+
+	for (i = 0; pmc->perf_events[i] && i < pmc->max_nr_events; i++) {
+		perf_event_release_kernel(pmc->perf_events[i]);
+		pmc->perf_events[i] = NULL;
 		pmc_to_pmu(pmc)->event_count--;
 	}
+
+	if (reset) {
+		pmc->current_config = 0;
+		pmc->extra_config = 0;
+		pmc->max_nr_events = 1;
+	}
 }
 
 static inline void pmc_stop_counter(struct kvm_pmc *pmc)
 {
 	if (pmc->perf_event) {
 		pmc->counter = pmc_read_counter(pmc);
-		pmc_release_perf_event(pmc);
+		pmc_release_perf_event(pmc, true);
 	}
 }
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index cef5a3d0abd0..861ff79ac614 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -230,6 +230,8 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
 		pmu->gp_counters[i].current_config = 0;
+		pmu->gp_counters[i].extra_config = 0;
+		pmu->gp_counters[i].max_nr_events = 1;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9bf80fee34fb..b45396e0a46c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -628,6 +628,8 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
 		pmu->gp_counters[i].current_config = 0;
+		pmu->gp_counters[i].extra_config = 0;
+		pmu->gp_counters[i].max_nr_events = 1;
 	}
 
 	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
@@ -635,6 +637,8 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
+		pmu->fixed_counters[i].extra_config = 0;
+		pmu->fixed_counters[i].max_nr_events = 1;
 	}
 
 	lbr_desc->records.nr = 0;
-- 
2.34.1

