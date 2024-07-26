Return-Path: <kvm+bounces-22423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B1D93DC12
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C1991C22FAF
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594F61891B5;
	Fri, 26 Jul 2024 23:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ALmb9nPO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB8E188CB6
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038085; cv=none; b=JO5rBvJKj7jhpXmHXk4CRHaivGkepg4HpvO3ty/YKYoIRDdopuMfBqgWKkELuYlVLTbml4z07+3bxwECvzJxd41NSTIBZnMg2ob5LypGy+KsinCADm+mK2/MxtS5TjDsn8nGmUs2kz2c62fz6JS3YE0Ds/alE2Ljt9TXC8hQrLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038085; c=relaxed/simple;
	bh=cf98YpKAzSnKSydcfMP082/xfk70ScQmPGu4ud3+tiY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IRY+OYt311lZvco0HwxOfPWC2nxSQrZKp7jX4fe5b1oo4F8oGibRK+TTcZb3hseXwoZw8wTdX2+r0wqpPkETDMbajZMhRcofSyMe5hGdAkC26t6xxMH14mv+/tsWR/ED2856e4bQfujsRNVipoXBRhCJ+/FeNTU7sGNtRDCRH6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ALmb9nPO; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b28f23a28so413563276.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038083; x=1722642883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6xYXr8Us14FXXKODtWRB0Ht9lxWZb28t4tAXkZ5fXOk=;
        b=ALmb9nPOUiTHX1TXXUEwpqY73/hhF5D/EoEuFKxkFTPMGGg9hfvz2qIvYf51M5eHUM
         igGXZINtRmYjFfu2usOtT/NVjWUkvPPz+KnhF/+CgFTPvFSuwSThEbzZpWo8TMTQt7S0
         +x46Hlghh2nw+wRcjEIelHQuy/RLICFyHFpfZOk+uce9spm7pboigtfnSymbYzRukPi8
         4pxmuJsPXdxS35QU7YYFm7zDs0JU7UaiboBy9dpfgNXsza0eYKslxyWAbGXFLohxyz6P
         4Q/vCYm3fHKJtUI7QwBOzsm6QS+Gh2nDVBdIHgkWHfXAz9hIQ9o3UiJiJleysPYjzQIt
         axLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038083; x=1722642883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xYXr8Us14FXXKODtWRB0Ht9lxWZb28t4tAXkZ5fXOk=;
        b=taDwgm/XcA1XzHmurLg9iqjoDBjVjvB8A23OeZbqQY1zcHPObt9HeTtU4dg+4drBJ8
         hjLYMsnemccc99ManW44F1rNSCx13IQYtvBwHWLup7IYM/ctifJAqWmggaJE9ruV4EW6
         hCOPWKdf00J/9jKNGDhdc3JlNOL1L79PaaMwV8GCUFHrkf98k0E8kqQ6Hw7AFmSHLLHe
         hqVMesxVTjb1TgfFdJJFQ0zxvfb1LRdUfM8MrNyA2qRH+fj9U2Tm+eVAVNI6x4EnMCzb
         /nS8IiC2IRvInZI1DsB6RdUcPm3qpDe0dA+VISpd0A7lINmlzok7QolZqMA5RK6/Wnum
         eiPA==
X-Gm-Message-State: AOJu0YyAwIRSLcNmvw2VcZBkmrtIyp6iZ6XWqzr8lB/S9+RXKzAkeNXb
	rXRQ8vbP4894x7kPN/nVfQeg/+8JeicfHVuQMNEgVM8S+uVyPWuYIjV1MLBWKeleFl+Bjn+i1Ad
	mxQ==
X-Google-Smtp-Source: AGHT+IE8wacjAGm1xSlUK/1K8X0GxeW+L1fXTQ/Y1AQI/5HhDGzzQTYAcJk3V2f1As7zQmLQNuyAyAYHMio=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8c02:0:b0:e05:f1ad:a139 with SMTP id
 3f1490d57ef6-e0b545c6203mr2068276.11.1722038082801; Fri, 26 Jul 2024 16:54:42
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:09 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-61-seanjc@google.com>
Subject: [PATCH v12 60/84] KVM: PPC: Use __kvm_faultin_pfn() to handle page
 faults on Book3s Radix
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

Replace Book3s Radix's homebrewed (read: copy+pasted) fault-in logic with
__kvm_faultin_pfn(), which functionally does pretty much the exact same
thing.

Note, when the code was written, KVM indeed didn't do fast GUP without
"!atomic && !async", but that has long since changed (KVM tries fast GUP
for all writable mappings).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 29 +++++---------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 8304b6f8fe45..14891d0a3b73 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -829,40 +829,21 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 	unsigned long mmu_seq;
 	unsigned long hva, gfn = gpa >> PAGE_SHIFT;
 	bool upgrade_write = false;
-	bool *upgrade_p = &upgrade_write;
 	pte_t pte, *ptep;
 	unsigned int shift, level;
 	int ret;
 	bool large_enable;
+	kvm_pfn_t pfn;
 
 	/* used to check for invalidations in progress */
 	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	/*
-	 * Do a fast check first, since __gfn_to_pfn_memslot doesn't
-	 * do it with !atomic && !async, which is how we call it.
-	 * We always ask for write permission since the common case
-	 * is that the page is writable.
-	 */
 	hva = gfn_to_hva_memslot(memslot, gfn);
-	if (!kvm_ro && get_user_page_fast_only(hva, FOLL_WRITE, &page)) {
-		upgrade_write = true;
-	} else {
-		unsigned long pfn;
-
-		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, upgrade_p);
-		if (is_error_noslot_pfn(pfn))
-			return -EFAULT;
-		page = NULL;
-		if (pfn_valid(pfn)) {
-			page = pfn_to_page(pfn);
-			if (PageReserved(page))
-				page = NULL;
-		}
-	}
+	pfn = __kvm_faultin_pfn(memslot, gfn, writing ? FOLL_WRITE : 0,
+				&upgrade_write, &page);
+	if (is_error_noslot_pfn(pfn))
+		return -EFAULT;
 
 	/*
 	 * Read the PTE from the process' radix tree and use that
-- 
2.46.0.rc1.232.g9752f9e123-goog


