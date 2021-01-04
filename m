Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D872E95F1
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbhADN1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:27:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:23246 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbhADN1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:27:51 -0500
IronPort-SDR: gvZlxIob5E1rHyJbhmn7g0TIJwGZhIilrnScVGjbFpo5DfENYue04XP6Qhbc03rZQPPJYRlvMM
 RMKn7ZtS46fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034368"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034368"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:32 -0800
IronPort-SDR: 2ClTuwdre+ashFI/IodTy4xYrURt7mpTaTansZZm+gyGJdoyZTAWxYdbvoDogR+FRo1gXZWzzB
 QvU1u/v4b50w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944620"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:29 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
Date:   Mon,  4 Jan 2021 21:15:35 +0800
Message-Id: <20210104131542.495413-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The CPUID features PDCM, DS and DTES64 are required for PEBS feature.
KVM would expose CPUID feature PDCM, DS and DTES64 to guest when PEBS
is supported in the KVM on the Ice Lake server platforms.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.h              |  6 ++++++
 arch/x86/kvm/vmx/capabilities.h | 17 ++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 067fef51760c..ee8f15cc4b5e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -3,6 +3,7 @@
 #define __KVM_X86_PMU_H
 
 #include <linux/nospec.h>
+#include <asm/cpu_device_id.h>
 
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
@@ -16,6 +17,11 @@
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
 #define MAX_FIXED_COUNTERS	3
+static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	{}
+};
 
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3a1861403d73..2f22ce34b165 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -5,6 +5,7 @@
 #include <asm/vmx.h>
 
 #include "lapic.h"
+#include "pmu.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -369,13 +370,27 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+static inline bool vmx_pebs_supported(void)
+{
+	return boot_cpu_has(X86_FEATURE_PEBS) && x86_match_cpu(vmx_icl_pebs_cpu);
+}
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	/*
 	 * Since counters are virtualized, KVM would support full
 	 * width counting unconditionally, even if the host lacks it.
 	 */
-	return PMU_CAP_FW_WRITES;
+	u64 value = PMU_CAP_FW_WRITES;
+	u64 perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	if (vmx_pebs_supported())
+		value |= perf_cap & PERF_CAP_PEBS_MASK;
+
+	return value;
 }
 
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dbb0e49aae64..341794b67f9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2200,6 +2200,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
+		if (data & PERF_CAP_PEBS_FORMAT) {
+			if ((data & PERF_CAP_PEBS_MASK) !=
+			    (vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
+				return 1;
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
+				return 1;
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_DTES64))
+				return 1;
+			if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
+				return 1;
+		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
 
@@ -7277,6 +7288,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (vmx_pebs_supported()) {
+		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
+	}
 
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
-- 
2.29.2

