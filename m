Return-Path: <kvm+bounces-11325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E00875762
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 20:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 039BAB220D2
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 19:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941761369B8;
	Thu,  7 Mar 2024 19:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2WfKSlRM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A6F12DDB6
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709840467; cv=none; b=BtLJHRxva1IzRirUsIo7WoD4iXrqtbj6ANw1FrrsJhha7tHtY9qMGIYbyWfW2YMm5T6UCktgRYhW4gT7J38ra8lgmvLLjY7H2Vf6sKkZmmm3sapvTFNWVaGTNv/vM1bI8wSzyj6aVUI1brOyrRo85MTJgyS00b+7aLj+K4bLXuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709840467; c=relaxed/simple;
	bh=zF//cYJtq4ANv0d7amIj0VJbCWaoNjUi03v84gdTePY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bgK89yfDsB/C4MYf/4phgjSad+UEt0b/0Qu3QGdWaZSNRopcdQLIh2/VrCkAinwdkf8HqEUcpxVKSdrPpit7SPpxfiuk9fDDbzKGDqqZqNEIUATD+2BeTqyD3rbNGMEKwid6thjkiOVDht4Dtrd0HuEKfPQ0wKPh7BVTszuoVa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2WfKSlRM; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a015ca1c5so1848317b3.1
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 11:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709840465; x=1710445265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KemvAC2r7vrA6gGy4y2yBrnwIonzbJ6k/sDwgAfmGAM=;
        b=2WfKSlRMnM/ktq65Z8Ync/HaD4AqJJ5hamlda9GG+XzSNB7Hm9OcqvWvnzA53O0pDk
         eq4YR3phPQPgbC8VNES0kkqjgWE9lMoGSt6ALA56PccoFIhcYE+NiYuhfB9pQp4/T9jH
         hlh6dwI5+hkCvtU2qx2XkoQ8Q7+8vKs65MDK2bYLQzP2znHsWgBAlOwvGaMk+eKZVT9c
         m3ZZXtDMPoF0HS9lGj5OCSdBTsOHH/SB4dvjO7J5UywBDwihFCEMKAFXWh4yyF5IuoVl
         47+hdqRrxBxto22dFDG6hW04KHVYWXYjR0/j8ofv2HwYwJVIWRtK2KHBnDLYM5pXsHdw
         8DDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709840465; x=1710445265;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KemvAC2r7vrA6gGy4y2yBrnwIonzbJ6k/sDwgAfmGAM=;
        b=QY1iqvZFkIQeE/4xfXyzKOOdq6q22HC9WTazZ6XTniuViJcmU195K/Wb/+/mtTnMBm
         K9bLHoIr7RKB5AC0US7JIEi6s4OSE2JfNZzzUgdEG2nmOkkc5OSDvTzrQKsI5wkQ7pUm
         R1rTYL3EI9n0kqGAlTxEZA6yQRlkEu47cphFMzt5RTWk9mN22wDmfR92nWh4/AlHzW0Z
         HFp6s8l0jOBcE2yv0FDmCLBV9zPjvCdFhFqFMIGg1wc7EEag6AnOkcJGhxLMELw+O3oY
         hWqjEUHfxDRGPOtB6p++gQwJvlRsT0L3KQRaRVeiodb6C5i0pqfsWohM1z0/MTyna0Tg
         /W7w==
X-Forwarded-Encrypted: i=1; AJvYcCUXxnUmI3KRFkPdvWGM5BxOhwpw+5MIFvBNkKfdgXCkaEZzoMIW+VC9N52EiGd0FjGgs4wRXzlfHL1EyasCwmi5f8So
X-Gm-Message-State: AOJu0Yz+X6QFcLnyD1HUZpclh70ieblOOltXb/fJCZGYXI/klaatcD+m
	/nrra65D/ZE8aA0YjIEQ+qkLpmEHNKJULKKN7reTevl/aPg5P1RCGh8FwRlxRzrkyYGBu8cRp6B
	ZBtUnWCW6vw==
X-Google-Smtp-Source: AGHT+IHGrJDALGa6yBkBbM/vQ/pXMX0hKZQg1GFWLKOyXPIeaimcnETTeTizQOSD+D2I7rRfG9XEGYOrvUYuew==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:100a:b0:dc7:5aad:8965 with SMTP
 id w10-20020a056902100a00b00dc75aad8965mr4921946ybt.0.1709840465159; Thu, 07
 Mar 2024 11:41:05 -0800 (PST)
Date: Thu,  7 Mar 2024 11:40:59 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307194059.1357377-1-dmatlack@google.com>
Subject: [PATCH] KVM: x86/mmu: Process atomically-zapped SPTEs after replacing REMOVED_SPTE
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Process SPTEs zapped under the read-lock after the TLB flush and
replacement of REMOVED_SPTE with 0. This minimizes the contention on the
child SPTEs (if zapping an SPTE that points to a page table) and
minimizes the amount of time vCPUs will be blocked by the REMOVED_SPTE.

In VMs with a large (400+) vCPUs, it can take KVM multiple seconds to
process a 1GiB region mapped with 4KiB entries, e.g. when disabling
dirty logging in a VM backed by 1GiB HugeTLB. During those seconds if a
vCPU accesses the 1GiB region being zapped it will be stalled until KVM
finishes processing the SPTE and replaces the REMOVED_SPTE with 0.

Re-ordering the processing does speed up the atomic-zaps somewhat, but
the main benefit is avoiding blocking vCPU threads.

