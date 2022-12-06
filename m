Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D256C644A66
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiLFRgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 12:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiLFRg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 12:36:28 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E643B9E7
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 09:36:18 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pq17-20020a17090b3d9100b0020a4c65c3a9so12036809pjb.0
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 09:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zGVIdVHmu98j0ATMgshfuLelOvL1LTZm9iF00wr+z1c=;
        b=the3UR5nZvASMSHWZbLNk/phN3QpGy2ZKbi9DHYfcXEQ159p8R/Z/7Kn8+DTeMoLVC
         pHaMaXdy8nBuAF7ZQ2GCqrLjaiaRR0ok0NVp/8M1NybmC1AX9iALlFOCP1J9eBukP62K
         TexEBs1IBdXfB8yWGuUpm4cBsb0DlWf6ECzEhJKJpgiNZHKgKJslJ4+mK+GkHrO3BR6n
         whrLxfo9JKB/TzV1zU5UtNlT+X/J7I2EibnOxAYrtaKAZ5MlhSUTaNP44stCu67XoUmc
         VA412z6d51UVGfKCbdx1Ny80uArOlblTwP+eCoH6u+49GoAX1nxW82zITs2cd+GzLIVD
         agtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zGVIdVHmu98j0ATMgshfuLelOvL1LTZm9iF00wr+z1c=;
        b=ezAWGjrY0ihDKrF+aNiZrOinnP4W15wdgtgNVyo2JO35sAZnj/VaJ2APy9GeDxWITb
         7C9OdCZ8Fbgsyn0MOKwF+vKMmY1F6jV1MOBIO5Khr2dH3jPAEL6asIOgO5lWGPGOSHdK
         Jr2ik4q5XmrTefqgIkf3rA2VCRhgCTUNrxEAykaYIME9nB5GOCNxzewFeamxHOq/Eak0
         XWmeU2xNFPPDY4R3TXrNiFRo2s/L/7eYjmdheA1+RwBbEtuwQnEuQ6xOwLiyG6Ol7Kpd
         5+WBKHxRhN6JHqlglCd3up92qGjf6ci9BmY/lZXFhmoyJEKbOEmDbmuEozP1vAW3Py7w
         /zzA==
X-Gm-Message-State: ANoB5pnlHvsI8Zu0jJwCVTpkLw8L6SkuV5OKcRQ8gzx5SqdeSo0WZPst
        GbdKAj7OaSTAs5ZAwWOKG7vlKAiAzqJh
X-Google-Smtp-Source: AA0mqf68Pz8Y3Hu8v2Z/yj/mfJs/DBPFKf1uym2qY0m7kl49GEfjQ/w0L7uOl9vvRQZvkaj86jRMQk2/UOwu
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:d086:b0:219:227d:d91f with SMTP id
 k6-20020a17090ad08600b00219227dd91fmr4993281pju.0.1670348177805; Tue, 06 Dec
 2022 09:36:17 -0800 (PST)
Date:   Tue,  6 Dec 2022 17:36:01 +0000
In-Reply-To: <20221206173601.549281-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221206173601.549281-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206173601.549281-8-bgardon@google.com>
Subject: [PATCH 7/7] KVM: x86/MMU: Move rmap_add() to rmap.c
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ben Gardon <bgardon@google.com>
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

Move rmap_add() to rmap.c to complete the migration of the various rmap
operations out of mmu.c.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 45 ++++-----------------------------
 arch/x86/kvm/mmu/mmu_internal.h |  6 +++++
 arch/x86/kvm/mmu/rmap.c         | 37 ++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/rmap.h         |  8 +++++-
 4 files changed, 54 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 12082314d82d..b122c90a3e5f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -215,13 +215,13 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
-static inline bool kvm_available_flush_tlb_with_range(void)
+inline bool kvm_available_flush_tlb_with_range(void)
 {
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
-		struct kvm_tlb_range *range)
+void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
+				      struct kvm_tlb_range *range)
 {
 	int ret = -ENOTSUPP;
 
@@ -695,8 +695,8 @@ static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
 	return sp->role.access;
 }
 
