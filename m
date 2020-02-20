Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6409C1668B3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgBTUoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:44:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:13656 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbgBTUoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:44:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 12:44:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="349237114"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2020 12:44:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] KVM: x86: Drop @invalidate_gpa param from kvm_x86_ops' tlb_flush()
Date:   Thu, 20 Feb 2020 12:43:54 -0800
Message-Id: <20200220204356.8837-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220204356.8837-1-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop @invalidate_gpa from ->tlb_flush() and kvm_vcpu_flush_tlb() now
that all callers pass %true for said param.

Note, vmx_flush_tlb() now unconditionally passes %true to
__vmx_flush_tlb(), the less straightforward VMX change will be handled
in a future patch.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/svm.c              | 10 +++++-----
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/vmx/vmx.h          |  4 ++--
 arch/x86/kvm/x86.c              |  6 +++---
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 86aed64b9a88..2d5ef0081d50 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1095,7 +1095,7 @@ struct kvm_x86_ops {
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
-	void (*tlb_flush)(struct kvm_vcpu *vcpu, bool invalidate_gpa);
+	void (*tlb_flush)(struct kvm_vcpu *vcpu);
 	int  (*tlb_remote_flush)(struct kvm *kvm);
 	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
 			struct kvm_tlb_range *range);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7011a4e54866..7fefe58dd7ab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5186,7 +5186,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	kvm_mmu_load_cr3(vcpu);
-	kvm_x86_ops->tlb_flush(vcpu, true);
+	kvm_x86_ops->tlb_flush(vcpu);
 out:
 	return r;
 }
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e549811f51c6..16d58ffc7aff 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -385,7 +385,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
+static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
 static void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate);
 static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
@@ -2634,7 +2634,7 @@ static int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return 1;
 
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
-		svm_flush_tlb(vcpu, true);
+		svm_flush_tlb(vcpu);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
@@ -3588,7 +3588,7 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
-	svm_flush_tlb(&svm->vcpu, true);
+	svm_flush_tlb(&svm->vcpu);
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
@@ -5591,7 +5591,7 @@ static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 	return 0;
 }
 
-static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
+static void svm_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -5610,7 +5610,7 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 
 static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
-	svm_flush_tlb(vcpu, true);
+	svm_flush_tlb(vcpu);
 }
 
 static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 906e9d9aa09e..8bb380d22dc2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6043,7 +6043,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 		if (flexpriority_enabled) {
 			sec_exec_control |=
 				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-			vmx_flush_tlb(vcpu, true);
+			vmx_flush_tlb(vcpu);
 		}
 		break;
 	case LAPIC_MODE_X2APIC:
@@ -6061,7 +6061,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
 {
 	if (!is_guest_mode(vcpu)) {
 		vmcs_write64(APIC_ACCESS_ADDR, hpa);
-		vmx_flush_tlb(vcpu, true);
+		vmx_flush_tlb(vcpu);
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f42cf3dcd70..6e588d238318 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -514,9 +514,9 @@ static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid,
 	}
 }
 
-static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
+static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, invalidate_gpa);
+	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, true);
 }
 
 static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72f7ca4baa6d..e26ffebe6f6e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2646,10 +2646,10 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.time = 0;
 }
 
-static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
+static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_x86_ops->tlb_flush(vcpu, invalidate_gpa);
+	kvm_x86_ops->tlb_flush(vcpu);
 }
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
@@ -8166,7 +8166,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_LOAD_CR3, vcpu))
 			kvm_mmu_load_cr3(vcpu);
 		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
-			kvm_vcpu_flush_tlb(vcpu, true);
+			kvm_vcpu_flush_tlb(vcpu);
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
 			r = 0;
-- 
2.24.1

