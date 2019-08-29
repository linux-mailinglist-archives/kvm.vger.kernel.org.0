Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BF7A10F0
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 07:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfH2FjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 01:39:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:3590 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfH2FjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 01:39:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 22:39:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="210416167"
Received: from icl-2s.bj.intel.com ([10.240.193.48])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2019 22:38:55 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [RFC v1 2/9] KVM: x86: PEBS via Intel PT HW feature detection
Date:   Thu, 29 Aug 2019 13:34:02 +0800
Message-Id: <1567056849-14608-3-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PEBS can be enabled in KVM guest by direct PEBS record into the Intel
Processor Trace output buffer. This patch adds a new flag to detect
if PEBS can be supported in KVM guest. It not only need HW support PEBS
output Intel PT (IA32_PERF_CAPABILITIES.PEBS_OUTPUT_PT_AVAIL[16]=1)
but also depends on:
1. PEBS feature is supported by HW (IA32_MISC_ENABLE[Bit12]=0);
2. Intel PT must be working in HOST_GUEST mode.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  1 +
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/kvm/vmx/capabilities.h  | 11 +++++++++++
 arch/x86/kvm/vmx/pmu_intel.c     |  7 ++++++-
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74e88e5..3463326 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -472,6 +472,7 @@ struct kvm_pmu {
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
 	u8 version;
+	bool pebs_pt;	/* PEBS output to Intel PT */
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 271d837..3dd166a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -134,6 +134,7 @@
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
+#define MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT	(1UL << 16)
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
@@ -660,6 +661,8 @@
 #define MSR_IA32_MISC_ENABLE_FERR			(1ULL << MSR_IA32_MISC_ENABLE_FERR_BIT)
 #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT		10
 #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX		(1ULL << MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT)
+#define MSR_IA32_MISC_ENABLE_PEBS_BIT			12
+#define MSR_IA32_MISC_ENABLE_PEBS			(1ULL << MSR_IA32_MISC_ENABLE_PEBS_BIT)
 #define MSR_IA32_MISC_ENABLE_TM2_BIT			13
 #define MSR_IA32_MISC_ENABLE_TM2			(1ULL << MSR_IA32_MISC_ENABLE_TM2_BIT)
 #define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE_BIT	19
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d6664ee..4bcb6b4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -342,4 +342,15 @@ static inline bool cpu_has_vmx_intel_pt(void)
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
 
+static inline bool cpu_has_vmx_pebs_output_pt(void)
+{
+	u64 misc, perf_cap;
+
+	rdmsrl(MSR_IA32_MISC_ENABLE, misc);
+	rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	return (!(misc & MSR_IA32_MISC_ENABLE_PEBS) &&
+		(perf_cap & MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT));
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 01441be..e1c987f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -12,6 +12,7 @@
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
 #include <asm/perf_event.h>
+#include "capabilities.h"
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
@@ -309,10 +310,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
-	if (kvm_x86_ops->pt_supported())
+	if (kvm_x86_ops->pt_supported()) {
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
+		if (cpu_has_vmx_pebs_output_pt())
+			pmu->pebs_pt = true;
+	}
+
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
-- 
1.8.3.1

