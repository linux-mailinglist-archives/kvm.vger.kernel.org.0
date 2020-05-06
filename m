Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC40C1C6B55
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgEFITj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:19:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:35417 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbgEFITi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:19:38 -0400
IronPort-SDR: KGa8Y74irfC7woxe+Iy3m22Z09vuStycEXcgUmPrUsg8L58nilpYRhHpxMTRjjSZgx5DwAKJ5o
 wvs2qGmpG1qw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 01:19:38 -0700
IronPort-SDR: 7gOec2BXlveLpzogVbHH3Y1UyqeH34JAYFhSHMTk2kHZ8l7Y/WDJnVrq8eATzLuMR//0qy5fjZ
 caLB5PkAzzHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="260030087"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 01:19:36 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 03/10] KVM: VMX: Configure CET settings upon guest CR0/4 changing
Date:   Wed,  6 May 2020 16:21:02 +0800
Message-Id: <20200506082110.25441-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
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
index 8903475f751e..52223f7d31d8 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -101,6 +101,11 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
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
index 97e766875a7e..7137e252ab38 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2440,7 +2440,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2464,7 +2465,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -3027,6 +3029,12 @@ static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_states)
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
@@ -3067,6 +3075,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && (!is_cet_supported(vcpu) ||
+	    !(kvm_read_cr0(vcpu) & X86_CR0_WP)))
+		return 1;
+
 	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
 
@@ -3097,6 +3109,20 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
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
index 6390b62c12ed..b63727318da1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -803,6 +803,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_ops.set_cr0(vcpu, cr0);
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-- 
2.17.2

