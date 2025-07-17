Return-Path: <kvm+bounces-52767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 549FAB091D1
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E8D6188A28A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BBF2FEE3B;
	Thu, 17 Jul 2025 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rju+tRQ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6E32FEE11
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769670; cv=none; b=byVnAOle44oqRub2/INNTmGjZN9pYI2C2gp1ab6Msm6DuobVtX1Djykbwo8uq42dZBXq6Fppc95hXPW0oof4t311Xzgu0IhcEf/ZABrmeWBKrXPwA+hVwYzVw1CHZqN5qtOtLNx4xPqhmVKiQQKBoKAAwrfdr46xcjy4UY9F7HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769670; c=relaxed/simple;
	bh=XqEDOOHzbtsev2fOvalNFu/wy33rAet52j1YnkQ4zec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vAJZD4qid0Oqfm772Fg6FDC8V2nkiw1MLW8+YBbK91tvqdbHJiCH/HbC+TNSjWFeIU02/OAX393YahXHdPeWLqf01FtBJJ8LFty4WJHN7aUTD1rOA8kQxoLv+Dnn49xFP9UYvtrQGLNhf//bL3CRIvlgyL27QDe9zWj8N1iZjEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rju+tRQ6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4538f375e86so11094985e9.3
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769667; x=1753374467; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ+SnMbckSSIhN9bCpI/0R+FpsGYVOPeZJ6oIUky9aI=;
        b=rju+tRQ69KruS+2oa3dLc3c3Hh+gchMtt/fAYcetu9Z/RZDaGQthMFE1p5RDSAbOT2
         saQAIYsn7wHF+j075ZQtq5jWpkc8fFvqjI4muCcVafXCpej9IhyrTN0Jdcmn6yBXmKJs
         q+KAV78C7p12pF6H/XSKdXOrerjzk8/71PYwrrCQrpu15vuppLXvAlMlRwk+bw0YG/Ri
         3seMSnQWqrT1c5SNqPfhrrymO5nAHjvdecLg1sEQRZ+8iSsfIcv0DS5OiQL1ogC9JiTW
         rjcig4CJjHjXhjMM6SIvrJsgNDSmySKYxlnv0sVJWX9ze8OyGh9Q7gVvU5m8avvRk6Wc
         C5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769667; x=1753374467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ+SnMbckSSIhN9bCpI/0R+FpsGYVOPeZJ6oIUky9aI=;
        b=IuBV7+suTY1SNv0JPUbyp+z/7SfMesmtlUkV3iX5kcmrC1X/Em1fKGf1DRBIXQ6Ypq
         u0q4idSjBEMAjIOLVvpR6yywVr4xwtcPKH9S/TAsRESitnTddHhyhmUN2W7iRoBhN8YV
         fDMGjRoi+XPS7JVGaBQ/AsUz+hVihx7/lLnQpT6Qca71QXdGA+YZF5qJgaBDRW5Q0p7J
         Zj1lsvKtQ4QoOfMgzLOJuX1gkHLOuyLP153z/4P/Mzcg5gPhMe8zusiN4QaZM7yuO4LQ
         H1GRjThH+XAGaOPWRHz5AdoB8P5cxMrGtECbPMdkK1LGejh4YzmyG8k3Bjthm6eMXpBI
         hWWA==
X-Gm-Message-State: AOJu0YyqJoZ5/car+YgMfAVJBXe+u2pQDHmKH7lLyuohqyQ0trllonqL
	TLi+n7ZqVV8yWD/hCUfZdSTeEtBJY4suRyDLc6KMzaotSeENNSQlgZn5UAqs1xSRv5kT4sryxpp
	RagQIBpA9NVkoS3lctmTG8R4FIbd/6QlT3UnP0cNNVTTnN6z1Zbgy6ZIN2UYc6cToiPQrEdC8Us
	yr/UC47oxEgv2o3Cjf8nq4T0neIHQ=
X-Google-Smtp-Source: AGHT+IHEntPmO9DY+DxchMnwOgYv2GREd1oegFwljdQ3Vt27b6YI+20amCtzyHAiGDugFG1DH5Xc3wIVPQ==
X-Received: from wmrm6.prod.google.com ([2002:a05:600c:37c6:b0:456:13a2:2e7e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8188:b0:456:1923:7549
 with SMTP id 5b1f17b1804b1-45634dd8050mr33926905e9.26.1752769666906; Thu, 17
 Jul 2025 09:27:46 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:24 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-15-tabba@google.com>
Subject: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default VM type
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

Enable host userspace mmap support for guest_memfd-backed memory when
running KVM with the KVM_X86_DEFAULT_VM type:

* Define kvm_arch_supports_gmem_mmap() for KVM_X86_DEFAULT_VM: Introduce
  the architecture-specific kvm_arch_supports_gmem_mmap() macro,
  specifically enabling mmap support for KVM_X86_DEFAULT_VM instances.
  This macro, gated by CONFIG_KVM_GMEM_SUPPORTS_MMAP, ensures that only
  the default VM type can leverage guest_memfd mmap functionality on
  x86. This explicit enablement prevents CoCo VMs, which use guest_memfd
  primarily for private memory and rely on hardware-enforced privacy,
  from accidentally exposing guest memory via host userspace mappings.

* Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in KVM_X86: Enable the
  CONFIG_KVM_GMEM_SUPPORTS_MMAP Kconfig option when KVM_X86 is selected.
  This ensures that the necessary code for guest_memfd mmap support
  (introduced earlier) is compiled into the kernel for x86. This Kconfig
  option acts as a system-wide gate for the guest_memfd mmap capability.
  It implicitly enables CONFIG_KVM_GMEM, making guest_memfd available,
  and then layers the mmap capability on top specifically for the
  default VM.

These changes make guest_memfd a more versatile memory backing for
standard KVM guests, allowing VMMs to use a unified guest_memfd model
for both private (CoCo) and non-private (default) VMs. This is a
prerequisite for use cases such as running Firecracker guests entirely
backed by guest_memfd and implementing direct map removal for non-CoCo
VMs.

Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +++++++++
 arch/x86/kvm/Kconfig            | 1 +
 arch/x86/kvm/x86.c              | 3 ++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 543d09fd4bca..e1426adfa93e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2279,9 +2279,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
+
+/*
+ * CoCo VMs with hardware support that use guest_memfd only for backing private
+ * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
+ */
+#define kvm_arch_supports_gmem_mmap(kvm)		\
+	(IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&	\
+	 (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
 #else
 #define kvm_arch_has_private_mem(kvm) false
 #define kvm_arch_supports_gmem(kvm) false
+#define kvm_arch_supports_gmem_mmap(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 12e723bb76cc..4acecfb70811 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -48,6 +48,7 @@ config KVM_X86
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GMEM if KVM_SW_PROTECTED_VM
 	select KVM_GENERIC_MEMORY_ATTRIBUTES if KVM_SW_PROTECTED_VM
+	select KVM_GMEM_SUPPORTS_MMAP if X86_64
 	select KVM_WERROR if WERROR
 
 config KVM
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index adbdc2cc97d4..ca99187a566e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12781,7 +12781,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm->arch.vm_type = type;
 	kvm->arch.has_private_mem = (type == KVM_X86_SW_PROTECTED_VM);
-	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem =
+		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.50.0.727.gbf7dc18ff4-goog


