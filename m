Return-Path: <kvm+bounces-47448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9052AC18E8
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 02:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70A7D504FD7
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 00:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B970127454;
	Fri, 23 May 2025 00:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o3sxMYV6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF8824DCFC
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747959108; cv=none; b=rbXVpDEV1rCu++t83yDpJhiIubURHatYVB0qHGr68IDsnqMwtA0ifzUYPKJ7ExIloDxnXDNTT5lPTQtg0G1POhdi3RcNj37GMTw9L1BWOxPSc5YNmpo7xwSoijbqXfzQO3ZuEOkVDgmme910yS4DSD4Iz9tVqSMF8tVCifb6oSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747959108; c=relaxed/simple;
	bh=+ePbA9IebCdbBB4vABHa4UUkOnxwLFCdaaUUAlJzaeo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dJsdOZgWAxn7xktv1YEwi3LkNRyWj5bP8Wdw+G9t76meEqzn/M5NDCCx9Yv7W4PwoTlEsRuDZeBGlcks+Haugx3eogmbNswYI9cr0DKGHR2ItYfkWmbs2HytdLOuE84VO49cxHUX6tn87XC79RAfecbOORsAE7uOUy+vP0nEhYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o3sxMYV6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30eda215ea4so4577683a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747959106; x=1748563906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SFvVGfdjVe68Lcv3nMcYvz6wEM8RX1QjbaqHj6wcH2k=;
        b=o3sxMYV6cSis3XtpXIXqQJ/ix5+ZyB/OAbceQwb8jHrTkOmUXwO266UsxkGw1lfxh9
         nxt/uuO/1br6UVKKOI2vR4pN36LG6MwgmKiLIW+LC3keSWW8pduQVulU6s168JRu/DVh
         j/3E2L/7qJPQESHx/rOVCTvCP8AUTRJLNYR30EDyEEPWzueu6r5HaxJdeu45PXHDKxon
         GRQfXYQ9Lb9U95Zuzd0azls1vgRVBkzZhnnn0blwneHQOSSWqjFzENjcJU024FaOoFPd
         pwFdkH457y//cTzVuFdbUVKN2ptnoPSq67RS69ppQdGlvkczEtrOM4mjNJBcNKkZ8mYp
         9VFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747959106; x=1748563906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SFvVGfdjVe68Lcv3nMcYvz6wEM8RX1QjbaqHj6wcH2k=;
        b=UVd5NsFEvJPyWva0NCNwo9i05QN5LIe0fP8H4b/VV9RL/SNTuqaCoQi/XDUruWlWct
         CJN+ZHgWYmxbyh3W+QmRZV/IeCgh8GP2Kvqma9Sq2hcwi0eqTZ+GD5rk6Pf2NS8J0Opx
         Od/0HZ6I7mBIjkKO3UyKx4oAM1Q5PgF43DfsO/muGoGrOQfe2JdBKqkjpAa5miX5tvQk
         PfXSTACvT8qNJqZ8aVYhGfDHWkpwIbhhyQ8jNmecLa9Wl0LArM6EBwnec0ibGg6Wymtv
         O+9tA46NxNeY+orvec+6AEGqTNVE++60i5L3I7e/ZQIK17jmpzAuy7C1RYTZfJSkAFKK
         4DWA==
X-Gm-Message-State: AOJu0YwUYEReazZMyhhViWIryWfZg6+zhR3ncr0DEd8zMPEenhzqSMgy
	7w4vIY/LAXclUGtC3kTunxfxMWtxbUQEwMRYD+qRyajRQ6GxNs/r6gYgDitL6kiGjO9hQ9ndVLw
	Up4eGkQ==
