Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D97363C7E2
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiK2TMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbiK2TMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:12:44 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570A15EFBF
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:12:42 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id e190-20020a6369c7000000b004777dc6a02aso9860967pgc.19
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Os4PbJiT3Ld5Lv/LgXTKbRpBhRE17eV3B/ireIkXlSU=;
        b=Erx4H4SVakvlu7N+u2skn+6Xtm64P8cJ6ropYl5zYMS9nxY65pDMbE9n0sCqHGGde1
         SgjDSWbbWfkDEhfQPcYOKQoLRAAm3ch4sNMw1jkCvzLGlYpBcxT9z2zxP0MRxIRr5h1v
         BVz5f1igjhYbAvjmg9vc0n84wQ2qHIJLvaYbkTbpyaGvsZMbRVLJXEprYXHEtbRBAKqU
         YDjxmBew3ESnfTyH4B83Gc75L0jPlI6oUqsa0RaoN0VrfRLlA/PUpirR4iSxr7J4TR/c
         iZJHh5z8vba2kUUR8g+w8LjE1QJvsODdZ+1KuiQ7go0J79fFK7GqZgXOGWKC0vzZrDJ0
         lt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Os4PbJiT3Ld5Lv/LgXTKbRpBhRE17eV3B/ireIkXlSU=;
        b=aXjlGFEeQ+DNZIL3NdWBqR3NOLNCN4hQoMQFMHSDhnih4uxr+8YsFlBM5j6jmAfwVI
         aGptywU9Lixi+UvNFOhKwIRZ8vojnv4Wdsr7DCK9DpyUufdSRN6eg+uJ46IIv419H6YS
         M68WxURErZVLdUneg0ubaS9EgT/VTX9Ok/oR9dSxKxlPw8+7Lfr5G246yoZt0uuIYsjT
         ePIuXaYhd48tOYPCR77SUcigR7tOWIH465Frt84hhKyp7RqB78dRr6A7kwI8Yj0eNs/O
         1jwxNzLoI07/cSG0k+/15t8/5iTiEItO9IvmqbUTqLTghZawcfixAHLB0TbsPGWtbS2m
         aATQ==
X-Gm-Message-State: ANoB5pl26vID0K3FtgFCFncTHwdfa7V1oQfrueMwVONm3Eb22eoV4pU+
        N4ieYmOEGHBwmtLPMUMovhqTGwGqIIZU
X-Google-Smtp-Source: AA0mqf58OhKp/8MwbUt+pzJ0rvk7EQ9mk0wATzWpcSe+ldobhafLsc0DO2Fr9gPK4Q/e+079YmqlFHkmFiSe
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:dc06:b0:218:9196:1cd1 with SMTP id
 i6-20020a17090adc0600b0021891961cd1mr54466231pjv.230.1669749161858; Tue, 29
 Nov 2022 11:12:41 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 29 Nov 2022 19:12:36 +0000
In-Reply-To: <20221129191237.31447-1-mizhang@google.com>
Mime-Version: 1.0
References: <20221129191237.31447-1-mizhang@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129191237.31447-2-mizhang@google.com>
Subject: [RFC PATCH v4 1/2] KVM: x86/mmu: plumb struct kvm all the way to pte_list_remove()
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>
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

Plumb struct kvm all the way to pte_list_remove() to allow the usage of
KVM_BUG() and/or KVM_BUG_ON(). This is the prepration step to depricate the
usage of BUG() in pte_list_remove() in shadow mmu.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4736d7849c60..b5a44b8f5f7b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -947,7 +947,8 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 	mmu_free_pte_list_desc(desc);
 }
 
-static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
+static void pte_list_remove(struct kvm *kvm, u64 *spte,
+			    struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
 	struct pte_list_desc *prev_desc;
@@ -987,7 +988,7 @@ static void kvm_zap_one_rmap_spte(struct kvm *kvm,
 				  struct kvm_rmap_head *rmap_head, u64 *sptep)
 {
 	mmu_spte_clear_track_bits(kvm, sptep);
-	pte_list_remove(sptep, rmap_head);
+	pte_list_remove(kvm, sptep, rmap_head);
 }
 
 /* Return true if at least one SPTE was zapped, false otherwise */
@@ -1077,7 +1078,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	slot = __gfn_to_memslot(slots, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
-	pte_list_remove(spte, rmap_head);
+	pte_list_remove(kvm, spte, rmap_head);
 }
 
 /*
@@ -1730,16 +1731,16 @@ static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
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
 
@@ -2382,7 +2383,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (child->role.access == direct_access)
 			return;
 
-		drop_parent_pte(child, sptep);
+		drop_parent_pte(vcpu->kvm, child, sptep);
 		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
 	}
 }
@@ -2400,7 +2401,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			drop_spte(kvm, spte);
 		} else {
 			child = spte_to_child_sp(pte);
-			drop_parent_pte(child, spte);
+			drop_parent_pte(kvm, child, spte);
 
 			/*
 			 * Recursively zap nested TDP SPs, parentless SPs are
@@ -2431,13 +2432,13 @@ static int kvm_mmu_page_unlink_children(struct kvm *kvm,
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
@@ -2475,7 +2476,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	*nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
-	kvm_mmu_unlink_parents(sp);
+	kvm_mmu_unlink_parents(kvm, sp);
 
 	/* Zapping children means active_mmu_pages has become unstable. */
 	list_unstable = *nr_zapped;
@@ -2839,7 +2840,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			u64 pte = *sptep;
 
 			child = spte_to_child_sp(pte);
-			drop_parent_pte(child, sptep);
+			drop_parent_pte(vcpu->kvm, child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
 			pgprintk("hfn old %llx new %llx\n",
-- 
2.38.1.584.g0f3c55d4c2-goog

