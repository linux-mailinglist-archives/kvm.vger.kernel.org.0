Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B8144838
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfFMRFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:05:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50196 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404621AbfFMREJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so10986656wmf.0;
        Thu, 13 Jun 2019 10:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5+InJnraTXrzge2F0K4aBFVDGbA/DhMyQq5KvIa9oCw=;
        b=hA3frNtmPTHYBQNEhEuinfL48hsLuiEnBwWy9uePnElpdp9YbPokdAizg0HhPxISY+
         7N65op+JdV0V05bzMcGqIuUSAEAtHvJFEidD1taWnLL1rDcDRJcRUHkF6nwjVkeWTuYb
         yYAfs08TcIR+yMohBQSqeoEVfUtlG4hn0LZSjASU0GWswbx+24SCArcDKg2JWiEauokL
         gDvJ7eZ4WqpoUNtK94IuGLfi1nnAGlWRK0xlPWFEMskj+vGyge4FCeATXm+Xvl4aC/N8
         rvRH0Uqa+A4OZIq+CVwOf2UiDP7WJyRT92NEtvNqijsIjDJRDbVsua2BfZb69MbiDzoW
         9B+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=5+InJnraTXrzge2F0K4aBFVDGbA/DhMyQq5KvIa9oCw=;
        b=VEWpXRcfFPsNObq3Mz40tOC5pEy/cBdVb9Q4yXmT95VR77Me1KHMiSNte9kcS0P0dy
         4ULSDJxWw9TcPumDmhE/33f6Sp/0fQ1U6nZ+u1NihT7F+g+Z/TC36DmldgOw813gp249
         PjFcxYHd50z2XF2K+MA1dQuWHfzLqhGrMTvC/lU4IN0muZfK48XVStBUj++eFicKsnkD
         xAwWxghx0uSzWN9rvlI4mBIONYHOcywG3CPt7hHmEqBPsDysNNeINXzQBaIdRRH1cY8a
         28Qxende30Xcz8ae/Hx6EM2FC9KnTPM0CpfVu1kuxoGpPbuFyaQaUnNjidmCAC9BGzit
         g9ow==
X-Gm-Message-State: APjAAAVTYDsbS4ZM5Ben65IJjgVQuQX9hU5Aj9ow8kvuQukh+P7H6SVc
        B/4E9FlLVymdsK2qSjTOznFrO2GD
X-Google-Smtp-Source: APXvYqx+jFavY98aEfi6o4XKYuvEWa1V29OkzxHopOJH2wnQF5aP2gs4iyxrBiZwUMOhomN2S/qaAw==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr4760954wma.114.1560445447536;
        Thu, 13 Jun 2019 10:04:07 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:06 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 35/43] KVM: VMX: Shadow VMCS secondary execution controls
Date:   Thu, 13 Jun 2019 19:03:21 +0200
Message-Id: <1560445409-17363-36-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Prepare to shadow all major control fields on a per-VMCS basis, which
allows KVM to avoid costly VMWRITEs when switching between vmcs01 and
vmcs02.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c    | 40 ++++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a754a2ed6295..9703fcf19837 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -192,7 +192,7 @@ static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
 
 static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
-	vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL, SECONDARY_EXEC_SHADOW_VMCS);
+	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
 }
 
@@ -287,6 +287,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vm_exit_controls_reset_shadow(vmx);
 	pin_controls_reset_shadow(vmx);
 	exec_controls_reset_shadow(vmx);
+	secondary_exec_controls_reset_shadow(vmx);
 	vmx_segment_cache_clear(vmx);
 }
 
@@ -2083,7 +2084,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write16(GUEST_INTR_STATUS,
 				vmcs12->guest_intr_status);
 
