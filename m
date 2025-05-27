Return-Path: <kvm+bounces-47816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7AFBAC59D0
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15B4F8A8226
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306402853E7;
	Tue, 27 May 2025 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xE/LgZBh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D43928469C
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368993; cv=none; b=s2F1jjMzM3bM4RRqwrPXMHok8N2xySzMx/39+pmiqHnMUdOt0VpF9pWvk2Cs8XLP9cr3LpdMsNf6WE2tlcJDWyg5Prvyb7XZ8A0q6qIZNtAulZMFZiMQK4aDE/biPdh6S7L3VvFa6u7c3fcnyWHyeKOCZe6LDGdpjI6brXGXp44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368993; c=relaxed/simple;
	bh=6JY7lxvtft8Eq4rZz2tvt8Cyg9mUIwrdG8wuh3RdHc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FsupUkTlNtap0BuhJ4zeGqgzgfW3C687JpV0qQ0GOvNu2U9Hf1ymM9rQK7Ng2DRQeKBHU6riTuntOFt6gM332gU2Qun1Vemj2+N1fRCf8b5nKlGyoGDQs3Dr86eboUvUtou2T7vnqJI6kH5Fmuz8HZUKEM5L4CnPAEhKD6+HOHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xE/LgZBh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-44059976a1fso18034775e9.1
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368990; x=1748973790; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tGxGAz/J8q+l9ioy8ZyCt7XqRvXAVcRnGlKU7YzuHUQ=;
        b=xE/LgZBhfrvbjgtxX+yGOTjhSkHV+2FmYKDnUnlRIlAyNRNLfg109KTJNm7cqoTNWh
         ZTVdi15A13Eo4+UWyg6PXoZ55DV24nmvM5mym/gd9G8dWmlS7VaLrZDXTes+0R9QImaI
         clRklktkiqKhGeyrizAjVv0vx3w6f1evXthkAXcz4C4Y7lk3UuCwLHMbbY0RM+A+rthz
         aEPAgiLSvS5GieXydQVJdxrs6fAHObHy+h/uvxzYdtI9EY3xWQKVqxO92U450mTM9Hsg
         t10H+nNc4owwQVnKYphygO8gy9BjLLcM3KRkSiaj3YTYCmvyCHJnIQZXEOzYZLCGvVtz
         wVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368990; x=1748973790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tGxGAz/J8q+l9ioy8ZyCt7XqRvXAVcRnGlKU7YzuHUQ=;
        b=cFJAlPwB6I+Ul40golSCh6vUswLe6OLDQvduxkWddQ4uO5KsYtcQVmNnULme1w+3RW
         zbOboSKo9cQKSA/Ut1G9cxqaonWfAKHVQy713I9Ti6j+XYQS9nYo9+v2d+tJomLeuRJV
         nH/zeCy4PL7d4JeOSPfMHg/KIySBiYxHw9yWS4IWE8+jfyr8RA5JBP1MpV0XUj8ghPSo
         dHPoA3IUWoGqLhqVP8vNX4UoR/W5k2HmKXYc060AoILUGigaTLtrD5tb11+vKDmuECTl
         s6Ug9hj7frR0yaF4wmE828mmJE+bHOuaKcnxpaiamCociv+YX/WsWIFUuIi3w0Xi8N5L
         JWMg==
X-Gm-Message-State: AOJu0YwT7Kzrl6+Vu3MykYqHu5XYQYjw4B6CrDqSPiDyT3m+Rd86FuOk
	riXMSl6m8MvpcaC/a0ARm3FWMo21GZ1jpCeddxH53U5yq7wDDeM5nVZ2REFPHMzI0uJ987pEQ8v
	Ur4PCF+PwNNc6Cqbb+ulcrC1pOMzp/gcJvzVvrx3vCimGeUTPZ/mNf1jnbpcnvM8fn/g9tpgmEq
	JnbdvJLXNfRAsp5GDgVKZBw9GRZpU=
X-Google-Smtp-Source: AGHT+IHCdTen+VlEN4YQKRHsWbOzuscw8dC+M4jud7nfLuiyuZdUz84LMjBfZHDeQ9BGX6pnIYBwYRdpZg==
X-Received: from wmrn14.prod.google.com ([2002:a05:600c:500e:b0:440:6830:ae64])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3c93:b0:43d:fa58:81d3
 with SMTP id 5b1f17b1804b1-44c933f0edfmr102933645e9.32.1748368989076; Tue, 27
 May 2025 11:03:09 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:40 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-12-tabba@google.com>
