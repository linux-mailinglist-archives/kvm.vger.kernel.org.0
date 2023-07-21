Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB33775D7C6
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjGUXAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjGUXAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:00:40 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BB83C21
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:26 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b8af49a5d2so21496695ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689980425; x=1690585225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PLkSwB6tRh7JnFVgr30kOLaNRpwq5sUpwdYDiH0NxiY=;
        b=et21q4jW2oI5WQNLlFaRkxQCMVyGGgcs4+y24fpzOsPzXRNvf7yEdkMT1oeo7ANhvJ
         89Igf1qRGyAKQ6P0v/Jsy786tsOFF6zbVcyHrXg2hQPuH3ZFAM0n0EnkRHve6v6YLzeu
         sHbdwQAgnkWG/389w1nyDBEF/mC9ixug2JbmyK+nHF3Fln+QoNT0mJkUVcEcSSArQSk2
         y9Lk5hkiRTxoY6rvX3KGaT5EXH7jrlvsGYgBxuDkkrVrUGWoUXc//TypGfz2EmoutoDZ
         93WB8lzAm7xfjQzIHUqmH+26nAi1+D0aZWE1PFbuG6EqifzZxZEZXJT9cTXkxzO9cLFC
         OcSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689980425; x=1690585225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PLkSwB6tRh7JnFVgr30kOLaNRpwq5sUpwdYDiH0NxiY=;
        b=l4L6ZMD4u6N2AZS5uYK05SFTA8NQygm2fM3KCPepx0T8sQS7tz6lpUVcGAlzPVlmFe
         VayHPsdK2Nu0Q38c3Q6/Or5zlfsMRm+thAZg5feqSTIL2IRjwXEOKNaeXaR4A0PHVKYx
         JG5Cj49ril6D5F6RYUfM4IG/KAAvfI8Da7q+LXnIkUGM8YXWJH2xtqAdqUywqeL81ikX
         odLHjugB/fMKRh9TxaxvU4O7C9vxWLzKhJLzSDMn7CHbUrHLSNzfnogfABkqfzx60hTN
         ZegswGL1sUvMIi6dNM1hXeqdKb4Kjhxj76zbdkmLUFXAkqkMUulfhfQbJDFe/JKxIuyt
         ZyJA==
X-Gm-Message-State: ABy/qLbW6lLU7u3T3UrJR0dScoWZyagRf72od0sJPCo955Mc8Ho3JkU8
        nwjq1RKebiZWkmDlBh9Inv8s3j2d/VY=
X-Google-Smtp-Source: APBJJlFoDO1avqLXe9WIEzr7nkCBtmSBVc1vKDbXXCMkXdjvsdLRnnOgrZenL+wNGPEAeAGHDFl7L8POYj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f684:b0:1b8:a552:c8c9 with SMTP id
 l4-20020a170902f68400b001b8a552c8c9mr14093plg.13.1689980425184; Fri, 21 Jul
 2023 16:00:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 16:00:05 -0700
In-Reply-To: <20230721230006.2337941-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721230006.2337941-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721230006.2337941-9-seanjc@google.com>
Subject: [PATCH v2 8/9] KVM: x86/mmu: Plumb "struct kvm" all the way to pte_list_remove()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mingwei Zhang <mizhang@google.com>

Plumb "struct kvm" all the way to pte_list_remove() to allow the usage of
KVM_BUG() and/or KVM_BUG_ON().  This will allow killing only the offending
VM instead of doing BUG() if the kernel is built with
CONFIG_BUG_ON_DATA_CORRUPTION=n, i.e. does NOT want to BUG() if KVM's data
structures (rmaps) appear to be corrupted.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: tweak changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 933e48a73a9a..b6cc261d7748 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -965,7 +965,8 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	return count;
 }
 
-static void pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
+static void pte_list_desc_remove_entry(struct kvm *kvm,
+				       struct kvm_rmap_head *rmap_head,
 				       struct pte_list_desc *desc, int i)
 {
 	struct pte_list_desc *head_desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
@@ -1001,7 +1002,8 @@ static void pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 	mmu_free_pte_list_desc(head_desc);
 }
 
-static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
+static void pte_list_remove(struct kvm *kvm, u64 *spte,
+			    struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
 	int i;
@@ -1020,7 +1022,8 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 		while (desc) {
 			for (i = 0; i < desc->spte_count; ++i) {
 				if (desc->sptes[i] == spte) {
-					pte_list_desc_remove_entry(rmap_head, desc, i);
+					pte_list_desc_remove_entry(kvm, rmap_head,
+								   desc, i);
 					return;
 				}
 			}
@@ -1035,7 +1038,7 @@ static void kvm_zap_one_rmap_spte(struct kvm *kvm,
 				  struct kvm_rmap_head *rmap_head, u64 *sptep)
 {
 	mmu_spte_clear_track_bits(kvm, sptep);
-	pte_list_remove(sptep, rmap_head);
+	pte_list_remove(kvm, sptep, rmap_head);
 }
 
 /* Return true if at least one SPTE was zapped, false otherwise */
@@ -1110,7 +1113,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	slot = __gfn_to_memslot(slots, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
-	pte_list_remove(spte, rmap_head);
+	pte_list_remove(kvm, spte, rmap_head);
 }
 
 /*
@@ -1758,16 +1761,16 @@ static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 	pte_list_add(cache, parent_pte, &sp->parent_ptes);
 }
 
-static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
+static void mmu_page_remove_parent_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 				       u64 *parent_pte)
 {
-	pte_list_remove(parent_pte, &sp->parent_ptes);
+	pte_list_remove(kvm, parent_pte, &sp->parent_ptes);
 }
 
-static void drop_parent_pte(struct kvm_mmu_page *sp,
+static void drop_parent_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			    u64 *parent_pte)
 {
-	mmu_page_remove_parent_pte(sp, parent_pte);
+	mmu_page_remove_parent_pte(kvm, sp, parent_pte);
 	mmu_spte_clear_no_track(parent_pte);
 }
 
@@ -2482,7 +2485,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (child->role.access == direct_access)
 			return;
 
-		drop_parent_pte(child, sptep);
+		drop_parent_pte(vcpu->kvm, child, sptep);
 		kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
 	}
 }
@@ -2500,7 +2503,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			drop_spte(kvm, spte);
 		} else {
 			child = spte_to_child_sp(pte);
-			drop_parent_pte(child, spte);
+			drop_parent_pte(kvm, child, spte);
 
 			/*
 			 * Recursively zap nested TDP SPs, parentless SPs are
@@ -2531,13 +2534,13 @@ static int kvm_mmu_page_unlink_children(struct kvm *kvm,
 	return zapped;
 }
 
-static void kvm_mmu_unlink_parents(struct kvm_mmu_page *sp)
+static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
 
 	while ((sptep = rmap_get_first(&sp->parent_ptes, &iter)))
-		drop_parent_pte(sp, sptep);
+		drop_parent_pte(kvm, sp, sptep);
 }
 
 static int mmu_zap_unsync_children(struct kvm *kvm,
@@ -2576,7 +2579,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	*nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
-	kvm_mmu_unlink_parents(sp);
+	kvm_mmu_unlink_parents(kvm, sp);
 
 	/* Zapping children means active_mmu_pages has become unstable. */
 	list_unstable = *nr_zapped;
@@ -2934,7 +2937,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			u64 pte = *sptep;
 
 			child = spte_to_child_sp(pte);
-			drop_parent_pte(child, sptep);
+			drop_parent_pte(vcpu->kvm, child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
 			drop_spte(vcpu->kvm, sptep);
-- 
2.41.0.487.g6d72f3e995-goog

