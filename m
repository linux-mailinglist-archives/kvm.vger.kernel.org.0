Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA094943A1
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344443AbiASXJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243366AbiASXH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:07:56 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5FEC06175B
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:56 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id u133-20020a63798b000000b0034c0630b044so2525398pgc.3
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2+TXnk2CNBszqcZB7JPnnvcTPXMeVHBO+bdIpTEIGzA=;
        b=dcUwx2rlgs36HWTHcqS54KNlxs3522SVb8E+ZJSZLgRQj5YUXhNEcYhQanKJO97DsQ
         NVYzJsyj103+jglwiGuP07jwbtdkUBNVOtmi6IlboSNW+oPrXXWiq8ebhNQ8Q9+g/mm4
         JIdIjRAgazTyk7aGa2k4rXQG8H/5wfECZt0XifvSwOg+sMI3tZWOtr8Eo1uZl8znNGAK
         HpSgYv2XbfjXGIq1zxQ73R3ML7OVzl0ybf/Ek6cIxTBSxaEKiRu77g0A9HlpjMLqV2DR
         xur1m7iEpek0wrLEqlYoznvSR2SiVpC0OnMhkw99A4XSJxeMXlEUnWEgYcyDnkj4ZC4u
         p6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2+TXnk2CNBszqcZB7JPnnvcTPXMeVHBO+bdIpTEIGzA=;
        b=SRlWuXnrujLB6pqG8sRL6FmBPM2xhwJRQy9bcqn5qFMZpSd8ZwyUFJ9DcxmLy3QW7F
         eoVxNnZ8oOX/dSYBkwsgaa+2SbNPihjYj2mqM98HxVBozyL8FSxC+kG9S7eWb7A4P1ID
         MSGCAI0PO9nyFotv7906RygUENyezjCrGhl98kq82fyY9UV1KjHYxKrO+8KNTTQvITqn
         mCd6sXsnKimXJcw799bOH98zb84USshZCYs+aQ7mIDisaW5M8HEn9BOiKopllI4LjarM
         aYqvFyL3ip1BcalD6lH+hhXfYjdMhk1Gez2tOHSqLAUU8L+APDM8lUBxM+2+t3h/RENm
         Lj4Q==
X-Gm-Message-State: AOAM532FWOhepN1TbuqokwpiZKYYIVd21Ubyr7/rO0Se+8wSRpbGUmEE
        ftfpjbCPstJTjOw1UVOcwn8RpKcWRbFZJQ==
X-Google-Smtp-Source: ABdhPJwBE5ZSNm9oSfmnkMUO2mX+3jPIuIhZ+UdP7SoKsH4QAzfbGu02OyhLPalfoM6h9Zwo8/PP5XCvBmwiEw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:21c7:b0:4bc:1d4d:dfe with SMTP
 id t7-20020a056a0021c700b004bc1d4d0dfemr32722511pfj.15.1642633675603; Wed, 19
 Jan 2022 15:07:55 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:26 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 05/18] KVM: x86/mmu: Rename TDP MMU functions that handle
 shadow pages
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

Rename 3 functions in tdp_mmu.c that handle shadow pages:

  alloc_tdp_mmu_page()  -> tdp_mmu_alloc_sp()
  tdp_mmu_link_page()   -> tdp_mmu_link_sp()
  tdp_mmu_unlink_page() -> tdp_mmu_unlink_sp()

These changed make tdp_mmu a consistent prefix before the verb in the
function name, and make it more clear that these functions deal with
kvm_mmu_page structs rather than struct pages.

One could argue that "shadow page" is the wrong term for a page table in
the TDP MMU since it never actually shadows a guest page table.
However, "shadow page" (or "sp" for short) has evolved to become the
standard term in KVM when referring to a kvm_mmu_page struct, and its
associated page table and other metadata, regardless of whether the page
table shadows a guest page table. So this commit just makes the TDP MMU
more consistent with the rest of KVM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3dc2e2a6d439..15cce503ffde 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -172,8 +172,8 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 	return role;
 }
 
-static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					       int level)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
+					     int level)
 {
 	struct kvm_mmu_page *sp;
 
@@ -207,7 +207,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
+	root = tdp_mmu_alloc_sp(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
@@ -252,15 +252,15 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 }
 
 /**
- * tdp_mmu_link_page - Add a new page to the list of pages used by the TDP MMU
+ * tdp_mmu_link_sp() - Add a new shadow page to the list of used pages
  *
  * @kvm: kvm instance
  * @sp: the new page
  * @account_nx: This page replaces a NX large page and should be marked for
  *		eventual reclaim.
  */
-static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			      bool account_nx)
+static void tdp_mmu_link_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
+			    bool account_nx)
 {
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
@@ -270,7 +270,7 @@ static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 }
 
 /**
- * tdp_mmu_unlink_page - Remove page from the list of pages used by the TDP MMU
+ * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
  *
  * @kvm: kvm instance
  * @sp: the page to be removed
@@ -278,8 +278,8 @@ static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  *	    the MMU lock and the operation must synchronize with other
  *	    threads that might be adding or removing pages.
  */
-static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-				bool shared)
+static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
+			      bool shared)
 {
 	if (shared)
 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
@@ -321,7 +321,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 
-	tdp_mmu_unlink_page(kvm, sp, shared);
+	tdp_mmu_unlink_sp(kvm, sp, shared);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		u64 *sptep = rcu_dereference(pt) + i;
@@ -1014,16 +1014,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
+			sp = tdp_mmu_alloc_sp(vcpu, iter.gfn, iter.level - 1);
 			child_pt = sp->spt;
 
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
 			if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
-				tdp_mmu_link_page(vcpu->kvm, sp,
-						  fault->huge_page_disallowed &&
-						  fault->req_level >= iter.level);
+				tdp_mmu_link_sp(vcpu->kvm, sp,
+						fault->huge_page_disallowed &&
+						fault->req_level >= iter.level);
 
 				trace_kvm_mmu_get_page(sp, true);
 			} else {
-- 
2.35.0.rc0.227.g00780c9af4-goog

