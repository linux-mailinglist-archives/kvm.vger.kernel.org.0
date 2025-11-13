Return-Path: <kvm+bounces-62972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C24AC55CE7
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EDF804E2500
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 05:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D686830C355;
	Thu, 13 Nov 2025 05:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yfH/cDac"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AA03093C0
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 05:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763011514; cv=none; b=jUaaw6DXiazbDlZYXyS2qt6iOGkhRfE3rxX8GhrAgjgchfOlMjDvP0gGjEZQ0ek8pkNoyfbmgmrc4bt1f556EvI22d7eMHscAKUOTrG4Tj8CJX6E+BN5pOaksxajmROvHYlDKMVcAQr+sE/dmh6gtyu/fZIuT8zry38zA2dGjgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763011514; c=relaxed/simple;
	bh=3MvUjAEITw8JSRCxSPotHQttoes8WfavPfN/6AC4l2A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nIWKX7o7UzmwzBw/PiX3xbSjmi/WKFMbueYMeeIKKAOR7wDLUvhou08e3wCvvv+VLWnVLwOATQWQxBSCegYrRupyfnDzNZndvsvz7gtqYHwIcP6qCxLBESq0ktghs3INipXPOmpwXUHrhKu8ZJfdXr7/EYD7og17Hr2qDb/szfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yfH/cDac; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-93e8092427aso54590339f.0
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 21:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763011512; x=1763616312; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ta7sr0PTTEzvgb7b4GWZ1P6Da8DksAgzSXe7OlGF+gA=;
        b=yfH/cDacUnoNKYpnsxFWKgP/2Qg0j/6lIaBon6YOapO4Z8dKTOMW6dmNaE1OBa6/gL
         RmzGdXYEmpcoGtqHHIBk0nH2IZsybtAcFPSvtGaxcqrCTlom6uvGRr8emCmD3jZtv60Q
         o39sDB84WamHhOmZ6rwKxcA5OWOrVN0ddr9oI4zi5i3Rc3w1NkGLdszUQpBjnkvEZ+xX
         GtGJmMyQrsZPnma0nZ4GcD2fd6+byRAQOBkOko1dvthOTgwuiRBiFtFNo83o/e98i/W7
         UeXPaKWsgmAOd4LLnz1R8cCvabj623Azoay27wDqJ4wfQSwS6yiWeIFRHocCiGWIB0EE
         Eu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763011512; x=1763616312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ta7sr0PTTEzvgb7b4GWZ1P6Da8DksAgzSXe7OlGF+gA=;
        b=hrJY/yomm9bDfE7pwh9pnxTYqUPXaR0Yx8OnyuUj78IefWAvGQzTnjdryRWaW3QhD4
         My44ZKzU8b70RVnitPL2hG1NGn7DjjPt43ZXouKiS0mMhCKCjPkr2DQaCYcKpChptoe0
         aG0tylvd985nRBjyS2Zna9fbC+SIaieaqIhq3p2y2GbpRqjBXg1xsHRIG5fKcRsLX2DE
         H3qimzPI2iGoWt6ysG5pM2h00JiOI4ekzZATASRvNo9fiZq9BCeI56giu2sMCeOOdvEa
         E8Ye8LXKoTlwkzQeZ6oF3IBJq8sMQ3iqKIhmDeDPulFbXNOxQWAQV+Q0wGraZjGY+Fx5
         o0Kg==
X-Forwarded-Encrypted: i=1; AJvYcCVXV0aicR98kK0xq565Rnixu/IoL7AScQLBZAviGmu83iX7dBYXa2W/yl+xIfQfYExV4jU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn6So1C/ICnSrG7UY8InOLcbZj/Z9Jf8jCQ3nBllcFI0tmM9xY
	4Gc6tGsbrSLC3qDINbu3GB8sUJrzmXjqsO2SExKpHFX5Oc6t/Gq/1qBc6fxnWLoJ5LL2aQ/33K2
	xY9OaIaQbuA==
X-Google-Smtp-Source: AGHT+IHMvk9ultN6RL8YYeEEQa9a2SgSGY279SAAWTq2ofAb1uDKUH6fYPApAnPv5ZmcPZ+gZVtFlIs2gOZI
X-Received: from iopt1.prod.google.com ([2002:a5e:dd01:0:b0:945:af6f:682e])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:8312:b0:948:9ff9:4189
 with SMTP id ca18e2360f4ac-948c46a06f5mr586614639f.19.1763011511803; Wed, 12
 Nov 2025 21:25:11 -0800 (PST)
Date: Thu, 13 Nov 2025 05:24:51 +0000
In-Reply-To: <20251113052452.975081-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113052452.975081-1-rananta@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251113052452.975081-3-rananta@google.com>
Subject: [PATCH 2/3] KVM: arm64: Split kvm_pgtable_stage2_destroy()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>
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
Link: https://lore.kernel.org/r/20250820162242.2624752-2-rananta@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 30 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h    |  4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 25 +++++++++++++++++++----
 arch/arm64/kvm/mmu.c                 | 12 +++++++++--
 arch/arm64/kvm/pkvm.c                | 11 ++++++++--
 5 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2888b5d037573..1246216616b51 100644
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
index 08be89c95466e..0aecd4ac5f45d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -180,7 +180,9 @@ struct pkvm_mapping {
 
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
index 6d6a23f7dedb6..0882896dbf8f2 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1577,21 +1577,38 @@ static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	}
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
index 7cc964af8d305..c2bc1eba032cd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -904,6 +904,14 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
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
@@ -980,7 +988,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return 0;
 
 out_destroy_pgtable:
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy)(pgt);
+	kvm_stage2_destroy(pgt);
 out_free_pgtable:
 	kfree(pgt);
 	return err;
@@ -1081,7 +1089,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
-		KVM_PGT_FN(kvm_pgtable_stage2_destroy)(pgt);
+		kvm_stage2_destroy(pgt);
 		kfree(pgt);
 	}
 }
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 24f0f8a8c943c..d7a0f69a99821 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -344,9 +344,16 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
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
2.51.2.1041.gc1ab5b90ca-goog


