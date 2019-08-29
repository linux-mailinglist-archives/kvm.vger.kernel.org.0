Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD14A10FA
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 07:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfH2FjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 01:39:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:42165 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbfH2FjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 01:39:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 22:39:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="210416315"
Received: from icl-2s.bj.intel.com ([10.240.193.48])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2019 22:39:20 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [RFC v1 7/9] KVM: X86: Expose PDCM cpuid to guest
Date:   Thu, 29 Aug 2019 13:34:07 +0800
Message-Id: <1567056849-14608-8-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PDCM (Perfmon and Debug Capability) indicates the processor
supports the performance and debug feature indication
MSR IA32_PERF_CAPABILITIES.

PEBS enabling in KVM guest depend on PEBS via PT, and
PEBS via PT is detected by IA32_PERF_CAPABILITIES[Bit16].

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  3 ++-
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx/capabilities.h | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.c          |  1 +
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 07d3b21..2d9b0f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1129,6 +1129,7 @@ struct kvm_x86_ops {
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
+	bool (*pdcm_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720..d12e7af 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -430,6 +430,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
 	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
+	unsigned f_pdcm = kvm_x86_ops->pdcm_supported() ? F(PDCM) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_cpuid_1_edx_x86_features =
@@ -458,7 +459,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
 		0 /* DS-CPL, VMX, SMX, EST */ |
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
-		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
+		F(FMA) | F(CX16) | 0 /* xTPR Update */ | f_pdcm |
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e036807..8ae6716 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6005,6 +6005,11 @@ static bool svm_pt_supported(void)
 	return false;
 }
 
+static bool svm_pdcm_supported(void)
+{
+	return false;
+}
+
 static bool svm_has_wbinvd_exit(void)
 {
 	return true;
@@ -7293,6 +7298,7 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
+	.pdcm_supported = svm_pdcm_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4bcb6b4..82ca51d 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -353,4 +353,14 @@ static inline bool cpu_has_vmx_pebs_output_pt(void)
 		(perf_cap & MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT));
 }
 
+static inline bool vmx_pebs_supported(void)
+{
+	return (cpu_has_vmx_pebs_output_pt() && pt_mode == PT_MODE_HOST_GUEST);
+}
+
+static inline bool vmx_pdcm_supported(void)
+{
+	return boot_cpu_has(X86_FEATURE_PDCM) && vmx_pebs_supported();
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4090c08..dbff8f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7768,6 +7768,7 @@ static __exit void hardware_unsetup(void)
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
+	.pdcm_supported = vmx_pdcm_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-- 
1.8.3.1

