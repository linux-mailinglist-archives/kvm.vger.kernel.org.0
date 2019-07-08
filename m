Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E586192A
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 04:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfGHCGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 22:06:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:44745 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728685AbfGHCGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 22:06:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 19:06:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,464,1557212400"; 
   d="scan'208";a="364083607"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jul 2019 19:06:43 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v7 12/12] KVM/VMX/vPMU: support to report GLOBAL_STATUS_LBRS_FROZEN
Date:   Mon,  8 Jul 2019 09:23:19 +0800
Message-Id: <1562548999-37095-13-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables the LBR related features in Arch v4 in advance,
though the current vPMU only has v2 support. Other arch v4 related
support will be enabled later in another series.

Arch v4 supports streamlined Freeze_LBR_on_PMI. According to the SDM,
the LBR_FRZ bit is set to global status when debugctl.freeze_lbr_on_pmi
has been set and a PMI is generated. The CTR_FRZ bit is set when
debugctl.freeze_perfmon_on_pmi is set and a PMI is generated.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kvm/pmu.c           | 11 +++++++++--
 arch/x86/kvm/pmu.h           |  1 +
 arch/x86/kvm/vmx/pmu_intel.c | 20 ++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 323bb45..89bff8f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -52,6 +52,13 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 	kvm_pmu_deliver_pmi(vcpu);
 }
 
+static void kvm_perf_set_global_status(struct kvm_pmu *pmu, u8 idx)
+{
+	__set_bit(idx, (unsigned long *)&pmu->global_status);
+	if (kvm_x86_ops->pmu_ops->set_global_status)
+		kvm_x86_ops->pmu_ops->set_global_status(pmu, idx);
+}
+
 static void kvm_perf_overflow(struct perf_event *perf_event,
 			      struct perf_sample_data *data,
 			      struct pt_regs *regs)
@@ -61,7 +68,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 
 	if (!test_and_set_bit(pmc->idx,
 			      (unsigned long *)&pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		kvm_perf_set_global_status(pmu, pmc->idx);
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 	}
 }
@@ -75,7 +82,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 
 	if (!test_and_set_bit(pmc->idx,
 			      (unsigned long *)&pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		kvm_perf_set_global_status(pmu, pmc->idx);
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
 		/*
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index cadf91a..408ddc2 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -24,6 +24,7 @@ struct kvm_pmu_ops {
 				    u8 unit_mask);
 	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
+	void (*set_global_status)(struct kvm_pmu *pmu, u8 idx);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, unsigned idx,
 					  u64 *mask);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fd09777..6f74b69 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -413,6 +413,22 @@ static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static void intel_pmu_set_global_status(struct kvm_pmu *pmu, u8 idx)
+{
+	u64 guest_debugctl;
+
+	if (pmu->version >= 4) {
+		guest_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+
+		if (guest_debugctl & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)
+			__set_bit(GLOBAL_STATUS_LBRS_FROZEN,
+				  (unsigned long *)&pmu->global_status);
+		if (guest_debugctl & DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI)
+			__set_bit(GLOBAL_STATUS_COUNTERS_FROZEN,
+				  (unsigned long *)&pmu->global_status);
+	}
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -597,6 +613,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
+	if (pmu->version >= 4)
+		pmu->global_ovf_ctrl_mask &= ~(GLOBAL_STATUS_LBRS_FROZEN |
+					       GLOBAL_STATUS_COUNTERS_FROZEN);
 	if (kvm_x86_ops->pt_supported())
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
@@ -711,6 +730,7 @@ void intel_pmu_disable_save_guest_lbr(struct kvm_vcpu *vcpu)
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
+	.set_global_status = intel_pmu_set_global_status,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.7.4

