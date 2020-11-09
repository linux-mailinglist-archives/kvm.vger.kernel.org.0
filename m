Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D072E2AAF6D
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgKICRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:64927 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbgKICRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:22 -0500
IronPort-SDR: +gQz6LNq3ym8PMpF1rbKBXCy8XE79EWjJ2hQiYqP+Nk9A0b1bu/VnP3vWFgQDQToRurVYIkihg
 4wrpoJ5UMISw==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684601"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684601"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:05 -0800
IronPort-SDR: 5xcBZ083ilWFnTu4+0og/HCYlvl4Jhj0dtxK1tMnQ4dXgFY7aAu6rTeIpeJDpHZt26ozxvqStb
 QoGqJIJLieaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646153"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:01 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and inject it to guest
Date:   Mon,  9 Nov 2020 10:12:41 +0800
Message-Id: <20201109021254.79755-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
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

If the counter_freezing is disabled on the host, a guest PEBS overflow
PMI would be missed when a PEBS counter is enabled on the host side
and coincidentally a host PEBS overflow PMI based on host DS_AREA is
also triggered right after vm-exit due to the guest PEBS overflow PMI
based on guest DS_AREA. In that case, KVM will disable guest PEBS before
vm-entry once there's a host PEBS counter enabled on the same CPU.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/ds.c | 64 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 86848c57b55e..1e759c74bffd 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1721,6 +1721,67 @@ intel_pmu_save_and_restart_reload(struct perf_event *event, int count)
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
+ * Without counter_freezing support on the host, the guest PEBS overflow
+ * PMI may be dropped when both the guest and the host use PEBS.
+ * Therefore, KVM will not enable guest PEBS once the host PEBS is enabled
+ * without counter_freezing since it may bring a confused unknown NMI.
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
+	 * Note: This is based on the assumption that counter_freezing is enabled,
+	 * or KVM disables the co-existence of guest PEBS and host PEBS.
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
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs,
 				   void *base, void *top,
@@ -1954,6 +2015,9 @@ static void intel_pmu_drain_pebs_icl(struct pt_regs *iregs)
 	if (!x86_pmu.pebs_active)
 		return;
 
+	if (intel_pmu_handle_guest_pebs(cpuc, iregs, ds))
+		return;
+
 	base = (struct pebs_basic *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_basic *)(unsigned long)ds->pebs_index;
 
-- 
2.21.3

