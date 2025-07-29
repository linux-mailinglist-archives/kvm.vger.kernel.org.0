Return-Path: <kvm+bounces-53689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7177DB1558E
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38C797B2E46
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3576F2857C6;
	Tue, 29 Jul 2025 22:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cKRnjelS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4512BE04C
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829747; cv=none; b=oRf8KoD9zBOhy9Un/7SG8SqcyAPbBPjInKtSMoXQdytByMUNG6x658gHMMvaWdWyJ2dOjFafFGCTZMuBthDLHwOLA4jRcq2DSb0Jm37k/TiuYtjR2eeDheSWPFvVxsJxaTYRi57nP/AXlDXpTnDH/KCd8FmARsxN6pZK4qw4DZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829747; c=relaxed/simple;
	bh=Sh/IfRFoYWaPKcCYaCpo6wz2Cjf9m+WXMtg9Zp0+6jw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pZbjYTYbPZgriRaHezmdKgdB3zfYA+bri8NJRzhiDxUHnWQAKXt6TxKkBQQpNA1HHUZBi6m+qyjbT5bzXoJgfUy0K5zuvDKLW51Tng5ya200PvqwNtmoMgJ0gKwP7RFvO8Xzvik+v7Iij7m5PkyBmGeBNBeJiuVkkzfGxlbnYOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cKRnjelS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31eec17b5acso2958581a91.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829745; x=1754434545; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oV6gYTik8qRY3StGmPp/EUp2dAdw3D3Ak3GOGxl25v8=;
        b=cKRnjelS6OV9vgJoIZLd+O5acA0gMGTkpcZtVyrN+D/d4GiiBajbgsdYJzSx8R5l2g
         N/MnUjUc3uhfYYtg/fwQEAewo98CB4AB+rUhbpGXPBUV3lX7bX88K2wCOKPbFHIyCxv6
         k0FhRKkflKaYwR71mFRfKvuY98NBrqHzvShNX5jscybxsTVxEsQ6I1l7NNTNiBQfCgdG
         vwJp6qZbXB/09a6Lz1BPOy6lys2kNrGPfyyDfx3s8efumI3Cb8MLn+rQ9qks4Qaqan2C
         lywJTS7kG+UplQbTmzTmF+Fvj5vU52NQ19Yqx2dM7NhcCxXpe7CDQZExPgIMmsOH0p2N
         pyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829745; x=1754434545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oV6gYTik8qRY3StGmPp/EUp2dAdw3D3Ak3GOGxl25v8=;
        b=hI1KGsSpPF+OoXGg77yqQ/jbQqsup3qbWUwz5BvUo/eXvnHKh2ukdsMtAQpz1lMyUm
         7/Net+txC6ZpFEiM+AjDvnJCSDifM/pdWE/hVyuUZMr6RIXN7cnavzDCkFAL03eplLrt
         /gPCAgGNVhM2Wq5xe6o2TEEYPyltEcVSMD2BxOudxqK/761e9ESoYOfssbGxB6A+Tu6G
         hQgRFX4MLbvzqQIhtaTKvDJ0PJfvJRrRsPaocryjZ8eiVP4C04OwJPMZsuDWFOF3CIeC
         74tlU6gQyZf9FxPodp2Px54c19U8Lnq0NHf2Dr9oBXDXzXnoy7YsYKb6wUzm2YqAIXOH
         a7OA==
X-Gm-Message-State: AOJu0YwD7mzVDQFkKEGdMahrEhajkS68NXHfCAsY7rfSgRTrmURnkS7g
	XjIgJAAtT4Xf/EUe9VPIvP8oEesrIaPv/luXzH06l2xO/PZONkW7VMgqFhSeiYXqiaUMik15ppw
	7dmXEGA==
X-Google-Smtp-Source: AGHT+IFUKuUgGE8Xp/j1VSO4HB6WlF8z7V2tvMpDcnp8m/G+j0eEa4knj1wWJuc7IsYN2X0Q+kKp6nFysik=
X-Received: from pjbpv8.prod.google.com ([2002:a17:90b:3c88:b0:31e:998f:7b79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c3:b0:31c:15d9:8ae
 with SMTP id 98e67ed59e1d1-31f5de68c89mr1509857a91.33.1753829745204; Tue, 29
 Jul 2025 15:55:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:40 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-10-seanjc@google.com>
Subject: [PATCH v17 09/24] KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
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

Enable KVM_GUEST_MEMFD for all KVM x86 64-bit builds, i.e. for "default"
VM types when running on 64-bit KVM.  This will allow using guest_memfd
to back non-private memory for all VM shapes, by supporting mmap() on
guest_memfd.

Opportunistically clean up various conditionals that become tautologies
once x86 selects KVM_GUEST_MEMFD more broadly.  Specifically, because
SW protected VMs, SEV, and TDX are all 64-bit only, private memory no
longer needs to take explicit dependencies on KVM_GUEST_MEMFD, because
it is effectively a prerequisite.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +---
 arch/x86/kvm/Kconfig            | 12 ++++--------
 include/linux/kvm_host.h        |  9 ++-------
 virt/kvm/kvm_main.c             |  4 ++--
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b0f2b3e492d..50366a1ca192 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2276,10 +2276,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_GUEST_MEMFD
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
-#else
-#define kvm_arch_has_private_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index c763446d9b9f..4e43923656d0 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_WERROR if WERROR
+	select KVM_GUEST_MEMFD if X86_64
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
@@ -79,16 +80,11 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
-config KVM_X86_PRIVATE_MEM
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
-	select KVM_GUEST_MEMFD
-	bool
-
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -138,7 +134,7 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -162,7 +158,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 56ea8c862cfd..4d1c44622056 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -719,11 +719,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-/*
- * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
- * enabled.
- */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GUEST_MEMFD)
+#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
@@ -2505,8 +2501,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return IS_ENABLED(CONFIG_KVM_GUEST_MEMFD) &&
-	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aa86dfd757db..4f57cb92e109 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -4917,7 +4917,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:
-		return !kvm || kvm_arch_has_private_mem(kvm);
+		return 1;
 #endif
 	default:
 		break;
-- 
2.50.1.552.g942d659e1b-goog


