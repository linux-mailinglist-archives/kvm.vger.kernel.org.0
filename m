Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3DC193A8E
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 09:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgCZIQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 04:16:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:27555 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbgCZIQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 04:16:05 -0400
IronPort-SDR: LQ96lUIgV8vFBmmhXj/fCi6v7WEPncXEcsv693yKo2L70maBqeubN7XrpAOqk5e9r805bIcbLb
 MyNf3pzgFvRA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 01:16:04 -0700
IronPort-SDR: ZnKTzhy7MMp8o3lshlN/iDvks42/kFd58moWFPEJgU085TCswTgwTam5pV94zWVqMxTQHGORm+
 F2sesc836CKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393898860"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 01:16:02 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 3/9] KVM: VMX: Set host/guest CET states for vmexit/vmentry
Date:   Thu, 26 Mar 2020 16:18:40 +0800
Message-Id: <20200326081847.5870-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200326081847.5870-1-weijiang.yang@intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Load {guest,host} CET state" bit controls whether guest/host
CET states will be loaded at VM entry/exit.
Set default host kernel CET states to 0s in VMCS to avoid guest
CET states leakage. When CR4.CET is cleared due to guest mode
change, make guest CET states invalid in VMCS, this can happen,
e.g., guest reboot.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 10 ++++++
 arch/x86/kvm/vmx/vmx.c          | 56 +++++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8903475f751e..565340352260 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -107,6 +107,16 @@ static inline bool cpu_has_vmx_mpx(void)
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
 }
 
+static inline bool cpu_has_cet_guest_load_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_GUEST_CET_STATE);
+}
+
+static inline bool cpu_has_cet_host_load_ctrl(void)
+{
+	return (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_HOST_CET_STATE);
+}
+
 static inline bool cpu_has_vmx_tpr_shadow(void)
 {
 	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1aca468d9a10..bd7cd175fd81 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -44,6 +44,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/cet.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -2456,7 +2457,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_HOST_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2480,7 +2482,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_GUEST_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -3040,6 +3043,12 @@ static bool is_cet_mode_allowed(struct kvm_vcpu *vcpu, u32 mode_mask)
 		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
 }
 
+static bool is_cet_supported(struct kvm_vcpu *vcpu)
+{
+	return is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_USER |
+				   XFEATURE_MASK_CET_KERNEL);
+}
+
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3110,6 +3119,12 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
 	}
 
+	if (!(hw_cr4 & X86_CR4_CET) && is_cet_supported(vcpu)) {
+		vmcs_writel(GUEST_SSP, 0);
+		vmcs_writel(GUEST_S_CET, 0);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
+	}
+
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, hw_cr4);
 	return 0;
@@ -3939,6 +3954,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	if (cpu_has_load_ia32_efer())
 		vmcs_write64(HOST_IA32_EFER, host_efer);
+
+	if (cpu_has_cet_host_load_ctrl()) {
+		vmcs_writel(HOST_S_CET, 0);
+		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
+		vmcs_writel(HOST_SSP, 0);
+	}
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
@@ -5749,6 +5770,13 @@ void dump_vmcs(void)
 		pr_err("InterruptStatus = %04x\n",
 		       vmcs_read16(GUEST_INTR_STATUS));
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_GUEST_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
+		pr_err("SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
+	}
+
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -5831,6 +5859,13 @@ void dump_vmcs(void)
 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
 		pr_err("Virtual processor ID = 0x%04x\n",
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
+	if (vmexit_ctl & VM_EXIT_LOAD_HOST_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
+		pr_err("SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(HOST_INTR_SSP_TABLE));
+	}
+
 }
 
 /*
@@ -7140,8 +7175,23 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	}
 
 	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
-	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
 		vmx_update_intercept_for_cet_msr(vcpu);
+
+		if (cpu_has_cet_guest_load_ctrl() && is_cet_supported(vcpu))
+			vm_entry_controls_setbit(to_vmx(vcpu),
+						 VM_ENTRY_LOAD_GUEST_CET_STATE);
+		else
+			vm_entry_controls_clearbit(to_vmx(vcpu),
+						   VM_ENTRY_LOAD_GUEST_CET_STATE);
+
+		if (cpu_has_cet_host_load_ctrl() && is_cet_supported(vcpu))
+			vm_exit_controls_setbit(to_vmx(vcpu),
+						VM_EXIT_LOAD_HOST_CET_STATE);
+		else
+			vm_exit_controls_clearbit(to_vmx(vcpu),
+						  VM_EXIT_LOAD_HOST_CET_STATE);
+	}
 }
 
 static __init void vmx_set_cpu_caps(void)
-- 
2.17.2

