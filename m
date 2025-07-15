Return-Path: <kvm+bounces-52470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61741B05675
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:34:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2631B1C237A6
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F028526E71A;
	Tue, 15 Jul 2025 09:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="syV0R9I5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268EB2D6612
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572040; cv=none; b=BZv1GmDpNFd9xPBItfUFTf7iipBx343UiX/E1VLlhs8GtVbVltcnyEldLl1kKmlnm9GRaGSNBRnDc+XRI3r7aclug24/Ii2uIsDXRPf9CJKghTFb88Ju63tKLf1eKoTYEPW6fxqR0rkfmJkbNQZfZTf9DBWxpU6NBH5PG/MqmCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572040; c=relaxed/simple;
	bh=H09IkjV4Xil817na22yCswVhU23DwQZ/x+bC3unupSo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mSEJwkVmes282o8pCFj7f7WB6ES7pxTBWReWAuQHX3qhLrgUrrGWpW56judNoWA6B+NXnHiwygFMSh1gxs1IAnqlCYjXrz5MgGwpeGCXr9GEE+Xul+dJjpRK28/iVhNEL/Mo++jvu44s3hkMn+4iMqQsmcv5+Bp0XQtHFM4KaEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=syV0R9I5; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a579058758so2099991f8f.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572036; x=1753176836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PJ/wXOElC+Z8OeCgIzyNM4mWk3Ktz7XTnyHef6ynGNw=;
        b=syV0R9I5ttFoXaTxzGRoGtaRmKkCitGUXyeXkO571oPk86ytHfejo9SLv+uL30uojT
         N9HiRU0ZDt/938kQmMZgTapAH8n1xp9Fqn97LgedtJNuXphivYRKFWUv4C7aSQaJfe3B
         eN3jzvLvqN1CfJKhWwRlEugYB7nP/9/R5Vs1XnRiaSwKSkFOOp3RvEtxjDCg4vlRHAXb
         8xxUF+D5UkLSjjgRlcny0l77h/JzxKbkU2fmWoluU5Shd48tOGAlgryX+XPmyeKAhjqm
         kETBWiu06w5NC5miZaJpfsEGKiudnkzIW8o+40wwmYALvF1t1McyAsMeZ/FJoWZ5v4ip
         US0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572036; x=1753176836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJ/wXOElC+Z8OeCgIzyNM4mWk3Ktz7XTnyHef6ynGNw=;
        b=hxgEnyzgEfVCzzkewKo/4nD0/vlLzJ6WYkIKRInVPt24ryIs7FiS59A1PGz9PBEPqL
         ftDF0yCYe2HAo6Hpf7XOTBaHRQph22/KvVczM7neEeoApgavOR+gbhmKkRnN1pY8ko3B
         eQO2vMkqMlQZwHZ8IgKrw+CDiVbetAIezOr6P7XqXUAZsfHw3+oECL7QnCBb5U3tlAQp
         MJlPGrwpkmZOu9NxEbiNR3sQXpbmmOCNqP/mKMZJ58gHCv7rjJ/x7JmP31dq0kffJ+AD
         AKEruhxp3u1edkadgorAW/epgQ+ZPgKZetOC8QJwGhOyIlVHoXPomwyYlwsOYP30zt5N
         CVAA==
X-Gm-Message-State: AOJu0Yy0ruIx/5I9OCwOtCiFY0WV+kTeu/Iqn8m5VQJq0WkiaKzKZHCk
	cdEZaq8vajtR5BGGHTvm38+Yyg7mvBOb3sojgEeLBFfXNjbh5blNMPepkqSA8dE3KcwlUchWnI1
	lBT1GVybntuWzXUfRZH5aKlDgLZcgxL112vAs/wTV9WW7GX+zZMjJHN+NXbbf35HAnYjcfrjVV/
	+YymNPGziFjU+Dwsn10DKU0U3xKbY=
X-Google-Smtp-Source: AGHT+IH9ipyPGuO8V82XBpfvrhIepf1jzkzfgTXGPdhYm+JoZw3MCGOKBqX02lTq+T6nYvHhNxdAlVbf4Q==
X-Received: from wrce6.prod.google.com ([2002:adf:9bc6:0:b0:3a5:7dbc:4d24])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f52:0:b0:3b4:990b:9ee7
 with SMTP id ffacd0b85a97d-3b5f18959b5mr13313952f8f.22.1752572036063; Tue, 15
 Jul 2025 02:33:56 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:31 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-3-tabba@google.com>
Subject: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
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


