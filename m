Return-Path: <kvm+bounces-46363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F153AB5A18
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 294C24A75EC
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50CA1F12F4;
	Tue, 13 May 2025 16:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qAK7Ps4T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3302BFC94
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154103; cv=none; b=k0YbqTx53UhfmQ5o316AqW5qjR6/qwIo3fDJ+Oz4VW6XK4VYXDNEE60NRS73n0RoUfa99lz1R7ESNMVnAat81+YRyAb1gFrilv828RkzwX/C5c1yw6Ats8c+S9MqSQgNGJ/WcN1odiogOppMQjiAo8BoVoMjTE0T7Enm3rxf2JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154103; c=relaxed/simple;
	bh=IgbJONri0NGoKyhF1kxMIJhf5KSMuWMgmCl50Qvefxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YqcdZkyrAS6l8IVQP6rynru7vbvxw76cm4mhuECjujqnM3kTcUS2A+63v5nuihpeQYrq0VRlDeavT5M2eb7MLHHe4iTjR6aCJfJB1mJ//3mN+I+tmbymTy+c/0ZebRnFtnQnCtc9iIhWQknSqdUM8vS9m4lb/k3H+o1eZPjrxSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qAK7Ps4T; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43efa869b19so39945595e9.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154099; x=1747758899; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NxKl/6+BAKCXIdE2T+YrAbctmttt0hBq+hOPemAaBUg=;
        b=qAK7Ps4TM/YzzNRhuSRSZM8xh0hx27Od81RDbHuZRPKpG2EvVWBa48J3bhQIQxxOZ7
         t0PhQx/90iLkQqbb8dNg+A3S7izOhNygxDg4oxgg7f1JmwmenhU7ynD9p3ICKL36S/o7
         4zIAW42yYCOKOLM2pjCfOG2ZzBpkWpr1B2GRFiTrXW8jq+zrfvk5IqLSZA/ZvDCGevLD
         sr7KigABdzdbqGEPdHYtCG/vZ5vRcFaUIXsZv7UWifusQ/BWwlUq8ww02z8jww28O+0s
         iRGh5XqkUnlTPZxswxSQXH80L6viZ8pu/8p5mxFAtsxfOtqiX9vcqeCNSEnA/Rsp3Key
         8LuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154099; x=1747758899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NxKl/6+BAKCXIdE2T+YrAbctmttt0hBq+hOPemAaBUg=;
        b=gXe+yvYFiY7/U7jK741njQI6n5bPnLIjrFOCgT8RCN+RsdWS4zDWWaonvWogqhM2BK
         SsNtooAyLc7Vs3qoC70RyCw9TJDl6RTyVrndE3HX/6wR4R2IB88httGhBsry2p2/mDXF
         m34VwaVHTDbaHJ5AvCWzJ2w7StbnNED9C+dCXPflho/aqW2PgHQicUeicZd5/dwYiaFB
         40GT6iJg+NQbARk5lpiFpf2cMNDzkQjKXnMO9MD5zGs7pe8hJMwJNFJ3JvexugBGU2Cd
         D6n1ujKbwTktHFnwTFz7LhnyJvM8RclpphbZvXU0DhUZ2bbG6UV7HIqCuge4OCsx7TKf
         Am0g==
X-Gm-Message-State: AOJu0Ywoit0XJCCmbzVidaziaEO2aT1H+jjkN40Tv/E4BLqbIQl/qBpp
	lOvPHhaeDOSbByg3mpRjjXFV6XYKmp0ZPh2NiKoL2lbDeSsiUIHFAaRwGNNNPx4TEzOYheHl7Js
	2cGE9qSyZvL4IQRd5JohpIoZBrR6a7lWhJmIuiH2HHz3/PXV+UcFm9KP247ERUwhXonG0cukt7k
	FkE/utF0q7dxM6Ww234xITkdA=
X-Google-Smtp-Source: AGHT+IG3vTrR9dlx8h1Y7WqXSbJ03o3LWkHYex4QcV7npEMOKy25lzrViPjnVXRCx5B9hTFNZlwSiNnOEw==
X-Received: from wmsd3.prod.google.com ([2002:a05:600c:3ac3:b0:442:dc9b:b569])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8284:b0:43c:fa52:7d2d
 with SMTP id 5b1f17b1804b1-442d6dd2478mr132398425e9.20.1747154099254; Tue, 13
 May 2025 09:34:59 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:30 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-10-tabba@google.com>
Subject: [PATCH v9 09/17] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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

For memslots backed by guest_memfd with shared mem support, the KVM MMU
always faults-in pages from guest_memfd, and not from the userspace_addr.
Towards this end, this patch also introduces a new guest_memfd flag,
GUEST_MEMFD_FLAG_SUPPORT_SHARED, which indicates that the guest_memfd
instance supports in-place shared memory.

This flag is only supported if the VM creating the guest_memfd instance
belongs to certain types determined by architecture. Only non-CoCo VMs
are permitted to use guest_memfd with shared mem, for now.

Function names have also been updated for accuracy -
kvm_mem_is_private() returns true only when the current private/shared
state (in the CoCo sense) of the memory is private, and returns false if
the current state is shared explicitly or impicitly, e.g., belongs to a
non-CoCo VM.

kvm_mmu_faultin_pfn_gmem() is updated to indicate that it can be used
to fault in not just private memory, but more generally, from
guest_memfd.

Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 33 ++++++++++++++++++---------------
 include/linux/kvm_host.h | 33 +++++++++++++++++++++++++++++++--
 virt/kvm/guest_memfd.c   | 17 +++++++++++++++++
 3 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2b6376986f96..cfbb471f7c70 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4465,21 +4465,25 @@ static inline u8 kvm_max_level_for_order(int order)
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
@@ -4491,10 +4495,10 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
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
@@ -4502,15 +4506,14 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
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
@@ -4520,8 +4523,8 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private)
-		return kvm_mmu_faultin_pfn_private(vcpu, fault);
+	if (fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot))
+		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2ec89c214978..de7b46ee1762 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2502,6 +2502,15 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot);
+#else
+static inline bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot)
+{
+	return false;
+}
+#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
@@ -2515,10 +2524,30 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 
+/*
+ * Returns true if the given gfn's private/shared status (in the CoCo sense) is
+ * private.
+ *
+ * A return value of false indicates that the gfn is explicitly or implicity
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
+		 * For now, memslots only support in-place shared memory if the
+		 * host is allowed to mmap memory (i.e., non-Coco VMs).
+		 */
+		return false;
+	}
+
+	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2f499021df66..fe0245335c96 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -388,6 +388,23 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 
 	return 0;
 }
+
+bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot)
+{
+	struct file *file;
+	bool ret;
+
+	file = kvm_gmem_get_file((struct kvm_memory_slot *)slot);
+	if (!file)
+		return false;
+
+	ret = kvm_gmem_supports_shared(file_inode(file));
+
+	fput(file);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_memslot_supports_shared);
+
 #else
 #define kvm_gmem_mmap NULL
 #endif /* CONFIG_KVM_GMEM_SHARED_MEM */
-- 
2.49.0.1045.g170613ef41-goog