X-Google-Smtp-Source: AGHT+IFXejHNB1MVLyCyxsu8hgU/yJNUmWF4rMS2c4NmhYW0BkLhjuLGqMvU5Lsb8AeRc+Sz5DJolyQUQkQ=
X-Received: from pjd15.prod.google.com ([2002:a17:90b:54cf:b0:308:861f:fddb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f0d:b0:2fe:68a5:d84b
 with SMTP id 98e67ed59e1d1-30e7d4e7e1bmr38315774a91.1.1747959106548; Thu, 22
 May 2025 17:11:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:11:37 -0700
In-Reply-To: <20250523001138.3182794-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523001138.3182794-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523001138.3182794-4-seanjc@google.com>
Subject: [PATCH v4 3/4] KVM: x86: Use kvzalloc() to allocate VM struct
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Allocate VM structs via kvzalloc(), i.e. try to use a contiguous physical
allocation before falling back to __vmalloc(), to avoid the overhead of
establishing the virtual mappings.  For non-debug builds, The SVM and VMX
(and TDX) structures are now just below 7000 bytes in the worst case
scenario (see below), i.e. are order-1 allocations, and will likely remain
that way for quite some time.

Add compile-time assertions in vendor code to ensure the size of the
structures, sans the memslos hash tables, are order-0 allocations, i.e.
are less than 4KiB.  There's nothing fundamentally wrong with a larger
kvm_{svm,vmx,tdx} size, but given that the size of the structure (without
the memslots hash tables) is below 2KiB after 18+ years of existence,
more than doubling the size would be quite notable.

Add sanity checks on the memslot hash table sizes, partly to ensure they
aren't resized without accounting for the impact on VM structure size, and
partly to document that the majority of the size of VM structures comes
from the memslots.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/tdx.c          |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 arch/x86/kvm/x86.h              | 22 ++++++++++++++++++++++
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9667d6b929ee..3a985825a945 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1961,7 +1961,7 @@ void kvm_x86_vendor_exit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	return kvzalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT);
 }
 
 #define __KVM_HAVE_ARCH_VM_FREE
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0ad1a6d4fb6d..d13e475c3407 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5675,6 +5675,8 @@ static int __init svm_init(void)
 {
 	int r;
 
+	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_svm);
+
 	__unused_size_checks();
 
 	if (!kvm_is_svm_supported())
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1790f6dee870..559fb18ff9fb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3531,6 +3531,8 @@ int __init tdx_bringup(void)
 
 void __init tdx_hardware_setup(void)
 {
+	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_tdx);
+
 	/*
 	 * Note, if the TDX module can't be loaded, KVM TDX support will be
 	 * disabled but KVM will continue loading (see tdx_bringup()).
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ff00ae9f05a..ef58b727d6c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8643,6 +8643,8 @@ int __init vmx_init(void)
 {
 	int r, cpu;
 
+	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_vmx);
+
 	if (!kvm_is_vmx_supported())
 		return -EOPNOTSUPP;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 832f0faf4779..db4e6a90e83d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -55,6 +55,28 @@ struct kvm_host_values {
 
 void kvm_spurious_fault(void);
 
+#define SIZE_OF_MEMSLOTS_HASHTABLE \
+	(sizeof(((struct kvm_memslots *)0)->id_hash) * 2 * KVM_MAX_NR_ADDRESS_SPACES)
+
+/* Sanity check the size of the memslot hash tables. */
+static_assert(SIZE_OF_MEMSLOTS_HASHTABLE ==
+	      (1024 * (1 + IS_ENABLED(CONFIG_X86_64)) * (1 + IS_ENABLED(CONFIG_KVM_SMM))));
+
+/*
+ * Assert that "struct kvm_{svm,vmx,tdx}" is an order-0 or order-1 allocation.
+ * Spilling over to an order-2 allocation isn't fundamentally problematic, but
+ * isn't expected to happen in the foreseeable future (O(years)).  Assert that
+ * the size is an order-0 allocation when ignoring the memslot hash tables, to
+ * help detect and debug unexpected size increases.
+ */
+#define KVM_SANITY_CHECK_VM_STRUCT_SIZE(x)						\
+do {											\
+	BUILD_BUG_ON(get_order(sizeof(struct x) - SIZE_OF_MEMSLOTS_HASHTABLE) &&	\
+		     !IS_ENABLED(CONFIG_DEBUG_KERNEL) && !IS_ENABLED(CONFIG_KASAN));	\
+	BUILD_BUG_ON(get_order(sizeof(struct x)) > 1 &&					\
+		     !IS_ENABLED(CONFIG_DEBUG_KERNEL) && !IS_ENABLED(CONFIG_KASAN));	\
+} while (0)
+
 #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
 ({									\
 	bool failed = (consistency_check);				\
-- 
2.49.0.1151.ga128411c76-goog


