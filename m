Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24CB4166EB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfEGPgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:36:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:51040 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfEGPgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:36:35 -0400
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
Subject: [PATCH 7/7] KVM: nVMX: Sync rarely accessed guest fields only when needed
Date:   Tue,  7 May 2019 08:36:29 -0700
Message-Id: <20190507153629.3681-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507153629.3681-1-sean.j.christopherson@intel.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many guest fields are rarely read (or written) by VMMs, i.e. likely
aren't accessed between runs of a nested VMCS.  Delay pulling rarely
accessed guest fields from vmcs02 until they are VMREAD or until vmcs12
is dirtied.  The latter case is necessary because nested VM-Entry will
consume all manner of fields when vmcs12 is dirty, e.g. for consistency
checks.

Note, an alternative to synchronizing all guest fields on VMREAD would
be to read *only* the field being accessed, but switching VMCS pointers
is expensive and odds are good if one guest field is being accessed then
others will soon follow, or that vmcs12 will be dirtied due to a VMWRITE
(see above).  And the full synchronization results in slightly cleaner
code.

Note, although GUEST_PDPTRs are relevant only for a 32-bit PAE guest,
they are accessed quite frequently for said guests, and a separate patch
is in flight to optimize away GUEST_PDTPR synchronziation for non-PAE
guests.

Skipping rarely accessed guest fields reduces the latency of a nested
VM-Exit by ~200 cycles.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 140 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h    |   6 ++
 2 files changed, 125 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 279961a63db2..0ff85c88e2eb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3373,21 +3373,56 @@ static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
 	return value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE;
 }
 
-/*
- * Update the guest state fields of vmcs12 to reflect changes that
- * occurred while L2 was running. (The "IA-32e mode guest" bit of the
- * VM-entry controls is also updated, since this is really a guest
- * state bit.)
- */
-static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
+static bool is_vmcs12_ext_field(unsigned long field)
 {
-	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
-	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
+	switch (field) {
+	case GUEST_ES_SELECTOR:
+	case GUEST_CS_SELECTOR:
+	case GUEST_SS_SELECTOR:
+	case GUEST_DS_SELECTOR:
+	case GUEST_FS_SELECTOR:
+	case GUEST_GS_SELECTOR:
+	case GUEST_LDTR_SELECTOR:
+	case GUEST_TR_SELECTOR:
+	case GUEST_ES_LIMIT:
+	case GUEST_CS_LIMIT:
+	case GUEST_SS_LIMIT:
+	case GUEST_DS_LIMIT:
+	case GUEST_FS_LIMIT:
+	case GUEST_GS_LIMIT:
+	case GUEST_LDTR_LIMIT:
+	case GUEST_TR_LIMIT:
+	case GUEST_GDTR_LIMIT:
+	case GUEST_IDTR_LIMIT:
+	case GUEST_ES_AR_BYTES:
+	case GUEST_DS_AR_BYTES:
+	case GUEST_FS_AR_BYTES:
+	case GUEST_GS_AR_BYTES:
+	case GUEST_LDTR_AR_BYTES:
+	case GUEST_TR_AR_BYTES:
+	case GUEST_ES_BASE:
+	case GUEST_CS_BASE:
+	case GUEST_SS_BASE:
+	case GUEST_DS_BASE:
+	case GUEST_FS_BASE:
+	case GUEST_GS_BASE:
+	case GUEST_LDTR_BASE:
+	case GUEST_TR_BASE:
+	case GUEST_GDTR_BASE:
+	case GUEST_IDTR_BASE:
+	case GUEST_PENDING_DBG_EXCEPTIONS:
+	case GUEST_BNDCFGS:
+		return true;
+	default:
+		break;
+	}
 
-	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
-	vmcs12->guest_rip = kvm_rip_read(vcpu);
-	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
+	return false;
+}
 
