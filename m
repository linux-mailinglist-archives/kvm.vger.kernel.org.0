Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F6217A2A3
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCEJ7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:59:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:64850 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgCEJ7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:59:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:59:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366434"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:58:56 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com
Subject: [PATCH v1 02/11] perf/x86/ds: Handle guest PEBS events overflow and inject fake PMI
Date:   Fri,  6 Mar 2020 01:56:56 +0800
Message-Id: <1583431025-19802-3-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

With PEBS virtualization, the PEBS record gets delivered to the guest,
but host still sees the PMI. This would normally result in a spurious
PEBS PMI that is ignored. But we need to inject the PMI into the guest,
so that the guest PMI handler can handle the PEBS record.

Check for this case in the perf PEBS handler. If a guest PEBS counter
overflowed, a fake event will be triggered. The fake event results in
calling the KVM PMI callback, which injects the PMI into the guest.

No matter how many PEBS counters are overflowed, only triggering one
fake event is enough. Then the guest handler would retrieve the correct
information from its own PEBS records including the guest state.

Originally-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/events/intel/ds.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index dc43cc1..6722f39 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1721,6 +1721,62 @@ void intel_pmu_auto_reload_read(struct perf_event *event)
 	return 0;
 }
 
+/*
+ * We may be running with virtualized PEBS, so the PEBS record
+ * was logged into the guest's DS and is invisible to host.
+ *
+ * For guest-dedicated counters we always have to check if the
+ * counters are overflowed, because PEBS thresholds
+ * are not reported in the PERF_GLOBAL_STATUS.
+ *
+ * In this case we just trigger a fake event for KVM to forward
+ * to the guest as PMI. The guest will then see the real PEBS
+ * record and read the counter values.
+ *
+ * The contents of the event do not matter.
+ */
+static int intel_pmu_handle_guest_pebs(struct cpu_hw_events *cpuc,
+				       struct pt_regs *iregs,
+				       struct debug_store *ds)
+{
+	struct perf_sample_data data;
+	struct perf_event *event;
+	int bit;
+
+	/*
+	 * Ideally, we should check guest DS to understand if the
+	 * guest-dedicated PEBS counters are overflowed.
+	 *
+	 * However, it brings high overhead to retrieve guest DS in host.
+	 * The host and guest cannot have pending PEBS events simultaneously.
+	 * So we check host DS instead.
+	 *
+	 * If PEBS interrupt threshold on host is not exceeded in a NMI,
+	 * the guest-dedicated counter must be overflowed.
+	 */
+	if (!cpuc->intel_ctrl_guest_dedicated_mask || !in_nmi() ||
+	    (ds->pebs_interrupt_threshold <= ds->pebs_index))
+		return 0;
+
+	for_each_set_bit(bit,
+		(unsigned long *)&cpuc->intel_ctrl_guest_dedicated_mask,
+			INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
+
+		event = cpuc->events[bit];
+		if (!event->attr.precise_ip)
+			continue;
+
+		perf_sample_data_init(&data, 0, event->hw.last_period);
+		if (perf_event_overflow(event, &data, iregs))
+			x86_pmu_stop(event, 0);
+
+		/* Inject one fake event is enough. */
+		return 1;
+	}
+
+	return 0;
+}
+
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs,
 				   void *base, void *top,
@@ -1954,6 +2010,9 @@ static void intel_pmu_drain_pebs_icl(struct pt_regs *iregs)
 	if (!x86_pmu.pebs_active)
 		return;
 
+	if (intel_pmu_handle_guest_pebs(cpuc, iregs, ds))
+		return;
+
 	base = (struct pebs_basic *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_basic *)(unsigned long)ds->pebs_index;
 
-- 
1.8.3.1

