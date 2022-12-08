Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76403647668
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiLHTjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLHTj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:39:28 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE6C87CAC
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:18 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k7-20020a256f07000000b006cbcc030bc8so2527227ybc.18
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a3bKpO5b/v0RCxuNw899Xshau8/zESVZr6kYd+4zdKE=;
        b=KPxzCU0dxo9eGutKZUhotgl9jJKDzTmrDJ6vzV8erWlSEgK6SxsymFRTIzbdw/dwSY
         +SC6PtCJm9pU4ixS9rlPhFsl5m6gvXODTybYIHpQJFhDImrcri/mVQCf3U7geImSfYZv
         jOCNDVtIAcIEEh22mPn+jaizoJ2GqxOS+Wu/loB2TQYGTJav7XgL+IkKf50x/qxFwed5
         KTLCUMIw8jkfg57J7bMRWqf0cY8RS9HRUaqkp6JSA+YDTR7c6IyBfSoqX9W9wVR0n1EG
         fdBWsC/Qy8Z8slhboisRHODy4G1CnX1V+3pJ0tUZkCd2ntcVE/dPnHvwgIZS+klnYn7M
         Opqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a3bKpO5b/v0RCxuNw899Xshau8/zESVZr6kYd+4zdKE=;
        b=rxkFEslT89I/MBXcoy6hZHlj0YNGiiz8DWydLmFPYU4HjFFE3MAvrWywidcvzEDLK7
         WhRaX0wgjMDbQ/ls5afIPKlC5WAZQcmsq5yJIoen6bPZvyDflhS23quo0Cr86KKKeIqg
         9yFKXLRsTlNaMz7Y2M7Quj7TmFCX80FomJIcGRJHRO/Rdq51+5k3bNbzlG8axBwARgca
         OYECzUHA3OlmaE+jh2tdn5LKsxwMy20W8AAk/1BqpewNEMNa/NCHMd0TY3DMeqSIB/Gu
         IScrwp7AV8lZ4+cFeEWm/7ggm70ujHh7hZRquJ5eI/MigH+VUhgoEqI6cMmRFhLt4CMg
         Wp6g==
X-Gm-Message-State: ANoB5pmDhj4akj5a+7cRaoodYUlHKjhkMqnwn3gOY7xvoRDxxJCnaNdY
        bx7sbfcn2NTPpvrzTNh5ReHlkGvnJXlTBA==
X-Google-Smtp-Source: AA0mqf5gdryBtEuIfjSANvRDkIbH3z8min3Cb8Q36LkcXIqZ65yLJBzUlATA8LbtoFr5VbGGv9+8vT8wYeHhZQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:8644:0:b0:3c7:3c2b:76b5 with SMTP id
 w65-20020a818644000000b003c73c2b76b5mr46075323ywf.22.1670528357332; Thu, 08
 Dec 2022 11:39:17 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:26 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-7-dmatlack@google.com>
Subject: [RFC PATCH 06/37] KVM: MMU: Move struct kvm_mmu_page to common code
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move struct kvm_mmu_page to common code and all x86-specific fields into
kvm_mmu_page_arch.

This commit increases the size of struct kvm_mmu_page by 64 bytes on
x86_64 (184 bytes -> 248 bytes). The size of this struct can be reduced
in future commits by moving TDP MMU root fields into a separate struct
and by dynamically allocating fields only used by the Shadow MMU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm/mmu_types.h |  62 ++++++++++++++
 arch/x86/include/asm/kvm_host.h      |   4 -
 arch/x86/kvm/mmu/mmu.c               | 122 ++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h      |  83 ------------------
 arch/x86/kvm/mmu/mmutrace.h          |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h       |  10 +--
 arch/x86/kvm/mmu/tdp_mmu.c           |   8 +-
 arch/x86/kvm/mmu/tdp_mmu.h           |   2 +-
 include/kvm/mmu_types.h              |  32 ++++++-
 9 files changed, 167 insertions(+), 160 deletions(-)

