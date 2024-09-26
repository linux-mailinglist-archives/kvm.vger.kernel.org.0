Return-Path: <kvm+bounces-27530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1542986A9A
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48AEA1F22EC9
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B25B1AB6D1;
	Thu, 26 Sep 2024 01:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VWyL8IMW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1611A4B66
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314534; cv=none; b=oyfuZHjMXm4CxbWtVEGzrTDNxnncs7h0Vu0qLJVJ0MsmoPr9kJVDN/8EOY4kJNrytAHFFE7zhFxuHRCkbCPVed3KLtBzIUbq4VMeQj90BFvJM6OUjNXCvfAF9jYx6xVr+fUa67OZcYkHw3CfWmtPzktDnj7vNMQO38b8eX2GO6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314534; c=relaxed/simple;
	bh=iynxZ4Ry9WaN4XO7OQhzo2JcvREd4yVbmFHSIphWh40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RoNiQVvn1NkBzrrNhYa3h9XkK6Fvaj91sCZdlXi98Og5wcJDUwTjpaC8svUfa6W95IRtUKR0WUTNfoszDDxZM5qgh8nO4fvsUrXvEXeyH4S7QaTV2zGo7u72E5x4i0fp4Z1/wMKA7MSVDT4a9WDsgCbUtoLr/LgeISQtitWqi+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VWyL8IMW; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e211e439a3so10623427b3.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314531; x=1727919331; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ogisB+p0t7E+MEmwUL2EdeyMfss1r+UivrCLQXciZ0o=;
        b=VWyL8IMWaAQGG04phvq0Z82R4n3aqoS8tnjLNrvV31bkzDKYLafBHC6bvUn+CxBWhA
         wgUjKspczotuLzqQkZA08e3t2qzXpHzyFxXGXL3oAqCpuveC4EQXmyq9ndvserDhpQCU
         YxO64grDH4l7l7CgnhizfmPdsfkHeV/O3t746cdXyk4q9froEqnH4gGhox54CF69qst/
         JGnKQ3s8K78MpE8Vo/EggETvPbj44jRIF4iuqglsTJXRS1dzVVnILFkWJ4GtouowoPqD
         Ez6nRSiklK1H9zgRKk0QeNTmf2xNHpMc9zpK4F3u+4TahGNcWTUoYo+W4sQIRWsRJlFw
         srRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314531; x=1727919331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ogisB+p0t7E+MEmwUL2EdeyMfss1r+UivrCLQXciZ0o=;
        b=vN1sGtwlLyMyRKCPpAlpkfMAL5meWA1PUiuuXMTbfTYy4BlkHZjxDA5bLUQiRvRATB
         EZFfh6UPLEs6T+3C40pjktJnNWXKpC0+vPWxgJ9BGjneG+rerFt8BVRpKTIwVTZHOrrt
         JjVXU3zJQRaN9ueBM4wpCABHfUDPA1My4OQbZTZstSfcLMOFYlIDKrrauPW56+0jNSvV
         gpeMxA1EOSRIWN8InFve12A18rEtcyFkBlsCKXxomK//dAO/y79wLt3ezbIiiuujTSqc
         1Uqi6VKRvNW6LWORUSTCIehqDj/PHQJcdKFuB5LBJVYkABeFxc9bUHv00jbc210xpl6g
         QaaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc5mDugz9x67g/UtBHWCQTWDg9Ko6aNLOonKfE0n4ijX09LRG7lHIlcDxAHqHs9vfOZ08=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIUNA17NIVAgt2N3qJi9olD3O04Bl6EC2hIPVOaN8XTaGU7bht
	rRVtNcTv2BHaBhtvB9rhWF/YctwCJYJLRbjQHtYB/YwymSmj4vBi75tCpsDj/xCDJU7x8wfPlrO
	jzBieuFpGvGSIORgdVg==
X-Google-Smtp-Source: AGHT+IEFdzw0O48kZ1pdx1YoauWRvV0zu2R4nMdxsgoP5v/WIUZXOoAYIDJzZnEXzkuO0wTdBSaqUczWpwalNBYg
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:5292:b0:62c:f976:a763 with
 SMTP id 00721157ae682-6e21d6c27c9mr136077b3.1.1727314530709; Wed, 25 Sep 2024
 18:35:30 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:35:01 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-14-jthoughton@google.com>
Subject: [PATCH v7 13/18] mm: Add fast_only bool to test_young and clear_young
 MMU notifiers
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

