Return-Path: <kvm+bounces-22987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB569452D1
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E8C01F2444E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A806314E2F9;
	Thu,  1 Aug 2024 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R/AJ2u0i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBDA14D2B5
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537312; cv=none; b=QuH9YU5Ub/Ad5AhvmragkrDj7cvbk/4TzZdRDL+bPGyf5Wvt9Rldblh1Ab6S3rI5WtUHrp09J8jvO82WequJ81KnkK9vCyoQNvKofE8gy2pnMk07HGJe2UyOG/xf8xCDB+QWd7xyxiPMwpQ9UQUNU0slvpJ09aAPVmWxihYHxpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537312; c=relaxed/simple;
	bh=kcyZHtFtSWTsZyQHZ3oFwxa1IXjn9+p3AjCTE5ktFqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LKDvQabbkj6tXbYso49c+xtUOMrA0e+4cebXlVQZeTBTkf2S/RXh2yp4EJEWikf+6+bK+HhRMnrTC9w9V6fo/GQNAqFAB5livCnGinF4D363QE9bKBWxHF/NWkYAi/iArYEpGoN5rAHu3GBtUlKSQhA4RZfB0OwswvxV74kHCQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R/AJ2u0i; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71050384c9aso2329680b3a.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722537309; x=1723142109; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MzTNDvjeVqrs7z6ZdAikXXC/sttVLmYnLoCNz/Cy7ro=;
        b=R/AJ2u0in/q7N5U13dxxbPnEoXpNcBME4V/loLgl8eYiNLb455O8l9sqEB4GPJa+xF
         5LOt4K98IAOjlX4JOv8O7uyVVB4mAliIgWKcMFqdjqS5m6rePZd8ZuI4dbTpB/Oyu2iM
         MXjtLD+C6DZBoCXTMByNLtWV3l+lFUD8tDIQlh0wsU7hNIoWG6yM+590HHzII+QDfkar
         VR12eVFGBcdFCvtzbiKME+HqEHawIOcyXzTcoFCS+gs0C5GinTiEYUFfjttPUyuduJzI
         U0vJIVJJXKcoRZbOzayOgcyXS2eVHowuJD0YpfX5jNjvq1LJke0KEFcCn6u5cVlQhr1z
         sFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537309; x=1723142109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MzTNDvjeVqrs7z6ZdAikXXC/sttVLmYnLoCNz/Cy7ro=;
        b=Z0PLyA7f2GzOqbg7FqHc+62Q2M/x26e+t6RmfXpVZ2BIfEPV+7U5qGdc+RRfmt0Qv0
         JvtwyymMnHciOP7ENI/QXslTJj9h+AFAJjr8a85fPQ6EMJxHCcOUnmiTEx8t45vrEO1/
         aqSrfAfq2YLkQMW1MROo72iUBmPCD40qjcnr7j72Ru54hZa2S9j9lpTvP0Sw2L8hwLfw
         0HEEED3h5PbeUxj7aG8Y+Ijc6A0rIc48ctYvhQ+dF0TBR1gGgQMM/L26HC1pIOdhAZ1X
         /AtyMz17bMlMRA/0WF3YiE3iS83KYIpaZX219ZYuiNBFalyEmUJFol6FXM2vmAatS4pc
         REBA==
X-Gm-Message-State: AOJu0YzJiNwUdylk5uvFKBG9CanQoI9YtCBC/o1KGHyNZ9j07NQN7Az9
	HXHWMsVrAn5Xe/zuvN1+PcW2RlrskM2/QGkziHeMORmfk5KOLxb3HyundGTD4R3Dd5NjcZPze1Z
	/yw==
X-Google-Smtp-Source: AGHT+IHBKWw5BAUfyMToUbh6nUKAFn26IAUUz572bHA0Rz/4Cn41vP3IxvpndgvHdAhxE1s8QOG25zRXuL0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f12:b0:710:4e4c:a4ad with SMTP id
 d2e1a72fcca58-71065b6f385mr40762b3a.0.1722537309268; Thu, 01 Aug 2024
 11:35:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 11:34:51 -0700
In-Reply-To: <20240801183453.57199-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801183453.57199-8-seanjc@google.com>
Subject: [RFC PATCH 7/9] KVM: x86/mmu: Stop processing TDP MMU roots for
 test_age if young SPTE found
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Return immediately if a young SPTE is found when testing, but not updating,
SPTEs.  The return value is a boolean, i.e. whether there is one young SPTE
or fifty is irrelevant (ignoring the fact that it's impossible for there to
be fifty SPTEs, as KVM has a hard limit on the number of valid TDP MMU
roots).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 84 ++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b358642890e1..ac3200ce00f9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1189,35 +1189,6 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 	return flush;
 }
 
-typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
-			      struct kvm_gfn_range *range);
-
-static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
-						   struct kvm_gfn_range *range,
-						   tdp_handler_t handler)
-{
-	struct kvm_mmu_page *root;
-	struct tdp_iter iter;
-	bool ret = false;
-
-	/*
-	 * Don't support rescheduling, none of the MMU notifiers that funnel
-	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
-	 * this helper must NOT be used to unmap GFNs, as it processes only
-	 * valid roots!
-	 */
-	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
-		rcu_read_lock();
-
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
-			ret |= handler(kvm, &iter, range);
-
-		rcu_read_unlock();
-	}
-
-	return ret;
-}
-
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
@@ -1226,15 +1197,10 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
  * from the clear_young() or clear_flush_young() notifier, which uses the
  * return value to determine if the page has been accessed.
  */
-static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
-			  struct kvm_gfn_range *range)
+static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
 {
 	u64 new_spte;
 
-	/* If we have a non-accessed entry we don't need to change the pte. */
-	if (!is_accessed_spte(iter->old_spte))
-		return false;
-
 	if (spte_ad_enabled(iter->old_spte)) {
 		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
 							 iter->old_spte,
@@ -1250,23 +1216,53 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
 	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
 				       iter->old_spte, new_spte);
-	return true;
+}
+
+static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
+					struct kvm_gfn_range *range,
+					bool test_only)
+{
+	struct kvm_mmu_page *root;
+	struct tdp_iter iter;
+	bool ret = false;
+
+	/*
+	 * Don't support rescheduling, none of the MMU notifiers that funnel
+	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
+	 * this helper must NOT be used to unmap GFNs, as it processes only
+	 * valid roots!
+	 */
+	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		rcu_read_lock();
+
+		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
+			if (!is_accessed_spte(iter.old_spte))
+				continue;
+
+			ret = true;
+			if (test_only)
+				break;
+
+			kvm_tdp_mmu_age_spte(&iter);
+		}
+
+		rcu_read_unlock();
+
+		if (ret && test_only)
+			break;
+	}
+
+	return ret;
 }
 
 bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
-}
-
-static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
-			 struct kvm_gfn_range *range)
-{
-	return is_accessed_spte(iter->old_spte);
+	return __kvm_tdp_mmu_age_gfn_range(kvm, range, false);
 }
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
+	return __kvm_tdp_mmu_age_gfn_range(kvm, range, true);
 }
 
 /*
-- 
2.46.0.rc1.232.g9752f9e123-goog


