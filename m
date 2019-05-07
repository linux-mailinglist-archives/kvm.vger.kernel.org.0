Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8162E16B1B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfEGTSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:55700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbfEGTSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 12:18:06 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2019 12:18:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 04/13] KVM: VMX: Shadow VMCS primary execution controls
Date:   Tue,  7 May 2019 12:17:56 -0700
Message-Id: <20190507191805.9932-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare to shadow all major control fields on a per-VMCS basis, which
allows KVM to avoid VMREADs when switching between vmcs01 and vmcs02,
and more importantly can eliminate costly VMWRITEs to controls when
preparing vmcs02.

Shadowing exec controls also saves a VMREAD when opening virtual
INTR/NMI windows, yay...

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 14 ++++++--------
 arch/x86/kvm/vmx/vmx.c    | 38 +++++++++++++++-----------------------
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 3 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 95eda399fd71..7212cd04e9c2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -255,6 +255,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vm_entry_controls_reset_shadow(vmx);
 	vm_exit_controls_reset_shadow(vmx);
 	pin_controls_reset_shadow(vmx);
+	exec_controls_reset_shadow(vmx);
 	vmx_segment_cache_clear(vmx);
 }
 
@@ -2032,7 +2033,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 */
 	exec_control &= ~CPU_BASED_USE_IO_BITMAPS;
 	exec_control |= CPU_BASED_UNCOND_IO_EXITING;
-	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, exec_control);
+	exec_controls_init(vmx, exec_control);
 
 	/*
 	 * SECONDARY EXEC CONTROLS
@@ -2873,8 +2874,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			 * _not_ what the processor does but it's basically the
 			 * only possibility we have.
 			 */
-			vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
-					CPU_BASED_TPR_SHADOW);
+			exec_controls_clearbit(vmx, CPU_BASED_TPR_SHADOW);
 		} else {
 			printk("bad virtual-APIC page address\n");
 			dump_vmcs();
@@ -2893,11 +2893,9 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		}
 	}
 	if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12))
-		vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
-			      CPU_BASED_USE_MSR_BITMAPS);
+		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
 	else
-		vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
-				CPU_BASED_USE_MSR_BITMAPS);
+		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
 }
 
 /*
@@ -2950,7 +2948,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	u32 exit_reason = EXIT_REASON_INVALID_STATE;
 	u32 exit_qual;
 
-	evaluate_pending_interrupts = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) &
+	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_VIRTUAL_INTR_PENDING | CPU_BASED_VIRTUAL_NMI_PENDING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c107a2dd9769..278007885a8e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2766,22 +2766,20 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 					unsigned long cr0,
 					struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
 	if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 		vmx_decache_cr3(vcpu);
 	if (!(cr0 & X86_CR0_PG)) {
 		/* From paging/starting to nonpaging */
-		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
-			     vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) |
-			     (CPU_BASED_CR3_LOAD_EXITING |
-			      CPU_BASED_CR3_STORE_EXITING));
+		exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
+					  CPU_BASED_CR3_STORE_EXITING);
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	} else if (!is_paging(vcpu)) {
 		/* From nonpaging to paging */
-		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
-			     vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) &
-			     ~(CPU_BASED_CR3_LOAD_EXITING |
-			       CPU_BASED_CR3_STORE_EXITING));
+		exec_controls_clearbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
+					    CPU_BASED_CR3_STORE_EXITING);
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	}
@@ -4018,7 +4016,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	pin_controls_init(vmx, vmx_pin_based_exec_ctrl(vmx));
 	vmx->hv_deadline_tsc = -1;
 
-	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, vmx_exec_control(vmx));
+	exec_controls_init(vmx, vmx_exec_control(vmx));
 
 	if (cpu_has_secondary_exec_ctrls()) {
 		vmx_compute_secondary_exec_control(vmx);
@@ -4208,8 +4206,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
-	vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
-		      CPU_BASED_VIRTUAL_INTR_PENDING);
+	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_INTR_PENDING);
 }
 
 static void enable_nmi_window(struct kvm_vcpu *vcpu)
@@ -4220,8 +4217,7 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
-		      CPU_BASED_VIRTUAL_NMI_PENDING);
+	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_NMI_PENDING);
 }
 
 static void vmx_inject_irq(struct kvm_vcpu *vcpu)
@@ -4771,8 +4767,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->guest_debug == 0) {
-		vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
-				CPU_BASED_MOV_DR_EXITING);
+		exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
 
 		/*
 		 * No more DR vmexits; force a reload of the debug registers
@@ -4816,7 +4811,7 @@ static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	vcpu->arch.dr7 = vmcs_readl(GUEST_DR7);
 
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
-	vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL, CPU_BASED_MOV_DR_EXITING);
+	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
 }
 
 static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
@@ -4876,8 +4871,7 @@ static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
 
 static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 {
-	vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
-			CPU_BASED_VIRTUAL_INTR_PENDING);
+	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_INTR_PENDING);
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
@@ -5131,8 +5125,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 static int handle_nmi_window(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!enable_vnmi);
-	vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
-			CPU_BASED_VIRTUAL_NMI_PENDING);
+	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_NMI_PENDING);
 	++vcpu->stat.nmi_window_exits;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
@@ -5144,7 +5137,6 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	enum emulation_result err = EMULATE_DONE;
 	int ret = 1;
-	u32 cpu_exec_ctrl;
 	bool intr_window_requested;
 	unsigned count = 130;
 
@@ -5155,8 +5147,8 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	 */
 	WARN_ON_ONCE(vmx->emulation_required && vmx->nested.nested_run_pending);
 
-	cpu_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
-	intr_window_requested = cpu_exec_ctrl & CPU_BASED_VIRTUAL_INTR_PENDING;
+	intr_window_requested = exec_controls_get(vmx) &
+				CPU_BASED_VIRTUAL_INTR_PENDING;
 
 	while (vmx->emulation_required && count-- != 0) {
 		if (intr_window_requested && vmx_interrupt_allowed(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 661ab4212cf7..673cab3f6f66 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -89,6 +89,7 @@ struct vmx_controls_shadow {
 	u32 vm_entry;
 	u32 vm_exit;
 	u32 pin;
+	u32 exec;
 };
 
 /*
@@ -412,6 +413,7 @@ static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
 BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
+BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
 
 static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 {
-- 
2.21.0

