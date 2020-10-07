Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC2E285669
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 03:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgJGBoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 21:44:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:7792 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgJGBoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 21:44:23 -0400
IronPort-SDR: rt8APeZ4S8pojpOyqy0W/clwWU1GiSH2k/3HyeXuWtv5Mx3G9G4/1rCoq/RcM8ZAymJWb/CAxn
 hf+3aby1AzGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164914607"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="164914607"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:44:19 -0700
IronPort-SDR: vqALXjD9B736iV7bM/uGxTF9Sr6B/GL4NvRhnzDfm4lrwKGYuoR/hF0XfYZyj1lirC/q8o/O3v
 ow0etGiP/eIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="297410309"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 06 Oct 2020 18:44:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stas Sergeev <stsp@users.sourceforge.net>
Subject: [PATCH 5/6] KVM: x86: Return bool instead of int for CR4 and SREGS validity checks
Date:   Tue,  6 Oct 2020 18:44:16 -0700
Message-Id: <20201007014417.29276-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007014417.29276-1-sean.j.christopherson@intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the common CR4 and SREGS checks to return a bool instead of an
int, i.e. true/false instead of 0/-EINVAL, and add "is" to the name to
clarify the polarity of the return value (which is effectively inverted
by this change).

No functional changed intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 arch/x86/kvm/x86.c        | 28 ++++++++++++----------------
 arch/x86/kvm/x86.h        |  2 +-
 4 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba50ff6e35c7..114e0e8561bc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -254,7 +254,7 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
 			return false;
 	}
-	if (kvm_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
+	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
 		return false;
 
 	return nested_vmcb_check_controls(&vmcb12->control);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5aa0a3af7dbb..ac69aa3076d8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3081,7 +3081,7 @@ static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	/*
 	 * We operate under the default treatment of SMM, so VMX cannot be
 	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
-	 * handled by kvm_valid_cr4().
+	 * handled by kvm_is_valid_cr4().
 	 */
 	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
 		return false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64cc86f4f18f..5870aa6cbad2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -965,20 +965,17 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
-int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & cr4_reserved_bits)
-		return -EINVAL;
+		return false;
 
 	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
-		return -EINVAL;
+		return false;
 
-	if (!kvm_x86_ops.is_valid_cr4(vcpu, cr4))
-		return -EINVAL;
-
-	return 0;
+	return kvm_x86_ops.is_valid_cr4(vcpu, cr4);
 }
-EXPORT_SYMBOL_GPL(kvm_valid_cr4);
+EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
@@ -986,7 +983,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP;
 
-	if (kvm_valid_cr4(vcpu, cr4))
+	if (!kvm_is_valid_cr4(vcpu, cr4))
 		return 1;
 
 	if (is_long_mode(vcpu)) {
@@ -9422,7 +9419,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 }
 EXPORT_SYMBOL_GPL(kvm_task_switch);
 
-static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	if ((sregs->efer & EFER_LME) && (sregs->cr0 & X86_CR0_PG)) {
 		/*
@@ -9430,19 +9427,18 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		 * 64-bit mode (though maybe in a 32-bit code segment).
 		 * CR4.PAE and EFER.LMA must be set.
 		 */
-		if (!(sregs->cr4 & X86_CR4_PAE)
-		    || !(sregs->efer & EFER_LMA))
-			return -EINVAL;
+		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
+			return false;
 	} else {
 		/*
 		 * Not in 64-bit mode: EFER.LMA is clear and the code
 		 * segment cannot be 64-bit.
 		 */
 		if (sregs->efer & EFER_LMA || sregs->cs.l)
-			return -EINVAL;
+			return false;
 	}
 
-	return kvm_valid_cr4(vcpu, sregs->cr4);
+	return kvm_is_valid_cr4(vcpu, sregs->cr4);
 }
 
 static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
@@ -9454,7 +9450,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	struct desc_ptr dt;
 	int ret = -EINVAL;
 
-	if (kvm_valid_sregs(vcpu, sregs))
+	if (!kvm_is_valid_sregs(vcpu, sregs))
 		goto out;
 
 	apic_base_msr.data = sregs->apic_base;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3900ab0c6004..b3b1d237ffe5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -369,7 +369,7 @@ static inline bool kvm_dr6_valid(u64 data)
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
-- 
2.28.0