-static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
-					 gfn_t gfn, unsigned int access)
+void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
+				  gfn_t gfn, unsigned int access)
 {
 	if (sp_has_gptes(sp)) {
 		sp->shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
@@ -1217,41 +1217,6 @@ static bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return false;
 }
 
-#define RMAP_RECYCLE_THRESHOLD 1000
-
-static void __rmap_add(struct kvm *kvm,
-		       struct kvm_mmu_memory_cache *cache,
-		       const struct kvm_memory_slot *slot,
-		       u64 *spte, gfn_t gfn, unsigned int access)
-{
-	struct kvm_mmu_page *sp;
-	struct kvm_rmap_head *rmap_head;
-	int rmap_count;
-
-	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_translation(sp, spte_index(spte), gfn, access);
-	kvm_update_page_stats(kvm, sp->role.level, 1);
-
-	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	rmap_count = pte_list_add(cache, spte, rmap_head);
-
-	if (rmap_count > kvm->stat.max_mmu_rmap_size)
-		kvm->stat.max_mmu_rmap_size = rmap_count;
-	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		kvm_zap_all_rmap_sptes(kvm, rmap_head);
-		kvm_flush_remote_tlbs_with_address(
-				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
-}
-
-static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn, unsigned int access)
-{
-	struct kvm_mmu_memory_cache *cache = &vcpu->arch.mmu_pte_list_desc_cache;
-
-	__rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
-}
-
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index a219c8e556e9..03da1f8b066e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -320,4 +320,10 @@ void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
 u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep);
+void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
+				  gfn_t gfn, unsigned int access);
+
+inline bool kvm_available_flush_tlb_with_range(void);
+void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
+				      struct kvm_tlb_range *range);
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/rmap.c b/arch/x86/kvm/mmu/rmap.c
index 9cc4252aaabb..136c5f4f867b 100644
--- a/arch/x86/kvm/mmu/rmap.c
+++ b/arch/x86/kvm/mmu/rmap.c
@@ -292,7 +292,8 @@ void kvm_zap_one_rmap_spte(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 }
 
 /* Return true if at least one SPTE was zapped, false otherwise */
-bool kvm_zap_all_rmap_sptes(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
+static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
+				   struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc, *next;
 	int i;
@@ -331,3 +332,37 @@ bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 {
 	return __kvm_zap_rmap(kvm, rmap_head, slot);
 }
+
+#define RMAP_RECYCLE_THRESHOLD 1000
+
+void __rmap_add(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+		const struct kvm_memory_slot *slot, u64 *spte, gfn_t gfn,
+		unsigned int access)
+{
+	struct kvm_mmu_page *sp;
+	struct kvm_rmap_head *rmap_head;
+	int rmap_count;
+
+	sp = sptep_to_sp(spte);
+	kvm_mmu_page_set_translation(sp, spte_index(spte), gfn, access);
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
+	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_count = pte_list_add(cache, spte, rmap_head);
+
+	if (rmap_count > kvm->stat.max_mmu_rmap_size)
+		kvm->stat.max_mmu_rmap_size = rmap_count;
+	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
+		kvm_zap_all_rmap_sptes(kvm, rmap_head);
+		kvm_flush_remote_tlbs_with_address(
+				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+	}
+}
+
+void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
+	      u64 *spte, gfn_t gfn, unsigned int access)
+{
+	struct kvm_mmu_memory_cache *cache = &vcpu->arch.mmu_pte_list_desc_cache;
+
+	__rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
+}
diff --git a/arch/x86/kvm/mmu/rmap.h b/arch/x86/kvm/mmu/rmap.h
index a9bf48494e1a..b06897dad76a 100644
--- a/arch/x86/kvm/mmu/rmap.h
+++ b/arch/x86/kvm/mmu/rmap.h
@@ -91,10 +91,16 @@ typedef bool (*rmap_handler_t)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 void kvm_zap_one_rmap_spte(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			   u64 *sptep);
-bool kvm_zap_all_rmap_sptes(struct kvm *kvm, struct kvm_rmap_head *rmap_head);
 bool __kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		    const struct kvm_memory_slot *slot);
 bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		  struct kvm_memory_slot *slot, gfn_t gfn, int level,
 		  pte_t unused);
+
+void __rmap_add(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+		const struct kvm_memory_slot *slot, u64 *spte, gfn_t gfn,
+		unsigned int access);
+void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
+	      u64 *spte, gfn_t gfn, unsigned int access);
+
 #endif /* __KVM_X86_MMU_RMAP_H */
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

