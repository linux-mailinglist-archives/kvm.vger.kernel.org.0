Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAA368A2FC
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 20:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbjBCT2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 14:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbjBCT2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 14:28:38 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A655AA8A23
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 11:28:34 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p10-20020a170902eaca00b00198dd431ec1so1535467pld.3
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 11:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SZBOzrPag9qrBF2hWUY6jbrMh9ikRhKVuoUM3SUVBlw=;
        b=pJq3E8HxuEK4dyqvrQfPM3ldp+gHJEW5GZjifURYqJ01MpDIVkBLWa20dx4quPs/sZ
         1ZUgW86Qrb0XAtmmgbtsUN3EfbGwRGdh491O5khsZH4C5htGRlm7IaO5OU/7ViPc2DEc
         ICQpGLr0Xr/56wm7CFTxlfob8bjIcM8StLtysDeewJRgBwjiXoz9EROyyswUUNnlVmL1
         c3oR075IT+ksuaTfm1gJjZ3VqvuZcL0V7DSyrW6LZv3GRhc8i4lFNS3QD05JwJHm+HTZ
         M8MGZRFd8uoyUJ3BrQe81xgQpwD8qPJEl9bS7KD5u3wkEsXyHu6yR2Usv771+y13Mqhh
         fDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SZBOzrPag9qrBF2hWUY6jbrMh9ikRhKVuoUM3SUVBlw=;
        b=6CUuYnAJQltT6JYq0ohF41GrfGlgqDyXjPBsxHK4BpJJ5ED2Z1f+DCQqCU69WYC7Eb
         ULWJFc627iAELhhOM7EIVMnb6g7MKAZ1aRp/F/829wirAPkBk2Y3SveyjyPZCv1ZA++L
         jLtuplNpATQbjM/UQTHQYfteOCtBfpPnyzyveJFlJjHVENPeIN4lfVu5q+pOY6+OQtcT
         2kRiPmYa7/HvSkR6zBQIpZr5gizofAaMyRvRA3AlDnrNihSSafqJUQ9jR5Bphc7fUc0+
         PQCnrfTkpxIKdbENURROJO56Rn0uO/od4qmsowAMKWdbHVDWtDFzgQ0irQRG0clGqM7b
         3wfA==
X-Gm-Message-State: AO0yUKWOD8zKUX84f4xlz3EPfkDs2Ha7c8V704ghh/MBTvXDrLM1i+H5
        5kpxrMXZyM4SMpojgRHVYMNxaUHrIGcs
X-Google-Smtp-Source: AK7set9l9TJm2dZktMJyX6mkgCljxrkCu2PY9spP3pxWA4XSjvY7UUJsKm+DEEt+hDjuw+ey9m80gEj+jR/M
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:705:b0:594:2b99:77ad with SMTP id
 5-20020a056a00070500b005942b9977admr1968810pfl.4.1675452514299; Fri, 03 Feb
 2023 11:28:34 -0800 (PST)
Date:   Fri,  3 Feb 2023 11:28:22 -0800
In-Reply-To: <20230203192822.106773-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203192822.106773-6-vipinsh@google.com>
Subject: [Patch v2 5/5] KVM: x86/mmu: Merge all handle_changed_pte* functions.
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

__handle_changed_pte() and handle_changed_spte_acc_track() are always
used together. Merge these two functions and name the new function
handle_changed_pte(). Remove the existing handle_changed_pte() function
which just calls __handle_changed_pte and
handle_changed_spte_acc_track().

This converges SPTEs change handling code to a single place.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 42 +++++++++++---------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index afe0dcb1859e..9b0c81a28f97 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -334,17 +334,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);
 
-static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
-{
-	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
-		return;
-
-	if (is_accessed_spte(old_spte) &&
-	    (!is_shadow_present_pte(new_spte) || !is_accessed_spte(new_spte) ||
-	     spte_to_pfn(old_spte) != spte_to_pfn(new_spte)))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
-}
-
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
@@ -487,7 +476,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 }
 
 /**
- * __handle_changed_spte - handle bookkeeping associated with an SPTE change
+ * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
  * @as_id: the address space of the paging structure the SPTE was a part of
  * @gfn: the base GFN that was mapped by the SPTE
@@ -501,9 +490,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
-static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				  u64 old_spte, u64 new_spte, int level,
-				  bool shared)
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level,
+				bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -587,15 +576,10 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
-}
 
-static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
-{
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
-			      shared);
-	handle_changed_spte_acc_track(old_spte, new_spte, level);
+	if (was_leaf && is_accessed_spte(old_spte) &&
+	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
+		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
 /*
@@ -638,9 +622,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
 		return -EBUSY;
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, true);
-	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
+	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			    new_spte, iter->level, true);
 
 	return 0;
 }
@@ -705,8 +688,7 @@ static u64 _tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
-	handle_changed_spte_acc_track(old_spte, new_spte, level);
+	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 	return old_spte;
 }
 
@@ -1273,7 +1255,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * Note, when changing a read-only SPTE, it's not strictly necessary to
 	 * zero the SPTE before setting the new PFN, but doing so preserves the
 	 * invariant that the PFN of a present * leaf SPTE can never change.
-	 * See __handle_changed_spte().
+	 * See handle_changed_spte().
 	 */
 	tdp_mmu_set_spte(kvm, iter, 0);
 
@@ -1298,7 +1280,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	/*
 	 * No need to handle the remote TLB flush under RCU protection, the
 	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
-	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
+	 * shadow page. See the WARN on pfn_changed in handle_changed_spte().
 	 */
 	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
 }
-- 
2.39.1.519.gcb327c4b5f-goog

