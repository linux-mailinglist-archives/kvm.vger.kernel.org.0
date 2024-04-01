Return-Path: <kvm+bounces-13306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973AC8947B8
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5339D28370E
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 23:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3330456B89;
	Mon,  1 Apr 2024 23:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o67IIE7c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFE857302
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 23:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014201; cv=none; b=FWXYx0QyiS21b+2Q05Jzfn9Kyd3Ef81brlfvx5OFUBDWiSZQvL6XEq6M2+upnAdjvA6hqQzaMzJWpDSMv9375i1z+mzjg4j9++GFDUV2SQxG1nLluPSDQ1mIH1Zl8ANUDQ3zzTEai1JVjHsJyufalNDVzIiEh7aNLCbcjJYuaKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014201; c=relaxed/simple;
	bh=lRPV7D03buZFkRc9Tfh1gwW8b2stqZAO6KHxYrUGYoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lKSreQGj5oMb9JO5GIiAtbVxwEVYnaThP6eiNli8Lv5TfxaL14+Z9huWPAQLhC32Wi+nSMi2tJwWBw9pyrgLGLs4TEskDRqKakXPPqENucDpfyiuNnERHmh5O8Zkfp7H1BpdLrV7K+3zSflvJI75r3yn5ltgkORt1YpKa4OQ8mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o67IIE7c; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-7e331817bb4so1808139241.0
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 16:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014199; x=1712618999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PTb42yX5D5jCiyjo92iMcOe2nJRX5BH9KgDDQYg5TSM=;
        b=o67IIE7c39Tm+GT3sYvvjvRxe7p7/8GayRhbazGdACqkCtFfIYvcN9H1ox9Ie0e4fc
         9OzbvBHIIKqQWH4dSvUYIq7ysmnyqwJzjfPrwJpgOfHyJBpF5Bf6/APqM11H3gsKiAQv
         ZylwKSkJWW23E2WLZwTCHZYk4t3dlP4KHwEZ6R2OLoObrXf5699OHxewMl4ShxCufTXz
         gDsJU8DE4OlOyS3UcUOWAUb4fRHXolY/0JEN1V8Z7gUl5/NZhyYoemTod5ciMdGs9nsu
         PHe2l0/DxDsdB6GMc0bSuOlIaPI0skW+FqFENmRbj6tOCFD0liq5zQKEzKss7rynI9pu
         eqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014199; x=1712618999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PTb42yX5D5jCiyjo92iMcOe2nJRX5BH9KgDDQYg5TSM=;
        b=xMd4G8N6hha7pYaRiqtxrBiEPhbiopvp8i5CcYovKiEwDc32/XWe1bPklfFJVUkqrN
         zLX8e8RhZTHzPwm+spZMiuE+/J2zqu5uZloa/CqZw6QMjqgCvNRWYKDS15L8Agn3uiUA
         dcUAzakI1OnEpULsdJNT/H1Kv4j4+xV6zISVAxsbNo3OXeXDqsj6yy+cQnOkzWBu5K46
         jnOUBvAdVze/LcNs/o/RlGOU5JrEF1hRUpEZVmdxPLnCm7c4qvVlx4VV/Dg6Sl4D56Mk
         Fu3eYA2l0NxrVlNdhRwyI8mvY8VwKCDzv/TWVxlJl2FalxSarE5TxEBKN5klejKDjeAf
         lzVg==
X-Forwarded-Encrypted: i=1; AJvYcCUERVkUF0oSuTbVgOpyXS45cUTBsh1xDwPkkS5ZKuf0uGs2WzhT+nEn6XwKU5PIQgOXS0gx+4EbVyVUjBgMIV/1ELs5
X-Gm-Message-State: AOJu0YxtSROjHOYg6typRgVop+d014KrqNrLUrHUc65sIJjfNE4tssC5
	Y5zetUNRP4ecFZuk5uWt+S4vLVUjs0GPuhwuY+1vB4KlzrlZuUgARQEKMgHwfRrJFBd+0U2ihPg
	z1TQSn4LGxDgKl/7b+A==
X-Google-Smtp-Source: AGHT+IGmJlmVbaC/lfrLJ5ZQ93VOyi/dOsu4Z25niMdu8RAczUBaed8myhkzYvDdfTTf9baVVIW2FHfRFR9HE1rY
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6102:2d0d:b0:470:5ca5:3e95 with
 SMTP id ih13-20020a0561022d0d00b004705ca53e95mr1009542vsb.2.1712014198891;
 Mon, 01 Apr 2024 16:29:58 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:42 +0000
