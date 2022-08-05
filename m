Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F6D58B29B
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 01:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241542AbiHEXFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 19:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241558AbiHEXFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 19:05:32 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDD91D32C
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 16:05:29 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y207-20020a6264d8000000b0052d4a912cddso1778656pfb.15
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 16:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=OW9TQ+LIu6gItsbFLVpaBRe5T84EmDWNHujqjldprDw=;
        b=SgOShPtcsyD6DJfgAOln2HyXTBcVLdGwM0h3i6vA6Gfdh/CuyKzeT5MtWB7WsXZCfj
         AvoOw031s2l0qlb370kwpA+z8zRJInInIYnoAoIE6H4SNfjOFAzO4NOs9dwag16kNXEt
         ebBCtMGitxbO2xvtwAf0NTXJ+Io/Aw63CGUAxo7SOOIcxRzSQtt0QLUVPEm3b8eRuInT
         z8BG4VEXuGkiosxmGxt3F9db/xpg4xwIpmpsYJh8X1bhxvP9i1FS0p8xl/+Lg2B7SlEY
         pZwbG2+KP5al+yYRD1DQBtCVn7emmbd+Dzs/QWBm6ndxfv/Q82UEFK66xc8zEWCsLAlS
         hHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=OW9TQ+LIu6gItsbFLVpaBRe5T84EmDWNHujqjldprDw=;
        b=3c4OUwXy3kEPyPuuZX29017KXow3E0mzuL4Om9zw6EF14TCVu+zWxwV5ah9pkgP6Sp
         Gf7ymbTI3I1wUlDR0wp8ycxxN3eyU/+Ut0iqV5SyAZbT5Z7ZMwATpnYlb73RJmrIgaeh
         Rctk5A0jMN9kKXmKPe6rFBayoNIq9QklDzVwvN8chxbFLrU1kT3zI1uXcBnP09htsFBd
         25M9qsxx+WNUNYDlBdGZuE70r4Y46SI+C73ZkQFMAuQEm/FBFwpjBJ8lIW0T0MLFb4yU
         1ce51Kp65CHr8bwTp+e8g0/xqc0diUk7DN+W1gwmVjTBZ5yBwNrmlzdNFVArZ6BUjHVC
         MY+A==
X-Gm-Message-State: ACgBeo1h4OpEWCWLEOdWSNj0eG+XNHe2xg7GTZ/b97rIYT6MYtt+0USf
        0/3ywXdRjXv1xb8DrsqWHZkqjpms8VE=
X-Google-Smtp-Source: AA6agR5OZjOLPpfT49XnSCfB9PI/nziY6RyBZB6mzyD88PBYt0wT22mMnzb6fjVe62SAqPSzm+pNkSlzkGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8049:0:b0:41b:e8db:d912 with SMTP id
 j70-20020a638049000000b0041be8dbd912mr7233418pgd.380.1659740728787; Fri, 05
 Aug 2022 16:05:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 23:05:10 +0000
In-Reply-To: <20220805230513.148869-1-seanjc@google.com>
Message-Id: <20220805230513.148869-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220805230513.148869-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 5/8] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU
 before setting SPTE
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set nx_huge_page_disallowed in TDP MMU shadow pages before making the SP
visible to other readers, i.e. before setting its SPTE.  This will allow
KVM to query the flag when determining if a shadow page can be replaced
by a NX huge page without violating the rules of the mitigation.

Note, the shadow/legacy MMU holds mmu_lock for write, so it's impossible
for another CPU to see a shadow page without an up-to-date
nx_huge_page_disallowed, i.e. only the TDP MMU needs the complicated
dance.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 28 +++++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  5 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      | 46 +++++++++++++++++++++++----------
 3 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 345b6b22ab68..f81ddedbe2f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -802,22 +802,25 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
-void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			  bool nx_huge_page_possible)
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (KVM_BUG_ON(!list_empty(&sp->possible_nx_huge_page_link), kvm))
 		return;
 
-	sp->nx_huge_page_disallowed = true;
-
-	if (!nx_huge_page_possible)
-		return;
-
 	++kvm->stat.nx_lpage_splits;
 	list_add_tail(&sp->possible_nx_huge_page_link,
 		      &kvm->arch.possible_nx_huge_pages);
 }
 
+static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				 bool nx_huge_page_possible)
+{
+	sp->nx_huge_page_disallowed = true;
+
+	if (nx_huge_page_possible)
+		track_possible_nx_huge_page(kvm, sp);
+}
+
 static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	struct kvm_memslots *slots;
@@ -835,10 +838,8 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	sp->nx_huge_page_disallowed = false;
-
 	if (list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
@@ -846,6 +847,13 @@ void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
+static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	sp->nx_huge_page_disallowed = false;
+
+	untrack_possible_nx_huge_page(kvm, sp);
+}
+
 static struct kvm_memory_slot *
 gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    bool no_dirty_log)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 67879459a25c..22152241bd29 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -328,8 +328,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
-void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			  bool nx_huge_page_possible);
-void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0e94182c87be..34994ca3d45b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -392,8 +392,19 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_del(&sp->link);
-	if (sp->nx_huge_page_disallowed)
-		unaccount_nx_huge_page(kvm, sp);
+
+	/*
+	 * Ensure nx_huge_page_disallowed is read after observing the present
+	 * shadow page.  A different vCPU may have _just_ finished installing
+	 * the shadow page if mmu_lock is held for read.  Pairs with the
+	 * smp_wmb() in kvm_tdp_mmu_map().
+	 */
+	smp_rmb();
+
+	if (sp->nx_huge_page_disallowed) {
+		sp->nx_huge_page_disallowed = false;
+		untrack_possible_nx_huge_page(kvm, sp);
+	}
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1107,16 +1118,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @sp: The new TDP page table to install.
- * @account_nx: True if this page table is being installed to split a
- *              non-executable huge page.
  * @shared: This operation is running under the MMU lock in read mode.
  *
  * Returns: 0 if the new page table was installed. Non-0 if the page table
  *          could not be installed (e.g. the atomic compare-exchange failed).
  */
 static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
-			   struct kvm_mmu_page *sp, bool account_nx,
-			   bool shared)
+			   struct kvm_mmu_page *sp, bool shared)
 {
 	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
 	int ret = 0;
@@ -1131,8 +1139,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	if (account_nx)
-		account_nx_huge_page(kvm, sp, true);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 	return 0;
@@ -1145,6 +1151,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret;
@@ -1181,9 +1188,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-			bool account_nx = fault->huge_page_disallowed &&
-					  fault->req_level >= iter.level;
-
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -1195,10 +1199,26 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			sp = tdp_mmu_alloc_sp(vcpu);
 			tdp_mmu_init_child_sp(sp, &iter);
 
-			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
+			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
+
+			/*
+			 * Ensure nx_huge_page_disallowed is visible before the
+			 * SP is marked present, as mmu_lock is held for read.
+			 * Pairs with the smp_rmb() in tdp_mmu_unlink_sp().
+			 */
+			smp_wmb();
+
+			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
 				tdp_mmu_free_sp(sp);
 				break;
 			}
+
+			if (fault->huge_page_disallowed &&
+			    fault->req_level >= iter.level) {
+				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+				track_possible_nx_huge_page(kvm, sp);
+				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+			}
 		}
 	}
 
@@ -1486,7 +1506,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * correctness standpoint since the translation will be the same either
 	 * way.
 	 */
-	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
+	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
 	if (ret)
 		goto out;
 
-- 
2.37.1.559.g78731f0fdb-goog

