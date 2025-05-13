Return-Path: <kvm+bounces-46357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C198EAB59FD
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03D373A8D6E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF72D2BF965;
	Tue, 13 May 2025 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LN3joSe3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FE12BF3E4
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154090; cv=none; b=WVLN7GHnzhTp4ofwYIjzqCKZWZhB+KQ9N+fxRISNcUPJMVBT6xotwBQvqsLI7Sm7BDqu+EC2c2tBVo9m7DbmjbZNxeo65b25/Yrt9p5CHBPBOBxJ+BZ60kVDomJ5NZgzB9esds/YQKO/aOVKRiPeR9nz1pB77akmhD+Jx60xOo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154090; c=relaxed/simple;
	bh=UHECWeNEThOikBN1LwL9MeUwPPM1e1QvYZaQ2/2CjLw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=szVawPM+SwhRbLRna+ZXpgWMCN4I2AZypmV91cuHn35jBVZKqK+uJzXiczMNiUXB97UyUSRLDxHMwjqxsKurHMFphvvxyRINRE0H9mLRpazrZpm5HGdGtg9TPsbB9pwztBARpo/FEEw5YdHdj8li/Ww9TwFJ2y5T0OG5k/QOSB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LN3joSe3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so26853465e9.3
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154087; x=1747758887; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pOo7NLt8OkegplqfcXi8muyEPIUYBCHaIAUmjBpBydc=;
        b=LN3joSe3idl+3il90jAK7/P8Zr+yZuBb2am5Sx6krK0s85wOmkR1r/+KhXhTFSUukZ
         c5lfmebqN9eXPSAvuST+dI2w2VLvCVl+I3CQvkBdXnltb+6cVI1+gAplYGETsxfBQiev
         LL27TWjIRbhahvMKFufmZm76RXTEXYZYlkr416alKiSZKKFZrfvuaUCFo7M5OAL38w4K
         AL6qiOLtvrmjr+V1JE+v46000fKc2DflwiyTxLs5apeOZiHOD9GrmW3GGDMGpmY8qQru
         SKmBYmfkPReuXTuORsHlTRESi1PnHAIjcVK0hwgkcb+9Oek4RU0UBzm9n79egbUrfkm5
         V7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154087; x=1747758887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pOo7NLt8OkegplqfcXi8muyEPIUYBCHaIAUmjBpBydc=;
        b=QFiB8/Nf+nAJXRzrLz3y3nA5qe8Qxlx4XFtleXYPDHxrtPGXQjl5/gVbcKvTgbMbLQ
         bOhXvfqnsMn2DAVS4u1CWWSJ8YljcizmsRohjVLVxISWVLsv7aB+7UZiwZGH3N007k+l
         oZsnDBe7YZc4hs1spkKXANfN5/zohwMhY8B5CHRPH2dqRyfpNvnk86nR0UPBcvzY9bhS
         5Slryrt4FRdK8GXQA+ecMNQzsOoOPlYdZLprhMYBzx1QdTffPgw1DTec0piVG7XV9kgf
         bxigO4ORi/EodiVA1t2W7m0yDU83+p2LkPQLIDnkuUxF9xeNbC1kgmfm/PFCTHKth4+D
         a1rA==
X-Gm-Message-State: AOJu0YzCW4aOYIdF2Mgk/Xd96TXTmBlxP7pa0Vb16yjdnbmF6bsh8MYm
	MT8dANMQKssoeRfS7iNbGEOlskVAF7msvHxtFfzsYiHVYlEPUUAtUaSJLv4ILve19Xnd7F+6ekq
	xkzgTLz7YKgqQP1kfTLKG3VLKcZfVwZHEalVH2rs1EPgrFh6MfEJJYv4LqspsDCtOY9N3qHus1w
	Wo+CI3Z2VXODk7Td5MRLIE2hw=
X-Google-Smtp-Source: AGHT+IE20aWTU+SpWpLldk/SfXaJ1mqHRG53T0tf3UqiygvBHSE+grusEkGSY5r+UM8qg1JZfkwl9ZFAMQ==
X-Received: from wmbdr14.prod.google.com ([2002:a05:600c:608e:b0:43c:ef1f:48d3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e87:b0:43d:7413:cb3e
 with SMTP id 5b1f17b1804b1-442f20bae12mr120965e9.1.1747154087002; Tue, 13 May
 2025 09:34:47 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:24 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-4-tabba@google.com>
Subject: [PATCH v9 03/17] KVM: Rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
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

The function kvm_arch_has_private_mem() is used to indicate whether
guest_memfd is supported by the architecture, which until now implies
that its private. To decouple guest_memfd support from whether the
memory is private, rename this function to kvm_arch_supports_gmem().

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++----
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 include/linux/kvm_host.h        | 6 +++---
 virt/kvm/kvm_main.c             | 6 +++---
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 52f6f6d08558..4a83fbae7056 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2254,9 +2254,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 
 #ifdef CONFIG_KVM_GMEM
-#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
 #else
-#define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_supports_gmem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
@@ -2309,8 +2309,8 @@ enum {
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
 # define KVM_MAX_NR_ADDRESS_SPACES	2
-/* SMM is currently unsupported for guests with private memory. */
-# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
+/* SMM is currently unsupported for guests with guest_memfd (esp private) memory. */
+# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? 1 : 2)
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
 #else
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d1b632e33d2..b66f1bf24e06 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4917,7 +4917,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	if (kvm_arch_has_private_mem(vcpu->kvm) &&
+	if (kvm_arch_supports_gmem(vcpu->kvm) &&
 	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
 		error_code |= PFERR_PRIVATE_ACCESS;
 
@@ -7705,7 +7705,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
 	 * a hugepage can be used for affected ranges.
 	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
 		return false;
 
 	if (WARN_ON_ONCE(range->end <= range->start))
@@ -7784,7 +7784,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	 * a range that has PRIVATE GFNs, and conversely converting a range to
 	 * SHARED may now allow hugepages.
 	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
 		return false;
 
 	/*
@@ -7840,7 +7840,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 {
 	int level;
 
-	if (!kvm_arch_has_private_mem(kvm))
+	if (!kvm_arch_supports_gmem(kvm))
 		return;
 
 	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ca23837fa52..6ca7279520cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -719,11 +719,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 #endif
 
 /*
- * Arch code must define kvm_arch_has_private_mem if support for private memory
+ * Arch code must define kvm_arch_supports_gmem if support for guest_memfd
  * is enabled.
  */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
-static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+#if !defined(kvm_arch_supports_gmem) && !IS_ENABLED(CONFIG_KVM_GMEM)
+static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
 {
 	return false;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4996cac41a8f..2468d50a9ed4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1531,7 +1531,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (kvm_arch_supports_gmem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -2362,7 +2362,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
-	if (!kvm || kvm_arch_has_private_mem(kvm))
+	if (!kvm || kvm_arch_supports_gmem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 
 	return 0;
@@ -4844,7 +4844,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
-		return !kvm || kvm_arch_has_private_mem(kvm);
+		return !kvm || kvm_arch_supports_gmem(kvm);
 #endif
 	default:
 		break;
-- 
2.49.0.1045.g170613ef41-goog