Before:

 $ ./dirty_log_perf_test -s anonymous_hugetlb_1gb -v 416 -b 1G -e
 ...
 Disabling dirty logging time: 509.765146313s

 $ ./funclatency -m tdp_mmu_zap_spte_atomic

     msec                : count    distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 0        |                                        |
        32 -> 63         : 0        |                                        |
        64 -> 127        : 0        |                                        |
       128 -> 255        : 8        |**                                      |
       256 -> 511        : 68       |******************                      |
       512 -> 1023       : 129      |**********************************      |
      1024 -> 2047       : 151      |****************************************|
      2048 -> 4095       : 60       |***************                         |

After:

 $ ./dirty_log_perf_test -s anonymous_hugetlb_1gb -v 416 -b 1G -e
 ...
 Disabling dirty logging time: 336.516838548s

 $ ./funclatency -m tdp_mmu_zap_spte_atomic

     msec                : count    distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 0        |                                        |
        32 -> 63         : 0        |                                        |
        64 -> 127        : 0        |                                        |
       128 -> 255        : 12       |**                                      |
       256 -> 511        : 166      |****************************************|
       512 -> 1023       : 101      |************************                |
      1024 -> 2047       : 137      |*********************************       |

KVM's processing of collapsible SPTEs is still extremely slow and can be
improved. For example, a significant amount of time is spent calling
kvm_set_pfn_{accessed,dirty}() for every last-level SPTE, which is
redundant when processing SPTEs that all map the folio.

Cc: Vipin Sharma <vipinsh@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 81 ++++++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d078157e62aa..e169e7ee6c40 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -530,6 +530,31 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
+static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
+{
+	u64 *sptep = rcu_dereference(iter->sptep);
+
+	/*
+	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
+	 * SPTE.  KVM should never attempt to zap or manipulate a REMOVED SPTE,
+	 * and pre-checking before inserting a new SPTE is advantageous as it
+	 * avoids unnecessary work.
+	 */
+	WARN_ON_ONCE(iter->yielded || is_removed_spte(iter->old_spte));
+
+	/*
+	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
+	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
+	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
+	 * the current value, so the caller operates on fresh data, e.g. if it
+	 * retries tdp_mmu_set_spte_atomic()
+	 */
+	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
+		return -EBUSY;
+
+	return 0;
+}
+
 /*
  * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically
  * and handle the associated bookkeeping.  Do not mark the page dirty
@@ -551,27 +576,13 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					  struct tdp_iter *iter,
 					  u64 new_spte)
 {
-	u64 *sptep = rcu_dereference(iter->sptep);
-
-	/*
-	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
-	 * SPTE.  KVM should never attempt to zap or manipulate a REMOVED SPTE,
-	 * and pre-checking before inserting a new SPTE is advantageous as it
-	 * avoids unnecessary work.
-	 */
-	WARN_ON_ONCE(iter->yielded || is_removed_spte(iter->old_spte));
+	int ret;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	/*
-	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
-	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
-	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
-	 * the current value, so the caller operates on fresh data, e.g. if it
-	 * retries tdp_mmu_set_spte_atomic()
-	 */
-	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
-		return -EBUSY;
+	ret = __tdp_mmu_set_spte_atomic(iter, new_spte);
+	if (ret)
+		return ret;
 
 	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			    new_spte, iter->level, true);
@@ -584,13 +595,17 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 {
 	int ret;
 
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
 	/*
-	 * Freeze the SPTE by setting it to a special,
-	 * non-present value. This will stop other threads from
-	 * immediately installing a present entry in its place
-	 * before the TLBs are flushed.
+	 * Freeze the SPTE by setting it to a special, non-present value. This
+	 * will stop other threads from immediately installing a present entry
+	 * in its place before the TLBs are flushed.
+	 *
+	 * Delay processing of the zapped SPTE until after TLBs are flushed and
+	 * the REMOVED_SPTE is replaced (see below).
 	 */
-	ret = tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE);
+	ret = __tdp_mmu_set_spte_atomic(iter, REMOVED_SPTE);
 	if (ret)
 		return ret;
 
@@ -599,12 +614,26 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	/*
 	 * No other thread can overwrite the removed SPTE as they must either
 	 * wait on the MMU lock or use tdp_mmu_set_spte_atomic() which will not
-	 * overwrite the special removed SPTE value. No bookkeeping is needed
-	 * here since the SPTE is going from non-present to non-present.  Use
-	 * the raw write helper to avoid an unnecessary check on volatile bits.
+	 * overwrite the special removed SPTE value. Use the raw write helper to
+	 * avoid an unnecessary check on volatile bits.
 	 */
 	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
 
+	/*
+	 * Process the zapped SPTE after flushing TLBs and replacing
+	 * REMOVED_SPTE with 0. This minimizes the amount of time vCPUs are
+	 * blocked by the REMOVED_SPTE and reduces contention on the child
+	 * SPTEs.
+	 *
+	 * This should be safe because KVM does not depend on any of the
+	 * processing completing before a new SPTE is installed to map a given
+	 * GFN. Case in point, kvm_mmu_zap_all_fast() can result in KVM
+	 * processing all SPTEs in a given root after vCPUs create mappings in
+	 * a new root.
+	 */
+	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			    0, iter->level, true);
+
 	return 0;
 }
 

base-commit: 0c64952fec3ea01cb5b09f00134200f3e7ab40d5
-- 
2.44.0.278.ge034bb2e1d-goog


