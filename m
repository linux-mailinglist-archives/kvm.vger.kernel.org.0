Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88D21878D9
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCQEzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:55:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:34097 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbgCQExN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:13 -0400
IronPort-SDR: ZMiglvMM6yL7oq2ETJTUAfGKieHJB3zawCbfSP8L3cirqRz3A2ER2FfDG5q9s9s6EPu/XC5s8x
 cW5a/FCmYwFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:12 -0700
IronPort-SDR: Rj0bX330l9zFczH6bFSAQunxHvib0ujrC7tWvSwDpTEcOdaDZ/USdtxlKbHgRDSO0u0tippxDn
 ejckLu4lW8bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252755"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:11 -0700
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
Subject: [PATCH v2 07/32] KVM: x86: Sync SPTEs when injecting page/EPT fault into L1
Date:   Mon, 16 Mar 2020 21:52:13 -0700
Message-Id: <20200317045238.30434-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

When injecting a page fault or EPT violation/misconfiguration, invoke
->invlpg() to sync any shadow PTEs associated with the faulting address,
including those in previous MMUs that are associated with L1's current
EPTP (in a nested EPT scenario).  Skip the sync (which incurs a costly
retpoline) if the MMU can't have unsync'd SPTEs for the address.

In addition, flush any hardware TLB entries associated with the faulting
address if the fault is the result of emulation, i.e. not an async
page fault.  !PRESENT and RSVD page faults are exempt from the flushing
as the CPU is not allowed to cache such translations.

Signed-off-by: Junaid Shahid <junaids@google.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 44 +++++++++++++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 arch/x86/kvm/x86.c        | 17 +++++++++++++++
 3 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 50bb7d8862aa..7bd13d207199 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -323,6 +323,14 @@ void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 }
 
+#define EPTP_PA_MASK	GENMASK_ULL(51, 12)
+
+static bool nested_ept_root_matches(hpa_t root_hpa, u64 root_eptp, u64 eptp)
+{
+	return VALID_PAGE(root_hpa) &&
+	       ((root_eptp & EPTP_PA_MASK) == (eptp & EPTP_PA_MASK));
+}
+
 static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		struct x86_exception *fault)
 {
@@ -330,18 +338,32 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 exit_reason;
 	unsigned long exit_qualification = vcpu->arch.exit_qualification;
+	struct kvm_mmu_root_info *prev;
+	u64 gpa = fault->address;
+	int i;
 
 	if (vmx->nested.pml_full) {
 		exit_reason = EXIT_REASON_PML_FULL;
 		vmx->nested.pml_full = false;
 		exit_qualification &= INTR_INFO_UNBLOCK_NMI;
-	} else if (fault->error_code & PFERR_RSVD_MASK)
-		exit_reason = EXIT_REASON_EPT_MISCONFIG;
-	else
-		exit_reason = EXIT_REASON_EPT_VIOLATION;
+	} else {
+		if (fault->error_code & PFERR_RSVD_MASK)
+			exit_reason = EXIT_REASON_EPT_MISCONFIG;
+		else
+			exit_reason = EXIT_REASON_EPT_VIOLATION;
+
+		/* Sync SPTEs in cached MMUs that track the current L1 EPTP. */
+		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+			prev = &vcpu->arch.mmu->prev_roots[i];
+
+			if (nested_ept_root_matches(prev->hpa, prev->cr3,
+						    vmcs12->ept_pointer))
+				vcpu->arch.mmu->invlpg(vcpu, gpa, prev->hpa);
+		}
+	}
 
 	nested_vmx_vmexit(vcpu, exit_reason, 0, exit_qualification);
-	vmcs12->guest_physical_address = fault->address;
+	vmcs12->guest_physical_address = gpa;
 }
 
 static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
@@ -4559,7 +4581,7 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 
@@ -4868,7 +4890,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
 		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e)) {
-			kvm_inject_page_fault(vcpu, &e);
+			kvm_inject_emulated_page_fault(vcpu, &e);
 			return 1;
 		}
 	}
@@ -4942,7 +4964,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 					instr_info, false, len, &gva))
 			return 1;
 		if (kvm_read_guest_virt(vcpu, gva, &value, len, &e)) {
-			kvm_inject_page_fault(vcpu, &e);
+			kvm_inject_emulated_page_fault(vcpu, &e);
 			return 1;
 		}
 	}
@@ -5107,7 +5129,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	/* *_system ok, nested_vmx_check_permission has verified cpl=0 */
 	if (kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
 					sizeof(gpa_t), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 	return nested_vmx_succeed(vcpu);
@@ -5151,7 +5173,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 
@@ -5215,7 +5237,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 	if (operand.vpid >> 16)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b447d66f44e6..ba49323a89d8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5404,7 +5404,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fcad522f221e..f506248d61a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -614,6 +614,11 @@ EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 void kvm_inject_l1_page_fault(struct kvm_vcpu *vcpu,
 			      struct x86_exception *fault)
 {
+	if (!vcpu->arch.mmu->direct_map &&
+	    (fault->error_code & PFERR_PRESENT_MASK))
+		vcpu->arch.mmu->invlpg(vcpu, fault->address,
+				       vcpu->arch.mmu->root_hpa);
+
 	vcpu->arch.mmu->inject_page_fault(vcpu, fault);
 }
 
@@ -622,7 +627,19 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 {
 	WARN_ON_ONCE(fault->vector != PF_VECTOR);
 
+	/*
+	 * Invalidate the TLB entry for the faulting address, if one can exist,
+	 * else the access will fault indefinitely (and to emulate hardware).
+	 */
+	if ((fault->error_code & PFERR_PRESENT_MASK) &&
+	    !(fault->error_code & PFERR_RSVD_MASK))
+		kvm_x86_ops->tlb_flush_gva(vcpu, fault->address);
+
 	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
+		/*
+		 * No need to sync SPTEs, the fault is being injected into L2,
+		 * whose page tables are not being shadowed.
+		 */
 		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
 	else
 		kvm_inject_l1_page_fault(vcpu, fault);
-- 
2.24.1

