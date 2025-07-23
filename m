Return-Path: <kvm+bounces-53204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFC8B0F03E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E34DA583EA9
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA442DCBE2;
	Wed, 23 Jul 2025 10:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kv0eeSXw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D05279327
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 10:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267643; cv=none; b=cfEl5IcLmCpddSuB+S2tLb33/nhSns2n8+J4Qf5NUdsf0kDrdaUyuAxMzE+hdLzHatLPdDcSMn5i5DjRC230iyGMJPnz6EKdRzvD74zvwFegUow2sOmwnHxDVO2J1OI5K13x2HawX+KFQxr/gVkX25eouxGH6I3EpUF2lxLseag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267643; c=relaxed/simple;
	bh=/qFLvaw3qRiAnkbo/svqH6YEjKKkTKH3rHCEjGPEx9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DNmEY68KfukynKI6d/GnLf4kbf/R6YWePnBeDgTOKuLEjlVcSGXhKU/bF2nKfS/1Uc3nK9JsvZQWu5c7vGnAW1LgxgVmDTCXU1lZ+X1L753ZpnLu0tkFipk3I41rCS9uSyPb/8MmBhJ5rJF5zqWgrvmlKPLelUSytmFMm/66eMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kv0eeSXw; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso42567205e9.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 03:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267640; x=1753872440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v/iLEXFMU4kw9alr2fNpv+K1GdCI87fKjWZbDt0URPA=;
        b=Kv0eeSXwDJGOYbN1sHbujFcoAEZ7F34fMf0Z+JRShGChKbaj0KwtvvC6Zo8UvLcXc8
         j7zu+yhWBoHTicu3JfClS+I44rQrjEKcfAyXOaUB8nS1gsFyNIcy0X0I5xjgLwhrLjEu
         3Q3gT4LhKll3ryXv7PZc3srVnVSYRKevzE1xJdfhjTyYa0Sb47yRrxznf/iJqt+plZj3
         2HVPUOE82OuQZ/cBxy1x6k4TXrlzS36j8TqgxzFMDNXaFBKUSJl7uLhTg+PSUnZu8NWR
         HZ810X/wNfqbOXgv3Oi0nxFihZB2wO+Wigmq8zFmU15lX9JJ+OxH0eRyXfNT/kdlNYpW
         oJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267640; x=1753872440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v/iLEXFMU4kw9alr2fNpv+K1GdCI87fKjWZbDt0URPA=;
        b=aqamiLjO86yZSfyf9gz0MepOFthe+BUri0/wnGI8Gtkq47gBgjLWlobcxSE2yvsgZa
         w4AaWyyNgJvz/zOhZx4Vjzwew/Gt6h20TW/uZdhqgAcf3h+/NkZOJPG99pC7IryQGplw
         ZtSnGXhpJiLzjJgMyYAy/SH3F+eHZpinInvdOxCzS5Sq2SL46/s/dZ5TMbBiUxJ9A8Pa
         FIa5iwsKdSUdiKrDJLxiCrBY7E8B5BLG51EixpCUxLpuydLozAWXYfRgxlvq6UnUFVRT
         oSq6VOMO30uEMLL7hhxetkdMSHIm6+vv4FPnJlQGzFO3zcGmZTRRPPF3yOu80znVCQay
         gdsw==
X-Gm-Message-State: AOJu0YwC+OckbhbWkDHhChXpHvWFWTiTRsGJlOqI6jEIGBhnEsVM/FC7
	8ZEqXkwbjLMmavjjvOs767D3F1vLkD9in0UHDFNfq9XlTzWSm8H1+tctbzUYnSce/8tEMAgfNnQ
	+DeTA8NsF6UhX68D+rwfI9xVWeMPB50MEcAn7Dc4Y1MmKnUlqwyer1SF2pf4Xmi3SGrXXlBlcEb
	RyEoGAg1YkLX1OqI17O7aOhSpCFoc=
X-Google-Smtp-Source: AGHT+IH3WXM76dEJWXSMwuAToHQi81PRJw+VhhRbD1bW3aY/uCINmpRjg47P6NrMDnaKGwQgz0FVu4rmyw==
X-Received: from wmhf21.prod.google.com ([2002:a7b:cc15:0:b0:456:23aa:8bf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e28:b0:450:d3b9:4ba4
 with SMTP id 5b1f17b1804b1-45868c7903cmr21488365e9.2.1753267639741; Wed, 23
 Jul 2025 03:47:19 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:57 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-6-tabba@google.com>
Subject: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
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

The original name was vague regarding its functionality. This Kconfig
option specifically enables and gates the kvm_gmem_populate() function,
which is responsible for populating a GPA range with guest data.

The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
option: to enable arch-specific guest_memfd population mechanisms. It
also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
options.

This improves clarity for developers and ensures the name accurately
reflects the functionality it controls, especially as guest_memfd
support expands beyond purely "private" memory scenarios.

Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
function. Therefore, ensure that the correct configuration is selected
when KVM_SW_PROTECTED_VM is enabled.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig     | 14 ++++++++++----
 include/linux/kvm_host.h |  2 +-
 virt/kvm/Kconfig         |  9 ++++-----
 virt/kvm/guest_memfd.c   |  2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 13ab7265b505..c763446d9b9f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -79,11 +79,16 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_GUEST_MEMFD
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_X86_PRIVATE_MEM
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -133,8 +138,8 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_GENERIC_PRIVATE_MEM
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_X86_PRIVATE_MEM
+	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
 	  confidential VMs on Intel processors.
@@ -157,9 +162,10 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_X86_PRIVATE_MEM
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
+	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching encrypted VMs which use Secure
 	  Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8cdc0b3cc1b1..ddfb6cfe20a6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2534,7 +2534,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
 /**
  * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
  *
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index e4b400feff94..1b7d5be0b6c4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -116,11 +116,6 @@ config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        bool
 
-config KVM_GENERIC_PRIVATE_MEM
-       select KVM_GENERIC_MEMORY_ATTRIBUTES
-       select KVM_GUEST_MEMFD
-       bool
-
 config HAVE_KVM_ARCH_GMEM_PREPARE
        bool
        depends on KVM_GUEST_MEMFD
@@ -128,3 +123,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_GUEST_MEMFD
+
+config HAVE_KVM_ARCH_GMEM_POPULATE
+       bool
+       depends on KVM_GUEST_MEMFD
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7d85cc33c0bb..b2b50560e80e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -627,7 +627,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
-- 
2.50.1.470.g6ba607880d-goog


