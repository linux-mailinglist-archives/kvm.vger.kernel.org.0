Return-Path: <kvm+bounces-37195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 084E5A268BA
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:42:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 014727A3195
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73931411EB;
	Tue,  4 Feb 2025 00:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YYF2yOB4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EAD78C9C
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629661; cv=none; b=ms3ISQbl4rohdminlzjjAEtXyAa9IYqUUREaTUhrAELRtKh+CzqNY0SDfVNuYXY9MW71RZ2TmJJdasphflYiKJgltOP+XWStHn8sAOPTGbhO1Qw8x1MRchv12Ls+ZpHwcoGJgrhdBiROPtq9mUU9ws6e8DtVJ6XDgZ3AJ97e2VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629661; c=relaxed/simple;
	bh=bX2/w7UmvLEkOahma7kREuSvI6Ls5tXqD4E2HIZYIY0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cXyUUcU8f0cayvPsq+n3ty9IbBFz1ccTZVQhsq8TyBGH7eWjz2pWavbd5tQTtTrhPWH1i/unVRAKziBRpIhm4533Sd/59zsV7DEFu+d+Ny62Kofas1k7djdy2VasA/g9YNwQbt3QcBl5IcIil5sHlPkrimlJU4rUg4o2RlenZso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YYF2yOB4; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-7b864496708so1484420285a.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629658; x=1739234458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gwfNdavV7e4Rb86VqYhaSGV1yuPDe9C0uBkRmAorJGI=;
        b=YYF2yOB4yolatRddZmhZOuX+14I5uHozwCWJH97qfs0z7ja7LIEHR41MJzUnEry8Ni
         lVeBX/ZUowXN8/p7GuxnNG55s4r5lHBi8cK2wRGzNa2hIAQQQJ+nlt/roeg97YrJjSOW
         Ng0QfxyXXH3GWivoKCZNfTxw3uux1hKeOvFN3OULphm4OkC/QIEqd0XhSdAFSQyUnCHf
         ntX45QVg82wusS6Po7phWX3dsSAjJxzzf7gHkI5MCKvEObiT+eE7Fp1XbAA/l4LohRoZ
         nceWmb3/I/XwuWRCErO0yrC+OeJ+BjXnKh/PHBoBdzpgG1Hk4598Xs48Jx00lZfihFDl
         bLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629658; x=1739234458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gwfNdavV7e4Rb86VqYhaSGV1yuPDe9C0uBkRmAorJGI=;
        b=djsO1r7TZGaRSlKmlN8Ziy/Rk2bIWYeGD820p7d2L5f0iAiG6gdam4AYgiuLxFuygi
         J5DCoeUKBJBlV7pKDASELJSwoIlzDwxEv25+1jxR4/09WBasVUNwzGdYl8rCNYVyr1/T
         MbvG36sJRKQlzlGZMdnzAfZSztg/5cHMD6NxKPKo9pAMOjXspjo2jOfpsqL+FeqB1O0w
         Wv4YvZF21BpUX/0+vmQ+CSW2nqkw39JMMnJ1cqNwwVDG9OyOtZ9Tvsc2tsvRC0FYJa99
         5vnXSGrP0kMBVFjG6GEb55qOXG8E4hvBHKOWqOWeyT6OjhE277kVISceML0of2PvrTdE
         eJdw==
X-Forwarded-Encrypted: i=1; AJvYcCWvwXKe6UT0rx80Elvafle66XkoPFVlUbZ1YsU1EBj2iUEZMDu7cziWeCBVz8B+P3yfpJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpjdylkXtNHuzAKt86ZDJL5lu8Lg6QCK2PhFVAd39q+a2ghVXb
	f9fVCeUVE71XRAl4ZiNhfp4lQGJG5+P20q7AtndLp6A8K98dnYVjjKQzmaluFzpESQdMD+UaQhK
	QMNl5jwmDd4htIN9u+w==
X-Google-Smtp-Source: AGHT+IGeok83Q9IAnky23jRFLjinK54hMup/gDbGN0jTr0epHOw3qamViOu7KianemfptLmTnNVDBCnVR1genjs+
X-Received: from qknpr12.prod.google.com ([2002:a05:620a:86cc:b0:7bc:dee1:94a3])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:bcb:b0:7af:c60b:5acf with SMTP id af79cd13be357-7bffccbfc15mr3017337685a.10.1738629658570;
 Mon, 03 Feb 2025 16:40:58 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:31 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-5-jthoughton@google.com>
