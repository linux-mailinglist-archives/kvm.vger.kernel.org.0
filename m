Return-Path: <kvm+bounces-30773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0A59BD531
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 185521C22B11
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF0E1EF081;
	Tue,  5 Nov 2024 18:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kv1cNC7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE8E1E8856
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832226; cv=none; b=TC7cBRSRq8swCnwknmJyJ7kNTl4G3WwKPX/7zux4YZqjKksetLgbSlBKkqQc+1oYEgO27Z3Rp2WU5SmTEeAFU3UY6OCy3nbEtaRzh0qdMF/mcZLloFf5cpzf558Zkl0QRDq7ApZ+9i1nWjmuVw8Fw2UR912J4DgBxNSek6Q3qwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832226; c=relaxed/simple;
	bh=tT+pzCXqWuNowH8bjSb9aKrHybWvc7zxkwsmc7gL1dg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MMAr8QMh/P/vbJkYfwnR11RFFZZrdB0kptWW1avc6U42+qFQRoVHkrXjIbct8CwgNkZDg7q5hceWMXlvfcbuD/EGdrvl2+XwLWBDRu45fB9eGjawPDoWpCd4SC75GpfqTGa0QaoFjFUdJNMe8h0LqWJjL5Dypc7h5Yro8tkHaTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kv1cNC7Q; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02fff66a83so9074351276.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832223; x=1731437023; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dg1ueYt3SFlmv/6xFaUNv91kdLtzNJ+9Y0y9mZTK1X4=;
        b=Kv1cNC7Q3nQQO8YONrhz+WCU68/FF9HoZV1X1TXEXzkX3r2/X80cO+d/SHnqOakeyC
         0DrJeml3Q58TNBFt7ITXbUb3zubd71Ook8IiIyx1fRnC+wiO9mUyomqQxyLB0RV0+Bct
         CHVfBFpI1s+dJdc/YYK98zos7eirzcgl2KnPqyHl3B2jmsYl586lO+49RlgypeT8EKnk
         Ot4qpLiMKGSFsqSjfAThjMBCnFAEb/3oqVfvGZ6PurBUCC/LJyBb3YbYZy4CSV3rqN1A
         +ilUrVHCE479vqwt7DvXRecFje/8Q323kJMybSgynQTuuuBNphsyZ/R6RFvCLm6ndnGT
         gDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832223; x=1731437023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dg1ueYt3SFlmv/6xFaUNv91kdLtzNJ+9Y0y9mZTK1X4=;
        b=eYx2kgDZrRG2rnMeOgCLS8z1KM7yjiSyRyg/A5/qa/W+/rd4xmANMcaUSqT3Tc9TIL
         B9vrj2TDlHmT39WT/5J9/u7E13RA+qOGy14ZRQM7Omb536AL4z43dXm0pnwfe8hKN3W8
         95Cihxo4o9bFjW1DbQDS81HxecSSWkpRRMAT+KJ05ozgVRh2VseW82JAZwgO0aJCxyyt
         1kFigupfJ6txDEG/5JjB8EBjEbAWHg5xQcNvBgIA+pOzwnRynaknYQMpDQdD0os3ydDr
         ys5ljqxbugbI9kLJQ/36sZuonlDDROfeEjMd68uo9onAEpqHyp065k0GUnbDKuwa9dhs
         tkrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE29E4qozzsF8zlX7bMixrIwb+gW9Ey02Ndr4+n4PrrZZNfICKhnkjnXQL+KYd//QiNlw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe/5Wa7BdctX6lAG+jMdQg+MrAP9YgV9POEm2uKncYwZk7VymK
	7Vi6RD4NUPCdU9f9szbU/vnnj2dFVEjaM0rUfJkm1Qe2afzAoWBsMmFqenXOYNBdvNI+SBHV/SW
	Klpzu4v2Bf+R2/qKFLQ==
