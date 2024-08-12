Return-Path: <kvm+bounces-23872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF5494F5B1
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 19:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB322282987
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 17:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD0018952D;
	Mon, 12 Aug 2024 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rB5ritOe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EC7187874
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 17:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482841; cv=none; b=QxoJOTzPf2HRepGW0BUcPOlJx1rJlsShy8RXxAw4orVFJZvnfu+zkMP6KRw605M+ugP3vN6IKbe4gqR8CoHKwaSPr4DaWB4J8cxxUpfquCfyDLUyUWDPUZmqt5YQDoZ0HBHCjQ4ofUatr2pteMIm8JZYsvt73GABvjNJ4d8c7mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482841; c=relaxed/simple;
	bh=tbXsad/z3mZiZfCLnrY3/b5eM02K1ySPKdXXYzGmMXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pXE2ukRj94Yh5sFSU3PT/l7vNT+wzjKccX6vQkvWS5HuBOluUH9DZDoijAw01N8b35ALidYxsm45UwAZYPc8fZ5LvgaKSNM8B0mZE6mCfls9pjzLqiLLI6Z1EuDHUTWtWtVxRERaEtPQbYmyhg558FJXy4GUdCkZSnknjpFOf+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rB5ritOe; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a2a04c79b6so4585840a12.0
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 10:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723482838; x=1724087638; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X7zexYQ9nOcrm8eOvumJW9tuoCHDjhCFQCssKDFI5Ro=;
        b=rB5ritOesRi5dMPnKzYUgch6/D1YgIWlZRt2qCwKLdaH+A4HpPob65e5Vy0ehpEzD0
         zpiy5pATkiQa3lDQaIlyc9El0YsbhNIUb6nl1SRIiNPH0mzGst2bdGkunSW5Vw0ssaNx
         /rhi49M+tXQ3reiAuk93n1gRRqg5fAgh0TG6P0wtKo14YA2D7fQCDczbkQcaggYwEUOm
         lOh508wUceyRtEbwqACdci6iAaA4W/u2D7zUMyTqWLMdjmol60/tCWZ42ijUC0ZT5gid
         3SqzNMj4t+VuN/RJncD2/PXQdF409Fse/+Ops8TgiwDxEeHQtiVmV8fvIhi1Je+Ck8/L
         wR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723482838; x=1724087638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7zexYQ9nOcrm8eOvumJW9tuoCHDjhCFQCssKDFI5Ro=;
        b=hClGpq6Y8JYrQizIdkJDc6mLn6J6pkSw9DE/wPiyrjsCFK4FZU0Sd8EE7ih3AMU2uo
         TYQEq9eBqBWcF8KxD+hm9IQgqz8dZim+Z9g9iNZxC++gv20z9gptnU+OOWF5hnb/216v
         mRCZQruTl3AcMFc9nd4JavpWuQBpjXs3V8T0S1ZUc4XcTuS/ct8Zt8dI7wmXC5MJcNV/
         vUWhaVEeG4/HHcBNbfE0YFjcr23ck2J9vcCSkLIcy+M2lu0hMG/jvJ9sVCoTYl8c34NH
         ErXDzDTZ8BoACmfmAUNm4jlSe1B2q79F7H3Lei0lsBMbd+g/CJ1juplz8NplkLQsaICi
         C5Kg==
X-Forwarded-Encrypted: i=1; AJvYcCVabbW77PbQ5hUKXfP17XwYzlSSPxbjy1UC0GWV41nfGlmBMdudXo0ThMei1d5kyrIP1A0X0uV4myfgxYnqMZ/wGpoU
X-Gm-Message-State: AOJu0YzGEwcx0JAWEiKyOB90Igvlx48ue8pyZhyP4VGEWk83C0BauuRJ
	HwB81gMOb+swC481cfPboctUAbl7IdyLoVuqWfoPTrleU3eq6x+ZzbcFlbo9ftgrhgoM+zhpmo9
	TddMiyA==
X-Google-Smtp-Source: AGHT+IHI1avs/7pYYtecwRvgmLZYgo2lFpjiEi7tuhfIJiSa3gOZzI078U+qk912/p0I1iBqDNU8jjzQS3Bf
X-Received: from vipin.c.googlers.com ([34.105.13.176]) (user=vipinsh
 job=sendgmr) by 2002:a17:90b:f92:b0:2cf:93dc:112d with SMTP id
 98e67ed59e1d1-2d39427d86emr1402a91.4.1723482837862; Mon, 12 Aug 2024 10:13:57
 -0700 (PDT)
