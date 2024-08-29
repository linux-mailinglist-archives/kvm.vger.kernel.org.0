Return-Path: <kvm+bounces-25397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D06C964E74
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91286B218C6
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB71E1B9B57;
	Thu, 29 Aug 2024 19:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bp8j8auW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7661B9B28
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724958706; cv=none; b=AVnin68Mo74AuOw38EMZfzO5FrSVyUqaceZCFfGFHw1WIhO/qvokuEIf7ms5dXhk0gRgnTIHU+h3jH3wwFOEcbfk4PGeswAkoI8kn15ZWNGu9yyIB2ukhG8dQIqwSI9RQSd6G+eI7U504BMY04tRwdFCeCtxDGplfIZC11U2CvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724958706; c=relaxed/simple;
	bh=hXqTCy+IwWuvE13nTODm+KR/gKFsVDZ85WkOLUllTk8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GLAjv6YOKqkbE127Z8R0QFrUH6SkatI9ny89PILuMx7qHwur8aPXFxxIsu5xBvjbwwTc/M5I23zE8XOlQbIc6KWGdNYc7IwH9rt5Fu4gFr2AWtzHggUoPal5n/tRcD6L1FaPpy+k5dvZLVXC4GXccpQHKkndIcP+4Y3KY4taooA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bp8j8auW; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7c6b192a39bso825223a12.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724958704; x=1725563504; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wl1T4+l//WebT6Vv9ktUpu/Y9AZqw4mpHt+k/DcseZg=;
        b=Bp8j8auWIwnU+8aqJhOPFfGL60tjfex38R1CGKGgNJSGgLsT03dEm7bVyEbcZe8Axk
         x//AjOQ5uGVhXnM623qtGbscdHZCAWpGFSpJnn+2vZUpBu2o6XRdwqfAK45Hpq8ZNnhP
         w4Y8ErcWwYVQDByxomOecL7sfmFUVMNq5Dt/CwS9gLaeiQxLX9DLHF7CZwJjy4ybWBs2
         IlUNQgq0dHqAH4YVVejUQL5+R7zLxUzX1nd635OyDWkDtZmM1aXhnPeQER86LeMDfFwJ
         g4Bny0I1WFkGR0kWKBGgn250CEFB1GDKvYCPM4e1yiIdMNssNB2P833WtRCeQTFWM6El
         DtBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724958704; x=1725563504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wl1T4+l//WebT6Vv9ktUpu/Y9AZqw4mpHt+k/DcseZg=;
        b=mGgue56eHG89cZHpbvrKQHG57sDJq79TC0d352WTkKSjA8wtiXTxsIpmYh0d9zkvxu
         tg8RLLMZv6dnNfFWNbDYMDHmn6h/r4aL00c8HVas3X2EumAJ/eSZdPDg9jB8rZlccG/b
         QI8NoF1k7d+yjb143qeCX9DXeBoEagX8dmdkYPfGja1ktRVYtZ3mXHnHxW0HC45Tf4Yw
         C0aASCsSYQ17oGoSvRCUJ9rjAxJKKIpWGEQ9YmSA36O9TCTMZnvo6D8A7o6nAE7Hes1v
         L2ZTO1r5iEXZqwk7wd12wOAdEEvUfPamglJ3/+HqT5YSKdg2vyqu55NHejmYBnsbkLOz
         R5Bg==
X-Gm-Message-State: AOJu0YzeAHAWV2hxX4NCDns9wL8JJ3397Ctv20mSirKEJ1Rcu2GXAL2g
	BkT1yLrwzn9fboFJkSLDMkvBtp2Jj7wUKctiLEbTZdQI1bh+h47pqJfpqYSruoBGoJm8z7SmUyS
	J9QBvJQ==
X-Google-Smtp-Source: AGHT+IGjtXxEEKFKY7G6VoFP2r45mwUTJ9UygqPJnCeYLndEwxjGtfi3gqP+J6ppU01pSc1JIiLZJ71zDgXW
X-Received: from vipin.c.googlers.com ([34.105.13.176]) (user=vipinsh
 job=sendgmr) by 2002:a65:63c9:0:b0:7a1:db97:d6b2 with SMTP id
 41be03b00d2f7-7d22c4767d5mr8230a12.1.1724958703643; Thu, 29 Aug 2024 12:11:43
 -0700 (PDT)
Date: Thu, 29 Aug 2024 12:11:33 -0700
In-Reply-To: <20240829191135.2041489-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240829191135.2041489-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240829191135.2041489-3-vipinsh@google.com>
Subject: [PATCH v2 2/4] KVM: x86/mmu: Extract out TDP MMU NX huge page
 recovery code
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Create separate function for TDP MMU NX huge page recovery. In the new
TDP MMU function remove code related to "prepare and commit" zap pages
of legacy MMU as there will be no legacy MMU pages. Similarly, remove
TDP MMU zap related logic from legacy MMU NX huge page recovery code.
Extract out dirty logging check as it is common to both. Rename
kvm_recover_nx_huge_pages() to kvm_mmu_recover_nx_huge_pages().

