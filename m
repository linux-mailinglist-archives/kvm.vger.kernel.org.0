Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DB657EB0A
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiGWBXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiGWBXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:23:33 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0536717F
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:32 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 134-20020a63018c000000b0040cf04213a1so3027102pgb.6
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JFWClFFZ6i0uApbGDS7dRt7zoDBAj/qGZuamUz2KkEU=;
        b=PXCgqnxNGuq1FULrDW8Hk5uuXzTT16D68a8q6eMLQ7qvZAHvhXyZZqmmHpYxiMFcq1
         zuSf6IqoaK6/pNS4FP0ANvZ1Z24Gdjr7ZZtkNyPeXrWAwbhgcJ/K0BVlmJc5dIf1iqTj
         YSydghR3Jw60Z1qGCumz/usvlweLc82eQL94EIHnavE9iEIzX36YZ6F68eLdPv2CZwNU
         js2LhC06/m2fEATaAGw46LzhBC5+DibN4SfjGlg3uxEg5vUwNPyXPNtZDAHkMQIevokQ
         NT7Qjh4iACUavOciN/PsNF1c325JH800voyDwAsS8YL6wHfCJEsTm/Bm0jsXipSBIg/y
         1wZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JFWClFFZ6i0uApbGDS7dRt7zoDBAj/qGZuamUz2KkEU=;
        b=2db2spkBpHqhfOilMay5zIKPuxigHeO50WTLAZY0jhszqqd0fge2/2+A08bgXIwRJe
         uYHsL8uEMJwZxz4hwDna9RADCUkQqMDcKPeq74Epe70+H3Mi3iIXyXRa88RYQNpK1S9u
         aDEE0YG8cB88zwAlIypsKwIpRVtEHfScLR2EQG2QJq1GA52mGg2cp+Lshx4hY++ZX5PU
         +24FC+TzI8OLmzGp1Io0ZzmOCds9N2z9qwrfX1ANffcS1gNhJT6jM65cIOsloXkWASf0
         5uEj7THCNVBdM9nwZZ9zD1KL+vNNL/4dt933X6i48i+B3zPuUDdFuvwqLTdAZultkmur
         8Eaw==
X-Gm-Message-State: AJIora966Qq0M3RMBgqvQvqt83CzFPSq3kWujX4apLHMavYFIIA5wGYh
        OnBoFZYy3YiK6eVdlQBXz8CaZ8zHBtA=
X-Google-Smtp-Source: AGRyM1swJaIsO00mH97rvLnUMikQ8FpxjCFjLuxyQ6Tqd4vJnPFY/p5Vv0bx7YCQDZwIvB36m77QIH+73Mg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce81:b0:16d:4376:3101 with SMTP id
 f1-20020a170902ce8100b0016d43763101mr2474282plg.85.1658539412169; Fri, 22 Jul
 2022 18:23:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 01:23:20 +0000
In-Reply-To: <20220723012325.1715714-1-seanjc@google.com>
Message-Id: <20220723012325.1715714-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 1/6] KVM: x86/mmu: Tag disallowed NX huge pages even if
 they're not tracked
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
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

Tag shadow pages that cannot be replaced with an NX huge page even if
zapping the page would not allow KVM to create a huge page, e.g. because
something else prevents creating a huge page.  This will allow a future
patch to more precisely apply the mitigation by checking if an existing
shadow page can be replaced by a NX huge page.  Currently, KVM assumes
that any existing shadow page encountered cannot be replaced by a NX huge
page (if the mitigation is enabled), which prevents KVM from replacing
no-longer-necessary shadow pages with huge pages, e.g. after disabling
dirty logging, zapping from the mmu_notifier due to page migration,
etc...

Failure to tag shadow pages appropriately could theoretically lead to
false negatives, e.g. if a fetch fault requests a small page and thus
isn't tracked, and a read/write fault later requests a huge page, KVM
will not reject the huge page as it should.

To avoid yet another flag, initialize the list_head and use list_empty()
to determine whether or not a page is on the list of NX huge pages that
should be recovered.

Opportunstically rename most of the variables/functions involved to
provide consistency, e.g. lpage vs huge page and NX huge vs huge NX, and
clarity, e.g. to make it obvious the flag applies only to the NX huge
page mitigation, not to any condition that prevents creating a huge page.

