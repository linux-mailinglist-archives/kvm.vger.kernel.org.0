Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524DE176911
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgCCACY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:02:24 -0500
Received: from mga17.intel.com ([192.55.52.151]:37735 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbgCBX5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384686"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 21/66] KVM: x86: Use supported_xcr0 to detect MPX support
Date:   Mon,  2 Mar 2020 15:56:24 -0800
Message-Id: <20200302235709.27467-22-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Query supported_xcr0 when checking for MPX support instead of invoking
->mpx_supported() and drop ->mpx_supported() as kvm_mpx_supported() was
its last user.  Rename vmx_mpx_supported() to cpu_has_vmx_mpx() to
better align with VMX/VMCS nomenclature.

Modify VMX's adjustment of xcr0 to call cpus_has_vmx_mpx() (renamed from
vmx_mpx_supported()) directly to avoid reading supported_xcr0 before
it's fully configured.

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/cpuid.c            | 3 +--
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/capabilities.h | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 3 +--
 5 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5edf6425c747..9a4ae6ef0d7a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1169,7 +1169,7 @@ struct kvm_x86_ops {
 			       enum x86_intercept_stage stage);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion *exit_fastpath);
-	bool (*mpx_supported)(void);
+
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1eb775c33c4e..54af2c19388b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -47,8 +47,7 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 
 bool kvm_mpx_supported(void)
 {
-	return ((host_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR))
-		 && kvm_x86_ops->mpx_supported());
+	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
 }
 EXPORT_SYMBOL_GPL(kvm_mpx_supported);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 51db8addda04..16c4b7eb6312 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6079,11 +6079,6 @@ static bool svm_invpcid_supported(void)
 	return false;
 }
 
-static bool svm_mpx_supported(void)
-{
-	return false;
-}
-
 static bool svm_xsaves_supported(void)
 {
 	return boot_cpu_has(X86_FEATURE_XSAVES);
@@ -7465,7 +7460,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.rdtscp_supported = svm_rdtscp_supported,
 	.invpcid_supported = svm_invpcid_supported,
-	.mpx_supported = svm_mpx_supported,
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 80eec8cffbe2..c00e26570198 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -101,7 +101,7 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
 }
 
-static inline bool vmx_mpx_supported(void)
+static inline bool cpu_has_vmx_mpx(void)
 {
 	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf874c364c8f..17dc4dc2a7f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7655,7 +7655,7 @@ static __init int hardware_setup(void)
 		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
 	}
 
-	if (!kvm_mpx_supported())
+	if (!cpu_has_vmx_mpx())
 		supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
 				    XFEATURE_MASK_BNDCSR);
 
@@ -7922,7 +7922,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-	.mpx_supported = vmx_mpx_supported,
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
-- 
2.24.1

