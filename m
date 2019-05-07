Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C2D16B1F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfEGTSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:55701 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbfEGTSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:08 -0400
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
Subject: [PATCH 03/13] KVM: VMX: Shadow VMCS pin controls
Date:   Tue,  7 May 2019 12:17:55 -0700
Message-Id: <20190507191805.9932-4-sean.j.christopherson@intel.com>
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
allows KVM to avoid costly VMWRITEs when switching between vmcs01 and
vmcs02.

Shadowing pin controls also allows a future patch to remove the per-VMCS
'hv_timer_armed' flag, as the shadow copy is a superset of said flag.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  3 ++-
 arch/x86/kvm/vmx/vmx.c    | 10 ++++------
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2a98d92f955b..95eda399fd71 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -254,6 +254,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 
 	vm_entry_controls_reset_shadow(vmx);
 	vm_exit_controls_reset_shadow(vmx);
+	pin_controls_reset_shadow(vmx);
 	vmx_segment_cache_clear(vmx);
 }
 
@@ -1999,7 +2000,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	} else {
 		exec_control &= ~PIN_BASED_POSTED_INTR;
 	}
-	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, exec_control);
+	pin_controls_init(vmx, exec_control);
 
 	/*
 	 * EXEC CONTROLS
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 08f36881473f..c107a2dd9769 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3817,7 +3817,7 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, vmx_pin_based_exec_ctrl(vmx));
+	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
 		if (kvm_vcpu_apicv_active(vcpu))
 			vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
@@ -4015,7 +4015,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
 	/* Control */
-	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, vmx_pin_based_exec_ctrl(vmx));
+	pin_controls_init(vmx, vmx_pin_based_exec_ctrl(vmx));
 	vmx->hv_deadline_tsc = -1;
 
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, vmx_exec_control(vmx));
@@ -6327,8 +6327,7 @@ static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
 {
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
 	if (!vmx->loaded_vmcs->hv_timer_armed)
-		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
-			      PIN_BASED_VMX_PREEMPTION_TIMER);
+		pin_controls_setbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 	vmx->loaded_vmcs->hv_timer_armed = true;
 }
 
@@ -6357,8 +6356,7 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 	}
 
 	if (vmx->loaded_vmcs->hv_timer_armed)
-		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
-				PIN_BASED_VMX_PREEMPTION_TIMER);
+		pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 	vmx->loaded_vmcs->hv_timer_armed = false;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bdc0df871be9..661ab4212cf7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -88,6 +88,7 @@ struct pt_desc {
 struct vmx_controls_shadow {
 	u32 vm_entry;
 	u32 vm_exit;
+	u32 pin;
 };
 
 /*
@@ -410,6 +411,7 @@ static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
 }
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
+BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
 
 static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 {
-- 
2.21.0

