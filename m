Return-Path: <kvm+bounces-47807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B570AC59BD
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4125F8A25CD
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA22280A3C;
	Tue, 27 May 2025 18:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pKCQFZ7l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7D9280314
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368974; cv=none; b=W2zZjw4Eq6peA4KMaxuEo5IEHI5s78mNQRtoFNqInwSivimwGUzfo4KYXN+ql3+G6+w3bK7g8XZ50eQTi3pxrv/1tP0ZUv2iguDxfcLLyPfikN2MbZwn3GYADlKmz8nNign3qp+XQZDDqjWIyWYAc6/JIPye7XtTn4crnx4pr74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368974; c=relaxed/simple;
	bh=7vSE4b+gpw60VpByePLlVFEBBz8IDDZdt67DV3HEzhU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=scfSAoD5VbgTITru4cd3ylGAAstw6hBvNqCHzNWb3wYMlwC/pjE3L1kc3eiNn1ePsN/WTgrhFhHR+p+0a5tSNGESEgqFd8HrYweRv+B8lgKxLGJhMPXetZbBipbxN4Y96B1PtlQlTChSNWux2aK7xymiUIZhF1uKHs4WrQvTx4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pKCQFZ7l; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-442cd12d151so31605295e9.1
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368971; x=1748973771; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5V3B2RYLa1fEECDPnlrHtu9P8hNPSXvchqgDN4GcNys=;
        b=pKCQFZ7lKWz4Lcv1PtyaaVWVdFypu7320IHrcat0UWXw0wRbDv1Zfzf8LnZD0CyBty
         EnP8+9y8PA8SgPIRsVmtQe/TDpnJP4sk3pw/VGk2mkBKRawU0e+DnctCUpTmxIQy2ucQ
         b88c3+LYef6DV/h7c5Iu9xWJSxxWEpKgFGj0gBIoXzCyZeKUtK/3T3q6PbQxeG5rAol9
         3FQ6GabzDTuL9EBthVgYa9KAH9U90i+3B/WSXkJJML0dt5nWHXfNxHv/aRAD5Y8JBhG4
         7lfR8294/nvMhnRvB2/r0Ycgri5RVMZ0/FkzbOghVeEH/9ud1LVa8jpTEXqUVu53Jnxs
         IiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368971; x=1748973771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5V3B2RYLa1fEECDPnlrHtu9P8hNPSXvchqgDN4GcNys=;
        b=ecSaVCT1UydGbBEGDvE2kcE0HtnkftFXRcROxKPBaQ89E8yLyj+txm3T7pcI0C2Oxy
         w+7KSeW1QyT6YdiT0eUAMJrnPu6vnZrRVUZtVVl7VgY4H54jzLaxNVdZc5dmIm8DpmCN
         uxorNSodxde2oTdabc/KkKliD3U/mD4i3wST7H2XMYXAA6zY+fU0q6dbSIJBGyOnojFj
         fBxJhwdmdDWfAf+LKz13jiWFfHt+h7EBcArOQm6CYb/ZRk/Kt1sEV/70FVD9/ofBQJLw
         lOnfVlG/nDOCCnEsnswSQcyP7wiir0RmJWrD4kYkBILjGIRAJ2QZ7nNLqxpJg1ewPQk/
         /2qg==
X-Gm-Message-State: AOJu0Yyl2hn+Tv8/RK6fl3x3a/PvTpIX+0ktfrrwGVDXPLkG5VsfxsC/
	9DqaRgEHFaV3+rDnYcpi0KqKH9nw6vrD5Iszsz/Ok8eqQ2M2sbBtvUSqfKp/D6XMMlsqM8qeCha
	83blPnKkPeJWYu4c0uFBy8QHlq/bBUPWfz0XFoqW6MpMVQxYjmXOXTcHBHRRlRd+GaS0yoTsXZq
	sw+L76dgPcVMQpeYOJdJoyWJUMIdE=
X-Google-Smtp-Source: AGHT+IFdZHX/lQZqCoT+8qts9/5CdbMfeZRpKrH709gkJkldDvm+LOhfmpHq4s3xD2Py1rZ0kVm6aRg0KQ==
X-Received: from wmbem23.prod.google.com ([2002:a05:600c:8217:b0:442:e19a:2ac9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3d19:b0:43d:fa59:af98
 with SMTP id 5b1f17b1804b1-44c937d138dmr123262715e9.33.1748368970523; Tue, 27
 May 2025 11:02:50 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:31 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-3-tabba@google.com>
Subject: [PATCH v10 02/16] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
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
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The option KVM_GENERIC_PRIVATE_MEM enables populating a GPA range with
guest data. Rename it to KVM_GENERIC_GMEM_POPULATE to make its purpose
clearer.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
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
2.49.0.1164.gab81da1b16-goog


