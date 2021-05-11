Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89754379D19
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 04:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhEKCpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 22:45:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:39591 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhEKCpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 22:45:05 -0400
IronPort-SDR: MzaRrMQeuBceDeWrAR0mK8sF59cku1ad/Ag7eaaky5nGqisDi/xE97llmzuojho60WHYHEELwu
 PsAJjAAUyaTA==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199015648"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199015648"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 19:43:59 -0700
IronPort-SDR: 8IDvFQRQksm1qm23OjKoWu+k/Tl+DJ0h0x1+uVL59Vq/jFHp8u8vhhQ5IHfzZ3pBaVSKxLwA2z
 bxLY4ouCVP2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="468592057"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2021 19:43:55 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v6 14/16] KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
Date:   Tue, 11 May 2021 10:42:12 +0800
Message-Id: <20210511024214.280733-15-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511024214.280733-1-like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The information obtained from the interface perf_get_x86_pmu_capability()
doesn't change, so an exported global "struct x86_pmu_capability" can be
introduced for all guests in the KVM, and it's initialized before
hardware_setup().

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 24 +++++++-----------------
 arch/x86/kvm/pmu.c           |  3 +++
 arch/x86/kvm/pmu.h           | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 17 ++++++++---------
 arch/x86/kvm/x86.c           |  9 ++++-----
 5 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9a48f138832d..a654fac41c22 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -744,32 +744,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 9:
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-		struct x86_pmu_capability cap;
 		union cpuid10_eax eax;
 		union cpuid10_edx edx;
 
-		perf_get_x86_pmu_capability(&cap);
+		eax.split.version_id = kvm_pmu_cap.version;
+		eax.split.num_counters = kvm_pmu_cap.num_counters_gp;
+		eax.split.bit_width = kvm_pmu_cap.bit_width_gp;
+		eax.split.mask_length = kvm_pmu_cap.events_mask_len;
 
-		/*
-		 * Only support guest architectural pmu on a host
-		 * with architectural pmu.
-		 */
-		if (!cap.version)
-			memset(&cap, 0, sizeof(cap));
-
-		eax.split.version_id = min(cap.version, 2);
-		eax.split.num_counters = cap.num_counters_gp;
-		eax.split.bit_width = cap.bit_width_gp;
-		eax.split.mask_length = cap.events_mask_len;
-
-		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
-		edx.split.bit_width_fixed = cap.bit_width_fixed;
+		edx.split.num_counters_fixed = kvm_pmu_cap.num_counters_fixed;
+		edx.split.bit_width_fixed = kvm_pmu_cap.bit_width_fixed;
 		edx.split.anythread_deprecated = 1;
 		edx.split.reserved1 = 0;
 		edx.split.reserved2 = 0;
 
 		entry->eax = eax.full;
-		entry->ebx = cap.events_mask;
+		entry->ebx = kvm_pmu_cap.events_mask;
 		entry->ecx = 0;
 		entry->edx = edx.full;
 		break;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 666a5e90a3cb..4798bf991b60 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -19,6 +19,9 @@
 #include "lapic.h"
 #include "pmu.h"
 
+struct x86_pmu_capability __read_mostly kvm_pmu_cap;
+EXPORT_SYMBOL_GPL(kvm_pmu_cap);
+
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ef5b6ee8fdc7..832cf56e6924 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -160,6 +160,24 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
+extern struct x86_pmu_capability kvm_pmu_cap;
+
+static inline void kvm_init_pmu_capability(void)
+{
+	perf_get_x86_pmu_capability(&kvm_pmu_cap);
+
+	/*
+	 * Only support guest architectural pmu on
+	 * a host with architectural pmu.
+	 */
+	if (!kvm_pmu_cap.version)
+		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
+
+	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
+	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
+					     MAX_FIXED_COUNTERS);
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
@@ -177,9 +195,11 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+void kvm_init_pmu_capability(void);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
+
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 28152d7fd12d..d0610716675b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -504,8 +504,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
-
-	struct x86_pmu_capability x86_pmu;
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
@@ -532,13 +530,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
-	perf_get_x86_pmu_capability(&x86_pmu);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
-					 x86_pmu.num_counters_gp);
-	eax.split.bit_width = min_t(int, eax.split.bit_width, x86_pmu.bit_width_gp);
+					 kvm_pmu_cap.num_counters_gp);
+	eax.split.bit_width = min_t(int, eax.split.bit_width,
+				    kvm_pmu_cap.bit_width_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
-	eax.split.mask_length = min_t(int, eax.split.mask_length, x86_pmu.events_mask_len);
+	eax.split.mask_length = min_t(int, eax.split.mask_length,
+				      kvm_pmu_cap.events_mask_len);
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
 
@@ -547,9 +546,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	} else {
 		pmu->nr_arch_fixed_counters =
 			min_t(int, edx.split.num_counters_fixed,
-			      x86_pmu.num_counters_fixed);
-		edx.split.bit_width_fixed = min_t(int,
-			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
+			      kvm_pmu_cap.num_counters_fixed);
+		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
+						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c1ab5bcf75cc..0a86a9f34dce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5969,15 +5969,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 static void kvm_init_msr_list(void)
 {
-	struct x86_pmu_capability x86_pmu;
 	u32 dummy[2];
 	unsigned i;
 
 	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
 			 "Please update the fixed PMCs in msrs_to_saved_all[]");
 
-	perf_get_x86_pmu_capability(&x86_pmu);
-
 	num_msrs_to_save = 0;
 	num_emulated_msrs = 0;
 	num_msr_based_features = 0;
@@ -6029,12 +6026,12 @@ static void kvm_init_msr_list(void)
 			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
-			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
-			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
 		default:
@@ -10618,6 +10615,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
+	kvm_init_pmu_capability();
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		return r;
-- 
2.31.1

