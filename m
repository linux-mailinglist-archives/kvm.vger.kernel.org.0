Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A461AB03C
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411616AbgDOR7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:59:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:30607 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441019AbgDORzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:36 -0400
IronPort-SDR: FM71Eg+yqJXduwqcORxA3ECE55/jN57fklnOqJaS/15oo9RMe6rLzf7dS8xYOVIDBufQooxi20
 z8tGgTV185jw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:25 -0700
IronPort-SDR: psTV5AxHU+H78T5fAqZOpSErKt0IqOjUau27Y7r5KjGdWxoaUw7L85OEMpTEtEO3sIryhuzaz+
 Yb9/8M0BSstw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567353"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 15 Apr 2020 10:55:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 05/10] KVM: nVMX: Split VM-Exit reflection logic into L0 vs. L1 wants
Date:   Wed, 15 Apr 2020 10:55:14 -0700
Message-Id: <20200415175519.14230-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the logic that determines whether a nested VM-Exit is reflected
into L1 into "L0 wants" and "L1 wants" to document the core control flow
at a high level.  If L0 wants the VM-Exit, e.g. because the exit is due
to a hardware event that isn't passed through to L1, then KVM should
handle the exit in L0 without considering L1's configuration.  Then, if
L0 doesn't want the exit, KVM needs to query L1's wants to determine
whether or not L1 "caused" the exit, e.g. by setting an exiting control,
versus the exit occurring due to an L0 setting, e.g. when L0 intercepts
an action that L1 chose to pass-through.

Note, this adds an extra read on vmcs.VM_EXIT_INTR_INFO for exception.
This will be addressed in a future patch via a VMX-wide enhancement,
rather than pile on another case where vmx->exit_intr_info is
conditionally available.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

The "future patch" mentioned above will be sent in a separate series.
If my branch predictor is wrong and that series gets merged first, the
entire note can be dropped.

 arch/x86/kvm/vmx/nested.c | 111 ++++++++++++++++++++++++--------------
 1 file changed, 70 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index de122ef3eeed..c2745cd9e022 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5642,34 +5642,85 @@ static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
 }
 
 /*
- * Return true if we should exit from L2 to L1 to handle an exit, or false if we
- * should handle it ourselves in L0 (and then continue L2). Only call this
- * when in is_guest_mode (L2).
+ * Return true if L0 wants to handle an exit from L2 regardless of whether or not
+ * L1 wants the exit.  Only call this when in is_guest_mode (L2).
  */
-static bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
+static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	u32 intr_info;
 
 	switch (exit_reason) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 		if (is_nmi(intr_info))
-			return false;
+			return true;
 		else if (is_page_fault(intr_info))
