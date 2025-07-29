Return-Path: <kvm+bounces-53681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB4BB1557B
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 068C47AC4DA
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4100286884;
	Tue, 29 Jul 2025 22:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wic7dCqw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C6C2820DB
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829733; cv=none; b=tMXzPl2O9UrQXHc+Hdd35dCy5AP/DG1qeS/0mwdEMboZwWIIXhMwSPOw/RttpDtpAC7Ifp71IEAeBxjdKrm9fsMTZkKkyFqDJSQRCcj1i7CRuKGnEq2fu8tJFFv5pkhbJ99yqOiyB4QtVzhBzqSpSS+QL6NUgc0rYw9H3SSN22A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829733; c=relaxed/simple;
	bh=zIljfq2TSzQaWNnOIy0jWv9y8WWWTpAGeN/SwFO0aV4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z6iDIoB4InyKJtyay29xI5UYDpDXIoT8TY2QQyoZSAA2YhEZpzxBKRBq8LrQ0FRZ+21HX2BVhecWNWGW1UA28+NGhN2MjsipvpJhaGRuJCHGIVIwSCUkTMwqIDKHxRTwoOrdVKn2b8KJtOENhhhrvPofTbiAX69Pkit2uzZk1CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wic7dCqw; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23ffd934201so30446255ad.3
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829731; x=1754434531; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rCpQGzwMKFK4ptMSW9GdDXyar1lj92zeXPJ/+yaFJX4=;
        b=wic7dCqwUAj5mCmJt1S3/vZm1KBMJ7sFjIXdQmsopWzszH4hYnL5NtGMK+tAJZ8Fnx
         c0mb4PWJMMtDD/J9HSK+IqIQXUGulZn0MsIkbVUD1k8TvHHvAUMrWt/c06IBRdWKi0ap
         Epl1mnCy2T5aCqvPPb1wjdp207FJFlY3YVTBvQ36ZDj05XSXjxqniyt2sg+PNBfrxvUM
         oBsNrlvtCrpFXt35VD3wryl36G6iJe/xpfMbqYxgeZPmXgVVMH8oE/lHoi2lPkTOameB
         ltRgYXOlK2diaJ/5S2+863ES39oCYQymIsl48L1A6BSlvtsyq+UybQ9mFK8psQr3c0or
         i8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829731; x=1754434531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCpQGzwMKFK4ptMSW9GdDXyar1lj92zeXPJ/+yaFJX4=;
        b=VlDsWDuTTUvjc28JMXqkyoN5wJn9byF0hfFtGCYm+SiHzZA04Pa42WhDqfueQYAbje
         aKWni9BWtX980RRNck2NTisfh2SuHITqnY/sDV2FyFaP3q7LuTBWG80y+syB79G0W2OE
         DF/5ncooPYpU3CR33hiirfcPPUX9PVr94m/VWJ5+LZP7eR8q4cnaX4KzktrirOAuCL3a
         ZcbYUUd0L7OS2cjC8HVfa4Yrlt/dhGlDHqlyzSf4C+tIO/8tu68Enk/kPmEp1eH3I/tE
         I6cAB4F6uKmZ9ql6f/hahnQxTB0zorl7UNrtfVTsonoA7DlaooPQYZ2yBKdo/8uxhOoI
         Pf9A==
X-Gm-Message-State: AOJu0YzioC6Y+EeIh8qczvKJ8lYpnwvTzMGWoW20KCUaYhQOUniNqO4K
	HhFe9BJWt8pYOq9qVVp/cDAfkh/H/VcPMmbviDwjzbN+dCf6i7/iIdQIKJ6EjJxstCPyY20oSkl
	/DTIn0Q==