For implementers, the fast_only bool indicates that the age information
needs to be harvested such that we do not slow down other MMU operations,
and ideally that we are not ourselves slowed down by other MMU
operations.  Usually this means that the implementation should be
lockless.

Also add mmu_notifier_test_young_fast_only() and
mmu_notifier_clear_young_fast_only() helpers to set fast_only for these
notifiers.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/mmu_notifier.h | 61 ++++++++++++++++++++++++++++++++----
 include/trace/events/kvm.h   | 19 ++++++-----
 mm/mmu_notifier.c            | 18 ++++++++---
 virt/kvm/kvm_main.c          | 12 ++++---
 4 files changed, 88 insertions(+), 22 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 37643fa43687..7c17e2871c66 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -106,21 +106,38 @@ struct mmu_notifier_ops {
 	 * clear_young is a lightweight version of clear_flush_young. Like the
 	 * latter, it is supposed to test-and-clear the young/accessed bitflag
 	 * in the secondary pte, but it may omit flushing the secondary tlb.
+	 *
+	 * The fast_only parameter indicates that this call should not block,
+	 * and this function should not cause other MMU notifier calls to
+	 * block. Usually this means that the implementation should be
+	 * lockless.
+	 *
+	 * When called with fast_only, this notifier will be a no-op (and
+	 * return that the range is NOT young), unless has_fast_aging is set
+	 * on the struct mmu_notifier.
+	 *
+	 * When fast_only is true, if the implementer cannot determine that a
+	 * range is young without blocking, it should return 0 (i.e., that
+	 * the range is NOT young).
 	 */
 	int (*clear_young)(struct mmu_notifier *subscription,
 			   struct mm_struct *mm,
 			   unsigned long start,
-			   unsigned long end);
+			   unsigned long end,
+			   bool fast_only);
 
 	/*
 	 * test_young is called to check the young/accessed bitflag in
 	 * the secondary pte. This is used to know if the page is
 	 * frequently used without actually clearing the flag or tearing
 	 * down the secondary mapping on the page.
+	 *
+	 * The fast_only parameter has the same meaning as with clear_young.
 	 */
 	int (*test_young)(struct mmu_notifier *subscription,
 			  struct mm_struct *mm,
-			  unsigned long address);
+			  unsigned long address,
+			  bool fast_only);
 
 	/*
 	 * invalidate_range_start() and invalidate_range_end() must be
@@ -381,9 +398,11 @@ extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 					  unsigned long end);
 extern int __mmu_notifier_clear_young(struct mm_struct *mm,
 				      unsigned long start,
-				      unsigned long end);
+				      unsigned long end,
+				      bool fast_only);
 extern int __mmu_notifier_test_young(struct mm_struct *mm,
-				     unsigned long address);
+				     unsigned long address,
+				     bool fast_only);
 extern bool __mm_has_fast_young_notifiers(struct mm_struct *mm);
 extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
 extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r);
@@ -418,7 +437,16 @@ static inline int mmu_notifier_clear_young(struct mm_struct *mm,
 					   unsigned long end)
 {
 	if (mm_has_notifiers(mm))
-		return __mmu_notifier_clear_young(mm, start, end);
+		return __mmu_notifier_clear_young(mm, start, end, false);
+	return 0;
+}
+
+static inline int mmu_notifier_clear_young_fast_only(struct mm_struct *mm,
+						     unsigned long start,
+						     unsigned long end)
+{
+	if (mm_has_notifiers(mm))
+		return __mmu_notifier_clear_young(mm, start, end, true);
 	return 0;
 }
 
@@ -426,7 +454,15 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
 					  unsigned long address)
 {
 	if (mm_has_notifiers(mm))
-		return __mmu_notifier_test_young(mm, address);
+		return __mmu_notifier_test_young(mm, address, false);
+	return 0;
+}
+
+static inline int mmu_notifier_test_young_fast_only(struct mm_struct *mm,
+						    unsigned long address)
+{
+	if (mm_has_notifiers(mm))
+		return __mmu_notifier_test_young(mm, address, true);
 	return 0;
 }
 
@@ -622,12 +658,25 @@ static inline int mmu_notifier_clear_young(struct mm_struct *mm,
 	return 0;
 }
 
+static inline int mmu_notifier_clear_young_fast_only(struct mm_struct *mm,
+						     unsigned long start,
+						     unsigned long end)
+{
+	return 0;
+}
+
 static inline int mmu_notifier_test_young(struct mm_struct *mm,
 					  unsigned long address)
 {
 	return 0;
 }
 
+static inline int mmu_notifier_test_young_fast_only(struct mm_struct *mm,
+						    unsigned long address)
+{
+	return 0;
+}
+
 static inline bool mm_has_fast_young_notifiers(struct mm_struct *mm)
 {
 	return 0;
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 74e40d5d4af4..6d9485cf3e51 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -457,36 +457,41 @@ TRACE_EVENT(kvm_unmap_hva_range,
 );
 
 TRACE_EVENT(kvm_age_hva,
-	TP_PROTO(unsigned long start, unsigned long end),
-	TP_ARGS(start, end),
+	TP_PROTO(unsigned long start, unsigned long end, bool fast_only),
+	TP_ARGS(start, end, fast_only),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	start		)
 		__field(	unsigned long,	end		)
+		__field(	bool,		fast_only	)
 	),
 
 	TP_fast_assign(
 		__entry->start		= start;
 		__entry->end		= end;
+		__entry->fast_only	= fast_only;
 	),
 
-	TP_printk("mmu notifier age hva: %#016lx -- %#016lx",
-		  __entry->start, __entry->end)
+	TP_printk("mmu notifier age hva: %#016lx -- %#016lx fast_only: %d",
+		  __entry->start, __entry->end, __entry->fast_only)
 );
 
 TRACE_EVENT(kvm_test_age_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
+	TP_PROTO(unsigned long hva, bool fast_only),
+	TP_ARGS(hva, fast_only),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	hva		)
+		__field(	bool,		fast_only	)
 	),
 
 	TP_fast_assign(
 		__entry->hva		= hva;
+		__entry->fast_only	= fast_only;
 	),
 
-	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
+	TP_printk("mmu notifier test age hva: %#016lx fast_only: %d",
+		  __entry->hva, __entry->fast_only)
 );
 
 #endif /* _TRACE_KVM_MAIN_H */
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index c405e5b072cf..f9ec810c8a1b 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -404,7 +404,8 @@ bool __mm_has_fast_young_notifiers(struct mm_struct *mm)
 
 int __mmu_notifier_clear_young(struct mm_struct *mm,
 			       unsigned long start,
-			       unsigned long end)
+			       unsigned long end,
+			       bool fast_only)
 {
 	struct mmu_notifier *subscription;
 	int young = 0, id;
@@ -413,9 +414,13 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
 	hlist_for_each_entry_rcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		if (fast_only && !subscription->has_fast_aging)
+			continue;
+
 		if (subscription->ops->clear_young)
 			young |= subscription->ops->clear_young(subscription,
-								mm, start, end);
+								mm, start, end,
+								fast_only);
 	}
 	srcu_read_unlock(&srcu, id);
 
