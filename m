Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4548A44817
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393338AbfFMREJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44554 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404616AbfFMREI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id r16so2443018wrl.11;
        Thu, 13 Jun 2019 10:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZlPh8zeSLRKgkImeuJUqcSn3MOVz2v/o08mkGTtQi+s=;
        b=EvXjUw8BJ/ylCe6tyUSOUI2DBK1ry6CIxL7Ki3wu2WrGX6CcTeVB7nXd8mAJ0CxjGW
         e56FXPM34OwY8jtz0B6qDWPV3JZ1Qcx0oMlJslpqzMVq417N7oR5KvZQ1fv0eUKVCAGk
         ktDembI3N1J/otHkHHZlugjcK8bBiYQUZRjqEbicujwFBK6cEg437i34pDKS8S6oGOde
         ArU3XTY01FRGp9B7Nmev8pGqM5R6+FjjIB/AhBOSdE4AAHfYKUG22MA/IyKC7ofSjQt+
         h6OqwK6ZgijWcb19PDU38IRkxb962+B3JACphYhKLwpSd4RXPxT2OtJ08hgHzGYxCfyQ
         neBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ZlPh8zeSLRKgkImeuJUqcSn3MOVz2v/o08mkGTtQi+s=;
        b=GZhWf1qA5pKoIJn3cq9spEEOK0lDKdnu48Nwe3RIhN0P2OZy9m7dCqBxiHI0pA5kQj
         eWShGkEA0ZCRTW+HuPMMC5J7p0wvMYCMvvwLXPU/6RutqTukLfHmkrIlCXpJCkeu8eib
         QUJ6Tj9VPKYwQpnCqz1RT/baS4JVqpH+I42Pj6z2mkd9jAZG77/DSVnFUG+k4v7Jo0/m
         uGZ67S7ZHVsrX2wQ+Z0BWsj2x4PGuZa6Lt+Iegk5X1XEeEXZJgu0bZEqp1PPQvEh8l6M
         e6Ra9Bl+bX/RCyhMM0cr8Rq4c+N/oAWVzddQe5iLOSubhviv72YR/61hTUFjHeWrQ4PA
         VDsQ==
X-Gm-Message-State: APjAAAUFzreQPB8lR2Vjf7o2Sccwyy5d1O+AcYsWBODooHB+DwKAQUrv
        ojggdJdal7RRViRrV2v6a5ZgWrYz
X-Google-Smtp-Source: APXvYqzWSOaGGPNyQVwjecTaUTMa/9xN86ZqydA4J2ARE2L6ENWRTr2MfSwri3NmKp8qpa9Hf0QPBg==
X-Received: by 2002:adf:fe08:: with SMTP id n8mr7695423wrr.140.1560445446683;
        Thu, 13 Jun 2019 10:04:06 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:06 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 34/43] KVM: VMX: Shadow VMCS primary execution controls
Date:   Thu, 13 Jun 2019 19:03:20 +0200
Message-Id: <1560445409-17363-35-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Prepare to shadow all major control fields on a per-VMCS basis, which
allows KVM to avoid VMREADs when switching between vmcs01 and vmcs02,
and more importantly can eliminate costly VMWRITEs to controls when
preparing vmcs02.

Shadowing exec controls also saves a VMREAD when opening virtual
INTR/NMI windows, yay...

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 14 ++++++--------
 arch/x86/kvm/vmx/vmx.c    | 38 +++++++++++++++-----------------------
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 3 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0179ac083dd1..a754a2ed6295 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -286,6 +286,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vm_entry_controls_reset_shadow(vmx);
 	vm_exit_controls_reset_shadow(vmx);
 	pin_controls_reset_shadow(vmx);
+	exec_controls_reset_shadow(vmx);
 	vmx_segment_cache_clear(vmx);
 }
 
@@ -2052,7 +2053,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
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
 			/*
 			 * Write an illegal value to VIRTUAL_APIC_PAGE_ADDR to
@@ -2896,11 +2896,9 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
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
@@ -2953,7 +2951,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	u32 exit_reason = EXIT_REASON_INVALID_STATE;
 	u32 exit_qual;
 
-	evaluate_pending_interrupts = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) &
+	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_VIRTUAL_INTR_PENDING | CPU_BASED_VIRTUAL_NMI_PENDING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6eb4063d98fc..fcb1a80270bc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2796,22 +2796,20 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
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
@@ -4045,7 +4043,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	pin_controls_init(vmx, vmx_pin_based_exec_ctrl(vmx));
 	vmx->hv_deadline_tsc = -1;
 
-	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, vmx_exec_control(vmx));
+	exec_controls_init(vmx, vmx_exec_control(vmx));
 
 	if (cpu_has_secondary_exec_ctrls()) {
 		vmx_compute_secondary_exec_control(vmx);
@@ -4235,8 +4233,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
-	vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
-		      CPU_BASED_VIRTUAL_INTR_PENDING);
+	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_INTR_PENDING);
 }
 
 static void enable_nmi_window(struct kvm_vcpu *vcpu)
@@ -4247,8 +4244,7 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
-		      CPU_BASED_VIRTUAL_NMI_PENDING);
+	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_NMI_PENDING);
 }
 
 static void vmx_inject_irq(struct kvm_vcpu *vcpu)
@@ -4795,8 +4791,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->guest_debug == 0) {
-		vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
-				CPU_BASED_MOV_DR_EXITING);
+		exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
 
 		/*
 		 * No more DR vmexits; force a reload of the debug registers
@@ -4840,7 +4835,7 @@ static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	vcpu->arch.dr7 = vmcs_readl(GUEST_DR7);
 
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
-	vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL, CPU_BASED_MOV_DR_EXITING);
+	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
 }
 
 static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
@@ -4900,8 +4895,7 @@ static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
 
 static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 {
-	vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
-			CPU_BASED_VIRTUAL_INTR_PENDING);
+	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_INTR_PENDING);
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
@@ -5155,8 +5149,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 static int handle_nmi_window(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!enable_vnmi);
-	vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
-			CPU_BASED_VIRTUAL_NMI_PENDING);
+	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_NMI_PENDING);
 	++vcpu->stat.nmi_window_exits;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
@@ -5168,7 +5161,6 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	enum emulation_result err = EMULATE_DONE;
 	int ret = 1;
-	u32 cpu_exec_ctrl;
 	bool intr_window_requested;
 	unsigned count = 130;
 
@@ -5179,8 +5171,8 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	 */
 	WARN_ON_ONCE(vmx->emulation_required && vmx->nested.nested_run_pending);
 
-	cpu_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
-	intr_window_requested = cpu_exec_ctrl & CPU_BASED_VIRTUAL_INTR_PENDING;
+	intr_window_requested = exec_controls_get(vmx) &
+				CPU_BASED_VIRTUAL_INTR_PENDING;
 
 	while (vmx->emulation_required && count-- != 0) {
 		if (intr_window_requested && vmx_interrupt_allowed(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 3c0a8b01f1f0..0bb0f75ebcb9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -89,6 +89,7 @@ struct vmx_controls_shadow {
 	u32 vm_entry;
 	u32 vm_exit;
 	u32 pin;
+	u32 exec;
 };
 
 /*
@@ -425,6 +426,7 @@ static inline u8 vmx_get_rvi(void)
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
 BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
+BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
 
 static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 {
-- 
1.8.3.1


