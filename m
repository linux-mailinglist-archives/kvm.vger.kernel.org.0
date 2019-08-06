Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925B582D81
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732469AbfHFIGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:06:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:5858 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732358AbfHFIGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:06:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:00:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337382"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:00:54 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 09/14] KVM/x86/vPMU: APIs to create/free lbr perf event for a vcpu thread
Date:   Tue,  6 Aug 2019 15:16:09 +0800
Message-Id: <1565075774-26671-10-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMX transition is much more frequent than vcpu switching, and
saving/restoring tens of lbr msrs (e.g. 32 lbr stack entries) would add
too much overhead to the frequent vmx transition, which is not
necessary. So the vcpu's lbr state only gets saved/restored on the vcpu
context switching.

The main purposes of using the vcpu's lbr perf event are
- follow the host perf scheduling rules to manage the vcpu's usage of
  lbr (e.g. a cpu pinned lbr event could reclaim lbr and thus stopping
  the vcpu's use);
- have the host perf do context switching of the lbr state on the vcpu
  thread context switching.
Please see the comments in intel_pmu_create_lbr_event for more details.

To achieve the pure lbr emulation, the perf event is created only to
claim for the lbr feature, and no perf counter is needed for it.

The vcpu_lbr field is added to indicate to the host lbr driver that the
lbr is currently assigned to a vcpu to use. The guest driver inside the
vcpu has its own logic to use the lbr, thus the host side lbr driver
doesn't need to enable and use the lbr feature in this case.

Some design choice considerations:
- Why using "is_kernel_event", instead of checking the PF_VCPU flag, to
  determine that it is a vcpu perf event for lbr emulation?
  This is because PF_VCPU is set right before vm-entry into the guest,
  and cleared after the guest vm-exits to the host. So that flag doesn't
  remain set when running the host code.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Co-developed-by: Like Xu <like.xu@intel.com>
Signed-off-by: Like Xu <like.xu@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/events/intel/lbr.c     | 38 ++++++++++++++++++++++--
 arch/x86/events/perf_event.h    |  1 +
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 64 +++++++++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h      |  7 +++++
 kernel/events/core.c            |  7 -----
 6 files changed, 108 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 9b2d05c..4f4bd18 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -462,6 +462,14 @@ void intel_pmu_lbr_add(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	/*
+	 * An lbr event without a counter indicates this is for the vcpu lbr
+	 * emulation, so set the vcpu_lbr flag when the vcpu lbr event
+	 * gets scheduled on the lbr here.
+	 */
+	if (is_no_counter_event(event))
+		cpuc->vcpu_lbr = 1;
+
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	if (branch_user_callstack(cpuc->br_sel) && event->ctx->task_ctx_data) {
@@ -509,6 +517,14 @@ void intel_pmu_lbr_del(struct perf_event *event)
 		task_ctx->lbr_callstack_users--;
 	}
 
+	/*
+	 * An lbr event without a counter indicates this is for the vcpu lbr
+	 * emulation, so clear the vcpu_lbr flag when the vcpu's lbr event
+	 * gets scheduled out from the lbr.
+	 */
+	if (is_no_counter_event(event))
+		cpuc->vcpu_lbr = 0;
+
 	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip > 0)
 		cpuc->lbr_pebs_users--;
 	cpuc->lbr_users--;
@@ -521,7 +537,12 @@ void intel_pmu_lbr_enable_all(bool pmi)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (cpuc->lbr_users)
+	/*
+	 * The vcpu lbr emulation doesn't need host to enable lbr at this
+	 * point, because the guest will set the enabling at a proper time
+	 * itself.
+	 */
+	if (cpuc->lbr_users && !cpuc->vcpu_lbr)
 		__intel_pmu_lbr_enable(pmi);
 }
 
@@ -529,7 +550,11 @@ void intel_pmu_lbr_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (cpuc->lbr_users)
+	/*
+	 * Same as intel_pmu_lbr_enable_all, the guest is responsible for
+	 * clearing the enabling itself.
+	 */
+	if (cpuc->lbr_users && !cpuc->vcpu_lbr)
 		__intel_pmu_lbr_disable();
 }
 
@@ -668,8 +693,12 @@ void intel_pmu_lbr_read(void)
 	 *
 	 * This could be smarter and actually check the event,
 	 * but this simple approach seems to work for now.