In-Reply-To: <20240401232946.1837665-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-4-jthoughton@google.com>
Subject: [PATCH v3 3/7] KVM: Add basic bitmap support into kvm_mmu_notifier_test/clear_young
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add kvm_arch_prepare_bitmap_age() for architectures to indiciate that
they support bitmap-based aging in kvm_mmu_notifier_test_clear_young()
and that they do not need KVM to grab the MMU lock for writing. This
function allows architectures to do other locking or other preparatory
work that it needs.

If an architecture does not implement kvm_arch_prepare_bitmap_age() or
is unable to do bitmap-based aging at runtime (and marks the bitmap as
unreliable):
 1. If a bitmap was provided, we inform the caller that the bitmap is
    unreliable (MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE).
 2. If a bitmap was not provided, fall back to the old logic.

Also add logic for architectures to easily use the provided bitmap if
they are able. The expectation is that the architecture's implementation
of kvm_gfn_test_age() will use kvm_gfn_record_young(), and
kvm_gfn_age() will use kvm_gfn_should_age().

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 60 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 92 +++++++++++++++++++++++++++++-----------
 2 files changed, 127 insertions(+), 25 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1800d03a06a9..5862fd7b5f9b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1992,6 +1992,26 @@ extern const struct _kvm_stats_desc kvm_vm_stats_desc[];
 extern const struct kvm_stats_header kvm_vcpu_stats_header;
 extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
 
+/*
+ * Architectures that support using bitmaps for kvm_age_gfn() and
+ * kvm_test_age_gfn should return true for kvm_arch_prepare_bitmap_age()
+ * and do any work they need to prepare. The subsequent walk will not
+ * automatically grab the KVM MMU lock, so some architectures may opt
+ * to grab it.
+ *
+ * If true is returned, a subsequent call to kvm_arch_finish_bitmap_age() is
+ * guaranteed.
+ */
+#ifndef kvm_arch_prepare_bitmap_age
+static inline bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *mn)
+{
+	return false;
+}
+#endif
+#ifndef kvm_arch_finish_bitmap_age
+static inline void kvm_arch_finish_bitmap_age(struct mmu_notifier *mn) {}
+#endif
+
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 {
@@ -2076,9 +2096,16 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
 	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
 }
 
