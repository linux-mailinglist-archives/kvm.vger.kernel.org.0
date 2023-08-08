Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813C4774486
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 20:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbjHHSVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 14:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbjHHSVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 14:21:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D13F187EBF;
        Tue,  8 Aug 2023 10:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691515904; x=1723051904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Va4FIDvyis2MT7kTBUHymJbWpd7rNtN7DbzQ10y24ho=;
  b=eHIG3RD9kekHPl6AkZxErdfmLuZMwbstqB81/2hgS1deCuCmC9GXgm54
   X3zeWFxuPavP+r/wt/kvBOUtuf3mNEMWIZei9fALLAnF7EzqB5B5rwp6R
   exWzSZP6iTymuMfJbtihKNkKtifXQORJziW3OipsWPBlQT7L380oXnbgr
   cz8UuQqG+XWMh6/3QVSEeRDKYO/G6yDLn9vg1etMGm66sRCkhiOKmUmUj
   nrlur5QXb1PyHi5+37Tc7rxfAx4TFs6O+cfDxEh8zm7NsSAulKx+RR3N7
   vW7vinuLizVrrMlupAwGzx6UZG/sz8NqFDUX4kkdIIEo7iRLYK43F4rRl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434582210"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="434582210"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 23:27:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734377919"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734377919"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2023 23:27:43 -0700
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
Subject: [PATCH RFV v2 12/13] KVM: x86/pmu: Handle PERF_METRICS overflow
Date:   Tue,  8 Aug 2023 14:31:10 +0800
Message-Id: <20230808063111.1870070-13-dapeng1.mi@linux.intel.com>
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
index 564f602b81f1..c45220804f8a 100644
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
index c766f2041479..b3179931e9b2 100644
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
@@ -491,7 +502,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 		goto reprogram_complete;
 
 	if (pmc->counter < pmc->prev_counter)
-		__kvm_perf_overflow(pmc, false);
+		__kvm_perf_overflow(pmc, false, false);
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
-- 
2.34.1

