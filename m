Return-Path: <kvm+bounces-22138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D8D93AA5F
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 03:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A78E21C22C71
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 01:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482181CAA1;
	Wed, 24 Jul 2024 01:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o2tsik2P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACD45C99
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 01:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783479; cv=none; b=nZdoJsOLZWmh9952iQEjExOQHPgC3Bl5hRCk7ScC1Dd8CGa3kGBRM2+l7FtzCPdih/nT8SdTEfagCs23gQUsD5ZhoQDk+e5bwIFoPs44itgevTq2zelOa0ilftenGYLpLZXdJqgVq75KtuxzZOkuDiWPyAna6xGLyLKsd3BpPBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783479; c=relaxed/simple;
	bh=/2kdFrEbCqHGO5LP5EvePqfjzDFLCHiFO1sO9p5KwPk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YKneLMW18wKwaKeSDE/h+6DJmL/r4kujTOfVKAgyED2gB+QAJM0HbvkAj8JyPLPebolS1Y0zmyyekgWgr47yJ4OmSGEibcuVxB9oyMZcgh69IBkFRt6ygg+RyKkVyyfutr7N+ya1KZb+pClDL8bGFtIy4iDHOZuj/NHeBQSH39Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o2tsik2P; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-664916e5b40so7215577b3.1
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 18:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721783475; x=1722388275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wYE88dZwxum6KV/GhN2JgnjTuhwRm296Ss1xDF2ZSzg=;
        b=o2tsik2PNa7ZGYeBObbjupExLxkjDImngS6WBXccvSNy91daNESSgStdln+DQjk7zH
         WMCibL6D5pqdK0FZSDIc3ZK5tXKjS247xSYeu4gYtr2vgBcy1IdakQux2qQywdRSft3Q
         gw6k0z/eVcYJUUtKpO4lSgdkOAWKE75GcvBMNse2C7Pvos9+2PPPImD+JdBGI6iWxhwC
         mWGGblme7dFRX3dT690kUf8QK0iO8ZuK+UqjgBFn3QqisErfzNuH70556v7RncjN6XqO
         2S42G3tUrIMGamm0iWwFK/yvw3T8uEajH12j6HnYaBOwwwzXIfSD/T0RhZoda+rSrS5+
         mbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783475; x=1722388275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wYE88dZwxum6KV/GhN2JgnjTuhwRm296Ss1xDF2ZSzg=;
        b=T1JAKSfpg91aWUYi+DeBAeP5H1IBSnMgkodVzzk0KR6yblVkx6ESQ/rVh/zn5i+zvo
         6OIRDYLtCJPclsrZ9FNj6ZKPfCVtfd1AVbOh4q5FlFNy7PyyW4BhZDY/iMhw1mnsRy/K
         mPg74AnaaBiMG6r4cZcSR8P3CQXVhD5WdB51tCaakWs6PX/1i1TFiqW5LiPG4sfgEkJh
         OVuG0Tiu8GwpbGUwLzOdDW7Y0uMmN1Oiho0MZ402wN59RFzj3ra9KJIl3OtZ/KjVaAXs
         i5kvTV14CJBk+zG/1kR7MAE+PT83yHE5ahzA2SnSv2KKp3LbOKGKTMoQvwDqC/ZtXtg5
         mVLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcpgNp/iTPvxAO34+IExV60gF/WRnYK3stl1IhQV6wQycawpvPgLfKX8B8Q7T5GFXdTdMh8lVb5DA9tcBcmGZhvY7P
X-Gm-Message-State: AOJu0Yz8CvHjfVyheBvbEjMaQKt5WvWcsFMHPAMmDX1vpIVZxEYTSHVH
	TShcgd2SPT1j4Xp3kdnzG6NeGcgfVVGsltyxNc+paeZV47uh19sOXsdXdTQxkTMzLOuEuPjL8Ew
	acoRJENkpGBCSHHe41g==
X-Google-Smtp-Source: AGHT+IFlbCwOv7FcHHPSyN/4LSWSns0pNrKnm/Gh8fQ5E5vmLdKRE2NJsut+pxEH6Bu3xVJUKO8eEZSj9XJO7SkF
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a0d:ff85:0:b0:665:7b0d:ed27 with SMTP
 id 00721157ae682-672bcb1f07cmr141337b3.2.1721783474906; Tue, 23 Jul 2024
 18:11:14 -0700 (PDT)
Date: Wed, 24 Jul 2024 01:10:27 +0000
In-Reply-To: <20240724011037.3671523-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240724011037.3671523-3-jthoughton@google.com>
Subject: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Walk the TDP MMU in an RCU read-side critical section. This requires a
way to do RCU-safe walking of the tdp_mmu_roots; do this with a new
macro. The PTE modifications are now done atomically, and
kvm_tdp_mmu_spte_need_atomic_write() has been updated to account for the
fact that kvm_age_gfn can now lockless update the accessed bit and the
R/X bits).

If the cmpxchg for marking the spte for access tracking fails, we simply
retry if the spte is still a leaf PTE. If it isn't, we return false
to continue the walk.

