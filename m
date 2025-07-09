Return-Path: <kvm+bounces-51909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1264DAFE6A9
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41012188F12C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA67259CA9;
	Wed,  9 Jul 2025 10:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RwsbmLE7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32702C8EB
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 10:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058797; cv=none; b=CTB+5+K/QHnssLKm8ZwvjsKnmxFsVgYtyvSi0VfYjbwSp3gq3xLL9JwdKmJu+PMigHEnc2ilKERo70PWlD5HWZ5ZzUyB8Xzrt4hDINzq5IMwMmzioRR5k9+8Tsv/kcoXFKRVBQm0xXNPKQGp+8VTzTtZxij22sEIXjZ2M6hPa+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058797; c=relaxed/simple;
	bh=H09IkjV4Xil817na22yCswVhU23DwQZ/x+bC3unupSo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o5KBmyH02zSZ64ZYv9/uB9U0n8qrewLYuVqQoxnX6TTH9b4NbyTGLlI1V/7gaouVb5uQSgFIUpEZ+yL/M6Oo0tfNi1BVyc7gv8rqs46Zz804LGs2ACjIfty4FTvodstS0YMSxtpijy4QiScLgifr6gTkhmwT68bnYQJv7AEkbaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RwsbmLE7; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-454d910ea8dso1730925e9.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 03:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058793; x=1752663593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PJ/wXOElC+Z8OeCgIzyNM4mWk3Ktz7XTnyHef6ynGNw=;
        b=RwsbmLE700BVA5sXeePVmuGvITxrJjfbdHcga1rN9Og40Yrs6fYkJBjv/9O0fLxGQP
         Gr53BCy+O+eHlQZ6weQLdldLDc+UsnNacF0w+zouvSWMq8zkaWi7D8QS0sixS1GJ3vcu
         eSVyufPKOLir8WXR3VU5E0uVk9n2Eg3kMCN3rK6UDIdD2bHnYMIFalaVyusjmIWgwfTJ
         0yTny0z/8KW7Mk2XPsXUZZy/o9agNWQuxV5ogKpgNV/0EbMZ5Z+yUDeJyb1nqhlIrEO+
         ocKd4jj35lCAsi1ZtzvzRVwZBwAi6RyrS4+kMnDg3M3SjIGgqGpg+BWOiV6b+8WHPhHo
         vRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058793; x=1752663593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJ/wXOElC+Z8OeCgIzyNM4mWk3Ktz7XTnyHef6ynGNw=;
        b=iENWM696KsAnI/PCywPQsMpknUC84b8jELCxBiYM734W7q+j0KQlUYNUL6SVh4fNcL
         LLYlxUnDAXmTZVSmBBcyTcI5R63awCYYGkUI0ESr5ipws+fqJkvQauCmRvDQUkWQO/DI
         SwDElJxzSXvofydP2uRqJLPY/cd9XUk3LapA+rOPT8GHr1dLfJIQXaQrelf5rUq8hqFR
         sb1s2OnqCpyvOnuI28bHZnkMA0g7nwdvqXNbnllsRjX+qqWZxJlM3wmsA413XScfxhOt
         R4BvCB0XMNCP1bqJ/zWPmOiNTNt7t6Gmrutnk3ctK76GnyS5Qu9F7U8VhNFwH7y6/Vwq
         rxdA==
X-Gm-Message-State: AOJu0YwgY3eJIHREaB9fhPr0KaVlAGB8axKv0rHnSwlYaaK/K7uS4TVH
	VsNgjsZk3Ng0nKRCHqjkKgNrbHRPYOZMPSdRUPzmOS9v9MGbSJ1e+PcxsElcP8Jzm900QnCF4lj
	peiiMYj1bp9n884XnNvElgRj/1S+lcK6Eo3YxTqBDKXENvPUi2AUBv/RTEbfdVlHx6oMsPePQiM
	7Rl8X7/XHavat9ueeWcxni4BDp4aQ=
X-Google-Smtp-Source: AGHT+IEzG+1uKM9AO05dF2Ch0TQrrd9Vs97wNui/rXRXxB3s9D/bdjxKFTMJjpP+kA7nJqBXvADB7nrGMw==
X-Received: from wmpz17.prod.google.com ([2002:a05:600c:a11:b0:453:f28:e99f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d29:b0:453:5fde:fb5b
 with SMTP id 5b1f17b1804b1-454d535bbc6mr17668815e9.19.1752058793100; Wed, 09
 Jul 2025 03:59:53 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:28 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-3-tabba@google.com>
Subject: [PATCH v13 02/20] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
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

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig     | 6 +++---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/Kconfig         | 2 +-
 virt/kvm/guest_memfd.c   | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2eeffcec5382..df1fdbb4024b 100644
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
@@ -95,7 +95,7 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
-	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
+	select KVM_GENERIC_GMEM_POPULATE if INTEL_TDX_HOST
 	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
@@ -157,7 +157,7 @@ config KVM_AMD_SEV
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


