Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B570E82D7F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732282AbfHFIGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:06:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:5872 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732426AbfHFIGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:06:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:01:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337498"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:01:04 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 13/14] KVM/x86/vPMU: check the lbr feature before entering guest
Date:   Tue,  6 Aug 2019 15:16:13 +0800
Message-Id: <1565075774-26671-14-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest can access the lbr related msrs only when the vcpu's lbr event
has been assigned the lbr feature. A cpu pinned lbr event (though no such
event usages in the current upstream kernel) could reclaim the lbr feature
from the vcpu's lbr event (task pinned) via ipi calls. If the cpu is
running in the non-root mode, this will cause the cpu to vm-exit to handle
the host ipi and then vm-entry back to the guest. So on vm-entry (where
interrupt has been disabled), we double confirm that the vcpu's lbr event
is still assigned the lbr feature via checking event->oncpu.

The pass-through of the lbr related msrs will be cancelled if the lbr is
reclaimed, and the following guest accesses to the lbr related msrs will
vm-exit to the related msr emulation handler in kvm, which will prevent
the accesses.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/pmu.c           |  6 ++++++
 arch/x86/kvm/pmu.h           |  3 +++
 arch/x86/kvm/vmx/pmu_intel.c | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c           | 13 +++++++++++++
 4 files changed, 57 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index afad092..ed10a57 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -339,6 +339,12 @@ bool kvm_pmu_lbr_enable(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+void kvm_pmu_enabled_feature_confirm(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops->pmu_ops->enabled_feature_confirm)
+		kvm_x86_ops->pmu_ops->enabled_feature_confirm(vcpu);
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu))
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index f875721..7467907 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -30,6 +30,7 @@ struct kvm_pmu_ops {
 	int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	bool (*lbr_enable)(struct kvm_vcpu *vcpu);
+	void (*enabled_feature_confirm)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	void (*sched_in)(struct kvm_vcpu *vcpu, int cpu);
@@ -126,6 +127,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
+void kvm_pmu_enabled_feature_confirm(struct kvm_vcpu *vcpu);
+
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5580f1a..421051aa 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -781,6 +781,40 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 	intel_pmu_free_lbr_event(vcpu);
 }
 
+void intel_pmu_lbr_confirm(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	/*
+	 * Either lbr_event being NULL or lbr_used being false indicates that
+	 * the lbr msrs haven't been passed through to the guest, so no need
+	 * to cancel passthrough.
+	 */
+	if (!pmu->lbr_event || !pmu->lbr_used)
+		return;
+
+	/*
+	 * The lbr feature gets reclaimed via IPI calls, so checking of
+	 * lbr_event->oncpu needs to be in an atomic context. Just confirm
+	 * that irq has been disabled already.
+	 */
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * Cancel the pass-through of the lbr msrs if lbr has been reclaimed
+	 * by the host perf.
+	 */
+	if (pmu->lbr_event->oncpu != -1) {
+		pmu->lbr_used = false;
+		intel_pmu_set_intercept_for_lbr_msrs(vcpu, true);
+	}
+}
+
+void intel_pmu_enabled_feature_confirm(struct kvm_vcpu *vcpu)
+{
+	intel_pmu_lbr_confirm(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -790,6 +824,7 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.is_valid_msr_idx = intel_is_valid_msr_idx,
 	.is_valid_msr = intel_is_valid_msr,
 	.lbr_enable = intel_pmu_lbr_enable,
+	.enabled_feature_confirm = intel_pmu_enabled_feature_confirm,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
 	.sched_in = intel_pmu_sched_in,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b76f019..efaf0e8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7985,6 +7985,19 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	smp_mb__after_srcu_read_unlock();
 
 	/*
+	 * Higher priority host perf events (e.g. cpu pinned) could reclaim the
+	 * pmu resources (e.g. lbr) that were assigned to the vcpu. This is
+	 * usually done via ipi calls (see perf_install_in_context for
+	 * details).
+	 *
+	 * Before entering the non-root mode (with irq disabled here), double
+	 * confirm that the pmu features enabled to the guest are not reclaimed
+	 * by higher priority host events. Otherwise, disallow vcpu's access to
+	 * the reclaimed features.
+	 */
+	kvm_pmu_enabled_feature_confirm(vcpu);
+
+	/*
 	 * This handles the case where a posted interrupt was
 	 * notified with kvm_vcpu_kick.
 	 */
-- 
2.7.4

