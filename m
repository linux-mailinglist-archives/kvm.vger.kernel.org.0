Return-Path: <kvm+bounces-44943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4234EAA5240
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 071831BC487B
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E32225A341;
	Wed, 30 Apr 2025 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yuheya24"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B376614AD2D
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032224; cv=none; b=DG6Z8eGb/utVpExuYpShhHuDxST2/V/4YLW21HNRzORVE+aBH83/0lybiAJjK8jd8+gs9SjAY+Qyu0fVKUCOcbcrXl/M69x6nV+4yXdA7sRUlzSXsjNd+gOAnqcxB3BHXIHNRUwogy9ZArBdgulswJ0lot4uGDzLvFsFmqp2tPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032224; c=relaxed/simple;
	bh=nwHILj2+5prz29PnFsotY0y6J6eLg8zMqCtDEF2APMw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eGeJUkF8ONU64Pa0SvHu3Neaa/pNtmc+43VQr3hvwSCN21v8k2n1ut8nA0udTTtuv7lvtjQvAM+YOwMiGcHx0o19wD2SV0VmvQi0TfQoFhYsi6jk7kMJUTzhWjqkgXUHMpIvLPXP3VQTCuLnPQjH1KKZKaH+oO66MmlIHPCdLqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yuheya24; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43941ad86d4so31575e9.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032221; x=1746637021; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EQOJicvOuD+4kvnHRJ2oY7nG9Llh+8wXb6K0ps724F0=;
        b=Yuheya24Zx+2QYk94q+hUPMMd04gd8lxzky+LHS9DP1Ly1YRaIiKz7Pwxkvgj3exaS
         ONttxc7zPUE/a+u/z4qiI1zwvkaQmexUPWCrRY8tfVQGG6OJJ6X3L+suIKuvkYqxPik8
         0on+SuhL2hshqSaF/QRwZW4wSsP0AlYx1WdwZCossGRfHzYiL8NBtbLqxYqWXLlH59gy
         mCJ/65eIk0pSlIg5XPw/Z6W+YprmXAziWeFVa8qf8IPondqBqhgQAnJIwqsdHVm4msNO
         RiNvmCvqRn1/cwk7G2rIkTAmPZNYQXbbw/m8JbtL+v3qU0nH70bPhCMig+6OkZGCKZmH
         /j+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032221; x=1746637021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EQOJicvOuD+4kvnHRJ2oY7nG9Llh+8wXb6K0ps724F0=;
        b=cgvlIlSIZUI/KpX+/vLfyYwLlF7CBNwDE7Asp/o12ujWeMJoWwV6RZSP0RT9xJmb+E
         bqCJ1VLs2NHANa/2RANyF1Q0JiaixZ6cTru/HzUcjwxG0VXKvt+JsXsJm7i1hh4mKpM4
         McHTPxZGCqbQndUP/k5nRuEoacGmede+Di9iqh6P/SI5fvtAjCOX+jUr4PrWZfea5CZd
         YRXH2BpcuKsId7WMJWDpFXkTcAI0ZW4ebd8VcAGgUXry80kF9NLQF2eo0gLgMv3gAa/N
         3IlMeSatTYR7Db4pdD4rKkpouYj6QBFRdvgxDjF6sdePdCNALdQtU7mmrdD+IHvZOZto
         sJEQ==
X-Gm-Message-State: AOJu0YzEoMo4YXwRavcYQo2SZ1msNT/Sm2TJCRboWQaNZOgPiXCwv/Pa
	3Ok2ejtJJoaiy3Jw/5GG+48+yi9JizpbcA/bs1vlEr3MwJAm/v+Pm0TvuvuBcry09s+XpXV7z2F
	w0tVM9vzosGnTT73P4Y73pWNkxguTodUzmoDwcmPLPCusLaN0e9Gus7jI7ZSCsdVgmqVcC7hFvu
	3wLwPlstbS3hP7FKKsy2EWf1Q=
X-Google-Smtp-Source: AGHT+IGwBVPOVGlrkY7iCJBXS/44guw/7Wk+oN3WlGjxVV4BaIM1xjA2zctAzqqrPbQWNZTXxR10YdF66Q==
X-Received: from wmbbh20.prod.google.com ([2002:a05:600c:3d14:b0:43c:eb09:3790])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f91:b0:43d:ac5:11ed
 with SMTP id 5b1f17b1804b1-441b1f5b8f7mr33803595e9.24.1746032221004; Wed, 30
 Apr 2025 09:57:01 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:44 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-3-tabba@google.com>
Subject: [PATCH v8 02/13] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
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

The option KVM_GENERIC_PRIVATE_MEM enables populating a GPA range with
guest data. Rename it to KVM_GENERIC_GMEM_POPULATE to make its purpose
clearer.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig     | 4 ++--
 include/linux/kvm_host.h | 2 +-
 virt/kvm/Kconfig         | 2 +-
 virt/kvm/guest_memfd.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fe8ea8c097de..b37258253543 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,7 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
@@ -145,7 +145,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_GENERIC_GMEM_POPULATE
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	help
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d6900995725d..7ca23837fa52 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2533,7 +2533,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
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
2.49.0.901.g37484f566f-goog