Subject: [PATCH v9 04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn()
 and kvm_age_gfn()
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Walk the TDP MMU in an RCU read-side critical section without holding
mmu_lock when harvesting and potentially updating age information on
sptes. This requires a way to do RCU-safe walking of the tdp_mmu_roots;
do this with a new macro. The PTE modifications are now always done
atomically.

spte_has_volatile_bits() no longer checks for Accessed bit at all. It
can (now) be set and cleared without taking the mmu_lock, but dropping
Accessed bit updates is already tolerated (the TLB is not invalidated
after clearing the Accessed bit).

If the cmpxchg for marking the spte for access tracking fails, leave it
as is and treat it as if it were young, as if the spte is being actively
modified, it is most likely young.

Harvesting age information from the shadow MMU is still done while
holding the MMU write lock.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          | 10 +++++++--
 arch/x86/kvm/mmu/spte.c         | 10 +++++++--
 arch/x86/kvm/mmu/tdp_iter.h     |  9 +++++----
 arch/x86/kvm/mmu/tdp_mmu.c      | 36 +++++++++++++++++++++++----------
 6 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f378cd43241c..0e44fc1cec0d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1479,6 +1479,7 @@ struct kvm_arch {
 	 * tdp_mmu_page set.
 	 *
 	 * For reads, this list is protected by:
+	 *	RCU alone or
 	 *	the MMU lock in read mode + RCU or
 	 *	the MMU lock in write mode
 	 *
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ea2c4f21c1ca..f0a60e59c884 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,6 +22,7 @@ config KVM_X86
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
+	select KVM_MMU_NOTIFIER_AGING_LOCKLESS
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a45ae60e84ab..7779b49f386d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1592,8 +1592,11 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm))
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
 		young = kvm_rmap_age_gfn_range(kvm, range, false);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1605,8 +1608,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm))
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
 		young = kvm_rmap_age_gfn_range(kvm, range, true);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 22551e2f1d00..e984b440c0f0 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -142,8 +142,14 @@ bool spte_has_volatile_bits(u64 spte)
 		return true;
 
 	if (spte_ad_enabled(spte)) {
-		if (!(spte & shadow_accessed_mask) ||
-		    (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
+		/*
+		 * Do not check the Accessed bit. It can be set (by the CPU)
+		 * and cleared (by kvm_tdp_mmu_age_spte()) without holding
+		 * the mmu_lock, but when clearing the Accessed bit, we do
+		 * not invalidate the TLB, so we can already miss Accessed bit
+		 * updates.
+		 */
+		if (is_writable_pte(spte) && !(spte & shadow_dirty_mask))
 			return true;
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 9135b035fa40..05e9d678aac9 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -39,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 }
 
 /*
- * SPTEs must be modified atomically if they are shadow-present, leaf
- * SPTEs, and have volatile bits, i.e. has bits that can be set outside
- * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
- * handler, and Accessed and Dirty bits can be set by the CPU.
+ * SPTEs must be modified atomically if they have bits that can be set outside
+ * of the mmu_lock. This can happen for any shadow-present leaf SPTEs, as the
+ * Writable bit can be set by KVM's fast page fault handler, the Accessed and
+ * Dirty bits can be set by the CPU, and the Accessed and W/R/X bits can be
+ * cleared by age_gfn_range().
  *
  * Note, non-leaf SPTEs do have Accessed bits and those bits are
  * technically volatile, but KVM doesn't consume the Accessed bit of
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 046b6ba31197..c9778c3e6ecd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -193,6 +193,19 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		     !tdp_mmu_root_match((_root), (_types)))) {			\
 		} else
 
+/*
+ * Iterate over all TDP MMU roots in an RCU read-side critical section.
+ * It is safe to iterate over the SPTEs under the root, but their values will
+ * be unstable, so all writes must be atomic. As this routine is meant to be
+ * used without holding the mmu_lock at all, any bits that are flipped must
+ * be reflected in kvm_tdp_mmu_spte_need_atomic_write().
+ */
+#define for_each_tdp_mmu_root_rcu(_kvm, _root, _as_id, _types)			\
+	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)		\
+		if ((_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) ||	\
+		    !tdp_mmu_root_match((_root), (_types))) {			\
+		} else
+
 #define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
 	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_VALID_ROOTS)
 
@@ -1332,21 +1345,22 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
  * from the clear_young() or clear_flush_young() notifier, which uses the
  * return value to determine if the page has been accessed.
  */
-static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
+static void kvm_tdp_mmu_age_spte(struct kvm *kvm, struct tdp_iter *iter)
 {
 	u64 new_spte;
 
 	if (spte_ad_enabled(iter->old_spte)) {
-		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
-							 iter->old_spte,
-							 shadow_accessed_mask,
-							 iter->level);
+		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
+								shadow_accessed_mask);
 		new_spte = iter->old_spte & ~shadow_accessed_mask;
 	} else {
 		new_spte = mark_spte_for_access_track(iter->old_spte);
-		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
-							iter->old_spte, new_spte,
-							iter->level);
+		/*
+		 * It is safe for the following cmpxchg to fail. Leave the
+		 * Accessed bit set, as the spte is most likely young anyway.
+		 */
+		if (__tdp_mmu_set_spte_atomic(kvm, iter, new_spte))
+			return;
 	}
 
 	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
@@ -1371,9 +1385,9 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
 	 * valid roots!
 	 */
 	WARN_ON(types & ~KVM_VALID_ROOTS);
-	__for_each_tdp_mmu_root(kvm, root, range->slot->as_id, types) {
-		guard(rcu)();
 
+	guard(rcu)();
+	for_each_tdp_mmu_root_rcu(kvm, root, range->slot->as_id, types) {
 		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end) {
 			if (!is_accessed_spte(iter.old_spte))
 				continue;
@@ -1382,7 +1396,7 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
 				return true;
 
 			ret = true;
-			kvm_tdp_mmu_age_spte(&iter);
+			kvm_tdp_mmu_age_spte(kvm, &iter);
 		}
 	}
 
-- 
2.48.1.362.g079036d154-goog


