Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51E17A2AF
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgCEJ7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:59:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:9013 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbgCEJ7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:59:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:59:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366616"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:59:34 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 07/11] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
Date:   Fri,  6 Mar 2020 01:57:01 +0800
Message-Id: <1583431025-19802-8-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The CPUID features PDCM, DS and DTES64 are required for PEBS feature.
This patch expose CPUID feature PDCM, DS and DTES64 to guest when PEBS
is supported in KVM.

Originally-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/cpuid.c            |  9 ++++++---
 arch/x86/kvm/svm.c              | 12 ++++++++++++
 arch/x86/kvm/vmx/capabilities.h | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 5 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 83abb49..033d9f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1180,6 +1180,8 @@ struct kvm_x86_ops {
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
 	bool (*pku_supported)(void);
+	bool (*pdcm_supported)(void);
+	bool (*dtes64_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c4694..92dabf3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -446,6 +446,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
 	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
+	unsigned int f_pdcm = kvm_x86_ops->pdcm_supported() ? F(PDCM) : 0;
+	unsigned int f_ds = kvm_x86_ops->dtes64_supported() ? F(DS) : 0;
+	unsigned int f_dtes64 = kvm_x86_ops->dtes64_supported() ? F(DTES64) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_cpuid_1_edx_x86_features =
@@ -454,7 +457,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
 		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
-		0 /* Reserved, DS, ACPI */ | F(MMX) |
+		0 /* Reserved */ | f_ds | 0 /* ACPI */ | F(MMX) |
 		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
 		0 /* HTT, TM, Reserved, PBE */;
 	/* cpuid 0x80000001.edx */
@@ -471,10 +474,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	const u32 kvm_cpuid_1_ecx_x86_features =
 		/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
 		 * but *not* advertised to guests via CPUID ! */
-		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
+		F(XMM3) | F(PCLMULQDQ) | f_dtes64 | 0 /* MONITOR */ |
 		0 /* DS-CPL, VMX, SMX, EST */ |
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
-		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
+		F(FMA) | F(CX16) | 0 /* xTPR Update */ | f_pdcm |
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 24c0b2b..984ab6c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6123,6 +6123,16 @@ static bool svm_pku_supported(void)
 	return false;
 }
 
+static bool svm_pdcm_supported(void)
+{
+	return false;
+}
+
+static bool svm_dtes64_supported(void)
+{
+	return false;
+}
+
 #define PRE_EX(exit)  { .exit_code = (exit), \
 			.stage = X86_ICPT_PRE_EXCEPT, }
 #define POST_EX(exit) { .exit_code = (exit), \
@@ -7485,6 +7495,8 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
 	.pku_supported = svm_pku_supported,
+	.pdcm_supported = svm_pdcm_supported,
+	.dtes64_supported = svm_dtes64_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f486e26..9e352b5 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -5,6 +5,7 @@
 #include <asm/vmx.h>
 
 #include "lapic.h"
+#include "pmu.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -151,6 +152,22 @@ static inline bool vmx_pku_supported(void)
 	return boot_cpu_has(X86_FEATURE_PKU);
 }
 
+static inline bool vmx_pdcm_supported(void)
+{
+	if (kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported)
+		return kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported();
+
+	return false;
+}
+
+static inline bool vmx_dtes64_supported(void)
+{
+	if (kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported)
+		return kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported();
+
+	return false;
+}
+
 static inline bool cpu_has_vmx_rdtscp(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40b1e61..cef7089 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7951,6 +7951,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
 	.pku_supported = vmx_pku_supported,
+	.pdcm_supported = vmx_pdcm_supported,
+	.dtes64_supported = vmx_dtes64_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-- 
1.8.3.1

