Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC676EBFF8
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 09:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfKAIuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 04:50:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:34433 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfKAIt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 04:49:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 01:49:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,254,1569308400"; 
   d="scan'208";a="194606613"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2019 01:49:55 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 4/7] KVM: VMX: Load CET states on vmentry/vmexit
Date:   Fri,  1 Nov 2019 16:52:19 +0800
Message-Id: <20191101085222.27997-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191101085222.27997-1-weijiang.yang@intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Load {guest,host} CET state" bit controls whether guest/host
CET states will be loaded at VM entry/exit. Before doing that,
KVM needs to check if CET is both enabled on host and guest.

Note: SHSTK and IBT features share one control MSR:
MSR_IA32_{U,S}_CET, which means it's difficult to hide
one feature from another in the case of SHSTK != IBT,
after discussed in community, it's agreed to allow Guest
control two features independently as it won't introduce
security hole.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/vmx/capabilities.h | 10 ++++++
 arch/x86/kvm/vmx/vmx.c          | 55 +++++++++++++++++++++++++++++++--
 3 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d018df8c5f32..f1e6cebaeb15 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -90,7 +90,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d6664ee3d127..2720c9f4cd49 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -106,6 +106,16 @@ static inline bool vmx_mpx_supported(void)
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
 }
 
+static inline bool cpu_has_load_guest_cet_states_ctrl(void)
+{
+	return ((vmcs_config.vmentry_ctrl) & VM_ENTRY_LOAD_GUEST_CET_STATE);
+}
+
+static inline bool cpu_has_load_host_cet_states_ctrl(void)
+{
+	return ((vmcs_config.vmexit_ctrl) & VM_EXIT_LOAD_HOST_CET_STATE);
+}
+
 static inline bool cpu_has_vmx_tpr_shadow(void)
 {
 	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index db03d9dc1297..e392e818e7eb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -44,6 +44,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/cet.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -2336,7 +2337,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_HOST_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2360,7 +2362,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_GUEST_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -2834,6 +2837,9 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long hw_cr0;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
+		cr0 |= X86_CR0_WP;
+
 	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
 	if (enable_unrestricted_guest)
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
@@ -2936,6 +2942,22 @@ static bool guest_cet_allowed(struct kvm_vcpu *vcpu, u32 feature, u32 mode)
 	return false;
 }
 
+bool is_cet_bit_allowed(struct kvm_vcpu *vcpu)
+{
+	unsigned long cr0;
+	bool cet_allowed;
+
+	cr0 = kvm_read_cr0(vcpu);
+	cet_allowed = guest_cet_allowed(vcpu, X86_FEATURE_SHSTK,
+					XFEATURE_MASK_CET_USER) ||
+		      guest_cet_allowed(vcpu, X86_FEATURE_IBT,
+					XFEATURE_MASK_CET_USER);
+	if ((cr0 & X86_CR0_WP) && cet_allowed)
+		return true;
+
+	return false;
+}
+
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2976,6 +2998,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !is_cet_bit_allowed(vcpu))
+		return 1;
+
 	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
 
@@ -3839,6 +3864,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	if (cpu_has_load_ia32_efer())
 		vmcs_write64(HOST_IA32_EFER, host_efer);
+
+	if (cpu_has_load_host_cet_states_ctrl()) {
+		vmcs_writel(HOST_S_CET, 0);
+		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
+		vmcs_writel(HOST_SSP, 0);
+	}
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
@@ -6436,6 +6467,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
+	bool cet_allowed;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -6466,6 +6498,25 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->host_state.cr3 = cr3;
 	}
 
+	/* To be aligned with kernel code, only user mode is supported now. */
+	cet_allowed = guest_cet_allowed(vcpu, X86_FEATURE_SHSTK,
+					XFEATURE_MASK_CET_USER) ||
+		      guest_cet_allowed(vcpu, X86_FEATURE_IBT,
+					XFEATURE_MASK_CET_USER);
+	if (cpu_has_load_guest_cet_states_ctrl() && cet_allowed)
+		vmcs_set_bits(VM_ENTRY_CONTROLS,
+			      VM_ENTRY_LOAD_GUEST_CET_STATE);
+	else
+		vmcs_clear_bits(VM_ENTRY_CONTROLS,
+				VM_ENTRY_LOAD_GUEST_CET_STATE);
+
+	if (cpu_has_load_host_cet_states_ctrl() && cet_allowed)
+		vmcs_set_bits(VM_EXIT_CONTROLS,
+			      VM_EXIT_LOAD_HOST_CET_STATE);
+	else
+		vmcs_clear_bits(VM_EXIT_CONTROLS,
+				VM_EXIT_LOAD_HOST_CET_STATE);
+
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
-- 
2.17.2

