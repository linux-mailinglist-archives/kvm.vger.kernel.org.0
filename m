Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B654943A3
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344613AbiASXJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbiASXHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:07:54 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A479C06175A
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:54 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id mn21-20020a17090b189500b001b4fa60efcbso2441019pjb.2
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HuPbbBZmFDP457aUW0hKNepMxy+Xj/+aJ5rP29iDMxk=;
        b=j9FEtusOAOCC78Snr6/jpsZHIwo9CVKgRS6UeK8GXTITS6YkOPs0CE+0euzVtZmuBx
         EfJPbd6knPZ9PqlyDAbGR5WWpL7CTy65u0I0TKIDW3NDz1ASVyTEsEvktqmP7n+LPH5p
         MYSHq4A2ViJcwtm7QZw4pO3fqkb4HdOfbJ2Tstp8VaA/ZMziD5+htpZ1k5+1FFqkBfG/
         nrhM72a4Uzs+5WLmrCVmqKvq8b77Y0G8sWaxhHqk3+oxcQe0tMlqb5q2ovZApUjUOeU0
         GuoNoCau8bUY6lHEKSkUHiv4q4OfnEOUl+f2qKvSkyOD9k9RlX7enhHj19zg37mUjlYb
         PvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HuPbbBZmFDP457aUW0hKNepMxy+Xj/+aJ5rP29iDMxk=;
        b=GYsjMsmxKkrYMBoqn3zykMZu+V0dOnREaw1O75twsHuYiju4JDIwjdbNXpHcVfip0U
         xmSPACa3Mvk3piww3cHgDECypYgx3W6J4nUKLaX9KJfdD4/LU9j4vlDJrxXR8u+myLjs
         NM+6JSUEZp6+jD+B4jkxcvLZVNZNuvnIrKnRv0CojR/MghNhbAJhKC1aeY2LGYxDOh0D
         5D3qY8+C1+DntfS70AP/UknIpw4caOi3PRWnO/GatKbccAZKe+wK7YkBYgBEyNxZQxpg
         iyFPK0nkZhWkrWa/HfsqK8xLvDO8P/sqOknaX4O8p1uAim473xorJmvX1P3tzy6srnUV
         c7cA==
X-Gm-Message-State: AOAM530+imj+UNrsT6/5udLKQUJtxFfYADGS6dIBwoyRO9BdVATyT2eX
        PM7I9xd7b/gPMC+Cxunc8A9sDK10PXATzg==
X-Google-Smtp-Source: ABdhPJzw9tNYW6JacuwK7RnjzHjtwOdnz6rNkwVjqy0W2gJQbxwVQZj5EBpEFfFNTcrYeN8tN9gE/Igzu7UW9g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:ac4:b0:4bd:6555:1746 with SMTP
 id c4-20020a056a000ac400b004bd65551746mr33000183pfl.39.1642633673958; Wed, 19
 Jan 2022 15:07:53 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:25 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 04/18] KVM: x86/mmu: Change tdp_mmu_{set,zap}_spte_atomic()
 to return 0/-EBUSY
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

tdp_mmu_set_spte_atomic() and tdp_mmu_zap_spte_atomic() return a bool
with true indicating the SPTE modification was successful and false
indicating failure. Change these functions to return an int instead
since that is the common practice.

Opportunistically fix up the kernel-doc style for the Return section
above tdp_mmu_set_spte_atomic().

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 47 +++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cb7c4e3e9001..3dc2e2a6d439 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -498,13 +498,15 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @new_spte: The value the SPTE should be set to
- * Returns: true if the SPTE was set, false if it was not. If false is returned,
- *          this function will have no side-effects other than setting
- *          iter->old_spte to the last known value of spte.
+ * Return:
+ * * 0      - If the SPTE was set.
+ * * -EBUSY - If the SPTE cannot be set. In this case this function will have
+ *            no side-effects other than setting iter->old_spte to the last
+ *            known value of the spte.
  */
-static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					   struct tdp_iter *iter,
-					   u64 new_spte)
+static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					  struct tdp_iter *iter,
+					  u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
 	u64 old_spte;
@@ -518,7 +520,7 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * may modify it.
 	 */
 	if (is_removed_spte(iter->old_spte))
-		return false;
+		return -EBUSY;
 
 	/*
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
@@ -533,27 +535,30 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		 * tdp_mmu_set_spte_atomic().
 		 */
 		iter->old_spte = old_spte;
-		return false;
+		return -EBUSY;
 	}
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, true);
 	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
 
-	return true;
+	return 0;
 }
 
-static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-					   struct tdp_iter *iter)
+static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
+					  struct tdp_iter *iter)
 {
+	int ret;
+
 	/*
 	 * Freeze the SPTE by setting it to a special,
 	 * non-present value. This will stop other threads from
 	 * immediately installing a present entry in its place
 	 * before the TLBs are flushed.
 	 */
-	if (!tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE))
-		return false;
+	ret = tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE);
+	if (ret)
+		return ret;
 
 	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
 					   KVM_PAGES_PER_HPAGE(iter->level));
@@ -568,7 +573,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 */
 	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
 
-	return true;
+	return 0;
 }
 
 
@@ -765,7 +770,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!shared) {
 			tdp_mmu_set_spte(kvm, &iter, 0);
 			flush = true;
-		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
+		} else if (tdp_mmu_zap_spte_atomic(kvm, &iter)) {
 			goto retry;
 		}
 	}
@@ -923,7 +928,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
 		return RET_PF_RETRY;
 
 	/*
@@ -989,7 +994,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 */
 		if (is_shadow_present_pte(iter.old_spte) &&
 		    is_large_pte(iter.old_spte)) {
-			if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
+			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
 				break;
 
 			/*
@@ -1015,7 +1020,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
+			if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
 				tdp_mmu_link_page(vcpu->kvm, sp,
 						  fault->huge_page_disallowed &&
 						  fault->req_level >= iter.level);
@@ -1203,7 +1208,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
 
-		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
+		if (tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
 			goto retry;
 
 		spte_set = true;
@@ -1266,7 +1271,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 				continue;
 		}
 
-		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
+		if (tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
 			goto retry;
 
 		spte_set = true;
@@ -1392,7 +1397,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		/* Note, a successful atomic zap also does a remote TLB flush. */
-		if (!tdp_mmu_zap_spte_atomic(kvm, &iter))
+		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
 			goto retry;
 	}
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

