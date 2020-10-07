Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F5E28566F
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 03:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgJGBog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 21:44:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:7786 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgJGBoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 21:44:20 -0400
IronPort-SDR: aqYtfWheU+M67nRaNQrFl/xBrdNsH/pzkAZYISgW6765Cki93imqj4nActABAEr5ymE/SVx3nU
 Trz54qzmUreg==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164914603"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="164914603"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:44:19 -0700
IronPort-SDR: Tp41jLrchQ6B2fLrl9caaGcPIt8qm+rhFCDL02mTOeSKB7wD2pQa6R1Z7ee0b8NZZ2jrU2WErg
 gpY4y/xTfOWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="297410306"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 06 Oct 2020 18:44:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stas Sergeev <stsp@users.sourceforge.net>
Subject: [PATCH 4/6] KVM: x86: Move vendor CR4 validity check to dedicated kvm_x86_ops hook
Date:   Tue,  6 Oct 2020 18:44:15 -0700
Message-Id: <20201007014417.29276-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007014417.29276-1-sean.j.christopherson@intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out VMX's checks on CR4.VMXE to a dedicated hook, .is_valid_cr4(),
and invoke the new hook from kvm_valid_cr4().  This fixes an issue where
KVM_SET_SREGS would return success while failing to actually set CR4.

Fixing the issue by explicitly checking kvm_x86_ops.set_cr4()'s return
in __set_sregs() is not a viable option as KVM has already stuffed a
variety of vCPU state.

Note, kvm_valid_cr4() and is_valid_cr4() have different return types and
inverted semantics.  This will be remedied in a future patch.

Fixes: 5e1746d6205d ("KVM: nVMX: Allow setting the VMXE bit in CR4")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/svm/svm.c          |  9 +++++++--
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 31 ++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h          |  2 +-
 arch/x86/kvm/x86.c              |  6 ++++--
 7 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d0f77235da92..e0fb61d8f6fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1085,7 +1085,8 @@ struct kvm_x86_ops {
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
-	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
+	bool (*is_valid_cr4)(struct kvm_vcpu *vcpu, unsigned long cr0);
+	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f92a19b77da3..38680d453f80 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1679,7 +1679,12 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	update_cr0_intercept(svm);
 }
 
-int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+static bool svm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return true;
+}
+
+void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
 	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
@@ -1693,7 +1698,6 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
 	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
-	return 0;
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
@@ -4192,6 +4196,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
 	.set_cr0 = svm_set_cr0,
+	.is_valid_cr4 = svm_is_valid_cr4,
 	.set_cr4 = svm_set_cr4,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a7f997459b87..8fe632d7fca4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -352,7 +352,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 u32 svm_msrpm_offset(u32 msr);
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void svm_flush_tlb(struct kvm_vcpu *vcpu);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6eca8a7deed1..650ff3e4b5ca 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4814,7 +4814,7 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 	/*
 	 * The Intel VMX Instruction Reference lists a bunch of bits that are
 	 * prerequisite to running VMXON, most notably cr4.VMXE must be set to
-	 * 1 (see vmx_set_cr4() for when we allow the guest to set this).
+	 * 1 (see vmx_is_valid_cr4() for when we allow the guest to set this).
 	 * Otherwise, we should fail with #UD.  But most faulting conditions
 	 * have already been checked by hardware, prior to the VM-exit for
 	 * VMXON.  We do test guest cr4.VMXE because processor CR4 always has
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dac93346aca9..5aa0a3af7dbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3076,7 +3076,23 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
-int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	/*
+	 * We operate under the default treatment of SMM, so VMX cannot be
+	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
+	 * handled by kvm_valid_cr4().
+	 */
+	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
+		return false;
+
+	if (to_vmx(vcpu)->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
+		return false;
+
+	return true;
+}
+
+void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	/*
@@ -3104,17 +3120,6 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 	}
 
-	/*
-	 * We operate under the default treatment of SMM, so VMX cannot be
-	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
-	 * handled by kvm_valid_cr4().
-	 */
-	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
-		return 1;
-
-	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
-		return 1;
-
 	vcpu->arch.cr4 = cr4;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR4);
 
@@ -3145,7 +3150,6 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, hw_cr4);
-	return 0;
 }
 
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
@@ -7597,6 +7601,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_cpl = vmx_get_cpl,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.set_cr0 = vmx_set_cr0,
+	.is_valid_cr4 = vmx_is_valid_cr4,
 	.set_cr4 = vmx_set_cr4,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 5961cb897125..96895ac16b27 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -321,7 +321,7 @@ u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu);
 void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
 void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx);
 void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4015a43cc8a..64cc86f4f18f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -973,6 +973,9 @@ int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
 		return -EINVAL;
 
+	if (!kvm_x86_ops.is_valid_cr4(vcpu, cr4))
+		return -EINVAL;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_valid_cr4);
@@ -1006,8 +1009,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
-	if (kvm_x86_ops.set_cr4(vcpu, cr4))
-		return 1;
+	kvm_x86_ops.set_cr4(vcpu, cr4);
 
 	if (((cr4 ^ old_cr4) & pdptr_bits) ||
 	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
-- 
2.28.0