diff --git a/arch/x86/include/asm/kvm/mmu_types.h b/arch/x86/include/asm/kvm/mmu_types.h
index 35f893ebab5a..affcb520b482 100644
--- a/arch/x86/include/asm/kvm/mmu_types.h
+++ b/arch/x86/include/asm/kvm/mmu_types.h
@@ -2,6 +2,8 @@
 #ifndef __ASM_KVM_MMU_TYPES_H
 #define __ASM_KVM_MMU_TYPES_H
 
+#include <linux/bitmap.h>
+#include <linux/list.h>
 #include <linux/types.h>
 
 /*
@@ -53,4 +55,64 @@ struct kvm_mmu_page_role_arch {
 	u16 passthrough:1;
 };
 
+struct kvm_rmap_head {
+	unsigned long val;
+};
+
+struct kvm_mmu_page_arch {
+	struct hlist_node hash_link;
+
+	bool shadow_mmu_page;
+	bool unsync;
+	u8 mmu_valid_gen;
+
+	 /*
+	  * The shadow page can't be replaced by an equivalent huge page
+	  * because it is being used to map an executable page in the guest
+	  * and the NX huge page mitigation is enabled.
+	  */
+	bool nx_huge_page_disallowed;
+
+	/*
+	 * Stores the result of the guest translation being shadowed by each
+	 * SPTE.  KVM shadows two types of guest translations: nGPA -> GPA
+	 * (shadow EPT/NPT) and GVA -> GPA (traditional shadow paging). In both
+	 * cases the result of the translation is a GPA and a set of access
+	 * constraints.
+	 *
+	 * The GFN is stored in the upper bits (PAGE_SHIFT) and the shadowed
+	 * access permissions are stored in the lower bits. Note, for
+	 * convenience and uniformity across guests, the access permissions are
+	 * stored in KVM format (e.g.  ACC_EXEC_MASK) not the raw guest format.
+	 */
+	u64 *shadowed_translation;
+
+	unsigned int unsync_children;
+
+	/* Rmap pointers to all parent sptes. */
+	struct kvm_rmap_head parent_ptes;
+
+	DECLARE_BITMAP(unsync_child_bitmap, 512);
+
+	/*
+	 * Tracks shadow pages that, if zapped, would allow KVM to create an NX
+	 * huge page.  A shadow page will have nx_huge_page_disallowed set but
+	 * not be on the list if a huge page is disallowed for other reasons,
+	 * e.g. because KVM is shadowing a PTE at the same gfn, the memslot
+	 * isn't properly aligned, etc...
+	 */
+	struct list_head possible_nx_huge_page_link;
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Used out of the mmu-lock to avoid reading spte values while an
+	 * update is in progress; see the comments in __get_spte_lockless().
+	 */
+	int clear_spte_count;
+#endif
+
+	/* Number of writes since the last time traversal visited this page.  */
+	atomic_t write_flooding_count;
+};
+
 #endif /* !__ASM_KVM_MMU_TYPES_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ebcd7a0dabef..f5743a652e10 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -329,10 +329,6 @@ union kvm_cpu_role {
 	};
 };
 
-struct kvm_rmap_head {
-	unsigned long val;
-};
-
 struct kvm_pio_request {
 	unsigned long linear_rip;
 	unsigned long count;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 11cef930d5ed..e47f35878ab5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -350,7 +350,7 @@ static void count_spte_clear(u64 *sptep, u64 spte)
 
 	/* Ensure the spte is completely set before we increase the count */
 	smp_wmb();
-	sp->clear_spte_count++;
+	sp->arch.clear_spte_count++;
 }
 
 static void __set_spte(u64 *sptep, u64 spte)
@@ -432,7 +432,7 @@ static u64 __get_spte_lockless(u64 *sptep)
 	int count;
 
 retry:
