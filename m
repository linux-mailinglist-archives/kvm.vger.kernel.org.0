Return-Path: <kvm+bounces-53694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D918DB1559A
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 746367B1E73
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9888B28642E;
	Tue, 29 Jul 2025 22:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WOc58KV1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F8C2C1592
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829757; cv=none; b=qLF+zEcirM98kBimJ/pjskah8Fj50pqZxGPlr+unJ2IjE+3+h1QaKct1nJFp/3S7fatBerCGpCT3TJAi2ttuXrDOZVt2DZGRysoJjAfQ9RdIEnnPT+xIIS6dxDmzN3A7LIWaEl8Rpq6TrTFGlkmVs5rIE7pEUOI8pd3XOCW16N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829757; c=relaxed/simple;
	bh=O7Igf/k3EvjgQJNCNWnKXWV/DcqSCE5tn8DU+4iX+q0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sDDAQPLiqbC4SqcY86IfXFGlAjY6s76hdNr8ozOE8bQl3Bh50HrzHNOQTVtH9v+sjfg/i+xn3iHstdPR2kuB9KLWiqz58wUyyuuBUW2ZHXqHTakhUevdPncffl4ayrWfX6I8FWHKm0QWvQV2W0ZJuwanyqAWyk+f7nPTcUu45xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WOc58KV1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so6112032a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829756; x=1754434556; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kH3lIGBMPWx+0VjPwRSayAsLHYbwZQBu+Y2sAmKiiP4=;
        b=WOc58KV1jNDhAfSYRUpwMPj5u96WsrBGxDDFn6F+FTD9MRfA/KIRGPMy8UkYKpdew3
         O6WybRnbuFxtIfzvQF2fu28TsT50B6bAILEWHoMbwyHIFHFMElo/QyRaCpFZfeHa9PXN
         rHxX50+t+/SxScPKKtT44IhXaJXXAltoLFIto8xkZ+AnJjZ7BVGqEgQxEwoX+SCxjqxK
         Pw5ANxMjF53cysJ5rHIZeymz36zQfehHW20vfH82CbWhO2k5PnD0ebTDNLwf8d71Lqj7
         MM4gw52sx/qVEc3qMLwBYouicWAXsoR800IjpCMMztDH2f1uyBQjICsZH6pSBChcMh+J
         buzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829756; x=1754434556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kH3lIGBMPWx+0VjPwRSayAsLHYbwZQBu+Y2sAmKiiP4=;
        b=n73JJ5s6Vs9VnTuFa5szrnJBMxI98wS11xqE6JRy7q6JBkujtT6t1RKGI7dga5w8jg
         v6eA/pOZMNOUQlGA6hFoc+L7/UP7iZ/DeWvT8e+GLf7Ugdsk+3vkj/82S2RXnDVu/MLc
         pUfkjk6GoyG5D0YDSI9fkApDU2LF0dPksHfdRUZFsB8dGQ92QoRfJG3rQB0aaOx+REps
         6Vq8IWOCM3ncXOYzpTsUTKdHZe6DdWSFe5dMQ9yuw662huqlVP9sigJHkzDuKhzHWXbM
         7hDVAlnLZf3ua32sA8jvFNUkPKt2Ncsef5h9e8bB7EI1Yv2dc0ckEhaI1o4n3NqcljPD
         r+Fw==
X-Gm-Message-State: AOJu0YxpgpfSkm3n0lpeK2mofRNc4+a5qnh1moJxdGq6JP0juTLWGCNu
	DIOY4V2mqGwml1rH3e6ITMoYD4joRLtE3lvsxvnGkMNsLYOqYVIFkTU2kL0yJvYc0oV/Uqj23ZX
	0d3PBhQ==
X-Google-Smtp-Source: AGHT+IGMilmlssFh4A4OjE5SWFJtANR4cHsVfEy8j5cTH/DcRDgidwnFJoQ2SdFwASXkQExBVaCY8392ed0=
X-Received: from pjxx5.prod.google.com ([2002:a17:90b:58c5:b0:31c:38fb:2958])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2407:b0:31e:ec02:2297
 with SMTP id 98e67ed59e1d1-31f5de2d582mr1162821a91.19.1753829755668; Tue, 29
 Jul 2025 15:55:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:45 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-15-seanjc@google.com>
Subject: [PATCH v17 14/24] KVM: x86/mmu: Enforce guest_memfd's max order when
 recovering hugepages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework kvm_mmu_max_mapping_level() to provide the plumbing to consult
guest_memfd (and relevant vendor code) when recovering hugepages, e.g.
after disabling live migration.  The flaw has existed since guest_memfd was
originally added, but has gone unnoticed due to lack of guest_memfd support
for hugepages or dirty logging.

Don't actually call into guest_memfd at this time, as it's unclear as to
what the API should be.  Ideally, KVM would simply use kvm_gmem_get_pfn(),
but invoking kvm_gmem_get_pfn() would lead to sleeping in atomic context
if guest_memfd needed to allocate memory (mmu_lock is held).  Luckily,
the path isn't actually reachable, so just add a TODO and WARN to ensure
the functionality is added alongisde guest_memfd hugepage support, and
punt the guest_memfd API design question to the future.

Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
of the gfn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 82 +++++++++++++++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 3 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 20dd9f64156e..61eb9f723675 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,31 +3302,54 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+					const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	u8 req_max_level;
+	u8 max_level, coco_level;
+	kvm_pfn_t pfn;
 
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+	/* For faults, use the gmem information that was resolved earlier. */
+	if (fault) {
+		pfn = fault->pfn;
+		max_level = fault->max_level;
+	} else {
+		/* TODO: Call into guest_memfd once hugepages are supported. */
+		WARN_ONCE(1, "Get pfn+order from guest_memfd");
+		pfn = KVM_PFN_ERR_FAULT;
+		max_level = PG_LEVEL_4K;
+	}
 
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
 	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+		return max_level;
 
-	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
+	/*
+	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
+	 * restrictions.  A return of '0' means "no additional restrictions", to
+	 * allow for using an optional "ret0" static call.
+	 */
+	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
+	if (coco_level)
+		max_level = min(max_level, coco_level);
 
 	return max_level;
 }
 
-static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
+	int host_level, max_level;
+	bool is_private;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (fault) {
+		max_level = fault->max_level;
+		is_private = fault->is_private;
+	} else {
+		max_level = PG_LEVEL_NUM;
+		is_private = kvm_mem_is_private(kvm, gfn);
+	}
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3335,25 +3358,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
 	if (is_private)
-		return max_level;
-
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
+		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+	else
+		host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	bool is_private = kvm_slot_has_gmem(slot) &&
-			  kvm_mem_is_private(kvm, gfn);
-
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
-}
-
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -3374,9 +3388,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						       fault->gfn, fault->max_level,
-						       fault->is_private);
+	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
+						     fault->slot, fault->gfn);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4564,8 +4577,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
 }
@@ -7165,7 +7177,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct &&
-		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
+		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_remote_tlbs_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 65f3c89d7c5d..b776be783a2f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return r;
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 			      const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..740cb06accdb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
 		if (iter.gfn < start || iter.gfn >= end)
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
 		if (max_mapping_level < iter.level)
 			continue;
 
-- 
2.50.1.552.g942d659e1b-goog


