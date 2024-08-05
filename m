Return-Path: <kvm+bounces-23279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8BC5948614
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC5311C21D42
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB4D16F0CE;
	Mon,  5 Aug 2024 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d725v6Y0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF57315383D
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900682; cv=none; b=PNUKYpfyoC9KqC/TYcTRahJZbU7vAILBIbAzIGzIJYQqjdXQ5QJ0UvoRjtFFsmfmqNsJl2+mAVLuiQQzlc4qibKZBwPQaD3bEjT04w2gw/EmA3QLmvl89RzIKH75ELjAggWLotbaCfdkcB+cImOVGFX3nijJslGBRHjSSrqGM4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900682; c=relaxed/simple;
	bh=6IcW3BKD0ZsW3+CyzILKAguRFTnb79dMKHlabWM3MoQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rx8CHADXV2KeCKO1j6vF9wRdpKCrErFibnwi/oUB7mBwMAt7lePCe8ZmRTl69jMIc/cY3fsTKheud+mka29z2Ot+62y/AdBx0ofXuZCbdNpSVt5MM+SDlYWfUVb9Mfdk5AyVobKschPAA89ho68hDyXRefoanscF0FlXWUsrqJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d725v6Y0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-650b621f4cdso220873237b3.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900680; x=1723505480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ck+Vh2yRWHPgKKCf2pdOlRdOu2qAo0ouS81QIi7u8Xg=;
        b=d725v6Y03NkkTkyGWaNsDDHL95QOK/Ui0I9Ymjbhg3upXVphHLtI9k5SWdgFk051iE
         KetAElclNH+KBAyu3bJWWV4vv3pmCt6MEl/CgzvehO7asxogRVpjMpJD03ZJVX8uY+aB
         BaypmwB/4+uObML2vwGdIzP0ITGw5YOFeGZVRiS/Aa01DmZtmEjGC16eN9phxwe+qqI1
         8mJslk+CeQvYtaN9gMIwoQFMzs/Kb11p4prc5Bgyd7B/Nfs6BdFZ77d297UvtxPrp0PP
         MwjOAWY4zp3cx0SE93ke0TFOQnxo/EBZ1E2946wj3BILgw7gy0zZixScT5Je8EP/GY2S
         ULLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900680; x=1723505480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ck+Vh2yRWHPgKKCf2pdOlRdOu2qAo0ouS81QIi7u8Xg=;
        b=qWUtPaWiFX7bPaoarpdQVBChtyYgz2aYpfwOuA5NuX3p6qMi2F3RYuFqtxzG8bxhb7
         ZMe3R2RRqH6GlcSeOSUcZZ3FNz8wUn81Upr9KX7gIE62ZmByjIUEdWvJtnLldhc225AJ
         VYupfcw2HquJkTWdEr1Dl7YN4roMNZXa2YpX7+/mT9nGAF+1iccquptFPvgJB5LIULjx
         IQmJnLFA2Kz8rW7lalGMCRo+DCW/qmVGLh1xZHOFQzhzaEukHCK4xe5zJAhD10vVvNzC
         8jCFoWyWxNLWb73PxIIHSkyCfaJRC6XTGtjCbG0n8hC1F2B8X+dW+ZWsgXkzczeuWLfF
         J1Iw==
X-Gm-Message-State: AOJu0YwHWoguRDumRmVMCMqd3mR1jeZnv0oBgdLdNoLoEweTGn3RhrnJ
	oHGYmyyk7+J8ETemQhvAS27EuQYYhwZ2hAyaWKDiq7qC68p6JbVLMaGzby8cXUPGA+mR0ea2CRV
	dSJ+SwHwUsw==
X-Google-Smtp-Source: AGHT+IFMsFM16r9MA3nOnJCu4X04Ugtbd7lAeFZWrmCFn+hbzl6PmfRQSxxdQRQO8kl++bc1fKVMhM6Qf5RxgA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:397:b0:61b:791a:9850 with SMTP
 id 00721157ae682-68964393719mr6731177b3.9.1722900679941; Mon, 05 Aug 2024
 16:31:19 -0700 (PDT)