-	count = sp->clear_spte_count;
+	count = sp->arch.clear_spte_count;
 	smp_rmb();
 
 	spte.spte_low = orig->spte_low;
@@ -442,7 +442,7 @@ static u64 __get_spte_lockless(u64 *sptep)
 	smp_rmb();
 
 	if (unlikely(spte.spte_low != orig->spte_low ||
-	      count != sp->clear_spte_count))
+	      count != sp->arch.clear_spte_count))
 		goto retry;
 
 	return spte.spte;
@@ -699,7 +699,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 		return sp->gfn;
 
 	if (!sp->role.arch.direct)
-		return sp->shadowed_translation[index] >> PAGE_SHIFT;
+		return sp->arch.shadowed_translation[index] >> PAGE_SHIFT;
 
 	return sp->gfn + (index << ((sp->role.level - 1) * SPTE_LEVEL_BITS));
 }
@@ -713,7 +713,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
 {
 	if (sp_has_gptes(sp))
-		return sp->shadowed_translation[index] & ACC_ALL;
+		return sp->arch.shadowed_translation[index] & ACC_ALL;
 
 	/*
 	 * For direct MMUs (e.g. TDP or non-paging guests) or passthrough SPs,
@@ -734,7 +734,7 @@ static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
 					 gfn_t gfn, unsigned int access)
 {
 	if (sp_has_gptes(sp)) {
-		sp->shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
+		sp->arch.shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
 		return;
 	}
 
@@ -825,18 +825,18 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	 * on the list if KVM is reusing an existing shadow page, i.e. if KVM
 	 * links a shadow page at multiple points.
 	 */
-	if (!list_empty(&sp->possible_nx_huge_page_link))
+	if (!list_empty(&sp->arch.possible_nx_huge_page_link))
 		return;
 
 	++kvm->stat.nx_lpage_splits;
-	list_add_tail(&sp->possible_nx_huge_page_link,
+	list_add_tail(&sp->arch.possible_nx_huge_page_link,
 		      &kvm->arch.possible_nx_huge_pages);
 }
 
 static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 				 bool nx_huge_page_possible)
 {
-	sp->nx_huge_page_disallowed = true;
+	sp->arch.nx_huge_page_disallowed = true;
 
 	if (nx_huge_page_possible)
 		track_possible_nx_huge_page(kvm, sp);
@@ -861,16 +861,16 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	if (list_empty(&sp->possible_nx_huge_page_link))
+	if (list_empty(&sp->arch.possible_nx_huge_page_link))
 		return;
 
 	--kvm->stat.nx_lpage_splits;
-	list_del_init(&sp->possible_nx_huge_page_link);
+	list_del_init(&sp->arch.possible_nx_huge_page_link);
 }
 
 static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	sp->nx_huge_page_disallowed = false;
+	sp->arch.nx_huge_page_disallowed = false;
 
 	untrack_possible_nx_huge_page(kvm, sp);
 }
@@ -1720,11 +1720,11 @@ static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
-	hlist_del(&sp->hash_link);
+	hlist_del(&sp->arch.hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.arch.direct)
-		free_page((unsigned long)sp->shadowed_translation);
+		free_page((unsigned long)sp->arch.shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1739,13 +1739,13 @@ static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 	if (!parent_pte)
 		return;
 
-	pte_list_add(cache, parent_pte, &sp->parent_ptes);
+	pte_list_add(cache, parent_pte, &sp->arch.parent_ptes);
 }
 
 static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 				       u64 *parent_pte)
 {
-	pte_list_remove(parent_pte, &sp->parent_ptes);
+	pte_list_remove(parent_pte, &sp->arch.parent_ptes);
 }
 
 static void drop_parent_pte(struct kvm_mmu_page *sp,
@@ -1761,7 +1761,7 @@ static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 	u64 *sptep;
 	struct rmap_iterator iter;
 
-	for_each_rmap_spte(&sp->parent_ptes, &iter, sptep) {
+	for_each_rmap_spte(&sp->arch.parent_ptes, &iter, sptep) {
 		mark_unsync(sptep);
 	}
 }
@@ -1771,9 +1771,9 @@ static void mark_unsync(u64 *spte)
 	struct kvm_mmu_page *sp;
 
 	sp = sptep_to_sp(spte);
-	if (__test_and_set_bit(spte_index(spte), sp->unsync_child_bitmap))
+	if (__test_and_set_bit(spte_index(spte), sp->arch.unsync_child_bitmap))
 		return;
-	if (sp->unsync_children++)
+	if (sp->arch.unsync_children++)
 		return;
 	kvm_mmu_mark_parents_unsync(sp);
 }
