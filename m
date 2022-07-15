Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E695576A0B
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 00:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiGOWnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 18:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiGOWmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 18:42:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F61A709AB
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:37 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u11-20020a654c0b000000b00415ed4acf16so3343824pgq.22
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XlISLMq7DUhoDRb1LI7vRx3HrCaF8EsMmRgAz27TFSk=;
        b=Y6WBWa+D1e9x3Po+uA3SjZzShUCRyhFJ4G5xAIWeK4BQd3vH2JZtrIP2GrytmD66Wq
         hEmyy/xGN/RogqpQVYsWFq/YsNjYpUSItqZVrJ5g9K4BI8k+VfFrm8GsplkoprbUbqBq
         OfNJ3INyZuLqF/3XrVlcYk1Wzn7E98dErU17JePGEU9FVIuxIO5vNvh800rGSjcENqKj
         Vswj998YQSbPPEc2Kup0XFgY2stoTUq49kosg6Dhhoee6FinWbc2m+E8P+NXN/rRU9Fi
         1RV9LAnhCvrPD+nXHsKIfXAESsOaMM0xfP9LkHb3pxWkEATJz+S6+neLCZdZzJaY1wmU
         vedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XlISLMq7DUhoDRb1LI7vRx3HrCaF8EsMmRgAz27TFSk=;
        b=O/+IjT4VWI1FO8SIIuOGcZxzlqvpdW1y7M2zYQnlL/mr4qWAQQaBb0xse9kWxxGj1g
         5FdgYeQc/fMr56aqJ2l4jd4zdiiKg0Vpr4uKJT25x09o/L78TdqA+kEVgfw2B6NjVHEj
         l5YRDRt1ROqckpLmeCg5wbV0Dgby3pKM7h3d05D2mr2pna0N5sR67hTVOETUoK6QkghL
         MbUKuAfHb6s1kdLAcE6Ly5LYqH8bozPzN81paHA1S7kWt0GUbIe57G7r4sKSmihjMUzm
         y+OWKzyeYRVD1l0gqOVH0VrzSZVjb1+1gus45kdHGskAJFC/k+/oOoo2qln/id03xrlX
         kAqw==
X-Gm-Message-State: AJIora+Fy4emLlZFdjhV4is1eF02wRky0zM/AdpE36Unjr181P28ASrw
        +/ZXlXCO4dAIe6sZe5MQYr9L+K68SrI=
X-Google-Smtp-Source: AGRyM1t6gLb6QV5n8NSWm5gkyOjFMc42imJYvjF0symnXsuCoQ210KaqhchuM2V2TZrD4dfroq8gaYfDkr8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9ae3:0:b0:528:d881:9ff with SMTP id
 y3-20020aa79ae3000000b00528d88109ffmr16408512pfp.66.1657924956812; Fri, 15
 Jul 2022 15:42:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 22:42:22 +0000
In-Reply-To: <20220715224226.3749507-1-seanjc@google.com>
Message-Id: <20220715224226.3749507-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220715224226.3749507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 3/7] KVM: x86/mmu: Drop the "p is for pointer" from rmap helpers
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

Drop the trailing "p" from rmap helpers, i.e. rename functions to simply
be kvm_<action>_rmap().  Declaring that a function takes a pointer is
completely unnecessary and goes against kernel style.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 43 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 92fcffec0227..fec999d2fc13 100644
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
@@ -1383,22 +1383,22 @@ static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, PG_LEVEL_4K);
 }
 
-static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			  const struct kvm_memory_slot *slot)
+static bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			 const struct kvm_memory_slot *slot)
 {
 	return pte_list_destroy(kvm, rmap_head);
 }
 
-static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			    struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			    pte_t unused)
+static bool kvm_unmap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			   struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			   pte_t unused)
 {
-	return kvm_zap_rmapp(kvm, rmap_head, slot);
+	return kvm_zap_rmap(kvm, rmap_head, slot);
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
@@ -1529,7 +1529,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool flush = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
+		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmap);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
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
@@ -6004,8 +6004,7 @@ static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			if (WARN_ON_ONCE(start >= end))
 				continue;
 
-			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
-
+			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmap,
 							PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
 							start, end - 1, true, flush);
 		}
-- 
2.37.0.170.g444d1eabd0-goog

