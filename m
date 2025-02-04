Return-Path: <kvm+bounces-37194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3248DA268B8
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 973761648FB
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F26132103;
	Tue,  4 Feb 2025 00:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mwNdEXKj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0705B7081A
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629660; cv=none; b=ikJc2JHyrnOD1XpdOcn0+U7WJgKTRwZ1wTu3pAWsSNq4yz4Owa6BLmQj3C1ysGVnOh7rao5ZhB1Tx4yOA95W2f53uVOPjrS4Yq4Cb/+DU8wmqHNwftxAyNlpwPVDTmFb1ld15g2kDBl2zw0jlBE2y0KmgNa9N5ZSy7yD75Of2Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629660; c=relaxed/simple;
	bh=BgGA7ROTPL0sIEgMvRuiQa9cabWE/8+IjXJZdJHbfGw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IRbnq1l9jDqmBWtMHT3OuOQzut9TbMwWXdNYjEJeAAfcSGfXC0hN+NdqPt56xULTHdILJ/rcy12Chx/4VAKXcvJz4bToUf5Za07/B3o7IVO5oVG2HCoOxOfo4XkfqdEGVjOJa+ORjx3adassRFf8c4pERds4hPUcmrqZ/3KsuB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mwNdEXKj; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4affab6057dso648470137.0
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629657; x=1739234457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p6K1OVMuQTd658Umax8NEjVCXyrHg3jp4bgkmGXf6oM=;
        b=mwNdEXKjyUKZPytD7GrhMD/ZXFhxYtlElMZJRr1CsvM43MP6T4omE+tuyu4DW662Rw
         WYJDUqZsl3Z76oGOBibpa56oOejJbnTxJDR8D6Cq72MIKg2zHLL0lLT03+9cKlvnYlKO
         0d36kDpThzUoxYvuwdWh9nHKKYfPjjGDahJoDF8cIeoyl8cJ16Yhdqj19CryqK+n28p9
         CxMRWBnwvZYESjSZtka/8Okt5lbERVbCEnMGc3TBFRzaCYpKvAhv3t0m5C3Ul5/J7IE9
         NN3exiCWTBEtgg7IvaxBrTSTcxJiY9k8bF+CDDDk6KfJyZFyuMrcxOtk98WHDLSUgAQc
         FaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629657; x=1739234457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p6K1OVMuQTd658Umax8NEjVCXyrHg3jp4bgkmGXf6oM=;
        b=MN5rIHKc8emDNMtczk0ca1sc6VXl+l+yLW+zDhyK94M7MOi/X/7WgtcoJk5K+6Bcpr
         KucU9jJWT1o0rxNFrIffTpELgSV1ojJLBbLA91sGNEdDoAjfICJcCaHGQ8/mXm8DJgyT
         nln41eYMAtzS6SOr6JiUDbprM/avGoZZQRX8H1adzMfn5kFBhq27fotXuAYLis3HFNAa
         jz0mq8CZe9HH+RJ6mPOiVh38y21k9aFzAVmBiNU/gWKRhSYRjdmLbOhagvs3kmq7RUQX
         oytRvlpzL1avTx6596tGyxaymGBSYPQbxCdbJj2oiqwLRupRLj82Cb7JB06b8SYh874w
         /QBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaiBH8vwPlYz3y4mMZ8fk6ykZIQP2kgr6KgKF+qLR9poCWtlXfCwZ8Hl7o9GZfpYXfuaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YykaHL2L/BxxTbBar89Qs78vTysq5AB6vkdaGmd4YUggvfDz34x
	JoHMHGWdPis3mYuIjghlfNcdeCI04qgDQkjH6YdvLIs3QKijL6Bj6UVyUvHvGgYfijgVMx1dBsy
	fsCWs4RetHP3ABFTVvg==
X-Google-Smtp-Source: AGHT+IG7mZazUgI6zXPd8PxKR1PwQ9GiCLBimHc3vVCrmcoMwEafOmvY7s+h7RDaMlvDg6+p4+ggaHz+iPCzJVV7
X-Received: from vsqd6.prod.google.com ([2002:a05:6102:406:b0:4ba:d75:c698])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:504b:b0:4b1:1b33:eb0f with SMTP id ada2fe7eead31-4b9a526c5f9mr19288103137.24.1738629656799;
 Mon, 03 Feb 2025 16:40:56 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:29 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-3-jthoughton@google.com>
Subject: [PATCH v9 02/11] KVM: Add lockless memslot walk to KVM
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

It is possible to correctly do aging without taking the KVM MMU lock;
this option allows such architectures to do so. Architectures that
select CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS are responsible for
correctness.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/Kconfig         |  2 ++
 virt/kvm/kvm_main.c      | 24 +++++++++++++++++-------
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f34f4cfaa513..c28a6aa1f2ed 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -267,6 +267,7 @@ struct kvm_gfn_range {
 	union kvm_mmu_notifier_arg arg;
 	enum kvm_gfn_range_filter attr_filter;
 	bool may_block;
+	bool lockless;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 54e959e7d68f..9356f4e4e255 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -102,6 +102,8 @@ config KVM_GENERIC_MMU_NOTIFIER
 
 config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
        depends on KVM_GENERIC_MMU_NOTIFIER
+
+config KVM_MMU_NOTIFIER_AGING_LOCKLESS
        bool
 
 config KVM_GENERIC_MEMORY_ATTRIBUTES
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1bd49770506a..4734ae9e8a54 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -517,6 +517,7 @@ struct kvm_mmu_notifier_range {
 	on_lock_fn_t on_lock;
 	bool flush_on_ret;
 	bool may_block;
+	bool lockless;
 };
 
 /*
@@ -571,6 +572,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			 IS_KVM_NULL_FN(range->handler)))
 		return r;
 
+	/* on_lock will never be called for lockless walks */
+	if (WARN_ON_ONCE(range->lockless && !IS_KVM_NULL_FN(range->on_lock)))
+		return r;
+
 	idx = srcu_read_lock(&kvm->srcu);
 
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
@@ -607,15 +612,18 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
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
-					goto mmu_unlock;
+				if (!range->lockless) {
+					KVM_MMU_LOCK(kvm);
+					if (!IS_KVM_NULL_FN(range->on_lock))
+						range->on_lock(kvm);
+
+					if (IS_KVM_NULL_FN(range->handler))
+						goto mmu_unlock;
+				}
 			}
 			r.ret |= range->handler(kvm, &gfn_range);
 		}
@@ -625,7 +633,7 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 
 mmu_unlock:
-	if (r.found_memslot)
+	if (r.found_memslot && !range->lockless)
 		KVM_MMU_UNLOCK(kvm);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -647,6 +655,8 @@ static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= flush_on_ret,
 		.may_block	= false,
+		.lockless	=
+			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS),
 	};
 
 	return kvm_handle_hva_range(kvm, &range).ret;
-- 
2.48.1.362.g079036d154-goog


