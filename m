Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6569E36566D
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhDTKmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:34983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231770AbhDTKmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:22 -0400
IronPort-SDR: o1bG+MpVtgx4lWsjDY28ukxKbFoHA+4wHQlzrb8w6nUSBcvnbPMUx5yZv4oN0YosZTGyMt+FF6
 OEYelhTSRhCA==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590778"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590778"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:46 -0700
IronPort-SDR: XaShw9JuAaGGhWf5lTTXWLh0+29NiJpjsHthMMNEHTbZlb1WR+qpB2EMiJEtv2WqqOXcm7Ap97
 RjSNqnoSrYsQ==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872799"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:46 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     isaku.yamahata@gmail.com, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [RFC PATCH 10/10] KVM: x86/mmu: make FNAME(fetch) receive single argument
Date:   Tue, 20 Apr 2021 03:39:20 -0700
Message-Id: <476ff2ab1160fffe8a0ec060afd0ee9ef8df5d18.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert FNAME(fetch) to receive single argument, struct kvm_page_fault
instead of many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 36 +++++++++++++++-------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7df68b5fdd10..ad01d933f2b7 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -631,20 +631,19 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
  * If the guest tries to write a write-protected page, we need to
  * emulate this operation, return 1 to indicate this case.
  */
-static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
-			 struct guest_walker *gw, u32 error_code,
-			 int max_level, kvm_pfn_t pfn, bool map_writable,
-			 bool prefault)
+static int FNAME(fetch)(struct kvm_page_fault *kpf,  struct guest_walker *gw)
 {
+	struct kvm_vcpu *vcpu = kpf->vcpu;
+	gpa_t addr = kpf->cr2_or_gpa;
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool write_fault = error_code & PFERR_WRITE_MASK;
-	bool exec = error_code & PFERR_FETCH_MASK;
+	bool exec = kpf->error_code & PFERR_FETCH_MASK;
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
 	unsigned direct_access, access = gw->pt_access;
 	int top_level, level, req_level, ret;
 	gfn_t base_gfn = gw->gfn;
+	WARN_ON(kpf->gfn != gw->gfn);
 
 	direct_access = gw->pte_access;
 
@@ -689,10 +688,10 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn,
+	level = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, kpf->max_level, &kpf->pfn,
 					huge_page_disallowed, &req_level);
 
-	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
+	trace_kvm_mmu_spte_requested(addr, gw->level, kpf->pfn);
 
 	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
 		clear_sp_write_flooding_count(it.sptep);
@@ -703,7 +702,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		 */
 		if (nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(*it.sptep, gw->gfn, it.level,
-						   &pfn, &level);
+						   &kpf->pfn, &level);
 
 		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
@@ -722,8 +721,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		}
 	}
 
-	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault,
-			   it.level, base_gfn, pfn, prefault, map_writable);
+	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, kpf->write_fault,
+			   it.level, base_gfn, kpf->pfn, kpf->prefault,
+			   kpf->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
@@ -794,14 +794,11 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	struct kvm_vcpu *vcpu = kpf->vcpu;
 	gpa_t addr = kpf->cr2_or_gpa;
 	u32 error_code = kpf->error_code;
-	bool prefault = kpf->prefault;
-	bool write_fault = kpf->write_fault;
 	bool user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
 	int r;
 	unsigned long mmu_seq;
 	bool is_self_change_mapping;
-	int max_level;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
@@ -821,7 +818,7 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	 */
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
-		if (!prefault)
+		if (!kpf->prefault)
 			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
 
 		return RET_PF_RETRY;
@@ -843,9 +840,9 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	      &walker, user_fault, &vcpu->arch.write_fault_to_shadow_pgtable);
 
 	if (is_self_change_mapping)
-		max_level = PG_LEVEL_4K;
+		kpf->max_level = PG_LEVEL_4K;
 	else
-		max_level = walker.level;
+		kpf->max_level = walker.level;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
@@ -860,7 +857,7 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	 * Do not change pte_access if the pfn is a mmio page, otherwise
 	 * we will cache the incorrect access into mmio spte.
 	 */
-	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
+	if (kpf->write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
 	     !is_write_protection(vcpu) && !user_fault &&
 	      !is_noslot_pfn(kpf->pfn)) {
 		walker.pte_access |= ACC_WRITE_MASK;
@@ -886,8 +883,7 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, kpf->pfn,
-			 kpf->map_writable, prefault);
+	r = FNAME(fetch)(kpf, &walker);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.25.1

