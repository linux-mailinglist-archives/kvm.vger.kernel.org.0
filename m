Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7257457EB0D
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbiGWBXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiGWBXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:23:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A8072EC4
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c12-20020a17090a8d0c00b001f20d603777so5045631pjo.4
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ExoXZvGRshft7N9/0/R2vsQcznqHDRAkfUEj9JdqFvk=;
        b=g1MUmSWG+f7m2392BXNfNph6hfSgIddkGENbhq4kqjuOVMn1iYbQDLrfW8AL/mzRmg
         Omwh7Nd5OPJCHDztI6W9QsdMrosL0OhwsZbCuS2Oyt7ywvAutjZgv02Lt6prKhqYXVsc
         Awaz0qDZbCLUSSL30aIiMo+3UjBGd9lXQiCGaq/b7cWruIpwVC6kBmJoRSKhmozkv1Gs
         pE9n6ss1jV8MbG2DlnuXLdYEJu36xnvtAePYV23PIjhG9ERa49+DmlXCiRiDqAgOq0tg
         e7tqxQAH7Vde9U0Fa0Javf0TgE2wjCgiCdnK4n/HoWylouj+Fv5Xv2d22wfnhPg56e7G
         CoTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ExoXZvGRshft7N9/0/R2vsQcznqHDRAkfUEj9JdqFvk=;
        b=BeA8VQk3YWzjZsvrIFNBbYx5BDiZaGPXZb3G7/cexGg3S/90zNlxR6zaeMHnsQxsY2
         F3kyMKTggJsghlL8nh+Oa9WoHJsWLcH2NgZTiZd5dwcXrXzmN5LscvWwjSW2UBYew+oT
         G9GQa8oZQ/yjDZEpzGA20v5GfwrKL9SVVVitqDbfCNMhch7weKKSIqDpnq+yGhnUZhQl
         vQH+khi+ZouZV2PibIVl/bXnGEY6W/Kl7+EswOTrZMeanf6fGXqS8QF/DKM6reNEmQrv
         /E0ElFdhfGykdUVtuaFZkdLIye2U6h5pGERdDg1oLvS21GK+Vt8Ntj8w3st/Bo6qZLS5
         YbgA==
X-Gm-Message-State: AJIora+GQlpmbYUV8cMklM+2dCTcpBm+JCwbca8vB6GPdNFSdoqmE5AP
        BKJDTnrkO44gkAoCyQmsSc6YSDZ00+k=
X-Google-Smtp-Source: AGRyM1uHvwJ2Ty2xhDBseM+YK17WRf4Z8roPfJ0wf7Tl9rBKQ0Dp1darR8hfiJqDItj49WHXTWfUxzHxQz0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e841:b0:16c:3053:c7e6 with SMTP id
 t1-20020a170902e84100b0016c3053c7e6mr2110080plg.163.1658539415931; Fri, 22
 Jul 2022 18:23:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 01:23:22 +0000
In-Reply-To: <20220723012325.1715714-1-seanjc@google.com>
Message-Id: <20220723012325.1715714-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 3/6] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU
 before setting SPTE
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set nx_huge_page_disallowed in TDP MMU shadow pages before making the SP
visible to other readers, i.e. before setting its SPTE.  This will allow
KVM to query the flag when determining if a shadow page can be replaced
by a NX huge page without violating the rules of the mitigation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 12 +++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  5 ++---
 arch/x86/kvm/mmu/tdp_mmu.c      | 30 +++++++++++++++++-------------
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 493cdf1c29ff..e9252e7cd5a2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -802,8 +802,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
-static void untrack_possible_nx_huge_page(struct kvm *kvm,
-					  struct kvm_mmu_page *sp)
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (list_empty(&sp->possible_nx_huge_page_link))
 		return;
@@ -812,15 +811,14 @@ static void untrack_possible_nx_huge_page(struct kvm *kvm,
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
-void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	sp->nx_huge_page_disallowed = false;
 
 	untrack_possible_nx_huge_page(kvm, sp);
 }
 
-static void track_possible_nx_huge_page(struct kvm *kvm,
-					struct kvm_mmu_page *sp)
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (!list_empty(&sp->possible_nx_huge_page_link))
 		return;
@@ -830,8 +828,8 @@ static void track_possible_nx_huge_page(struct kvm *kvm,
 		      &kvm->arch.possible_nx_huge_pages);
 }
 
-void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			  bool nx_huge_page_possible)
+static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				 bool nx_huge_page_possible)
 {
 	sp->nx_huge_page_disallowed = true;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 83644a0167ab..2a887d08b722 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -336,8 +336,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
-void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			  bool nx_huge_page_possible);
-void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a30983947fee..626c40ec2af9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -392,8 +392,10 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_del(&sp->link);
-	if (sp->nx_huge_page_disallowed)
-		unaccount_nx_huge_page(kvm, sp);
+	if (sp->nx_huge_page_disallowed) {
+		sp->nx_huge_page_disallowed = false;
+		untrack_possible_nx_huge_page(kvm, sp);
+	}
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1111,16 +1113,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
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
@@ -1135,8 +1134,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	if (account_nx)
-		account_nx_huge_page(kvm, sp, true);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 	return 0;
@@ -1149,6 +1146,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret;
@@ -1185,9 +1183,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-			bool account_nx = fault->huge_page_disallowed &&
-					  fault->req_level >= iter.level;
-
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -1199,10 +1194,19 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			sp = tdp_mmu_alloc_sp(vcpu);
 			tdp_mmu_init_child_sp(sp, &iter);
 
-			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
+			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
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
 
@@ -1490,7 +1494,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * correctness standpoint since the translation will be the same either
 	 * way.
 	 */
-	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
+	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
 	if (ret)
 		goto out;
 
-- 
2.37.1.359.gd136c6c3e2-goog

