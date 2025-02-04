Return-Path: <kvm+bounces-37193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6047A268B7
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7506B188641F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88714126C17;
	Tue,  4 Feb 2025 00:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f8hJsGj5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1346F2F2
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629660; cv=none; b=Ay4L+IzEtzTsl9mTM4+C7NJhqbjPrCePxQltOy2HVaKOJx1fQIVkWuF8BfRsCAtZo1HnOMj93Ey2HAyYHG3C/UKtasiPeQD4mFR0cqw4UTzxad3ZP0M873MpswB3tn/gvQIQz/8Y8pC58nsFrcWzOIooB47GJ4LmDJtrk8ckaqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629660; c=relaxed/simple;
	bh=UL28ZgR3kUeF2Xp82uMj6FzafYe+V0R6ZlLnORKDOpc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lj07qFvIAODeAoZGAK2qAkzyb1zoKrZHz5F465nNYvvO0DUA9rj2Ld4iMK2XTcGLfi51gqDq8RkES+IVG2bYN4VN3fRm7Svy1dwxYFDMDsZJDWB/xUKLx05KbbYZrGoxcoOJ1e/6lppHxom3Upvh1P/lCHIDyIYyNer6zrIXXGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f8hJsGj5; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-516054f130dso4146764e0c.3
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629656; x=1739234456; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UxEUYl8a/dKUlJdS6GEIUWUFOjQCNo9vrgo3n4ZkdWk=;
        b=f8hJsGj55j+ghiQ7nVU5BKbP5XIcRew4BoqdzAJ0a0kfR1PpXgYs2ZHWiQ4Av+gDPu
         LU+b849+eVYbc15Y56cgZQqmEVkhkFDVvDQ/tKyJVqhg/uRxHm4lkRkRavmxGEDvbWxT
         KJfb2ofGHycpVPmMuASt2Cn7oh0d2bxdj4QZ1lZuAw502iOystaStb5hUU7Nw3nJRgzL
         7mBcpn/9iXORVrrx6y1edn4g/WW6/xE+jny0uuPrtviBkIIXDkaH3ZlFXbXqC/FDOAom
         uJqoEKlHjrnkRiT3dZrMpTyNRxzP8Obb1HvpaKjnagI0sJxXsQBQctdxdIaJTdygKytv
         LGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629656; x=1739234456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UxEUYl8a/dKUlJdS6GEIUWUFOjQCNo9vrgo3n4ZkdWk=;
        b=Z7QSnKhS8DHQz5nDZZH/yzrdL9pDvHMtgkauUoRslmG3i9heIit9ustRy2ye+aeBVh
         EeoAtTod/pG1fJbhoTujpAM/GYU3iztUhzSeJORpYjBgGPVOszXOmjUCYLnq0R0G7KLj
         Ost6hCryCdcvgMKIEjM178YaD8Jf0ghDifLJqko5rEYj01f1ZY+Xmt/BhfKu9H5JxGIC
         7KSFgmUDDoLrGk009QCBr8kXQCadACB4zJWxgcGkjIc8r+jRk2wRpBlbVK0TCBJgqMlX
         PM52ktZivxohOF2wKtpeQ4Y+/CpDMPlBfzazyv39xkJifg8uI89WyxA643UJn1/6Ho1p
         DKcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTS3vJzYjkcEtv4Gk3OHa/lETaZvdwB1RmYYhtRdzWqTZC6GeziuHSywwflrFtTafARGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMr2ebmFD4d26ZjUtjL1GgykQ4KkcTrQlUX1i7W958oH401j+r
	1C9pDCuLlMfGvxcKAN2IrFNRPyE23UbNsHmTwceQVyjE2pr0Htey2TgtB00KZHZ1ablbqNsWuOC
	fzcowESioC7MJBcc/zw==
X-Google-Smtp-Source: AGHT+IH1OMmPekDOsDXJdjNiOLgCD/s/BK6ZQ+I8kVUAc7o1sZtVsX7n6D39xPBo/DPZuRGHQr2EoQQcIrmlSwCC
X-Received: from vkbcp2.prod.google.com ([2002:a05:6122:4302:b0:516:2831:75fd])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:3181:b0:51b:8949:c9a7 with SMTP id 71dfb90a1353d-51e9e5161abmr17882570e0c.8.1738629656189;
 Mon, 03 Feb 2025 16:40:56 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:28 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-2-jthoughton@google.com>
Subject: [PATCH v9 01/11] KVM: Rename kvm_handle_hva_range()
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rename kvm_handle_hva_range() to kvm_age_hva_range(),
kvm_handle_hva_range_no_flush() to kvm_age_hva_range_no_flush(), and
__kvm_handle_hva_range() to kvm_handle_hva_range(), as
kvm_age_hva_range() will get more aging-specific functionality.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index add042839823..1bd49770506a 100644
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
@@ -633,7 +633,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	return r;
 }
 
-static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
+static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
 						gfn_handler_t handler,
@@ -649,15 +649,15 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.may_block	= false,
 	};
 
-	return __kvm_handle_hva_range(kvm, &range).ret;
+	return kvm_handle_hva_range(kvm, &range).ret;
 }
 
-static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
-							 unsigned long start,
-							 unsigned long end,
-							 gfn_handler_t handler)
+static __always_inline int kvm_age_hva_range_no_flush(struct mmu_notifier *mn,
+						      unsigned long start,
+						      unsigned long end,
+						      gfn_handler_t handler)
 {
-	return kvm_handle_hva_range(mn, start, end, handler, false);
+	return kvm_age_hva_range(mn, start, end, handler, false);
 }
 
 void kvm_mmu_invalidate_begin(struct kvm *kvm)
@@ -752,7 +752,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * that guest memory has been reclaimed.  This needs to be done *after*
 	 * dropping mmu_lock, as x86's reclaim path is slooooow.
 	 */
-	if (__kvm_handle_hva_range(kvm, &hva_range).found_memslot)
+	if (kvm_handle_hva_range(kvm, &hva_range).found_memslot)
 		kvm_arch_guest_memory_reclaimed(kvm);
 
 	return 0;
@@ -798,7 +798,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	};
 	bool wake;
 
-	__kvm_handle_hva_range(kvm, &hva_range);
+	kvm_handle_hva_range(kvm, &hva_range);
 
 	/* Pairs with the increment in range_start(). */
 	spin_lock(&kvm->mn_invalidate_lock);
@@ -822,8 +822,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 {
 	trace_kvm_age_hva(start, end);
 
-	return kvm_handle_hva_range(mn, start, end, kvm_age_gfn,
-				    !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG));
+	return kvm_age_hva_range(mn, start, end, kvm_age_gfn,
+				 !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG));
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
@@ -846,7 +846,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+	return kvm_age_hva_range_no_flush(mn, start, end, kvm_age_gfn);
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -855,8 +855,8 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 {
 	trace_kvm_test_age_hva(address);
 
-	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-					     kvm_test_age_gfn);
+	return kvm_age_hva_range_no_flush(mn, address, address + 1,
+					  kvm_test_age_gfn);
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
-- 
2.48.1.362.g079036d154-goog


