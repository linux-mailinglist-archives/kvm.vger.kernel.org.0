Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9AB1838DF
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgCLSp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:45:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:23441 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgCLSp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:45:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="416041246"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2020 11:45:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 08/10] KVM: nVMX: Rename exit_reason to vm_exit_reason for nested VM-Exit
Date:   Thu, 12 Mar 2020 11:45:19 -0700
Message-Id: <20200312184521.24579-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312184521.24579-1-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use "vm_exit_reason" when passing around the full exit reason for nested
VM-Exits to make it clear that it's not just the basic exit reason.  The
basic exit reason (bits 15:0 of vmcs.VM_EXIT_REASON) is colloquially
referred to as simply "exit reason", e.g. vmx_handle_vmexit() tracks the
basic exit reason in a local variable named "exit_reason".

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++--------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 86b12a2918c5..c775feca3eb0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -328,19 +328,19 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 exit_reason;
+	u32 vm_exit_reason;
 	unsigned long exit_qualification = vcpu->arch.exit_qualification;
 
 	if (vmx->nested.pml_full) {
-		exit_reason = EXIT_REASON_PML_FULL;
+		vm_exit_reason = EXIT_REASON_PML_FULL;
 		vmx->nested.pml_full = false;
 		exit_qualification &= INTR_INFO_UNBLOCK_NMI;
 	} else if (fault->error_code & PFERR_RSVD_MASK)
-		exit_reason = EXIT_REASON_EPT_MISCONFIG;
+		vm_exit_reason = EXIT_REASON_EPT_MISCONFIG;
 	else
-		exit_reason = EXIT_REASON_EPT_VIOLATION;
+		vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
 
-	nested_vmx_vmexit(vcpu, exit_reason, 0, exit_qualification);
+	nested_vmx_vmexit(vcpu, vm_exit_reason, 0, exit_qualification);
 	vmcs12->guest_physical_address = fault->address;
 }
 
@@ -3919,11 +3919,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
  * which already writes to vmcs12 directly.
  */
 static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
-			   u32 exit_reason, u32 exit_intr_info,
+			   u32 vm_exit_reason, u32 exit_intr_info,
 			   unsigned long exit_qualification)
 {
 	/* update exit information fields: */
-	vmcs12->vm_exit_reason = exit_reason;
+	vmcs12->vm_exit_reason = vm_exit_reason;
 	vmcs12->exit_qualification = exit_qualification;
 	vmcs12->vm_exit_intr_info = exit_intr_info;
 
@@ -4252,7 +4252,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
  * and modify vmcs12 to make it see what it would expect to see there if
  * L2 was its real guest. Must only be called when in L2 (is_guest_mode())
  */
-void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
+void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4272,9 +4272,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	if (likely(!vmx->fail)) {
 		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
 
-		if (exit_reason != -1)
-			prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
-				       exit_qualification);
+		if (vm_exit_reason != -1)
+			prepare_vmcs12(vcpu, vmcs12, vm_exit_reason,
+				       exit_intr_info, exit_qualification);
 
 		/*
 		 * Must happen outside of sync_vmcs02_to_vmcs12() as it will
@@ -4330,14 +4330,15 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	 */
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
-	if ((exit_reason != -1) && (enable_shadow_vmcs || vmx->nested.hv_evmcs))
+	if ((vm_exit_reason != -1) &&
+	    (enable_shadow_vmcs || vmx->nested.hv_evmcs))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 
 	/* in case we halted in L2 */
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	if (likely(!vmx->fail)) {
-		if ((u16)exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
+		if ((u16)vm_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
 		    nested_exit_intr_ack_set(vcpu)) {
 			int irq = kvm_cpu_get_interrupt(vcpu);
 			WARN_ON(irq < 0);
@@ -4345,7 +4346,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 				INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
 		}
 
-		if (exit_reason != -1)
+		if (vm_exit_reason != -1)
 			trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
 						       vmcs12->exit_qualification,
 						       vmcs12->idt_vectoring_info_field,
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 569cb828b6ca..04584bcbcc8d 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -25,7 +25,7 @@ void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						     bool from_vmentry);
 bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu);
-void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
+void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
-- 
2.24.1

