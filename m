Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C094D61926
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 04:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfGHCGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 22:06:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:44745 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbfGHCGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 22:06:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 19:06:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,464,1557212400"; 
   d="scan'208";a="364083589"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jul 2019 19:06:39 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v7 10/12] KVM/x86/lbr: lazy save the guest lbr stack
Date:   Mon,  8 Jul 2019 09:23:17 +0800
Message-Id: <1562548999-37095-11-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the vCPU is scheduled in:
- if the lbr feature was used in the last vCPU time slice, set the lbr
  stack to be interceptible, so that the host can capture whether the
  lbr feature will be used in this time slice;
- if the lbr feature wasn't used in the last vCPU time slice, disable
  the vCPU support of the guest lbr switching.

Upon the first access to one of the lbr related MSRs (since the vCPU was
scheduled in):
- record that the guest has used the lbr;
- create a host perf event to help save/restore the guest lbr stack;
- pass the stack through to the guest.

Suggested-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/pmu.c              |   6 ++
 arch/x86/kvm/pmu.h              |   2 +
 arch/x86/kvm/vmx/pmu_intel.c    | 141 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |   4 +-
 arch/x86/kvm/vmx/vmx.h          |   2 +
 arch/x86/kvm/x86.c              |   2 +
 7 files changed, 157 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 79e9c92..cf8996e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -469,6 +469,8 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	/* Indicate if the lbr msrs were accessed in this vCPU time slice */
+	bool lbr_used;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index ee6ed47..323bb45 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -325,6 +325,12 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return kvm_x86_ops->pmu_ops->set_msr(vcpu, msr_info);
 }
 
+void kvm_pmu_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	if (kvm_x86_ops->pmu_ops->sched_in)
+		kvm_x86_ops->pmu_ops->sched_in(vcpu, cpu);
+}
+
 /* refresh PMU settings. This function generally is called when underlying
  * settings are changed (such as changes of PMU CPUID by guest VMs), which
  * should rarely happen.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 384a0b7..cadf91a 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -32,6 +32,7 @@ struct kvm_pmu_ops {
 	bool (*lbr_enable)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+	void (*sched_in)(struct kvm_vcpu *vcpu, int cpu);
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
@@ -116,6 +117,7 @@ int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+void kvm_pmu_sched_in(struct kvm_vcpu *vcpu, int cpu);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
 void kvm_pmu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 24a544e..fd09777 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -13,10 +13,12 @@
 #include <linux/perf_event.h>
 #include <asm/perf_event.h>
 #include <asm/intel-family.h>
+#include <asm/vmx.h>
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
 #include "pmu.h"
+#include "vmx.h"
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
@@ -141,6 +143,18 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[idx];
 }
 
+static inline bool is_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
+{
+	struct x86_perf_lbr_stack *stack = &vcpu->kvm->arch.lbr_stack;
+	int nr = stack->nr;
+
+	return !!(index == MSR_LBR_SELECT ||
+		  index == stack->tos ||
+		  (index >= stack->from && index < stack->from + nr) ||
+		  (index >= stack->to && index < stack->to + nr) ||
+		  (index >= stack->info && index < stack->info));
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -152,9 +166,12 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 	case MSR_IA32_PERF_CAPABILITIES:
+	case MSR_IA32_DEBUGCTLMSR:
 		ret = pmu->version > 1;
 		break;
 	default:
+		if (is_lbr_msr(vcpu, msr))
+			return pmu->version > 1;
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
 			get_fixed_pmc(pmu, msr);
@@ -298,6 +315,104 @@ static bool intel_pmu_lbr_enable(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static void intel_pmu_set_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu,
+						 bool set)
+{
+	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	struct x86_perf_lbr_stack *stack = &vcpu->kvm->arch.lbr_stack;
+	int nr = stack->nr;
+	int i;
+
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_SELECT,
+				  MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(msr_bitmap, stack->tos,
+				  MSR_TYPE_RW, set);
+	for (i = 0; i < nr; i++) {
+		vmx_set_intercept_for_msr(msr_bitmap, stack->from + i,
+					  MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(msr_bitmap, stack->to + i,
+					  MSR_TYPE_RW, set);
+		if (stack->info)
+			vmx_set_intercept_for_msr(msr_bitmap, stack->info + i,
+						  MSR_TYPE_RW, set);
+	}
+}
+
+static bool intel_pmu_get_lbr_msr(struct kvm_vcpu *vcpu,
+			      struct msr_data *msr_info)
+{
+	u32 index = msr_info->index;
+	bool ret = false;
+
+	switch (index) {
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		ret = true;
+		break;
+	default:
+		if (is_lbr_msr(vcpu, index)) {
+			ret = true;
+			rdmsrl(index, msr_info->data);
+		}
+	}
+
+	return ret;
+}
+
+static bool intel_pmu_set_lbr_msr(struct kvm_vcpu *vcpu,
+				  struct msr_data *msr_info)
+{
+	u32 index = msr_info->index;
+	u64 data = msr_info->data;
+	bool ret = false;
+
+	switch (index) {
+	case MSR_IA32_DEBUGCTLMSR:
+		ret = true;
+		/*
+		 * Currently, only FREEZE_LBRS_ON_PMI and DEBUGCTLMSR_LBR are
+		 * supported.
+		 */
+		data &= (DEBUGCTLMSR_FREEZE_LBRS_ON_PMI | DEBUGCTLMSR_LBR);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		break;
+	default:
+		if (is_lbr_msr(vcpu, index)) {
+			ret = true;
+			wrmsrl(index, data);
+		}
+	}
+
+	return ret;
+}
+
+static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
+				 struct msr_data *msr_info,
+				 bool set)
+{
+	bool ret = false;
+
+	/*
+	 * Some userspace implementations (e.g. QEMU) expects the msrs to be
+	 * always accesible.
+	 */
+	if (!msr_info->host_initiated && !vcpu->kvm->arch.lbr_in_guest)
+		return false;
+
+	if (set)
+		ret = intel_pmu_set_lbr_msr(vcpu, msr_info);
+	else
+		ret = intel_pmu_get_lbr_msr(vcpu, msr_info);
+
+	if (ret && !vcpu->arch.pmu.lbr_used) {
+		vcpu->arch.pmu.lbr_used = true;
+		intel_pmu_set_intercept_for_lbr_msrs(vcpu, false);
+		intel_pmu_enable_save_guest_lbr(vcpu);
+	}
+
+	return ret;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -344,6 +459,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, false)) {
+			return 0;
 		}
 	}
 
