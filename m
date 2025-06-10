Return-Path: <kvm+bounces-48914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3394AD4667
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 843423A80F4
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0792D2FC8;
	Tue, 10 Jun 2025 22:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W3ymdE3r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467C22D1038
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596313; cv=none; b=FXiUemyXUSSyQEf8mogqKHCnvwOQPn//Pfwu4V8RYoWt1+3ACM8zT2DSILDtRgDk6UPAwAUmVw6NTqrxesqXFL3j+fypsB/jSiXazxRjZs4Nrpgcwb+V6LPhGkAicOK+RCC9afau2WkdwgukWImLm7HOnkv3Ev9UtrVugn0vmVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596313; c=relaxed/simple;
	bh=VH8WRfFFUUs5JJlTZjXJW3PCCeZLDh78G1qzdoW4OoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z23+zhtItxcYoOcN9gn4ctbrXP4AtBjbFlCcVf5NVkO5GHtgqoALfKrbT0gG88lKrK7z92fypdAXzxR11xAFqnNTgeGsy72PWUVf3b6r6q5+SlPg/o2V/vVbHJMmRDEWEHMJOMH+ioQUoLXsrPsbntCC0xGEwM86CwwvyQobPO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W3ymdE3r; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74620e98ec8so234840b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596312; x=1750201112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A6jp+MxEVwUWr2OGrLLa/UhZgsS9fBawhSOksR6+SUo=;
        b=W3ymdE3rUHwwtQmNBZETi7DM3KoU9YnjkteSoOKFM+6okzOk1vj+YKx9fwTXkYmyC+
         qZRE3w8+1pJESZwwI8OuYzvWXCs6HstBnzGFinNDUfmtydKdXoIBjRLwg006fpi+k8LO
         urhVWp1a6zUVVY4a81EhddGrzl3W2wDHxI215NvdRSx3mbX4/OEVS2tGTUMSwwVlEBVe
         /tynQa/9tAODoAy0r9Gn8hDpMfQ1HEyCMe8hMg2K+EbEzx3Pf0KKtW2x2RQ36sAG0is7
         eN9+nsNEhs/tMgtIjV7UPuQqFfnfQjvpJan74G/9A3winCZj4DaULQV+zHooGvsomCdr
         +0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596312; x=1750201112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A6jp+MxEVwUWr2OGrLLa/UhZgsS9fBawhSOksR6+SUo=;
        b=mozLPEid3VJUqtBu9vUPIRzmpesPwp33uPONNgb+7KcXswHI1sgMm5fpEmfHBKjBEe
         8jRJneZV4y1HPnsTO/35UH+WGq3fn7BeERU1PkUg7A/Miwj18cqtCH4L3aeCpoLeEOhG
         JKdyDltkyIguyo1FwHQE1y7XCOzmvynHe42NIC2LCLJe3nFEqTBS5Yqh4svs0CpqDJOs
         tdcfQxFVAmAAnEz2Kte7PkhD+IiyG5b9dX67KqrqHp1uiaYZ+GhCNbN1cT5oBqxuAMek
         IZ95bF9YKPaN3gIcd1w5zSPwN7AThB7BId9371/fvmBlv2p0jvjD4HAz9qzex3DJ+OXP
         I1kg==
X-Gm-Message-State: AOJu0YxQIDFm0IZGD2NYp8RNEI8F953HcK501Kar3sRbf1Ia8803muff
	ftsMVMcx7PSSlWfwh57VlqXmoo6bT+VJi+iLCe32K4NHC5cRdCQqToeIObJRSu3uvkeOJLmgfoa
	DmGq0eQ==
X-Google-Smtp-Source: AGHT+IHUbTWEMdxOysQIgDGJSqdbtnuSvVC/t8qT8y4a8ukS+CVQAVwHYn3Az15lUwMqTPo8MV2aPVRifBI=
X-Received: from pfax8.prod.google.com ([2002:aa7:9188:0:b0:746:fd4c:1fd0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:17a3:b0:748:6a12:1b47
 with SMTP id d2e1a72fcca58-7486d3729a9mr1291570b3a.10.1749596311602; Tue, 10
 Jun 2025 15:58:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:35 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-31-seanjc@google.com>
Subject: [PATCH v2 30/32] KVM: SVM: Add a helper to allocate and initialize
 permissions bitmaps
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to allocate and initialize an MSR or I/O permissions map, as
the logic is identical between the two map types, the only difference is
the size of the bitmap.  Opportunistically add a comment to explain why
the bitmaps are initialized with 0xff, e.g. instead of the more common
zero-initialized behavior, which is the main motivation for deduplicating
the code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 31 +++++++++++++++----------------
 arch/x86/kvm/svm/svm.h |  8 +++++++-
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc41ec70b6de..e3c49c763225 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -728,19 +728,23 @@ void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	svm->nested.force_msr_bitmap_recalc = true;
 }
 
-void *svm_vcpu_alloc_msrpm(void)
+void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)
 {
-	unsigned int order = get_order(MSRPM_SIZE);
-	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, order);
-	void *msrpm;
+	unsigned int order = get_order(size);
+	struct page *pages = alloc_pages(gfp_mask, order);
+	void *pm;
 
 	if (!pages)
 		return NULL;
 
-	msrpm = page_address(pages);
-	memset(msrpm, 0xff, PAGE_SIZE * (1 << order));
+	/*
+	 * Set all bits in the permissions map so that all MSR and I/O accesses
+	 * are intercepted by default.
+	 */
+	pm = page_address(pages);
+	memset(pm, 0xff, PAGE_SIZE * (1 << order));
 
-	return msrpm;
+	return pm;
 }
 
 static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
@@ -5325,11 +5329,8 @@ static __init void svm_set_cpu_caps(void)
 
 static __init int svm_hardware_setup(void)
 {
-	int cpu;
-	struct page *iopm_pages;
 	void *iopm_va;
-	int r;
-	unsigned int order = get_order(IOPM_SIZE);
+	int cpu, r;
 
 	/*
 	 * NX is required for shadow paging and for NPT if the NX huge pages
@@ -5410,13 +5411,11 @@ static __init int svm_hardware_setup(void)
 			pr_info("LBR virtualization supported\n");
 	}
 
-	iopm_pages = alloc_pages(GFP_KERNEL, order);
-	if (!iopm_pages)
+	iopm_va = svm_alloc_permissions_map(IOPM_SIZE, GFP_KERNEL);
+	if (!iopm_va)
 		return -ENOMEM;
 
-	iopm_va = page_address(iopm_pages);
-	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
-	iopm_base = __sme_page_pa(iopm_pages);
+	iopm_base = __sme_set(__pa(iopm_va));
 
 	/*
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 489adc2ca3f5..8d3279563261 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -667,7 +667,13 @@ BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
 /* svm.c */
 extern bool dump_invalid_vmcb;
 
-void *svm_vcpu_alloc_msrpm(void);
+void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask);
+
+static inline void *svm_vcpu_alloc_msrpm(void)
+{
+	return svm_alloc_permissions_map(MSRPM_SIZE, GFP_KERNEL_ACCOUNT);
+}
+
 void svm_vcpu_free_msrpm(void *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_enable_lbrv(struct kvm_vcpu *vcpu);
-- 
2.50.0.rc0.642.g800a2b2222-goog


