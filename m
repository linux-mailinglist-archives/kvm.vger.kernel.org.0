Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C937644A60
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 18:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiLFRg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 12:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbiLFRgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 12:36:16 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162713AC32
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 09:36:12 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d2-20020a170902cec200b001899479b1d8so17060807plg.22
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 09:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H8e8OULO3pzQ8jNXethnMgHASPzYAV1ngKTaICSK2LU=;
        b=FRZhVvY5mtOkbQD31kJD+YaHVJajPmTARMOqiCcI+/xvmLCmh6BGekzUTtjDNeotzq
         uV42h3eYcy2Y1U/jWIpUCdXPMDgEMZB91kpXLVv2PxG8wk3IE0JRMUxaYINZkDlBMDBa
         xpCtjKpLUcnALTVXha4JOqpMnLfJtCq7RtJbdS9Y/NG265fX+/qqKwUBhyWT0k0diYdV
         hq5HsZiSMwFdUeFrTC5lDJVcu3kftBgtGZ1hMUr8kPf0vK+aWbxsNiNiyI68v8zC2qbC
         6pvrAGBfgZS4RecxrDW7y8awmGVUrRF0AFrFHz2Pjud05rWFkofdAumELQtzKuoObx4B
         tcew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H8e8OULO3pzQ8jNXethnMgHASPzYAV1ngKTaICSK2LU=;
        b=xZHpJ6yhy+Z8g7FyCk0qgwPTjcTaK8RimWJmtkx1SuoXVreNrBWFLEV1EnXMYByvDM
         wGdRqTl+OMyrcrDiTAtTa8RIJTl0MDkGpFJ72+Er/PYqDFcCozFhPYSZlvfgEcPyjUe4
         iQKJw8148ClvTHo6WPBlbyoTbxfqAX4+6JHhgu3xzAEsdN0MG+JN0IdbTvFArnt3e4qr
         KgR5FzubUQNT2fMZLGpPXrmtiD4rJKkqJHmSlG2r8SV6HqZtavgPSs4R1ChjdfqKFoQV
         9py6yNh9L3sLUQxs5ZSPiXbp9f6L/QgPAXqxHHPvvIYhoaU4FfDsLu0W6SAS6CMo7lQm
         V/Nw==
X-Gm-Message-State: ANoB5pk+5hYdQSFQT5GAzVz2hQGDctZcbCrYVoxsI0fEFFZYChPicyuZ
        XZrvLuGAmU3LAfwqmUxEq3Ixhlu8WtZV
X-Google-Smtp-Source: AA0mqf5wvq/CNKL0wy9/uNEygU7TfpDW2kz7kcpjud97MrqPQOnNGktDWLeek44G5uBaOn37u7mXhaJhOxg8
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:3398:b0:575:72f3:d4dc with SMTP
 id cm24-20020a056a00339800b0057572f3d4dcmr36836377pfb.6.1670348172521; Tue,
 06 Dec 2022 09:36:12 -0800 (PST)
Date:   Tue,  6 Dec 2022 17:35:58 +0000
In-Reply-To: <20221206173601.549281-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221206173601.549281-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206173601.549281-5-bgardon@google.com>
Subject: [PATCH 4/7] KVM: x86/MMU: Move rmap_can_add() and rmap_remove() to rmap.c
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

Move the functions to check if an entry can be added to an rmap and for
removing elements from an rmap to rmap.(c|h).

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 34 +--------------------------------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/rmap.c         | 32 +++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/rmap.h         |  3 +++
 4 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f8d7201210c8..52e487d89d54 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -658,7 +658,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 
 static bool sp_has_gptes(struct kvm_mmu_page *sp);
 
-static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
+gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
 	if (sp->role.passthrough)
 		return sp->gfn;
@@ -891,38 +891,6 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	return true;
 }
 
-static bool rmap_can_add(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu_memory_cache *mc;
-
-	mc = &vcpu->arch.mmu_pte_list_desc_cache;
-	return kvm_mmu_memory_cache_nr_free_objects(mc);
-}
-
-static void rmap_remove(struct kvm *kvm, u64 *spte)
-{
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *slot;
-	struct kvm_mmu_page *sp;
-	gfn_t gfn;
-	struct kvm_rmap_head *rmap_head;
-
-	sp = sptep_to_sp(spte);
-	gfn = kvm_mmu_page_get_gfn(sp, spte_index(spte));
-
-	/*
-	 * Unlike rmap_add, rmap_remove does not run in the context of a vCPU
-	 * so we have to determine which memslots to use based on context
-	 * information in sp->role.
-	 */
-	slots = kvm_memslots_for_spte_role(kvm, sp->role);
-
-	slot = __gfn_to_memslot(slots, gfn);
-	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-
-	pte_list_remove(spte, rmap_head);
-}
-
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	u64 old_spte = mmu_spte_clear_track_bits(kvm, sptep);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index cd1c8f32269d..3de703c2a5d4 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -318,4 +318,5 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/rmap.c b/arch/x86/kvm/mmu/rmap.c
index 272e89147d96..6833676aa9ea 100644
--- a/arch/x86/kvm/mmu/rmap.c
+++ b/arch/x86/kvm/mmu/rmap.c
@@ -208,3 +208,35 @@ struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
 	idx = gfn_to_index(gfn, slot->base_gfn, level);
 	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
 }
+
+bool rmap_can_add(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_memory_cache *mc;
+
+	mc = &vcpu->arch.mmu_pte_list_desc_cache;
+	return kvm_mmu_memory_cache_nr_free_objects(mc);
+}
+
+void rmap_remove(struct kvm *kvm, u64 *spte)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	struct kvm_mmu_page *sp;
+	gfn_t gfn;
+	struct kvm_rmap_head *rmap_head;
+
+	sp = sptep_to_sp(spte);
+	gfn = kvm_mmu_page_get_gfn(sp, spte_index(spte));
+
+	/*
+	 * Unlike rmap_add, rmap_remove does not run in the context of a vCPU
+	 * so we have to determine which memslots to use based on context
+	 * information in sp->role.
+	 */
+	slots = kvm_memslots_for_spte_role(kvm, sp->role);
+
+	slot = __gfn_to_memslot(slots, gfn);
+	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
+
+	pte_list_remove(spte, rmap_head);
+}
diff --git a/arch/x86/kvm/mmu/rmap.h b/arch/x86/kvm/mmu/rmap.h
index 45732eda57e5..81df186ba3c3 100644
--- a/arch/x86/kvm/mmu/rmap.h
+++ b/arch/x86/kvm/mmu/rmap.h
@@ -51,4 +51,7 @@ u64 *rmap_get_next(struct rmap_iterator *iter);
 
 struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
 				  const struct kvm_memory_slot *slot);
+
+bool rmap_can_add(struct kvm_vcpu *vcpu);
+void rmap_remove(struct kvm *kvm, u64 *spte);
 #endif /* __KVM_X86_MMU_RMAP_H */
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

