Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20DF14D3C8
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgA2Xqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:46:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:46688 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbgA2Xqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551753"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/26] KVM: x86: Handle PKU CPUID adjustment in SVM code
Date:   Wed, 29 Jan 2020 15:46:34 -0800
Message-Id: <20200129234640.8147-21-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the clearing of the PKU CPUID bit into SVM, which does not yet
support virtualizing PKU, to eliminate an instance of the undesirable
"unsigned f_* = *_supported ? F(*) : 0" pattern in the common CPUID
handling code.  Drop ->pku_supported() since CPUID adjustment was the
only user.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/cpuid.c            | 4 +---
 arch/x86/kvm/svm.c              | 7 +------
 arch/x86/kvm/vmx/capabilities.h | 5 -----
 arch/x86/kvm/vmx/vmx.c          | 1 -
 5 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b9c871c03bf5..8a685509c218 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1167,7 +1167,6 @@ struct kvm_x86_ops {
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
-	bool (*pku_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d835f4662fba..e376d648f94d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -323,7 +323,6 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 {
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
-	unsigned f_pku = kvm_x86_ops->pku_supported() ? F(PKU) : 0;
 
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
@@ -335,7 +334,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 
 	/* cpuid 7.0.ecx*/
 	const u32 kvm_cpuid_7_0_ecx_x86_features =
-		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
+		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
@@ -363,7 +362,6 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		cpuid_mask(&entry->ecx, CPUID_7_ECX);
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
-		entry->ecx |= f_pku;
 		/* PKU is not yet implemented for shadow paging. */
 		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
 			cpuid_entry_clear(entry, X86_FEATURE_PKU);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4ea530ff6a0c..1092d5e6c683 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6060,6 +6060,7 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 			cpuid_entry_clear(entry, X86_FEATURE_X2APIC);
 		break;
 	case 0x7:
+		cpuid_entry_clear(entry, X86_FEATURE_PKU);
 		cpuid_entry_clear(entry, X86_FEATURE_MPX);
 		cpuid_entry_clear(entry, X86_FEATURE_INVPCID);
 		break;
@@ -6120,11 +6121,6 @@ static bool svm_has_wbinvd_exit(void)
 	return true;
 }
 
-static bool svm_pku_supported(void)
-{
-	return false;
-}
-
 #define PRE_EX(exit)  { .exit_code = (exit), \
 			.stage = X86_ICPT_PRE_EXCEPT, }
 #define POST_EX(exit) { .exit_code = (exit), \
@@ -7484,7 +7480,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
-	.pku_supported = svm_pku_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 0a0b1494a934..7cae355e3490 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -145,11 +145,6 @@ static inline bool vmx_umip_emulated(void)
 		SECONDARY_EXEC_DESC;
 }
 
-static inline bool vmx_pku_supported(void)
-{
-	return boot_cpu_has(X86_FEATURE_PKU);
-}
-
 static inline bool cpu_has_vmx_rdtscp(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6bcdfb8744d3..3845ca7da6e0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7900,7 +7900,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
-	.pku_supported = vmx_pku_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-- 
2.24.1

