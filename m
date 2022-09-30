Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDAF5F16D9
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiI3XtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiI3XtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:49:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DD01A88F4
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:49:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id o1-20020a170902d4c100b00177f59a9889so4143906plg.13
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=dIkus8SgdqkYMrXyhSaL0jYmwmqz8zPjRcNlpBWOB98=;
        b=jJQNjwZ3afas5q8qAA1hh7Cdeea4PRnmbcXEO9BxaCBLxc6swG5DFVNS6lSgcZh0B1
         q0FkZxInxLbuQYEOuxhu+MbHod9YDKMk4rzQSgBGTWQCzxa4OJRTZVLm55cQWQW7oAQD
         03Nn/BJjcZW0CqLmHStxhwQdL83MCoyk7wEGQL0hw/dTIRGaArsqc60LZsJQ8sTlwAaW
         aIVOMLl8dbasQp4EQQnyzWwGx3mhrJ8qiH+BLdgPSpoaXIKjbKt2l1RYzsb0sBNQiSvU
         LhCgVVKhOAH0UZbHeld1GN1ye/qLrbdkTV0SWQyDhes+Kz5o7A6o4+AVEJ0aBQndeQQW
         TxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=dIkus8SgdqkYMrXyhSaL0jYmwmqz8zPjRcNlpBWOB98=;
        b=NUvCAleiRMh6MLepaXFwCfXIO27wftmlz6VgswLdZky1B0948Fcpenu4/ibEZRwe2/
         HqAGyFoDKyuB8ZSzYz8SxAyCIjuYAR2d/VOIWmQnzkrlOMMMLZXhzwCPExgmCpXBP4x6
         r5vr7NZ9AuFZU5blW6ewrpucXR/adpnnPUvj8OcqMG0DJLrJCU0+RpjNNqrWnY7hNoZR
         IYKP07n3ysHmVSdB+S2OMKZ5OjZiMM4RBdRIPsyhlPbMe58gtFruDWl48oK8NLU+JrsI
         oY/qdWk8HuBt5mVFlKSdcAjV9hpJPsq9IHtdmLzYuRzFGpTQHuNiFgeQYTEDVQ5/VCe6
         VUmA==
X-Gm-Message-State: ACrzQf2/VuauoEd1BXDjGTpsaFwVwBxfC62jOJIgT4bDUGXI4UUlEy/3
        zPPCi0SGtUwbk5AtVekKWkyy2QOf0bc=
X-Google-Smtp-Source: AMsMyM4e7ebYfSBOsagSuYeVx7wIvTOYNX/Siloh8VE+0fbK8MqVj/ZZ/d2Yag7K76uJzuTxiYhoBpyjYyw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b05:b0:202:b76e:a274 with SMTP id
 lx5-20020a17090b4b0500b00202b76ea274mr745774pjb.59.1664581743879; Fri, 30 Sep
 2022 16:49:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:48:51 +0000
In-Reply-To: <20220930234854.1739690-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220930234854.1739690-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930234854.1739690-5-seanjc@google.com>
Subject: [PATCH v5 4/7] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU
 before setting SPTE
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
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
 arch/x86/kvm/mmu/mmu.c          | 28 +++++++++++++++++++---------
 arch/x86/kvm/mmu/mmu_internal.h |  5 ++---
 arch/x86/kvm/mmu/tdp_mmu.c      | 31 ++++++++++++++++++-------------
 3 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 431c88617cae..f8a8a9b83755 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -802,11 +802,8 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
-void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			  bool nx_huge_page_possible)
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	sp->nx_huge_page_disallowed = true;
-
 	/*
 	 * If it's possible to replace the shadow page with an NX huge page,
 	 * i.e. if the shadow page is the only thing currently preventing KVM
@@ -815,8 +812,7 @@ void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	 * on the list if KVM is reusing an existing shadow page, i.e. if KVM
 	 * links a shadow page at multiple points.
 	 */
-	if (!nx_huge_page_possible ||
-	    !list_empty(&sp->possible_nx_huge_page_link))
+	if (!list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
 	++kvm->stat.nx_lpage_splits;
@@ -824,6 +820,15 @@ void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
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
@@ -841,10 +846,8 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	sp->nx_huge_page_disallowed = false;
-
 	if (list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
@@ -852,6 +855,13 @@ void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
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
index 73eb28ed1f03..059231c82345 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -403,8 +403,11 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_del(&sp->link);
-	if (sp->nx_huge_page_disallowed)
-		unaccount_nx_huge_page(kvm, sp);
+
+	if (sp->nx_huge_page_disallowed) {
+		sp->nx_huge_page_disallowed = false;
+		untrack_possible_nx_huge_page(kvm, sp);
+	}
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1118,16 +1121,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
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
@@ -1142,8 +1142,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	if (account_nx)
-		account_nx_huge_page(kvm, sp, true);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 	tdp_account_mmu_page(kvm, sp);
 
@@ -1157,6 +1155,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret;
@@ -1193,9 +1192,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-			bool account_nx = fault->huge_page_disallowed &&
-					  fault->req_level >= iter.level;
-
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -1207,10 +1203,19 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
 
@@ -1498,7 +1503,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * correctness standpoint since the translation will be the same either
 	 * way.
 	 */
-	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
+	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
 	if (ret)
 		goto out;
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

