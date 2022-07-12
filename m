Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BAB570FBB
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiGLB4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiGLB4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:56:06 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B733E747
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:05 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id v2-20020a622f02000000b0052573fc72f8so1595702pfv.11
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eglsQtDj4CdMdD6XF+d1TDYgow2SaSneMXkv7CXAOJE=;
        b=qq8Lsfiezm9iN06C4o50Rjrfcg9ncT9MD5G2rSl0CSb5HyP8ibG11L2KwronwfU0UU
         MwQrpSsdeOBOmaG+0E2YVT2f/85+gkqtOAWetdgm4azTZvAJ+A9oIYFPrwx7p9CEwayu
         D8ZPcoLMZxTEGGfukoQBYQb32Uood6Pfyp9UWwkUH48GuHeZFWBC0RAWFK6hOEHPBF6D
         p0MbfJZM+Id6puOAmhqXrXRMy3u96ZYjBdVvsun/tCx5XGcJWHv4TVgrFoNDzhwJ1QZ2
         uTp9I1L+DRYnUP7sdzN/sKXwwgdcBHn4S7tQnVnZgoJLFGhEwIuAfN3f1y4wB4FpSZAm
         jwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eglsQtDj4CdMdD6XF+d1TDYgow2SaSneMXkv7CXAOJE=;
        b=Pgpg2wIlKh5XTsPC5msnwoRSGqWrOUq4aZDyIeQRjfV0GzJQJ6ZwxCK9VI3HmQx8LZ
         B5J2NNJga0BLPUiyapccfjjeFKa9R0s0XvNL3nWSp2pzyogGEXtOQufwPkcvN0AyOYL6
         Oz/O6Ezf+6RpbpFmSZTE6Kda6XXJYqq62v+srJudfCMCOG1MbS0ArCvPyhIvlKhgFU+w
         IEVYoNMM2Ce/A8b6Cb/Jwvhr/WFyId0Z6ntRpvRgT4bWQUcqAOZ+CCNHmXnmma+TpRzI
         GWGTCU76kT0ocOePWc/20eGVYiMC4K2uxQwJ1VLfI/xWba9GcPnHQrPdRvwviCF2R1tU
         FGCw==
X-Gm-Message-State: AJIora/lPTWkELgkdrYIcKsL28vlCVIvLV9KCZ8eplK/6p+HIP2EQM3K
        U0NahZht4SqKkmrlMwl0hsfytCXscxM=
X-Google-Smtp-Source: AGRyM1thwzmkST4/TSmLMCVNzU/nZWEqa2yA0adk84Az+l7MwfnIsaV0sP5TNbTkhyrqCqNXNy7zQuSlMEM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114c:b0:528:2c7a:630e with SMTP id
 b12-20020a056a00114c00b005282c7a630emr21379638pfm.86.1657590965176; Mon, 11
 Jul 2022 18:56:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 01:55:55 +0000
In-Reply-To: <20220712015558.1247978-1-seanjc@google.com>
Message-Id: <20220712015558.1247978-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220712015558.1247978-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 2/5] KVM: x86/mmu: Rename rmap zap helpers to better show relationships
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Rename the helpers that zap rmaps to use consistent naming and better
show the relationships between the various helpers.  E.g. rename
pte_list_remove() to kvm_zap_one_rmap(), use "zap" universally instead of
a mix of "zap" and "unmap", etc...

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2605d6ebc193..32f9427f3334 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -957,15 +957,15 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 	}
 }
 
-static void pte_list_remove(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			    u64 *sptep)
+static void kvm_zap_one_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			     u64 *sptep)
 {
 	mmu_spte_clear_track_bits(kvm, sptep);
 	__pte_list_remove(sptep, rmap_head);
 }
 
-/* Return true if rmap existed, false otherwise */
-static bool pte_list_destroy(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
+/* Return true if at least one rmap was zapped, false otherwise */
+static bool ____kvm_zap_rmaps(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc, *next;
 	int i;
@@ -1383,17 +1383,17 @@ static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, PG_LEVEL_4K);
 }
 
-static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			  const struct kvm_memory_slot *slot)
+static bool __kvm_zap_rmaps(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			    const struct kvm_memory_slot *slot)
 {
-	return pte_list_destroy(kvm, rmap_head);
+	return ____kvm_zap_rmaps(kvm, rmap_head);
 }
 
-static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			    struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			    pte_t unused)
+static bool kvm_zap_rmaps(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			  struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			  pte_t unused)
 {
-	return kvm_zap_rmapp(kvm, rmap_head, slot);
+	return __kvm_zap_rmaps(kvm, rmap_head, slot);
 }
 
 static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
@@ -1417,7 +1417,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		need_flush = true;
 
 		if (pte_write(pte)) {
-			pte_list_remove(kvm, rmap_head, sptep);
+			kvm_zap_one_rmap(kvm, rmap_head, sptep);
 			goto restart;
 		} else {
 			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
@@ -1529,7 +1529,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool flush = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
+		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmaps);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
@@ -1596,7 +1596,7 @@ static void __rmap_add(struct kvm *kvm,
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		kvm_zap_rmaps(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 		kvm_flush_remote_tlbs_with_address(
 				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
@@ -5977,7 +5977,7 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	mmu_free_vm_memory_caches(kvm);
 }
 
-static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+static bool __kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	const struct kvm_memory_slot *memslot;
 	struct kvm_memslots *slots;
@@ -5999,8 +5999,7 @@ static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			if (WARN_ON_ONCE(start >= end))
 				continue;
 
-			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
-
+			flush = slot_handle_level_range(kvm, memslot, __kvm_zap_rmaps,
 							PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
 							start, end - 1, true, flush);
 		}
@@ -6025,7 +6024,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
 
-	flush = __kvm_zap_rmaps(kvm, gfn_start, gfn_end);
+	flush = __kvm_zap_gfn_range(kvm, gfn_start, gfn_end);
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
@@ -6401,7 +6400,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		if (sp->role.direct &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       pfn, PG_LEVEL_NUM)) {
-			pte_list_remove(kvm, rmap_head, sptep);
+			kvm_zap_one_rmap(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
 				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
-- 
2.37.0.144.g8ac04bfd2-goog

