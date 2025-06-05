Return-Path: <kvm+bounces-48542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8B3ACF343
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69C34189C2E9
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAFD32749CE;
	Thu,  5 Jun 2025 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Li83ThBL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D10274652
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137907; cv=none; b=oxGnqjp7GGEn5xLCxlHhRCL/ZYWl53pJ9e4AcB6WGgg5o0AdUotclgWhThHtTQN+ztZIWoIHhD3bUuJ6nP8yF2ScvfDcdNZ9lN8tpMxZImnUUmGlhDLczxkGTXrxghGaFnxZ36ounyodbDmgO4r6cSUvAfwkwutQaJEHaTmL+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137907; c=relaxed/simple;
	bh=aEGIxDz90Zon9QCUIY4z+F3iah7Pnq1sMPdwiCjlQLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YnIdNlpFrO7JpRaFyq8JlH0avUZOxfZT7RCOR4f5YTalX4tRJtXydpRhK3PunP18QByK4jrquYDoDVB9QQsjRONKZTfGrzWzBTNRpdDo6uamHRGujk52iWAhpUn3S1VlseD9C1qEIvRVLIJ82fti7QdWO6rAiRYeZQ8KD/E7sqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Li83ThBL; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso474602f8f.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137903; x=1749742703; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k5mT80MZDXcAwlQCNoaIhoW3gcZnOr/cDM6o1B6bi7Y=;
        b=Li83ThBLC8QaIP1XS9l4u7YQNhstrUQYtRQiN9VLCn9ZCWLuqBM+KV5FYP2QsMeXm9
         S6ksbtwQfgOBKhzFiIW5LptGYUL/rNIEtdyVSmdbHwzgq9hYw/Dykwfex3BPh2q6ufd2
         ZwkPVOf8vQRwHuFjScYb5TqpaVgpHwjx2Ug6XXe+v/ZXXxj84QIIk6X614L12y6I/W/N
         sOLX1YzVIuBTJyGeqDLZf6l5EC1vydcBv9j1ijTy46PTLnDj8ZDEDavyf27UxFGVibQH
         ANyQFon0xK8JvFrual1RooDod7ailci/BPwYiCuP71hX65cw1p0SXOk54vwjbIVkvnRm
         bRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137903; x=1749742703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k5mT80MZDXcAwlQCNoaIhoW3gcZnOr/cDM6o1B6bi7Y=;
        b=LBPEVenoZXwBdJa5FYXjY9QC93UBDznFYbBMtN/PZj2Xz2HWLaFBSVvBiPGG0LGs+a
         JmIgDk2pRQVhHqpopqZxazLQ+9mVdWrrXY1FTvwNyGmsEpSzIq+yTSoySZb/jTpdMBBe
         /cVv54DCqko/rc4xP+g4cGCNDGkICBmFf5jV+kc7tMJzdpJDDXzBQWhICb5n2rpw4PYY
         GlEGfRe9mqLBlhNtFDSuV2URICpZtU0TFRGmhqiOpuqBVjnNBx69/ClSu+OnPpkcFny2
         jhi7EyK7ZL89dPZEhJS0etD21gYERlE/3xpFLIM2eCedBGqkLyJWO+73r4y8Xs/IZ3WP
         tDyw==
X-Gm-Message-State: AOJu0Yyo9xHP1x5rXexqm9oZz6bFGvn0JoKmx5IGI/5ll+Hw+yQWLDcT
	dY8XasJhV9sBzxHojWLsAmR9XHroy62IDfu9X6QgA5R54bwbaao0genFOuHS0bUSFLI/PVhBl8Z
	wV46bjHyfvUweA8qyAz2A74mAyvAU3sF1vI14hmzbrqCe75aW53wPEonfNznzCBRq5gGIMDxq5Q
	cusknYR5SG8ZOWOj3w14MEL7mjcFg=
X-Google-Smtp-Source: AGHT+IGc1LkSHwQNrznKJ1b33wj++AUM7x7/8ughlVaHpxKIkTfS1rPIxYD8sjJvOn6Gs4MKeRuaa/i+eQ==
X-Received: from wmbem24.prod.google.com ([2002:a05:600c:8218:b0:450:41ed:d20e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2907:b0:3a5:2653:7322
 with SMTP id ffacd0b85a97d-3a5265374aemr4365482f8f.3.1749137903336; Thu, 05
 Jun 2025 08:38:23 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:52 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-11-tabba@google.com>
Subject: [PATCH v11 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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

For memslots backed by guest_memfd with shared mem support, the KVM MMU
must always fault in pages from guest_memfd, and not from the host
userspace_addr. Update the fault handler to do so.

This patch also refactors related function names for accuracy:

kvm_mem_is_private() returns true only when the current private/shared
state (in the CoCo sense) of the memory is private, and returns false if
the current state is shared explicitly or impicitly, e.g., belongs to a
non-CoCo VM.

kvm_mmu_faultin_pfn_gmem() is updated to indicate that it can be used to
fault in not just private memory, but more generally, from guest_memfd.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 38 +++++++++++++++++++++++---------------
 include/linux/kvm_host.h | 25 +++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2b6376986f96..5b7df2905aa9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3289,6 +3289,11 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
 }
 
+static inline bool fault_from_gmem(struct kvm_page_fault *fault)
+{
+	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
+}
+
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -4465,21 +4470,25 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,
+					    struct kvm_page_fault *fault,
+					    int order)
 {
-	u8 req_max_level;
+	u8 max_level = fault->max_level;
 
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	max_level = min(kvm_max_level_for_order(order), max_level);
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
+	if (fault->is_private) {
+		u8 level = kvm_x86_call(private_max_mapping_level)(kvm, fault->pfn);
+
+		if (level)
+			max_level = min(max_level, level);
+	}
 
 	return max_level;
 }
@@ -4491,10 +4500,10 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				 r == RET_PF_RETRY, fault->map_writable);
 }
 
-static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-				       struct kvm_page_fault *fault)
+static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
-	int max_order, r;
+	int gmem_order, r;
 
 	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
@@ -4502,15 +4511,14 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &fault->refcounted_page, &max_order);
+			     &fault->refcounted_page, &gmem_order);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_level_for_fault_and_order(vcpu->kvm, fault, gmem_order);
 
 	return RET_PF_CONTINUE;
 }
@@ -4520,8 +4528,8 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private)
-		return kvm_mmu_faultin_pfn_private(vcpu, fault);
+	if (fault_from_gmem(fault))
+		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6326d1ad8225..c1c76794b25a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2524,10 +2524,31 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 
+/*
+ * Returns true if the given gfn's private/shared status (in the CoCo sense) is
+ * private.
+ *
+ * A return value of false indicates that the gfn is explicitly or implicitly
+ * shared (i.e., non-CoCo VMs).
+ */
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return IS_ENABLED(CONFIG_KVM_GMEM) &&
-	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	struct kvm_memory_slot *slot;
+
+	if (!IS_ENABLED(CONFIG_KVM_GMEM))
+		return false;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
+		/*
+		 * Without in-place conversion support, if a guest_memfd memslot
+		 * supports shared memory, then all the slot's memory is
+		 * considered not private, i.e., implicitly shared.
+		 */
+		return false;
+	}
+
+	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
-- 
2.49.0.1266.g31b7d2e469-goog


