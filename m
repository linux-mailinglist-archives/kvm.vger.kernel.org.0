Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E53221AA8
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgGPDRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:17:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:8148 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgGPDRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:17:04 -0400
IronPort-SDR: ChyNNk7yQntGanN2rjJTM8gzJbbPNyz9WCCh8pBdtkdHGYCzRK5OSbLB7KQEg9z/Zpto8/qJNG
 5huMYpV4Cc+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210844851"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210844851"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:17:03 -0700
IronPort-SDR: AtgFEO+Y19gOCmjaM1cJXjz5Bw/OabRMHZWeZ3Hlub8IMKfHzBUipcl1NZG6Uk1sQtjVk0DPsl
 9QXbm0nqmpfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="360910445"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2020 20:17:01 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND v13 04/11] KVM: VMX: Configure CET settings upon guest CR0/4 changing
Date:   Thu, 16 Jul 2020 11:16:20 +0800
Message-Id: <20200716031627.11492-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200716031627.11492-1-weijiang.yang@intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CR4.CET is master control bit for CET function. There're mutual constrains
between CR0.WP and CR4.CET, so need to check the dependent bit while changing
the control registers.

The processor does not allow CR4.CET to be set if CR0.WP = 0,similarly, it does
not allow CR0.WP to be cleared while CR4.CET = 1. In either case, KVM would
inject #GP to guest.

CET state load bit is set/cleared along with CR4.CET bit set/clear.

Note:
SHSTK and IBT features share one control MSR: MSR_IA32_{U,S}_CET, which means
it's difficult to hide one feature from another in the case of SHSTK != IBT,
after discussed in community, it's agreed to allow guest control two features
independently as it won't introduce security hole.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 30 ++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |  3 +++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4bbd8b448d22..dbc87c5997cc 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -103,6 +103,11 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
 }
 
+static inline bool cpu_has_load_cet_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE) &&
+		(vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_CET_STATE);
+}
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a9f135c52cbc..0089943fbb31 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2510,7 +2510,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2534,7 +2535,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -3133,6 +3135,12 @@ static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_states)
 		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
 }
 
+static bool is_cet_supported(struct kvm_vcpu *vcpu)
+{
+	return is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER |
+				      XFEATURE_MASK_CET_KERNEL);
+}
+
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3173,6 +3181,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && (!is_cet_supported(vcpu) ||
+	    !(kvm_read_cr0(vcpu) & X86_CR0_WP)))
+		return 1;
+
 	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
 
@@ -3204,6 +3216,20 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
 	}
 
+	if (cpu_has_load_cet_ctrl()) {
+		if ((hw_cr4 & X86_CR4_CET) && is_cet_supported(vcpu)) {
+			vm_entry_controls_setbit(to_vmx(vcpu),
+						 VM_ENTRY_LOAD_CET_STATE);
+			vm_exit_controls_setbit(to_vmx(vcpu),
+						VM_EXIT_LOAD_CET_STATE);
+		} else {
+			vm_entry_controls_clearbit(to_vmx(vcpu),
+						   VM_ENTRY_LOAD_CET_STATE);
+			vm_exit_controls_clearbit(to_vmx(vcpu),
+						  VM_EXIT_LOAD_CET_STATE);
+		}
+	}
+
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, hw_cr4);
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ea8a9dc9fbad..906e07039d59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -815,6 +815,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_ops.set_cr0(vcpu, cr0);
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-- 
2.17.2

