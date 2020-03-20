Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB55D18DA31
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgCTV3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:20439 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbgCTV27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:59 -0400
IronPort-SDR: 6Pjuj3TSaZ3yORS2+Ku9tPC9Xa8uOFpqk8HNb74gwdAJHfQiSHIO+v7RK1vNgYVzk5L6Vb0IB2
 Yc0JyjOAsfDg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:56 -0700
IronPort-SDR: Vu97rLrGvYiVmK+Cs9I/DgfJuVxopoq7INqG5/+zm9qoUkZH7ay3w9vo1cu+ZtzawHh4a9MlGF
 3C/FFjlHiL1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224492"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 24/37] KVM: x86: Introduce KVM_REQ_TLB_FLUSH_CURRENT to flush current ASID
Date:   Fri, 20 Mar 2020 14:28:20 -0700
Message-Id: <20200320212833.3507-25-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM_REQ_TLB_FLUSH_CURRENT to allow optimized TLB flushing of VMX's
EPTP/VPID contexts[*] from the KVM MMU and/or in a deferred manner, e.g.
to flush L2's context during nested VM-Enter.

Convert KVM_REQ_TLB_FLUSH to KVM_REQ_TLB_FLUSH_CURRENT in flows where
the flush is directly associated with vCPU-scoped instruction emulation,
i.e. MOV CR3 and INVPCID.

Add a comment in vmx_vcpu_load_vmcs() above its KVM_REQ_TLB_FLUSH to
make it clear that it deliberately requests a flush of all contexts.

Service any pending flush request on nested VM-Exit as it's possible a
nested VM-Exit could occur after requesting a flush for L2.  Add the
same logic for nested VM-Enter even though it's _extremely_ unlikely
for flush to be pending on nested VM-Enter, but theoretically possible
(in the future) due to RSM (SMM) emulation.

[*] Intel also has an Address Space Identifier (ASID) concept, e.g.
    EPTP+VPID+PCID == ASID, it's just not documented in the SDM because
    the rules of invalidation are different based on which piece of the
    ASID is being changed, i.e. whether the EPTP, VPID, or PCID context
    must be invalidated.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm.c              |  1 +
 arch/x86/kvm/vmx/nested.c       |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          |  7 ++++++-
 arch/x86/kvm/x86.c              | 11 +++++++++--
 arch/x86/kvm/x86.h              |  6 ++++++
 6 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0392a9db110d..26fa52450569 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -83,6 +83,7 @@
 #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
 #define KVM_REQ_APICV_UPDATE \
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1106,6 +1107,7 @@ struct kvm_x86_ops {
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
 	void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
+	void (*tlb_flush_current)(struct kvm_vcpu *vcpu);
 	int  (*tlb_remote_flush)(struct kvm *kvm);
 	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
 			struct kvm_tlb_range *range);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 10e5b8c4b515..0bf7ad5f62ad 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7406,6 +7406,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.set_rflags = svm_set_rflags,
 
 	.tlb_flush_all = svm_flush_tlb,
+	.tlb_flush_current = svm_flush_tlb,
 	.tlb_flush_gva = svm_flush_tlb_gva,
 	.tlb_flush_guest = svm_flush_tlb,
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 580d5c98352f..b9fa2f89b564 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3230,6 +3230,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	u32 exit_reason = EXIT_REASON_INVALID_STATE;
 	u32 exit_qual;
 
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
+		kvm_vcpu_flush_tlb_current(vcpu);
+
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
@@ -4295,6 +4298,10 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
+	/* Service the TLB flush request for L2 before switching to L1. */
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
+		kvm_vcpu_flush_tlb_current(vcpu);
+
 	leave_guest_mode(vcpu);
 
 	if (nested_cpu_has_preemption_timer(vmcs12))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d6cf625b4011..ae7279802652 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1367,6 +1367,10 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 		void *gdt = get_current_gdt_ro();
 		unsigned long sysenter_esp;
 
+		/*
+		 * Flush all EPTP/VPID contexts, the new pCPU may have stale
+		 * TLB entries from its previous association with the vCPU.
+		 */
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 
 		/*
@@ -5479,7 +5483,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 
 		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
 			kvm_mmu_sync_roots(vcpu);
-			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
 
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
@@ -7921,6 +7925,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_rflags = vmx_set_rflags,
 
 	.tlb_flush_all = vmx_flush_tlb_all,
+	.tlb_flush_current = vmx_flush_tlb_current,
 	.tlb_flush_gva = vmx_flush_tlb_gva,
 	.tlb_flush_guest = vmx_flush_tlb_guest,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 333968e5ef3c..cccfcf612008 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1033,7 +1033,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (cr3 == kvm_read_cr3(vcpu) && !pdptrs_changed(vcpu)) {
 		if (!skip_tlb_flush) {
 			kvm_mmu_sync_roots(vcpu);
-			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
 		return 0;
 	}
@@ -8222,8 +8222,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_mmu_sync_roots(vcpu);
 		if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
 			kvm_mmu_load_pgd(vcpu);
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
 			kvm_vcpu_flush_tlb_all(vcpu);
+
+			/* Flushing all ASIDs flushes the current ASID... */
+			kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+		}
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
+			kvm_vcpu_flush_tlb_current(vcpu);
+
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
 			r = 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c1954e216b41..e0816850ce5e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -125,6 +125,12 @@ static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
 	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
 }
 
+static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.tlb_flush;
+	kvm_x86_ops->tlb_flush_current(vcpu);
+}
+
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);
-- 
2.24.1

