Return-Path: <kvm+bounces-44942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E8CAA523C
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:57:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B678F1C054B4
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74911190676;
	Wed, 30 Apr 2025 16:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wL30anfD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22382580D5
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032223; cv=none; b=lZaSzjp3ERLzwYhlloZTBY84sgkDN/nxVDBz+R2UrEtqHnkzgknwgU6iDROdfVDQyk1EG0DEgOYgZyhJo0IkcBV1AKJMg+O5iZcINf30k0v0/PlrFBWMCXh9oAmYI8oGFocMsxcrBUcG/Ehv8PCMRaRHdkNXrpHYqIZsji+Hypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032223; c=relaxed/simple;
	bh=h0KHgLItt9CHDAIDrvShHUQC1OFn5R7uYj9ts4iZ2wo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kRywDV2ZdBQ1w+ujdM1qBfi/A20nitGGoReo4gMP1JBE93Ypu8b4biO9JOB5QnW3CiAHMva4j+AVhQl6D1CcInHGj9239mO+zkxqFfxTrtsBtYWvWgm6ugmF772b/w6Z6xgLcgLEKaSJ1D9OY/636WLumgWxZsQHKvgqRjGka94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wL30anfD; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ce8f82e66so60265e9.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032219; x=1746637019; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yin9qGD9i6bYJZBuPpRaU3TWAZSEhluGZrBoQBBflwo=;
        b=wL30anfDfLs7vrlQ187U3vv8eoRBmZl/MT9n2C8ZY8ZcoxgCXT6DvM2YrAWHm+sNEw
         +Os0wifE6LpF5XB8cj1UgKEMCSc8UhANm+COTxU4tL4mo1DPYGf5LkgxTSHm1yOohmrI
         eWjNf+VRPiva6ql10QGznw7NVz7VLEk87DeRrfax0/ChK2ix8miZloxi9l1shHxlXqZB
         ItKhSNIBfSKj6NIKkiYfv8s3hUzdOEzCuRg9VnWXe9w9EOLBNtkjJF+FOq1Tk33ACkV4
         Xg1ibKyvRvVKZBSq2aM8b+dxcWem+h6tNbWWiYj3Rc+EGLzhOamwp7FMya1cwDNPvJ3q
         2pTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032219; x=1746637019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yin9qGD9i6bYJZBuPpRaU3TWAZSEhluGZrBoQBBflwo=;
        b=jga+qrhLkBpUNkcCGvM6C4krRG21XfsDinNnqx+clcuR0me3fybjYgk/2iDyxDwcdy
         RGuJh22uiRafifeKgVcirmnvCWYFMq9FGUk1t8vMxA3TC+wDkq7dfBPn5y+T76ceshIr
         dDCO+TL3S1FWVFMSkNoEBhwPOsRCTx7hD9g3vEZ68/T0RoJ/a47NXCAn6SqEXDA1Vpwg
         KK927FA+60Sg0Nz8anjjc0MUVf9GmVaPxPEa+DvIhDzYkKwNZa69jTZlmBwu2IxbKVlf
         3MBAJbH1VzPvguNXimkfYKFXWl4YonhJLtrnzyYv/Cv0JuXVihHm3i0i9lO6Vo1R1qcy
         jNxQ==
X-Gm-Message-State: AOJu0YxCKlSM+vJTJfyruE3Kx6AC1w4g5aMmobUe6qTSphPm8T/ns7ti
	h10bQJL6ut4s2aPaRInD1qa8faeL1/XMW2M2TOzzCV/BILLzk0qIXO9ara5uKfKqqw+a46RCB/5
	TyY1+hoV+z2WvCpguK+SAfGYoJxXGaqnKFNRHbIgnvcwxRJpFySX9sd+DnGKWJlLAk0lHjVVr35
	KJmN4fyADMfvdUCu0t6sCD4Ls=
X-Google-Smtp-Source: AGHT+IHNTXwBimJm7w0AvwxO9LHDuRmUVyq5N7prGpQ33JGOil9AldAs09e2ILpTnulXgaJQe+NnqGUKlQ==
X-Received: from wmbfp26.prod.google.com ([2002:a05:600c:699a:b0:43d:1c63:a630])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d91:b0:43c:f44c:72b7
 with SMTP id 5b1f17b1804b1-441b1f35e37mr42132445e9.14.1746032219027; Wed, 30
 Apr 2025 09:56:59 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:43 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-2-tabba@google.com>
Subject: [PATCH v8 01/13] KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The option KVM_PRIVATE_MEM enables guest_memfd in general. Subsequent
patches add shared memory support to guest_memfd. Therefore, rename it
to KVM_GMEM to make its purpose clearer.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h        | 10 +++++-----
 virt/kvm/Kconfig                |  8 ++++----
 virt/kvm/Makefile.kvm           |  2 +-
 virt/kvm/kvm_main.c             |  4 ++--
 virt/kvm/kvm_mm.h               |  4 ++--
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7bc174a1f1cb..52f6f6d08558 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2253,7 +2253,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GMEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #else
 #define kvm_arch_has_private_mem(kvm) false
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 291d49b9bf05..d6900995725d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -601,7 +601,7 @@ struct kvm_memory_slot {
 	short id;
 	u16 as_id;
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GMEM
 	struct {
 		/*
 		 * Writes protected by kvm->slots_lock.  Acquiring a
@@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
  * Arch code must define kvm_arch_has_private_mem if support for private memory
  * is enabled.
  */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
+#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
@@ -2504,7 +2504,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
+	return IS_ENABLED(CONFIG_KVM_GMEM) &&
 	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
@@ -2514,7 +2514,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GMEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
@@ -2527,7 +2527,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
-#endif /* CONFIG_KVM_PRIVATE_MEM */
+#endif /* CONFIG_KVM_GMEM */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 727b542074e7..49df4e32bff7 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -112,19 +112,19 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
-config KVM_PRIVATE_MEM
+config KVM_GMEM
        select XARRAY_MULTI
        bool
 
 config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
-       select KVM_PRIVATE_MEM
+       select KVM_GMEM
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
        bool
-       depends on KVM_PRIVATE_MEM
+       depends on KVM_GMEM
 
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
-       depends on KVM_PRIVATE_MEM
+       depends on KVM_GMEM
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 724c89af78af..8d00918d4c8b 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -12,4 +12,4 @@ kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
-kvm-$(CONFIG_KVM_PRIVATE_MEM) += $(KVM)/guest_memfd.o
+kvm-$(CONFIG_KVM_GMEM) += $(KVM)/guest_memfd.o
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a92624..4996cac41a8f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4842,7 +4842,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		return kvm_supported_mem_attributes(kvm);
 #endif
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
 #endif
@@ -5276,7 +5276,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_GET_STATS_FD:
 		r = kvm_vm_ioctl_get_stats_fd(kvm);
 		break;
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GMEM
 	case KVM_CREATE_GUEST_MEMFD: {
 		struct kvm_create_guest_memfd guest_memfd;
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index acef3f5c582a..ec311c0d6718 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -67,7 +67,7 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 }
 #endif /* HAVE_KVM_PFNCACHE */
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GMEM
 void kvm_gmem_init(struct module *module);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -91,6 +91,6 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
 	WARN_ON_ONCE(1);
 }
-#endif /* CONFIG_KVM_PRIVATE_MEM */
+#endif /* CONFIG_KVM_GMEM */
 
 #endif /* __KVM_MM_H__ */
-- 
2.49.0.901.g37484f566f-goog