+static void __sync_vmcs02_to_vmcs12_ext(struct kvm_vcpu *vcpu,
+					struct vmcs12 *vmcs12)
+{
 	vmcs12->guest_es_selector = vmcs_read16(GUEST_ES_SELECTOR);
 	vmcs12->guest_cs_selector = vmcs_read16(GUEST_CS_SELECTOR);
 	vmcs12->guest_ss_selector = vmcs_read16(GUEST_SS_SELECTOR);
@@ -3407,8 +3442,6 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_gdtr_limit = vmcs_read32(GUEST_GDTR_LIMIT);
 	vmcs12->guest_idtr_limit = vmcs_read32(GUEST_IDTR_LIMIT);
 	vmcs12->guest_es_ar_bytes = vmcs_read32(GUEST_ES_AR_BYTES);
-	vmcs12->guest_cs_ar_bytes = vmcs_read32(GUEST_CS_AR_BYTES);
-	vmcs12->guest_ss_ar_bytes = vmcs_read32(GUEST_SS_AR_BYTES);
 	vmcs12->guest_ds_ar_bytes = vmcs_read32(GUEST_DS_AR_BYTES);
 	vmcs12->guest_fs_ar_bytes = vmcs_read32(GUEST_FS_AR_BYTES);
 	vmcs12->guest_gs_ar_bytes = vmcs_read32(GUEST_GS_AR_BYTES);
@@ -3424,11 +3457,65 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_tr_base = vmcs_readl(GUEST_TR_BASE);
 	vmcs12->guest_gdtr_base = vmcs_readl(GUEST_GDTR_BASE);
 	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
-
-	vmcs12->guest_interruptibility_info =
-		vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
 	vmcs12->guest_pending_dbg_exceptions =
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
+	if (kvm_mpx_supported())
+		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+}
+
+static void sync_vmcs02_to_vmcs12_ext(struct kvm_vcpu *vcpu,
+				      struct vmcs12 *vmcs12)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int cpu;
+
+	if (!vmx->nested.need_vmcs02_to_vmcs12_ext_sync)
+		return;
+
+
+	WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01);
+
+	cpu = get_cpu();
+	vmx->loaded_vmcs = &vmx->nested.vmcs02;
+	vmx_vcpu_load(&vmx->vcpu, cpu);
+
+	__sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
+
+	vmx->loaded_vmcs = &vmx->vmcs01;
+	vmx_vcpu_load(&vmx->vcpu, cpu);
+	put_cpu();
+
+	vmx->nested.need_vmcs02_to_vmcs12_ext_sync = false;
+}
+
+/*
+ * Update the guest state fields of vmcs12 to reflect changes that
+ * occurred while L2 was running. (The "IA-32e mode guest" bit of the
+ * VM-entry controls is also updated, since this is really a guest
+ * state bit.)
+ */
+static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (vmx->nested.hv_evmcs)
+		__sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
+
+	vmx->nested.need_vmcs02_to_vmcs12_ext_sync = !vmx->nested.hv_evmcs;
+
+	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
+	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
+
+	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
+	vmcs12->guest_rip = kvm_rip_read(vcpu);
+	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
+
+	vmcs12->guest_cs_ar_bytes = vmcs_read32(GUEST_CS_AR_BYTES);
+	vmcs12->guest_ss_ar_bytes = vmcs_read32(GUEST_SS_AR_BYTES);
+
+	vmcs12->guest_interruptibility_info =
+		vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+
 	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_HLT;
 	else
@@ -3478,8 +3565,6 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
 	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
 	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
-	if (kvm_mpx_supported())
-		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 }
 
 /*
@@ -4276,6 +4361,8 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 	if (vmx->nested.current_vmptr == -1ull)
 		return;
 
+	sync_vmcs02_to_vmcs12_ext(vcpu, get_vmcs12(vcpu));
+
 	if (enable_shadow_vmcs) {
 		/* copy to memory all shadowed fields in case
 		   they were modified */
@@ -4392,6 +4479,9 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
+	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
+		sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
+
 	/* Read the field, zero-extended to a u64 field_value */
 	field_value = vmcs12_read_any(vmcs12, field, offset);
 
@@ -4489,9 +4579,16 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
 
-	if (!is_guest_mode(vcpu))
+	if (!is_guest_mode(vcpu)) {
 		vmcs12 = get_vmcs12(vcpu);
-	else {
+
+		/*
+		 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
+		 * vmcs12, else we may crush a field or consume a stale value.
+		 */
+		if (!is_shadow_field_rw(field))
+			sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
+	} else {
 		/*
 		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
 		 * to shadowed-field sets the ALU flags for VMfailInvalid.
@@ -5310,6 +5407,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	if (is_guest_mode(vcpu)) {
 		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
+		__sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
 	} else if (!vmx->nested.need_vmcs12_to_shadow_sync) {
 		if (vmx->nested.hv_evmcs)
 			copy_enlightened_to_vmcs12(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 16210dde0374..8b215c6840b4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -123,6 +123,12 @@ struct nested_vmx {
 	 */
 	bool vmcs02_initialized;
 
+	/*
+	 * Indicates lazily loaded guest state has not yet been decached from
+	 * vmcs02.
+	 */
+	bool need_vmcs02_to_vmcs12_ext_sync;
+
 	bool change_vmcs01_virtual_apic_mode;
 
 	/*
-- 
2.21.0

