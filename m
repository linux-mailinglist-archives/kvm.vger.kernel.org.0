Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7F934C332
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhC2Ftl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:49:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:15632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbhC2Ftb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:49:31 -0400
IronPort-SDR: fN8LxQFK/cWHw/XeUCltG+U7ESK0WFPUq3NXR+rwDoZWQvE7xXuX/17qOCvhm4h9CEhZiKIU0h
 Sz2QB0T1EMFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="255478716"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="255478716"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 22:49:31 -0700
IronPort-SDR: SaCxxdWTby18Y68WXgHvFiQiOTyyNlPnn1cu44Ori+1qT8SiWri31CSAMyIiirD0KKoBVYbQ7R
 f/SlHzHx3B5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="417506705"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2021 22:49:27 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v4 02/16] perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
Date:   Mon, 29 Mar 2021 13:41:23 +0800
Message-Id: <20210329054137.120994-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With PEBS virtualization, the guest PEBS records get delivered to the
guest DS, and the host pmi handler uses perf_guest_cbs->is_in_guest()
to distinguish whether the PMI comes from the guest code like Intel PT.

No matter how many guest PEBS counters are overflowed, only triggering
one fake event is enough. The fake event causes the KVM PMI callback to
be called, thereby injecting the PEBS overflow PMI into the guest.

KVM will inject the PMI with BUFFER_OVF set, even if the guest DS is
empty. That should really be harmless. Thus the guest PEBS handler would
retrieve the correct information from its own PEBS records buffer.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c | 45 +++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 591d60cc8436..af9ac48fe840 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2747,6 +2747,46 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
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
+ * The contents and other behavior of the guest event do not matter.
+ */
+static int x86_pmu_handle_guest_pebs(struct pt_regs *regs,
+					struct perf_sample_data *data)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+	struct perf_event *event = NULL;
+	int bit;
+
+	if (!x86_pmu.pebs_active || !guest_pebs_idxs)
+		return 0;
+
+	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
+			INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
+
+		event = cpuc->events[bit];
+		if (!event->attr.precise_ip)
+			continue;
+
+		perf_sample_data_init(data, 0, event->hw.last_period);
+		if (perf_event_overflow(event, data, regs))
+			x86_pmu_stop(event, 0);
+
+		/* Inject one fake event is enough. */
+		return 1;
+	}
+
+	return 0;
+}
+
 static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
 	struct perf_sample_data data;
@@ -2797,7 +2837,10 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 		u64 pebs_enabled = cpuc->pebs_enabled;
 
 		handled++;
-		x86_pmu.drain_pebs(regs, &data);
+		if (x86_pmu.pebs_vmx && perf_guest_cbs && perf_guest_cbs->is_in_guest())
+			x86_pmu_handle_guest_pebs(regs, &data);
+		else
+			x86_pmu.drain_pebs(regs, &data);
 		status &= x86_pmu.intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
 
 		/*
-- 
2.29.2

