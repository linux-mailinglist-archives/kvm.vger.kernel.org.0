Return-Path: <kvm+bounces-22366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC0F93DB40
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF9EB1C2327A
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D960155A5D;
	Fri, 26 Jul 2024 23:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fdnDV+1H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4815534E
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037966; cv=none; b=jgJwwjUehA3+dRSJ6Dz7qa1EekGL5tAQ1D9sNz7j8uNVwodtkS3qbZRk2KAY2BZoNK990XKgBzy8pqxk702RQrmJwpRg5GMiHkzejQXtnRq8iYaFAC7Xsv7JZzI6Ny3W79B5lfaF9DSOjL9bm70tvfnIk+tCAdQ8XT/CS0eWY4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037966; c=relaxed/simple;
	bh=As5a6sCjA0bn2QxKfat0y/Alc6god6QcgzHJ1XC3GL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZA5y+4LSZ0MzgDzCGwXS2DaBMlyPt5vaB6bAGvajrc+bpW/E8/UTZra5l+qemM4NRBQ6cKuZwKZtGR45f/6kAWaxk4wZZCBTY4ZSAJZM4cf+bsN0HkRsE0bMgrHjRF3/zT1jFxwbGl5O5NAs+VNZeRmXgr0qZ/7zZ9AkZTvrDq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fdnDV+1H; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7278c31e2acso1432200a12.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037964; x=1722642764; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oJ4Czs6Wm6GL3WD+/Q+iqutVJUfrJPNLt1yka1W8eMI=;
        b=fdnDV+1HxF+ZDEUfAaSQMe5gqybfshxy3wBNaaMJWShcud2X86nWhsHuANclv+qmQn
         BGm0UUcRb76OzoQdn01lBBv4TiijJWIiqPVrKXfvtfsjvSqomDufivBtvKUguwNIBwXq
         6o2etMgaRSSTMK/xqJaraOPiJ52u0VYJRr2OPL2m6kTnLhv82tKzwibcNMVA0QUvADEf
         v3vXCuSG+FKX2fNcf8ztluRbcyRbK3qOnzYFUpoRrpyOUvFnOpmSrxCckvICl3CGzQQW
         znGWzGgHXbEoYjW21xGipMy9d6R63P3fN+BYxB8QUzd/cvBDtkWlpcZaTvgphoYj2hdR
         hZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037964; x=1722642764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJ4Czs6Wm6GL3WD+/Q+iqutVJUfrJPNLt1yka1W8eMI=;
        b=VbEF0FdGRAI1FVmvy+3z+5HNGr9dXEpddI3/V3rnkXI31hIEi5e2t1MHzg0YM0YTuG
         wA2YhE+maa8cKndKPC3YBgCRmFxm9oVJVxaXu/b6PeWfONhWCPFjguPEXTa4Aw4M7pGS
         070hRWOgPLFJpcpQPYFnWp6dKUw2QmE7W/vNvt9UlNPscMMnvjrwkTQ6aNmWvqJe+3SL
         z8VOP06JTwgr7y+M9GCNHYtyELAB4KNBO4xxPdoKsLg1kJ6kJPzA1ZOkEJzRIqULFBrv
         GF4RGIFh9QLfQPQW5gjVI+mls5gyJd8TS70wF10unDJgUk9lQWmW811RnH2DryRgbKAS
         8QYQ==
X-Gm-Message-State: AOJu0Yxs42ujsJKmjmuH2r+FeDFDlHyUDxvhwsWf9vFdr0kx50ydreTa
	XXXFNBQW0Iigw2rH0wLdfenGWz95f3oH/CkJc775VO/boCpO/LNt2860i9yFUPp/7m8BAp6lMs5
	Tiw==
X-Google-Smtp-Source: AGHT+IE4QseE8FQyDppGpUcmrzEgygvCajM4BiXmkGQ8bCrs1hHMNuBsnO5u2Op4CzG6c9mnubgf1na2VnA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f683:b0:1fc:27be:42dd with SMTP id
 d9443c01a7336-1ff0479bbb4mr799825ad.1.1722037964087; Fri, 26 Jul 2024
 16:52:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:12 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-4-seanjc@google.com>
