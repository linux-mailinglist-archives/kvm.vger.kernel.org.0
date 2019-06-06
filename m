Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5289D36DB3
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfFFHog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:44:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:24992 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbfFFHoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:33 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:31 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 04/12] KVM/x86: intel_pmu_lbr_enable
Date:   Thu,  6 Jun 2019 15:02:23 +0800
Message-Id: <1559804551-42271-5-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
References: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lbr stack is architecturally specific, for example, SKX has 32 lbr
stack entries while HSW has 16 entries, so a HSW guest running on a SKX
machine may not get accurate perf results. Currently, we forbid the
guest lbr enabling when the guest and host see different lbr stack
entries or the host and guest see different lbr stack msr indices.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kvm/cpuid.h         |   8 +++
 arch/x86/kvm/pmu.c           |   8 +++
 arch/x86/kvm/pmu.h           |   2 +
 arch/x86/kvm/vmx/pmu_intel.c | 136 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c           |   3 +-
 5 files changed, 155 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 9a327d5..92bdc7d 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -123,6 +123,14 @@ static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
 	return best && best->ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx;
 }
 
+static inline bool guest_cpuid_is_intel(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0, 0);
+	return best && best->ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx;
+}
+
 static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index dd745b5..fea8a67 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -299,6 +299,14 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	return 0;
 }
 
+bool kvm_pmu_lbr_enable(struct kvm_vcpu *vcpu)
+{
+	if (guest_cpuid_is_intel(vcpu))
+		return kvm_x86_ops->pmu_ops->lbr_enable(vcpu);
+
+	return false;
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu))
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 22dff66..c099b4b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -29,6 +29,7 @@ struct kvm_pmu_ops {
 					  u64 *mask);
 	int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
+	bool (*lbr_enable)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	void (*refresh)(struct kvm_vcpu *vcpu);
@@ -107,6 +108,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
 
+bool kvm_pmu_lbr_enable(struct kvm_vcpu *vcpu);
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a99613a..b465ff0 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -15,6 +15,7 @@
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
 #include <asm/perf_event.h>
+#include <asm/intel-family.h>
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
@@ -165,6 +166,140 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return ret;
 }
 
