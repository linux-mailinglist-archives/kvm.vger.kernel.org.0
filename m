Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C255692CA4
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 02:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBKBqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 20:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjBKBql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 20:46:41 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF84B84B91
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:39 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id s4-20020a056a00194400b0058d9b9fecb6so3436637pfk.1
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+gGMkWLRs9fWzgoKMZp1xjTHNEtbWSt2tA+J164dR+I=;
        b=n4w2JvSZxbvAx7VDuTa8a6gnidk7+fM4SN3MoyITzRdo8Zusatugfb0N1mp7zDdAtm
         nkhT4ceurl+KSeBYu9KzUTa8oFiachS16q0TOsJhkSXmoY5VcCxLGE77JXnMLtd4AlJm
         nYaND+RHtk6DaGb8UbXmjF67jjmu7+tbRomwRl8q4whlT68/prZH4lf6oAKIuMqg3Oog
         7jRUqsAdomH6eGOi5pQpQdIXfWvKdc17woQPwGK56J49NXm1kQFEkeER/UbFB7IRBE4E
         ds6/M+/hv1rxXm244otjozs+JI1/o3dSAAc9NOQzc/cN4c27HBZFHrDd9YmeV9F+D+Ts
         TwYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gGMkWLRs9fWzgoKMZp1xjTHNEtbWSt2tA+J164dR+I=;
        b=Fo2dcUIIxBt2y6eqt4uW3vkVXd9oMfCbiH1kfFf8DKMFKyGrgzctRu5wTEZRY5r2Hn
         xz821AqPLImV4BHQ/d4V8TWMrcR+GcEKvd51AlxA8BCADAoZhRAeU/PYcVOwKo/gcUJN
         OpMM+9EKqwMuy4Z8B/dgd+JU5ivrW+6hE8LeWjErIXrKcwzyXhIeJsDFp9V2d8tFsJbm
         ZriSMHkjtHiR5aKWxRGpo0Xhvn0X6kQ10f5Y970NZPtEjuH5MjEOsLBLVBl6qZBxdVEY
         HfVeS9a6ErRBFlTakWH13CQsyVHwTysQEUknYmwwRhIuB5Zm+TptldCqToDFjHxqHsh0
         Z+yg==
X-Gm-Message-State: AO0yUKX2oOJkHhe3b4yD59heEjjvID2RXKn5t2U8Pxu06CGngJJqYGW2
        VIirNQvFNxMJ7nfYp/4VrmZgc4/MyDnN
X-Google-Smtp-Source: AK7set8K9Pxm27vSO52D5ATEFyE/B/V3FGyDTFtREQw5bTFuoc9urcOJfrVPxABPSX++bn6TZOR+0gt2vq91
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:e84f:b0:189:6df9:4f85 with SMTP id
 t15-20020a170902e84f00b001896df94f85mr4137680plg.27.1676079999320; Fri, 10
 Feb 2023 17:46:39 -0800 (PST)
Date:   Fri, 10 Feb 2023 17:46:23 -0800
In-Reply-To: <20230211014626.3659152-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211014626.3659152-5-vipinsh@google.com>
Subject: [Patch v3 4/7] KVM: x86/mmu: Optimize SPTE change for aging gfn range
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

No need to check all of the conditions in __handle_changed_spte(). Aging
a gfn range implies resetting access bit or marking spte for access
tracking.

Use atomic operation to only reset those bits. This avoids checking many
conditions in __handle_changed_spte() API. Also, clean up code by
removing dead code and API parameters.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c895560244de..5d6e77554797 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -758,13 +758,6 @@ static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	_tdp_mmu_set_spte(kvm, iter, new_spte, true);
 }
 
-static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
-						 struct tdp_iter *iter,
-						 u64 new_spte)
-{
-	_tdp_mmu_set_spte(kvm, iter, new_spte, false);
-}
-
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root, _start, _end)
 
@@ -1251,32 +1244,41 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
+ *
+ * No need to mark corresponding PFN as accessed as this call is coming from
+ * the clear_young() or clear_flush_young() notifier, which uses the return
+ * value to determine if the page has been accessed.
  */
 static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 			  struct kvm_gfn_range *range)
 {
-	u64 new_spte = 0;
+	u64 new_spte;
 
 	/* If we have a non-accessed entry we don't need to change the pte. */
 	if (!is_accessed_spte(iter->old_spte))
 		return false;
 
-	new_spte = iter->old_spte;
-
-	if (spte_ad_enabled(new_spte)) {
-		new_spte &= ~shadow_accessed_mask;
+	if (spte_ad_enabled(iter->old_spte)) {
+		iter->old_spte  = tdp_mmu_clear_spte_bits(iter->sptep,
+							  iter->old_spte,
+							  shadow_accessed_mask,
+							  iter->level);
+		new_spte = iter->old_spte & ~shadow_accessed_mask;
 	} else {
+		new_spte = mark_spte_for_access_track(iter->old_spte);
+		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
+							iter->old_spte, new_spte,
+							iter->level);
 		/*
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(new_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(new_spte));
-
-		new_spte = mark_spte_for_access_track(new_spte);
+		if (is_writable_pte(iter->old_spte))
+			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
 	}
 
-	tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
+	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
+				       iter->old_spte, new_spte);
 
 	return true;
 }
-- 
2.39.1.581.gbfd45094c4-goog