@@ -1799,7 +1799,7 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 {
 	int i;
 
-	if (sp->unsync)
+	if (sp->arch.unsync)
 		for (i=0; i < pvec->nr; i++)
 			if (pvec->page[i].sp == sp)
 				return 0;
@@ -1812,9 +1812,9 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 
 static inline void clear_unsync_child_bit(struct kvm_mmu_page *sp, int idx)
 {
-	--sp->unsync_children;
-	WARN_ON((int)sp->unsync_children < 0);
-	__clear_bit(idx, sp->unsync_child_bitmap);
+	--sp->arch.unsync_children;
+	WARN_ON((int)sp->arch.unsync_children < 0);
+	__clear_bit(idx, sp->arch.unsync_child_bitmap);
 }
 
 static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
@@ -1822,7 +1822,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 {
 	int i, ret, nr_unsync_leaf = 0;
 
-	for_each_set_bit(i, sp->unsync_child_bitmap, 512) {
+	for_each_set_bit(i, sp->arch.unsync_child_bitmap, 512) {
 		struct kvm_mmu_page *child;
 		u64 ent = sp->spt[i];
 
@@ -1833,7 +1833,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 
 		child = spte_to_child_sp(ent);
 
-		if (child->unsync_children) {
+		if (child->arch.unsync_children) {
 			if (mmu_pages_add(pvec, child, i))
 				return -ENOSPC;
 
@@ -1845,7 +1845,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 				nr_unsync_leaf += ret;
 			} else
 				return ret;
-		} else if (child->unsync) {
+		} else if (child->arch.unsync) {
 			nr_unsync_leaf++;
 			if (mmu_pages_add(pvec, child, i))
 				return -ENOSPC;
@@ -1862,7 +1862,7 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
 			   struct kvm_mmu_pages *pvec)
 {
 	pvec->nr = 0;
-	if (!sp->unsync_children)
+	if (!sp->arch.unsync_children)
 		return 0;
 
 	mmu_pages_add(pvec, sp, INVALID_INDEX);
@@ -1871,9 +1871,9 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
 
 static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	WARN_ON(!sp->unsync);
+	WARN_ON(!sp->arch.unsync);
 	trace_kvm_mmu_sync_page(sp);
-	sp->unsync = 0;
+	sp->arch.unsync = 0;
 	--kvm->stat.mmu_unsync;
 }
 
@@ -1894,7 +1894,7 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 }
 
 #define for_each_valid_sp(_kvm, _sp, _list)				\
-	hlist_for_each_entry(_sp, _list, hash_link)			\
+	hlist_for_each_entry(_sp, _list, arch.hash_link)			\
 		if (is_obsolete_sp((_kvm), (_sp))) {			\
 		} else
 
@@ -1934,7 +1934,7 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	/* TDP MMU pages do not use the MMU generation. */
 	return !is_tdp_mmu_page(sp) &&
-	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
+	       unlikely(sp->arch.mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
 
 struct mmu_page_path {
@@ -2006,7 +2006,7 @@ static void mmu_pages_clear_parents(struct mmu_page_path *parents)
 		WARN_ON(idx == INVALID_INDEX);
 		clear_unsync_child_bit(sp, idx);
 		level++;
-	} while (!sp->unsync_children);
+	} while (!sp->arch.unsync_children);
 }
 
 static int mmu_sync_children(struct kvm_vcpu *vcpu,
@@ -2053,7 +2053,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 
 static void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
 {
-	atomic_set(&sp->write_flooding_count,  0);
+	atomic_set(&sp->arch.write_flooding_count,  0);
 }
 
 static void clear_sp_write_flooding_count(u64 *spte)
@@ -2094,7 +2094,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			 * Unsync pages must not be left as is, because the new
 			 * upper-level page will be write-protected.
 			 */
-			if (role.level > PG_LEVEL_4K && sp->unsync)
+			if (role.level > PG_LEVEL_4K && sp->arch.unsync)
 				kvm_mmu_prepare_zap_page(kvm, sp,
 							 &invalid_list);
 			continue;
@@ -2104,7 +2104,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 		if (sp->role.arch.direct)
 			goto out;
 
-		if (sp->unsync) {
+		if (sp->arch.unsync) {
 			if (KVM_BUG_ON(!vcpu, kvm))
 				break;
 
@@ -2163,25 +2163,26 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
 	if (!role.arch.direct)
-		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
+		sp->arch.shadowed_translation =
+			kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
+	INIT_LIST_HEAD(&sp->arch.possible_nx_huge_page_link);
 
 	/*
 	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
 	 * depends on valid pages being added to the head of the list.  See
 	 * comments in kvm_zap_obsolete_pages().
 	 */
-	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+	sp->arch.mmu_valid_gen = kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &kvm->arch.active_mmu_pages);
 	kvm_account_mmu_page(kvm, sp);
 
 	sp->gfn = gfn;
 	sp->role = role;
-	sp->shadow_mmu_page = true;
-	hlist_add_head(&sp->hash_link, sp_list);
+	sp->arch.shadow_mmu_page = true;
+	hlist_add_head(&sp->arch.hash_link, sp_list);
 	if (sp_has_gptes(sp))
 		account_shadowed(kvm, sp);
 
@@ -2368,7 +2369,7 @@ static void __link_shadow_page(struct kvm *kvm,
 
 	mmu_page_add_parent_pte(cache, sp, sptep);
 
-	if (sp->unsync_children || sp->unsync)
+	if (sp->arch.unsync_children || sp->arch.unsync)
 		mark_unsync(sptep);
 }
 
@@ -2421,7 +2422,8 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			 * avoids retaining a large number of stale nested SPs.
 			 */
 			if (tdp_enabled && invalid_list &&
-			    child->role.arch.guest_mode && !child->parent_ptes.val)
+			    child->role.arch.guest_mode &&
+			    !child->arch.parent_ptes.val)
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
@@ -2449,7 +2451,7 @@ static void kvm_mmu_unlink_parents(struct kvm_mmu_page *sp)
 	u64 *sptep;
 	struct rmap_iterator iter;
 
-	while ((sptep = rmap_get_first(&sp->parent_ptes, &iter)))
+	while ((sptep = rmap_get_first(&sp->arch.parent_ptes, &iter)))
 		drop_parent_pte(sp, sptep);
 }
 
@@ -2496,7 +2498,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	if (!sp->role.invalid && sp_has_gptes(sp))
 		unaccount_shadowed(kvm, sp);
 
-	if (sp->unsync)
+	if (sp->arch.unsync)
 		kvm_unlink_unsync_page(kvm, sp);
 	if (!refcount_read(&sp->root_refcount)) {
 		/* Count self */
@@ -2527,7 +2529,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 		zapped_root = !is_obsolete_sp(kvm, sp);
 	}
 
-	if (sp->nx_huge_page_disallowed)
+	if (sp->arch.nx_huge_page_disallowed)
 		unaccount_nx_huge_page(kvm, sp);
 
 	sp->role.invalid = 1;
@@ -2704,7 +2706,7 @@ static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	trace_kvm_mmu_unsync_page(sp);
 	++kvm->stat.mmu_unsync;
-	sp->unsync = 1;
+	sp->arch.unsync = 1;
 
 	kvm_mmu_mark_parents_unsync(sp);
 }
@@ -2739,7 +2741,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 		if (!can_unsync)
 			return -EPERM;
 
-		if (sp->unsync)
+		if (sp->arch.unsync)
 			continue;
 
 		if (prefetch)
@@ -2764,7 +2766,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 			 * for write, i.e. unsync cannot transition from 0->1
 			 * while this CPU holds mmu_lock for read (or write).
 			 */
-			if (READ_ONCE(sp->unsync))
+			if (READ_ONCE(sp->arch.unsync))
 				continue;
 		}
 
