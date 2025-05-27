Return-Path: <kvm+bounces-47806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E32AC59BB
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B01F71BA740A
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4C028032E;
	Tue, 27 May 2025 18:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l3yEnizS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5901D255E26
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368972; cv=none; b=DYogEXxzUMydr70UW+vfr+LsdtJ63hc0fHTIqDu5eRKgnYJh44dEJ51r2noiStTP6823p04he3P879RJGNdXuTV3+yxai5pqQpNmJz6KaBRkykpSPwYm2fC73NOwgNQdxufyAvRZ7FSoEMLTRxznNtBRl0M0+nZ/1AYSsBwF2j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368972; c=relaxed/simple;
	bh=eVG5qd1xMmR4dBz8mcKuiATiQC9HbxMpsCCJ5ZDN96U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OgmZFmc6jpGCbwQB76f/K6KWVA79u02/UyKDzSdd0A6KgvjpbQBjyOupiFz0rBOzopu3hwgjDflHRiB9vt/DUAa/Oljz6boUH/ZjxAeMpH0/UXXVzpGL6tmd6V3KWYah3UhxVPGuE2nWLGcYYlDEaV7kKtL+82cyLxgHXDSkuuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l3yEnizS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-44059976a1fso18026955e9.1
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368969; x=1748973769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MAPYMFcA04iMajFfhYRVqya4vkT5AgmHoZCtCa4VM9o=;
        b=l3yEnizS7TYBruhznrChzBFKZEs49h1gu6oxHweQf71w39a2GWeyIgN3zlwLU2lWSf
         f6qYDnXQDfkLbIbvAVMmlrGUEuYCm2EJvmmvrBdE0fLeze/3cvHqeMi2yyJ+dReoAoQr
         GbUxVi9m/02ZI3KR5zDrP7AJqfwmiRfzh6EboPzAgLbmHzBnqayHKMey/8eSDrX6fpcC
         LrOxGbx39ZypYccYkGVT9fDF7e48d1goI9BrxoxSY/82QTpPfmYvZ4INIX2QPiWZHjUu
         4ETRJMFc/n3f7i8qToId5eCRUPq+6UKSE3n8QKbHADMlWCJjb16x8aUK6qozXeNLO9hS
         7H8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368969; x=1748973769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAPYMFcA04iMajFfhYRVqya4vkT5AgmHoZCtCa4VM9o=;
        b=NXzCd98Do/dA4VIiMmzzEUbtucTNi99rsjgjHS6J4KwTpktK9onohbbgk+hhoWeWHp
         5CmHHA+Ozy+tVeEJcjrZfXpZc77yFinKZfMPfr3WK2BWq6fXyM6b/O4THdPWiOPJAihi
         q1qK9gRARAw2yf+mU922BE/MVCBzTDeHPZlCI/7D8JYTsKdxu9dLciGRI3AX3Jk/VjLw
         TegcmoNylwN+VO6ox7SLI9fyT37BjN1Jz8iAGxej4gpmVT1znZNPQBtDzj2jVrvNGl9C
         k2UiDmQrEbnZdeRZlGRmkhqkJIqnoRk4qt0Ixc56CMY+m3RFOic/CwIZm7tk2hzdYUp5
         4e1A==
X-Gm-Message-State: AOJu0Yz2V4kno6gAt4ZL9HOQzKMAe1TIL9uO22Z/pjVK7HRgYzGOUI6n
	Z5sHlcmSshn1m0fgHtyYnIuOF/ILmCvezwipo/rS/uGUiK/rbEqcCtuBYSskSh7Cp4ldE4yN2ts
	eS4IeNhEJaHFTrBBvIXSzNK8GKX7DsRzBiiyaHDx02UJQGhfvd+joDhNXhFRrkI3vGrdUqyO5L8
	dL8MseX0KYnGQP0TbS3dpx8QK91bA=
X-Google-Smtp-Source: AGHT+IFWX1lJsP7uFK8w6KMkSZC/1XfIm/q0jgF4g35Q5VfG/kHzWvBsrg3xCXhhetjQEsU/iN/qBHkEHw==
X-Received: from wmqc14.prod.google.com ([2002:a05:600c:a4e:b0:440:60ac:3f40])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:26d1:b0:43b:cb12:ba6d
 with SMTP id 5b1f17b1804b1-44c9465aff1mr106223585e9.3.1748368968678; Tue, 27
 May 2025 11:02:48 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:30 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-2-tabba@google.com>
Subject: [PATCH v10 01/16] KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
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

The option KVM_PRIVATE_MEM enables guest_memfd in general. Subsequent
patches add shared memory support to guest_memfd. Therefore, rename it
to KVM_GMEM to make its purpose clearer.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
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
2.49.0.1164.gab81da1b16-goog


