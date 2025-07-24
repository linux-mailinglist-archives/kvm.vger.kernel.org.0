Return-Path: <kvm+bounces-53425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E38D9B114F0
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 01:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 406D73B950F
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812B724C68D;
	Thu, 24 Jul 2025 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4uYQdkiV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AD8246BC5
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 23:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753401112; cv=none; b=SL+LKIYUiocSChtA6ov5pGQoAlnvuT9XOC5/joG1UPcK9NmJ1wo20XmC8KPlGfOzeOv09SIZ0Mq91P4KCVNz4bNhIY2O6f8l4RDX2vd7drNt5KHgYxcQRSDXJnckWR8UdzSCGVcM8BYn01YQbeQBmcg0gRsTSI0VTzWLFlAuk/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753401112; c=relaxed/simple;
	bh=mJZhkVqzAlktMiicVdZMAgFidWnCL7xJSgsFsqv8CX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mkMkizMJBXVI366qb1j0FgZgfJjb0M/nwcC2TE7HmKqiEWeEKX5GZAxGpi24ciylKVhVjXlUKfxoTnzwxFqoqHbNCCNKVfPWMOBqosnW3NfjRtWTOieFHLfVFl1FN3mAOTnzyAhe6hQT9MIH0ItD7XJdd360F3VDoMNDXbEO3lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4uYQdkiV; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3e29380e516so31454215ab.1
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 16:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753401109; x=1754005909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0ewaMZlNiX4XUwdWiCIffQ7VQjkoCOyqrIjMyhZukM=;
        b=4uYQdkiVHPdv6CW4I4hM6Px7b/nT25U5ybV/eXnFSfByL1JXYNVcSekYe4bO0/W1NI
         EZIxc5hB2YO8DR5Es6djn5ESIfysnXCvBggeLcRhDJmL/5uQnbEdX9zHLwxNrosYJlMV
         V4m60j26YJZ3BwESkBYZFy3Txnyp7vuFY/0q+TsMbprquPy/OnJYDeE+dzC3zM+1h21N
         /byL1r5lS4m4frhRgJci/tmdOmO9Wu3JUwaZvOsynY6nUgxtwFq1Goo2NRZkxxHAciT2
         FHPWtrSXojGm45INV0qyOhqXwEHyoNK2mFRbaTQrOU07ncnLcE6j8UEDJt1AIT5LLnGn
         GHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753401109; x=1754005909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0ewaMZlNiX4XUwdWiCIffQ7VQjkoCOyqrIjMyhZukM=;
        b=vyxD12IU/qdwo9gLV1TYIEu0IGVuFTmjKoli6cmY24ysK+kFtQcmZRYeTwRjlICP6d
         uzjYmVu8llqV2Rmf3bY+UEZy4N56dM0Zxqgg1wRYnWOmPOdrqCST0QTFTMqcComPJzV/
         dA3sv8AEOEMJK0rTmMym/RDt8IUDdRFAyVEkNUXUt2Rb8rZDyEFGYsiqhPzAgQnDA1/4
         t5HXNv+uRszN7nQByvYWGR6gKpmS41hZuGE6Wcp5S1hpeDdOFGavl2u8IkXv8XG9lZhf
         52NOb93ENGagYxTlVMdDqJakywVPETwz8Qa1UjqNBIBAZCygz8cOmFYePJfJnVXN9NKd
         0fpw==
X-Forwarded-Encrypted: i=1; AJvYcCWdMaRrazydK3QucrSk9Q9r+6N9UTnwP3NS9VIu3eFjU6cS58HJ5rLxqIWviNC40v/2PGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz35bnsJI/sZo8jQlbwZ8zeqK3cg7vt8gKFPD7krbTp5edZ/Uyr
	DJNNKQVZ00x5qTnhPKLJ+7jUqMW2c+nuumosYb6eYTpnfITg0ACULiQ8PW1CAI+K5pJ7KkWJdot
	snyFjq49t3g==
