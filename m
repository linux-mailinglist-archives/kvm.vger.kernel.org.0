Return-Path: <kvm+bounces-26032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E718796FCD9
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D6CA28988A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FB41D86D6;
	Fri,  6 Sep 2024 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IA/ByX6r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABC9157A67
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 20:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725655522; cv=none; b=GxNVU3LEfVA5qwwH8eniDtSjXtJ7UU3mCR7s2iKq9QSG/p48Tw3hUhj2leVi1ngEIj/gssAikw0FeS3z6e/4j16nJhNEZzFFPFfRRwYMU7KYlL0mfb/2WqEyV++GZ83Gdi7bePRKzsmhG0WHYgUg4fM/YJnp/X6ues4jEd8rB/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725655522; c=relaxed/simple;
	bh=gd0clIPIodl2f/Gcii95WqTvvODsQXy40ftXvlCE0CY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a6ej1ynCTkVO0g5bDfEnl9FGSKqj5v/5aSCTWNWdACm84DK3GvJ4YCXfesHVsmD0BQ0NHadLfsBIvqL6g86XsNLsqK1GfJeRYbNcrnnV8WbRS2S7S+jSTptVSh7kmTZKWHVY8oFe35kjqWmJFtJaowNBWXvu8B3vmuVn1gjJkTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IA/ByX6r; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e178e745c49so4496956276.2
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 13:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725655520; x=1726260320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ynLeLZHmcgV0OPoa4jVXAQCVisoCKJo4HE1cjVAXqpk=;
        b=IA/ByX6rreKnhD/i2o35R5/L26i8ptZd5U4yZvk6G8asLJDHE9G+9E2h5vR823ujU7
         jMhSSFfcgG2u78UX3XvFCxmBhhmj26jI/+nFwVgonziblqyJhXdLLEbEvkqghfN3q68y
         dSlgVULAmS7FjMA7Y8mowNwuTZtdGg8NkkYuGs49dNjGn2DAR8WEtV1pqTjU+gwuCxdS
         Dk5yeCxrGpcFcWOZFtT1p2N+iYsh3lb7f0BeQWXfwiZzOP0R1XYmkvMX2JWQKEMBZLr/
         NzZ7ldKV4h02ImDqnd19BvBxSIUX4g/ixUH8UkpTZi4g0mzT/CKalrU5WB50XCGvVlhY
         dHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725655520; x=1726260320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ynLeLZHmcgV0OPoa4jVXAQCVisoCKJo4HE1cjVAXqpk=;
        b=Oe2c2ZXheWH9ChRAroqQJ87vUZFfkVz+3unAWBMWTF8jbIw3NJlIOXtJPx4QTCF2R6
         tWgZFswDMWsglA3/wSTTkDm/XQh3+v9xZWAuIOtuJdGheNXGAf9mNUhOd8Du3XrXpwPy
         L0UR6H5v2WDpo1XbZhlynnIhEvE4nMsrr61tK6VqdJe/jCJ0SP0KAzOijsyi5ooWxLGx
         fvDlLdgCldZUiB6M55NuUH6MvtqFpw6rGcr4tL5R5QWdUJH7bEhIcvTRCcMacvN8A1KX
         WaShGcMaBwDe1nNi3eOxsUC+9cYMZYHJzEOoT4MHVWHLkUh2duQb+PCbApiBCWP7/v7s
         5DqA==
X-Gm-Message-State: AOJu0YyOdpODLzS+/Sw5/sGjjdduPDNoKFB3VVde2dFoZVKYWn2EqwH5
	lH9xvGby8UUnV4pj/KqN1mBolVCwy2r0ZgHvHHFfUrK14IeAoNhMzZ0j/WYuCpVzbFO5yOLk8rb
	USiPxZQ==