+	 *
+	 * And no need to read the lbr msrs here if the vcpu lbr event
+	 * is using it, as the guest will read them itself.
 	 */
-	if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
+	if (!cpuc->lbr_users || cpuc->vcpu_lbr ||
+	    cpuc->lbr_users == cpuc->lbr_pebs_users)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
@@ -802,6 +831,9 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return -EOPNOTSUPP;
 
+	if (event->attr.exclude_host && is_kernel_event(event))
+		perf_event_set_no_counter(event);
+
 	/*
 	 * setup SW LBR filter
 	 */
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 27e4d32..8b90a25 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -220,6 +220,7 @@ struct cpu_hw_events {
 	/*
 	 * Intel LBR bits
 	 */
+	u8				vcpu_lbr;
 	int				lbr_users;
 	int				lbr_pebs_users;
 	struct perf_branch_stack	lbr_stack;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d29dddd..692a0c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -474,6 +474,7 @@ struct kvm_pmu {
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
 	u64 reprogram_pmi;
+	struct perf_event *lbr_event;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f0ad78f..89730f8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -164,6 +164,70 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return ret;
 }
 
+int intel_pmu_create_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event;
+
+	/*
+	 * The perf event is created for the following purposes:
+	 * - have the host perf subsystem manage (prioritize) the guest's use
+	 *   of lbr with other host lbr events (if there are). The pinned field
+	 *   is set to true to make this event task pinned. If a cpu pinned
+	 *   lbr event reclaims lbr, the event->oncpu field will be set to -1.
+	 *   It will be checked at the moment before vm-entry, and the lbr
+	 *   feature will not be passed through to the guest for direct
+	 *   accesses if the vcpu's lbr event does not own the lbr feature
+	 *   anymore. This will cause the guest's lbr accesses to trap to the
+	 *   kvm's handler, where the accesses will be prevented in this case.
+	 * - have the host perf subsystem help save/restore the guest lbr stack
+	 *   on vcpu switching. Since the host perf only performs this
+	 *   save/restore for the user callstack mode lbr event, we configure
+	 *   the sample_type and branch_sample_type fields accordingly to make
+	 *   this a user callstack mode lbr event.
+	 *
+	 * This perf event is used for the emulation of the lbr feature, which
+	 * doesn't have a pmu counter. Accordingly, the related attr fields,
+	 * such as config and sample period, don't need to be set here.
+	 * exclude_host is set to tell the perf lbr driver that the event is for
+	 * the guest lbr emulation.
+	 */
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_RAW,
+		.size = sizeof(attr),
+		.pinned = true,
+		.exclude_host = true,
+		.sample_type = PERF_SAMPLE_BRANCH_STACK,
+		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+				      PERF_SAMPLE_BRANCH_USER,
+	};
+
+	if (pmu->lbr_event)
+		return 0;
+
+	event = perf_event_create_kernel_counter(&attr, -1, current, NULL,
+						 NULL);
+	if (IS_ERR(event)) {
+		pr_err("%s: failed %ld\n", __func__, PTR_ERR(event));
+		return -ENOENT;
+	}
+	pmu->lbr_event = event;
+
+	return 0;
+}
+
+void intel_pmu_free_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event = pmu->lbr_event;
+
+	if (!event)
+		return;
+
+	perf_event_release_kernel(event);
+	pmu->lbr_event = NULL;
+}
+
 static bool intel_pmu_lbr_enable(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2cae06a..eb76cdc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1050,6 +1050,13 @@ static inline void perf_event_set_no_counter(struct perf_event *event)
 	event->event_caps |= PERF_EV_CAP_NO_COUNTER;
 }
 
+#define TASK_TOMBSTONE ((void *)-1L)
+
+static inline bool is_kernel_event(struct perf_event *event)
+{
+	return READ_ONCE(event->owner) == TASK_TOMBSTONE;
+}
+
 /*
  * Return 1 for a software event, 0 for a hardware event
  */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7663f85..9aa987a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -164,13 +164,6 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 	raw_spin_unlock(&cpuctx->ctx.lock);
 }
 
-#define TASK_TOMBSTONE ((void *)-1L)
-
-static bool is_kernel_event(struct perf_event *event)
-{
-	return READ_ONCE(event->owner) == TASK_TOMBSTONE;
-}
-
 /*
  * On task ctx scheduling...
  *
-- 
2.7.4