@@ -2796,8 +2798,8 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 *                      2.2 Guest issues TLB flush.
 	 *                          That causes a VM Exit.
 	 *
-	 *                      2.3 Walking of unsync pages sees sp->unsync is
-	 *                          false and skips the page.
+	 *                      2.3 Walking of unsync pages sees sp->arch.unsync
+	 *                          is false and skips the page.
 	 *
 	 *                      2.4 Guest accesses GVA X.
 	 *                          Since the mapping in the SP was not updated,
@@ -2805,7 +2807,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 *                          gets used.
 	 * 1.1 Host marks SP
 	 *     as unsync
-	 *     (sp->unsync = true)
+	 *     (sp->arch.unsync = true)
 	 *
 	 * The write barrier below ensures that 1.1 happens before 1.2 and thus
 	 * the situation in 2.4 does not arise.  It pairs with the read barrier
@@ -3126,7 +3128,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte) &&
-	    spte_to_child_sp(spte)->nx_huge_page_disallowed) {
+	    spte_to_child_sp(spte)->arch.nx_huge_page_disallowed) {
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch),
 		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
@@ -3902,7 +3904,7 @@ static bool is_unsync_root(hpa_t root)
 
 	/*
 	 * The read barrier orders the CPU's read of SPTE.W during the page table
-	 * walk before the reads of sp->unsync/sp->unsync_children here.
+	 * walk before the reads of sp->arch.{unsync,unsync_children} here.
 	 *
 	 * Even if another CPU was marking the SP as unsync-ed simultaneously,
 	 * any guest page table changes are not guaranteed to be visible anyway
@@ -3922,7 +3924,7 @@ static bool is_unsync_root(hpa_t root)
 	if (WARN_ON_ONCE(!sp))
 		return false;
 
-	if (sp->unsync || sp->unsync_children)
+	if (sp->arch.unsync || sp->arch.unsync_children)
 		return true;
 
 	return false;
@@ -5510,8 +5512,8 @@ static bool detect_write_flooding(struct kvm_mmu_page *sp)
 	if (sp->role.level == PG_LEVEL_4K)
 		return false;
 
-	atomic_inc(&sp->write_flooding_count);
-	return atomic_read(&sp->write_flooding_count) >= 3;
+	atomic_inc(&sp->arch.write_flooding_count);
+	return atomic_read(&sp->arch.write_flooding_count) >= 3;
 }
 
 /*
@@ -6389,7 +6391,7 @@ static bool shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 			continue;
 
 		/* SPs with level >PG_LEVEL_4K should never by unsync. */
