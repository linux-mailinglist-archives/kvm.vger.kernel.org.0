Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D590717A298
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 10:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCEJ64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:58:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:50986 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgCEJ64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:58:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:58:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366402"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:58:49 -0800
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
Subject: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a dedicated counter for guest PEBS
Date:   Fri,  6 Mar 2020 01:56:55 +0800
Message-Id: <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The PEBS event created by host needs to be assigned specific counters
requested by the guest, which means the guest and host counter indexes
have to be the same or fail to create. This is needed because PEBS leaks
counter indexes into the guest. Otherwise, the guest driver will be
confused by the counter indexes in the status field of the PEBS record.

A guest_dedicated_idx field is added to indicate the counter index
specifically requested by KVM. The dedicated event constraints would
constrain the counter in the host to the same numbered counter in guest.

A intel_ctrl_guest_dedicated_mask field is added to indicate the enabled
counters for guest PEBS events. The IA32_PEBS_ENABLE MSR will be switched
during the VMX transitions if intel_ctrl_guest_owned is set.

Originally-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/events/intel/core.c | 60 +++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/events/perf_event.h |  1 +
 include/linux/perf_event.h   |  2 ++
 kernel/events/core.c         |  1 +
 4 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index dff6623..ef95076 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -368,6 +368,29 @@
 	EVENT_CONSTRAINT_END
 };
 
+#define GUEST_DEDICATED_CONSTRAINT(idx) {          \
+	{ .idxmsk64 = (1ULL << (idx)) },        \
+	.weight = 1,                            \
+}
+
+static struct event_constraint dedicated_gp_c[MAX_PEBS_EVENTS] = {
+	GUEST_DEDICATED_CONSTRAINT(0),
+	GUEST_DEDICATED_CONSTRAINT(1),
+	GUEST_DEDICATED_CONSTRAINT(2),
+	GUEST_DEDICATED_CONSTRAINT(3),
+	GUEST_DEDICATED_CONSTRAINT(4),
+	GUEST_DEDICATED_CONSTRAINT(5),
+	GUEST_DEDICATED_CONSTRAINT(6),
+	GUEST_DEDICATED_CONSTRAINT(7),
+};
+
+static struct event_constraint dedicated_fixed_c[MAX_FIXED_PEBS_EVENTS] = {
+	GUEST_DEDICATED_CONSTRAINT(INTEL_PMC_IDX_FIXED),
+	GUEST_DEDICATED_CONSTRAINT(INTEL_PMC_IDX_FIXED + 1),
+	GUEST_DEDICATED_CONSTRAINT(INTEL_PMC_IDX_FIXED + 2),
+	GUEST_DEDICATED_CONSTRAINT(INTEL_PMC_IDX_FIXED + 3),
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -2158,6 +2181,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	}
 
 	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
+	cpuc->intel_ctrl_guest_dedicated_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
 
@@ -2246,6 +2270,10 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	if (event->attr.exclude_guest)
 		cpuc->intel_ctrl_host_mask |= (1ull << hwc->idx);
 
+	if (unlikely(event->guest_dedicated_idx >= 0)) {
+		WARN_ON(hwc->idx != event->guest_dedicated_idx);
+		cpuc->intel_ctrl_guest_dedicated_mask |= (1ull << hwc->idx);
+	}
 	if (unlikely(event_is_checkpointed(event)))
 		cpuc->intel_cp_status |= (1ull << hwc->idx);
 
@@ -3036,7 +3064,21 @@ static void intel_commit_scheduling(struct cpu_hw_events *cpuc, int idx, int cnt
 	if (cpuc->excl_cntrs)
 		return intel_get_excl_constraints(cpuc, event, idx, c2);
 
-	return c2;
+	if (event->guest_dedicated_idx < 0)
+		return c2;
+
+	BUILD_BUG_ON(ARRAY_SIZE(dedicated_fixed_c) != MAX_FIXED_PEBS_EVENTS);
+	if (c2->idxmsk64 & (1ULL << event->guest_dedicated_idx)) {
+		if (event->guest_dedicated_idx < MAX_PEBS_EVENTS)
+			return &dedicated_gp_c[event->guest_dedicated_idx];
+		else if ((event->guest_dedicated_idx >= INTEL_PMC_IDX_FIXED) &&
+			 (event->guest_dedicated_idx < INTEL_PMC_IDX_FIXED +
+							MAX_FIXED_PEBS_EVENTS))
+			return &dedicated_fixed_c[event->guest_dedicated_idx -
+							INTEL_PMC_IDX_FIXED];
+	}
+
+	return &emptyconstraint;
 }
 
 static void intel_put_excl_constraints(struct cpu_hw_events *cpuc,
@@ -3373,6 +3415,22 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 		*nr = 2;
 	}
 
+	if (cpuc->intel_ctrl_guest_dedicated_mask) {
+		arr[0].guest |= cpuc->intel_ctrl_guest_dedicated_mask;
+		arr[1].msr = MSR_IA32_PEBS_ENABLE;
+		arr[1].host = cpuc->pebs_enabled &
+				~cpuc->intel_ctrl_guest_dedicated_mask;
+		arr[1].guest = cpuc->intel_ctrl_guest_dedicated_mask;
+		*nr = 2;
+	} else {
+		/* Remove MSR_IA32_PEBS_ENABLE from MSR switch list in KVM */
+		if (*nr == 1) {
+			arr[1].msr = MSR_IA32_PEBS_ENABLE;
+			arr[1].host = arr[1].guest = 0;
+			*nr = 2;
+		}
+	}
+
 	return arr;
 }
 
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index f1cd1ca..621529c 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -242,6 +242,7 @@ struct cpu_hw_events {
 	 * Intel host/guest exclude bits
 	 */
 	u64				intel_ctrl_guest_mask;
+	u64				intel_ctrl_guest_dedicated_mask;
 	u64				intel_ctrl_host_mask;
 	struct perf_guest_switch_msr	guest_switch_msrs[X86_PMC_IDX_MAX];
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 547773f..3bccb88 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -750,6 +750,8 @@ struct perf_event {
 	void *security;
 #endif
 	struct list_head		sb_list;
+	/* the guest specified counter index of KVM owned event, e.g PEBS */
+	int				guest_dedicated_idx;
 #endif /* CONFIG_PERF_EVENTS */
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e453589..7a7b56c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10731,6 +10731,7 @@ static void account_event(struct perf_event *event)
 	event->id		= atomic64_inc_return(&perf_event_id);
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
+	event->guest_dedicated_idx = -1;
 
 	if (task) {
 		event->attach_state = PERF_ATTACH_TASK;
-- 
1.8.3.1

