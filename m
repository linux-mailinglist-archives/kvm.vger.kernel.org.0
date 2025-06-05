Return-Path: <kvm+bounces-48543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B66ACF345
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E80E41895C9C
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF162749E4;
	Thu,  5 Jun 2025 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h10jbZzj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3232749C7
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137909; cv=none; b=n9QkNxBcTZk/1ghMl0MZCErXBlwIE+VRPPdSTlIn4EubqWvJfHE0O6rSUvayQi4jhuv0a62CyDry5cqia8a8N0qWeUkt4Ktmd4pHc43hpQ2+ieZgGP/TU6m85prTBlYgl5rZ6fUn672ptm+yB26sHJKaiMGXI3UoQsLAVL6/r9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137909; c=relaxed/simple;
	bh=1Q8cbQvjFXtZKZecW0xkLQCqrCm1hPK+LAqNqvm2qKA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jQdYeSVNnBr6nbQZFfis5Y9W7iBB2QNCS9ztV1AAfOJzunD+HWY77l/5/o7SbJMNzopqmF9njxWtES7knAEdlkooKryUQEPwXoErqAlR6SxrsD1TZb1PwqNuLnIys0+oyA8Shcdp9+HGzAX3r3DCI5rCIlbWgDZbBcLFbNpm+pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h10jbZzj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-450d6768d4dso7161755e9.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137906; x=1749742706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Q3MZaB+gkddolpn5GExyUuoZk0C0aW5OJ088gHNwOM=;
        b=h10jbZzjP2SgUa15kFmatjvmve1OilATDTO0l8d6sPB7gNVMlZiRLwCFuvcrk4byM9
         dCa0jKXfxcHvxSznikfEKyMy5+kdOp8MKPWChIcdtBo4A6dEskmyXJOsk39M4r0YBoy9
         vE5jngmq9VHg2T9Aj3eAISf8OS8oXhMnyFrspvtLj7LL9MgiV1gNMas5EInPQwOYjnPW
         AqR5thcXzhUGtVTaK2IsSv0dlX3v9SiyDWjZbEV6jGYZBGK1h2tnaHeJXBgIK2e54qky
         jKckj7OFZreRRmditk90noFLMt6o3Y71x0wMxovq8uUDlbKrslMf25XeiCZo62jGE61P
         zz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137906; x=1749742706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Q3MZaB+gkddolpn5GExyUuoZk0C0aW5OJ088gHNwOM=;
        b=b8huDJWeoNeRg4jsz9sjlqW36I05AeXc9bU3FxKCdpSIOnZV5M0Z/eedL2/2158Fpc
         918PPkP+o85Nkfqs92zdLSCNdngGYFjQb1ix7ddd1+f15aS1/CP2OmO+aTXGdWqLDXsQ
         4KYuE4D8q48xV4FnscRGw7kolDbMUVjoUq7yI5KoyYWA9BKpgpoIf5N/hq/EC0/YLoK1
         JgawztfMs78fuSzNRpwpDHLsYQhIi2KM0AdYSy1IQT6vltV59CV3rf0yU4qOJv1Uwk+q
         qhxmPQTDYv9KNP/+FBoyYrJ87kTxwEQDRUmhcCFn0VlFBLj1FsMhB194Xsjvo6MvRrq6
         hQaQ==
X-Gm-Message-State: AOJu0YyA3a7xg6ktAQkig1Is9Qhg262EB70fwPYsfk70B4TraEZXGACS
	R5zfZ5VdmtFOGgGr72CTDBgvzW4YFKdmne51LQ3Uc49QIEoUqxF1NmrM50sWXzGUdDt6LaIZ7GC
	qNp+lDHTEaK4gOxpZuWQwgnJWv0v8ytMFiA8/3hp2ME858YlLifwMmwv9USjWhbiRHiv4qJuIFu
	HWy9/9yhHlETmGAbxtK50iQ0fIoAs=
X-Google-Smtp-Source: AGHT+IEA7uYOS1Y9QP3JkFrU8QvHSg/X2tqLhqzqw4p1Ujpz33BJ7l1JlQZBOKqfB5toHtGtrk7dSHdR/w==
X-Received: from wmbgw9.prod.google.com ([2002:a05:600c:8509:b0:451:d768:b11d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2087:b0:3a4:f00b:69b6
 with SMTP id ffacd0b85a97d-3a51d98b212mr6642446f8f.54.1749137905440; Thu, 05
 Jun 2025 08:38:25 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:53 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-12-tabba@google.com>
Subject: [PATCH v11 11/18] KVM: x86: Consult guest_memfd when computing max_mapping_level
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
Co-developed-by: Fuad Tabba <tabba@google.com>
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
index c1c76794b25a..d55d870b354d 100644
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
index e0fa49699e05..b07e38fd91f5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -716,6 +716,18 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
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
2.49.0.1266.g31b7d2e469-goog