Harvesting age information from the shadow MMU is still done while
holding the MMU write lock.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          | 10 ++++-
 arch/x86/kvm/mmu/tdp_iter.h     | 27 +++++++------
 arch/x86/kvm/mmu/tdp_mmu.c      | 67 +++++++++++++++++++++++++--------
 5 files changed, 77 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..096988262005 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1456,6 +1456,7 @@ struct kvm_arch {
 	 * tdp_mmu_page set.
 	 *
 	 * For reads, this list is protected by:
+	 *	RCU alone or
 	 *	the MMU lock in read mode + RCU or
 	 *	the MMU lock in write mode
 	 *
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 4287a8071a3a..6ac43074c5e9 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -23,6 +23,7 @@ config KVM
 	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..7b93ce8f0680 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1633,8 +1633,11 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm))
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1646,8 +1649,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm))
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..510936a8455a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -25,6 +25,13 @@ static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_ptep_t sptep, u64 new_spte)
 	return xchg(rcu_dereference(sptep), new_spte);
 }
 
+static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64 mask)
+{
+	atomic64_t *sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
+
+	return (u64)atomic64_fetch_and(~mask, sptep_atomic);
+}
+
 static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 {
 	KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
@@ -32,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 }
 
 /*
- * SPTEs must be modified atomically if they are shadow-present, leaf
- * SPTEs, and have volatile bits, i.e. has bits that can be set outside
- * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
- * handler, and Accessed and Dirty bits can be set by the CPU.
+ * SPTEs must be modified atomically if they have bits that can be set outside
+ * of the mmu_lock. This can happen for any shadow-present leaf SPTEs, as the
+ * Writable bit can be set by KVM's fast page fault handler, the Accessed and
+ * Dirty bits can be set by the CPU, and the Accessed and R/X bits can be
+ * cleared by age_gfn_range.
  *
  * Note, non-leaf SPTEs do have Accessed bits and those bits are
  * technically volatile, but KVM doesn't consume the Accessed bit of
@@ -46,8 +54,7 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, int level)
 {
 	return is_shadow_present_pte(old_spte) &&
-	       is_last_spte(old_spte, level) &&
-	       spte_has_volatile_bits(old_spte);
+	       is_last_spte(old_spte, level);
 }
 
 static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
@@ -63,12 +70,8 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
 static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte,
 					  u64 mask, int level)
 {
-	atomic64_t *sptep_atomic;
-
-	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
-		sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
-		return (u64)atomic64_fetch_and(~mask, sptep_atomic);
-	}
+	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
+		return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
 
 	__kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
 	return old_spte;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c7dc49ee7388..3f13b2db53de 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -29,6 +29,11 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 
 	return true;
 }
+static __always_inline bool kvm_lockdep_assert_rcu_read_lock_held(void)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return true;
+}
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
@@ -178,6 +183,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		     ((_only_valid) && (_root)->role.invalid))) {		\
 		} else
 
+/*
+ * Iterate over all TDP MMU roots in an RCU read-side critical section.
+ */
+#define for_each_tdp_mmu_root_rcu(_kvm, _root, _as_id)				\
+	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)		\
+		if (kvm_lockdep_assert_rcu_read_lock_held() &&			\
+		    (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id)) {	\
+		} else
+
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
 	__for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
 
@@ -1224,6 +1238,27 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	return ret;
 }
 
+static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
+		struct kvm *kvm,
+		struct kvm_gfn_range *range,
+		tdp_handler_t handler)
+{
+	struct kvm_mmu_page *root;
+	struct tdp_iter iter;
+	bool ret = false;
+
+	rcu_read_lock();
+
+	for_each_tdp_mmu_root_rcu(kvm, root, range->slot->as_id) {
+		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+			ret |= handler(kvm, &iter, range);
+	}
+
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
@@ -1237,28 +1272,30 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 {
 	u64 new_spte;
 
+retry:
 	/* If we have a non-accessed entry we don't need to change the pte. */
 	if (!is_accessed_spte(iter->old_spte))
 		return false;
 
 	if (spte_ad_enabled(iter->old_spte)) {
-		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
-							 iter->old_spte,
-							 shadow_accessed_mask,
-							 iter->level);
+		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
+						shadow_accessed_mask);
 		new_spte = iter->old_spte & ~shadow_accessed_mask;
 	} else {
-		/*
-		 * Capture the dirty status of the page, so that it doesn't get
-		 * lost when the SPTE is marked for access tracking.
-		 */
+		new_spte = mark_spte_for_access_track(iter->old_spte);
+		if (__tdp_mmu_set_spte_atomic(iter, new_spte)) {
+			/*
+			 * The cmpxchg failed. If the spte is still a
+			 * last-level spte, we can safely retry.
+			 */
+			if (is_shadow_present_pte(iter->old_spte) &&
+			    is_last_spte(iter->old_spte, iter->level))
+				goto retry;
+			/* Otherwise, continue walking. */
+			return false;
+		}
 		if (is_writable_pte(iter->old_spte))
 			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
-
-		new_spte = mark_spte_for_access_track(iter->old_spte);
-		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
-							iter->old_spte, new_spte,
-							iter->level);
 	}
 
 	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
@@ -1268,7 +1305,7 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
+	return kvm_tdp_mmu_handle_gfn_lockless(kvm, range, age_gfn_range);
 }
 
 static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
@@ -1279,7 +1316,7 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
+	return kvm_tdp_mmu_handle_gfn_lockless(kvm, range, test_age_gfn);
 }
 
 /*
-- 
2.46.0.rc1.232.g9752f9e123-goog


