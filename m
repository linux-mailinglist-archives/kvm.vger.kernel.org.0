Return-Path: <kvm+bounces-49049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B675AD5722
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B43F8171B6C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A79628CF6C;
	Wed, 11 Jun 2025 13:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kIFec2RC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE4F28A71D
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648819; cv=none; b=VSYSREdjNFhZya2ejESVWcQHc5aq2eTDdpZvZHqMlGcLeCt0B3iN3Ux1w58aE7vN4J7/w0mIcsHI5tNphHGHMG76UHX2JgiHTbD9Y5iB5cbMV0Ymd8uCSG62DZJ0fw0+ZjM4yVQ1DZfRYiYmxytx9tM/LoLzy6LUiNRAfxM5Yqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648819; c=relaxed/simple;
	bh=eedZ0Odlmb15tEnzmGB/L5qIaAHZsoYCFIO/KNKE/pE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kW8TtZ+ldSBfA8H5YD/j8qoq67CT3ni6peBNhdv5SUtkXj0neIBQA5DPO7vVnHfAJOkOHNBMx8cNWJ3ur+xF0Hj1R2YE5//VG/P3f3D/o/HGDlvZt4wid1sVtc2DA5a7apgjtE8Ghv+LE4owOoB8UafbTYpkPhQTjCzDjhQTga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kIFec2RC; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4530ec2c87cso22563765e9.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648816; x=1750253616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sby3t6E3SqseU66+AjZSRAM5YQx/H+Ih8yt31sFaamo=;
        b=kIFec2RCa1NPknaeGahGu2nLR1SX8hh5kAU4w8GUCPyhhJmdTJ+ODeWWAjjrU0Tfzg
         z3xg0IyrWoZeRNqVToXp+rTODKAMcj8yOPHsvq+c/vD0vYntkhfF+E4EEpqI0R5heidz
         UdtoDyJxN0ZNH2nrqDvlQMVzsC+h4AkM0Sirw0Oz5fP6nUimDLEOocEDYiCJZV+/9xZ/
         IGe6AxjRPDHT0sb3I8VucNDJF4ge7vw1eU9cskU6Ayy/9WI3DtleghGoH3wPjsM9uXJj
         nh/Xq8370hFLgNYVEhMxl7nAgyomOcXaa1Zr/axAST516rzujZ14UsQx6+NRawZJqb+H
         dDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648816; x=1750253616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sby3t6E3SqseU66+AjZSRAM5YQx/H+Ih8yt31sFaamo=;
        b=tS7TaR1BXdMTebHa2YKe2BF8ST9ez9zlZJbfqwwfhO4a8Uv2DdU2wv75+S7CrfP0a6
         /YaP/4MD+rLtpOhyLrjIGMdlmKcGxaoKR8afpL78wfzJ8ulF1IEbzqG9nMo+U0vE49WO
         +JhibTsc0jE29WUeJkxXmZ597RwUMC7AToYbPkFzWL+79YS8k7Q+BMlF21Orwebvek8J
         KbfxIm7jS6FrdkMLS0UiWhylnmTzpIT0XatqrjSOVGBKQhbSiRpT9mJUwqjQWQKWwN3e
         vZqkJl+XGpSf8Q1XhbrWctsYmM4zGebekWkayFUuvs+KPapmFch+cvWR0eVtk73B92rT
         o9sg==
X-Gm-Message-State: AOJu0YwFByHiZ3Hv8EdKxa/qQSZ9hmi3bTL9L7cCBCcKwnT3eQhn+zKL
	StkUYyRxyYJ0BsHyAU7WXBpuPu2CLKPl0j4WF8QiK2k+TYCXsHesWhiqQhOOUFebsDjlR2Ih2LF
	0l9pBuwqX4x2mBlo7kEG1dGfKX9lR2UGEybcEUgQtByyo37dFMo67blnTKZ800HR8KDT7vFgj2H
	eYif/fkDXiP+HigpYP/htNVFdCFIo=
X-Google-Smtp-Source: AGHT+IFaCPRTnRe5F4zwoOmailDRB5UmsMCtLol47gADiAuvV7sR757p1uzXQjjWMoxDfkgDrC1b9HUN7Q==
X-Received: from wmbbi10.prod.google.com ([2002:a05:600c:3d8a:b0:442:f8e9:a2ac])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8012:b0:43d:3df:42d8
 with SMTP id 5b1f17b1804b1-453296f41f6mr8408995e9.6.1749648816092; Wed, 11
 Jun 2025 06:33:36 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:14 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-3-tabba@google.com>
Subject: [PATCH v12 02/18] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
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

The option KVM_GENERIC_PRIVATE_MEM enables populating a GPA range with
guest data. Rename it to KVM_GENERIC_GMEM_POPULATE to make its purpose
clearer.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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
index 2eeffcec5382..9151cd82adab 100644
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
index b2c415e81e2e..7700efc06e35 100644
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
2.50.0.rc0.642.g800a2b2222-goog


