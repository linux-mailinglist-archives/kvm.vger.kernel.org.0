Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBDA394D9
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbfFGSzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 14:55:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:27538 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729973AbfFGSzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 14:55:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 11:55:36 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2019 11:55:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH v2] KVM: nVMX: Stash L1's CR3 in vmcs01.GUEST_CR3 on nested entry w/o EPT
Date:   Fri,  7 Jun 2019 11:55:34 -0700
Message-Id: <20190607185534.24368-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM does not have 100% coverage of VMX consistency checks, i.e. some
checks that cause VM-Fail may only be detected by hardware during a
nested VM-Entry.  In such a case, KVM must restore L1's state to the
pre-VM-Enter state as L2's state has already been loaded into KVM's
software model.

L1's CR3 and PDPTRs in particular are loaded from vmcs01.GUEST_*.  But
when EPT is disabled, the associated fields hold KVM's shadow values,
not L1's "real" values.  Fortunately, when EPT is disabled the PDPTRs
come from memory, i.e. are not cached in the VMCS.  Which leaves CR3
as the sole anomaly.

A previously applied workaround to handle CR3 was to force nested early
checks if EPT is disabled:

  commit 2b27924bb1d48 ("KVM: nVMX: always use early vmcs check when EPT
                         is disabled")

Forcing nested early checks is undesirable as doing so adds hundreds of
cycles to every nested VM-Entry.  Rather than take this performance hit,
handle CR3 by overwriting vmcs01.GUEST_CR3 with L1's CR3 during nested
VM-Entry when EPT is disabled *and* nested early checks are disabled.
By stuffing vmcs01.GUEST_CR3, nested_vmx_restore_host_state() will
naturally restore the correct vcpu->arch.cr3 from vmcs01.GUEST_CR3.

These shenanigans work because nested_vmx_restore_host_state() does a
full kvm_mmu_reset_context(), i.e. unloads the current MMU, which
guarantees vmcs01.GUEST_CR3 will be rewritten with a new shadow CR3
prior to re-entering L1.

vcpu->arch.root_mmu.root_hpa is set to INVALID_PAGE via:

    nested_vmx_restore_host_state() ->
        kvm_mmu_reset_context() ->
            kvm_mmu_unload() ->
                kvm_mmu_free_roots()

kvm_mmu_unload() has WARN_ON(root_hpa != INVALID_PAGE), i.e. we can bank
on 'root_hpa == INVALID_PAGE' unless the implementation of
kvm_mmu_reset_context() is changed.

On the way into L1, VMCS.GUEST_CR3 is guaranteed to be written (on a
successful entry) via:

    vcpu_enter_guest() ->
        kvm_mmu_reload() ->
            kvm_mmu_load() ->
                kvm_mmu_load_cr3() ->
                    vmx_set_cr3()

Stuff vmcs01.GUEST_CR3 if and only if nested early checks are disabled
as a "late" VM-Fail should never happen win that case (KVM WARNs), and
the conditional write avoids the need to restore the correct GUEST_CR3
when nested_vmx_check_vmentry_hw() fails.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

v2: Squashed the revert of the previous workaround into this patch
    and added a beefy comment [Paolo].

 arch/x86/include/uapi/asm/vmx.h |  1 -
 arch/x86/kvm/vmx/nested.c       | 44 +++++++++++++++++----------------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index d213ec5c3766..f0b0c90dd398 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -146,7 +146,6 @@
 
 #define VMX_ABORT_SAVE_GUEST_MSR_FAIL        1
 #define VMX_ABORT_LOAD_HOST_PDPTE_FAIL       2
-#define VMX_ABORT_VMCS_CORRUPTED             3
 #define VMX_ABORT_LOAD_HOST_MSR_FAIL         4
 
 #endif /* _UAPIVMX_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0f705c7d590c..5c6f37edb16c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2964,6 +2964,25 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
+	/*
+	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
+	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
+	 * i.e. a VM-Fail detected by hardware but not KVM, KVM must unwind its
+	 * software model to the pre-VMEntry host state.  When EPT is disabled,
+	 * GUEST_CR3 holds KVM's shadow CR3, not L1's "real" CR3, which causes
+	 * nested_vmx_restore_host_state() to corrupt vcpu->arch.cr3.  Stuffing
+	 * vmcs01.GUEST_CR3 results in the unwind naturally setting arch.cr3 to
+	 * the correct value.  Smashing vmcs01.GUEST_CR3 is safe because nested
+	 * VM-Exits, and the unwind, reset KVM's MMU, i.e. vmcs01.GUEST_CR3 is
+	 * guaranteed to be overwritten with a shadow CR3 prior to re-entering
+	 * L1.  Don't stuff vmcs01.GUEST_CR3 when using nested early checks as
+	 * KVM modifies vcpu->arch.cr3 if and only if the early hardware checks
+	 * pass, and early VM-Fails do not reset KVM's MMU, i.e. the VM-Fail
+	 * path would need to manually save/restore vmcs01.GUEST_CR3.
+	 */
+	if (!enable_ept && !nested_early_check)
+		vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
+
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
 
 	prepare_vmcs02_early(vmx, vmcs12);
@@ -3775,18 +3794,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	vmx_set_cr4(vcpu, vmcs_readl(CR4_READ_SHADOW));
 
 	nested_ept_uninit_mmu_context(vcpu);
-
-	/*
-	 * This is only valid if EPT is in use, otherwise the vmcs01 GUEST_CR3
-	 * points to shadow pages!  Fortunately we only get here after a WARN_ON
-	 * if EPT is disabled, so a VMabort is perfectly fine.
-	 */
-	if (enable_ept) {
-		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-		__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
-	} else {
-		nested_vmx_abort(vcpu, VMX_ABORT_VMCS_CORRUPTED);
-	}
+	vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
+	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
 
 	/*
 	 * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs
@@ -3794,7 +3803,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 * VMFail, like everything else we just need to ensure our
 	 * software model is up-to-date.
 	 */
-	ept_save_pdptrs(vcpu);
+	if (enable_ept)
+		ept_save_pdptrs(vcpu);
 
 	kvm_mmu_reset_context(vcpu);
 
@@ -5726,14 +5736,6 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 {
 	int i;
 
-	/*
-	 * Without EPT it is not possible to restore L1's CR3 and PDPTR on
-	 * VMfail, because they are not available in vmcs01.  Just always
-	 * use hardware checks.
-	 */
-	if (!enable_ept)
-		nested_early_check = 1;
-
 	if (!cpu_has_vmx_shadow_vmcs())
 		enable_shadow_vmcs = 0;
 	if (enable_shadow_vmcs) {
-- 
2.21.0