@@ -423,7 +428,8 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
 }
 
 int __mmu_notifier_test_young(struct mm_struct *mm,
-			      unsigned long address)
+			      unsigned long address,
+			      bool fast_only)
 {
 	struct mmu_notifier *subscription;
 	int young = 0, id;
@@ -432,9 +438,13 @@ int __mmu_notifier_test_young(struct mm_struct *mm,
 	hlist_for_each_entry_rcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		if (fast_only && !subscription->has_fast_aging)
+			continue;
+
 		if (subscription->ops->test_young) {
 			young = subscription->ops->test_young(subscription, mm,
-							      address);
+							      address,
+							      fast_only);
 			if (young)
 				break;
 		}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f6c369eccd2a..ec07caaed6b6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -846,7 +846,7 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
 	};
 
-	trace_kvm_age_hva(start, end);
+	trace_kvm_age_hva(start, end, false);
 
 	return kvm_handle_hva_range(kvm, &range).ret;
 }
@@ -854,7 +854,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long start,
-					unsigned long end)
+					unsigned long end,
+					bool fast_only)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
@@ -868,7 +869,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
 	};
 
-	trace_kvm_age_hva(start, end);
+	trace_kvm_age_hva(start, end, fast_only);
 
 	/*
 	 * Even though we do not flush TLB, this will still adversely
@@ -888,7 +889,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
-				       unsigned long address)
+				       unsigned long address,
+				       bool fast_only)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
@@ -902,7 +904,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
 	};
 
-	trace_kvm_test_age_hva(address);
+	trace_kvm_test_age_hva(address, fast_only);
 
 	return kvm_handle_hva_range(kvm, &range).ret;
 }
-- 
2.46.0.792.g87dc391469-goog


