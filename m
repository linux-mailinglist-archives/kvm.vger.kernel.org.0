Return-Path: <kvm+bounces-24977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CCEC95D9FA
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9DAA282EDC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E5D1CC17D;
	Fri, 23 Aug 2024 23:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6/OrFcJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065351C9EB3
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457417; cv=none; b=ZbrqSdj8TJzErIj/OLrFEB9zuRUBEM4/cWqukjd0YO5us0SmZsJHbKua8ykJaTVnidaqFgB9LCLhWZ5aZj+PBTluapML54MXg/IarxDh4mVvXTOd65MuejGmYTMt9siXAPqQg7grph2TnQ1BtVE+BQk8ZjvS3leGneVXI14xxJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457417; c=relaxed/simple;
	bh=dZEo0UOwWn12iIUCrzr8vgdqV2EOjO/gQOV4s1BjTOA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HylvLLiVN6Hy4h7ehHbVIl6SyjihwOqOfNI1BtXt4MgPkzSn7KPwsbumTqN45hl9RkUJ5h+4RGTbZX8M0gW5mnXEnrrsoAeCg/5Ci9HvZqD/GKC0V8cv7KFGN8we3b46KfBepcXaUmFEWJJK+t0FtVLTktToCvmFaAQq7ZiTzgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6/OrFcJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1651bac405so4321181276.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457415; x=1725062215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rA4HJJd1dlxmJbeqwRLcZUkWjbmbwXw5nXrnADSqjEU=;
        b=i6/OrFcJcJkaDet1132EULyrd3qautkwV8U5P/Vk3uZ+rKg9qUUzwjAq9Zx5WWepxV
         8nnZ7lF6D08HXDMLygJTMwAzaDsKBYT3dts7Hr7xI64imCoK4bxkMM+tsHHruEkiWsfW
         wZ1X9/z0UHaMBCzblcJAMS9qtZ21JJeHMni+NuiLghv37imJAnxDDYwS5zZA/bG3uTS3
         vdUYZ+xtqzjVpYM22gB6naoYqq6e2kj9vWTl+fx7rnIxNb2fqj+KFM+GsVfOfiv8VxzV
         9VfqPYzhQ0IXrAx5Kkpvl6kRDsWWY32nxOiu1+F7ysWyru6MtvIIkCNPW9TShc5DEa3y
         uwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457415; x=1725062215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rA4HJJd1dlxmJbeqwRLcZUkWjbmbwXw5nXrnADSqjEU=;
        b=t4hlK3GJoxakZuL/HLZ72fxsSLnGz2AOD6CkZeT9rIfO+k/Qc/1V7/l25eFXSDN+Xn
         7xbec+GjhThDRO511/12EtOHMNiaHrwYKLiXnRUI+ru4r1SLozf5oEav4iG++xq/UR1B
         0UPjx5KgpbxwJc57seaFg8uPGsafEv/zM2MKiIysbIe6JB0MJ/261r2QSIaaMi2l2sXF
         5rc9B/omyWmB4/w8BJHmOakyyg7TqdjNi6Ez1X51VfkzAO1dDrs8RgtXSY4G6oXRAuiz
         asFx6f0wxvpk0LGaVgVxPYeXtaPEI2YDZ2te6UeQGLXh5Ctz1qydgjJDJmbdn9YCZdWe
         gvOg==
X-Gm-Message-State: AOJu0Yy1yiiMwTh0X7nLxc2/WDgSncoUeu68m7CLbXozOcyqcMY8lvLI
	kUOFbxpkFfCq1mByb793J/EFWqzud/BLMWLWoeTHDSRK2c4Iw/IX3QYEHyYk8oFke7LgdbWdhEy
	byWWUwlgnxg==
