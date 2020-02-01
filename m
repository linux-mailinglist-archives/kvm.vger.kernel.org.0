Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A8714F98A
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBASwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:30 -0500
Received: from mga05.intel.com ([192.55.52.43]:37509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgBASw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075528"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 33/61] KVM: x86: Handle PKU CPUID adjustment in VMX code
Date:   Sat,  1 Feb 2020 10:51:50 -0800
Message-Id: <20200201185218.24473-34-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the setting of the PKU CPUID bit into VMX to eliminate an instance
of the undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in
the common CPUID handling code.  Drop ->pku_supported(), CPUID
adjustment was the only user.

Note, some AMD CPUs now support PKU, but SVM doesn't yet support
exposing it to a guest.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/cpuid.c            | 5 -----
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/capabilities.h | 5 -----
 arch/x86/kvm/vmx/vmx.c          | 6 +++++-
 5 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9baff70ad419..ba828569cda5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1166,7 +1166,6 @@ struct kvm_x86_ops {
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
-	bool (*pku_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 202a6c0f1db8..a1f46b3ca16e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -341,7 +341,6 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 {
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
-	unsigned f_pku = kvm_x86_ops->pku_supported() ? F(PKU) : 0;
 
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
@@ -381,10 +380,6 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 		cpuid_entry_mask(entry, CPUID_7_ECX);
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
-		entry->ecx |= f_pku;
-		/* PKU is not yet implemented for shadow paging. */
-		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
-			cpuid_entry_clear(entry, X86_FEATURE_PKU);
 
 		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
 		cpuid_entry_mask(entry, CPUID_7_EDX);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c0f8c09f3b04..630520f8adfa 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6094,11 +6094,6 @@ static bool svm_has_wbinvd_exit(void)
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
@@ -7457,7 +7452,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
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
index 9d2e36a5ecb9..a9728cc0c343 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7113,6 +7113,11 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
 		if (vmx_umip_emulated())
 			cpuid_entry_set(entry, X86_FEATURE_UMIP);
+
+		/* PKU is not yet implemented for shadow paging. */
+		if (enable_ept && boot_cpu_has(X86_FEATURE_PKU) &&
+		    boot_cpu_has(X86_FEATURE_OSPKE))
+			cpuid_entry_set(entry, X86_FEATURE_PKU);
 		break;
 	default:
 		break;
@@ -7868,7 +7873,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
-	.pku_supported = vmx_pku_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-- 
2.24.1

