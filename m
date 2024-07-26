Return-Path: <kvm+bounces-22437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFE093DC40
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B549285461
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDDB153838;
	Fri, 26 Jul 2024 23:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pWQsKdPE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C6418FC9E
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038114; cv=none; b=euAdX8wWWLIgGsuJ0TnEoPcSztTlcBRXEm4C7BMn4KSztqD3yaH33NVc151RbdLjfZXcORh/2FD2J6+4+iXdFTbvk3RinuzEF6VkkzK+NtFtt6rU5c9CKfb/hOvS61f4MfdJMjARP8m0JG1si9NXJ9jRSFaRn+d3XljfVmjA+v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038114; c=relaxed/simple;
	bh=O9N2pQ58zHOs8mA5SBdaAy+6THp9s1eg8+6wg1nEqWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hD3Nl065qO/gsz19B2IZOxD2tn4YUG7Se0QHj5I4JhviXLbaCsrtk95+Rj70NQ9w7UtssRwItm1yqYrefm15XmsAtxUhrF/OyCglHWgsN7KcUj7ssxHFuuH605+1MeoG+hq/KKIF+CeNGGsJCDnmrmGTeIixMWWCKDLiPLiY1N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pWQsKdPE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b2af9de57so405402276.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038112; x=1722642912; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4Hy7goaarUlwaWZyx1m4yCokRE7UoQ8eGBMKWJ4Hgr8=;
        b=pWQsKdPEjJ3K/ABVXUrqwiiZJ1hcSXiB40UXceg5KoEDcuMTyptzOrer+1tQIs58ck
         ipsRDvluKdAzfDpAStUZSD7F0k5s08cH6S+pEPYTtHcZEl+E7x/xWiLnq/3AZJU+E8Aw
         trN02GZlgbYHbNOFdoDGUWmHGgNEfn1q8IxLcKPiW94LhYP3Pcz2QH70Ez4wA1FoaLpF
         exegkvYneXnbVTnhQZszx2+IvyTBbDL5R2N3wuO9xihRpGP8rxH3mETiGqsiKexGE+P9
         nq4toqsot/CIVJrPStMAl8w08nqaqazX/R0GCV2wl8OKzzIHr4ViOPWTEpYTP0ruQ54C
         kTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038112; x=1722642912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Hy7goaarUlwaWZyx1m4yCokRE7UoQ8eGBMKWJ4Hgr8=;
        b=xVD4ggcYXaatN+ESUHgvfsqvlsk8lTjHWFABd9JwMmMce1dABUzkyM+FItq5FY4HJK
         Y2v7p42axLizntiFo6++jnIB/hQmK8zIB5g78rlTt9/b9NN9wyOf6vNm+zVPlCiesoFB
         mSAx19WXFB57EZv8IX8ysvYXIf2gqMgejiqv+Jea3k5ekAigt6Hk+fQ7I7i7te3RJSu6
         jDJsadwh8cqF4W9c+CCsbq6ND1ASQYJL1ewSQXrlz5te5XvaftKtyQCUM6aMlAlx/j6Y
         42FBd9nearqQ0HBoJUa8oMlrpy5pw9BLIN+x+HSa3XPUTHVkUqUktsnQCrI1Uitvy4Vn
         K9Yg==
X-Gm-Message-State: AOJu0YwUS1H2JvT7L/SlD4HV0tnxFNn+5VAhJav0Y9zlSTxsMKI3++C6
	/STwFo5pmeO8E6p8zEWGNiHEzcEHMPEZ0KxuDKIoz5C5zHdOpd/BFMWVHVlVq1cbDwN+ub/9bn9
	XcQ==
X-Google-Smtp-Source: AGHT+IH925MpsiY9ahug77TjXa70fcvLwqDVLsDqA/3N0vd70sZBQGqqpgNL91Lx+sGl/PSva06bFRo6+6A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b8c:b0:e03:b0b4:9456 with SMTP id
 3f1490d57ef6-e0b5454ca99mr43273276.7.1722038111873; Fri, 26 Jul 2024 16:55:11
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:23 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-75-seanjc@google.com>
Subject: [PATCH v12 74/84] KVM: Convert gfn_to_page() to use kvm_follow_pfn()
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

Convert gfn_to_page() to the new kvm_follow_pfn() internal API, which will
eventually allow removing gfn_to_pfn() and kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6dc448602751..d0f55a6ecb31 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3181,14 +3181,16 @@ EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
  */
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	kvm_pfn_t pfn;
+	struct page *refcounted_page = NULL;
+	struct kvm_follow_pfn kfp = {
+		.slot = gfn_to_memslot(kvm, gfn),
+		.gfn = gfn,
+		.flags = FOLL_WRITE,
+		.refcounted_page = &refcounted_page,
+	};
 
-	pfn = gfn_to_pfn(kvm, gfn);
-
-	if (is_error_noslot_pfn(pfn))
-		return NULL;
-
-	return kvm_pfn_to_refcounted_page(pfn);
+	(void)kvm_follow_pfn(&kfp);
+	return refcounted_page;
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


