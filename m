Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F98639E76
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 01:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiK1AUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 19:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiK1AUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 19:20:50 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3946A10564
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 16:20:50 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pj8-20020a17090b4f4800b002140219b2b3so7814753pjb.0
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 16:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Os4PbJiT3Ld5Lv/LgXTKbRpBhRE17eV3B/ireIkXlSU=;
        b=Yw6awvyfFd70dz2eGE3TO9tcdtiZk2uLIz6rLJthelDJ04p8SaSLYnDjroBs8ybbPr
         tQXvkGKkWaT4z2w73UiYpjaiTAHYDKPboGUDfqGjvx0tX54MxPZChE06wTV1Tzqfs7oP
         EwM8upLQQHy6TM+ooZ7eRsZEnVWWmDmRxa+AiSk1bkyhqgWCb04LfTU2A58eAQhZIWpV
         kw/5VtbyHvecKZdXPuEcYOKuTCbC80TbHXmG2U9hKYc8O5rPYp2ZHq7OCfNJujMauUV9
         K99wJ/xF8ObZxrgDPayK8it24+q2VE9VeIz2HJ2VH2iw/ac55J1BEgOvq9QNI81716Ca
         s0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Os4PbJiT3Ld5Lv/LgXTKbRpBhRE17eV3B/ireIkXlSU=;
        b=eVXw4bkpOeGr5Vyzk/tgnqLTw1jzZsugCjeGYIv4j75/ct/uwuWlJV/8Eu87djmP5Z
         FydrEcoEL63T4kktBDjYLawoH3Ux4tXXq+79Pl/I0ebLEqKcM1S4fSuJSnSOS4U3RWDT
         20cK2fVXUxZez2kea4ZnrKCv2GYIfdk8uryxCdazIojnVW902nbBdGUHlwAXj9mC4XY9
         RQK5mA9RNbdxCic/gJvHmYs5AYP7hQAn+bvx/sR8xhZqn3e2fNO6Dx1jOiSkziF3Auxi
         l+0OMi4WN+JJVrSh9UzJhfCMjwLgC4Rn89XXIY/ry0O+jC6QC6YKvRn+SL9kkHBDqJsq
         QFDA==
X-Gm-Message-State: ANoB5pnVU3yU8k5CymGfsCt20rmZXTOV0a/SW7CrLseA9GSc/6ejjulz
        dsUp5C/Syd6ZxtsZQdabit2ml9t0IKPn
X-Google-Smtp-Source: AA0mqf5AgK6jO1dDMxIgbqlR5yL4JmLQxLi7PfExpQTJ/7FUVHSnqfsMANW2chv0/kN2D15RNvjL+EAkp/26
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:d086:b0:219:227d:d91f with SMTP id
 k6-20020a17090ad08600b00219227dd91fmr702999pju.0.1669594849468; Sun, 27 Nov
 2022 16:20:49 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 28 Nov 2022 00:20:42 +0000
In-Reply-To: <20221128002043.1555543-1-mizhang@google.com>
Mime-Version: 1.0
References: <20221128002043.1555543-1-mizhang@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221128002043.1555543-2-mizhang@google.com>
Subject: [RFC PATCH v3 1/2] KVM: x86/mmu: plumb struct kvm all the way to pte_list_remove()
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

