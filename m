Return-Path: <kvm+bounces-52480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C72ABB05690
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13D967AFC75
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545262DAFB9;
	Tue, 15 Jul 2025 09:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aEwIicZa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54CF2D9EFF
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572060; cv=none; b=BatCDjAAsorPEXjy4uM9b7bBgK5mY6zgkLIpYN5vbQx9xri519ex7EwuyIDKuo8y26BEDfeHsD/OHwDJrcjFVbQLuWNUAuR9GdBg/4OzursjEQeMVmg2mWOnJsVH+b9g7Im/35C26jrSgnlhFl27smGRYtE4554E9sKShYTGGlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572060; c=relaxed/simple;
	bh=xurDWAtZkL6bObNk6B6ReVIsKjxDthfj6nKjWzzTH4k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jznutnTg7m8Tm8BZkixks1iZ/lOQgL0dTKm7FzJI6v4dHx0Z6c1uv6xHBT3KNkz+M0skSO6bX9SMTBKWyhwPBUxu+DvoBZg5N5Z736WilTdoht9BO0V6o1zcC0ALdbknSIoZiEziYgg+08wsdESbx365AsTIzy7+Lv1TrzYB7zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aEwIicZa; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45359bfe631so31582695e9.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572057; x=1753176857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vj4FcImTJCIyi98y1V49b83tOyghRW7/aml55WLH8OI=;
        b=aEwIicZaGltpsEod/v1VEhBBI5OcUy9pxQznz2ohhqqzLQ/M27JWhXgzKgACOPjHyz
         EMtFhtKWXWMiiQeG+By6L0C2Cd4vWWGikIw7Wis9+s6mVJMIuzbC41NJLWYP/87xzUkW
         FTd3hrWDr7057QUb7DAsso6JdG4cqWP97zyl9SJ4Rjz6n8GU26bfR1RuQcoLDuvuwPFi
         mZ4eYnfYPhfrnZaY+MCVDH8AObId3PJBWchYpboSBgmm7uloNTTPkgCJXhBzKbqcR2G1
         WQSxwkgEbglm6qFEyBkOW2g8V4SJvlNyyf1P+FkO/Z6YsZefx/4vqSeZjkEJZRO2/tSM
         4mQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572057; x=1753176857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vj4FcImTJCIyi98y1V49b83tOyghRW7/aml55WLH8OI=;
        b=lgmD75XcQF+HhKzXIije74qw1qkPMxE/uoUy6+Xf58JP16+nVsrKo6aAwYSYSNgMBT
         BD2n7/7bprR8LMHBSUF/+SIceIb2MWxsITb+yWMuIWeM4oK4z9uwnev7KdbJqD53qIrM
         g7Ukp7kCs8dJef/1WCdNUamq+ncNikYdEp3fmywbpK8/C9BV9QSkIiMXlTmV6YrBk/Lx
         AalKoWUDqPfiabc2htYNDML+Jm1kh3zD72W5fR2ixcQfcLs7Py5xDGKYEHjS4YywLiIu
         CmZQIuIGiF8mj1IS1w4axUxvO+1xt5epwE45JzlR/vT06hyD/JquFbmgU668d/bS3YFB
         IxRw==
X-Gm-Message-State: AOJu0Yw0ApsS1PLV/+WfiCdyMJRigE8eyc31o+9rheKQyWg4vDZ5j1mU
	nvMIcm084IjfKJ6qfDF0ay46a41A/wgkVw4jKI6ZYKsdw/yMkcLhxHGi9br4wvXuRCAK150nKwo
	Fd2/9ZGl2VaiKZTn7B9rtciCmoP9nmDnUKrgpy88CBrsbwmh3QESswgOhljzQRpbHCo6Q9MtCX3
	Ap5zLCPZ+lRtlG39jHm3I7jnp4SR0=
X-Google-Smtp-Source: AGHT+IEyJ5h1JxYJfdwQzraAUkDVc/0m81Qa8ZAoEWQG0pPu2KC2KwcMTfd23Q8xPe+xGRzWwhfb6SO2ZA==
X-Received: from wmbgz9-n1.prod.google.com ([2002:a05:600c:8889:10b0:456:1ceb:e66])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d8b:b0:455:ed48:144f
 with SMTP id 5b1f17b1804b1-455ed4815f8mr164308385e9.14.1752572057086; Tue, 15
 Jul 2025 02:34:17 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:41 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-13-tabba@google.com>
Subject: [PATCH v14 12/21] KVM: x86/mmu: Consult guest_memfd when computing max_mapping_level
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


