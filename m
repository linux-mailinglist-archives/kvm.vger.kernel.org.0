Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07948CB14D
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbfJCVi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:38:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:52651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387909AbfJCVi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:38:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051627"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 05/13] kvm: Add #PF injection for KVM XO
Date:   Thu,  3 Oct 2019 14:23:52 -0700
Message-Id: <20191003212400.31130-6-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If there is a read or write violation on the gfn range of an XO memslot,
then inject a page fault into the guest with the guest virtual address
that faulted. This can be done directly if the hardware provides the gva
access that caused the fault. Otherwise, the violating instruction needs
to be emulated to figure it out.

TODO:
Currently ACC_USER_MASK is used to mean not-readable in the EPT case,
but in the x86 page tables case it means the real user bit and so can't
be overloaded to mean not readable. Probably a new dedicated ACC_ flag is
needed for not readable to be used in XOM cases. Instead of changing that
everywhere a conditional is added in paging_tmpl.h to check for the KVM XO
bit. This should probably be made to work with the logic in
permission_fault instead of having a special case.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.c              | 52 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h      | 29 ++++++++++++++----
 arch/x86/kvm/x86.c              |  5 +++-
 4 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b363a7fc47b0..6d06c794d720 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -785,6 +785,8 @@ struct kvm_vcpu_arch {
 	bool gva_available;
 	gva_t gva_val;
 
+	bool xo_fault;
+
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 338cc64cc821..d5ba44066b62 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -45,6 +45,7 @@
 #include <asm/io.h>
 #include <asm/vmx.h>
 #include <asm/kvm_page_track.h>
+#include <asm/traps.h>
 #include "trace.h"
 
 /*
@@ -4130,6 +4131,34 @@ check_hugepage_cache_consistency(struct kvm_vcpu *vcpu, gfn_t gfn, int level)
 	return kvm_mtrr_check_gfn_range_consistency(vcpu, gfn, page_num);
 }
 
+
+static int try_inject_exec_only_pf(struct kvm_vcpu *vcpu, u64 error_code)
+{
+	struct x86_exception fault;
+	int cpl = kvm_x86_ops->get_cpl(vcpu);
+	/*
+	 * There is an assumption here that if there is an TDP violation for an
+	 * XO memslot, then it must be a read or write fault.
+	 */
+	u16 fault_error_code = X86_PF_PROT | (cpl == 3 ? X86_PF_USER : 0);
+
+	if (!vcpu->arch.gva_available)
+		return 0;
+
+	if (error_code & PFERR_WRITE_MASK)
+		fault_error_code |= X86_PF_WRITE;
+
+	fault.vector = PF_VECTOR;
+	fault.error_code_valid = true;
+	fault.error_code = fault_error_code;
+	fault.nested_page_fault = false;
+	fault.address = vcpu->arch.gva_val;
+	fault.async_page_fault = true;
+	kvm_inject_page_fault(vcpu, &fault);
+
+	return 1;
+}
+
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 			  bool prefault)
 {
@@ -4141,12 +4170,35 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	unsigned long mmu_seq;
 	int write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
 	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
+	/*
+	 * Set xo_fault when the fault is a read or write fault on an xo memslot
+	 * so that the emulator knows it needs to check page table permissions
+	 * and will inject a fault.
+	 */
+	vcpu->arch.xo_fault = false;
+	if (slot && unlikely((slot->flags & KVM_MEM_EXECONLY)
+		&& !(error_code & PFERR_FETCH_MASK)))
+		vcpu->arch.xo_fault = true;
+
+	/* If memslot is xo, need to inject fault */
+	if (unlikely(vcpu->arch.xo_fault)) {
+		/*
+		 * If not enough information to inject the fault,
+		 * emulate to figure it out and emulate the PF.
+		 */
+		if (!try_inject_exec_only_pf(vcpu, error_code))
+			return RET_PF_EMULATE;
+
+		return 1;
+	}
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7d5cdb3af594..eae1871c5225 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -307,7 +307,9 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gpa_t pte_gpa;
 	bool have_ad;
 	int offset;
-	u64 walk_nx_mask = 0;
+	u64 walk_mask = 0;
+	u64 walk_nr_mask = 0;
+	bool kvm_xo = guest_cpuid_has(vcpu, X86_FEATURE_KVM_XO);
 	const int write_fault = access & PFERR_WRITE_MASK;
 	const int user_fault  = access & PFERR_USER_MASK;
 	const int fetch_fault = access & PFERR_FETCH_MASK;
@@ -322,7 +324,11 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
-	walk_nx_mask = 1ULL << PT64_NX_SHIFT;
+	walk_mask = 1ULL << PT64_NX_SHIFT;
+	if (kvm_xo) {
+		walk_nr_mask = 1ULL << cpuid_maxphyaddr(vcpu);
+		walk_mask |= walk_nr_mask;
+	}
 	if (walker->level == PT32E_ROOT_LEVEL) {
 		pte = mmu->get_pdptr(vcpu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
@@ -395,7 +401,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * Inverting the NX it lets us AND it like other
 		 * permission bits.
 		 */
-		pte_access = pt_access & (pte ^ walk_nx_mask);
+		pte_access = pt_access & (pte ^ walk_mask);
 
 		if (unlikely(!FNAME(is_present_gpte)(pte)))
 			goto error;
@@ -412,12 +418,25 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
 
 	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
-	walker->pt_access = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
-	walker->pte_access = FNAME(gpte_access)(pte_access ^ walk_nx_mask);
+	walker->pt_access = FNAME(gpte_access)(pt_access ^ walk_mask);
+	walker->pte_access = FNAME(gpte_access)(pte_access ^ walk_mask);
+
 	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
 	if (unlikely(errcode))
 		goto error;
 
+	/*
+	 * KVM XO bit is not checked in permission_fault(), so check it here and
+	 * inject appropriate fault.
+	 */
+	if (kvm_xo && !fetch_fault
+	    && (walk_nr_mask & (pte_access ^ walk_nr_mask))) {
+		errcode = PFERR_PRESENT_MASK;
+		if (write_fault)
+			errcode	|= PFERR_WRITE_MASK;
+		goto error;
+	}
+
 	gfn = gpte_to_gfn_lvl(pte, walker->level);
 	gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa138d3a86c5..2e321d788672 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5494,8 +5494,11 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	 * Note, this cannot be used on string operations since string
 	 * operation using rep will only have the initial GPA from the NPF
 	 * occurred.
+	 *
+	 * If the fault was an XO fault, we need to walk the page tables to
+	 * determine the gva and emulate the PF.
 	 */
-	if (vcpu->arch.gpa_available &&
+	if (!vcpu->arch.xo_fault && vcpu->arch.gpa_available &&
 	    emulator_can_use_gpa(ctxt) &&
 	    (addr & ~PAGE_MASK) == (vcpu->arch.gpa_val & ~PAGE_MASK)) {
 		gpa = vcpu->arch.gpa_val;
-- 
2.17.1