X-Google-Smtp-Source: AGHT+IE3uwh7rhlhnMSw8HCvEnAO71PNq4x2deGAz1aZwNBL6ubSNi4i+u/4ukPGZg4fKVPvTraBAf35Sn8T
X-Received: from ilsx9.prod.google.com ([2002:a05:6e02:749:b0:3dd:ca88:fcaf])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:3c87:b0:3e2:c33f:351d
 with SMTP id e9e14a558f8ab-3e32fc216e6mr150034255ab.3.1753401109503; Thu, 24
 Jul 2025 16:51:49 -0700 (PDT)
Date: Thu, 24 Jul 2025 23:51:43 +0000
In-Reply-To: <20250724235144.2428795-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250724235144.2428795-2-rananta@google.com>
Subject: [PATCH 1/2] KVM: arm64: Split kvm_pgtable_stage2_destroy()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Split kvm_pgtable_stage2_destroy() into two:
  - kvm_pgtable_stage2_destroy_range(), that performs the
    page-table walk and free the entries over a range of addresses.
  - kvm_pgtable_stage2_destroy_pgd(), that frees the PGD.

This refactoring enables subsequent patches to free large page-tables
in chunks, calling cond_resched() between each chunk, to yield the CPU
as necessary.

Direct callers of kvm_pgtable_stage2_destroy() will continue to walk
the entire range of the VM as before, ensuring no functional changes.

Also, add equivalent pkvm_pgtable_stage2_*() stubs to maintain 1:1
mapping of the page-table functions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 19 +++++++++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h    |  3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++++++++++---
 arch/arm64/kvm/pkvm.c                | 11 +++++++++++
 4 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2888b5d03757..20aea58eca18 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -542,6 +542,25 @@ static inline int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2
 	return __kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL);
 }
 
+/**
+ * kvm_pgtable_stage2_destroy_range() - Destroy the unlinked range of addresses.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @addr:	Intermediate physical address at which to place the mapping.
+ * @size:	Size of the mapping.
+ *
+ * The page-table is assumed to be unreachable by any hardware walkers prior
+ * to freeing and therefore no TLB invalidation is performed.
+ */
+void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				       u64 addr, u64 size);
+/**
+ * kvm_pgtable_stage2_destroy_pgd() - Destroy the PGD of guest stage-2 page-table.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ *
+ * It is assumed that the rest of the page-table is freed before this operation.
+ */
+void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
+
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ea58282f59bb..ad32ea90639c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -197,4 +197,7 @@ void pkvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *
 kvm_pte_t *pkvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
 					       enum kvm_pgtable_prot prot, void *mc,
 					       bool force_pte);
+void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+					u64 addr, u64 size);
+void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..7fad791cf40b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1551,21 +1551,38 @@ static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				       u64 addr, u64 size)
 {
-	size_t pgd_sz;
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
 			  KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
+	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
+}
+
+void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
+{
+	/*
+	 * We aren't doing a pgtable walk here, but the walker struct is needed
+	 * for kvm_dereference_pteref(), which only looks at the ->flags.
+	 */
+	struct kvm_pgtable_walker walker = {0};
+	size_t pgd_sz;
+
 	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
 	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(&walker, pgt->pgd), pgd_sz);
 	pgt->pgd = NULL;
 }
 
+void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	kvm_pgtable_stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
+	kvm_pgtable_stage2_destroy_pgd(pgt);
+}
+
 void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level)
 {
 	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index fcd70bfe44fb..bf737717ccb4 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -450,3 +450,14 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	WARN_ON_ONCE(1);
 	return -EINVAL;
 }
+
+void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+					u64 addr, u64 size)
+{
+	WARN_ON_ONCE(1);
+}
+
+void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
+{
+	WARN_ON_ONCE(1);
+}
-- 
2.50.1.470.g6ba607880d-goog


