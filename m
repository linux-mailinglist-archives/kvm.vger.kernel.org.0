Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B2E36DA8
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfFFHo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:44:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:25022 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfFFHox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:53 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:51 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 12/12] KVM/VMX/vPMU: support to report GLOBAL_STATUS_LBRS_FROZEN
Date:   Thu,  6 Jun 2019 15:02:31 +0800
Message-Id: <1559804551-42271-13-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
References: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 arch/x86/kvm/vmx/pmu_intel.c | 19 +++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 1e313f3..f5f1f46 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -55,6 +55,13 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
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
@@ -64,7 +71,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 
 	if (!test_and_set_bit(pmc->idx,
 			      (unsigned long *)&pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		kvm_perf_set_global_status(pmu, pmc->idx);
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 	}
 }
@@ -78,7 +85,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 
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
index c60f564..62e7bcd 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -421,6 +421,24 @@ static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static void intel_pmu_set_global_status(struct kvm_pmu *pmu, u8 idx)
+{
+	u64 guest_debugctl;
+
+	if (pmu->version >= 4) {
+		guest_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+
+		if ((guest_debugctl & GLOBAL_STATUS_LBRS_FROZEN) ==
+		    DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)
+			__set_bit(GLOBAL_STATUS_LBRS_FROZEN,
+				  (unsigned long *)&pmu->global_status);
+		if ((guest_debugctl & GLOBAL_STATUS_LBRS_FROZEN) ==
+		    DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI)
+			__set_bit(GLOBAL_STATUS_COUNTERS_FROZEN,
+				  (unsigned long *)&pmu->global_status);
+	}
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -719,6 +737,7 @@ void intel_pmu_disable_save_guest_lbr(struct kvm_vcpu *vcpu)
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
+	.set_global_status = intel_pmu_set_global_status,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.7.4

