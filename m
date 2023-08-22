Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AFE783914
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjHVFH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjHVFH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:07:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B0ECE0;
        Mon, 21 Aug 2023 22:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692680820; x=1724216820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SNcJaChC/heuKNF6UUiOZR1s9WThihpIUHavE5la/mg=;
  b=RIDRAhdLtfu+qXpR8BTKaZDJyWGecrDhVv4rl8vfwNs2VVwwMmYM8O4M
   /BRJTefWgxQ5cT43t6AKabwXLeeMlbvKvz8LFZq4xukCoTPzQPQ5xP3jN
   +Icu9n1pwcaf5PAmwTWMTClPzNzsJL3tm5DkaEpeJV8X99KE+B+G+tY+z
   +jlJh1aQQq5VNVlqClLlxUm9nbMe+d5vxbSk26cBKDjmE+T1cqcixWkCU
   nETGCwZnl2U/UpYxCTHeSGFwaS6KQUpoaZoG22KLlUMN+5fZ3gRnbtXvF
   kpVYycEFxVeMNAsMANhSa/952B7VRzY4OC+2Wckz0w7/6Ncg/4qKYpqhi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440146761"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440146761"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 22:05:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982737005"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982737005"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2023 22:05:04 -0700
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
Subject: [PATCH RFC v3 12/13] KVM: x86/pmu: Handle PERF_METRICS overflow
Date:   Tue, 22 Aug 2023 13:11:39 +0800
Message-Id: <20230822051140.512879-13-dapeng1.mi@linux.intel.com>
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

When the fixed counter 3 overflows, the PMU would also triggers an
PERF_METRICS overflow subsequently. This patch handles the PERF_METRICS
overflow case, it would inject an PMI into guest and set the
PERF_METRICS overflow bit in PERF_GLOBAL_STATUS MSR after detecting
PERF_METRICS overflow on host.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/events/intel/core.c |  7 ++++++-
 arch/x86/kvm/pmu.c           | 19 +++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 9d53b1c6ac86..7a917e61d994 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3042,8 +3042,13 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 * Intel Perf metrics
 	 */
 	if (__test_and_clear_bit(GLOBAL_STATUS_PERF_METRICS_OVF_BIT, (unsigned long *)&status)) {
+		struct perf_event *event = cpuc->events[GLOBAL_STATUS_PERF_METRICS_OVF_BIT];
+
 		handled++;
-		static_call(intel_pmu_update_topdown_event)(NULL);
+		if (event && is_vmetrics_event(event))
+			READ_ONCE(event->overflow_handler)(event, &data, regs);
+		else
+			static_call(intel_pmu_update_topdown_event)(NULL);
 	}
 
 	/*
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index fad7b2c10bb8..06c815859f77 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -101,7 +101,7 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 	kvm_pmu_deliver_pmi(vcpu);
 }
 
-static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
+static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi, bool metrics_of)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	bool skip_pmi = false;
@@ -121,7 +121,11 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 						      (unsigned long *)&pmu->global_status);
 		}
 	} else {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		if (metrics_of)
+			__set_bit(GLOBAL_STATUS_PERF_METRICS_OVF_BIT,
+				  (unsigned long *)&pmu->global_status);
+		else
+			__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
 
 	if (!pmc->intr || skip_pmi)
@@ -141,11 +145,18 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
 }
 
+static inline bool is_vmetrics_event(struct perf_event *event)
+{
+	return (event->attr.config & INTEL_ARCH_EVENT_MASK) ==
+			INTEL_FIXED_VMETRICS_EVENT;
+}
+
 static void kvm_perf_overflow(struct perf_event *perf_event,
 			      struct perf_sample_data *data,
 			      struct pt_regs *regs)
 {
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
+	bool metrics_of = is_vmetrics_event(perf_event);
 
 	/*
 	 * Ignore overflow events for counters that are scheduled to be
@@ -155,7 +166,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 	if (test_and_set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi))
 		return;
 
-	__kvm_perf_overflow(pmc, true);
+	__kvm_perf_overflow(pmc, true, metrics_of);
 
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
@@ -490,7 +501,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 		goto reprogram_complete;
 
 	if (pmc->counter < pmc->prev_counter)
-		__kvm_perf_overflow(pmc, false);
+		__kvm_perf_overflow(pmc, false, false);
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
-- 
2.34.1