Separate code allows to change TDP MMU NX huge page recovery
independently of legacy MMU.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 93 ++++++++++++++-------------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 68 ++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  3 ++
 4 files changed, 113 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0bda372b13a5..c8c64df979e3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -925,7 +925,7 @@ void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
-static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	sp->nx_huge_page_disallowed = false;
 
@@ -7327,26 +7327,44 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	return err;
 }
 
-static void kvm_recover_nx_huge_pages(struct kvm *kvm,
-				      struct list_head *nx_huge_pages,
-				      unsigned long to_zap)
+bool kvm_mmu_sp_dirty_logging_enabled(struct kvm *kvm, struct kvm_mmu_page *sp)
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
+static void kvm_mmu_recover_nx_huge_pages(struct kvm *kvm,
+					  struct list_head *nx_huge_pages,
+					  unsigned long to_zap)
 {
-	struct kvm_memory_slot *slot;
 	int rcu_idx;
 	struct kvm_mmu_page *sp;
 	LIST_HEAD(invalid_list);
-	bool flush = false;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
 	write_lock(&kvm->mmu_lock);
 
-	/*
-	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
-	 * be done under RCU protection, because the pages are freed via RCU
-	 * callback.
-	 */
-	rcu_read_lock();
-
 	for ( ; to_zap; --to_zap) {
 		if (list_empty(nx_huge_pages))
 			break;
@@ -7370,50 +7388,19 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
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
 	}
-	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-
-	rcu_read_unlock();
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
@@ -7461,16 +7448,16 @@ static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
 			return 0;
 
 		to_zap = nx_huge_pages_to_zap(kvm);
-		kvm_recover_nx_huge_pages(kvm,
-					  &kvm->arch.possible_nx_huge_pages,
-					  to_zap);
+		kvm_mmu_recover_nx_huge_pages(kvm,
+					      &kvm->arch.possible_nx_huge_pages,
+					      to_zap);
 
 		if (tdp_mmu_enabled) {
 #ifdef CONFIG_X86_64
 			to_zap = kvm_tdp_mmu_nx_huge_pages_to_zap(kvm);
-			kvm_recover_nx_huge_pages(kvm,
-						  &kvm->arch.tdp_mmu_possible_nx_huge_pages,
-						  to_zap);
+			kvm_tdp_mmu_recover_nx_huge_pages(kvm,
+						      &kvm->arch.tdp_mmu_possible_nx_huge_pages,
+						      to_zap);
 #endif
 		}
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8deed808592b..83b165077d97 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -353,6 +353,8 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+bool kvm_mmu_sp_dirty_logging_enabled(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 extern unsigned int nx_huge_pages_recovery_ratio;
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6415c2c7e936..f0b4341264fd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1805,3 +1805,71 @@ unsigned long kvm_tdp_mmu_nx_huge_pages_to_zap(struct kvm *kvm)
 
 	return ratio ? DIV_ROUND_UP(pages, ratio) : 0;
 }
+
+void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm,
+				   struct list_head *nx_huge_pages,
+				   unsigned long to_zap)
+{
+	int rcu_idx;
+	struct kvm_mmu_page *sp;
+	bool flush = false;
+
+	rcu_idx = srcu_read_lock(&kvm->srcu);
+	write_lock(&kvm->mmu_lock);
+
+	/*
+	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
+	 * be done under RCU protection, because the pages are freed via RCU
+	 * callback.
+	 */
+	rcu_read_lock();
+
+	for ( ; to_zap; --to_zap) {
+		if (list_empty(nx_huge_pages))
+			break;
+
+		/*
+		 * We use a separate list instead of just using active_mmu_pages
+		 * because the number of shadow pages that be replaced with an
+		 * NX huge page is expected to be relatively small compared to
+		 * the total number of shadow pages.  And because the TDP MMU
+		 * doesn't use active_mmu_pages.
+		 */
+		sp = list_first_entry(nx_huge_pages,
+				      struct kvm_mmu_page,
+				      possible_nx_huge_page_link);
+		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
+		WARN_ON_ONCE(!sp->role.direct);
+
+		/*
+		 * Unaccount and do not attempt to recover any NX Huge Pages
+		 * that are being dirty tracked, as they would just be faulted
+		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
+		 * recovered, along with all the other huge pages in the slot,
+		 * when dirty logging is disabled.
+		 */
+		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
+			unaccount_nx_huge_page(kvm, sp);
+		else
+			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
+		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
+
+		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
+			if (flush)
+				kvm_flush_remote_tlbs(kvm);
+			rcu_read_unlock();
+
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+			flush = false;
+
+			rcu_read_lock();
+		}
+	}
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+	rcu_read_unlock();
+
+	write_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, rcu_idx);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 95290fd6154e..4036552f40cd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -68,6 +68,9 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte);
 
 unsigned long kvm_tdp_mmu_nx_huge_pages_to_zap(struct kvm *kvm);
+void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm,
+				   struct list_head *nx_huge_pages,
+				   unsigned long to_zap);
 
 #ifdef CONFIG_X86_64
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
-- 
2.46.0.469.g59c65b2a67-goog


