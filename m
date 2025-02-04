Return-Path: <kvm+bounces-37202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 509BDA268CA
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:45:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FAFB7A396F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7981FECCA;
	Tue,  4 Feb 2025 00:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TYFGe7OZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC76156C6F
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629667; cv=none; b=gzFERzZTzSz454m5IHVZdHU2Rg7k+neEKmaVB0zV0JvasWJNPLzvV0Rrn8KGv4l1U3p6GwPwd3xvEoulpuor51nLQQ1a6MyBn+Rj/QT45OmQ1m5UScP33iQw6uFqTBiMcszRtojkADe4N+2C99T4yLaOKvxMCM8MT5R2DZQALO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629667; c=relaxed/simple;
	bh=4Z6U9GTWfR1nveiuKtqo1MRye+TyhaPepZk533SRaN4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZG1sNbMxBX/phUmwWR+NZ/sBMOzacf35rYe56qQPoJ7I66nYONxeoYWoo5CDjDG+mP3bz6QWPQrMyyGE2SjYwH6K9hUqHpAkxjK8KjojYUwTH5A8fqtaYGEUA4FeyV2smbN4B4yhD8qb0vUAujvUnQOAnczuq9neV5LmsZMHWiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TYFGe7OZ; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-5174cd0a7d7so764051e0c.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629664; x=1739234464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XB20a67KR7DeYrSjHAqgweuJ5njCwGEox7XlvgNvZEY=;
        b=TYFGe7OZBfZnGZf5CSawINtJLZ4PTjs67v6LBzo+duSCaRk2ol7qcmXEi8RrF4DJ44
         T3gFntTiMAfa/1L22ctUBAMy4vazUecogMd9V8mZbBNYdBUzwySTlPzdB6lMRPLAhGFC
         wxwZILNMw751kiY03IFhwNHP1iYGxJahQYc2PZYuJzTjD2BzA3vrWDcsnu260lBiVd+d
         Rqg92QpyZOACVWzW0o8qzsUkyHtFbfnbdzbnGLH93zbTl4bScXOeIZ1JWCBVLrrHmMPD
         CvcgXYsdZ9/DtVt+HeYztQlCxq1im4Ioio/bb8GPLczFlF27okag0ANyhQKcsWvakjzO
         60DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629664; x=1739234464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XB20a67KR7DeYrSjHAqgweuJ5njCwGEox7XlvgNvZEY=;
        b=UD7kUCXKkgrDgtn2pRR9FthJPm6MvuIIWw2K1gMV2jhCsV/zN27h7TRAVqRnuCOank
         lmjhXq8HpfcpFtkbSaajgS9s4dbyq6qX7+jKjmr4ntMYyyxwhJibGZ3viAZ4mjjfsEat
         IPOGLMHVtEf+Z8ziy8i/hf6qnmthpIVRqzUl68aCRHsQ+uzgNTRThtkTXcOzQiRo8kka
         Q0210zChgvp25OWNGffjgsIhKBv9ia3o91P7Q2xpj3dILfGuR4jHchKHkdn7wvIDZU1u
         hegPul2avPH6l2YVRtBTjeDCbQJ6HzO1Mj/ecyZmAfA+tCcn7Xx5RAbHDGJpbluuysiL
         faFw==
X-Forwarded-Encrypted: i=1; AJvYcCUkqusw7xfDjZzSHuNgEUnE6oz6D4oXEl8nEYDn9jIt2zOdRLE4dOKVitrvC3Ky5jz+1tM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwANt7NaFMQTHMuhwzop+Yx/N5/oc77ryYlOrKaIL3F9wiSJuI
	X2ysHr40jYvHbPML8lFRpwx10PL8V9brNRgchovcoCT1dZJPPjg6YbnTMxq8FxTdOYK5eStcjSh
	9sSgiNBGPqmxrdg7b1A==
X-Google-Smtp-Source: AGHT+IHkxO6ZPBe74K2xXD+6ZgmR8X9CtK0Avp1jbltMoCBw3n9EM24JEDU/Ye39c2lV2gucwTZ1OATmaKLU8JCe
X-Received: from vkbfi24.prod.google.com ([2002:a05:6122:4d18:b0:51a:e48:fdff])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:1999:b0:51b:8949:c996 with SMTP id 71dfb90a1353d-51e9e5195e7mr18189806e0c.9.1738629663888;
 Mon, 03 Feb 2025 16:41:03 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:38 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-12-jthoughton@google.com>
Subject: [PATCH v9 11/11] KVM: x86/mmu: Support rmap walks without holding
 mmu_lock when aging gfns
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

