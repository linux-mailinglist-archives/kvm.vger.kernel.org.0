Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7734C34D
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhC2FvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:51:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:15632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231466AbhC2Fuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:50:39 -0400
IronPort-SDR: Tn1UkLFCzhxQtV72ITryQweGPspJ5QhNPCCZdtn05ZbiA/Hwt7szn9xX+zclLElRzEccgr1ce/
 KwWw9uKdIDTg==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="255478777"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="255478777"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 22:50:25 -0700
IronPort-SDR: AV7WsDBH8TmQnMrOqrdFcgHRYJGgDqdPzssgSfe8fSxWrtiKMNfpvvbK/2kjrIM9DjgoaarJKQ
 2OUfLR6ePWiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="417507204"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2021 22:50:21 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v4 16/16] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
Date:   Mon, 29 Mar 2021 13:41:37 +0800
Message-Id: <20210329054137.120994-17-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
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
 arch/x86/kvm/vmx/capabilities.h | 26 ++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d1d77985e889..df06da09f84c 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -5,6 +5,7 @@
 #include <asm/vmx.h>
 
 #include "lapic.h"
+#include "pmu.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -378,20 +379,33 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
-static inline u64 vmx_get_perf_capabilities(void)
+static inline bool vmx_pebs_supported(void)
 {
-	u64 perf_cap = 0;
+	struct x86_pmu_capability x86_pmu;
 
-	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+	perf_get_x86_pmu_capability(&x86_pmu);
 
-	perf_cap &= PMU_CAP_LBR_FMT;
+	return boot_cpu_has(X86_FEATURE_PEBS) && x86_pmu.pebs_vmx;
+}
 
+static inline u64 vmx_get_perf_capabilities(void)
+{
 	/*
 	 * Since counters are virtualized, KVM would support full
 	 * width counting unconditionally, even if the host lacks it.
 	 */
-	return PMU_CAP_FW_WRITES | perf_cap;
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+	u64 host_perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+
+	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+
+	if (vmx_pebs_supported())
+		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
+
+	return perf_cap;
 }
 
 static inline u64 vmx_supported_debugctl(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b0f2cb790359..7cd9370357f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2262,6 +2262,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
+		if (data & PERF_CAP_PEBS_FORMAT) {
+			if ((data & PERF_CAP_PEBS_MASK) !=
+			    (vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
+				return 1;
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
+				return 1;
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_DTES64))
+				return 1;
+			if (!cpuid_model_is_consistent(vcpu))
+				return 1;
+		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
 
@@ -7264,6 +7275,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
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