+struct test_clear_young_metadata {
+	unsigned long *bitmap;
+	unsigned long bitmap_offset_end;
+	unsigned long end;
+	bool unreliable;
+};
 union kvm_mmu_notifier_arg {
 	pte_t pte;
 	unsigned long attributes;
+	struct test_clear_young_metadata *metadata;
 };
 
 struct kvm_gfn_range {
@@ -2087,11 +2114,44 @@ struct kvm_gfn_range {
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
 	bool may_block;
+	bool lockless;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+
+static inline void kvm_age_set_unreliable(struct kvm_gfn_range *range)
+{
+	struct test_clear_young_metadata *args = range->arg.metadata;
+
+	args->unreliable = true;
+}
+static inline unsigned long kvm_young_bitmap_offset(struct kvm_gfn_range *range,
+						    gfn_t gfn)
+{
+	struct test_clear_young_metadata *args = range->arg.metadata;
+
+	return hva_to_gfn_memslot(args->end - 1, range->slot) - gfn;
+}
+static inline void kvm_gfn_record_young(struct kvm_gfn_range *range, gfn_t gfn)
+{
+	struct test_clear_young_metadata *args = range->arg.metadata;
+
+	WARN_ON_ONCE(gfn < range->start || gfn >= range->end);
+	if (args->bitmap)
+		__set_bit(kvm_young_bitmap_offset(range, gfn), args->bitmap);
+}
+static inline bool kvm_gfn_should_age(struct kvm_gfn_range *range, gfn_t gfn)
+{
+	struct test_clear_young_metadata *args = range->arg.metadata;
+
+	WARN_ON_ONCE(gfn < range->start || gfn >= range->end);
+	if (args->bitmap)
+		return test_bit(kvm_young_bitmap_offset(range, gfn),
+				args->bitmap);
+	return true;
+}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0545d88c802..7d80321e2ece 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -550,6 +550,7 @@ struct kvm_mmu_notifier_range {
 	on_lock_fn_t on_lock;
 	bool flush_on_ret;
 	bool may_block;
+	bool lockless;
 };
 
 /*
@@ -598,6 +599,8 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int i, idx;
 
+	BUILD_BUG_ON(sizeof(gfn_range.arg) != sizeof(gfn_range.arg.pte));
+
 	if (WARN_ON_ONCE(range->end <= range->start))
 		return r;
 
@@ -637,15 +640,18 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.lockless = range->lockless;
 
 			if (!r.found_memslot) {
 				r.found_memslot = true;
-				KVM_MMU_LOCK(kvm);
-				if (!IS_KVM_NULL_FN(range->on_lock))
-					range->on_lock(kvm);
-
-				if (IS_KVM_NULL_FN(range->handler))
-					break;
+				if (!range->lockless) {
+					KVM_MMU_LOCK(kvm);
+					if (!IS_KVM_NULL_FN(range->on_lock))
+						range->on_lock(kvm);
+
+					if (IS_KVM_NULL_FN(range->handler))
+						break;
+				}
 			}
 			r.ret |= range->handler(kvm, &gfn_range);
 		}
@@ -654,7 +660,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && r.ret)
 		kvm_flush_remote_tlbs(kvm);
 
-	if (r.found_memslot)
+	if (r.found_memslot && !range->lockless)
 		KVM_MMU_UNLOCK(kvm);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -682,19 +688,24 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 	return __kvm_handle_hva_range(kvm, &range).ret;
 }
 
-static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
-							 unsigned long start,
-							 unsigned long end,
-							 gfn_handler_t handler)
+static __always_inline int kvm_handle_hva_range_no_flush(
+		struct mmu_notifier *mn,
+		unsigned long start,
+		unsigned long end,
+		gfn_handler_t handler,
+		union kvm_mmu_notifier_arg arg,
+		bool lockless)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
 		.start		= start,
 		.end		= end,
 		.handler	= handler,
+		.arg		= arg,
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
+		.lockless	= lockless,
 	};
 
 	return __kvm_handle_hva_range(kvm, &range).ret;
@@ -909,15 +920,36 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 				    kvm_age_gfn);
 }
 
-static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
-					struct mm_struct *mm,
-					unsigned long start,
-					unsigned long end,
-					unsigned long *bitmap)
+static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn,
+					     struct mm_struct *mm,
+					     unsigned long start,
+					     unsigned long end,
+					     unsigned long *bitmap,
+					     bool clear)
 {
-	trace_kvm_age_hva(start, end);
+	if (kvm_arch_prepare_bitmap_age(mn)) {
+		struct test_clear_young_metadata args = {
+			.bitmap		= bitmap,
+			.end		= end,
+			.unreliable	= false,
+		};
+		union kvm_mmu_notifier_arg arg = {
+			.metadata = &args
+		};
+		bool young;
+
+		young = kvm_handle_hva_range_no_flush(
+					mn, start, end,
+					clear ? kvm_age_gfn : kvm_test_age_gfn,
+					arg, true);
+
+		kvm_arch_finish_bitmap_age(mn);
 
-	/* We don't support bitmaps. Don't test or clear anything. */
+		if (!args.unreliable)
+			return young ? MMU_NOTIFIER_YOUNG_FAST : 0;
+	}
+
+	/* A bitmap was passed but the architecture doesn't support bitmaps */
 	if (bitmap)
 		return MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE;
 
@@ -934,7 +966,21 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+	return kvm_handle_hva_range_no_flush(
+			mn, start, end, clear ? kvm_age_gfn : kvm_test_age_gfn,
+			KVM_MMU_NOTIFIER_NO_ARG, false);
+}
+
+static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
+					struct mm_struct *mm,
+					unsigned long start,
+					unsigned long end,
+					unsigned long *bitmap)
+{
+	trace_kvm_age_hva(start, end);
+
+	return kvm_mmu_notifier_test_clear_young(mn, mm, start, end, bitmap,
+						 true);
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -945,12 +991,8 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 {
 	trace_kvm_test_age_hva(start, end);
 
-	/* We don't support bitmaps. Don't test or clear anything. */
-	if (bitmap)
-		return MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE;
-
-	return kvm_handle_hva_range_no_flush(mn, start, end,
-					     kvm_test_age_gfn);
+	return kvm_mmu_notifier_test_clear_young(mn, mm, start, end, bitmap,
+						 false);
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
-- 
2.44.0.478.gd926399ef9-goog


