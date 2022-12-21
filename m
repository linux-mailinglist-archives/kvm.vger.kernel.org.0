Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D8365388A
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiLUWZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbiLUWYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:24:38 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D99327174
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:33 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-460ab8a327eso2986857b3.23
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PpjDc5kQAW+k4ZQYHkXtWYHcVTdhQtxJVF/UKPc9J1o=;
        b=iOK91BqR2al5dx6yxJYNdJ0KjbgTezozD9d7Mfm19BVc0Kn0bIzeV8O1a2Amyvc21A
         k4zIUHIPW0rEnb7NHeK7QnH/T9jDadvayvwB+uwAIHMBE+jIW0LKKiX43+hFzNddGEDL
         PsoSH7FSpEWOZODYGU8x75XtalOTNUa5zPk+Dw5g9eAW8EGY1XV1zBxEfiZC/iqpNyik
         T1BVGUnWV6RWCRPu8ua0k42ZlNt7NDeOb9uT5nVz4LTvl55RESt8bk00TJGWB9wl+4Xk
         8Q+0BypI3uvPrwdnt6Xpgenc3i+yQX0gL4bvsoyke4sHKc9qjqTPrazgLRNuAaA9Jrhb
         se0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PpjDc5kQAW+k4ZQYHkXtWYHcVTdhQtxJVF/UKPc9J1o=;
        b=l3MITiakzivud1UilmWiKBsOKE9og6kZQI9Tauri95L+xa1kzmxhvxuEQ3niI+Sb7h
         +8BCA8nRVVLN/RWNiy0Bwd1BPN7FCWdEAuZSZYHXDWjjwXCE1jLxooC0hgjnp4KPfWTP
         RCCKSSIp+4RGj4hFH310ftvtiWhaJohZCTWglSxobIQwpChbQgX5ZY0yvW+sX7QHbDlr
         N+lXayqcDYvi3voY26tVxKjW44yz9bU1VjLD/Du7wyoD+hhRlBVd6uEyehTTZTK6hDGh
         ZXPzcwc8sQhw7KCQq4n0bs3kCIx3ylDLzErF3BlZVKw7vFoPsJKqVBtgACn0vfjWba5u
         r8WQ==
X-Gm-Message-State: AFqh2koIIPd/2o1UDWQxG/t4fx/MhQHPGjF5R+gX0eumFK4iOJo91ZF3
        ZYYEBIWA1kGP1J8of0iLEucdlYPk7jrr
X-Google-Smtp-Source: AMrXdXu88AaC3b5v889t8A+RxymtaH7gcPHvKNpTnvt/AXsdpsQsEau7v6rQsJqLyekXwlH5RmEX9VxdYxs2
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6902:513:b0:6fa:5a47:c208 with SMTP id
 x19-20020a056902051300b006fa5a47c208mr376658ybs.472.1671661472442; Wed, 21
 Dec 2022 14:24:32 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:10 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-7-bgardon@google.com>
Subject: [RFC 06/14] KVM: x86/MMU: Clean up Shadow MMU exports
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that paging_tmpl.h is included from shadow_mmu.c, there's no need to
export many of the functions currrently in shadow_mmu.h, so remove those
exports and mark the functions static. This cleans up the interface
of the Shadow MMU, and will allow the implementation to keep the details
of rmap_heads internal.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/shadow_mmu.c | 78 +++++++++++++++++++++--------------
 arch/x86/kvm/mmu/shadow_mmu.h | 51 +----------------------
 2 files changed, 48 insertions(+), 81 deletions(-)

diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 86b5fb75d50a..090b4788f7de 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -21,6 +21,20 @@
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
+struct kvm_shadow_walk_iterator {
+	u64 addr;
+	hpa_t shadow_addr;
+	u64 *sptep;
+	int level;
+	unsigned index;
+};
+
+#define for_each_shadow_entry_using_root(_vcpu, _root, _addr, _walker)     \
+	for (shadow_walk_init_using_root(&(_walker), (_vcpu),              \
+					 (_root), (_addr));                \
+	     shadow_walk_okay(&(_walker));			           \
+	     shadow_walk_next(&(_walker)))
+
 #define for_each_shadow_entry(_vcpu, _addr, _walker)            \
 	for (shadow_walk_init(&(_walker), _vcpu, _addr);	\
 	     shadow_walk_okay(&(_walker));			\
@@ -227,7 +241,7 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
  *
  * Returns true if the TLB needs to be flushed
  */
-bool mmu_spte_update(u64 *sptep, u64 new_spte)
+static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 {
 	bool flush = false;
 	u64 old_spte = mmu_spte_update_no_track(sptep, new_spte);
@@ -311,7 +325,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
  * Directly clear spte without caring the state bits of sptep,
  * it is used to set the upper level spte.
  */
-void mmu_spte_clear_no_track(u64 *sptep)
+static void mmu_spte_clear_no_track(u64 *sptep)
 {
 	__update_clear_spte_fast(sptep, 0ull);
 }
@@ -354,7 +368,7 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 
 static bool sp_has_gptes(struct kvm_mmu_page *sp);
 
-gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
+static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
 	if (sp->role.passthrough)
 		return sp->gfn;
@@ -410,8 +424,8 @@ static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
 	          sp->gfn, kvm_mmu_page_get_gfn(sp, index), gfn);
 }
 
-void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
-			     unsigned int access)
+static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
+				    unsigned int access)
 {
 	gfn_t gfn = kvm_mmu_page_get_gfn(sp, index);
 
@@ -627,7 +641,7 @@ struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
 	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
 }
 
-bool rmap_can_add(struct kvm_vcpu *vcpu)
+static bool rmap_can_add(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_memory_cache *mc;
 
@@ -735,7 +749,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
 	     _spte_; _spte_ = rmap_get_next(_iter_))
 
-void drop_spte(struct kvm *kvm, u64 *sptep)
+static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	u64 old_spte = mmu_spte_clear_track_bits(kvm, sptep);
 
@@ -1112,7 +1126,7 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 	pte_list_remove(parent_pte, &sp->parent_ptes);
 }
 
-void drop_parent_pte(struct kvm_mmu_page *sp, u64 *parent_pte)
+static void drop_parent_pte(struct kvm_mmu_page *sp, u64 *parent_pte)
 {
 	mmu_page_remove_parent_pte(sp, parent_pte);
 	mmu_spte_clear_no_track(parent_pte);
@@ -1342,8 +1356,8 @@ static void mmu_pages_clear_parents(struct mmu_page_path *parents)
 	} while (!sp->unsync_children);
 }
 
-int mmu_sync_children(struct kvm_vcpu *vcpu, struct kvm_mmu_page *parent,
-		      bool can_yield)
+static int mmu_sync_children(struct kvm_vcpu *vcpu, struct kvm_mmu_page *parent,
+			     bool can_yield)
 {
 	int i;
 	struct kvm_mmu_page *sp;
@@ -1389,7 +1403,7 @@ void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
 	atomic_set(&sp->write_flooding_count,  0);
 }
 
-void clear_sp_write_flooding_count(u64 *spte)
+static void clear_sp_write_flooding_count(u64 *spte)
 {
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
@@ -1602,9 +1616,9 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
 	return role;
 }
 
-struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu, u64 *sptep,
-					  gfn_t gfn, bool direct,
-					  unsigned int access)
+static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
+						 u64 *sptep, gfn_t gfn,
+						 bool direct, unsigned int access)
 {
 	union kvm_mmu_page_role role;
 
@@ -1615,8 +1629,9 @@ struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu, u64 *sptep,
 	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
 
-void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
-				 struct kvm_vcpu *vcpu, hpa_t root, u64 addr)
+static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
+					struct kvm_vcpu *vcpu, hpa_t root,
+					u64 addr)
 {
 	iterator->addr = addr;
 	iterator->shadow_addr = root;
@@ -1643,14 +1658,14 @@ void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
 	}
 }
 
-void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
-		      struct kvm_vcpu *vcpu, u64 addr)
+static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
+			     struct kvm_vcpu *vcpu, u64 addr)
 {
 	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->root.hpa,
 				    addr);
 }
 
-bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
+static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 {
 	if (iterator->level < PG_LEVEL_4K)
 		return false;
@@ -1672,7 +1687,7 @@ static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 	--iterator->level;
 }
 
