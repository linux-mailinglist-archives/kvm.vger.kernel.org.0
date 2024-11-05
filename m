Return-Path: <kvm+bounces-30776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8999BD536
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:47:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA4941C2273A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96F61F4FC6;
	Tue,  5 Nov 2024 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kHW6y1S0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0201EF0A9
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832229; cv=none; b=Dkb8ocOHh+V0llw1xy3Eysqwk0F80pNXW10g1r+8u/8+588X3VdJh+pH/vQiqfBDbqak/+E1Gad/JP6La6c8a+VXnw+gPHvTvFTTJOZoDyuql8Wj829qk9RX51GA9XVRJ21CYi/NaAuFG3Tup3Gz7IYLaYqGOpZjiA6b8HSqCRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832229; c=relaxed/simple;
	bh=rGtastp5MUVjDZjrcFpzQhgzR3WKxIrGkFIwnsizN4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kzzXrLMhyAbk0SvY2S/l3WQYxQnCTDK7F/YMzrcCU2yXmD5qujwSDjWc4bwBsXHm6xMTCuMFwwqr8xKW2PhmuVjFvz2E5eihGzJPs4au1qMDRdXGm1oy9PCsm5Ztf0tmIeBVH21EhMgYDWrUnnzskd0/xxzE14C8HJeQmqfQW0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kHW6y1S0; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e28fc8902e6so10650696276.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832227; x=1731437027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q/zpmmxBLNRk9p52ALn0nSRYK7DaOpkC3JwFDj1wmZI=;
        b=kHW6y1S0/yUuIDu8VsV94vgNPGy075vDWiOJPb3qJon6Y9ZHyCStnfKOjvc0THAYJ7
         cs8bmpUD6on66Gt3xeSQ2lIbhVyD9N7q/By9nDZif7ff+4VFV8v6rP8T3S0dZrMo7hg0
         FeJ24cxXlKP7/KwL4UvMrqDEyJmRSJLBMxZy4kEoqpSNmesDVfQJbjdqId+5bfP1BRJ3
         YyJY/Dg71qm5oFyYnoudWJ88hys9avuFRa5kPpYOV9VRSCFvapOndl1LAsfhfbtsgLT1
         c/BZ8VTbfAyBNBXb8GKwxhZ3gsJ0U2jEk8lwTZohQAFPZxnQ1w/qqpoU0d9TYTkTEPLN
         1qfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832227; x=1731437027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q/zpmmxBLNRk9p52ALn0nSRYK7DaOpkC3JwFDj1wmZI=;
        b=VQsT4ZjDdRDFrqWKaGB7JrFFc8RbZ1QfvRGpwLysPaLeu/2RXbzUTYSn9hbyJRa+nu
         lGrN737+Yc45Lt1snbqe3urxH6b5wMCMDt9vGFTgh+IfIDfuvZ6TXBXCpaxxtb47TYOO
         xmhqnE0eMYtXKK2wspTzqL3weRKCN4d3cqF/JdCqffwtLxk6MqiOOwEoRDdDo1bcE3d+
         zLZrNJtZsMc2FcQrmiagMDbW3GqpoLA141TJZqyi3dKfLKh1qLMcKVA+KXUGRqx88b0b
         IQUFKVi8s4pcbmUn9+GA7ATZi1Kq0+zFl+D7aKmsgRuy0Uc9M9yPXpO/YZh+VQhyPyHW
         c1zQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd6+kE9rbCGjP5wxAlAsr9AIl2Xbwm1C2tjPbzJhNzSnGjmoCcoXuXRM2xOzAC7mYHg8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YycIvACCzwFPWFBYmCSmtAWTOpJGC/G+X8c5V+EXWAuMHpijKI/
	bXofbfZCgIiPnnJV5AZyaiSMsZxX2Gnf05IGXlA7NSnXPIhEpNP8v1kXjnzVuu8tw4mPioCA6zl
	p57w1BDg5KtsG3RPfIA==
X-Google-Smtp-Source: AGHT+IFa1K4sYqOl+dXQ0E88Fydq2dUpDP40xAUJNd8RbWVqJfYPpP7dUIrWr/dF77HO82K1mA4Eg4a/ON1+iLKE
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a25:83c3:0:b0:e30:c79e:16bc with SMTP
 id 3f1490d57ef6-e30c79e1861mr26074276.8.1730832226917; Tue, 05 Nov 2024
 10:43:46 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:26 +0000
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-5-jthoughton@google.com>
Subject: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn and kvm_age_gfn
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
do this with a new macro. The PTE modifications are now done atomically,
and kvm_tdp_mmu_spte_need_atomic_write() has been updated to account for
the fact that kvm_age_gfn can now locklessly update the accessed bit and
the W/R/X bits).

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
 arch/x86/kvm/mmu/mmu.c          | 10 ++++++++--
 arch/x86/kvm/mmu/tdp_iter.h     | 12 ++++++------
 arch/x86/kvm/mmu/tdp_mmu.c      | 23 ++++++++++++++++-------
 5 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70c7ed0ef184..84ee08078686 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1455,6 +1455,7 @@ struct kvm_arch {
 	 * tdp_mmu_page set.
 	 *
 	 * For reads, this list is protected by:
+	 *	RCU alone or
 	 *	the MMU lock in read mode + RCU or
 	 *	the MMU lock in write mode
 	 *
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 1ed1e4f5d51c..97f747d60fe9 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -23,6 +23,7 @@ config KVM_X86
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
+	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 443845bb2e01..26797ccd34d8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1586,8 +1586,11 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
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
@@ -1599,8 +1602,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
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
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index a24fca3f9e7f..f26d0b60d2dd 100644
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
@@ -53,8 +54,7 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, int level)
 {
 	return is_shadow_present_pte(old_spte) &&
-	       is_last_spte(old_spte, level) &&
-	       spte_has_volatile_bits(old_spte);
+	       is_last_spte(old_spte, level);
 }
 
 static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4508d868f1cd..f5b4f1060fff 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -178,6 +178,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		     ((_only_valid) && (_root)->role.invalid))) {		\
 		} else
 
+/*
+ * Iterate over all TDP MMU roots in an RCU read-side critical section.
+ */
+#define for_each_valid_tdp_mmu_root_rcu(_kvm, _root, _as_id)			\
+	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)		\
+		if ((_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) ||	\
+		    (_root)->role.invalid) {					\
+		} else
+
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
 	__for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
 
@@ -1168,16 +1177,16 @@ static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
 	u64 new_spte;
 
 	if (spte_ad_enabled(iter->old_spte)) {
-		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
-							 iter->old_spte,
-							 shadow_accessed_mask,
-							 iter->level);
+		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
+						shadow_accessed_mask);
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
+		(void)__tdp_mmu_set_spte_atomic(iter, new_spte);
 	}
 
 	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
-- 
2.47.0.199.ga7371fff76-goog


