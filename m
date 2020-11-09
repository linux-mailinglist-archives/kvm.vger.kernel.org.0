Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2F2AAF64
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgKICRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:64940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbgKICRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:31 -0500
IronPort-SDR: fOJOkMBZriwy8bGPIkcQSZLiBCrBoXaPAlnkQmZFJnfqh5CNZTaGzg98kBUR0l39oZhD+sa+b+
 wLDnYleaNfzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684634"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684634"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:29 -0800
IronPort-SDR: a9asSMsbRkeEiq6GXB7YeWZja9btnrKVbL92ubA0pn7d/VdX+5yJ9oAHdksHDbhX92jIHkIZJh
 uOQbrdhnTYpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646230"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:25 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
Date:   Mon,  9 Nov 2020 10:12:47 +0800
Message-Id: <20201109021254.79755-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
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
index 954c15fb9b00..3b62907c8959 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2201,6 +2201,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
 
@@ -7293,6 +7304,10 @@ static __init void vmx_set_cpu_caps(void)
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
2.21.3

