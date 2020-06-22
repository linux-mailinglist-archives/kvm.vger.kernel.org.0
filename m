Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026FD2041DA
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgFVUUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:20:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:62019 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbgFVUUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:20:40 -0400
IronPort-SDR: sL4o0erdfEor/xISteE3/4E6wWmIm67JU8OSt2IsV8KDNYHd1QZ+fRO+4iiic7qaohLstmGkaq
 8jDt4ZbY3rmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209057485"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="209057485"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 13:20:37 -0700
IronPort-SDR: 9V8k+KBjGXG00f1tdI/pY/GPpMV18jXW1Qiqh2mLQrt9HPt7TAeyqgDz8b/mNRKCBpg+jswiSU
 VUHDUiB1JTow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="478506337"
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
Subject: [PATCH 5/6] KVM: x86/mmu: Add sptep_to_sp() helper to wrap shadow page lookup
Date:   Mon, 22 Jun 2020 13:20:33 -0700
Message-Id: <20200622202034.15093-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622202034.15093-1-sean.j.christopherson@intel.com>
References: <20200622202034.15093-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce sptep_to_sp() to reduce the boilerplate code needed to get the
shadow page associated with a spte pointer, and to improve readability
as it's not immediately obvious that "page_header" is a KVM-specific
accessor for retrieving a shadow page.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 28 +++++++++++++---------------
 arch/x86/kvm/mmu/mmu_audit.c    |  6 +++---
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
 4 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c1bf30e24bfc..cd1f8017de8a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -677,7 +677,7 @@ union split_spte {
 
 static void count_spte_clear(u64 *sptep, u64 spte)
 {
-	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
+	struct kvm_mmu_page *sp =  sptep_to_sp(sptep);
 
 	if (is_shadow_present_pte(spte))
 		return;
@@ -761,7 +761,7 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
  */
 static u64 __get_spte_lockless(u64 *sptep)
 {
-	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
+	struct kvm_mmu_page *sp =  sptep_to_sp(sptep);
 	union split_spte spte, *orig = (union split_spte *)sptep;
 	int count;
 
@@ -1427,7 +1427,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
 
-	sp = page_header(__pa(spte));
+	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	rmap_head = gfn_to_rmap(vcpu->kvm, gfn, sp);
 	return pte_list_add(vcpu, spte, rmap_head);
@@ -1439,7 +1439,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn_t gfn;
 	struct kvm_rmap_head *rmap_head;
 
-	sp = page_header(__pa(spte));
+	sp = sptep_to_sp(spte);
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 	rmap_head = gfn_to_rmap(kvm, gfn, sp);
 	__pte_list_remove(spte, rmap_head);
@@ -1531,7 +1531,7 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
 {
 	if (is_large_pte(*sptep)) {
-		WARN_ON(page_header(__pa(sptep))->role.level == PG_LEVEL_4K);
+		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
 		drop_spte(kvm, sptep);
 		--kvm->stat.lpages;
 		return true;
@@ -1543,7 +1543,7 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
 	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = page_header(__pa(sptep));
+		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
 
 		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
@@ -2017,7 +2017,7 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	struct kvm_rmap_head *rmap_head;
 	struct kvm_mmu_page *sp;
 
-	sp = page_header(__pa(spte));
+	sp = sptep_to_sp(spte);
 
 	rmap_head = gfn_to_rmap(vcpu->kvm, gfn, sp);
 
@@ -2139,7 +2139,7 @@ static void mark_unsync(u64 *spte)
 	struct kvm_mmu_page *sp;
 	unsigned int index;
 
-	sp = page_header(__pa(spte));
+	sp = sptep_to_sp(spte);
 	index = spte - sp->spt;
 	if (__test_and_set_bit(index, sp->unsync_child_bitmap))
 		return;
@@ -2465,9 +2465,7 @@ static void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
 
 static void clear_sp_write_flooding_count(u64 *spte)
 {
-	struct kvm_mmu_page *sp =  page_header(__pa(spte));
-
-	__clear_sp_write_flooding_count(sp);
+	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
@@ -3009,7 +3007,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
 		return 0;
 
-	sp = page_header(__pa(sptep));
+	sp = sptep_to_sp(sptep);
 	if (sp_ad_disabled(sp))
 		spte |= SPTE_AD_DISABLED_MASK;
 	else if (kvm_vcpu_ad_need_write_protect(vcpu))
@@ -3222,7 +3220,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 {
 	struct kvm_mmu_page *sp;
 
-	sp = page_header(__pa(sptep));
+	sp = sptep_to_sp(sptep);
 
 	/*
 	 * Without accessed bits, there's no way to distinguish between
@@ -3530,7 +3528,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			if (!is_shadow_present_pte(spte))
 				break;
 
-		sp = page_header(__pa(iterator.sptep));
+		sp = sptep_to_sp(iterator.sptep);
 		if (!is_last_spte(spte, sp->role.level))
 			break;
 
@@ -5914,7 +5912,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 restart:
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
-		sp = page_header(__pa(sptep));
+		sp = sptep_to_sp(sptep);
 		pfn = spte_to_pfn(*sptep);
 
 		/*
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index 9d2844f87f6d..6ba703d3497f 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -97,7 +97,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 	kvm_pfn_t pfn;
 	hpa_t hpa;
 
-	sp = page_header(__pa(sptep));
+	sp = sptep_to_sp(sptep);
 
 	if (sp->unsync) {
 		if (level != PG_LEVEL_4K) {
@@ -132,7 +132,7 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 	struct kvm_memory_slot *slot;
 	gfn_t gfn;
 
-	rev_sp = page_header(__pa(sptep));
+	rev_sp = sptep_to_sp(sptep);
 	gfn = kvm_mmu_page_get_gfn(rev_sp, sptep - rev_sp->spt);
 
 	slots = kvm_memslots_for_spte_role(kvm, rev_sp->role);
@@ -165,7 +165,7 @@ static void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 
 static void audit_spte_after_sync(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 {
-	struct kvm_mmu_page *sp = page_header(__pa(sptep));
+	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
 
 	if (vcpu->kvm->arch.audit_point == AUDIT_POST_SYNC && sp->unsync)
 		audit_printk(vcpu->kvm, "meet unsync sp(%p) after sync "
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8afa60f0a1a5..6371bf1d0b1c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -50,6 +50,11 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 	return (struct kvm_mmu_page *)page_private(page);
 }
 
+static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
+{
+	return page_header(__pa(sptep));
+}
+
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 38c576495048..e507a80b951a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -598,7 +598,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 	u64 *spte;
 	int i;
 
-	sp = page_header(__pa(sptep));
+	sp = sptep_to_sp(sptep);
 
 	if (sp->role.level > PG_LEVEL_4K)
 		return;
@@ -917,7 +917,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 		level = iterator.level;
 		sptep = iterator.sptep;
 
-		sp = page_header(__pa(sptep));
+		sp = sptep_to_sp(sptep);
 		if (is_last_spte(*sptep, level)) {
 			pt_element_t gpte;
 			gpa_t pte_gpa;
-- 
2.26.0