-void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
+static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 {
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
@@ -1703,13 +1718,14 @@ static void __link_shadow_page(struct kvm *kvm,
 		mark_unsync(sptep);
 }
 
-void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp)
+static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
+			     struct kvm_mmu_page *sp)
 {
 	__link_shadow_page(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, sptep, sp, true);
 }
 
-void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			  unsigned direct_access)
+static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
+				 unsigned direct_access)
 {
 	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
 		struct kvm_mmu_page *child;
@@ -1731,8 +1747,8 @@ void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 }
 
 /* Returns the number of zapped non-leaf child shadow pages. */
-int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *spte,
-		     struct list_head *invalid_list)
+static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *spte,
+			    struct list_head *invalid_list)
 {
 	u64 pte;
 	struct kvm_mmu_page *child;
@@ -2144,9 +2160,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	return 0;
 }
 
-int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
-		 u64 *sptep, unsigned int pte_access, gfn_t gfn,
-		 kvm_pfn_t pfn, struct kvm_page_fault *fault)
+static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			u64 *sptep, unsigned int pte_access, gfn_t gfn,
+			kvm_pfn_t pfn, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
 	int level = sp->role.level;
@@ -2251,8 +2267,8 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-void __direct_pte_prefetch(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			   u64 *sptep)
+static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *sp, u64 *sptep)
 {
 	u64 *spte, *start = NULL;
 	int i;
@@ -2788,7 +2804,7 @@ int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level)
 	return leaf;
 }
 
-void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
+static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	u64 spte;
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 00d2f9abecf0..20c65a0ea52c 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -23,32 +23,11 @@ struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
 };
 
+/* Only exported for debugfs.c. */
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
-struct kvm_shadow_walk_iterator {
-	u64 addr;
-	hpa_t shadow_addr;
-	u64 *sptep;
-	int level;
-	unsigned index;
-};
-
-#define for_each_shadow_entry_using_root(_vcpu, _root, _addr, _walker)     \
-	for (shadow_walk_init_using_root(&(_walker), (_vcpu),              \
-					 (_root), (_addr));                \
-	     shadow_walk_okay(&(_walker));			           \
-	     shadow_walk_next(&(_walker)))
-
-bool mmu_spte_update(u64 *sptep, u64 new_spte);
-void mmu_spte_clear_no_track(u64 *sptep);
-gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
-void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
-			     unsigned int access);
-
 struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
 				  const struct kvm_memory_slot *slot);
-bool rmap_can_add(struct kvm_vcpu *vcpu);
-void drop_spte(struct kvm *kvm, u64 *sptep);
 bool rmap_write_protect(struct kvm_rmap_head *rmap_head, bool pt_protect);
 bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			const struct kvm_memory_slot *slot);
@@ -72,30 +51,8 @@ bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		       struct kvm_memory_slot *slot, gfn_t gfn,
 		       int level, pte_t unused);
 
-void drop_parent_pte(struct kvm_mmu_page *sp, u64 *parent_pte);
-int mmu_sync_children(struct kvm_vcpu *vcpu, struct kvm_mmu_page *parent,
-		      bool can_yield);
 void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
-void clear_sp_write_flooding_count(u64 *spte);
-
-struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu, u64 *sptep,
-					  gfn_t gfn, bool direct,
-					  unsigned int access);
-
-void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
-				 struct kvm_vcpu *vcpu, hpa_t root, u64 addr);
-void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
-		      struct kvm_vcpu *vcpu, u64 addr);
-bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator);
-void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator);
-
-void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp);
-
-void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			  unsigned direct_access);
 
-int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *spte,
-		     struct list_head *invalid_list);
 bool __kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 				struct list_head *invalid_list,
 				int *nr_zapped);
@@ -107,11 +64,6 @@ int make_mmu_pages_available(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 
-int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
-		 u64 *sptep, unsigned int pte_access, gfn_t gfn,
-		 kvm_pfn_t pfn, struct kvm_page_fault *fault);
-void __direct_pte_prefetch(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			   u64 *sptep);
 int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte);
 
@@ -121,7 +73,6 @@ int mmu_alloc_special_roots(struct kvm_vcpu *vcpu);
 
 int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level);
 
-void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 		       int bytes, struct kvm_page_track_notifier_node *node);
 
-- 
2.39.0.314.g84b9a713c41-goog

