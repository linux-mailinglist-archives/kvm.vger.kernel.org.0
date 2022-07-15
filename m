Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF3A576A11
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 00:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiGOWn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 18:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiGOWm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 18:42:58 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87458C145
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c15-20020a170902d48f00b0016c01db365cso2765899plg.20
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=12pAoMG7eqUpSjBxIvOnNJnEwyKK8LrfDPX8olcQNKs=;
        b=byCtTANhDQqGzobjfvR7dIeBxKJXRj9f4WjvncLqxasPzh2o5H8X/IPljjW2Ey8jZy
         +eoPB5V0ZDvJ2dBhL4uTf24x6vfC/c7050s049hXISAkUbvVlOHOgAtQG4gFO+RYQpML
         l0SOhdeMpJGIMNTvySvhtTbMntz1feob2FN52Sn692iRK2j0W/JLUSk39CaeZbeZFeKt
         Lyc7ehni3ryxB2Hw0pza6UgYFMnk5vTK0M6Py5MSbrDHE7rGSAUbfHU4QbZFfa12x2Md
         I3kklLPd4TMwvnUAo2nkOS55mDilXcguEdQuaWsJkq57fqiu0vot30r9djl+Tt0rewAh
         X9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=12pAoMG7eqUpSjBxIvOnNJnEwyKK8LrfDPX8olcQNKs=;
        b=VW+6YW5sZDMXU8aS5jVelHjnhF0GRi6d/QlgTy9sd9WNr0TFWcL06Zf8SgA8uAklo6
         lJnxyZb4MZFOiOwJyO2oycsjG/0ETXxWqNL9l1aPSOyFFeNAPMYffXcwJeL0NyO30OZu
         Gw0jknKbrRNfPRzo01oi0XLvdqKedFGVE+tsF6EeqWaNDZbYoN7UtyHt3zd6tDYGt/xr
         gTLQVm8ZxEUvcvhqS3RaVTRHu6q6Oo/8eOs+E6ARlonZq/woyellgW/+NnXcbU2nSpC4
         M+BZ5A9aRvHzZVn+cIur7cmeIHFU2xZAFfaIPU4XD6naFyMB6X2YADZJ+z6niydMEzzH
         S7pg==
X-Gm-Message-State: AJIora8q1m3mZLRhFsYa08wYQ06/LRKmwdZtHEAOg3CGmECH5Oen9R/N
        maN4Qh4rx547CeRb+OeiOL4gsAi8ZIw=
X-Google-Smtp-Source: AGRyM1uNRYq10LMeXTESy4mNUWMPIr8lGyZaxJ19QKoiM47J1hE2CGcDTLs2w0Eod1PKupNoYlp2xhx/KPE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:11d0:b0:16b:80cf:5d9 with SMTP id
 q16-20020a17090311d000b0016b80cf05d9mr16043328plh.91.1657924964208; Fri, 15
 Jul 2022 15:42:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 22:42:26 +0000
In-Reply-To: <20220715224226.3749507-1-seanjc@google.com>
Message-Id: <20220715224226.3749507-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220715224226.3749507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 7/7] KVM: x86/mmu: Remove underscores from __pte_list_remove()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Remove the underscores from __pte_list_remove(), the function formerly
known as pte_list_remove() is now named kvm_zap_one_rmap_spte() to show
that it zaps rmaps/PTEs, i.e. doesn't just remove an entry from a list.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 282e7e2ab446..5957c3e66b77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -921,7 +921,7 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 	mmu_free_pte_list_desc(desc);
 }
 
-static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
+static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
 	struct pte_list_desc *prev_desc;
@@ -961,7 +961,7 @@ static void kvm_zap_one_rmap_spte(struct kvm *kvm,
 				  struct kvm_rmap_head *rmap_head, u64 *sptep)
 {
 	mmu_spte_clear_track_bits(kvm, sptep);
-	__pte_list_remove(sptep, rmap_head);
+	pte_list_remove(sptep, rmap_head);
 }
 
 /* Return true if at least one SPTE was zapped, false otherwise */
@@ -1051,7 +1051,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	slot = __gfn_to_memslot(slots, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
-	__pte_list_remove(spte, rmap_head);
+	pte_list_remove(spte, rmap_head);
 }
 
 /*
@@ -1693,7 +1693,7 @@ static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 				       u64 *parent_pte)
 {
-	__pte_list_remove(parent_pte, &sp->parent_ptes);
+	pte_list_remove(parent_pte, &sp->parent_ptes);
 }
 
 static void drop_parent_pte(struct kvm_mmu_page *sp,
-- 
2.37.0.170.g444d1eabd0-goog