+static bool intel_pmu_lbr_enable(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u8 vcpu_model = guest_cpuid_model(vcpu);
+	unsigned int vcpu_lbr_from, vcpu_lbr_nr;
+
+	if (x86_perf_get_lbr_stack(&kvm->arch.lbr_stack))
+		return false;
+
+	if (guest_cpuid_family(vcpu) != boot_cpu_data.x86)
+		return false;
+
+	/*
+	 * It could be possible that people have vcpus of old model run on
+	 * physcal cpus of newer model, for example a BDW guest on a SKX
+	 * machine (but not possible to be the other way around).
+	 * The BDW guest may not get accurate results on a SKX machine as it
+	 * only reads 16 entries of the lbr stack while there are 32 entries
+	 * of recordings. We currently forbid the lbr enabling when the vcpu
+	 * and physical cpu see different lbr stack entries or the guest lbr
+	 * msr indices are not compatible with the host.
+	 */
+	switch (vcpu_model) {
+	case INTEL_FAM6_CORE2_MEROM:
+	case INTEL_FAM6_CORE2_MEROM_L:
+	case INTEL_FAM6_CORE2_PENRYN:
+	case INTEL_FAM6_CORE2_DUNNINGTON:
+		/* intel_pmu_lbr_init_core() */
+		vcpu_lbr_nr = 4;
+		vcpu_lbr_from = MSR_LBR_CORE_FROM;
+		break;
+	case INTEL_FAM6_NEHALEM:
+	case INTEL_FAM6_NEHALEM_EP:
+	case INTEL_FAM6_NEHALEM_EX:
+		/* intel_pmu_lbr_init_nhm() */
+		vcpu_lbr_nr = 16;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_ATOM_BONNELL:
+	case INTEL_FAM6_ATOM_BONNELL_MID:
+	case INTEL_FAM6_ATOM_SALTWELL:
+	case INTEL_FAM6_ATOM_SALTWELL_MID:
+	case INTEL_FAM6_ATOM_SALTWELL_TABLET:
+		/* intel_pmu_lbr_init_atom() */
+		vcpu_lbr_nr = 8;
+		vcpu_lbr_from = MSR_LBR_CORE_FROM;
+		break;
+	case INTEL_FAM6_ATOM_SILVERMONT:
+	case INTEL_FAM6_ATOM_SILVERMONT_X:
+	case INTEL_FAM6_ATOM_SILVERMONT_MID:
+	case INTEL_FAM6_ATOM_AIRMONT:
+	case INTEL_FAM6_ATOM_AIRMONT_MID:
+		/* intel_pmu_lbr_init_slm() */
+		vcpu_lbr_nr = 8;
+		vcpu_lbr_from = MSR_LBR_CORE_FROM;
+		break;
+	case INTEL_FAM6_ATOM_GOLDMONT:
+	case INTEL_FAM6_ATOM_GOLDMONT_X:
+		/* intel_pmu_lbr_init_skl(); */
+		vcpu_lbr_nr = 32;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
+		/* intel_pmu_lbr_init_skl()*/
+		vcpu_lbr_nr = 32;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_WESTMERE:
+	case INTEL_FAM6_WESTMERE_EP:
+	case INTEL_FAM6_WESTMERE_EX:
+		/* intel_pmu_lbr_init_nhm() */
+		vcpu_lbr_nr = 16;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_SANDYBRIDGE:
+	case INTEL_FAM6_SANDYBRIDGE_X:
+		/* intel_pmu_lbr_init_snb() */
+		vcpu_lbr_nr = 16;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_IVYBRIDGE:
+	case INTEL_FAM6_IVYBRIDGE_X:
+		/* intel_pmu_lbr_init_snb() */
+		vcpu_lbr_nr = 16;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_HASWELL_CORE:
+	case INTEL_FAM6_HASWELL_X:
+	case INTEL_FAM6_HASWELL_ULT:
+	case INTEL_FAM6_HASWELL_GT3E:
+		/* intel_pmu_lbr_init_hsw() */
+		vcpu_lbr_nr = 16;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_BROADWELL_CORE:
+	case INTEL_FAM6_BROADWELL_XEON_D:
+	case INTEL_FAM6_BROADWELL_GT3E:
+	case INTEL_FAM6_BROADWELL_X:
+		/* intel_pmu_lbr_init_hsw() */
+		vcpu_lbr_nr = 16;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_XEON_PHI_KNL:
+	case INTEL_FAM6_XEON_PHI_KNM:
+		/* intel_pmu_lbr_init_knl() */
+		vcpu_lbr_nr = 8;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	case INTEL_FAM6_SKYLAKE_MOBILE:
+	case INTEL_FAM6_SKYLAKE_DESKTOP:
+	case INTEL_FAM6_SKYLAKE_X:
+	case INTEL_FAM6_KABYLAKE_MOBILE:
+	case INTEL_FAM6_KABYLAKE_DESKTOP:
+		/* intel_pmu_lbr_init_skl() */
+		vcpu_lbr_nr = 32;
+		vcpu_lbr_from = MSR_LBR_NHM_FROM;
+		break;
+	default:
+		vcpu_lbr_nr = 0;
+		vcpu_lbr_from = 0;
+		pr_warn("%s: vcpu model not supported %d\n", __func__,
+			vcpu_model);
+	}
+
+	if (vcpu_lbr_nr != kvm->arch.lbr_stack.nr ||
+	    vcpu_lbr_from != kvm->arch.lbr_stack.from) {
+		pr_warn("%s: vcpu model %x incompatible to pcpu %x\n",
+			__func__, vcpu_model, boot_cpu_data.x86_model);
+		return false;
+	}
+
+	return true;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -364,6 +499,7 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
 	.is_valid_msr_idx = intel_is_valid_msr_idx,
 	.is_valid_msr = intel_is_valid_msr,
+	.lbr_enable = intel_pmu_lbr_enable,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
 	.refresh = intel_pmu_refresh,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 524e663..44a300f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4625,8 +4625,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_X86_GUEST_LBR:
 		r = -EINVAL;
-		if (cap->args[0] &&
-		    x86_perf_get_lbr_stack(&kvm->arch.lbr_stack))
+		if (cap->args[0] && !kvm_pmu_lbr_enable(kvm->vcpus[0]))
 			break;
 
 		if (copy_to_user((void __user *)cap->args[1],
-- 
2.7.4

