Return-Path: <kvm+bounces-30782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B7D9BD545
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:49:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC016284116
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69421F80B7;
	Tue,  5 Nov 2024 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J5kHK/OJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80E1F7560
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832236; cv=none; b=hWuxkOZeSTaStzUqMycT1K+54zRIFPJCAwETrQzSZ4kvXIJ1OD7TaMLT+TcZ4Wcc6oTPeYIx+CC2IzC8rH1bUVOfCt3SGVFTUzmowdthvtpK47NX9QXUmeQPIzqKeRbQSac6i6/w9PgPpPp5/C9nsn6JXjPQv/OeD9fpyyUXZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832236; c=relaxed/simple;
	bh=NUxSfRX4cW7cHK1sEEySqBH76Z0YY3GolZI8i3B0KXc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e8ZIW0rnhizDzRRKGadxev7hE5dKTTJNLrMvVlQy0pnhw9EHBxrAUaoRe8tCntAfsyK94PHValWF+iFi4No0srVGZ0zBs4Lx6dj2Djtav1hS7c6qANjYUGhyoYjN902xIaSQela9GsEYjP5RQ3iF1Zzpwo/OD1yiK4TvMqwlUjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J5kHK/OJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2b9f2c6559so8705106276.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832233; x=1731437033; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=878SGuKh3XmWcBJqcVpzoEFvF+zSdyFMaOS0SizaVl0=;
        b=J5kHK/OJQotjkpAFnmz0SpIlBwugvNynd8cVpQG9dHbrDnigzyhY0TqZ/jdVcG7CpR
         iaZht1Apr689NOIId/9y2JFAAs72kRlra1UpWdD3pLgmhajLJ8GJEVJPWRzQ53eZ6TyT
         Xx/iMZpOqjYZzwV2/J0dWkPYAKnVTFjrOpRYOnPDGfuggSzFY/rUdCpy6NXEK5rnc0yF
         5y4CHRIRQFOsJpcKmGgvqWlJR54QVGpVJKWSMmTReq6ylA8eLfK6eMQ3BTrcUk93Os+K
         fSx6HeGsI0bpp9VgDQHH942yK7Bn2MM21ZNYRQGcKy+k0p476cxZJY72GCSESrI/4+9U
         txYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832233; x=1731437033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=878SGuKh3XmWcBJqcVpzoEFvF+zSdyFMaOS0SizaVl0=;
        b=RSDRJmIcF26Pph8VKrhIpHnxzihoi3zZh2b9QS5/N3RZA8KW2/rCxnkI6LCmmBjoc1
         OXZI4zMY3AgtPFZPLHOFmJuZspqDuaSdk3y6XHBMT3i4gTcJ07Q0XV95taoMOF/2Ww/2
         t7cFkf/WTsZmDqmBJtL7KMGrVMmw2KyJYK7FvqGn0p5EGJHlbId646OIRqBApgq3HziF
         2TNzXCWTH0FuKiIM/yMTs/Y7tU3TWKXxdC48UrRUVPPj5bDfExqe6Z+TvjOIkM1lo2zf
         9E0Xl5odJEBrPZiP7DAFYAY+XSXMIDGn696edpYyO9fBLZ1fKaxGtlf9BXK7bGBGa234
         hg0g==
X-Forwarded-Encrypted: i=1; AJvYcCU1gWHWSMKsHporh7TULAsFhnHfXGsAexKcG0bqYRI1hDub6Hc6vriW4gv2OesAYSqFjUg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjtjLT//xI9TBxFrtUZrzsqieyUtwljSgyhLhkNMFqxaux41l5
	17X0+0TSJ2KxbAu9EhDz10vBe22FBrpQC6o4DdkayYUlTbZckuDwieEkI7RQWdjQ7qhYEeEJNJO
	W2oJ6MawBoyR/eW7rNg==
X-Google-Smtp-Source: AGHT+IH7ISi4GnII+0BnZH0fUyJfZEHfRMZQzMU+f5JniaDp4cZHgc7uAg+CKsWk5yAjOsMg6WNz5CqdG6JaBDbt
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:1d1:b0:e2e:3031:3f0c with SMTP
 id 3f1490d57ef6-e30e5b0ee45mr14173276.7.1730832233341; Tue, 05 Nov 2024
 10:43:53 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:32 +0000
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-11-jthoughton@google.com>
Subject: [PATCH v8 10/11] KVM: x86/mmu: Support rmap walks without holding
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
index 71019762a28a..bdd6abf9b44e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -952,13 +952,11 @@ static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
  * locking is the same, but the caller is disallowed from modifying the rmap,
  * and so the unlock flow is a nop if the rmap is/was empty.
  */
-__maybe_unused
 static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_head)
 {
 	return __kvm_rmap_lock(rmap_head);
 }
 
-__maybe_unused
 static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
 				     unsigned long old_val)
 {
@@ -1677,37 +1675,48 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
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
@@ -1725,11 +1734,8 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	if (kvm_has_shadow_mmu_sptes(kvm)) {
-		write_lock(&kvm->mmu_lock);
+	if (kvm_has_shadow_mmu_sptes(kvm))
 		young |= kvm_rmap_age_gfn_range(kvm, range, false);
-		write_unlock(&kvm->mmu_lock);
-	}
 
 	return young;
 }
@@ -1741,11 +1747,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {
-		write_lock(&kvm->mmu_lock);
+	if (young)
+		return young;
+
+	if (kvm_has_shadow_mmu_sptes(kvm))
 		young |= kvm_rmap_age_gfn_range(kvm, range, true);
-		write_unlock(&kvm->mmu_lock);
-	}
 
 	return young;
 }
-- 
2.47.0.199.ga7371fff76-goog


