Return-Path: <kvm+bounces-46364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 974AFAB5A14
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A1CC3A73FE
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F62C2C0312;
	Tue, 13 May 2025 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U5/ZHG11"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC27A2BFC7F
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154104; cv=none; b=K3ktNNl6q+rXL7vARFHP5iuvDGBkCM9oUJ4bWYQxX1mLF7jHVQvothVnSAM2yd0e+R69IyzP2MbeKj0V240KuUyXcYAB/I4inm+Br0PTWYcuVLo3rn5PgnGrrqOSasciOgoolTyyitYde9X3pVkwaZaZwZa3uTZOxA+t0fzEX7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154104; c=relaxed/simple;
	bh=Jr9xqsOqotECuvzAu+C7RbwpyeNTMbt9IEgZBUaW6fM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RD/LH7Q8Fz7TwwtJ0kvZb1VO8+tITdxQx5mnj4nwn30oNXr/G3eqPZRge/znE8j2kXveteMUuxjtwTh2IYydCNir+PIzAGbW45/txC9wkDOpj5Ss7RRXanRn+cjLy2+Uxlkp1omvy9KP3PuQ/nOjCttWeucRPzWTG3E/p5M38d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U5/ZHG11; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a0adce033bso2032505f8f.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154101; x=1747758901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j1W1Cy37OzbQ24L0v54CfH7EjVT5UN5Iyr5YInP+w4Y=;
        b=U5/ZHG11kxeq3z/pjK8tDwgUf1RdTFGSx9sI3dY1Fl5CZnKDjoi6cLCdCwAog4rHYT
         a+X7mruR5XtzSKIRpz0lpht/JPDQSQfCrU2sMGshiI4Ml/lRTvWSaCV9X6v5rgoj7KN8
         S0FjK+K5DpdcWqJNqTDwQrXJBE46gV6C72olJJLGu2PnKj+httP4msDMl4Y48nP0BTku
         owoRCwRnQFk4qC97+U06sW5TiFSK0/G5cdSfTFH7Xs0eIbzrZhQyL8kmJpZ87gFf96JL
         HKW0lKWaAg+kn2QnHjeQ0qXyEfBL5IgtG8xzsizLzCfYkbEFz0F4nket7IgiQqlUVgdv
         EJyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154101; x=1747758901;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j1W1Cy37OzbQ24L0v54CfH7EjVT5UN5Iyr5YInP+w4Y=;
        b=f/xEt3m7RyHmI+b/rnP4TfcTTwRajD+bjKJO7um/folDzv4aDMXmBon1di7cs5lsFE
         183s5/X954DPa2knU4MeinUGdId7QIvqZ6GEgJEBeFsHt3gcfPZHNrX0FT/21Z2dNJIB
         5w7uGhckCRtDgKtteJzCu9IUikhMqWCSopvxZEzviAM+2Sm1bqqL10sSimNsJfTQs2aA
         VCCw+tcHm08hOH8flcUiLUiSHLu9rxweafUo1ErWUuCLDKeAnJ0uLfbIFj5yvhFu0FEp
         ZdKUhX0dNo8X4l1s4WvnoEXwPpVGr8TtGVLl6IGFFM2YTKKLH0vAHPTjDR1b2SV4/NSN
         v5gg==
X-Gm-Message-State: AOJu0Yxc59n/sDlloPUblEpsFLLnh9a/KLP4QaIZ9RT4iT3UUZGWardR
	pFOta0f75tfzfTgN/JBiRY67qvU1TqKYmqWFsjtdT6RyNZge2P0LUBXLxLCq0G7m7kkHjTbeRNm
	97GbU6gBXc5RRSNAzBVG7BKHGsSbOX13aFh6NXWnBGJeW01xP+pDk3oN3pTmUM337COmvjXdgKc
	WMAvXKiHJiFSlRb/R51uitQQ8=
X-Google-Smtp-Source: AGHT+IFGjQxHgijGI2OEWj0PdaWz94EVCFblWm1hwEf7UsJPhE5e8u62QQVgajDHnVw5zTqR4B58OPcL3Q==
X-Received: from wrbgv9.prod.google.com ([2002:a05:6000:4609:b0:3a0:b83e:ad41])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64ce:0:b0:3a0:b8b0:441a
 with SMTP id ffacd0b85a97d-3a1f643ba6bmr13308222f8f.25.1747154101187; Tue, 13
 May 2025 09:35:01 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:31 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-11-tabba@google.com>
Subject: [PATCH v9 10/17] KVM: x86: Compute max_mapping_level with input from guest_memfd
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
 arch/x86/kvm/mmu/mmu.c   | 92 ++++++++++++++++++++++++++--------------
 include/linux/kvm_host.h |  7 +++
 virt/kvm/guest_memfd.c   | 12 ++++++
 3 files changed, 79 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cfbb471f7c70..9e0bc8114859 100644
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
@@ -3270,23 +3269,61 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
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
+
+	max_level = kvm_lpage_info_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
 
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
+	if (kvm_slot_has_gmem(slot) &&
+	    (kvm_gmem_memslot_supports_shared(slot) ||
+	     kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		return kvm_gmem_max_mapping_level(slot, gfn, max_level);
+	}
+
+	return min(max_level, host_pfn_mapping_level(kvm, gfn, slot));
+}
+
+static inline bool fault_from_gmem(struct kvm_page_fault *fault)
+{
+	return fault->is_private ||
+	       (kvm_slot_has_gmem(fault->slot) &&
+		kvm_gmem_memslot_supports_shared(fault->slot));
 }
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -3309,12 +3346,20 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
@@ -4448,23 +4493,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
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
@@ -4523,7 +4551,7 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot))
+	if (fault_from_gmem(fault))
 		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index de7b46ee1762..f9bb025327c3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2560,6 +2560,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
+int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2569,6 +2570,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
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
index fe0245335c96..b8e247063b20 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -774,6 +774,18 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
+/**
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
2.49.0.1045.g170613ef41-goog