-		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
+		secondary_exec_controls_init(vmx, exec_control);
 	}
 
 	/*
@@ -2853,8 +2854,8 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			hpa = page_to_phys(vmx->nested.apic_access_page);
 			vmcs_write64(APIC_ACCESS_ADDR, hpa);
 		} else {
-			vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
-					SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
+			secondary_exec_controls_clearbit(vmx,
+				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
 		}
 	}
 
@@ -4667,8 +4668,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 {
 	vmx->nested.current_vmptr = vmptr;
 	if (enable_shadow_vmcs) {
-		vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
-			      SECONDARY_EXEC_SHADOW_VMCS);
+		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
 		vmcs_write64(VMCS_LINK_POINTER,
 			     __pa(vmx->vmcs01.shadow_vmcs));
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fcb1a80270bc..1104f52d281c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2909,6 +2909,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	/*
 	 * Pass through host's Machine Check Enable value to hw_cr4, which
 	 * is in force while we are in guest mode.  Do not let guests control
@@ -2919,20 +2920,19 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
 	if (enable_unrestricted_guest)
 		hw_cr4 |= KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST;
-	else if (to_vmx(vcpu)->rmode.vm86_active)
+	else if (vmx->rmode.vm86_active)
 		hw_cr4 |= KVM_RMODE_VM_CR4_ALWAYS_ON;
 	else
 		hw_cr4 |= KVM_PMODE_VM_CR4_ALWAYS_ON;
 
 	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
 		if (cr4 & X86_CR4_UMIP) {
-			vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
-				SECONDARY_EXEC_DESC);
+			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 			hw_cr4 &= ~X86_CR4_UMIP;
 		} else if (!is_guest_mode(vcpu) ||
-			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC))
-			vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
-					SECONDARY_EXEC_DESC);
+			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC)) {
+			secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
+		}
 	}
 
 	if (cr4 & X86_CR4_VMXE) {
@@ -2947,7 +2947,7 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
-	if (to_vmx(vcpu)->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
+	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
 
 	vcpu->arch.cr4 = cr4;
@@ -3565,7 +3565,7 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	u8 mode = 0;
 
 	if (cpu_has_secondary_exec_ctrls() &&
-	    (vmcs_read32(SECONDARY_VM_EXEC_CONTROL) &
+	    (secondary_exec_controls_get(to_vmx(vcpu)) &
 	     SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE)) {
 		mode |= MSR_BITMAP_MODE_X2APIC;
 		if (enable_apicv && kvm_vcpu_apicv_active(vcpu))
@@ -3845,11 +3845,11 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
 		if (kvm_vcpu_apicv_active(vcpu))
-			vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
+			secondary_exec_controls_setbit(vmx,
 				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 		else
-			vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
+			secondary_exec_controls_clearbit(vmx,
 					SECONDARY_EXEC_APIC_REGISTER_VIRT |
 					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 	}
@@ -4047,8 +4047,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 	if (cpu_has_secondary_exec_ctrls()) {
 		vmx_compute_secondary_exec_control(vmx);
-		vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
-			     vmx->secondary_exec_control);
+		secondary_exec_controls_init(vmx, vmx->secondary_exec_control);
 	}
 
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
@@ -5969,6 +5968,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 sec_exec_control;
 
 	if (!lapic_in_kernel(vcpu))
@@ -5980,11 +5980,11 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 
 	/* Postpone execution until vmcs01 is the current VMCS. */
 	if (is_guest_mode(vcpu)) {
-		to_vmx(vcpu)->nested.change_vmcs01_virtual_apic_mode = true;
+		vmx->nested.change_vmcs01_virtual_apic_mode = true;
 		return;
 	}
 
-	sec_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
+	sec_exec_control = secondary_exec_controls_get(vmx);
 	sec_exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
 			      SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
 
@@ -6006,7 +6006,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 				SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
 		break;
 	}
-	vmcs_write32(SECONDARY_VM_EXEC_CONTROL, sec_exec_control);
+	secondary_exec_controls_set(vmx, sec_exec_control);
 
 	vmx_update_msr_bitmap(vcpu);
 }
@@ -6827,7 +6827,7 @@ static int vmx_get_lpage_level(void)
 		return PT_PDPE_LEVEL;
 }
 
-static void vmcs_set_secondary_exec_control(u32 new_ctl)
+static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx)
 {
 	/*
 	 * These bits in the secondary execution controls field
@@ -6841,10 +6841,10 @@ static void vmcs_set_secondary_exec_control(u32 new_ctl)
 		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
 		SECONDARY_EXEC_DESC;
 
-	u32 cur_ctl = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
+	u32 new_ctl = vmx->secondary_exec_control;
+	u32 cur_ctl = secondary_exec_controls_get(vmx);
 
-	vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
-		     (new_ctl & ~mask) | (cur_ctl & mask));
+	secondary_exec_controls_set(vmx, (new_ctl & ~mask) | (cur_ctl & mask));
 }
 
 /*
@@ -6982,7 +6982,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 
 	if (cpu_has_secondary_exec_ctrls()) {
 		vmx_compute_secondary_exec_control(vmx);
-		vmcs_set_secondary_exec_control(vmx->secondary_exec_control);
+		vmcs_set_secondary_exec_control(vmx);
 	}
 
 	if (nested_vmx_allowed(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0bb0f75ebcb9..b4d5684b0be9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -90,6 +90,7 @@ struct vmx_controls_shadow {
 	u32 vm_exit;
 	u32 pin;
 	u32 exec;
+	u32 secondary_exec;
 };
 
 /*
@@ -427,6 +428,7 @@ static inline u8 vmx_get_rvi(void)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
 BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
 BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
+BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
 
 static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 {
-- 
1.8.3.1


