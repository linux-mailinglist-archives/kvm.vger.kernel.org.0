Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C60A2E95DD
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbhADNZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:25:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:23246 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbhADNZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:25:08 -0500
IronPort-SDR: MJ2GCXb2/8ShcWClvkKUweoyFOaGV3xFZEbY03xHPMdXokvGVCvsbucWcv+YfkeX3ojghhNUet
 xER6HYivHlvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034316"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034316"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:12 -0800
IronPort-SDR: wJ1Uqk9JEYlvUZTTzHukE3gWww3UgbyKka/qbz8lmWUVRQ0Gvro6zCdm0uZ9WIMu6nMw+AjmWy
 2AN5Rluwa6TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944553"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:09 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and inject it to guest
Date:   Mon,  4 Jan 2021 21:15:29 +0800
Message-Id: <20210104131542.495413-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With PEBS virtualization, the PEBS records get delivered to the guest,
and host still sees the PEBS overflow PMI from guest PEBS counters.
This would normally result in a spurious host PMI and we needs to inject
that PEBS overflow PMI into the guest, so that the guest PMI handler
can handle the PEBS records.

Check for this case in the host perf PEBS handler. If a PEBS overflow
PMI occurs and it's not generated from host side (via check host DS),
a fake event will be triggered. The fake event causes the KVM PMI callback
to be called, thereby injecting the PEBS overflow PMI into the guest.

No matter how many guest PEBS counters are overflowed, only triggering
one fake event is enough. The guest PEBS handler would retrieve the
correct information from its own PEBS records buffer.

A guest PEBS overflow PMI would be missed when a PEBS counter is enabled
on the host side and coincidentally a host PEBS overflow PMI based on
host DS_AREA is also triggered right after vm-exit due to the guest
PEBS overflow PMI based on guest DS_AREA. In that case, KVM will disable
guest PEBS before vm-entry once there's a host PEBS counter enabled
on the same CPU.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/ds.c | 62 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index b47cc4226934..c499bdb58373 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1721,6 +1721,65 @@ intel_pmu_save_and_restart_reload(struct perf_event *event, int count)
 	return 0;
 }
 
+/*
+ * We may be running with guest PEBS events created by KVM, and the
+ * PEBS records are logged into the guest's DS and invisible to host.
+ *
+ * In the case of guest PEBS overflow, we only trigger a fake event
+ * to emulate the PEBS overflow PMI for guest PBES counters in KVM.
+ * The guest will then vm-entry and check the guest DS area to read
+ * the guest PEBS records.
+ *
+ * The guest PEBS overflow PMI may be dropped when both the guest and
+ * the host use PEBS. Therefore, KVM will not enable guest PEBS once
+ * the host PEBS is enabled since it may bring a confused unknown NMI.
+ *
+ * The contents and other behavior of the guest event do not matter.
+ */
+static int intel_pmu_handle_guest_pebs(struct cpu_hw_events *cpuc,
+				       struct pt_regs *iregs,
+				       struct debug_store *ds)
+{
+	struct perf_sample_data data;
+	struct perf_event *event = NULL;
+	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+	int bit;
+
+	/*
+	 * Ideally, we should check guest DS to understand if it's
+	 * a guest PEBS overflow PMI from guest PEBS counters.
+	 * However, it brings high overhead to retrieve guest DS in host.
+	 * So we check host DS instead for performance.
+	 *
+	 * If PEBS interrupt threshold on host is not exceeded in a NMI, there
+	 * must be a PEBS overflow PMI generated from the guest PEBS counters.
+	 * There is no ambiguity since the reported event in the PMI is guest
+	 * only. It gets handled correctly on a case by case base for each event.
+	 *
+	 * Note: KVM disables the co-existence of guest PEBS and host PEBS.
+	 */
+	if (!guest_pebs_idxs || !in_nmi() ||
+		ds->pebs_index >= ds->pebs_interrupt_threshold)
+		return 0;
+
+	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
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
 static __always_inline void
 __intel_pmu_pebs_event(struct perf_event *event,
 		       struct pt_regs *iregs,
@@ -1965,6 +2024,9 @@ static void intel_pmu_drain_pebs_icl(struct pt_regs *iregs, struct perf_sample_d
 	if (!x86_pmu.pebs_active)
 		return;
 
+	if (intel_pmu_handle_guest_pebs(cpuc, iregs, ds))
+		return;
+
 	base = (struct pebs_basic *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_basic *)(unsigned long)ds->pebs_index;
 
-- 
2.29.2

