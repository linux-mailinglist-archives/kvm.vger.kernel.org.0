Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410386C3D53
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 23:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCUWBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 18:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjCUWAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 18:00:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF547591CD
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a5a0b6e3so170294347b3.10
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679436037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l3JzYD0u087M8uWewJDs63iio7s7LCBf0UooyaaQZak=;
        b=sPfaqDOE7yWhSuiUIZf0xd+k0PDvbafdbkdbHy9oZQ50zsLIKXlNo4EApjcM1z4yXY
         9/ZRMbMHteBU7UnlaUQlJB83EZFWV6DqQLgv/3l95DfrZ07rsVGjeprJ4Jlt9TGlI6A1
         Mz9CElVjeppNfWHMD3wYKaOjvH2MuEeM3SMsArkPXwg3cpCopPUsnPJU0ggZI/oGJMKj
         t2zLZFRLThgRMWoaLHb3zSCfQKrIbKvLhuYiQXflYK36QWSPTN1q4hq5AH8M3dpCnyW4
         hB0Ewf4SzzL44avvLXFFBq2aomaMHTMr3mMskq3FCfPKAsd8Hca1vd6hDtU9ajGSQbby
         jbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l3JzYD0u087M8uWewJDs63iio7s7LCBf0UooyaaQZak=;
        b=BmecKTQAQkvl/F10lcBLLPsFY0TgGe+yxnHD2PLpFFNW7CPVSlG63+ViphO3/GpMFt
         FjvKlgX+h/ioDdRlV9Y2/heEqCPpU5ZOo/trZxaGDH2cEdLct3w4E3ejb3q5JbbIkZEU
         Ximj4WZwPSOX4bM5tSmH7Dz/XhOrZl2yTov2Vwaw1s88ovWPgXjWcHLeSxO0Ih/u8pAn
         BRAr1+dbgUksMjMcf9xJyfVdppsIXxwxRJCuoyB3/b6LR5vri6A3ybHuTL091pcTkTOs
         /PUl5nYK59ci8ZHXcIVmrb4euqHBKnfCNFumNMDVWS8ec3Fq01LGeb+sDydeADQFvoxg
         BnYA==
X-Gm-Message-State: AAQBX9dCPtLUYcVZgVGmnHeDJJP3KCN2G1pmtvr7QWGHIk/w78FItsfw
        cs5C86quK7v1Zh7NIsGpWfmL1Kd65f8=
X-Google-Smtp-Source: AKy350ZrJiZIL9DkISdCz4U34JRpP0pdOec2sduVj6biEF/6aEeFwAoFopPBaLpv1b0ftiNSOQQL+BhsVz0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:283:b0:b6e:d788:eba7 with SMTP id
 v3-20020a056902028300b00b6ed788eba7mr2491158ybh.6.1679436037531; Tue, 21 Mar
 2023 15:00:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 15:00:16 -0700
In-Reply-To: <20230321220021.2119033-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230321220021.2119033-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321220021.2119033-9-seanjc@google.com>
Subject: [PATCH v4 08/13] KVM: x86/mmu: Clear only A-bit (if enabled) when
 aging TDP MMU SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vipin Sharma <vipinsh@google.com>

Use tdp_mmu_clear_spte_bits() when clearing the Accessed bit in TDP MMU
SPTEs so as to use an atomic-AND instead of XCHG to clear the A-bit.
Similar to the D-bit story, this will allow KVM to bypass
__handle_changed_spte() by ensuring only the A-bit is modified.

Link: https://lore.kernel.org/all/Y9HcHRBShQgjxsQb@google.com
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3cc81fa22b7f..adbdfed287cc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -756,13 +756,6 @@ static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
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
 
@@ -1248,33 +1241,44 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
+ *
+ * No need to mark the corresponding PFN as accessed as this call is coming
+ * from the clear_young() or clear_flush_young() notifier, which uses the
+ * return value to determine if the page has been accessed.
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
+		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
+							 iter->old_spte,
+							 shadow_accessed_mask,
+							 iter->level);
+		new_spte = iter->old_spte & ~shadow_accessed_mask;
 	} else {
 		/*
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(new_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(new_spte));
+		if (is_writable_pte(iter->old_spte))
+			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
 
-		new_spte = mark_spte_for_access_track(new_spte);
+		new_spte = mark_spte_for_access_track(iter->old_spte);
+		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
+							iter->old_spte, new_spte,
+							iter->level);
 	}
 
-	tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
-
+	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			      new_spte, iter->level, false);
+	handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
+				      iter->old_spte, new_spte, iter->level);
 	return true;
 }
 
-- 
2.40.0.rc2.332.ga46443480c-goog

