Return-Path: <kvm+bounces-52755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3006CB091B7
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CFCA3B78FD
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B222FCE02;
	Thu, 17 Jul 2025 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I/ifEe2o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B172FCE0F
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769657; cv=none; b=LkO+R/ynGey9tRX/5+XJCt32HZ1RSfNnrhkKXhjI13z7VUiUTOSTbmUJlWcbQv8PAVmwNmrUpgmt9sX5KftBY7BEhjo9Wxn72ZJrfwKmmQROLnEauIDL8kjrC3ISeGhdQ0UhJFnGtLi2SMEWKiwLj2BJPTawYa6bDxAV5lNShdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769657; c=relaxed/simple;
	bh=a2AmqfPqUEiHYBwe+SAO+KbajDt70Xo6aWdaPw9Jucc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=krfq51Q/c2UGC1cHXaptIJj86rLJUleMo/4H/o7LEAJ4sy6q3zgrG1deNyMGozeB8Jn73wwTnVmHCUTVS6UlptdIPDEF4QhS6lkcepptK3MtZ8UES1FAWqZdyhhReHmEJtiBOmA+7m9RDLLau784FK3mKG3PJ2MygAusX2B2hX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I/ifEe2o; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-455e9e09afeso5688685e9.2
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769654; x=1753374454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yrFFM6dN0hZn+joDbHE3S92ibbzuWQAFna6YR+Og468=;
        b=I/ifEe2obBbbOfSTTgiNq6jnUV+/Ts21b4peMZ9833qFtGOjjicv8zJ1om9xlcfIb7
         PchRxuHQQCMFHmU633gXbmyhpAt475jol4C1P9Ng4JMkgui3UbuyNVUK9pedsr/82ry0
         FU3GAgrzLyWZkkW510MMDD0qaaK9h2E/aaBcrJ2sGE0W3BWsCeXuE+/xrBfWY7FqwST/
         HIHbfAfU0M+i2Rr6dp5qvgrnzMgz9x5+sJgVy4EWf76Mgo23rFhWqHKzQx3gCtIW3paI
         iGFCxSphvKJrG7xK+jO4yEYZSl/nish95yexq709hMfTaljtCZ5ZIJnICN5vK+u+/eR5
         ww/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769654; x=1753374454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yrFFM6dN0hZn+joDbHE3S92ibbzuWQAFna6YR+Og468=;
        b=OC0IVPRoZzoYxzuhqP1g1DIWf+xjjFU72PN4IpaUqnRXrA1hsuSoDNFdc/qLdPO1gZ
         FNFWCTPptL2s6FS4yLvtan51KmNhCFqeDmeBF/BsMJpIBVVASFV9WjFlg0OLNaa4FAD3
         FN83KbKMn94jrcVatbETqYni+budmzNd+mXh4L8vL5sVaFcaO+Xk6nLPlMVIWNdPyHnl
         zOAuIKX6Xtbu0Gy0Tyw0aXztUcoAbDZmb9jhxKPb3FrxC063e1xWcHqjGWQNEVoHhmxe
         0q3oPHaDPpeLCDtSRJgTRIyiopFyDlyLqPzSi5j9MENglf18co1VRSy75Pi59UNDtW/m
         SPyw==
X-Gm-Message-State: AOJu0YyQQWgKeWag1SAO7avElPPrNmJisTGrpS2xo0Rru4byf54epOWi
	IKnV1xTs1KmgmUOcRyVFoX/6PoUAV6xGzMtIiY4RXwWBKF6pl3YPeXIz39iBDjdUBYWnoE8OTvA
	/oyfwCRgx10kDlmXQh5fxDJClhMI5DYBxZXuuEKw9OXrGeceX/aruT7ZNkl6bRvNpxzmc/v3CbI
	kxxXsrIJYTahxPhWaywf+v8yENTzc=
X-Google-Smtp-Source: AGHT+IGWNJmzVHRBtuRXV0Y7n1LnhwxUOBrg131DXM8VMhNpcDnApi+yf4VA5V6c8icP22qw5FpljorYqg==
X-Received: from wmbh26.prod.google.com ([2002:a05:600c:a11a:b0:442:ea0c:c453])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b29:b0:456:2ac6:cca4
 with SMTP id 5b1f17b1804b1-4562e34bad0mr72649705e9.13.1752769654113; Thu, 17
 Jul 2025 09:27:34 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:12 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-3-tabba@google.com>
Subject: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
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

The new name, KVM_GENERIC_GMEM_POPULATE, describes the purpose of the
option: to enable generic guest_memfd population mechanisms. This
improves clarity for developers and ensures the name accurately reflects
the functionality it controls, especially as guest_memfd support expands
beyond purely "private" memory scenarios.

Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
function. Therefore, ensure that the correct configuration is selected
when KVM_SW_PROTECTED_VM is enabled.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig     | 7 ++++---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/Kconfig         | 2 +-
 virt/kvm/guest_memfd.c   | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2eeffcec5382..12e723bb76cc 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,8 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+	select KVM_GMEM if KVM_SW_PROTECTED_VM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
@@ -95,7 +96,7 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
-	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
+	select KVM_GENERIC_GMEM_POPULATE if INTEL_TDX_HOST
 	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
@@ -157,7 +158,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_GENERIC_GMEM_POPULATE
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	help
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 755b09dcafce..359baaae5e9f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2556,7 +2556,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
 /**
  * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
  *
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 49df4e32bff7..559c93ad90be 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -116,7 +116,7 @@ config KVM_GMEM
        select XARRAY_MULTI
        bool
 
-config KVM_GENERIC_PRIVATE_MEM
+config KVM_GENERIC_GMEM_POPULATE
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_GMEM
        bool
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2aa6bf24d3a..befea51bbc75 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -638,7 +638,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
-- 
2.50.0.727.gbf7dc18ff4-goog


