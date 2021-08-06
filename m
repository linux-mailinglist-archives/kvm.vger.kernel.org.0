Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41573E2BAE
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 15:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbhHFNkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 09:40:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:44640 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344239AbhHFNkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 09:40:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="236350394"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="236350394"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:53 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="523463833"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:42 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V10 18/18] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
Date:   Fri,  6 Aug 2021 21:38:02 +0800
Message-Id: <20210806133802.3528-19-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210806133802.3528-1-lingshan.zhu@intel.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The CPUID features PDCM, DS and DTES64 are required for PEBS feature.
KVM would expose CPUID feature PDCM, DS and DTES64 to guest when PEBS
is supported in the KVM on the Ice Lake server platforms.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/vmx/capabilities.h | 26 ++++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4705ad55abb5..41b0933abdb1 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -5,6 +5,7 @@
 #include <asm/vmx.h>
 
 #include "lapic.h"
+#include "pmu.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -376,20 +377,29 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
-static inline u64 vmx_get_perf_capabilities(void)
+static inline bool vmx_pebs_supported(void)
 {
-	u64 perf_cap = 0;
-
-	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
-
-	perf_cap &= PMU_CAP_LBR_FMT;
+	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_vmx;
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
index d0af51c1389d..32dd90707b0d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2224,6 +2224,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
 
@@ -7225,6 +7236,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (vmx_pebs_supported()) {
+		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
+	}
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
-- 
2.27.0

