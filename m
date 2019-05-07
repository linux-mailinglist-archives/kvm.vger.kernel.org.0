Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A469F166EA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfEGPge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:36:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:51035 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfEGPgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:36:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 08:36:32 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2019 08:36:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 5/7] KVM: nVMX: Use descriptive names for VMCS sync functions and flags
Date:   Tue,  7 May 2019 08:36:27 -0700
Message-Id: <20190507153629.3681-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507153629.3681-1-sean.j.christopherson@intel.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nested virtualization involves copying data between many different types
of VMCSes, e.g. vmcs02, vmcs12, shadow VMCS and eVMCS.  Rename a variety
of functions and flags to document both the source and destination of
each sync.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++--------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  4 ++--
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0eee7894b453..632e7e4324f3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1612,7 +1612,7 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 	 * evmcs->host_gdtr_base = vmcs12->host_gdtr_base;
 	 * evmcs->host_idtr_base = vmcs12->host_idtr_base;
 	 * evmcs->host_rsp = vmcs12->host_rsp;
-	 * sync_vmcs12() doesn't read these:
+	 * sync_vmcs02_to_vmcs12() doesn't read these:
 	 * evmcs->io_bitmap_a = vmcs12->io_bitmap_a;
 	 * evmcs->io_bitmap_b = vmcs12->io_bitmap_b;
 	 * evmcs->msr_bitmap = vmcs12->msr_bitmap;
@@ -1836,7 +1836,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu)
+void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -1857,7 +1857,7 @@ void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu)
 		copy_vmcs12_to_shadow(vmx);
 	}
 
-	vmx->nested.need_vmcs12_sync = false;
+	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
 static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
@@ -3039,7 +3039,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
 	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
-		vmx->nested.need_vmcs12_sync = true;
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return 1;
 }
 
@@ -3379,7 +3379,7 @@ static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
  * VM-entry controls is also updated, since this is really a guest
  * state bit.)
  */
-static void sync_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
+static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 {
 	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
 	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
@@ -3858,14 +3858,14 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
 
 	if (likely(!vmx->fail)) {
-		sync_vmcs12(vcpu, vmcs12);
+		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
 
 		if (exit_reason != -1)
 			prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
 				       exit_qualification);
 
 		/*
-		 * Must happen outside of sync_vmcs12() as it will
+		 * Must happen outside of sync_vmcs02_to_vmcs12() as it will
 		 * also be used to capture vmcs12 cache as part of
 		 * capturing nVMX state for snapshot (migration).
 		 *
@@ -3921,7 +3921,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	if ((exit_reason != -1) && (enable_shadow_vmcs || vmx->nested.hv_evmcs))
-		vmx->nested.need_vmcs12_sync = true;
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 
 	/* in case we halted in L2 */
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
@@ -4280,7 +4280,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 		/* copy to memory all shadowed fields in case
 		   they were modified */
 		copy_shadow_to_vmcs12(vmx);
-		vmx->nested.need_vmcs12_sync = false;
+		vmx->nested.need_vmcs12_to_shadow_sync = false;
 		vmx_disable_shadow_vmcs(vmx);
 	}
 	vmx->nested.posted_intr_nv = -1;
@@ -4545,7 +4545,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 			      SECONDARY_EXEC_SHADOW_VMCS);
 		vmcs_write64(VMCS_LINK_POINTER,
 			     __pa(vmx->vmcs01.shadow_vmcs));
-		vmx->nested.need_vmcs12_sync = true;
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	}
 	vmx->nested.dirty_vmcs12 = true;
 }
@@ -5296,12 +5296,12 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	 * When running L2, the authoritative vmcs12 state is in the
 	 * vmcs02. When running L1, the authoritative vmcs12 state is
 	 * in the shadow or enlightened vmcs linked to vmcs01, unless
-	 * need_vmcs12_sync is set, in which case, the authoritative
+	 * need_vmcs12_to_shadow_sync is set, in which case, the authoritative
 	 * vmcs12 state is in the vmcs12 already.
 	 */
 	if (is_guest_mode(vcpu)) {
-		sync_vmcs12(vcpu, vmcs12);
-	} else if (!vmx->nested.need_vmcs12_sync) {
+		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
+	} else if (!vmx->nested.need_vmcs12_to_shadow_sync) {
 		if (vmx->nested.hv_evmcs)
 			copy_enlightened_to_vmcs12(vmx);
 		else if (enable_shadow_vmcs)
@@ -5414,7 +5414,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		 * Sync eVMCS upon entry as we may not have
 		 * HV_X64_MSR_VP_ASSIST_PAGE set up yet.
 		 */
-		vmx->nested.need_vmcs12_sync = true;
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	} else {
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index e847ff1019a2..8688262a15ed 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -17,7 +17,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry);
 bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
-void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu);
+void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 60306f19105d..91f55ff65345 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6392,8 +6392,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
 	}
 
-	if (vmx->nested.need_vmcs12_sync)
-		nested_sync_from_vmcs12(vcpu);
+	if (vmx->nested.need_vmcs12_to_shadow_sync)
+		nested_sync_vmcs12_to_shadow(vcpu);
 
 	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 63d37ccce3dc..16210dde0374 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -113,7 +113,7 @@ struct nested_vmx {
 	 * Indicates if the shadow vmcs or enlightened vmcs must be updated
 	 * with the data held by struct vmcs12.
 	 */
-	bool need_vmcs12_sync;
+	bool need_vmcs12_to_shadow_sync;
 	bool dirty_vmcs12;
 
 	/*
-- 
2.21.0

