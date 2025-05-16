Return-Path: <kvm+bounces-46900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6941AABA599
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E70587AD2C4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1E928031E;
	Fri, 16 May 2025 21:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mpgAOzN6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3455628003A
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747432481; cv=none; b=i6LZ8YTNzONw2j0GMDYXfvX4+25UCR7ItU3zHKYl0B8QHiBH886j26wabkILJ0YIoj869xObMKl4ur2cJDhLs9OtgcpadKRvYuJL2T2AkOEsE/ByRH8PZA1ZITh3DyBF/lyfvOaUqHpkePrSdH/e0K4SE6fNLebkNTezXSHw6Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747432481; c=relaxed/simple;
	bh=nRPieSPOQF3VWwkmferQ1dgFBNyvX49xzQ3/NHlAE9Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hshP2GqIRX5NaKa6OsJVGzpW9XsAY8wY3ZSUtl+XZMXX6yTDhTXnEhdgwuxvkuBDYdw6UhtobesATFJQGNHUua9dlIDNrHzV/heAuEYsExp2GoTCZo+gzbVJS5+fwvel3rVVphWq9W08tz90wswyc2aXDciodl8nP9FjHFQH+YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mpgAOzN6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e8aec4689so820161a91.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747432479; x=1748037279; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D0gXvpr2sHdqy9QZLUq/qbAZv7yiyUTA7R6EBW7+pvc=;
        b=mpgAOzN609xA3+MSbXoT0pRFGc/sGYDtMvWODsOZRp9/SdDIQwxKNRbycdg5iCrscn
         1UjqFf4KpE+cZh8qwGS3V166rUtCGI0uo4B0t5sLmVzsbf5cepwakJGItZlS3EBZZ8iA
         yxIno286gtoM1apT3fSWbxtp+TYhI5axFXVbAGihfk/HaW3WpQ6E8D+D9Ww6BBgNKIlq
         3Pz2l05PIcnBnlwJeaFQ5KEq0yxgkuBu4VqIpG9Dd9Zmz62ehwukxDobK4v/h9bdZvpI
         zrwySx6zD37w1pEBhalO0BxjeXagDd02FYqRPk7446mTnoUg42JKOk2aqRjPLYD+LBPA
         ZVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747432479; x=1748037279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D0gXvpr2sHdqy9QZLUq/qbAZv7yiyUTA7R6EBW7+pvc=;
        b=rR/kp5Qr+kL6u6BJW8TZx/ykw0Zc5+dxYYTyw+w9kUm7J/4bILXcAkfLxAbOKNqTPV
         jw+DMvi0bE8YWze08rg1kH+rrP+zlO2qo8d8LLKxJANVTOYQsNbayQ4EA7s5PnWOWwU5
         z0pQjzKKIIPYyorVinE+lWlc7nFklYfML6Mx2AevfLA2p2ekcrN8xlTWQzDiy//gXkGw
         XtVKn+t5XzuXzFvQlSh1nHlbcEyYMpAGVaJrYDOfmav2SaDG65HZ9WRwqFFnwjoDFXzY
         Kol1udcc+yV4CMUelb/Bqt89q4Ske+S9a47OuhO6jBu5JseNjQA6UxqalyAyjIlMgHlc
         YNag==
X-Gm-Message-State: AOJu0YxgsCsgqtaMyOiJoMSGus37EPY/uAy6OsgdBo4eBsHKA7p6wYTp
	+Oc3d8qm9fZa7Dl74L8hL74PGC1NLG2zdJttUFWGpusU1/q6u/Njc6dExKAdtf8u7bSp3UDbXv2
	IE0dWdQ==
X-Google-Smtp-Source: AGHT+IH34nCA0NwEOc5om/HjB7xT1Sgsq7/Owr6ybh70IbeIayMQAkFXjkdzcFi3Zex3eJnI4pnnMU32WEw=
X-Received: from pjbpt6.prod.google.com ([2002:a17:90b:3d06:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c5:b0:2f2:a664:df1a
 with SMTP id 98e67ed59e1d1-30e7d4f920dmr8130238a91.2.1747432479652; Fri, 16
 May 2025 14:54:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:54:21 -0700
In-Reply-To: <20250516215422.2550669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516215422.2550669-3-seanjc@google.com>
Subject: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
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
 arch/x86/kvm/vmx/main.c         |  2 ++
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
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..e18dfada2e90 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -64,6 +64,8 @@ static __init int vt_hardware_setup(void)
 		vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
 	}
 
+	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_tdx);
+
 	return 0;
 }
 
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
index 832f0faf4779..0f3046cccb79 100644
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
+	BUILD_BUG_ON(get_order(sizeof(struct x)) < 2 &&					\
+		     !IS_ENABLED(CONFIG_DEBUG_KERNEL) && !IS_ENABLED(CONFIG_KASAN));	\
+} while (0)
+
 #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
 ({									\
 	bool failed = (consistency_check);				\
-- 
2.49.0.1112.g889b7c5bd8-goog