X-Google-Smtp-Source: AGHT+IH/2j0g8b38xgXv/Mz5EetP3v/9W3P5WbYERrZ4ckZRr3Z4g+b3Hv93b2pe6QIYDIeBDbGY/gVzjSsx0I/4
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a25:b411:0:b0:e2b:da82:f695 with SMTP
 id 3f1490d57ef6-e30e5b0f56amr12767276.6.1730832223468; Tue, 05 Nov 2024
 10:43:43 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:23 +0000
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-2-jthoughton@google.com>
Subject: [PATCH v8 01/11] KVM: Remove kvm_handle_hva_range helper functions
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_handle_hva_range is only used by the young notifiers. In a later
patch, it will be even further tied to the young notifiers. Instead of
renaming kvm_handle_hva_range to something like
kvm_handle_hva_range_young, simply remove kvm_handle_hva_range. This
seems slightly more readable, though there is slightly more code
duplication.

Finally, rename __kvm_handle_hva_range to kvm_handle_hva_range, now that
the name is available.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 74 +++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 27186b06518a..8b234a9acdb3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -551,8 +551,8 @@ static void kvm_null_fn(void)
 	     node;							     \
 	     node = interval_tree_iter_next(node, start, last))	     \
 
-static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
-							   const struct kvm_mmu_notifier_range *range)
+static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
+							 const struct kvm_mmu_notifier_range *range)
 {
 	struct kvm_mmu_notifier_return r = {
 		.ret = false,
@@ -628,33 +628,6 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	return r;
 }
 
-static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
-						unsigned long start,
-						unsigned long end,
-						gfn_handler_t handler,
-						bool flush_on_ret)
-{
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_mmu_notifier_range range = {
-		.start		= start,
-		.end		= end,
-		.handler	= handler,
-		.on_lock	= (void *)kvm_null_fn,
-		.flush_on_ret	= flush_on_ret,
-		.may_block	= false,
-	};
-
-	return __kvm_handle_hva_range(kvm, &range).ret;
-}
-
-static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
-							 unsigned long start,
-							 unsigned long end,
-							 gfn_handler_t handler)
-{
-	return kvm_handle_hva_range(mn, start, end, handler, false);
-}
-
 void kvm_mmu_invalidate_begin(struct kvm *kvm)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -747,7 +720,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * that guest memory has been reclaimed.  This needs to be done *after*
 	 * dropping mmu_lock, as x86's reclaim path is slooooow.
 	 */
-	if (__kvm_handle_hva_range(kvm, &hva_range).found_memslot)
+	if (kvm_handle_hva_range(kvm, &hva_range).found_memslot)
 		kvm_arch_guest_memory_reclaimed(kvm);
 
 	return 0;
@@ -793,7 +766,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	};
 	bool wake;
 
-	__kvm_handle_hva_range(kvm, &hva_range);
+	kvm_handle_hva_range(kvm, &hva_range);
 
 	/* Pairs with the increment in range_start(). */
 	spin_lock(&kvm->mn_invalidate_lock);
@@ -815,10 +788,20 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 					      unsigned long start,
 					      unsigned long end)
 {
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_mmu_notifier_range range = {
+		.start		= start,
+		.end		= end,
+		.handler	= kvm_age_gfn,
+		.on_lock	= (void *)kvm_null_fn,
+		.flush_on_ret	=
+			!IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG),
+		.may_block	= false,
+	};
+
 	trace_kvm_age_hva(start, end);
 
-	return kvm_handle_hva_range(mn, start, end, kvm_age_gfn,
-				    !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG));
+	return kvm_handle_hva_range(kvm, &range).ret;
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
@@ -826,6 +809,16 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 					unsigned long start,
 					unsigned long end)
 {
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_mmu_notifier_range range = {
+		.start		= start,
+		.end		= end,
+		.handler	= kvm_age_gfn,
+		.on_lock	= (void *)kvm_null_fn,
+		.flush_on_ret	= false,
+		.may_block	= false,
+	};
+
 	trace_kvm_age_hva(start, end);
 
 	/*
@@ -841,17 +834,26 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+	return kvm_handle_hva_range(kvm, &range).ret;
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
 				       unsigned long address)
 {
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_mmu_notifier_range range = {
+		.start		= address,
+		.end		= address + 1,
+		.handler	= kvm_test_age_gfn,
+		.on_lock	= (void *)kvm_null_fn,
+		.flush_on_ret	= false,
+		.may_block	= false,
+	};
+
 	trace_kvm_test_age_hva(address);
 
-	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-					     kvm_test_age_gfn);
+	return kvm_handle_hva_range(kvm, &range).ret;
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
-- 
2.47.0.199.ga7371fff76-goog