X-Google-Smtp-Source: AGHT+IFbj44B83iSbE5A+vqSrciKuaygxoH40sCo6SkWHfvt5hELe3GEpiiE21IydS3tBnU29mqnLgsJFnM=
X-Received: from pjbqa11.prod.google.com ([2002:a17:90b:4fcb:b0:31c:2fe4:33bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2a8c:b0:23f:dc56:66e2
 with SMTP id d9443c01a7336-24096b2a372mr19186465ad.38.1753829731380; Tue, 29
 Jul 2025 15:55:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:32 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-2-seanjc@google.com>
Subject: [PATCH v17 01/24] KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
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

From: Fuad Tabba <tabba@google.com>

Rename the Kconfig option CONFIG_KVM_PRIVATE_MEM to
CONFIG_KVM_GUEST_MEMFD. The original name implied that the feature only
supported "private" memory. However, CONFIG_KVM_PRIVATE_MEM enables
guest_memfd in general, which is not exclusively for private memory.
Subsequent patches in this series will add guest_memfd support for
non-CoCo VMs, whose memory is not private.

Renaming the Kconfig option to CONFIG_KVM_GUEST_MEMFD more accurately
reflects its broader scope as the main Kconfig option for all
guest_memfd-backed memory. This provides clearer semantics for the
option and avoids confusion as new features are introduced.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h        | 14 +++++++-------
 virt/kvm/Kconfig                |  8 ++++----
 virt/kvm/Makefile.kvm           |  2 +-
 virt/kvm/kvm_main.c             |  4 ++--
 virt/kvm/kvm_mm.h               |  4 ++--
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..7b0f2b3e492d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2276,7 +2276,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #else
 #define kvm_arch_has_private_mem(kvm) false
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..8cdc0b3cc1b1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -602,7 +602,7 @@ struct kvm_memory_slot {
 	short id;
 	u16 as_id;
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 	struct {
 		/*
 		 * Writes protected by kvm->slots_lock.  Acquiring a
@@ -720,10 +720,10 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 #endif
 
 /*
- * Arch code must define kvm_arch_has_private_mem if support for private memory
- * is enabled.
+ * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
+ * enabled.
  */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
+#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GUEST_MEMFD)
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
@@ -2505,7 +2505,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
+	return IS_ENABLED(CONFIG_KVM_GUEST_MEMFD) &&
 	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
@@ -2515,7 +2515,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
@@ -2528,7 +2528,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
-#endif /* CONFIG_KVM_PRIVATE_MEM */
+#endif /* CONFIG_KVM_GUEST_MEMFD */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 727b542074e7..e4b400feff94 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -112,19 +112,19 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
-config KVM_PRIVATE_MEM
+config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        bool
 
 config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
-       select KVM_PRIVATE_MEM
+       select KVM_GUEST_MEMFD
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
        bool
-       depends on KVM_PRIVATE_MEM
+       depends on KVM_GUEST_MEMFD
 
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
-       depends on KVM_PRIVATE_MEM
+       depends on KVM_GUEST_MEMFD
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 724c89af78af..d047d4cf58c9 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -12,4 +12,4 @@ kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
-kvm-$(CONFIG_KVM_PRIVATE_MEM) += $(KVM)/guest_memfd.o
+kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..25a94eed75fd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4915,7 +4915,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		return kvm_supported_mem_attributes(kvm);
 #endif
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
 #endif
@@ -5352,7 +5352,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_GET_STATS_FD:
 		r = kvm_vm_ioctl_get_stats_fd(kvm);
 		break;
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CREATE_GUEST_MEMFD: {
 		struct kvm_create_guest_memfd guest_memfd;
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index acef3f5c582a..31defb08ccba 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -67,7 +67,7 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 }
 #endif /* HAVE_KVM_PFNCACHE */
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 void kvm_gmem_init(struct module *module);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -91,6 +91,6 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
 	WARN_ON_ONCE(1);
 }
-#endif /* CONFIG_KVM_PRIVATE_MEM */
+#endif /* CONFIG_KVM_GUEST_MEMFD */
 
 #endif /* __KVM_MM_H__ */
-- 
2.50.1.552.g942d659e1b-goog


