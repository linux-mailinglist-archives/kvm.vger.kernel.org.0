Return-Path: <kvm+bounces-51709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A6DAFBE5E
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 00:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70BB97A1600
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A16C2DBF6E;
	Mon,  7 Jul 2025 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V5ZJxOwQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85364290BC8
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 22:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751928513; cv=none; b=Sz8/XwJQ8ozRtUGmLYiVt2b6nz3/Jg1HZm1+AA6Oc6XfEnJhiZ4lR0EY214yTvs7sHA0GrnLhbttPgDwDrGUkRR6bYRZ8dX45oKpDxyftAHfLf0LFClhqfYbBsRh5UexSlzGo2oVYwB4Mi1aVO6EfVlOq+OXtMKTQgh2b3sL0B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751928513; c=relaxed/simple;
	bh=KFY76OztoaGgvyZYSEG+X1NnOeAiy/PXyOHQTfSj98A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tliKhYHY7eHpFJdpmf/gLSS2KeJr/kcX17zXB+hPJ99a8l46IpK0FA8ZS2fAVnCJZq0mKS7TU1SA+/XgcxTJMcc8gRXqz6Ib6KaZPJx4/86a8ov2iswAkdS4c7jFC2zPmNh7mRRfNP+6ZNfEq9PvFyXwC3jr1Tc0MgQuHn/Nq0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V5ZJxOwQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31315427249so3359140a91.1
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 15:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751928511; x=1752533311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=63YuRp5JRiwz35F008n7xPw4ISE7/+YautHrLsfI/AY=;
        b=V5ZJxOwQe35lKdnbVE6tdAIyQjtajF9E/yX9UP49adaLs6NmowpPzbIlodaE13Ra26
         qf/oi93+m1Ni/N2gSpfF7i7FdA6RND88xhdoBHPgvK9oE5RKfIorrSb4KGN8cUI0Ngh5
         0neh2IpAgkQxJlaB8bOS2Y5QZfNZ0bLfTcWs/CtvI1kaWJ5gIvMiPOhmBkrwq1YNAwi+
         qAj/sI/oG0GDFyjQAca1Im2GShYONqXUjR29t4DHtautB3HAOGg12d/xUyoamr9Li7M6
         IGHO6zDD2S9hf5MrfDMeUJefubF6UO8x74oIP2pdbG3bY15FJp467hOEpRzKJdnw4ysl
         xHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751928511; x=1752533311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=63YuRp5JRiwz35F008n7xPw4ISE7/+YautHrLsfI/AY=;
        b=gbSQ8do0I2hGWZ79rdNP0jQbm6CqPL4saecxxtO8tWSmhBqKb5xAv7R5UE5DJEaqH6
         VwlcQmgIRWhvXiI6Tis7suDcYaXznAy8rSQtvNWyoSil859ibY/N6VCWjNrciRsc05jA
         MifYoEH4n/jWbZ2o8fW28kLE56tMBMXCUGr4hCQWukyiVSUP9v0AgiKbVde8k7IoM305
         +LB72P7pWVBbJFQ6gTSTH2H24HGUGmSwubaec5w05qfOAbY6IhJ0Bi9A1LN9ZVlfzx8+
         Yg9MDG5nyVVdzuEQ7wcGOibR+b0WUYcvdWISMWflU2NO/4nRGYrTjyvUAzG1GrJSJrDr
         uB3g==
X-Forwarded-Encrypted: i=1; AJvYcCXxxdQLBzf5P439jabKXbV4pDTh+85wsw/XcErIW+E4wmXhptzFg/yncZtqZehLAoikYoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxTe/hcLtDX+FWNCNSkmgOe9KM6ObqlmL7gmF6gb1q+hrHhBoo
	XLoWT7vI5V72kVcq16TmviRwdcUDIW8wexOirE9nC52U7DuEa9xdMeS2uNHY2IpBZkVYSVHp0ZL
	16+Ovp/6xRG31okZJMhv2bQ==
X-Google-Smtp-Source: AGHT+IHxgvuCz+16e1Vy1aMt3tccVzSt8BxJwVfzCWxpal0itppps/QWpBJVHuH2Lc6fEpwuD0QBu1nc3HmAlTF5
X-Received: from pjbsv15.prod.google.com ([2002:a17:90b:538f:b0:311:46e:8c26])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:48c8:b0:311:c5d9:2c7c with SMTP id 98e67ed59e1d1-31c21de8312mr746959a91.23.1751928510684;
 Mon, 07 Jul 2025 15:48:30 -0700 (PDT)
