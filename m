Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312F52041DD
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgFVUUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:20:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:62017 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730159AbgFVUUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:20:39 -0400
IronPort-SDR: ZQQQ/rHz5jj2Yxu+TfvyEhIQwKybFXIUnFWO74ZLKncgeei+p3LKxCObkBZo0m6ayyFsJ88Phi
 cTv25uULILCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209057487"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="209057487"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 13:20:38 -0700
IronPort-SDR: CQ+eXfZX692oIZ3Lu4J470lvA3hd4jwi6l7rfhJVbKnw9PW/26e8/KHG64pcM7J/0q6F1sB6Gn
 i+R8Bfs4pKKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="478506341"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jun 2020 13:20:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] KVM: x86/mmu: Rename page_header() to to_shadow_page()
Date:   Mon, 22 Jun 2020 13:20:34 -0700
Message-Id: <20200622202034.15093-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622202034.15093-1-sean.j.christopherson@intel.com>
References: <20200622202034.15093-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename KVM's accessor for retrieving a 'struct kvm_mmu_page' from the
associated host physical address to better convey what the function is
doing.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++----------
 arch/x86/kvm/mmu/mmu_audit.c    |  6 +++---
 arch/x86/kvm/mmu/mmu_internal.h |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cd1f8017de8a..258334b4e563 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2208,7 +2208,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			continue;
 		}
 
-		child = page_header(ent & PT64_BASE_ADDR_MASK);
+		child = to_shadow_page(ent & PT64_BASE_ADDR_MASK);
 
 		if (child->unsync_children) {
 			if (mmu_pages_add(pvec, child, i))
@@ -2656,7 +2656,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * so we should update the spte at this point to get
 		 * a new sp with the correct access.
 		 */
-		child = page_header(*sptep & PT64_BASE_ADDR_MASK);
+		child = to_shadow_page(*sptep & PT64_BASE_ADDR_MASK);
 		if (child->role.access == direct_access)
 			return;
 
@@ -2678,7 +2678,7 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			if (is_large_pte(pte))
 				--kvm->stat.lpages;
 		} else {
-			child = page_header(pte & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 		}
 		return true;
@@ -3110,7 +3110,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
-			child = page_header(pte & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
@@ -3615,7 +3615,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (!VALID_PAGE(*root_hpa))
 		return;
 
-	sp = page_header(*root_hpa & PT64_BASE_ADDR_MASK);
+	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
 	--sp->root_count;
 	if (!sp->root_count && sp->role.invalid)
 		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
@@ -3845,7 +3845,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
 		hpa_t root = vcpu->arch.mmu->root_hpa;
-		sp = page_header(root);
+		sp = to_shadow_page(root);
 
 		/*
 		 * Even if another CPU was marking the SP as unsync-ed
@@ -3879,7 +3879,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 		if (root && VALID_PAGE(root)) {
 			root &= PT64_BASE_ADDR_MASK;
-			sp = page_header(root);
+			sp = to_shadow_page(root);
 			mmu_sync_children(vcpu, sp);
 		}
 	}
@@ -4235,8 +4235,8 @@ static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
 				  union kvm_mmu_page_role role)
 {
 	return (role.direct || pgd == root->pgd) &&
-	       VALID_PAGE(root->hpa) && page_header(root->hpa) &&
-	       role.word == page_header(root->hpa)->role.word;
+	       VALID_PAGE(root->hpa) && to_shadow_page(root->hpa) &&
+	       role.word == to_shadow_page(root->hpa)->role.word;
 }
 
 /*
@@ -4321,7 +4321,7 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 */
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-	__clear_sp_write_flooding_count(page_header(vcpu->arch.mmu->root_hpa));
+	__clear_sp_write_flooding_count(to_shadow_page(vcpu->arch.mmu->root_hpa));
 }
 
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index 6ba703d3497f..c8d51a37e2ce 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -45,7 +45,7 @@ static void __mmu_spte_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		      !is_last_spte(ent[i], level)) {
 			struct kvm_mmu_page *child;
 
-			child = page_header(ent[i] & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(ent[i] & PT64_BASE_ADDR_MASK);
 			__mmu_spte_walk(vcpu, child, fn, level - 1);
 		}
 	}
@@ -62,7 +62,7 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
 		hpa_t root = vcpu->arch.mmu->root_hpa;
 
-		sp = page_header(root);
+		sp = to_shadow_page(root);
 		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->root_level);
 		return;
 	}
@@ -72,7 +72,7 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 
 		if (root && VALID_PAGE(root)) {
 			root &= PT64_BASE_ADDR_MASK;
-			sp = page_header(root);
+			sp = to_shadow_page(root);
 			__mmu_spte_walk(vcpu, sp, fn, 2);
 		}
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 6371bf1d0b1c..3acf3b8eb469 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -43,7 +43,7 @@ struct kvm_mmu_page {
 	atomic_t write_flooding_count;
 };
 
-static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
+static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
 
@@ -52,7 +52,7 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 
 static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 {
-	return page_header(__pa(sptep));
+	return to_shadow_page(__pa(sptep));
 }
 
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
-- 
2.26.0