Date: Mon, 12 Aug 2024 10:13:40 -0700
In-Reply-To: <20240812171341.1763297-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240812171341.1763297-2-vipinsh@google.com>
Subject: [PATCH 1/2] KVM: x86/mmu: Split NX hugepage recovery flow into TDP
 and non-TDP flow
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: dmatlack@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Preparatory patch to run NX hugepage recovery for TDP MMU pages under
MMU read lock. Split NX hugepage recovery code into two separate
functions; one for TDP MMU pages and another for non-TDP MMU pages. Run
both flows under MMU write lock, same as in the code prior to split.

Traverse the common list kvm->arch.possible_nx_huge_pages and only
process TDP MMU shadow pages in TDP flow and non-TDP MMU pages in
non-TDP flow. Starvation is avoided by maintaining the invariant that
only first 'to_zap' pages from the list will be zapped at max. If there
are 'x' (x <= to_zap) TDP MMU pages in the first 'to_zap' pages of the
list then TDP flow will only zap 'x' pages and non-TDP MMU flow will get
'to_zap - x' iterations to zap.

In TDP flow, zap using kvm_tdp_mmu_zap() and flush remote TLBs under RCU
read lock.

In non-TDP flow, use kvm_mmu_prepare_zap_page() and
kvm_commit_zap_pages(). There is no RCU read lock needed.

Side effects of this split are:
1. Separate TLB flushes for TDP and non-TDP flow instead of a single
   combined one in existing approach.
   In most practical cases this should not happen often as majority of
   time pages in recovery worker list will be of one type and not both.

2. kvm->arch.possible_nx_huge_pages will be traversed two times for each
   flow.
   This should not cause slow down as traversing a list is fast in
   general.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 164 +++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h |   6 ++
 arch/x86/kvm/mmu/tdp_mmu.c      |  59 ++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +
 4 files changed, 164 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..5534fcc9d1b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -909,7 +909,7 @@ void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
-static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	sp->nx_huge_page_disallowed = false;
 
@@ -7311,98 +7311,128 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	return err;
 }
 
-static void kvm_recover_nx_huge_pages(struct kvm *kvm)
+/*
+ * Get the first shadow mmu page of desired type from the NX huge pages list.
+ * Return NULL if list doesn't have the needed page with in the first max pages.
+ */
+struct kvm_mmu_page *kvm_mmu_possible_nx_huge_page(struct kvm *kvm, bool tdp_mmu,
+						   ulong max)
 {
-	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
-	struct kvm_memory_slot *slot;
-	int rcu_idx;
-	struct kvm_mmu_page *sp;
-	unsigned int ratio;
-	LIST_HEAD(invalid_list);
-	bool flush = false;
-	ulong to_zap;
+	struct kvm_mmu_page *sp = NULL;
+	ulong i = 0;
 
-	rcu_idx = srcu_read_lock(&kvm->srcu);
-	write_lock(&kvm->mmu_lock);
+	/*
+	 * We use a separate list instead of just using active_mmu_pages because
+	 * the number of shadow pages that be replaced with an NX huge page is
+	 * expected to be relatively small compared to the total number of shadow
+	 * pages. And because the TDP MMU doesn't use active_mmu_pages.
+	 */
+	list_for_each_entry(sp, &kvm->arch.possible_nx_huge_pages, possible_nx_huge_page_link) {
+		if (i++ >= max)
+			break;
+		if (is_tdp_mmu_page(sp) == tdp_mmu)
+			return sp;
+	}
+
+	return NULL;
+}
+
+static struct kvm_mmu_page *shadow_mmu_nx_huge_page_to_zap(struct kvm *kvm, ulong max)
+{
+	return kvm_mmu_possible_nx_huge_page(kvm, /*tdp_mmu=*/false, max);
+}
+
+bool kvm_mmu_sp_dirty_logging_enabled(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	struct kvm_memory_slot *slot = NULL;
 
 	/*
-	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
-	 * be done under RCU protection, because the pages are freed via RCU
-	 * callback.
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
 	 */
-	rcu_read_lock();
+	if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
+		struct kvm_memslots *slots;
 
-	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
-	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
-	for ( ; to_zap; --to_zap) {
-		if (list_empty(&kvm->arch.possible_nx_huge_pages))
+		slots = kvm_memslots_for_spte_role(kvm, sp->role);
+		slot = __gfn_to_memslot(slots, sp->gfn);
+		WARN_ON_ONCE(!slot);
+	}
+
+	return slot && kvm_slot_dirty_track_enabled(slot);
+}
+
+static void shadow_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
+{
+	struct kvm_mmu_page *sp;
+	LIST_HEAD(invalid_list);
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	while (to_zap) {
+		sp = shadow_mmu_nx_huge_page_to_zap(kvm, to_zap);
+		if (!sp)
 			break;
 
-		/*
-		 * We use a separate list instead of just using active_mmu_pages
-		 * because the number of shadow pages that be replaced with an
-		 * NX huge page is expected to be relatively small compared to
-		 * the total number of shadow pages.  And because the TDP MMU
-		 * doesn't use active_mmu_pages.
-		 */
-		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
-				      struct kvm_mmu_page,
-				      possible_nx_huge_page_link);
 		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
 		WARN_ON_ONCE(!sp->role.direct);
 
 		/*
-		 * Unaccount and do not attempt to recover any NX Huge Pages
-		 * that are being dirty tracked, as they would just be faulted
-		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
+		 * Unaccount and do not attempt to recover any NX Huge Pages that
+		 * are being dirty tracked, as they would just be faulted back in
+		 * as 4KiB pages. The NX Huge Pages in this slot will be
 		 * recovered, along with all the other huge pages in the slot,
 		 * when dirty logging is disabled.
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
 		 */
-		slot = NULL;
-		if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
-			struct kvm_memslots *slots;
-
-			slots = kvm_memslots_for_spte_role(kvm, sp->role);
-			slot = __gfn_to_memslot(slots, sp->gfn);
-			WARN_ON_ONCE(!slot);
-		}
-
-		if (slot && kvm_slot_dirty_track_enabled(slot))
+		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
 			unaccount_nx_huge_page(kvm, sp);