X-Google-Smtp-Source: AGHT+IEDFjsBUjHwCCJpwBeX/aAnrpUa/0s1xrwzsiQJRhRCrfP8t9vU+ua0+rlLtRRGWrOapFWOzrXc4LFs
X-Received: from vipin.c.googlers.com ([34.105.13.176]) (user=vipinsh
 job=sendgmr) by 2002:a25:83c3:0:b0:e0e:499f:3d9b with SMTP id
 3f1490d57ef6-e1d3486852emr6340276.1.1725655519903; Fri, 06 Sep 2024 13:45:19
 -0700 (PDT)
Date: Fri,  6 Sep 2024 13:45:14 -0700
In-Reply-To: <20240906204515.3276696-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906204515.3276696-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906204515.3276696-2-vipinsh@google.com>
Subject: [PATCH v3 1/2] KVM: x86/mmu: Track TDP MMU NX huge pages separately
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Create separate list for storing TDP MMU NX huge pages and provide
counter for it. Use this list in NX huge page recovery worker along with
the existing NX huge pages list. Use old NX huge pages list for storing
only non-TDP MMU pages and provide separate counter for it.

Separate list will allow to optimize TDP MMU NX huge page recovery in
future patches by using MMU read lock.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h | 13 ++++++++++-
 arch/x86/kvm/mmu/mmu.c          | 39 +++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |  8 +++++--
 arch/x86/kvm/mmu/tdp_mmu.c      | 19 ++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h      |  1 +
 5 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..0f21f9a69285 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1318,8 +1318,12 @@ struct kvm_arch {
 	 * guarantee an NX huge page will be created in its stead, e.g. if the
 	 * guest attempts to execute from the region then KVM obviously can't
 	 * create an NX huge page (without hanging the guest).
+	 *
+	 * This list only contains shadow and legacy MMU pages. TDP MMU pages
+	 * are stored separately in tdp_mmu_possible_nx_huge_pages.
 	 */
 	struct list_head possible_nx_huge_pages;
+	u64 nr_possible_nx_huge_pages;
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 	struct kvm_page_track_notifier_head track_notifier_head;
 #endif
@@ -1474,7 +1478,7 @@ struct kvm_arch {
 	 * is held in read mode:
 	 *  - tdp_mmu_roots (above)
 	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
-	 *  - possible_nx_huge_pages;
+	 *  - tdp_mmu_possible_nx_huge_pages
 	 *  - the possible_nx_huge_page_link field of kvm_mmu_page structs used
 	 *    by the TDP MMU
 	 * Because the lock is only taken within the MMU lock, strictly
@@ -1483,6 +1487,13 @@ struct kvm_arch {
 	 * the code to do so.
 	 */
 	spinlock_t tdp_mmu_pages_lock;
+
+	/*
+	 * Similar to possible_nx_huge_pages list but this one stores only TDP
+	 * MMU pages.
+	 */
+	struct list_head tdp_mmu_possible_nx_huge_pages;
+	u64 tdp_mmu_nr_possible_nx_huge_pages;
 #endif /* CONFIG_X86_64 */
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..455caaaa04f5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -857,7 +857,8 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_gfn(kvm, gfn, PG_LEVEL_4K);
 }
 
-void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				 struct list_head *pages, u64 *nr_pages)
 {
 	/*
 	 * If it's possible to replace the shadow page with an NX huge page,
@@ -870,9 +871,9 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (!list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
+	++(*nr_pages);
 	++kvm->stat.nx_lpage_splits;
-	list_add_tail(&sp->possible_nx_huge_page_link,
-		      &kvm->arch.possible_nx_huge_pages);
+	list_add_tail(&sp->possible_nx_huge_page_link, pages);
 }
 
 static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
@@ -881,7 +882,10 @@ static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	sp->nx_huge_page_disallowed = true;
 
 	if (nx_huge_page_possible)
-		track_possible_nx_huge_page(kvm, sp);
+		track_possible_nx_huge_page(kvm,
+					    sp,
+					    &kvm->arch.possible_nx_huge_pages,
+					    &kvm->arch.nr_possible_nx_huge_pages);
 }
 
 static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -900,11 +904,13 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				   u64 *nr_pages)
 {
 	if (list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
+	--(*nr_pages);
 	--kvm->stat.nx_lpage_splits;
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
@@ -913,7 +919,7 @@ static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	sp->nx_huge_page_disallowed = false;
 
-	untrack_possible_nx_huge_page(kvm, sp);
+	untrack_possible_nx_huge_page(kvm, sp, &kvm->arch.nr_possible_nx_huge_pages);
 }
 
 static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu,
@@ -7311,9 +7317,9 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	return err;
 }
 
-static void kvm_recover_nx_huge_pages(struct kvm *kvm)
+void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
+			       unsigned long nr_pages)
 {
-	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
 	struct kvm_memory_slot *slot;
 	int rcu_idx;
 	struct kvm_mmu_page *sp;
@@ -7333,9 +7339,9 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 	rcu_read_lock();
 
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
-	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
+	to_zap = ratio ? DIV_ROUND_UP(nr_pages, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
-		if (list_empty(&kvm->arch.possible_nx_huge_pages))
+		if (list_empty(pages))
 			break;
 
 		/*
@@ -7345,7 +7351,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		 * the total number of shadow pages.  And because the TDP MMU
 		 * doesn't use active_mmu_pages.
 		 */
-		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
+		sp = list_first_entry(pages,
 				      struct kvm_mmu_page,
 				      possible_nx_huge_page_link);
 		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
@@ -7417,6 +7423,12 @@ static long get_nx_huge_page_recovery_timeout(u64 start_time)
 		       : MAX_SCHEDULE_TIMEOUT;
 }
 
+static void kvm_mmu_recover_nx_huge_pages(struct kvm *kvm)
+{
+	kvm_recover_nx_huge_pages(kvm, &kvm->arch.possible_nx_huge_pages,
+				  kvm->arch.nr_possible_nx_huge_pages);
+}
+
 static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
 {
 	u64 start_time;
@@ -7438,7 +7450,10 @@ static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
 		if (kthread_should_stop())
 			return 0;
 
-		kvm_recover_nx_huge_pages(kvm);
+		kvm_mmu_recover_nx_huge_pages(kvm);
+		if (tdp_mmu_enabled)
+			kvm_tdp_mmu_recover_nx_huge_pages(kvm);
+
 	}
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..2d2e1231996a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -351,7 +351,11 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
-void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
-void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				 struct list_head *pages, u64 *nr_pages);
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				   u64 *nr_pages);
+void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
+			       unsigned long nr_pages);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c7dc49ee7388..9a6c26d20210 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -15,6 +15,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
+	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 }
 
