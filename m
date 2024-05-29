Return-Path: <kvm+bounces-18330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF318D3DEE
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 20:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5CAD286A0B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 18:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4B61C68B1;
	Wed, 29 May 2024 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s7MBpJ1m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3451C0DEE
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717005924; cv=none; b=rMOwfoqrKQ0t+w8JQFEhoXhIWVnHg3iA6cEuhETiHSFhlGjBjYm2kA+K8/k7LJtG/JLQqzLCyCcUPpLf1AuMA+vROhdLQwlnDy9qIjYpLc60b4sPVI4/qu0pQcn+PdVsyT75IVWpJnaOYUmbispGXJbVJvlSzxt2DplXD1iuTj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717005924; c=relaxed/simple;
	bh=SWsXA6zISqxg7q/RviiZ4NedczRmTyw4MPVWOHpV4Is=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RZVtsafu6WpkiKkTVj+fukN87ci4UnvhPC/Gpeg4kpeJtc6Oax34PIMjsGTeNIhiyU9xpnw12ex60TjBZPqD74s8mJpJpW0TtY+JPz2wbhDcMPd+PZ1xw/qRRj3LpSjnHCOcblijLxro915GjJ9Cbg5Ku7HtYGZEOhqmhdoYGMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s7MBpJ1m; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-804f9eea128so30874241.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 11:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717005920; x=1717610720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9IVaEi5zQfJ05wKpIy/u5NLNm+GzTdT+Fqa7TW9318s=;
        b=s7MBpJ1mHbnkciR9D20cJ6JpiWCtHVtbp1Xs4X2ToDNocrXxNDD99pTaf8IBdMQ+Ch
         K5+dqPBtAGsL+eW4M3bIVGJ8gRZNPafS9gFSaHCdbz7XKeR2zeRUM8TG+SyeEJONnQ+5
         5RSSLmFj3mVvfz/CWNpYKjFi1qKShk+L8qU1wUzvGpe4G0O8Jfdp1yQpTJ96Jsdak4BV
         6ztaNRvVQKyEC58xBXmTIh+H4qY4yN0StoFCeZTSN3nA4w0itvMCxdo9NIxSsIxNp2/I
         zRZG848LjREmCP0kKyqUMtB3EhynDvJJ/i0zCb8u7tbSBx4oaN2x0bbZ780p+p/4diax
         QpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717005920; x=1717610720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9IVaEi5zQfJ05wKpIy/u5NLNm+GzTdT+Fqa7TW9318s=;
        b=iIIfygBzhoG02BkrPBxqnaSWDLPyB4GYE+mW7Usq3niOQPWhJhhfkfL/VJFkWc3L8E
         gJ7T2PvyYkn1QrHeBEygSsba+TyuLO5yCweOh7xrXRURVKDid7hjwm6JKGD78Lb+mQNr
         fXcxnCIfNB8g82IA/xOstuCT/J7I04R6U/nN3KxZM4XWQ2Ljimcs5RajLiHV/2EM3LA4
         jxRlbnNORTvnQjInUHCa7CowkaFfb+c3AVlLWAAM2wm5HKEipMP5CgI9TuJXO+HOcLkJ
         d2hstLOUuF+53hysp44Z0IBNMrIgG6+4NA8uebmxfWqrwuFTDaP4OezSm2+rYFNeSX6t
         EK9A==
X-Forwarded-Encrypted: i=1; AJvYcCVuttqJ5YAG39Upn1yh1+TQD8c0QutCVks0X/e0pYnrbcLlJuCF4sZuh/LPjJgTodpTKjo23EdHIvXHqlbfrBBfXbcX
X-Gm-Message-State: AOJu0YybFLxsVRMTCQDlf1nP53PZsEjdrrlFXgWb6GOP1uBd2WgilWFY
	Q1cMjkT1jvexE/1mUU27e1CkQhTgBJvck+LCGb50SCnxhoajKiJJ/lWXcV2ALBzED0teU9QFb6y
	HMljv2g+hXWpSr0ykDA==
X-Google-Smtp-Source: AGHT+IHvckbiyzzys4cYuqrWT42OTG48lfJUuChD2cJY5KHOUyTU+EmIW59KYswmWzGhXx+WNvqLQXCKjQe35xSx
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6130:2289:b0:80a:5330:87c5 with
 SMTP id a1e0cc1a2514c-80a5330931fmr5289241.2.1717005920232; Wed, 29 May 2024
 11:05:20 -0700 (PDT)
Date: Wed, 29 May 2024 18:05:06 +0000
In-Reply-To: <20240529180510.2295118-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529180510.2295118-4-jthoughton@google.com>
Subject: [PATCH v4 3/7] KVM: Add lockless memslot walk to KVM
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Houghton <jthoughton@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Provide flexibility to the architecture to synchronize as optimally as
they can instead of always taking the MMU lock for writing.

The immediate application is to allow architectures to implement the
test/clear_young MMU notifiers more cheaply.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 38 +++++++++++++++++++++++++-------------
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 692c01e41a18..4d7c3e8632e6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -266,6 +266,7 @@ struct kvm_gfn_range {
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
 	bool may_block;
+	bool lockless;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..d197b6725cb3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -558,6 +558,7 @@ struct kvm_mmu_notifier_range {
 	on_lock_fn_t on_lock;
 	bool flush_on_ret;
 	bool may_block;
+	bool lockless;
 };
 
 /*
@@ -612,6 +613,10 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 IS_KVM_NULL_FN(range->handler)))
 		return r;
 
+	/* on_lock will never be called for lockless walks */
+	if (WARN_ON_ONCE(range->lockless && !IS_KVM_NULL_FN(range->on_lock)))
+		return r;
+
 	idx = srcu_read_lock(&kvm->srcu);
 
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
@@ -643,15 +648,18 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
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
@@ -660,7 +668,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && r.ret)
 		kvm_flush_remote_tlbs(kvm);
 
-	if (r.found_memslot)
+	if (r.found_memslot && !range->lockless)
 		KVM_MMU_UNLOCK(kvm);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -686,10 +694,12 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
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
+		bool lockless)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
@@ -699,6 +709,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
+		.lockless	= lockless,
 	};
 
 	return __kvm_handle_hva_range(kvm, &range).ret;
@@ -889,7 +900,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+	return kvm_handle_hva_range_no_flush(mn, start, end,
+					     kvm_age_gfn, false);
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -899,7 +911,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	trace_kvm_test_age_hva(address);
 
 	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-					     kvm_test_age_gfn);
+					     kvm_test_age_gfn, false);
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
-- 
2.45.1.288.g0e0cd299f1-goog