-		if (WARN_ON_ONCE(sp->unsync))
+		if (WARN_ON_ONCE(sp->arch.unsync))
 			continue;
 
 		/* Don't bother splitting huge pages on invalid SPs. */
@@ -6941,8 +6943,8 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		 */
 		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
 				      struct kvm_mmu_page,
-				      possible_nx_huge_page_link);
-		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
+				      arch.possible_nx_huge_page_link);
+		WARN_ON_ONCE(!sp->arch.nx_huge_page_disallowed);
 		WARN_ON_ONCE(!sp->role.arch.direct);
 
 		/*
@@ -6977,7 +6979,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		else
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
+		WARN_ON_ONCE(sp->arch.nx_huge_page_disallowed);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index fd4990c8b0e9..af2ae4887e35 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -44,89 +44,6 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
-struct kvm_mmu_page {
-	/*
-	 * Note, "link" through "spt" fit in a single 64 byte cache line on
-	 * 64-bit kernels, keep it that way unless there's a reason not to.
-	 */
-	struct list_head link;
-	struct hlist_node hash_link;
-
-	bool shadow_mmu_page;
-	bool unsync;
-	u8 mmu_valid_gen;
-
-	 /*
-	  * The shadow page can't be replaced by an equivalent huge page
-	  * because it is being used to map an executable page in the guest
-	  * and the NX huge page mitigation is enabled.
-	  */
-	bool nx_huge_page_disallowed;
-
-	/*
-	 * The following two entries are used to key the shadow page in the
-	 * hash table.
-	 */
-	union kvm_mmu_page_role role;
-	gfn_t gfn;
-
-	u64 *spt;
-
-	/*
-	 * Stores the result of the guest translation being shadowed by each
-	 * SPTE.  KVM shadows two types of guest translations: nGPA -> GPA
-	 * (shadow EPT/NPT) and GVA -> GPA (traditional shadow paging). In both
-	 * cases the result of the translation is a GPA and a set of access
-	 * constraints.
-	 *
-	 * The GFN is stored in the upper bits (PAGE_SHIFT) and the shadowed
-	 * access permissions are stored in the lower bits. Note, for
-	 * convenience and uniformity across guests, the access permissions are
-	 * stored in KVM format (e.g.  ACC_EXEC_MASK) not the raw guest format.
-	 */
-	u64 *shadowed_translation;
-
-	/* Currently serving as active root */
-	refcount_t root_refcount;
-
-	unsigned int unsync_children;
-	union {
-		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
-		tdp_ptep_t ptep;
-	};
-	union {
-		DECLARE_BITMAP(unsync_child_bitmap, 512);
-		struct {
-			struct work_struct tdp_mmu_async_work;
-			void *tdp_mmu_async_data;
-		};
-	};
-
-	/*
-	 * Tracks shadow pages that, if zapped, would allow KVM to create an NX
-	 * huge page.  A shadow page will have nx_huge_page_disallowed set but
-	 * not be on the list if a huge page is disallowed for other reasons,
-	 * e.g. because KVM is shadowing a PTE at the same gfn, the memslot
-	 * isn't properly aligned, etc...
-	 */
-	struct list_head possible_nx_huge_page_link;
-#ifdef CONFIG_X86_32
-	/*
-	 * Used out of the mmu-lock to avoid reading spte values while an
-	 * update is in progress; see the comments in __get_spte_lockless().
-	 */
-	int clear_spte_count;
-#endif
-
-	/* Number of writes since the last time traversal visited this page.  */
-	atomic_t write_flooding_count;
-
-#ifdef CONFIG_X86_64
-	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
-	struct rcu_head rcu_head;
-#endif
-};
-
 extern struct kmem_cache *mmu_page_header_cache;
 
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index ffd10ce3eae3..335f26dabdf3 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -16,11 +16,11 @@
 	__field(bool, unsync)
 
 #define KVM_MMU_PAGE_ASSIGN(sp)				\