Subject: [PATCH v10 11/16] KVM: x86: Compute max_mapping_level with input from guest_memfd
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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

This patch adds kvm_gmem_max_mapping_level(), which always returns
PG_LEVEL_4K since guest_memfd only supports 4K pages for now.

When guest_memfd supports shared memory, max_mapping_level (especially
when recovering huge pages - see call to __kvm_mmu_max_mapping_level()
from recover_huge_pages_range()) should take input from
guest_memfd.

Input from guest_memfd should be taken in these cases:

+ if the memslot supports shared memory (guest_memfd is used for
  shared memory, or in future both shared and private memory) or
+ if the memslot is only used for private memory and that gfn is
  private.

If the memslot doesn't use guest_memfd, figure out the
max_mapping_level using the host page tables like before.

This patch also refactors and inlines the other call to
__kvm_mmu_max_mapping_level().

In kvm_mmu_hugepage_adjust(), guest_memfd's input is already
provided (if applicable) in fault->max_level. Hence, there is no need
to query guest_memfd.

lpage_info is queried like before, and then if the fault is not from
guest_memfd, adjust fault->req_level based on input from host page
tables.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 87 +++++++++++++++++++++++++---------------
 include/linux/kvm_host.h | 11 +++++
 virt/kvm/guest_memfd.c   | 12 ++++++
 3 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5b7df2905aa9..9e0bc8114859 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3256,12 +3256,11 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return level;
 }
 
-static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+static int kvm_lpage_info_max_mapping_level(struct kvm *kvm,
+					    const struct kvm_memory_slot *slot,
+					    gfn_t gfn, int max_level)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3270,28 +3269,61 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
-	if (is_private)
-		return max_level;
+	return max_level;
+}
+
+static inline u8 kvm_max_level_for_order(int order)
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
+static inline int kvm_gmem_max_mapping_level(const struct kvm_memory_slot *slot,
+					     gfn_t gfn, int max_level)
+{
+	int max_order;
 
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
-	return min(host_level, max_level);
+	max_order = kvm_gmem_mapping_order(slot, gfn);
+	return min(max_level, kvm_max_level_for_order(max_order));
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	bool is_private = kvm_slot_has_gmem(slot) &&
-			  kvm_mem_is_private(kvm, gfn);
+	int max_level;
 
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
+	max_level = kvm_lpage_info_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	if (kvm_slot_has_gmem(slot) &&
+	    (kvm_gmem_memslot_supports_shared(slot) ||
+	     kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		return kvm_gmem_max_mapping_level(slot, gfn, max_level);
+	}
+
+	return min(max_level, host_pfn_mapping_level(kvm, gfn, slot));
 }
 
 static inline bool fault_from_gmem(struct kvm_page_fault *fault)
 {
-	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
+	return fault->is_private ||
+	       (kvm_slot_has_gmem(fault->slot) &&
+		kvm_gmem_memslot_supports_shared(fault->slot));
 }
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -3314,12 +3346,20 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						       fault->gfn, fault->max_level,
-						       fault->is_private);
+	fault->req_level = kvm_lpage_info_max_mapping_level(vcpu->kvm, slot,
+							    fault->gfn, fault->max_level);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
+	if (!fault_from_gmem(fault)) {
+		int host_level;
+
+		host_level = host_pfn_mapping_level(vcpu->kvm, fault->gfn, slot);
+		fault->req_level = min(fault->req_level, host_level);
+		if (fault->req_level == PG_LEVEL_4K)
+			return;
+	}
+
 	/*
 	 * mmu_invalidate_retry() was successful and mmu_lock is held, so
 	 * the pmd can't be split from under us.
@@ -4453,23 +4493,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
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
 static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,
 					    struct kvm_page_fault *fault,
 					    int order)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b1786ef6d8ea..629915b2bb8d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2551,6 +2551,10 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
+static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	return 0;
+}
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2561,6 +2565,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
+int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2570,6 +2575,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
+					 gfn_t gfn)
+{
+	BUG();
+	return 0;
+}
 #endif /* CONFIG_KVM_GMEM */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9ded8d5139ee..0cd12f94958b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -723,6 +723,18 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
+/*
+ * Returns the mapping order for this @gfn in @slot.
+ *
+ * This is equal to max_order that would be returned if kvm_gmem_get_pfn() were
+ * called now.
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
2.49.0.1164.gab81da1b16-goog