Fixes: 5bcaf3e1715f ("KVM: x86/mmu: Account NX huge page disallowed iff huge page was requested")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +--
 arch/x86/kvm/mmu/mmu.c          | 75 ++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/mmu_internal.h | 22 ++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +--
 arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++--
 5 files changed, 79 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8281d64a431..246b69262b93 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1143,7 +1143,7 @@ struct kvm_arch {
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
-	struct list_head lpage_disallowed_mmu_pages;
+	struct list_head possible_nx_huge_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
 	/*
@@ -1304,8 +1304,8 @@ struct kvm_arch {
 	 *  - tdp_mmu_roots (above)
 	 *  - tdp_mmu_pages (above)
 	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
-	 *  - lpage_disallowed_mmu_pages
-	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
+	 *  - possible_nx_huge_pages;
+	 *  - the possible_nx_huge_page_link field of struct kvm_mmu_pages used
 	 *    by the TDP MMU
 	 * It is acceptable, but not necessary, to acquire this lock when
 	 * the thread holds the MMU lock in write mode.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e477333a263..1112e3a4cf3e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -802,15 +802,43 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void untrack_possible_nx_huge_page(struct kvm *kvm,
+					  struct kvm_mmu_page *sp)
 {
-	if (sp->lpage_disallowed)
+	if (list_empty(&sp->possible_nx_huge_page_link))
+		return;
+
+	--kvm->stat.nx_lpage_splits;
+	list_del_init(&sp->possible_nx_huge_page_link);
+}
+
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	sp->nx_huge_page_disallowed = false;
+
+	untrack_possible_nx_huge_page(kvm, sp);
+}
+
+static void track_possible_nx_huge_page(struct kvm *kvm,
+					struct kvm_mmu_page *sp)
+{
+	if (!list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
 	++kvm->stat.nx_lpage_splits;
-	list_add_tail(&sp->lpage_disallowed_link,
-		      &kvm->arch.lpage_disallowed_mmu_pages);
-	sp->lpage_disallowed = true;
+	list_add_tail(&sp->possible_nx_huge_page_link,
+		      &kvm->arch.possible_nx_huge_pages);
+}
+
+void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			  bool nx_huge_page_possible)
+{
+	sp->nx_huge_page_disallowed = true;
+
+	if (!nx_huge_page_possible)
+		untrack_possible_nx_huge_page(kvm, sp);
+	else
+		track_possible_nx_huge_page(kvm, sp);
 }
 
 static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -830,13 +858,6 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	--kvm->stat.nx_lpage_splits;
-	sp->lpage_disallowed = false;
-	list_del(&sp->lpage_disallowed_link);
-}
-
 static struct kvm_memory_slot *
 gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    bool no_dirty_log)
@@ -2115,6 +2136,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
+	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
+
 	/*
 	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
 	 * depends on valid pages being added to the head of the list.  See
@@ -2472,8 +2495,8 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 		zapped_root = !is_obsolete_sp(kvm, sp);
 	}
 
-	if (sp->lpage_disallowed)
-		unaccount_huge_nx_page(kvm, sp);
+	if (sp->nx_huge_page_disallowed)
+		unaccount_nx_huge_page(kvm, sp);
 
 	sp->role.invalid = 1;
 
@@ -3112,9 +3135,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->is_tdp && fault->huge_page_disallowed &&
-		    fault->req_level >= it.level)
-			account_huge_nx_page(vcpu->kvm, sp);
+		if (fault->is_tdp && fault->huge_page_disallowed)
+			account_nx_huge_page(vcpu->kvm, sp,
+					     fault->req_level >= it.level);
 	}
 
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
@@ -5970,7 +5993,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
-	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
 	r = kvm_mmu_init_tdp_mmu(kvm);
@@ -6845,23 +6868,25 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
 	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
-		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
+		if (list_empty(&kvm->arch.possible_nx_huge_pages))
 			break;
 
 		/*
 		 * We use a separate list instead of just using active_mmu_pages
-		 * because the number of lpage_disallowed pages is expected to
-		 * be relatively small compared to the total.
+		 * because the number of shadow pages that be replaced with an
+		 * NX huge page is expected to be relatively small compared to
+		 * the total number of shadow pages.  And because the TDP MMU
+		 * doesn't use active_mmu_pages.
 		 */
-		sp = list_first_entry(&kvm->arch.lpage_disallowed_mmu_pages,
+		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
 				      struct kvm_mmu_page,
-				      lpage_disallowed_link);
-		WARN_ON_ONCE(!sp->lpage_disallowed);
+				      possible_nx_huge_page_link);
+		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
 		if (is_tdp_mmu_page(sp)) {
 			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-			WARN_ON_ONCE(sp->lpage_disallowed);
+			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
 		}
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 582def531d4d..ff4ca54b9dda 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -57,7 +57,13 @@ struct kvm_mmu_page {
 	bool tdp_mmu_page;
 	bool unsync;
 	u8 mmu_valid_gen;
-	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
+
+	 /*
+	  * The shadow page can't be replaced by an equivalent huge page
+	  * because it is being used to map an executable page in the guest
+	  * and the NX huge page mitigation is enabled.
+	  */
+	bool nx_huge_page_disallowed;
 
 	/*
 	 * The following two entries are used to key the shadow page in the
@@ -100,7 +106,14 @@ struct kvm_mmu_page {
 		};
 	};
 
-	struct list_head lpage_disallowed_link;
+	/*
+	 * Use to track shadow pages that, if zapped, would allow KVM to create
+	 * an NX huge page.  A shadow page will have nx_huge_page_disallowed
+	 * set but not be on the list if a huge page is disallowed for other
+	 * reasons, e.g. because KVM is shadowing a PTE at the same gfn, the
+	 * memslot isn't properly aligned, etc...
+	 */
+	struct list_head possible_nx_huge_page_link;
 #ifdef CONFIG_X86_32
 	/*
 	 * Used out of the mmu-lock to avoid reading spte values while an
@@ -315,7 +328,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
-void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			  bool nx_huge_page_possible);
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f5958071220c..259c0f019f09 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -713,9 +713,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->huge_page_disallowed &&
-		    fault->req_level >= it.level)
-			account_huge_nx_page(vcpu->kvm, sp);
+		if (fault->huge_page_disallowed)
+			account_nx_huge_page(vcpu->kvm, sp,
+					     fault->req_level >= it.level);
 	}
 
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 40ccb5fba870..a30983947fee 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -284,6 +284,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 			    gfn_t gfn, union kvm_mmu_page_role role)
 {
+	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
+
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	sp->role = role;
@@ -390,8 +392,8 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_del(&sp->link);
-	if (sp->lpage_disallowed)
-		unaccount_huge_nx_page(kvm, sp);
+	if (sp->nx_huge_page_disallowed)
+		unaccount_nx_huge_page(kvm, sp);
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1134,7 +1136,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
 	if (account_nx)
-		account_huge_nx_page(kvm, sp);
+		account_nx_huge_page(kvm, sp, true);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 	return 0;
-- 
2.37.1.359.gd136c6c3e2-goog

