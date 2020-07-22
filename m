Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A775229CAD
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgGVQBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:40 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37950 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728640AbgGVQBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1BD97305D7E9;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id F3E583072789;
        Wed, 22 Jul 2020 19:01:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 05/34] KVM: x86: mmu: add EPT view parameter to kvm_mmu_get_page()
Date:   Wed, 22 Jul 2020 19:00:52 +0300
Message-Id: <20200722160121.9601-6-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

This will be used to create root_hpa for all the EPT views.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++-
 arch/x86/kvm/mmu/mmu.c          | 43 ++++++++++++++++++++-------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +++--
 3 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0acc21087caf..bd45778e0904 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -243,6 +243,8 @@ enum x86_intercept_stage;
 				 PFERR_WRITE_MASK |		\
 				 PFERR_PRESENT_MASK)
 
+#define KVM_MAX_EPT_VIEWS	3
+
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
@@ -349,6 +351,9 @@ struct kvm_mmu_page {
 	union kvm_mmu_page_role role;
 	gfn_t gfn;
 
+	/* The view this shadow page belongs to */
+	u16 view;
+
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
@@ -936,7 +941,7 @@ struct kvm_arch {
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
 	u8 mmu_valid_gen;
-	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
+	struct hlist_head mmu_page_hash[KVM_MAX_EPT_VIEWS][KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
 	 */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f3ba4d0452c9..0b6527a1ebe6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2349,14 +2349,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
 
-#define for_each_valid_sp(_kvm, _sp, _gfn)				\
+#define for_each_valid_sp(_kvm, _sp, _gfn, view)			\
 	hlist_for_each_entry(_sp,					\
-	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
+	  &(_kvm)->arch.mmu_page_hash[view][kvm_page_table_hashfn(_gfn)], hash_link) \
 		if (is_obsolete_sp((_kvm), (_sp))) {			\
 		} else
 
 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
-	for_each_valid_sp(_kvm, _sp, _gfn)				\
+	for_each_valid_sp(_kvm, _sp, _gfn, 0)				\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
 static inline bool is_ept_sp(struct kvm_mmu_page *sp)
@@ -2564,7 +2564,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gva_t gaddr,
 					     unsigned level,
 					     int direct,
-					     unsigned int access)
+					     unsigned int access,
+					     u16 view)
 {
 	union kvm_mmu_page_role role;
 	unsigned quadrant;
@@ -2587,7 +2588,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	for_each_valid_sp(vcpu->kvm, sp, gfn) {
+	for_each_valid_sp(vcpu->kvm, sp, gfn, view) {
 		if (sp->gfn != gfn) {
 			collisions++;
 			continue;
@@ -2624,9 +2625,10 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	sp->gfn = gfn;
 	sp->role = role;
+	sp->view = view;
 	pg_hash = kvm_page_table_hashfn(gfn);
 	hlist_add_head(&sp->hash_link,
-		&vcpu->kvm->arch.mmu_page_hash[pg_hash]);
+		&vcpu->kvm->arch.mmu_page_hash[view][pg_hash]);
 	if (!direct) {
 		/*
 		 * we should do write protection before syncing pages
@@ -3463,7 +3465,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 		drop_large_spte(vcpu, it.sptep);
 		if (!is_shadow_present_pte(*it.sptep)) {
 			sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr,
-					      it.level - 1, true, ACC_ALL);
+					      it.level - 1, true, ACC_ALL,
+					      kvm_get_ept_view(vcpu));
 
 			link_shadow_page(vcpu, it.sptep, sp);
 			if (account_disallowed_nx_lpage)
@@ -3788,7 +3791,7 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 }
 
 static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
-			    u8 level, bool direct)
+			    u8 level, bool direct, u16 view)
 {
 	struct kvm_mmu_page *sp;
 
@@ -3798,7 +3801,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		return INVALID_PAGE;
 	}
-	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
+	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL, view);
 	++sp->root_count;
 
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -3809,19 +3812,24 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
 	u8 shadow_root_level = vcpu->arch.mmu->shadow_root_level;
 	hpa_t root;
-	unsigned i;
+
+	u16 i;
 
 	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
-		vcpu->arch.mmu->root_hpa = root;
+		for (i = 0; i < KVM_MAX_EPT_VIEWS; i++) {
+			root = mmu_alloc_root(vcpu, 0, PAGE_SIZE * i,
+					      shadow_root_level, true, i);
+			if (!VALID_PAGE(root))
+				return -ENOSPC;
+			if (i == 0)
+				vcpu->arch.mmu->root_hpa = root;
+		}
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
 			MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
-					      i << 30, PT32_ROOT_LEVEL, true);
+					      i << 30, PT32_ROOT_LEVEL, true, 0);
 			if (!VALID_PAGE(root))
 				return -ENOSPC;
 			vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK;
@@ -3857,7 +3865,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->root_hpa));
 
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      vcpu->arch.mmu->shadow_root_level, false);
+				      vcpu->arch.mmu->shadow_root_level, false,
+				      0);
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
 		vcpu->arch.mmu->root_hpa = root;
@@ -3887,7 +3896,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 
 		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
-				      PT32_ROOT_LEVEL, false);
+				      PT32_ROOT_LEVEL, false, 0);
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
 		vcpu->arch.mmu->pae_root[i] = root | pm_mask;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index bd70ece1ef8b..244e339dee52 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -665,7 +665,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
-					      false, access);
+					      false, access,
+					      kvm_get_ept_view(vcpu));
 		}
 
 		/*
@@ -702,7 +703,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 
 		if (!is_shadow_present_pte(*it.sptep)) {
 			sp = kvm_mmu_get_page(vcpu, base_gfn, addr,
-					      it.level - 1, true, direct_access);
+					      it.level - 1, true, direct_access,
+					      kvm_get_ept_view(vcpu));
 			link_shadow_page(vcpu, it.sptep, sp);
 			if (lpage_disallowed)
 				account_huge_nx_page(vcpu->kvm, sp);