Date: Mon,  5 Aug 2024 16:31:08 -0700
In-Reply-To: <20240805233114.4060019-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805233114.4060019-2-dmatlack@google.com>
Subject: [PATCH 1/7] Revert "KVM: x86/mmu: Don't bottom out on leafs when
 zapping collapsible SPTEs"
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

This reverts commit 85f44f8cc07b5f61bef30fe5343d629fd4263230.

Bring back the logic that walks down to leafs when zapping collapsible
SPTEs. Stepping down to leafs is technically unnecessary when zapping,
but the leaf SPTE will be used in a subsequent commit to construct a
huge SPTE and recover the huge mapping in place.

Note, this revert does not revert the function comment changes above
zap_collapsible_spte_range() and kvm_tdp_mmu_zap_collapsible_sptes()
since those are still relevant.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c |  9 +++++++
 arch/x86/kvm/mmu/tdp_iter.h |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c  | 47 ++++++++++++++++++-------------------
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 04c247bfe318..1279babbc72c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -142,6 +142,15 @@ static bool try_step_up(struct tdp_iter *iter)
 	return true;
 }
 
+/*
+ * Step the iterator back up a level in the paging structure. Should only be
+ * used when the iterator is below the root level.
+ */
+void tdp_iter_step_up(struct tdp_iter *iter)
+{
+	WARN_ON(!try_step_up(iter));
+}
+
 /*
  * Step to the next SPTE in a pre-order traversal of the paging structure.
  * To get to the next SPTE, the iterator either steps down towards the goal
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..821fde2ac7b0 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -136,5 +136,6 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
+void tdp_iter_step_up(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c7dc49ee7388..ebe2ab3686c7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1628,49 +1628,48 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
-retry:
+	tdp_root_for_each_pte(iter, root, start, end) {
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		if (iter.level > KVM_MAX_HUGEPAGE_LEVEL ||
-		    !is_shadow_present_pte(iter.old_spte))
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
+							      iter.gfn, PG_LEVEL_NUM);
+
+		WARN_ON(max_mapping_level < iter.level);
+
 		/*
-		 * Don't zap leaf SPTEs, if a leaf SPTE could be replaced with
-		 * a large page size, then its parent would have been zapped
-		 * instead of stepping down.
+		 * If this page is already mapped at the highest
+		 * viable level, there's nothing more to do.
 		 */
-		if (is_last_spte(iter.old_spte, iter.level))
+		if (max_mapping_level == iter.level)
 			continue;
 
 		/*
-		 * If iter.gfn resides outside of the slot, i.e. the page for
-		 * the current level overlaps but is not contained by the slot,
-		 * then the SPTE can't be made huge.  More importantly, trying
-		 * to query that info from slot->arch.lpage_info will cause an
-		 * out-of-bounds access.
+		 * The page can be remapped at a higher level, so step
+		 * up to zap the parent SPTE.
 		 */
-		if (iter.gfn < start || iter.gfn >= end)
-			continue;
-
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
-							      iter.gfn, PG_LEVEL_NUM);
-		if (max_mapping_level < iter.level)
-			continue;
+		while (max_mapping_level > iter.level)
+			tdp_iter_step_up(&iter);
 
 		/* Note, a successful atomic zap also does a remote TLB flush. */
-		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
-			goto retry;
+		(void)tdp_mmu_zap_spte_atomic(kvm, &iter);
+
+		/*
+		 * If the atomic zap fails, the iter will recurse back into
+		 * the same subtree to retry.
+		 */
 	}
 
 	rcu_read_unlock();
 }
 
 /*
- * Zap non-leaf SPTEs (and free their associated page tables) which could
- * be replaced by huge pages, for GFNs within the slot.
+ * Zap non-leaf SPTEs (and free their associated page tables) which could be
+ * replaced by huge pages, for GFNs within the slot.
  */
 void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot)
-- 
2.46.0.rc2.264.g509ed76dc8-goog