Date: Mon,  7 Jul 2025 22:47:16 +0000
In-Reply-To: <20250707224720.4016504-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250707224720.4016504-4-jthoughton@google.com>
Subject: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU
 read lock
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Vipin Sharma <vipinsh@google.com>

Use MMU read lock to recover TDP MMU NX huge pages. Iterate
over the huge pages list under tdp_mmu_pages_lock protection and
unaccount the page before dropping the lock.

We must not zap an SPTE if:
- The SPTE is a root page.
- The SPTE does not point at the SP's page table.

If the SPTE does not point at the SP's page table, then something else
has change the SPTE, so we cannot safely zap it.

Warn if zapping SPTE fails and current SPTE is still pointing to same
page table. This should never happen.

There is always a race between dirty logging, vCPU faults, and NX huge
page recovery for backing a gfn by an NX huge page or an executable
small page. Unaccounting sooner during the list traversal is increasing
the window of that race. Functionally, it is okay, because accounting
doesn't protect against iTLB multi-hit bug, it is there purely to
prevent KVM from bouncing a gfn between two page sizes. The only
downside is that a vCPU will end up doing more work in tearing down all
the child SPTEs. This should be a very rare race.

Zapping under MMU read lock unblocks vCPUs which are waiting for MMU
read lock. This optimizaion is done to solve a guest jitter issue on
Windows VM which was observing an increase in network latency.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: James Houghton <jthoughton@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 107 ++++++++++++++++++++++++-------------
 arch/x86/kvm/mmu/tdp_mmu.c |  42 ++++++++++++---
 2 files changed, 105 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b074f7bb5cc58..7df1b4ead705b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7535,12 +7535,40 @@ static unsigned long nx_huge_pages_to_zap(struct kvm *kvm,
 	return ratio ? DIV_ROUND_UP(pages, ratio) : 0;
 }
 
+static bool kvm_mmu_sp_dirty_logging_enabled(struct kvm *kvm,
+					     struct kvm_mmu_page *sp)
+{
+	struct kvm_memory_slot *slot = NULL;
+
+	/*
+	 * Since gfn_to_memslot() is relatively expensive, it helps to skip it if
+	 * it the test cannot possibly return true.  On the other hand, if any
+	 * memslot has logging enabled, chances are good that all of them do, in
+	 * which case unaccount_nx_huge_page() is much cheaper than zapping the
+	 * page.
+	 *
+	 * If a memslot update is in progress, reading an incorrect value of
+	 * kvm->nr_memslots_dirty_logging is not a problem: if it is becoming
+	 * zero, gfn_to_memslot() will be done unnecessarily; if it is becoming
+	 * nonzero, the page will be zapped unnecessarily.  Either way, this only
+	 * affects efficiency in racy situations, and not correctness.
+	 */
+	if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
+		struct kvm_memslots *slots;
+
+		slots = kvm_memslots_for_spte_role(kvm, sp->role);
+		slot = __gfn_to_memslot(slots, sp->gfn);
+		WARN_ON_ONCE(!slot);
+	}
+	return slot && kvm_slot_dirty_track_enabled(slot);
+}
+
 static void kvm_recover_nx_huge_pages(struct kvm *kvm,
-				      enum kvm_mmu_type mmu_type)
+				      const enum kvm_mmu_type mmu_type)
 {
 	unsigned long to_zap = nx_huge_pages_to_zap(kvm, mmu_type);
+	bool is_tdp_mmu = mmu_type == KVM_TDP_MMU;
 	struct list_head *nx_huge_pages;
-	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
@@ -7549,7 +7577,10 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 	nx_huge_pages = &kvm->arch.possible_nx_huge_pages[mmu_type].pages;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
-	write_lock(&kvm->mmu_lock);
+	if (is_tdp_mmu)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 
 	/*
 	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
@@ -7559,8 +7590,17 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 	rcu_read_lock();
 
 	for ( ; to_zap; --to_zap) {
-		if (list_empty(nx_huge_pages))
+#ifdef CONFIG_X86_64
+		if (is_tdp_mmu)
+			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+#endif
+		if (list_empty(nx_huge_pages)) {
+#ifdef CONFIG_X86_64
+			if (is_tdp_mmu)
+				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+#endif
 			break;
+		}
 
 		/*
 		 * We use a separate list instead of just using active_mmu_pages
@@ -7575,50 +7615,40 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
 		WARN_ON_ONCE(!sp->role.direct);
 
+		unaccount_nx_huge_page(kvm, sp);
+
+#ifdef CONFIG_X86_64
+		if (is_tdp_mmu)
+			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+#endif
+
 		/*
-		 * Unaccount and do not attempt to recover any NX Huge Pages
-		 * that are being dirty tracked, as they would just be faulted
-		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
-		 * recovered, along with all the other huge pages in the slot,
-		 * when dirty logging is disabled.
-		 *
-		 * Since gfn_to_memslot() is relatively expensive, it helps to
-		 * skip it if it the test cannot possibly return true.  On the
-		 * other hand, if any memslot has logging enabled, chances are
-		 * good that all of them do, in which case unaccount_nx_huge_page()
-		 * is much cheaper than zapping the page.
-		 *
-		 * If a memslot update is in progress, reading an incorrect value
-		 * of kvm->nr_memslots_dirty_logging is not a problem: if it is
-		 * becoming zero, gfn_to_memslot() will be done unnecessarily; if
-		 * it is becoming nonzero, the page will be zapped unnecessarily.
-		 * Either way, this only affects efficiency in racy situations,
-		 * and not correctness.
+		 * Do not attempt to recover any NX Huge Pages that are being
+		 * dirty tracked, as they would just be faulted back in as 4KiB
+		 * pages. The NX Huge Pages in this slot will be recovered,
+		 * along with all the other huge pages in the slot, when dirty
+		 * logging is disabled.
 		 */
-		slot = NULL;
-		if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
-			struct kvm_memslots *slots;
+		if (!kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
+			if (is_tdp_mmu)
+				flush |= kvm_tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
+			else
+				kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 
-			slots = kvm_memslots_for_spte_role(kvm, sp->role);
-			slot = __gfn_to_memslot(slots, sp->gfn);
-			WARN_ON_ONCE(!slot);
 		}
 
-		if (slot && kvm_slot_dirty_track_enabled(slot))
-			unaccount_nx_huge_page(kvm, sp);
-		else if (mmu_type == KVM_TDP_MMU)
-			flush |= kvm_tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
-		else
-			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 			rcu_read_unlock();
 
-			cond_resched_rwlock_write(&kvm->mmu_lock);
-			flush = false;
+			if (is_tdp_mmu)
+				cond_resched_rwlock_read(&kvm->mmu_lock);
+			else
+				cond_resched_rwlock_write(&kvm->mmu_lock);
 
+			flush = false;
 			rcu_read_lock();
 		}
 	}