Subject: [PATCH v12 03/84] KVM: Drop KVM_ERR_PTR_BAD_PAGE and instead return
 NULL to indicate an error
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Remove KVM_ERR_PTR_BAD_PAGE and instead return NULL, as "bad page" is just
a leftover bit of weirdness from days of old when KVM stuffed a "bad" page
into the guest instead of actually handling missing pages.  See commit
cea7bb21280e ("KVM: MMU: Make gfn_to_page() always safe").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c          |  2 +-
 arch/powerpc/kvm/book3s_xive_native.c |  2 +-
 arch/s390/kvm/vsie.c                  |  2 +-
 arch/x86/kvm/lapic.c                  |  2 +-
 include/linux/kvm_host.h              |  7 -------
 virt/kvm/kvm_main.c                   | 15 ++++++---------
 6 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index a7d7137ea0c8..1bdcd4ee4813 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -645,7 +645,7 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 	int i;
 
 	hpage = gfn_to_page(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
-	if (is_error_page(hpage))
+	if (!hpage)
 		return;
 
 	hpage_offset = pte->raddr & ~PAGE_MASK;
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 6e2ebbd8aaac..d9bf1bc3ff61 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -654,7 +654,7 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 	}
 
 	page = gfn_to_page(kvm, gfn);
-	if (is_error_page(page)) {
+	if (!page) {
 		srcu_read_unlock(&kvm->srcu, srcu_idx);
 		pr_err("Couldn't get queue page %llx!\n", kvm_eq.qaddr);
 		return -EINVAL;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 54deafd0d698..566697ee37eb 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -661,7 +661,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
 	struct page *page;
 
 	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
-	if (is_error_page(page))
+	if (!page)
 		return -EINVAL;
 	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
 	return 0;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a7172ba59ad2..6d65b36fac29 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2629,7 +2629,7 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 	}
 
 	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (is_error_page(page)) {
+	if (!page) {
 		ret = -EFAULT;
 		goto out;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 689e8be873a7..3d9617d1de41 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -153,13 +153,6 @@ static inline bool kvm_is_error_gpa(gpa_t gpa)
 	return gpa == INVALID_GPA;
 }
 
-#define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
-
-static inline bool is_error_page(struct page *page)
-{
-	return IS_ERR(page);
-}
-
 #define KVM_REQUEST_MASK           GENMASK(7,0)
 #define KVM_REQUEST_NO_WAKEUP      BIT(8)
 #define KVM_REQUEST_WAIT           BIT(9)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..fd8c212b8de7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3085,19 +3085,14 @@ EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
  */
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	struct page *page;
 	kvm_pfn_t pfn;
 
 	pfn = gfn_to_pfn(kvm, gfn);
 
 	if (is_error_noslot_pfn(pfn))
-		return KVM_ERR_PTR_BAD_PAGE;
+		return NULL;
 
-	page = kvm_pfn_to_refcounted_page(pfn);
-	if (!page)
-		return KVM_ERR_PTR_BAD_PAGE;
-
-	return page;
+	return kvm_pfn_to_refcounted_page(pfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
@@ -3191,7 +3186,8 @@ static void kvm_set_page_accessed(struct page *page)
 
 void kvm_release_page_clean(struct page *page)
 {
-	WARN_ON(is_error_page(page));
+	if (WARN_ON(!page))
+		return;
 
 	kvm_set_page_accessed(page);
 	put_page(page);
@@ -3215,7 +3211,8 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 
 void kvm_release_page_dirty(struct page *page)
 {
-	WARN_ON(is_error_page(page));
+	if (WARN_ON(!page))
+		return;
 
 	kvm_set_page_dirty(page);
 	kvm_release_page_clean(page);
-- 
2.46.0.rc1.232.g9752f9e123-goog