-			return !vmx->vcpu.arch.apf.host_apf_reason && enable_ept;
+			return vcpu->arch.apf.host_apf_reason || !enable_ept;
 		else if (is_debug(intr_info) &&
 			 vcpu->guest_debug &
 			 (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
-			return false;
+			return true;
 		else if (is_breakpoint(intr_info) &&
 			 vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
-			return false;
+			return true;
+		return false;
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
+		return true;
+	case EXIT_REASON_MCE_DURING_VMENTRY:
+		return true;
+	case EXIT_REASON_EPT_VIOLATION:
+		/*
+		 * L0 always deals with the EPT violation. If nested EPT is
+		 * used, and the nested mmu code discovers that the address is
+		 * missing in the guest EPT table (EPT12), the EPT violation
+		 * will be injected with nested_ept_inject_page_fault()
+		 */
+		return true;
+	case EXIT_REASON_EPT_MISCONFIG:
+		/*
+		 * L2 never uses directly L1's EPT, but rather L0's own EPT
+		 * table (shadow on EPT) or a merged EPT table that L0 built
+		 * (EPT on EPT). So any problems with the structure of the
+		 * table is L0's fault.
+		 */
+		return true;
+	case EXIT_REASON_PREEMPTION_TIMER:
+		return true;
+	case EXIT_REASON_PML_FULL:
+		/* We emulate PML support to L1. */
+		return true;
+	case EXIT_REASON_VMFUNC:
+		/* VM functions are emulated through L2->L0 vmexits. */
+		return true;
+	case EXIT_REASON_ENCLS:
+		/* SGX is never exposed to L1 */
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+/*
+ * Return 1 if L1 wants to intercept an exit from L2.  Only call this when in
+ * is_guest_mode (L2).
+ */
+static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	u32 intr_info;
+
+	switch (exit_reason) {
+	case EXIT_REASON_EXCEPTION_NMI:
+		intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+		if (is_nmi(intr_info))
+			return true;
+		else if (is_page_fault(intr_info))
+			return true;
 		return vmcs12->exception_bitmap &
 				(1u << (intr_info & INTR_INFO_VECTOR_MASK));
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
-		return false;
+		return nested_exit_on_intr(vcpu);
 	case EXIT_REASON_TRIPLE_FAULT:
 		return true;
 	case EXIT_REASON_INTERRUPT_WINDOW:
@@ -5734,7 +5785,7 @@ static bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 			nested_cpu_has2(vmcs12,
 				SECONDARY_EXEC_PAUSE_LOOP_EXITING);
 	case EXIT_REASON_MCE_DURING_VMENTRY:
-		return false;
+		return true;
 	case EXIT_REASON_TPR_BELOW_THRESHOLD:
 		return nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW);
 	case EXIT_REASON_APIC_ACCESS:
@@ -5746,22 +5797,6 @@ static bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 		 * delivery" only come from vmcs12.
 		 */
 		return true;
-	case EXIT_REASON_EPT_VIOLATION:
-		/*
-		 * L0 always deals with the EPT violation. If nested EPT is
-		 * used, and the nested mmu code discovers that the address is
-		 * missing in the guest EPT table (EPT12), the EPT violation
-		 * will be injected with nested_ept_inject_page_fault()
-		 */
-		return false;
-	case EXIT_REASON_EPT_MISCONFIG:
-		/*
-		 * L2 never uses directly L1's EPT, but rather L0's own EPT
-		 * table (shadow on EPT) or a merged EPT table that L0 built
-		 * (EPT on EPT). So any problems with the structure of the
-		 * table is L0's fault.
-		 */
-		return false;
 	case EXIT_REASON_INVPCID:
 		return
 			nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_INVPCID) &&
@@ -5778,17 +5813,6 @@ static bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 		 * the XSS exit bitmap in vmcs12.
 		 */
 		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
-	case EXIT_REASON_PREEMPTION_TIMER:
-		return false;
-	case EXIT_REASON_PML_FULL:
-		/* We emulate PML support to L1. */
-		return false;
-	case EXIT_REASON_VMFUNC:
-		/* VM functions are emulated through L2->L0 vmexits. */
-		return false;
-	case EXIT_REASON_ENCLS:
-		/* SGX is never exposed to L1 */
-		return false;
 	case EXIT_REASON_UMWAIT:
 	case EXIT_REASON_TPAUSE:
 		return nested_cpu_has2(vmcs12,
@@ -5830,7 +5854,12 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
 
-	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
+	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
+	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))
+		return false;
+
+	/* If L1 doesn't want the exit, handle it in L0. */
+	if (!nested_vmx_l1_wants_exit(vcpu, exit_reason))
 		return false;
 
 	/*
@@ -6162,7 +6191,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	 * reason is that if one of these bits is necessary, it will appear
 	 * in vmcs01 and prepare_vmcs02, when it bitwise-or's the control
 	 * fields of vmcs01 and vmcs02, will turn these bits off - and
-	 * nested_vmx_exit_reflected() will not pass related exits to L1.
+	 * nested_vmx_l1_wants_exit() will not pass related exits to L1.
 	 * These rules have exceptions below.
 	 */
 
-- 
2.26.0