X-Google-Smtp-Source: AGHT+IFRYHUkcJEoopDgBehYt1tfMMWNLUCj+UBhwPmHwybOd0Pb/UPjFHIpZdnw+abj3e/1j9o2rDrqO1/IOg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:2188:0:b0:e16:55e7:5138 with SMTP id
 3f1490d57ef6-e17a80075e1mr7203276.0.1724457415022; Fri, 23 Aug 2024 16:56:55
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:56:44 -0700
In-Reply-To: <20240823235648.3236880-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823235648.3236880-3-dmatlack@google.com>
Subject: [PATCH v2 2/6] KVM: x86/mmu: Batch TLB flushes when zapping
 collapsible TDP MMU SPTEs
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Set SPTEs directly to SHADOW_NONPRESENT_VALUE and batch up TLB flushes
when zapping collapsible SPTEs, rather than freezing them first.

Freezing the SPTE first is not required. It is fine for another thread
holding mmu_lock for read to immediately install a present entry before
TLBs are flushed because the underlying mapping is not changing. vCPUs
that translate through the stale 4K mappings or a new huge page mapping
will still observe the same GPA->HPA translations.

KVM must only flush TLBs before dropping RCU (to avoid use-after-free of
the zapped page tables) and before dropping mmu_lock (to synchronize
with mmu_notifiers invalidating mappings).

In VMs backed with 2MiB pages, batching TLB flushes improves the time it
takes to zap collapsible SPTEs to disable dirty logging:

 $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 64 -e -b 4g

 Before: Disabling dirty logging time: 14.334453428s (131072 flushes)
 After:  Disabling dirty logging time: 4.794969689s  (76 flushes)

Skipping freezing SPTEs also avoids stalling vCPU threads on the frozen
SPTE for the time it takes to perform a remote TLB flush. vCPUs faulting
on the zapped mapping can now immediately install a new huge mapping and
proceed with guest execution.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 55 +++++++-------------------------------
 1 file changed, 10 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2a843b9c8d81..27adbb3ecb02 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -591,48 +591,6 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	return 0;
 }
 
-static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-						       struct tdp_iter *iter)
-{
-	int ret;
-
-	lockdep_assert_held_read(&kvm->mmu_lock);
-
-	/*
-	 * Freeze the SPTE by setting it to a special, non-present value. This
-	 * will stop other threads from immediately installing a present entry
-	 * in its place before the TLBs are flushed.
-	 *
-	 * Delay processing of the zapped SPTE until after TLBs are flushed and
-	 * the FROZEN_SPTE is replaced (see below).
-	 */
-	ret = __tdp_mmu_set_spte_atomic(iter, FROZEN_SPTE);
-	if (ret)
-		return ret;
-
-	kvm_flush_remote_tlbs_gfn(kvm, iter->gfn, iter->level);
-
-	/*
-	 * No other thread can overwrite the frozen SPTE as they must either
-	 * wait on the MMU lock or use tdp_mmu_set_spte_atomic() which will not
-	 * overwrite the special frozen SPTE value. Use the raw write helper to
-	 * avoid an unnecessary check on volatile bits.
-	 */
-	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
-
-	/*
-	 * Process the zapped SPTE after flushing TLBs, and after replacing
-	 * FROZEN_SPTE with 0. This minimizes the amount of time vCPUs are
-	 * blocked by the FROZEN_SPTE and reduces contention on the child
-	 * SPTEs.
-	 */
-	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    SHADOW_NONPRESENT_VALUE, iter->level, true);
-
-	return 0;
-}
-
-
 /*
  * tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
  * @kvm:	      KVM instance
@@ -1625,13 +1583,16 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	gfn_t end = start + slot->npages;
 	struct tdp_iter iter;
 	int max_mapping_level;
+	bool flush = false;
 
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
+			flush = false;
 			continue;
+		}
 
 		if (iter.level > KVM_MAX_HUGEPAGE_LEVEL ||
 		    !is_shadow_present_pte(iter.old_spte))
@@ -1659,11 +1620,15 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		if (max_mapping_level < iter.level)
 			continue;
 
-		/* Note, a successful atomic zap also does a remote TLB flush. */
-		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
+		if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
 			goto retry;
+
+		flush = true;
 	}
 
+	if (flush)
+		kvm_flush_remote_tlbs_memslot(kvm, slot);
+
 	rcu_read_unlock();
 }
 
-- 
2.46.0.295.g3b9ea8a38a-goog


