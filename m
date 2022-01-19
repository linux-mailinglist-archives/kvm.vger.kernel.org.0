Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9684943B0
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344272AbiASXJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240071AbiASXH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:07:59 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8B9C06175D
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:59 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j186-20020a636ec3000000b00340c5f3a0cbso2542219pgc.0
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M/E6s/KdP8Nhq2HrOUVfsx3LUjXAmeogBGtH3TxkicY=;
        b=YqoHC8NPXtG95qTU5rAxxQgNFb8IjTkeXRsA4alfO+8aIptQbt4vJ/HtpODcbD2K2K
         agkI7RtojQkj2rPvIRQdrZ5I+6D10xLraJ1hmaKgy/vrLkgHuHA6Je0bWbZzYbcPI3pb
         SkYSl0Q18beAlW8hq5dtJHbE0itxdEKgRoEHmkQceRpasZ2pJXyDz91QPf38baIabqy4
         c75NmSyNbozY4Rc1K9+2u6BW/Ax68KQLhqCDBCT0zrLziZ3arVmYQBQXoXxT8aap0VaD
         oC5bKDmibnqtZfYkrbyRQ6iYxQCKmOqZ2nKX0iCqCOqeXk4wf0esl0A6Kgs2AETjCq+G
         P2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M/E6s/KdP8Nhq2HrOUVfsx3LUjXAmeogBGtH3TxkicY=;
        b=rIKODSUJng1Q5ck0ExSD91007bcgYbN5WMdqXTqzbxCoNT8vsSwJaSGsaUAammw9+y
         QoLw7w+ko6DVwT2gO/VLBOHQETZFU/jV5c/G8hPigppW0OGCkd/tjKDV4XYWAb6wmi8D
         WAJHfxTJaU2rUs4GybQ/dmLEz4U2MustnOfcYoqSw9jwis7TF5T1AmAzqDq5jCrOXJRl
         0d3p57AaPKnFcRhpiNFaJ1VNJSiHFqeLMmSsuHzsDGOPKViWIfmwmfmLtPCP5NOSlZBq
         H/ok705RwyULiSVrVb4lRMiSSOewQ8e9hGj2+GMxUuQlH3UWEKKO98LIAXmHHGUpEcpX
         LwHA==
X-Gm-Message-State: AOAM531mOQ65r01XfK/7r40vdr8p2L1XGJt5wvCV2dwg9VNuN/qQHU2x
        ZLJ48+GLrDSUxp4KQW4qN85IAzRNMLDSrw==
X-Google-Smtp-Source: ABdhPJx7XqrEq/4TJkaQcjPDMOPEQRIHEJJFKAfaOUpV0DS4BqYcdJqAYuJKc52gCaZvyBBGoSyOIts+HR4Y1g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:7bce:: with SMTP id
 d14mr965518pjl.7.1642633679272; Wed, 19 Jan 2022 15:07:59 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:28 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 07/18] KVM: x86/mmu: Consolidate logic to atomically
 install a new TDP MMU page table
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate the logic to atomically replace an SPTE with an SPTE that
points to a new page table into a single helper function. This will be
used in a follow-up commit to split huge pages, which involves replacing
each huge page SPTE with an SPTE that points to a page table.

Opportunistically drop the call to trace_kvm_mmu_get_page() in
kvm_tdp_mmu_map() since it is redundant with the identical tracepoint in
tdp_mmu_alloc_sp().

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 68 ++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 902dd6e49e50..f6144db48367 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -251,24 +251,6 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
-/**
- * tdp_mmu_link_sp() - Add a new shadow page to the list of used pages
- *
- * @kvm: kvm instance
- * @sp: the new page
- * @account_nx: This page replaces a NX large page and should be marked for
- *		eventual reclaim.
- */
-static void tdp_mmu_link_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
-			    bool account_nx)
-{
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	if (account_nx)
-		account_huge_nx_page(kvm, sp);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-}
-
 /**
  * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
  *
@@ -959,6 +941,38 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+/*
+ * tdp_mmu_link_sp_atomic - Atomically replace the given spte with an spte
+ * pointing to the provided page table.
+ *
+ * @kvm: kvm instance
+ * @iter: a tdp_iter instance currently on the SPTE that should be set
+ * @sp: The new TDP page table to install.
+ * @account_nx: True if this page table is being installed to split a
+ *              non-executable huge page.
+ *
+ * Returns: 0 if the new page table was installed. Non-0 if the page table
+ *          could not be installed (e.g. the atomic compare-exchange failed).
+ */
+static int tdp_mmu_link_sp_atomic(struct kvm *kvm, struct tdp_iter *iter,
+				  struct kvm_mmu_page *sp, bool account_nx)
+{
+	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
+	int ret;
+
+	ret = tdp_mmu_set_spte_atomic(kvm, iter, spte);
+	if (ret)
+		return ret;
+
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
+	if (account_nx)
+		account_huge_nx_page(kvm, sp);
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+
+	return 0;
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -968,8 +982,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
-	u64 *child_pt;
-	u64 new_spte;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1004,6 +1016,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
+			bool account_nx = fault->huge_page_disallowed &&
+					  fault->req_level >= iter.level;
+
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -1013,18 +1028,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 				break;
 
 			sp = tdp_mmu_alloc_sp(vcpu, iter.gfn, iter.level - 1);
-			child_pt = sp->spt;
-
-			new_spte = make_nonleaf_spte(child_pt,
-						     !shadow_accessed_mask);
-
-			if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
-				tdp_mmu_link_sp(vcpu->kvm, sp,
-						fault->huge_page_disallowed &&
-						fault->req_level >= iter.level);
-
-				trace_kvm_mmu_get_page(sp, true);
-			} else {
+			if (tdp_mmu_link_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
 				tdp_mmu_free_sp(sp);
 				break;
 			}
-- 
2.35.0.rc0.227.g00780c9af4-goog

