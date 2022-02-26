Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6994C5289
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240704AbiBZASJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240884AbiBZARO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:14 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EAA2261C1
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:30 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id b6-20020a621b06000000b004e1453487efso3948570pfb.22
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tRw/deY2VUJH9uZ2P/hJN+/3kIiv3vn+Rqob7NUnZN4=;
        b=PaaSV5IRPBmtEyd0+pvviWtBTpUOYzerXq4v5mPU1O/7behXkjfV+J9JAFmS98y3PQ
         ok8BXbQ/aDwJtX5HGEtG1w/zh/2qwN7uxpJvigr49COt9DKOG4fl0kZRN9JM+9bLuQv1
         SUux0tSM6dHFd6wAH/c/c+9f9Kx1jnEry9GEKQ+gjno4Yn9BnM93z1tj+/IHjoW0QvV9
         IxfMhtrUZUB5nGC0c2J5hkopkVzO4HFC1vDTg3VWnOxZAK/5WCLy3O0+BynDb3GExLSM
         wacKrzlB5LLFtiIWDU/5ILRyHEXm9xTnqaQj6r9cB4rmajwPQIDBIUw+S8czycZ5IMXP
         5cHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tRw/deY2VUJH9uZ2P/hJN+/3kIiv3vn+Rqob7NUnZN4=;
        b=VOf5IJKmteUiRpkEC2cpbjM16jigU+XyCXm9PD5WBTjhQKLqvaR/zRJ4Qeujh6Z5pl
         Y3bBkNpU7i3PN5X+NSZFQCaKevtLVMEj1sSi3ZMk5RSkmEJbMiH3X8MG7xIZj0zhOmbh
         zFaCPGTBd+0+CiQxQfmzuBoJLmFF2YqWkd+i2kYbdQgRvmiQSRw8wfRuzJ9Jav1vmdmv
         5Xvn0vDG0yXqUkasEYndeP7izkoLUSLQe3dg38hOD5KThregj/6ejeCKe7ii3cCucz7h
         wKNhwpL7285wJVXIU14g/AcbpGHCXNdSJDveQe8jiomgUwVRTcwLBUkZwc3pgyrrflqN
         uC8w==
X-Gm-Message-State: AOAM5324nMleEHq37wRSPaZpj2zv41Wwrwsk8Oi0PNF+r0uWwGEL0w1m
        OXOjMC8qbFGxfHCW2ycY+GLRk/Os9lk=
X-Google-Smtp-Source: ABdhPJwsueKl4GHgV3xPfatFXXxxYt7VznGdNycV8rXaEF320vIs/okAqFaQ8bX7p+ARIye8G2egzOfWTDI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:11cf:b0:14d:654b:b559 with SMTP id
 q15-20020a17090311cf00b0014d654bb559mr9854802plh.164.1645834589988; Fri, 25
 Feb 2022 16:16:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:35 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 17/28] KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zap only leaf SPTEs in the TDP MMU's zap_gfn_range(), and rename various
functions accordingly.  When removing mappings for functional correctness
(except for the stupid VFIO GPU passthrough memslots bug), zapping the
leaf SPTEs is sufficient as the paging structures themselves do not point
at guest memory and do not directly impact the final translation (in the
TDP MMU).

Note, this aligns the TDP MMU with the legacy/full MMU, which zaps only
the rmaps, a.k.a. leaf SPTEs, in kvm_zap_gfn_range() and
kvm_unmap_gfn_range().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 41 ++++++++++----------------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  8 +-------
 3 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1c4b84e80841..92fe1ba27213 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5775,8 +5775,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
-							  gfn_end, flush);
+			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
+						      gfn_end, true, flush);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b55eb7bec308..42803d5dbbf9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -848,10 +848,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 /*
- * Tears down the mappings for the range of gfns, [start, end), and frees the
- * non-root pages mapping GFNs strictly within that range. Returns true if
- * SPTEs have been cleared and a TLB flush is needed before releasing the
- * MMU lock.
+ * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
+ * have been cleared and a TLB flush is needed before releasing the MMU lock.
  *
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -859,42 +857,25 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * the caller must ensure it does not supply too large a GFN range, or the
  * operation can cause a soft lockup.
  */
-static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush)
+static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
+			      gfn_t start, gfn_t end, bool can_yield, bool flush)
 {
-	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
 	struct tdp_iter iter;
 
-	/*
-	 * No need to try to step down in the iterator when zapping all SPTEs,
-	 * zapping the top-level non-leaf SPTEs will recurse on their children.
-	 */
-	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
-
 	end = min(end, tdp_mmu_max_gfn_host());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
 
-		if (!is_shadow_present_pte(iter.old_spte))
-			continue;
-
-		/*
-		 * If this is a non-last-level SPTE that covers a larger range
-		 * than should be zapped, continue, and zap the mappings at a
-		 * lower level, except when zapping all SPTEs.
-		 */
-		if (!zap_all &&
-		    (iter.gfn < start ||
-		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
+		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
@@ -912,13 +893,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
  */
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush)
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
+			   bool can_yield, bool flush)
 {
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
-		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
 
 	return flush;
 }
@@ -1179,8 +1160,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
-					   range->end, range->may_block, flush);
+	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
+				     range->end, range->may_block, flush);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5e5ef2576c81..54bc8118c40a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -15,14 +15,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
 				 gfn_t end, bool can_yield, bool flush);
-static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
-					     gfn_t start, gfn_t end, bool flush)
-{
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
-}
-
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-- 
2.35.1.574.g5d30c73bfb-goog

