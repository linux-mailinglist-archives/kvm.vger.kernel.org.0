Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907DE1D2A2B
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgENIbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:31:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:12089 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgENIbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:31:23 -0400
IronPort-SDR: NOCT9Ix1cmtiGFN7BMH2ErFTTtsspIHovv/JYksSh5hTVkfLRyfTUzj0HwxqEeSWiVRBUAY+Wr
 F0G+VE//oYYA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:31:22 -0700
IronPort-SDR: Ox397vVNy8HAkIYHQRZ1Ofs2gGmD6NCWn3uCPgBNajFHD5ZQz2lLrg2ansqzL+3KjeVoAMTuZb
 pE1ggiMwd9xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="341539958"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 01:31:19 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v11 04/11] perf/x86: Add constraint to create guest LBR event without hw counter
Date:   Thu, 14 May 2020 16:30:47 +0800
Message-Id: <20200514083054.62538-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200514083054.62538-1-like.xu@linux.intel.com>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypervisor may request the perf subsystem to schedule a time window
to directly access the LBR stack msrs for its own use. Normally, it would
create a guest LBR event with callstack mode enabled, which is scheduled
along with other ordinary LBR events on the host but in an exclusive way.

To avoid wasting a counter for the guest LBR event, the perf tracks it via
needs_guest_lbr_without_counter() and assigns it with a fake VLBR counter
with the help of new lbr_without_counter_constraint. As with the BTS event,
there is actually no hardware counter assigned for the guest LBR event.

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/core.c            |  1 +
 arch/x86/events/intel/core.c      | 20 ++++++++++++++++++++
 arch/x86/events/intel/lbr.c       |  3 +++
 arch/x86/events/perf_event.h      |  6 ++++++
 arch/x86/include/asm/perf_event.h | 22 +++++++++++++++++++++-
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index f7a259dcbb06..2405926e2dba 100644
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
index f1439acbf7e6..112bc8367d5b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2621,6 +2621,22 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
+/*
+ * Note, the event that satisfies this constraint will not be assigned
+ * with a normal hardware counter but a fake one like BTS event.
+ *
+ * The guest LBR event uses it in the __intel_get_event_constraints()
+ * to make sure LBR registers to be used exclusively for guest.
+ */
+static struct event_constraint *
+intel_guest_lbr_constraints(struct perf_event *event)
+{
+	if (unlikely(is_guest_lbr_event(event)))
+		return &guest_lbr_constraint;
+
+	return NULL;
+}
+
 static int intel_alt_er(int idx, u64 config)
 {
 	int alt_idx = idx;
@@ -2811,6 +2827,10 @@ __intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
 {
 	struct event_constraint *c;
 
+	c = intel_guest_lbr_constraints(event);
+	if (c)
+		return c;
+
 	c = intel_bts_constraints(event);
 	if (c)
 		return c;
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 6c60dcaaaf69..0a91cbe3a7c7 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1363,3 +1363,6 @@ int x86_perf_get_lbr(struct x86_pmu_lbr *stack)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
+
+struct event_constraint guest_lbr_constraint =
+	EVENT_CONSTRAINT(0, 1ULL << INTEL_PMC_IDX_FIXED_VLBR, 0);
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 1025bc6eb04f..34d76a2f5ebd 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -969,6 +969,11 @@ static inline bool intel_pmu_has_bts(struct perf_event *event)
 	return intel_pmu_has_bts_period(event, hwc->sample_period);
 }
 
+static inline bool is_guest_lbr_event(struct perf_event *event)
+{
+	return event->attr.config == INTEL_FIXED_VLBR_EVENT;
+}
+
 int intel_pmu_save_and_restart(struct perf_event *event);
 
 struct event_constraint *
@@ -989,6 +994,7 @@ void release_ds_buffers(void);
 void reserve_ds_buffers(void);
 
 extern struct event_constraint bts_constraint;
+extern struct event_constraint guest_lbr_constraint;
 
 void intel_pmu_enable_bts(u64 config);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 5071515f6b0f..d1938484854d 100644
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
+#define INTEL_PMC_IDX_FIXED_VLBR	GLOBAL_STATUS_LBRS_FROZEN_BIT
+
+/*
+ * Pseudo-encoding the guest LBR event as event=0x00,umask=0x1a,
+ * since it would claim bit 58 which is effectively Fixed25.
+ */
+#define INTEL_FIXED_VLBR_EVENT	0x1a00
+
 /*
  * Adaptive PEBS v4
  */
-- 
2.21.3

