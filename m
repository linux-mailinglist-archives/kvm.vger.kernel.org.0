Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9317E1C22FB
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEBEc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:32:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:55783 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgEBEcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:39 -0400
IronPort-SDR: FkVFJ3Cm8necnXSiqRaMvmVgHhk+WkIWv8ephWIEchWAO4gZv81fpdUYEMCfVybRV4ulbMgIEc
 6XnHfRIqQyPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:37 -0700
IronPort-SDR: WTpWe24HDWYQ1HuZKLyRkPmhyg8pzMf3ZorAJA0YAAFqDMRlNhkxIoDt0xM3ZuHgvz6ARjACqD
 rgsKR/10Rj5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516138"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 01 May 2020 21:32:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] KVM: VMX: Add anti-retpoline accessors for RIP and RSP
Date:   Fri,  1 May 2020 21:32:32 -0700
Message-Id: <20200502043234.12481-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add VMX specific accessors for RIP and RSP that are used if and only if
CONFIG_RETPOLINE=y to avoid bouncing through kvm_x86_ops.cache_reg() and
taking the associated retpoline hit.  This eliminates a retpoline in the
vast majority of exits by avoiding the RIP read needed to skip the
emulated instruction.  This also saves two retpolines on nested VM-Exits
as both RIP and RSP need to be saved from vmcs02 to vmcs12.

Make the accessors dependent on CONFIG_RETPOLINE so that they can be
easily ripped out if/when the kernel gains support for static calls.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  6 +++---
 arch/x86/kvm/vmx/vmx.c    |  6 +++---
 arch/x86/kvm/vmx/vmx.h    | 28 ++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3b4f1408b4e1..a7639818b814 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3943,8 +3943,8 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
 	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
 
-	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
-	vmcs12->guest_rip = kvm_rip_read(vcpu);
+	vmcs12->guest_rsp = vmx_rsp_read(vcpu);
+	vmcs12->guest_rip = vmx_rip_read(vcpu);
 	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
 
 	vmcs12->guest_cs_ar_bytes = vmcs_read32(GUEST_CS_AR_BYTES);
@@ -5854,7 +5854,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	exit_intr_info = vmx_get_intr_info(vcpu);
 	exit_qual = vmx_get_exit_qual(vcpu);
 
-	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason, exit_qual,
+	trace_kvm_nested_vmexit(vmx_rip_read(vcpu), exit_reason, exit_qual,
 				vmx->idt_vectoring_info, exit_intr_info,
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0cb0c347de04..d826ac541eed 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1569,7 +1569,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
 	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
-		rip = kvm_rip_read(vcpu);
+		rip = vmx_rip_read(vcpu);
 		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 		kvm_rip_write(vcpu, rip);
 	} else {
@@ -2185,7 +2185,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
-static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
 	unsigned long guest_owned_bits;
 
@@ -4750,7 +4750,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		vmx->vcpu.arch.event_exit_inst_len =
 			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
-		rip = kvm_rip_read(vcpu);
+		rip = vmx_rip_read(vcpu);
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
 		break;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 5f3f141d7254..63baa0d5fe41 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -500,6 +500,34 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
+#ifdef CONFIG_RETPOLINE
+void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
+static __always_inline unsigned long vmx_register_read(struct kvm_vcpu *vcpu,
+						       enum kvm_reg reg)
+{
+	BUILD_BUG_ON(!__builtin_constant_p(reg));
+	BUILD_BUG_ON(reg != VCPU_REGS_RIP && reg != VCPU_REGS_RSP);
+
+	if (!kvm_register_is_available(vcpu, reg))
+		vmx_cache_reg(vcpu, reg);
+
+	return vcpu->arch.regs[reg];
+}
+
+static inline unsigned long vmx_rip_read(struct kvm_vcpu *vcpu)
+{
+	return vmx_register_read(vcpu, VCPU_REGS_RIP);
+}
+
+static inline unsigned long vmx_rsp_read(struct kvm_vcpu *vcpu)
+{
+	return vmx_register_read(vcpu, VCPU_REGS_RSP);
+}
+#else
+#define vmx_rip_read kvm_rip_read
+#define vmx_rsp_read kvm_rsp_read
+#endif
+
 static inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-- 
2.26.0