@@ -7626,7 +7656,10 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 
 	rcu_read_unlock();
 
-	write_unlock(&kvm->mmu_lock);
+	if (is_tdp_mmu)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 19907eb04a9c4..31d921705dee7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -928,21 +928,49 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 bool kvm_tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
 					   struct kvm_mmu_page *sp)
 {
-	u64 old_spte;
+	struct tdp_iter iter = {
+		.old_spte = sp->ptep ? kvm_tdp_mmu_read_spte(sp->ptep) : 0,
+		.sptep = sp->ptep,
+		.level = sp->role.level + 1,
+		.gfn = sp->gfn,
+		.as_id = kvm_mmu_page_as_id(sp),
+	};
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	if (WARN_ON_ONCE(!is_tdp_mmu_page(sp)))
+		return false;
 
 	/*
-	 * This helper intentionally doesn't allow zapping a root shadow page,
-	 * which doesn't have a parent page table and thus no associated entry.
+	 * Root shadow pages don't have a parent page table and thus no
+	 * associated entry, but they can never be possible NX huge pages.
 	 */
 	if (WARN_ON_ONCE(!sp->ptep))
 		return false;
 
-	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
-	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
+	/*
+	 * Since mmu_lock is held in read mode, it's possible another task has
+	 * already modified the SPTE. Zap the SPTE if and only if the SPTE
+	 * points at the SP's page table, as checking shadow-present isn't
+	 * sufficient, e.g. the SPTE could be replaced by a leaf SPTE, or even
+	 * another SP. Note, spte_to_child_pt() also checks that the SPTE is
+	 * shadow-present, i.e. guards against zapping a frozen SPTE.
+	 */
+	if ((tdp_ptep_t)sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
 		return false;
 
-	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
-			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
+	/*
+	 * If a different task modified the SPTE, then it should be impossible
+	 * for the SPTE to still be used for the to-be-zapped SP. Non-leaf
+	 * SPTEs don't have Dirty bits, KVM always sets the Accessed bit when
+	 * creating non-leaf SPTEs, and all other bits are immutable for non-
+	 * leaf SPTEs, i.e. the only legal operations for non-leaf SPTEs are
+	 * zapping and replacement.
+	 */
+	if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE)) {
+		WARN_ON_ONCE((tdp_ptep_t)sp->spt == spte_to_child_pt(iter.old_spte, iter.level));
+		return false;
+	}
 
 	return true;
 }
-- 
2.50.0.727.gbf7dc18ff4-goog


