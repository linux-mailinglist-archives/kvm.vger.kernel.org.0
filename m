Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A8B576A14
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 00:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiGOWnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 18:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiGOWms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 18:42:48 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E295E8B4B7
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q8-20020a17090a304800b001ef82a71a9eso3596864pjl.3
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9jEPpmejaSJpxIROjRPts8ujHRiSKDn3EzCK/DbmdXQ=;
        b=alccWWwRp4dJ72ANmbiqaAnCXwro8TrJGygV1VoT+fTjk9M+6mqrMXtonQxeqNRMcw
         V9h1FBIS9wrKO6Re0MU7jAxbM7h4m+BuiKvsnDjhrUEPRGfd8h579Hz8p322zegtivig
         3+L5ZGL+PW6ve138NJuu3jNYbtMXYxzgEYkhsX63xm25fXIFvjP+Z++6XZcY7mup9ITD
         7PgFF7IeWgCHyySR5EGOalorJNcKqMH81NFed5xuDcRf3nNMCCtVWVk+f1brlNxPoQmF
         3Up9TLIvnwYCC2rRx7HnDGlRagHyEY/D4RHeOblD1Jxjdzj6oHFfo/MzXBulrMTPWCdl
         mlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9jEPpmejaSJpxIROjRPts8ujHRiSKDn3EzCK/DbmdXQ=;
        b=eS6j/ghlA89LI+usrUgvaxwBvozmK1Bi3RnVsA4s/m6WwuWJUw9WSIgJoYCgw9de/3
         5+5WYlmoV6qKoNExwCcfifLbX8XpJAfWkcr7MQNB/Ov7xfFsKx07IP4/yk3zk0xk+c5c
         DlNkucdCWGrM5EwD4mDuoWK6HnQvZQJPYZXf9KLpu7REM9oJd/ZqlbHHlyfmL1GZdSRL
         Q21tMWjMiferCkAHhy2SddpmzXyAHXPAG+lW/7MbshovlOY0NMDNHs98qoWu9SeOzqvQ
         ubOZbtonkz6lF91p5wweuLgDWZzI4PaJKUOQilq+TGAq6ALQUUQrB0eBwUzvlOnWUDta
         JDvg==
X-Gm-Message-State: AJIora+pn4oSyEUNhu/sgHb116DuyELx4q6A1IZIAXctA87siS/xZiQQ
        t+ksrP/VbYPjE8J8o5LEuQn6/S9Pox0=
X-Google-Smtp-Source: AGRyM1vgvAyE6T8+8qp0blINZFRVIxz5+mmnSQBx64ekEZIG0aC+EdVSCbLJW9jxVwiusNnQ9MLfVODPs8k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:31c9:b0:16c:3024:69c4 with SMTP id
 v9-20020a17090331c900b0016c302469c4mr16001311ple.81.1657924962676; Fri, 15
 Jul 2022 15:42:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 22:42:25 +0000
In-Reply-To: <20220715224226.3749507-1-seanjc@google.com>
Message-Id: <20220715224226.3749507-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220715224226.3749507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 6/7] KVM: x86/mmu: Rename pte_list_{destroy,remove}() to
 show they zap SPTEs
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

Rename pte_list_remove() and pte_list_destroy() to kvm_zap_one_rmap_spte()
and kvm_zap_all_rmap_sptes() respectively to document that (a) they zap
SPTEs and (b) to better document how they differ (remove vs. destroy does
not exactly scream "one vs. all").

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 00be88e0a5f7..282e7e2ab446 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -957,15 +957,16 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 	}
 }
 
-static void pte_list_remove(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			    u64 *sptep)
+static void kvm_zap_one_rmap_spte(struct kvm *kvm,
+				  struct kvm_rmap_head *rmap_head, u64 *sptep)
 {
 	mmu_spte_clear_track_bits(kvm, sptep);
 	__pte_list_remove(sptep, rmap_head);
 }
 
-/* Return true if rmap existed, false otherwise */
-static bool pte_list_destroy(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
+/* Return true if at least one SPTE was zapped, false otherwise */
+static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
+				   struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc, *next;
 	int i;
@@ -1386,7 +1387,7 @@ static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
 static bool __kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			   const struct kvm_memory_slot *slot)
 {
-	return pte_list_destroy(kvm, rmap_head);
+	return kvm_zap_all_rmap_sptes(kvm, rmap_head);
 }
 
 static bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
@@ -1417,7 +1418,7 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		need_flush = true;
 
 		if (pte_write(pte)) {
-			pte_list_remove(kvm, rmap_head, sptep);
+			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 			goto restart;
 		} else {
 			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
@@ -1596,7 +1597,7 @@ static void __rmap_add(struct kvm *kvm,
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		pte_list_destroy(kvm, rmap_head);
+		kvm_zap_all_rmap_sptes(kvm, rmap_head);
 		kvm_flush_remote_tlbs_with_address(
 				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
@@ -6406,7 +6407,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		if (sp->role.direct &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       pfn, PG_LEVEL_NUM)) {
-			pte_list_remove(kvm, rmap_head, sptep);
+			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
 				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
-- 
2.37.0.170.g444d1eabd0-goog

