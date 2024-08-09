Return-Path: <kvm+bounces-23789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4761A94D7A2
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E49B7281633
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED481993B2;
	Fri,  9 Aug 2024 19:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WJov4la9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F384199256
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232648; cv=none; b=P1qUlB/FTdM59fToAbkYncOFr6yQcTaeDy4FEdQCBCW3RGOyEhQvoPlGGEwZj6AmLEFWcKzBYFzKKe5QypZFBQJzZUNix5ESLCvPivoLWh9laY0XNcqCWqBAQyVlLJCDLlOXmrlfbMP30XoEruxxeAJPLdvL4pRLm6w7Slae1mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232648; c=relaxed/simple;
	bh=Ed1G/Nb2CnyIN7eoTZ0EijA3UdmeGBcXP9PKO/DqlAo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XtZAqXQHI7YyC2QlBp3mxThFaaEL/GtgnRTqDm9nr7p2DkoO4ZoOsTBI9Up5GnINQn9yWppZxWEVZU8lHH/LRt/nUloDnYU1Rghy4b5cdb95t5ElWvRT6hdNc+MvHbGa2aLXmwh/FzxHd4OjOjfQtwdhXMzZxgg6O4eu8/uBzVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WJov4la9; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a30753fe30so2302559a12.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232647; x=1723837447; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xgf0knUlsf9OwxiOIKoJyEqysjyCp256HfjOAsBxKsQ=;
        b=WJov4la9g6mT6plMsSYQXNdHAX9fpke2GXA9PibfRBbl/km/cDZ6eW/g5uljUZLvAL
         lNLemc0pucMcfpvsH3IdogpZWpONwLKd8tBK/GBCNq6lgjtI6uANf8AlLT3edj234NSL
         +uZt+QPjGBTWNdcLCCvZnPRFFBAJy/EKXjwHm5AW/Qw5iu1vUFG2icWu9+044H4FjRm1
         hzvIb+qDAKcfpUZau8lLIi/7iknVionVOe75FxTM9NUT6MwZTxHdv8oDAPV7E0++nobf
         4cW2h7jf7KzoDaAUl74AlvfOcgkrgy66YrFQEWCQPu4OPZwnCsKRofdLV/UF2+XpFQn1
         ZMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232647; x=1723837447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xgf0knUlsf9OwxiOIKoJyEqysjyCp256HfjOAsBxKsQ=;
        b=e53xUZskM/81z/KDTSKpMhecUwcZci3sQ1Cbrsk7MPM4Qm01jNgDfB1hMNLlqkynkj
         V0IPG+Ndh/aFRkEtcpcWmUJq/vPWEsf6oSGOQnJgPBEoGYP83poTyKXnHaDrLS2fggLr
         W+70DQzE7QkBlmQxKN4WnjAoW+Jw4UOVs599+RvFdStEIK1LKPLVRXc0p1uhOolQpXSQ
         CifSpHpSZSv82eHtdye0r9p6c1W1QLQvBgLZGg3ewkusddN48/g5QqaZg+WulKYxG1ee
         FUzRCUJke8Rqw8WZLGZ2HlYwvAWWAzechEqkQzETwM8L0HT72S1mwqJwTOsLJjWL1CUz
         XzGg==
X-Gm-Message-State: AOJu0YyO1YkZVKHE+xkpokCoZ9QWA9PEqM6uBSVGzFgQt/hFFXjGgmHA
	50P4ViuXqGZ1jsWmjxQBHxTLd70gmXVlYjki+LDtqP4zUb6cYcDQsAHtWGyztNn11xRp40LMn7G
	ZTg==
X-Google-Smtp-Source: AGHT+IH1270TZbw7dwgOHkJEckbD2SAane4OZgA6vncKd5lKiIhglKNNCAxVffQiCers7rx90OBnP67l4os=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6d46:0:b0:718:665d:65c9 with SMTP id
 41be03b00d2f7-7c3d2bd2a84mr4911a12.6.1723232646717; Fri, 09 Aug 2024 12:44:06
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:26 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-15-seanjc@google.com>
Subject: [PATCH 14/22] KVM: x86/mmu: Morph kvm_handle_gfn_range() into an
 aging specific helper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework kvm_handle_gfn_range() into an aging-specic helper,
kvm_rmap_age_gfn_range().  In addition to purging a bunch of unnecessary
boilerplate code, this sets the stage for aging rmap SPTEs outside of
mmu_lock.

Note, there's a small functional change, as kvm_test_age_gfn() will now
return immediately if a young SPTE is found, whereas previously KVM would
continue iterating over other levels.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 68 ++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0a33857d668a..88b656a1453d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1596,25 +1596,6 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 				 start, end - 1, can_yield, true, flush);
 }
 
-typedef bool (*rmap_handler_t)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			       struct kvm_memory_slot *slot, gfn_t gfn,
-			       int level);
-
-static __always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
-						 struct kvm_gfn_range *range,
-						 rmap_handler_t handler)
-{
-	struct slot_rmap_walk_iterator iterator;
-	bool ret = false;
-
-	for_each_slot_rmap_range(range->slot, PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
-				 range->start, range->end - 1, &iterator)
-		ret |= handler(kvm, iterator.rmap, range->slot, iterator.gfn,
-			       iterator.level);
-
-	return ret;
-}
-
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
@@ -1634,31 +1615,6 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return flush;
 }
 
-static bool kvm_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			 struct kvm_memory_slot *slot, gfn_t gfn, int level)
-{
-	u64 *sptep;
-	struct rmap_iterator iter;
-	int young = 0;
-
-	for_each_rmap_spte(rmap_head, &iter, sptep)
-		young |= mmu_spte_age(sptep);
-
-	return young;
-}
-
-static bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			      struct kvm_memory_slot *slot, gfn_t gfn, int level)
-{
-	u64 *sptep;
-	struct rmap_iterator iter;
-
-	for_each_rmap_spte(rmap_head, &iter, sptep)
-		if (is_accessed_spte(*sptep))
-			return true;
-	return false;
-}
-
 #define RMAP_RECYCLE_THRESHOLD 1000
 
 static void __rmap_add(struct kvm *kvm,
@@ -1693,12 +1649,32 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 	__rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
 }
 
+static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
+				   struct kvm_gfn_range *range, bool test_only)
+{
+	struct slot_rmap_walk_iterator iterator;
+	struct rmap_iterator iter;
+	bool young = false;
+	u64 *sptep;
+
+	for_each_slot_rmap_range(range->slot, PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
+				 range->start, range->end - 1, &iterator) {
+		for_each_rmap_spte(iterator.rmap, &iter, sptep) {
+			if (test_only && is_accessed_spte(*sptep))
+				return true;
+
+			young = mmu_spte_age(sptep);
+		}
+	}
+	return young;
+}
+
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
+		young = kvm_rmap_age_gfn_range(kvm, range, false);
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1711,7 +1687,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool young = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
+		young = kvm_rmap_age_gfn_range(kvm, range, true);
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
-- 
2.46.0.76.ge559c4bf1a-goog


