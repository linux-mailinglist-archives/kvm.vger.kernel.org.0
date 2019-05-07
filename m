Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7838016B21
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfEGTSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:55700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbfEGTSI (ORCPT <rfc822;kvm@vger.kernel.org>);
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
Subject: [PATCH 08/13] KVM: VMX: Explicitly initialize controls shadow at VMCS allocation
Date:   Tue,  7 May 2019 12:18:00 -0700
Message-Id: <20190507191805.9932-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Or: Don't re-initialize vmcs02's controls on every nested VM-Entry.

VMWRITEs to the major VMCS controls are deceptively expensive.  Intel
CPUs with VMCS caching (Westmere and later) also optimize away
consistency checks on VM-Entry, i.e. skip consistency checks if the
relevant fields have not changed since the last successful VM-Entry (of
the cached VMCS).  Because uops are a precious commodity, uCode's dirty
VMCS field tracking isn't as precise as software would prefer.  Notably,
writing any of the major VMCS fields effectively marks the entire VMCS
dirty, i.e. causes the next VM-Entry to perform all consistency checks,
which consumes several hundred cycles.

Zero out the controls' shadow copies during VMCS allocation and use the
optimized setter when "initializing" controls.  While this technically
affects both non-nested and nested virtualization, nested virtualization
is the primary beneficiary as avoid VMWRITEs when prepare vmcs02 allows
hardware to optimizie away consistency checks.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 10 +++++-----
 arch/x86/kvm/vmx/vmx.c    | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.h    |  5 -----
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 23be882e3365..cd1daf3b63a4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1997,7 +1997,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	} else {
 		exec_control &= ~PIN_BASED_POSTED_INTR;
 	}
-	pin_controls_init(vmx, exec_control);
+	pin_controls_set(vmx, exec_control);
 
 	/*
 	 * EXEC CONTROLS
@@ -2029,7 +2029,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 */
 	exec_control &= ~CPU_BASED_USE_IO_BITMAPS;
 	exec_control |= CPU_BASED_UNCOND_IO_EXITING;
-	exec_controls_init(vmx, exec_control);
+	exec_controls_set(vmx, exec_control);
 
 	/*
 	 * SECONDARY EXEC CONTROLS
@@ -2070,7 +2070,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (exec_control & SECONDARY_EXEC_ENCLS_EXITING)
 			vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
 
-		sec_exec_controls_init(vmx, exec_control);
+		sec_exec_controls_set(vmx, exec_control);
 	}
 
 	/*
@@ -2089,7 +2089,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (guest_efer != host_efer)
 			exec_control |= VM_ENTRY_LOAD_IA32_EFER;
 	}
-	vm_entry_controls_init(vmx, exec_control);
+	vm_entry_controls_set(vmx, exec_control);
 
 	/*
 	 * EXIT CONTROLS
@@ -2101,7 +2101,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	exec_control = vmx_vmexit_ctrl();
 	if (cpu_has_load_ia32_efer() && guest_efer != host_efer)
 		exec_control |= VM_EXIT_LOAD_IA32_EFER;
-	vm_exit_controls_init(vmx, exec_control);
+	vm_exit_controls_set(vmx, exec_control);
 
 	/*
 	 * Conceptually we want to copy the PML address and index from
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 274b870f6511..eaa74c1e9a02 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2455,6 +2455,8 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	}
 
 	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
+	memset(&loaded_vmcs->controls_shadow, 0,
+		sizeof(struct vmcs_controls_shadow));
 
 	return 0;
 
@@ -4013,14 +4015,14 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
 	/* Control */
-	pin_controls_init(vmx, vmx_pin_based_exec_ctrl(vmx));
+	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	vmx->hv_deadline_tsc = -1;
 
-	exec_controls_init(vmx, vmx_exec_control(vmx));
+	exec_controls_set(vmx, vmx_exec_control(vmx));
 
 	if (cpu_has_secondary_exec_ctrls()) {
 		vmx_compute_secondary_exec_control(vmx);
-		sec_exec_controls_init(vmx, vmx->secondary_exec_control);
+		sec_exec_controls_set(vmx, vmx->secondary_exec_control);
 	}
 
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
@@ -4078,10 +4080,10 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		++vmx->nmsrs;
 	}
 
-	vm_exit_controls_init(vmx, vmx_vmexit_ctrl());
+	vm_exit_controls_set(vmx, vmx_vmexit_ctrl());
 
 	/* 22.2.1, 20.8.1 */
-	vm_entry_controls_init(vmx, vmx_vmentry_ctrl());
+	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
 	vmx->vcpu.arch.cr0_guest_owned_bits = X86_CR0_TS;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~X86_CR0_TS);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c12c0aec13a5..ac40fc6859c1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -375,11 +375,6 @@ static inline u8 vmx_get_rvi(void)
 }
 
 #define BUILD_CONTROLS_SHADOW(lname, uname)				    \
-static inline void lname##_controls_init(struct vcpu_vmx *vmx, u32 val)	    \
-{									    \
-	vmcs_write32(uname, val);					    \
-	vmx->loaded_vmcs->controls_shadow.lname = val;			    \
-}									    \
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
 {									    \
 	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
-- 
2.21.0

