Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09295570FC2
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiGLB4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiGLB4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:56:13 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AC15B044
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:11 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id a17-20020a170902ecd100b0016c012c4cf3so4809024plh.15
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6EgqZPf0D0wnYAjdKuP58XnoafqbcD/Jb2aV9uAljuY=;
        b=BG0HpeyxmzDKRosaGJZ48VoohZfNgDhr+mvi1x+W6Ap36PtRjUjQ7EhY1Wv7uqDNRR
         SMOlx3+vGF9SPvl7v5YtXyw6QH2KhyPnaHccuIQeBTBsNmxTtAEyFTJblItqf9NMXM3s
         ZVRsxOIiqszRx6poRBNJNspWsAQC7DjWdIAwmr1vu4YzDSQNfmWYBxBk7lg6riZ3EiAR
         KCVPPpf6UP5xkuD39ioM8438S2ZlAALsid+y3mzfHEtq1BkT1BX7VoR7x+3MTKCr53Jp
         3E9wm812KJHyBOrRjtHDRGyXpmKFP/AhJ28LboWlbhZytjJ/yFRE7bmFdQ3YxZz8dIi9
         maZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6EgqZPf0D0wnYAjdKuP58XnoafqbcD/Jb2aV9uAljuY=;
        b=8EQy6QS3nVkKuDhk12U1AI5fzdjSHJDPYgKFUghAW8BmY/V7hpZVFLeXh7GQnmGaOz
         fJjOod24otlHagyLH1S2alkntywKw+RF7hVay9Ot9gdw5vv7QZod9uuAyrtuTVEHQzVT
         Lac0ddAdgSiqfqo9ESlIZfFdT8Hpock/6zLaFZ7jH09kCR3AV0Yv2CAuu9917x6kZEMb
         k7+lYTnkpPeTYbJIztoElhUyoC8O4OJvdSn+tUEQ0T8Q6jEPgd7YIws/iV1nJVNu7/mE
         RZxqsZtzKz7Q+sIfmgVNs9kNaFmPBffGU+nzL4AGN3dKRodXWCGemTC9E2Kqog+1bQNl
         SEbA==
X-Gm-Message-State: AJIora9G3Az6iIorkMURtThK9rYe/XAq5q81S0bVd/vN1GhLVyQm2GNJ
        xIPzDU/UHrcL4rcyLWAjHoI5XoxzJxc=
X-Google-Smtp-Source: AGRyM1uivt6jnQCO8wHsYSpbjkHm5SAsYq6O2gwxRAWGKLbqXWnoAWwNUBsA0i4WD0A3aGScRoULdAAYnrY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr40755pje.0.1657590970172; Mon, 11 Jul
 2022 18:56:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 01:55:58 +0000
In-Reply-To: <20220712015558.1247978-1-seanjc@google.com>
Message-Id: <20220712015558.1247978-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220712015558.1247978-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 5/5] KVM: x86/mmu: Drop the "p is for pointer" from rmap helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Drop the trailing "p" from rmap helpers, i.e. rename functions to simply
be kvm_<action>_rmap().  Declaring that a function takes a pointer is
completely unnecessary and goes against kernel style.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 496672ffaf46..47e46c10731d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -403,7 +403,7 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
  * The idea using the light way get the spte on x86_32 guest is from
  * gup_get_pte (mm/gup.c).
  *
- * An spte tlb flush may be pending, because kvm_set_pte_rmapp
+ * An spte tlb flush may be pending, because kvm_set_pte_rmap
  * coalesces them and we are running out of the MMU lock.  Therefore
  * we need to protect against in-progress updates of the spte.
  *
@@ -1396,9 +1396,9 @@ static bool kvm_zap_rmaps(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return __kvm_zap_rmaps(kvm, rmap_head, slot);
 }
 
-static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			      struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			      pte_t pte)
+static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			     struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			     pte_t pte)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1542,7 +1542,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool flush = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
+		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
@@ -1550,9 +1550,9 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return flush;
 }
 
-static bool kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			  struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			  pte_t unused)
+static bool kvm_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			 struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			 pte_t unused)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1564,9 +1564,9 @@ static bool kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return young;
 }
 
-static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			       struct kvm_memory_slot *slot, gfn_t gfn,
-			       int level, pte_t unused)
+static bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			      struct kvm_memory_slot *slot, gfn_t gfn,
+			      int level, pte_t unused)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1615,7 +1615,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool young = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
+		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 
 	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1628,7 +1628,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool young = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
+		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 
 	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
-- 
2.37.0.144.g8ac04bfd2-goog

