Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE63036DB4
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfFFHpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:45:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:25016 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfFFHoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:43 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:41 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 08/12] KVM/x86/vPMU: Add APIs to support host save/restore the guest lbr stack
Date:   Thu,  6 Jun 2019 15:02:27 +0800
Message-Id: <1559804551-42271-9-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
References: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@intel.com>

This patch adds support to enable/disable the host side save/restore
for the guest lbr stack on vCPU switching. To enable that, the host
creates a perf event for the vCPU, and the event attributes are set
to the user callstack mode lbr so that all the conditions are meet in
the host perf subsystem to save the lbr stack on task switching.

The host side lbr perf event are created only for the purpose of saving
and restoring the lbr stack. There is no need to enable the lbr
functionality for this perf event, because the feature is essentially
used in the vCPU. So perf_event_create is invoked with need_counter=false
to get no counter assigned for the perf event.

The vcpu_lbr field is added to cpuc, to indicate if the lbr perf event is
used by the vCPU only for context switching. When the perf subsystem
handles this event (e.g. lbr enable or read lbr stack on PMI) and finds
it's non-zero, it simply returns.

Signed-off-by: Like Xu <like.xu@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/events/intel/lbr.c     | 13 +++++++--
 arch/x86/events/perf_event.h    |  1 +
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.h              |  3 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 61 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 784642a..118764b 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -462,6 +462,9 @@ void intel_pmu_lbr_add(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	if (event->attr.exclude_guest && is_no_counter_event(event))
+		cpuc->vcpu_lbr = 1;
+
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	if (branch_user_callstack(cpuc->br_sel) && event->ctx->task_ctx_data) {
@@ -509,6 +512,9 @@ void intel_pmu_lbr_del(struct perf_event *event)
 		task_ctx->lbr_callstack_users--;
 	}
 
+	if (event->attr.exclude_guest && is_no_counter_event(event))
+		cpuc->vcpu_lbr = 0;
+
 	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip > 0)
 		cpuc->lbr_pebs_users--;
 	cpuc->lbr_users--;
@@ -521,7 +527,7 @@ void intel_pmu_lbr_enable_all(bool pmi)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (cpuc->lbr_users)
+	if (cpuc->lbr_users && !cpuc->vcpu_lbr)
 		__intel_pmu_lbr_enable(pmi);
 }
 
@@ -529,7 +535,7 @@ void intel_pmu_lbr_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (cpuc->lbr_users)
+	if (cpuc->lbr_users && !cpuc->vcpu_lbr)
 		__intel_pmu_lbr_disable();
 }
 
@@ -669,7 +675,8 @@ void intel_pmu_lbr_read(void)
 	 * This could be smarter and actually check the event,
 	 * but this simple approach seems to work for now.
 	 */
-	if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
+	if (!cpuc->lbr_users || cpuc->vcpu_lbr ||
+	    cpuc->lbr_users == cpuc->lbr_pebs_users)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 186c1c7..86605d1 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -238,6 +238,7 @@ struct cpu_hw_events {
 	/*
 	 * Intel LBR bits
 	 */
+	u8				vcpu_lbr;
 	int				lbr_users;
 	int				lbr_pebs_users;
 	struct perf_branch_stack	lbr_stack;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a6cc967..d0f59ea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -477,6 +477,7 @@ struct kvm_pmu {
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
 	u64 reprogram_pmi;
+	struct perf_event *vcpu_lbr_event;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7926b65..384a0b7 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -123,6 +123,9 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
+extern int intel_pmu_enable_save_guest_lbr(struct kvm_vcpu *vcpu);
+extern void intel_pmu_disable_save_guest_lbr(struct kvm_vcpu *vcpu);
+
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8df5e97..ca7a914 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -510,6 +510,67 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
+int intel_pmu_enable_save_guest_lbr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event;
+
+	/*
+	 * The main purpose of this perf event is to have the host perf core
+	 * help save/restore the guest lbr stack on vcpu switching. There is
+	 * no perf counters allocated for the event.
+	 *
+	 * About the attr:
+	 * exclude_guest: set to true to indicate that the event runs on the
+	 *                host only.
+	 * pinned:        set to false, so that the FLEXIBLE events will not
+	 *                be rescheduled for this event which actually doesn't
+	 *                need a perf counter.
+	 * config:        Actually this field won't be used by the perf core
+	 *                as this event doesn't have a perf counter.
+	 * sample_period: Same as above.
+	 * sample_type:   tells the perf core that it is an lbr event.
+	 * branch_sample_type: tells the perf core that the lbr event works in
+	 *                the user callstack mode so that the lbr stack will be
+	 *                saved/restored on vCPU switching.
+	 */
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_RAW,
+		.size = sizeof(attr),
+		.exclude_guest = true,
+		.pinned = false,
+		.config = 0,
+		.sample_period = 0,
+		.sample_type = PERF_SAMPLE_BRANCH_STACK,
+		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+				      PERF_SAMPLE_BRANCH_USER,
+	};
+
+	if (pmu->vcpu_lbr_event)
+		return 0;
+
+	event = perf_event_create(&attr, -1, current, NULL, NULL, false);
+	if (IS_ERR(event)) {
+		pr_err("%s: failed %ld\n", __func__, PTR_ERR(event));
+		return -ENOENT;
+	}
+	pmu->vcpu_lbr_event = event;
+
+	return 0;
+}
+
+void intel_pmu_disable_save_guest_lbr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event = pmu->vcpu_lbr_event;
+
+	if (!event)
+		return;
+
+	perf_event_release_kernel(event);
+	pmu->vcpu_lbr_event = NULL;
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
-- 
2.7.4