@@ -73,6 +74,13 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	tdp_mmu_free_sp(sp);
 }
 
+void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
+{
+	kvm_recover_nx_huge_pages(kvm,
+				  &kvm->arch.tdp_mmu_possible_nx_huge_pages,
+				  kvm->arch.tdp_mmu_nr_possible_nx_huge_pages);
+}
+
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
@@ -318,7 +326,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	sp->nx_huge_page_disallowed = false;
-	untrack_possible_nx_huge_page(kvm, sp);
+	untrack_possible_nx_huge_page(kvm, sp, &kvm->arch.tdp_mmu_nr_possible_nx_huge_pages);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
@@ -1162,10 +1170,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (fault->huge_page_disallowed &&
-		    fault->req_level >= iter.level) {
+		    fault->req_level >= iter.level &&
+		    sp->nx_huge_page_disallowed) {
 			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-			if (sp->nx_huge_page_disallowed)
-				track_possible_nx_huge_page(kvm, sp);
+			track_possible_nx_huge_page(kvm,
+						    sp,
+						    &kvm->arch.tdp_mmu_possible_nx_huge_pages,
+						    &kvm->arch.tdp_mmu_nr_possible_nx_huge_pages);
 			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 		}
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1b74e058a81c..510baf3eb3f1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -66,6 +66,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte);
+void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm);
 
 #ifdef CONFIG_X86_64
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
-- 
2.46.0.469.g59c65b2a67-goog


