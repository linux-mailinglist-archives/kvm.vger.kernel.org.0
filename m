Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8081F81BC
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgFMIMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:12:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:64586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgFMIL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:28 -0400
IronPort-SDR: oM6iM1XxgcOK+7bsyaX2grHhTlTLJSgERRWSSShUH9FpxwDuj5+oH2/avQlsjxsfwuhH4b+tmv
 5mfHkSAa1fvA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:23 -0700
IronPort-SDR: zy3TlMWoIN6mYecJxRXR2z7b0M+tT8VKkR3z1QXs5Zuz1FI/pWw7iWkprQYU0i9G+iVltwNQng
 3tN5OH6dhaCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467364"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:13 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 04/11] perf/x86: Add constraint to create guest LBR event without hw counter
Date:   Sat, 13 Jun 2020 16:09:49 +0800
Message-Id: <20200613080958.132489-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypervisor may request the perf subsystem to schedule a time window
to directly access the LBR records msrs for its own use. Normally, it would
create a guest LBR event with callstack mode enabled, which is scheduled
along with other ordinary LBR events on the host but in an exclusive way.

To avoid wasting a counter for the guest LBR event, the perf tracks its
hw->idx via INTEL_PMC_IDX_FIXED_VLBR and assigns it with a fake VLBR
counter with the help of new vlbr_constraint. As with the BTS event,
there is actually no hardware counter assigned for the guest LBR event.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200514083054.62538-5-like.xu@linux.intel.com
---
 arch/x86/events/core.c            |  1 +
 arch/x86/events/intel/core.c      | 18 ++++++++++++++++++
 arch/x86/events/intel/lbr.c       |  4 ++++
 arch/x86/events/perf_event.h      |  1 +
 arch/x86/include/asm/perf_event.h | 22 +++++++++++++++++++++-
 5 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 9a5056472b67..1996f2ed7c83 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1104,6 +1104,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 
 	switch (hwc->idx) {
 	case INTEL_PMC_IDX_FIXED_BTS:
+	case INTEL_PMC_IDX_FIXED_VLBR:
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
 		break;
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 8dac4c61bf76..51e1fba7b1d1 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2621,6 +2621,20 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
+/*
+ * Note: matches a fake event, like Fixed2.
+ */
+static struct event_constraint *
+intel_vlbr_constraints(struct perf_event *event)
+{
+	struct event_constraint *c = &vlbr_constraint;
+
+	if (unlikely(constraint_match(c, event->hw.config)))
+		return c;
+
+	return NULL;
+}
+
 static int intel_alt_er(int idx, u64 config)
 {
 	int alt_idx = idx;
@@ -2811,6 +2825,10 @@ __intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
 {
 	struct event_constraint *c;
 
+	c = intel_vlbr_constraints(event);
+	if (c)
+		return c;
+
 	c = intel_bts_constraints(event);
 	if (c)
 		return c;
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 2ed3f2a51bdf..d285d26c1578 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1363,3 +1363,7 @@ int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
+
+struct event_constraint vlbr_constraint =
+	FIXED_EVENT_CONSTRAINT(INTEL_FIXED_VLBR_EVENT,
+			       (INTEL_PMC_IDX_FIXED_VLBR - INTEL_PMC_IDX_FIXED));
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index eb37f6c43c96..77a6dd66bd9a 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -990,6 +990,7 @@ void release_ds_buffers(void);
 void reserve_ds_buffers(void);
 
 extern struct event_constraint bts_constraint;
+extern struct event_constraint vlbr_constraint;
 
 void intel_pmu_enable_bts(u64 config);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 5d2c30f0df02..2df707311d17 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -192,9 +192,29 @@ struct x86_pmu_capability {
 #define GLOBAL_STATUS_UNC_OVF				BIT_ULL(61)
 #define GLOBAL_STATUS_ASIF				BIT_ULL(60)
 #define GLOBAL_STATUS_COUNTERS_FROZEN			BIT_ULL(59)
-#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(58)
+#define GLOBAL_STATUS_LBRS_FROZEN_BIT			58
+#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(GLOBAL_STATUS_LBRS_FROZEN_BIT)
 #define GLOBAL_STATUS_TRACE_TOPAPMI			BIT_ULL(55)
 
+/*
+ * We model guest LBR event tracing as another fixed-mode PMC like BTS.
+ *
+ * We choose bit 58 because it's used to indicate LBR stack frozen state
+ * for architectural perfmon v4, also we unconditionally mask that bit in
+ * the handle_pmi_common(), so it'll never be set in the overflow handling.
+ *
+ * With this fake counter assigned, the guest LBR event user (such as KVM),
+ * can program the LBR registers on its own, and we don't actually do anything
+ * with then in the host context.
+ */
+#define INTEL_PMC_IDX_FIXED_VLBR	(GLOBAL_STATUS_LBRS_FROZEN_BIT)
+
+/*
+ * Pseudo-encoding the guest LBR event as event=0x00,umask=0x1b,
+ * since it would claim bit 58 which is effectively Fixed26.
+ */
+#define INTEL_FIXED_VLBR_EVENT	0x1b00
+
 /*
  * Adaptive PEBS v4
  */
-- 
2.21.3

