Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6CE767A27
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbjG2AuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbjG2At3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:49:29 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773BB4C00
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbb97d27d6so18320655ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591664; x=1691196464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wQPXzO6Hsu0iSJF0dOCAsCOFxRTne/hu/L+54JaWJC0=;
        b=xk+sw9iHBzeSkdbItPNiudL91ectUHw+VPj43a93ptNlkiVnFBWSaIzTGo+pBOZrVB
         ZMZwVCYflhDXeIrkHf6UKFSk7SIyUbjztsAG4Mw4KJRCYnGySF3Nt3HKUeKczPqEU4zG
         SslR1c0snG5jb8rT1lS2+NufHyLHp+wt0HthtHJpu1qRkzc6nMkJKDnij6sEUAbjCtEF
         xE35oyH827tgDTbyWBzgzeJAkn0BQPrkDeAgl61AfpacjncbL2Nm7WLmKYPYqFiDjg9q
         xz3BLkHqH3lpajail7UUUR1jWV+XCNuYepHBeCKE68teAVQAlpsg/L+kiDJJmlR5RdJi
         2sMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591664; x=1691196464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wQPXzO6Hsu0iSJF0dOCAsCOFxRTne/hu/L+54JaWJC0=;
        b=KRl3apRDyEl95vJVTfGGl+j7A8R5/cfiOvIGc5oh+kNXJfEzEKeXG8nKxzINUWqtQY
         cZoZfbNfp0ru+GXxfyaxOMkWSrx8DCxceKenqBeOOLixwymu/WHOrvje4iZFb1dVaX8t
         Qc2xIyDswFg5g3+guGpwU9ekgKLNO8MYrFi5zBKDDuJgtV8PD+Ho0ZLgx7uehKm+2K2F
         bWNsUN4Bl0fR7rjB68XXAxoYsyOBLVxAAkLre/3pMBErMgGOB2HW4qGYNZiMvsXvfLUu
         tCCTM9dzpY5DDPs5kS2cQVG/EDp8rg/pqkIB5zJixT4hVZ5YGwUI9f3G6mCJlBlhf4rk
         en2A==
X-Gm-Message-State: ABy/qLY5CGki1Is2lcH9AUdil2llRKZS1fxfOFyELO6bc+jBpS5tJV19
        494TBsouA093kuK6MsKrBaDgOeptv4U=
X-Google-Smtp-Source: APBJJlFG4d/5bdx+xRzhQ/DaNaoyQLMCndwbopyCOGef6fROIbvq0t1FoGOW/euNMPaBYQgIxM7Z7+SLE4s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c9:b0:1bb:8c42:79f4 with SMTP id
 o9-20020a170902d4c900b001bb8c4279f4mr11219plg.2.1690591664685; Fri, 28 Jul
 2023 17:47:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:21 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-12-seanjc@google.com>
Subject: [PATCH v3 11/12] KVM: x86/mmu: Plumb "struct kvm" all the way to pte_list_remove()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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
index 21ced900c3e9..67a25c957a16 100644
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
@@ -1757,16 +1760,16 @@ static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
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
 
@@ -2481,7 +2484,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (child->role.access == direct_access)
 			return;
 
-		drop_parent_pte(child, sptep);
+		drop_parent_pte(vcpu->kvm, child, sptep);
 		kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
 	}
 }
@@ -2499,7 +2502,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			drop_spte(kvm, spte);
 		} else {
 			child = spte_to_child_sp(pte);
-			drop_parent_pte(child, spte);
+			drop_parent_pte(kvm, child, spte);
 
 			/*
 			 * Recursively zap nested TDP SPs, parentless SPs are
@@ -2530,13 +2533,13 @@ static int kvm_mmu_page_unlink_children(struct kvm *kvm,
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
@@ -2575,7 +2578,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	*nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
-	kvm_mmu_unlink_parents(sp);
+	kvm_mmu_unlink_parents(kvm, sp);
 
 	/* Zapping children means active_mmu_pages has become unstable. */
 	list_unstable = *nr_zapped;
@@ -2933,7 +2936,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			u64 pte = *sptep;
 
 			child = spte_to_child_sp(pte);
-			drop_parent_pte(child, sptep);
+			drop_parent_pte(vcpu->kvm, child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
 			drop_spte(vcpu->kvm, sptep);
-- 
2.41.0.487.g6d72f3e995-goog

