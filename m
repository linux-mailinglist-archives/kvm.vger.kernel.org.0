Return-Path: <kvm+bounces-23143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 665A294648E
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:45:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9773F1C21656
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F863EA98;
	Fri,  2 Aug 2024 20:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bieb6yJb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7726D1B9
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631518; cv=none; b=B39P95/pwhO0GqLFd8//hTb0EmQcuAN3O2xZWOURP96SQ8yBNWdtljEe3Yqp5rOab0B/f2SIatq4YXQh5QNQv1HsPxW1VlTI3OGB7Wei4XFm812BAfW4gDr9ZpSJ115qv6BtgC5/BZrSSuxAQ/u7zw+TwUGyRWHy4I1KOZldxXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631518; c=relaxed/simple;
	bh=lVGVJTk9jnqyafCwVBq3gYkwAdJxTfIQ8N912VK7nC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sYShchFrRN0jsvzJRXFUMccHNDmbhBYOSpMCk9HD+BLs1y/gEmqfuZpkkC49HJPCuClCH8AUC265KvpVngun1Dtbnqrv/7QKcepLjR28zaNXtgNrityxcNN8OQBDBHst0YIJ9VtPz+vbiM0Kd2ovmQ4/d1Z23aEwG7Uq9Xdb010=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bieb6yJb; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bcd04741fso4707189276.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631516; x=1723236316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Igz2ZJyNNATN1XeEvBd17znAw6/Dz7d0KpIxkojeTYo=;
        b=bieb6yJboFbRZuMdvr6Jz5h7L1lBfHS3nGXl849mEGTeNeQX/kWdBxxSpjddTBiXSB
         +GxxiuCvNmHws9YTG6fHBoWHf5ULZH8TatpROqu5D5nC0WCT99I+gkXPUUzk7+qDqbAW
         u/OtGLFvp5VtzIxWxRxDerPcWu11TlRuNbNgale1awhdN5GMCVsjJXXFfaShj/c24Bf0
         JD9Xy1psa5hrF3teiIwr86hWF068H4jsqCRoxTqxBlfL2j7gv5l65rpIh8HBFpWuO+So
         KEYlEqLHXS1xD0iit+yrUEB9gigeiUKSKHZqIj01sb0/KTRkng7GOMhc4OQH9p01SW2Z
         HmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631516; x=1723236316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Igz2ZJyNNATN1XeEvBd17znAw6/Dz7d0KpIxkojeTYo=;
        b=Q0ji+3fdftEpB1hFApF3TpPt17VkN9DGJoMx5DtUomqkRynpgDGSZs7V/y22H0DQi5
         ye3R0CXdUktVhjYEW5IGIa2aKQxruEnvwBZTeQD2gHnel7DgaVpy6VOaFFbbUwGa0KiE
         VJ3nxGtHlvOjSrNYwctTIQQcMprrKLMx43MB3+eAeZ7LVqTIohBulJwEKux+wa6CWfL9
         BaabIh1pxB43cHnBLhHTTyeKxFQ4HA+t/1KY8pndMu3bKyhT6AckQJU7bC8uDYeC6fjj
         wL/M0gNvVVgZJQ0txdkmXMgaJZZhrRBxkM81oMHmax+GrpfHFTr7iV6fJCqWj4qE3nIv
         8dNw==
X-Gm-Message-State: AOJu0YwJFVO/kjcU8nuM9cr12QO76sXAd0QqLI1clj8OY+kFAyK9Z+ky
	+lCC0DVs6W70DMBCHnt5PgEEnROIkwL4PrLLeHVSfHMVker0YEHzJySCeBuilWE0PapuV9Gfsbs
	g6g==
X-Google-Smtp-Source: AGHT+IGAc96EWJLQ/4sJpltgqTG6OOrlRceDtu62MpXUFhsp63bSYtrY6Grjcmv8UziSYaCDnsvGdEWEGCI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1610:b0:e0b:6ba4:7d60 with SMTP id
 3f1490d57ef6-e0bde21c34dmr206063276.4.1722631516483; Fri, 02 Aug 2024
 13:45:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:45:09 -0700
In-Reply-To: <20240802204511.352017-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802204511.352017-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802204511.352017-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: SVM: Add a helper to convert a SME-aware PA back to
 a struct page
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add __sme_pa_to_page() to pair with __sme_page_pa() and use it to replace
open coded equivalents, including for "iopm_base", which previously
avoided having to do __sme_clr() by storing the raw PA in the global
variable.

Opportunistically convert __sme_page_pa() to a helper to provide type
safety.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  9 ++++-----
 arch/x86/kvm/svm/svm.h | 16 +++++++++++++++-
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..2c44261fda70 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1124,8 +1124,7 @@ static void svm_hardware_unsetup(void)
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
 
-	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT),
-	get_order(IOPM_SIZE));
+	__free_pages(__sme_pa_to_page(iopm_base), get_order(IOPM_SIZE));
 	iopm_base = 0;
 }
 
@@ -1301,7 +1300,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (!kvm_hlt_in_guest(vcpu->kvm))
 		svm_set_intercept(svm, INTERCEPT_HLT);
 
-	control->iopm_base_pa = __sme_set(iopm_base);
+	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __sme_set(__pa(svm->msrpm));
 	control->int_ctl = V_INTR_MASKING_MASK;
 
@@ -1503,7 +1502,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 
 	sev_free_vcpu(vcpu);
 
-	__free_page(pfn_to_page(__sme_clr(svm->vmcb01.pa) >> PAGE_SHIFT));
+	__free_page(__sme_pa_to_page(svm->vmcb01.pa));
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
@@ -5250,7 +5249,7 @@ static __init int svm_hardware_setup(void)
 
 	iopm_va = page_address(iopm_pages);
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
-	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
+	iopm_base = __sme_page_pa(iopm_pages);
 
 	init_msrpm_offsets();
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 76107c7d0595..2b095acdb97f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -25,7 +25,21 @@
 #include "cpuid.h"
 #include "kvm_cache_regs.h"
 
-#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
+/*
+ * Helpers to convert to/from physical addresses for pages whose address is
+ * consumed directly by hardware.  Even though it's a physical address, SVM
+ * often restricts the address to the natural width, hence 'unsigned long'
+ * instead of 'hpa_t'.
+ */
+static inline unsigned long __sme_page_pa(struct page *page)
+{
+	return __sme_set(page_to_pfn(page) << PAGE_SHIFT);
+}
+
+static inline struct page *__sme_pa_to_page(unsigned long pa)
+{
+	return pfn_to_page(__sme_clr(pa) >> PAGE_SHIFT);
+}
 
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
-- 
2.46.0.rc2.264.g509ed76dc8-goog


