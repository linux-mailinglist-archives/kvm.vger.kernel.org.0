Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A194C18C5F4
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 04:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCTDku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 23:40:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:27908 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbgCTDkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 23:40:49 -0400
IronPort-SDR: 76wiKmcbvVgPFQqbR4IifNkQpv/JCdjgyz1s+ZBHCnLqPK2i6yF1Kmfh2Fvb0CoJ/gD0T8RwUS
 rBjtAC+nI9eQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 20:40:48 -0700
IronPort-SDR: 1KkkAk0vAJKRBQ/yio5nsHt6+uzEJmhw99Td8JNvFXxlIp2Jv6wswIEgiFEwXDJudekdQFSSj+
 fjy+dDOfKcJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="263945589"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 19 Mar 2020 20:40:46 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 3/8] KVM: VMX: Load CET states on vmentry/vmexit
Date:   Fri, 20 Mar 2020 11:43:36 +0800
Message-Id: <20200320034342.26610-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200320034342.26610-1-weijiang.yang@intel.com>
References: <20200320034342.26610-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Load {guest,host} CET state" bit controls whether guest/host
CET states will be loaded at VM entry/exit.
There're mutual constrains between CR0.WP and CR4.CET, so need
to check the dependent bit while changing the control registers.

Note:
1)The processor does not allow CR4.CET to be set if CR0.WP = 0,
  similarly, it does not allow CR0.WP to be cleared while CR4.CET = 1.
  In either case, KVM would inject #GP to guest.

2)SHSTK and IBT features share one control MSR:
  MSR_IA32_{U,S}_CET, which means it's difficult to hide
  one feature from another in the case of SHSTK != IBT,
  after discussed in community, it's agreed to allow Guest
  control two features independently as it won't introduce
  security hole.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.c          | 25 +++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |  3 +++
 3 files changed, 36 insertions(+), 2 deletions(-)

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
index 61d2a4bf9eb6..e7ac776c808f 100644
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
@@ -3086,6 +3089,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && (!is_cet_supported(vcpu) ||
+	    !(kvm_read_cr0(vcpu) & X86_CR0_WP)))
+		return 1;
+
 	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
 
@@ -3945,6 +3952,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
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
@@ -6541,6 +6554,14 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->host_state.cr3 = cr3;
 	}
 
+	if (cpu_has_cet_guest_load_ctrl() && is_cet_supported(vcpu))
+		vmcs_set_bits(VM_ENTRY_CONTROLS,
+			      VM_ENTRY_LOAD_GUEST_CET_STATE);
+
+	if (cpu_has_cet_host_load_ctrl() && is_cet_supported(vcpu))
+		vmcs_set_bits(VM_EXIT_CONTROLS,
+			      VM_EXIT_LOAD_HOST_CET_STATE);
+
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 830afe5038d1..90acdbbb8a5a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -804,6 +804,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_ops->set_cr0(vcpu, cr0);
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-- 
2.17.2