-	__entry->mmu_valid_gen = sp->mmu_valid_gen;	\
+	__entry->mmu_valid_gen = sp->arch.mmu_valid_gen;	\
 	__entry->gfn = sp->gfn;				\
 	__entry->role = sp->role.word;			\
 	__entry->root_count = refcount_read(&sp->root_refcount);	\
-	__entry->unsync = sp->unsync;
+	__entry->unsync = sp->arch.unsync;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
 	const char *saved_ptr = trace_seq_buffer_ptr(p);		\
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e15ec1c473da..18bb92b70a01 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -671,7 +671,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			 * KVM_REQ_MMU_SYNC is not necessary but it
 			 * expedites the process.
 			 */
-			if (sp->unsync_children &&
+			if (sp->arch.unsync_children &&
 			    mmu_sync_children(vcpu, sp, false))
 				return RET_PF_RETRY;
 		}
@@ -921,7 +921,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			pt_element_t gpte;
 			gpa_t pte_gpa;
 
-			if (!sp->unsync)
+			if (!sp->arch.unsync)
 				break;
 
 			pte_gpa = FNAME(get_level1_sp_gpa)(sp);
@@ -942,7 +942,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			FNAME(prefetch_gpte)(vcpu, sp, sptep, gpte, false);
 		}
 
