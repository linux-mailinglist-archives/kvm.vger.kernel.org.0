Return-Path: <kvm+bounces-55194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8882CB2E236
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 18:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10FE51C475C6
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F07431E0FD;
	Wed, 20 Aug 2025 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uOsGb/Cq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A485D3277AF
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755706969; cv=none; b=hS/e99Ul4/LtvhF2uc+bFjsfC37vwQlQP8eDjbrZ9urBQ68u9BzsV4duBZOAbP2i21l3+1SDb0G+TzUbJqnDMIB32XVVJe0/yqbb5DOaUt8F7v2Cj02tkVTMagJu/7JpLlfOOWEv7U68UPO5PgnkAb13U8QBF4axBeYdWqMjUnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755706969; c=relaxed/simple;
	bh=rnxTonDSNPXs5FCxS6Of9bvwZEGqBmpHPLERN309rp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j8cW5xntTv2PsyXsmzesA5U3BeWwHYDRpElweiCyEs2DRcJHouFeW8PaVXc9o9o3tDpDhTEn2DQLyRREyGueXos0jFyXkF6ZGxNfqZQYimVT1NnUoqkA1Yecbie4ncNw7zCS6fT9ojvFbzS4F57nIUQa1j5TWPcLv6bEi9YQpbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uOsGb/Cq; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-88432e1f068so737544739f.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 09:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755706967; x=1756311767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dWAJht+0s/guAhpHqYXPso1akQHfmjOy8KfjWfGKDJM=;
        b=uOsGb/Cqdelix8cJIFW6d0PULiIpQVLKSDDv+sB9H1XBTsfjFoSgtRWhMuEBnJqT6J
         O491/RbvVFs/kmo9Cmt9eCOWrUCjJeLW/DmCg/UrTZbfu40LA/B16z/vgXYEn31CcEQf
         PYkzp5cWnNmgbOAxZ42HJp0Zert6UvU5yz5+ZepR68skmXnfi/xd5FdxEUq1rzqtl38R
         A4Gs2zN8nm/MyXaYdYN32F6JTR1fb0LhyUH5AA/HAHz6v248UPgyG4APB0vlCOg9M2HW
         3QcfWiflcbo5ud6o4Mf6fSsu1zBPoq/5CTFr5v03xxURKqPbLxzRzeDdQOl8845HMD6o
         mKag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755706967; x=1756311767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dWAJht+0s/guAhpHqYXPso1akQHfmjOy8KfjWfGKDJM=;
        b=uW0F9Szid1dt5vz8dkegixv0tGS5xc+6R2KczVtoe8HB8NSNsI+WhGramkFrGDMgb/
         gX34cRnh1kuSAbP6xUIWavEEKm9Z3u4aht7dJS+cyhFJLC159uhkuXBfjoXZtmkvrBRz
         hPKxd64DAXh4UcfW5bxhSX2ZX+lpWTNz8KMv5QO33lC7bFfAYiFnVNyFpHZUR1SBYFso
         2Wpt2kLzvHZPmsM7TtDE98UVc3OE000OKDeZuSbyYJGpO2q56h8ByWkP9sxo9O02k+Ya
         wjG7WZpX1WO0Qe+FOoL5SKdPGWlokP4u26aXrhfy09W7dCXSqzfbPTzQkUgmRqCBhRq4
         WuGA==
X-Forwarded-Encrypted: i=1; AJvYcCUe2aVmGXsA88O1YmLBYGjpiYaceeQAHaFwbQpKJiuD6noB8oIDXDedgAGNskzulgOjvVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfoUFvDdeac0leIMHFLZZpYX5RoX0eDevIUFiS1cvxW/wH9OUN
	5WCBbujAQzQyAhhkIHZZolBa3V2potAOpvYiRSoim/tcLkjb+tQ2zCVBtIrIa7mXsz5VtuPV9cH
	IHwxr9PTN3w==
X-Google-Smtp-Source: AGHT+IGr91NNpYqJGSQuJm4ghXc/RFMzXTzX9dbp2NGvcmWuajHz8+Psx6HTRNeVlGvCz79RD8rPG9bKd7E9
X-Received: from iobeu2.prod.google.com ([2002:a05:6602:4c82:b0:881:7069:9679])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3402:b0:87c:72f3:d5d7
 with SMTP id ca18e2360f4ac-88471b0adadmr748916839f.13.1755706966799; Wed, 20
 Aug 2025 09:22:46 -0700 (PDT)
