Return-Path: <kvm+bounces-52765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3FAB091CB
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 399E13BECB1
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547A82FEE16;
	Thu, 17 Jul 2025 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KJzBFvos"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC6A2FE383
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769668; cv=none; b=nRzqTgimzKBLjVqaeWTKPd2W9R2AS2swy5P/R41kPqgmyvoD6FYG/Ky21a8+HskRvoL1PAXYSzgZC/1pUotdtLlP2D3eD3T+PfspTPJ2U//GTwOWExjeo4PR+t9L8wbVP1yYpXkPkTjfiDEuCt3CGnOUwj2UC25UgQv3slUKRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769668; c=relaxed/simple;
	bh=xurDWAtZkL6bObNk6B6ReVIsKjxDthfj6nKjWzzTH4k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gt0fVgM8g7WzzSg6Jcgr7sZeZm0S+NmYe1RKRLJ3XJI70EHlUCahKMP6fZrkDzQ7Lm4jANl72STbGW4WkZ4p1ZlCsi5VjaX1urakosRix6OtSXWo/4k2runiWO2j1Bc492sV/dlacicfQx8W68fKT8ldqkLNXrxjS2+V0SgK0us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KJzBFvos; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45597cc95d5so6382335e9.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769665; x=1753374465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vj4FcImTJCIyi98y1V49b83tOyghRW7/aml55WLH8OI=;
        b=KJzBFvosjiqTL0U02p2HeBEpkmLHYMVJtdYtsWxgEOIzbuviEa0RG4NM1wGNvnyY5m
         Ya0Y6U9WbSC3trXsJWzfeLLs8uVH5AbtLQJ4jlQ5kZ8f4s9xfoUNFzsADFhQPMZKTFbO
         6jhAhChKHXYuvu8XCPM9g/wxGhWwC8YLSp6M4Tlf8CQnF0o7vAZGtOJDWg1RJck2WlUz
         bBajZbNkRYkOiF0KHqWNrdy6mLL8bfmATwujwvTKabvHRoY71c0thbQlqS96S6qGIiTX
         ygobDHygsYjOt+hycBYQHLkXjiTfPPDHrCHVWsJDCKo9El/rwgkXBzRdmU/ZordOLZpg
         7CBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769665; x=1753374465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vj4FcImTJCIyi98y1V49b83tOyghRW7/aml55WLH8OI=;
        b=xM8XYQWQE8FB3efM7bG33BjgtBCCvr8pdnXifj+05mu8n2ROyQVh5eXKsvL2XgOT6W
         U15ypLlILpciu4FonjeKAYTVv9ITugaGEK1b17jI57TAlBugyVW0qxuBKTYMzyO43hKT
         V7obIsj14BMnAfL3uvPzUZ4m/KLmf6GCtn0Sjo7Lnm6W7seh687rQpML8Nyhl4K/Emeu
         YjdXsXh/twXP3VDFiXe/XjEfmXMhCiDuT5Kkl5SyPT/rWylahcnJSUmntBUtwt43amNN
         6fEpHPPCjpTu6FaL6zYpV8DeGsWTf6Hg98B/imcENN+wBLTzW9nEYP1OinI9r/De9pzi
         OWng==
X-Gm-Message-State: AOJu0YwbC4aPPuZk+MmK+i/tX3QW7PVpBUcYVhucauKBPnpfAK7A5Shm
	BZ2jUhNDFidqrmM6OUULyYiQzI9tcMdisPOXw+sNOWVN8MGNEXZfRnvy/4kgGss2jHxL7zxyTAI
	s+gaM0UBub71WoRxyOk7b37qhfsGlKIbSn8WdbSSyKPZsAgu30jEQnvekYgj0dEK8R1Rl3ejyq6
	yZp0NY/4V3IUKOP6dza9LPMdBvyCc=
X-Google-Smtp-Source: AGHT+IGX3NQvvDMUofafuVPFgyASWN1/bLW2GTIJYT/sdS6bflD836GYOEbMPrT78AXCy7zcu7MAVXDMSg==
X-Received: from wmbjg15.prod.google.com ([2002:a05:600c:a00f:b0:456:2080:97c0])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45cd:b0:43e:bdf7:7975
 with SMTP id 5b1f17b1804b1-4562e39b723mr69794275e9.32.1752769664668; Thu, 17
 Jul 2025 09:27:44 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:22 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-13-tabba@google.com>
