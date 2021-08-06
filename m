Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F71C3E2B8E
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 15:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344210AbhHFNjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 09:39:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:13922 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344173AbhHFNiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 09:38:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="214101448"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="214101448"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:38:34 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="523463363"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:38:30 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V10 03/18] perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
Date:   Fri,  6 Aug 2021 21:37:47 +0800
Message-Id: <20210806133802.3528-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210806133802.3528-1-lingshan.zhu@intel.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

With PEBS virtualization, the guest PEBS records get delivered to the
guest DS, and the host pmi handler uses perf_guest_cbs->is_in_guest()
to distinguish whether the PMI comes from the guest code like Intel PT.

No matter how many guest PEBS counters are overflowed, only triggering
one fake event is enough. The fake event causes the KVM PMI callback to
be called, thereby injecting the PEBS overflow PMI into the guest.

KVM may inject the PMI with BUFFER_OVF set, even if the guest DS is
empty. That should really be harmless. Thus guest PEBS handler would
retrieve the correct information from its own PEBS records buffer.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c | 45 ++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index da835f5a37e2..2770eba232c7 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2783,6 +2783,50 @@ static void intel_pmu_reset(void)
 }
 
 DECLARE_STATIC_CALL(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
+DECLARE_STATIC_CALL(x86_guest_state, *(perf_guest_cbs->state));
+
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
+static void x86_pmu_handle_guest_pebs(struct pt_regs *regs,
+				      struct perf_sample_data *data)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+	struct perf_event *event = NULL;
+	unsigned int guest = 0;
+	int bit;
+
+	guest = static_call(x86_guest_state)();
+	if (!(guest & PERF_GUEST_ACTIVE))
+		return;
+
+	if (!x86_pmu.pebs_vmx || !x86_pmu.pebs_active ||
+	    !guest_pebs_idxs)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
+			 INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
+		event = cpuc->events[bit];
+		if (!event->attr.precise_ip)
+			continue;
+
+		perf_sample_data_init(data, 0, event->hw.last_period);
+		if (perf_event_overflow(event, data, regs))
+			x86_pmu_stop(event, 0);
+
+		/* Inject one fake event is enough. */
+		break;
+	}
+}
 
 static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
@@ -2835,6 +2879,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 		u64 pebs_enabled = cpuc->pebs_enabled;
 
 		handled++;
+		x86_pmu_handle_guest_pebs(regs, &data);
 		x86_pmu.drain_pebs(regs, &data);
 		status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
 
-- 
2.27.0