-		if (!sp->unsync_children)
+		if (!sp->arch.unsync_children)
 			break;
 	}
 	write_unlock(&vcpu->kvm->mmu_lock);
@@ -974,8 +974,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 
 /*
- * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()) is
- * safe because:
+ * Using the information in sp->arch.shadowed_translation
+ * (kvm_mmu_page_get_gfn()) is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
  *
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 34d674080170..66231c7ed31e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -270,7 +270,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 			    gfn_t gfn, union kvm_mmu_page_role role)
 {
-	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
+	INIT_LIST_HEAD(&sp->arch.possible_nx_huge_page_link);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -385,7 +385,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 {
 	tdp_unaccount_mmu_page(kvm, sp);
 
-	if (!sp->nx_huge_page_disallowed)
+	if (!sp->arch.nx_huge_page_disallowed)
 		return;
 
 	if (shared)
@@ -393,7 +393,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
-	sp->nx_huge_page_disallowed = false;
+	sp->arch.nx_huge_page_disallowed = false;
 	untrack_possible_nx_huge_page(kvm, sp);
 
 	if (shared)
@@ -1181,7 +1181,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		sp = tdp_mmu_alloc_sp(vcpu);
 		tdp_mmu_init_child_sp(sp, &iter);
 
-		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
+		sp->arch.nx_huge_page_disallowed = fault->huge_page_disallowed;
 
 		if (is_shadow_present_pte(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 19d3153051a3..e6a929089715 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -73,7 +73,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 #ifdef CONFIG_X86_64
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp)
 {
-	return !sp->shadow_mmu_page;
+	return !sp->arch.shadow_mmu_page;
 }
 #else
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
index 14099956fdac..a9da33d4baa8 100644
--- a/include/kvm/mmu_types.h
+++ b/include/kvm/mmu_types.h
@@ -3,8 +3,11 @@
 #define __KVM_MMU_TYPES_H
 
 #include <linux/bug.h>
-#include <linux/types.h>
+#include <linux/kvm_types.h>
+#include <linux/refcount.h>
 #include <linux/stddef.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
 
 #include <asm/kvm/mmu_types.h>
 
@@ -36,4 +39,31 @@ static_assert(sizeof(union kvm_mmu_page_role) == sizeof_field(union kvm_mmu_page
 
 typedef u64 __rcu *tdp_ptep_t;
 
+struct kvm_mmu_page {
+	struct list_head link;
+
+	union kvm_mmu_page_role role;
+
+	/* The start of the GFN region mapped by this shadow page. */
+	gfn_t gfn;
+
+	/* The page table page. */
+	u64 *spt;
+
+	/* The PTE that points to this shadow page. */
+	tdp_ptep_t ptep;
+
+	/* Used for freeing TDP MMU pages asynchronously. */
+	struct rcu_head rcu_head;
+
+	/* The number of references to this shadow page as a root. */
+	refcount_t root_refcount;
+
+	/* Used for tearing down an entire page table tree. */
+	struct work_struct tdp_mmu_async_work;
+	void *tdp_mmu_async_data;
+
+	struct kvm_mmu_page_arch arch;
+};
+
 #endif /* !__KVM_MMU_TYPES_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