Subject: [PATCH v15 12/21] KVM: x86/mmu: Consult guest_memfd when computing max_mapping_level
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Modify kvm_mmu_max_mapping_level() to consult guest_memfd for memory
regions backed by it when computing the maximum mapping level,
especially during huge page recovery.

Previously, kvm_mmu_max_mapping_level() was designed primarily for
host-backed memory and private pages. With guest_memfd now supporting
non-private memory, it's necessary to factor in guest_memfd's influence
on mapping levels for such memory.

Since guest_memfd can now be used for non-private memory, make
kvm_max_max_mapping_level, when recovering huge pages, take input from
guest_memfd.

Input is taken from guest_memfd as long as a fault to that slot and gfn
would have been served from guest_memfd. For now, take a shortcut if the
slot and gfn points to memory that is private, since recovering huge
pages aren't supported for private memory yet.

Since guest_memfd memory can also be faulted into host page tables,
__kvm_mmu_max_mapping_level() still applies since consulting lpage_info
and host page tables are required.

Move functions kvm_max_level_for_order() and
kvm_gmem_max_mapping_level() so kvm_mmu_max_mapping_level() can use
those functions.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 90 ++++++++++++++++++++++++----------------
 include/linux/kvm_host.h |  7 ++++
 virt/kvm/guest_memfd.c   | 17 ++++++++
 3 files changed, 79 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6bd28fda0fd3..94be15cde6da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3282,13 +3282,67 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 	return min(host_level, max_level);
 }
 
+static u8 kvm_max_level_for_order(int order)
+{
+	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
+
+	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
+		return PG_LEVEL_1G;
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
+				     struct kvm_page_fault *fault)
+{
+	u8 req_max_level;
+	u8 max_level;
+
+	max_level = kvm_max_level_for_order(order);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
+	if (req_max_level)
+		max_level = min(max_level, req_max_level);
+
+	return max_level;
+}
+
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	bool is_private = kvm_slot_has_gmem(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
+	int max_level = PG_LEVEL_NUM;
+
+	/*
+	 * For now, kvm_mmu_max_mapping_level() is only called from
+	 * kvm_mmu_recover_huge_pages(), and that's not yet supported for
+	 * private memory, hence we can take a shortcut and return early.
+	 */
+	if (is_private)
+		return PG_LEVEL_4K;
 
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
+	/*
+	 * For non-private pages that would have been faulted from guest_memfd,
+	 * let guest_memfd influence max_mapping_level.
+	 */
+	if (kvm_memslot_is_gmem_only(slot)) {
+		int order = kvm_gmem_mapping_order(slot, gfn);
+
+		max_level = min(max_level,
+				kvm_gmem_max_mapping_level(kvm, order, NULL));
+	}
+
+	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level, is_private);
 }
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -4450,40 +4504,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		vcpu->stat.pf_fixed++;
 }
 
-static inline u8 kvm_max_level_for_order(int order)
-{
-	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
-
-	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
-		return PG_LEVEL_1G;
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
-		return PG_LEVEL_2M;
-
-	return PG_LEVEL_4K;
-}
-
-static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
-				     struct kvm_page_fault *fault)
-{
-	u8 req_max_level;
-	u8 max_level;
-
-	max_level = kvm_max_level_for_order(order);
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
-
-	return max_level;
-}
-
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d2218ec57ceb..662271314778 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2574,6 +2574,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
+int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2583,6 +2584,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
+					 gfn_t gfn)
+{
+	WARN_ONCE(1, "Unexpected call since gmem is disabled.");
+	return 0;
+}
 #endif /* CONFIG_KVM_GMEM */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2b00f8796a15..d01bd7a2c2bd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -713,6 +713,23 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
+/**
+ * kvm_gmem_mapping_order() - Get the mapping order for this @gfn in @slot.
+ *
+ * @slot: the memslot that gfn belongs to.
+ * @gfn: the gfn to look up mapping order for.
+ *
+ * This is equal to max_order that would be returned if kvm_gmem_get_pfn() were
+ * called now.
+ *
+ * Return: the mapping order for this @gfn in @slot.
+ */
+int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_mapping_order);
+
 #ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
-- 
2.50.0.727.gbf7dc18ff4-goog