@@ -407,12 +524,33 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, true)) {
+			return 0;
 		}
 	}
 
 	return 1;
 }
 
+static void intel_pmu_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u64 guest_debugctl;
+
+	if (pmu->lbr_used) {
+		pmu->lbr_used = false;
+		intel_pmu_set_intercept_for_lbr_msrs(vcpu, true);
+	} else if (pmu->vcpu_lbr_event) {
+		/*
+		 * The lbr feature wasn't used during that last vCPU time
+		 * slice, so it's time to disable the vCPU side save/restore.
+		 */
+		guest_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		if (!(guest_debugctl & DEBUGCTLMSR_LBR))
+			intel_pmu_disable_save_guest_lbr(vcpu);
+	}
+}
+
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -505,6 +643,8 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
+
+	intel_pmu_disable_save_guest_lbr(vcpu);
 }
 
 int intel_pmu_enable_save_guest_lbr(struct kvm_vcpu *vcpu)
@@ -579,6 +719,7 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.lbr_enable = intel_pmu_lbr_enable,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
+	.sched_in = intel_pmu_sched_in,
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d98eac3..5dc0dcf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3523,8 +3523,8 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap, u32 msr, int type,
+			       bool value)
 {
 	if (value)
 		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 61128b4..ed94909 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -317,6 +317,8 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap, u32 msr, int type,
+			       bool value);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e34286..a3bc7f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9233,6 +9233,8 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->arch.l1tf_flush_l1d = true;
+
+	kvm_pmu_sched_in(vcpu, cpu);
 	kvm_x86_ops->sched_in(vcpu, cpu);
 }
 
-- 
2.7.4

