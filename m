Return-Path: <kvm+bounces-22374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D85F093DB5F
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07E7A1C20856
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC3115EFDA;
	Fri, 26 Jul 2024 23:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xwcgZZWz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E81598EE
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037982; cv=none; b=W407T1pJ1d27pQwvwhhZGE3OfhKAsHi8qBh0/9Lx9IpP6H6tzQrd9Umm+xBFtO52Hjzirq/ZpSXhh1aJGzzycXcpnH4BtXwaij187NU7KaqbLBqpI4sFNyLWOjjk27XsBQAA8QuSqfpa3DKOOLgBfp3vDLgu/0+M3tOJ2KCAwUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037982; c=relaxed/simple;
	bh=66rQYSeeqJfCAKMkX7WI4GHJ+JHcgyOho5Y4s7cGJ3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GlmgcP6suKBMzjptp0Bjm2vJeB9Xty1OxjxRKJ4yfeBajXeoGIbwlySXzzjaHZmcTMOSN/3DtS4Ug2f9hoYH5NqQjUetFE3htJGvyMmZX0Rbit+Oa818NCxUsAmx+1iqzCRNmZdYNDEKlrZiKMOjE8fszBRpbJ/Qk7pKdD0ouo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xwcgZZWz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc5e1ab396so11764055ad.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037980; x=1722642780; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OCfqpOOOZn7LpwpHWWHUZjndC9uE6mObDYxnDRBBpAY=;
        b=xwcgZZWzaAnbOeWQO2etkn51kzgLxaOg55beKjXSpvYvfM5MIOscZc7VNHVmnhZwSB
         VTROrwqNTOmAtWB2TqyS+ohyiigPxQ8NEKWZOR3zl5AzQe5P2GW07NFNW62U+8UyRG+R
         3eNVWgKTx2JlLuEkVErZd/JsFiV/AYVLPE/WTu0g5XRzBBPrRw7FRifzDJ3rabvjDb6G
         PrRH60zOUCUAgX8G21vxKbjG97s619HN24QJxFh94YdhaSOlt8sIi0ROYFCUPmvaNEz3
         MSFiFUL+VQ3/sWbggtCafT3NeuJPRMjLcTtmp+zOR6fxE3im4tl6KXQYEtwEPhLtdnvx
         oC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037980; x=1722642780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OCfqpOOOZn7LpwpHWWHUZjndC9uE6mObDYxnDRBBpAY=;
        b=SOyEJmNTdhFQqQZXkZJ6ZXxosDyEcpx17yI7EQgxdsT2nRGFGOGSpLvQkQvPAmWuCC
         nV4Ejsr5aEZeookcQ6w9wmnj5hmTpM1WDUxNAplQuoF9doaeXhCpGsx10M/Zb38t23Ot
         dUjcUplH5OD4hpNKu9Sz4A7D3rqbZpOFhr8vauoFE2GqwsEkWbWDTzgBSV5rSQCrM6aw
         rGF/KUzSqNfnpjr13f2xaCptsv0dXm5/1v7RxQsgU0qwpWKuYijUYV/YY/taIdVXMF57
         HAZ+bveKnJPDAwwPVPN9JOPUpFKq4Pu9au6EEKT/1HTpWPDvNBDYplE7fRbuPIpoJTHZ
         3isQ==
X-Gm-Message-State: AOJu0YyyiB3MgwA0tFDrvldjvYQciEsi3vUZLYFu0k5AiFs5rluWFpyg
	0Lzbil3SGgqDyzgqEWhgNrawzhAZmSUsRo220swC9eUKBxqKjvEUKUCLVHCt/QOhbVCtlAjusvR
	mPg==
X-Google-Smtp-Source: AGHT+IGEij7x5iOOrUuL0BYhT5Dm9YFKfO4AZ5nK1acS0T3wJ2KiuANG5aiKSF+tpPt4GoCINPA3jjFDrnM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2341:b0:1fd:d740:b1e5 with SMTP id
 d9443c01a7336-1ff04850898mr447825ad.6.1722037979718; Fri, 26 Jul 2024
 16:52:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:20 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-12-seanjc@google.com>
Subject: [PATCH v12 11/84] KVM: Rename gfn_to_page_many_atomic() to kvm_prefetch_pages()
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

Rename gfn_to_page_many_atomic() to kvm_prefetch_pages() to try and
communicate its true purpose, as the "atomic" aspect is essentially a
side effect of the fact that x86 uses the API while holding mmu_lock.
E.g. even if mmu_lock weren't held, KVM wouldn't want to fault-in pages,
as the goal is to opportunistically grab surrounding pages that have
already been accessed and/or dirtied by the host, and to do so quickly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 include/linux/kvm_host.h       | 4 ++--
 virt/kvm/kvm_main.c            | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b7642f1f993f..c1914f02c5e1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2912,7 +2912,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	if (!slot)
 		return -1;
 
-	ret = gfn_to_page_many_atomic(slot, gfn, pages, end - start);
+	ret = kvm_prefetch_pages(slot, gfn, pages, end - start);
 	if (ret <= 0)
 		return -1;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 6b215a932158..bc801d454f41 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -549,7 +549,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!slot)
 		return false;
 
-	if (gfn_to_page_many_atomic(slot, gfn, &page, 1) != 1)
+	if (kvm_prefetch_pages(slot, gfn, &page, 1) != 1)
 		return false;
 
 	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c5d39a337aa3..79fed9fea638 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1192,8 +1192,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
 
-int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			    struct page **pages, int nr_pages);
+int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+		       struct page **pages, int nr_pages);
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 656e931ac39e..803299778cf8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3060,8 +3060,8 @@ kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
 
-int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			    struct page **pages, int nr_pages)
+int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+		       struct page **pages, int nr_pages)
 {
 	unsigned long addr;
 	gfn_t entry = 0;
@@ -3075,7 +3075,7 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 
 	return get_user_pages_fast_only(addr, nr_pages, FOLL_WRITE, pages);
 }
-EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
+EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
 
 /*
  * Do not use this helper unless you are absolutely certain the gfn _must_ be
-- 
2.46.0.rc1.232.g9752f9e123-goog