When A/D bits are supported on sptes, it is safe to simply clear the
Accessed bits.

The less obvious case is marking sptes for access tracking in the
non-A/D case (for EPT only). In this case, we have to be sure that it is
okay for TLB entries to exist for non-present sptes. For example, when
doing dirty tracking, if we come across a non-present SPTE, we need to
know that we need to do a TLB invalidation.

This case is already supported today (as we already support *not* doing
TLBIs for clear_young(); there is a separate notifier for clearing *and*
flushing, clear_flush_young()). This works today because GET_DIRTY_LOG
flushes the TLB before returning to userspace.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: James Houghton <jthoughton@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a0f735eeaaeb..57b99daa8614 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -970,7 +970,6 @@ static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
  * actual locking is the same, but the caller is disallowed from modifying the
  * rmap, and so the unlock flow is a nop if the rmap is/was empty.
  */
-__maybe_unused
 static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_head)
 {
 	unsigned long rmap_val;
@@ -984,7 +983,6 @@ static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_head)
 	return rmap_val;
 }
 
-__maybe_unused
 static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
 				     unsigned long old_val)
 {
@@ -1705,37 +1703,48 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 }
 
 static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
-				   struct kvm_gfn_range *range, bool test_only)
+				   struct kvm_gfn_range *range,
+				   bool test_only)
 {
-	struct slot_rmap_walk_iterator iterator;
+	struct kvm_rmap_head *rmap_head;
 	struct rmap_iterator iter;
+	unsigned long rmap_val;
 	bool young = false;
 	u64 *sptep;
+	gfn_t gfn;
+	int level;
+	u64 spte;
 
-	for_each_slot_rmap_range(range->slot, PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
-				 range->start, range->end - 1, &iterator) {
-		for_each_rmap_spte(iterator.rmap, &iter, sptep) {
-			u64 spte = *sptep;
+	for (level = PG_LEVEL_4K; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
+		for (gfn = range->start; gfn < range->end;
+		     gfn += KVM_PAGES_PER_HPAGE(level)) {
+			rmap_head = gfn_to_rmap(gfn, level, range->slot);
+			rmap_val = kvm_rmap_lock_readonly(rmap_head);
 
-			if (!is_accessed_spte(spte))
-				continue;
+			for_each_rmap_spte_lockless(rmap_head, &iter, sptep, spte) {
+				if (!is_accessed_spte(spte))
+					continue;
+
+				if (test_only) {
+					kvm_rmap_unlock_readonly(rmap_head, rmap_val);
+					return true;
+				}
 
-			if (test_only)
-				return true;
-
-			if (spte_ad_enabled(spte)) {
-				clear_bit((ffs(shadow_accessed_mask) - 1),
-					(unsigned long *)sptep);
-			} else {
-				/*
-				 * WARN if mmu_spte_update() signals the need
-				 * for a TLB flush, as Access tracking a SPTE
-				 * should never trigger an _immediate_ flush.
-				 */
-				spte = mark_spte_for_access_track(spte);
-				WARN_ON_ONCE(mmu_spte_update(sptep, spte));
+				if (spte_ad_enabled(spte))
+					clear_bit((ffs(shadow_accessed_mask) - 1),
+						  (unsigned long *)sptep);
+				else
+					/*
+					 * If the following cmpxchg fails, the
+					 * spte is being concurrently modified
+					 * and should most likely stay young.
+					 */
+					cmpxchg64(sptep, spte,
+					      mark_spte_for_access_track(spte));
+				young = true;
 			}
-			young = true;
+
+			kvm_rmap_unlock_readonly(rmap_head, rmap_val);
 		}
 	}
 	return young;
@@ -1753,11 +1762,8 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	if (kvm_may_have_shadow_mmu_sptes(kvm)) {
-		write_lock(&kvm->mmu_lock);
+	if (kvm_may_have_shadow_mmu_sptes(kvm))
 		young |= kvm_rmap_age_gfn_range(kvm, range, false);
-		write_unlock(&kvm->mmu_lock);
-	}
 
 	return young;
 }
@@ -1769,11 +1775,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	if (!young && kvm_may_have_shadow_mmu_sptes(kvm)) {
-		write_lock(&kvm->mmu_lock);
+	if (young)
+		return young;
+
+	if (kvm_may_have_shadow_mmu_sptes(kvm))
 		young |= kvm_rmap_age_gfn_range(kvm, range, true);
-		write_unlock(&kvm->mmu_lock);
-	}
 
 	return young;
 }
-- 
2.48.1.362.g079036d154-goog