Date: Wed, 20 Aug 2025 16:22:41 +0000
In-Reply-To: <20250820162242.2624752-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250820162242.2624752-1-rananta@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250820162242.2624752-2-rananta@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: Split kvm_pgtable_stage2_destroy()
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
in chunks, calling cond_resched() between each chunk, to yield the
CPU as necessary.

Existing callers of kvm_pgtable_stage2_destroy(), that probably cannot
take advantage of this (such as nVMHE), will continue to function as is.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 30 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h    |  4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 25 +++++++++++++++++++----
 arch/arm64/kvm/mmu.c                 | 12 +++++++++--
 arch/arm64/kvm/pkvm.c                | 11 ++++++++--
 5 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2888b5d03757..1246216616b5 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -355,6 +355,11 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return pteref;
 }
 
+static inline kvm_pte_t *kvm_dereference_pteref_raw(kvm_pteref_t pteref)
+{
+	return pteref;
+}
+
 static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
 {
 	/*
@@ -384,6 +389,11 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return rcu_dereference_check(pteref, !(walker->flags & KVM_PGTABLE_WALK_SHARED));
 }
 
+static inline kvm_pte_t *kvm_dereference_pteref_raw(kvm_pteref_t pteref)
+{
+	return rcu_dereference_raw(pteref);
+}
+
 static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
 {
 	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
@@ -551,6 +561,26 @@ static inline int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2
  */
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
+/**
+ * kvm_pgtable_stage2_destroy_range() - Destroy the unlinked range of addresses.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @addr:      Intermediate physical address at which to place the mapping.
+ * @size:      Size of the mapping.
+ *
+ * The page-table is assumed to be unreachable by any hardware walkers prior
+ * to freeing and therefore no TLB invalidation is performed.
+ */
+void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+					u64 addr, u64 size);
+
+/**
+ * kvm_pgtable_stage2_destroy_pgd() - Destroy the PGD of guest stage-2 page-table.
+ * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
+ *
+ * It is assumed that the rest of the page-table is freed before this operation.
+ */
+void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
+
 /**
  * kvm_pgtable_stage2_free_unlinked() - Free an unlinked stage-2 paging structure.
  * @mm_ops:	Memory management callbacks.
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ea58282f59bb..35f9d9478004 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -179,7 +179,9 @@ struct pkvm_mapping {
 
 int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			     struct kvm_pgtable_mm_ops *mm_ops);
-void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
+void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+					u64 addr, u64 size);
+void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
 int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 			    enum kvm_pgtable_prot prot, void *mc,
 			    enum kvm_pgtable_walk_flags flags);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..c36f282a175d 100644
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
+	size_t pgd_sz;
+
 	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
-	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(&walker, pgt->pgd), pgd_sz);
+
+	/*
+	 * Since the pgtable is unlinked at this point, and not shared with
+	 * other walkers, safely deference pgd with kvm_dereference_pteref_raw()
+	 */
+	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref_raw(pgt->pgd), pgd_sz);
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
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1c78864767c5..e41fc7bcee24 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -903,6 +903,14 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	return 0;
 }
 
+static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
+
+	KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, 0, BIT(ia_bits));
+	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
+}
+
 /**
  * kvm_init_stage2_mmu - Initialise a S2 MMU structure
  * @kvm:	The pointer to the KVM structure
@@ -979,7 +987,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return 0;
 
 out_destroy_pgtable:
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy)(pgt);
+	kvm_stage2_destroy(pgt);
 out_free_pgtable:
 	kfree(pgt);
 	return err;
@@ -1076,7 +1084,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
-		KVM_PGT_FN(kvm_pgtable_stage2_destroy)(pgt);
+		kvm_stage2_destroy(pgt);
 		kfree(pgt);
 	}
 }
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index fcd70bfe44fb..61827cf6fea4 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -316,9 +316,16 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 	return 0;
 }
 
-void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+					u64 addr, u64 size)
 {
-	__pkvm_pgtable_stage2_unmap(pgt, 0, ~(0ULL));
+	__pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+}
+
+void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
+{
+	/* Expected to be called after all pKVM mappings have been released. */
+	WARN_ON_ONCE(!RB_EMPTY_ROOT(&pgt->pkvm_mappings.rb_root));
 }
 
 int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