-		else if (is_tdp_mmu_page(sp))
-			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		else
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+
 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-			rcu_read_unlock();
-
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
 			cond_resched_rwlock_write(&kvm->mmu_lock);
-			flush = false;
-
-			rcu_read_lock();
 		}
+		to_zap--;
 	}
-	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 
-	rcu_read_unlock();
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+}
+
+static void kvm_recover_nx_huge_pages(struct kvm *kvm)
+{
+	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
+	unsigned int ratio;
+	ulong to_zap;
+	int rcu_idx;
+
+	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
+
+	rcu_idx = srcu_read_lock(&kvm->srcu);
+
+	if (to_zap && tdp_mmu_enabled) {
+		write_lock(&kvm->mmu_lock);
+		to_zap = kvm_tdp_mmu_recover_nx_huge_pages(kvm, to_zap);
+		write_unlock(&kvm->mmu_lock);
+	}
+
+	if (to_zap && kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
+		shadow_mmu_recover_nx_huge_pages(kvm, to_zap);
+		write_unlock(&kvm->mmu_lock);
+	}
 
-	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..246b1bc0319b 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -354,4 +354,10 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+struct kvm_mmu_page *kvm_mmu_possible_nx_huge_page(struct kvm *kvm, bool tdp_mmu,
+						   ulong max);
+
+bool kvm_mmu_sp_dirty_logging_enabled(struct kvm *kvm, struct kvm_mmu_page *sp);
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c7dc49ee7388..933bb8b11c9f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1796,3 +1796,62 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 	 */
 	return rcu_dereference(sptep);
 }
+
+static struct kvm_mmu_page *tdp_mmu_nx_huge_page_to_zap(struct kvm *kvm, ulong max)
+{
+	return kvm_mmu_possible_nx_huge_page(kvm, /*tdp_mmu=*/true, max);
+}
+
+ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
+{
+	struct kvm_mmu_page *sp;
+	bool flush = false;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	/*
+	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
+	 * be done under RCU protection, because the pages are freed via RCU
+	 * callback.
+	 */
+	rcu_read_lock();
+
+	while (to_zap) {
+		sp = tdp_mmu_nx_huge_page_to_zap(kvm, to_zap);
+
+		if (!sp)
+			break;
+
+		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
+		WARN_ON_ONCE(!sp->role.direct);
+
+		/*
+		 * Unaccount and do not attempt to recover any NX Huge Pages that
+		 * are being dirty tracked, as they would just be faulted back in
+		 * as 4KiB pages. The NX Huge Pages in this slot will be
+		 * recovered, along with all the other huge pages in the slot,
+		 * when dirty logging is disabled.
+		 */
+		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
+			unaccount_nx_huge_page(kvm, sp);
+		else
+			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
+
+		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
+
+		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
+			if (flush) {
+				kvm_flush_remote_tlbs(kvm);
+				flush = false;
+			}
+			rcu_read_unlock();
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+			rcu_read_lock();
+		}
+		to_zap--;
+	}
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+	rcu_read_unlock();
+	return to_zap;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1b74e058a81c..7d68c2ddf78c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -52,6 +52,8 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      gfn_t start, gfn_t end,
 				      int target_level, bool shared);
 
+ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap);
+
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
 	rcu_read_lock();
-- 
2.46.0.76.ge559c4bf1a-goog


