Return-Path: <kvm+bounces-22416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D5193DBF9
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACB7C1C22B60
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336E41862B4;
	Fri, 26 Jul 2024 23:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="22bCu+sQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7959185E64
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038069; cv=none; b=cUl2k1ShSn8TBI5oLvSGKLA+70S/Re+y1SKsjcn47pzO9lQ/xg4Je9SHC5jZ1Q+WkDSe8w/HuHiqZ2u0+2Xh29os02b64P7PYky0j1tGlMNF+uvFInZKfGtYleXxBoL3ZTCzEU65TKSr1eGG52L4UriLamw4x+OhsJTYwDB6CtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038069; c=relaxed/simple;
	bh=5OcQ4yMNFCHP+jiDtiAE4Jxg5Z1H9MhX9ShMIrwVrSo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h4QDkXV1D67ZnY/mm/c8WOYrK2BnfXL1RQPcWQVSRdYz3c5oBaIJcHnS0CBKQRsBTX1m62/UBFSaQZ+Cx4kordJn0fvAAg/pr8NmXYcBjWjPZf3jx3LJNTls0G3TOY7ocHopV5tEYOYT/jEu1mMpQcmJtON0jByd6N8ihkexFyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=22bCu+sQ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70e93462241so1461937b3a.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038067; x=1722642867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zSr/S7cQW+jg6+5Yur5d69GSxQ0D+3E/XB18qDPP3eA=;
        b=22bCu+sQaujahuWtEOl2dfPGGGuZEjgPzT+8vB0ggXHrmvuN/nhHQ/dI4lgdXFHsCH
         cVxqOlUPUAr/qrZcxvyCxEMkO5u9VdoFNzh5tuDoq2r5GaNxpAfDu2LMgsn5vN9CkbRw
         G1WkAE+9k7bfUaSMBgOCrG5DjzESxFAWfAOvs4hLBjrh0pWpXIor6J/lhRPfufvpM1it
         icGbTgJuhtQms1hCD6YeB0GUBBP70Z5GEcWUHqnWIS4jHURwilDSbsIPDxCJD+9l+Zv1
         H+PBTOVJ8Qxy4AxrWyA+kSARtgB20evKMrpr90SttZf6wfp6JdwaebYVKATevtgaH9JM
         C2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038067; x=1722642867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zSr/S7cQW+jg6+5Yur5d69GSxQ0D+3E/XB18qDPP3eA=;
        b=d0jVWGZJtYyhohWP03PVpKuZP5A4pZ0jS6+kDgm6FIfIi2RUB8jHOEBQwxsAfLcnVx
         jD8dp+IUjIkFDSQZt3Va1ufTXIuf80DlJw0JKjceNIEb9Db4QY8YgXz5s5HV+7sTb7vd
         6Lh6/d6Z+3gWQiVFjfZANrogH49i4kXfYbbVPkp0thglIQQlzDW2BYxLicT2AnlC/41E
         BSNAU4gd8agG51YwfDzxx9AfshkA7Yn1ei0zZHr4T8zjPorIp5vEIbYJbcPf3z9LbmV1
         b2zTMwHOs6RbVJyF+BvVrVupxqGCbFOTyPcmfGF7TIfuIrNXOWEsFMwQLhKnqC9HJWiW
         7QQA==
X-Gm-Message-State: AOJu0YwJxRC72OgRUXHhPp2WLrPIBmP8JozJnHdBVgWtIEE/a0gQilvm
	TXrKHsJPNkLvvQhfvG4tvIz/RhGcvm2K74PeEdYp+jfS3lBQZEmoZ2w0BHdDHP9dkYBWu8sLopU
	bmg==
X-Google-Smtp-Source: AGHT+IEvvOLEi17q5BnKGFU80vyNCkxL+K4ME2VW/zA0UgmW3Jn60esm+Gg/1wQhRB2++SmF9ZjJ4yJ/TXU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:238d:b0:70e:98e2:fdae with SMTP id
 d2e1a72fcca58-70ecee6db73mr19809b3a.0.1722038066705; Fri, 26 Jul 2024
 16:54:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:02 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-54-seanjc@google.com>
Subject: [PATCH v12 53/84] KVM: PPC: e500: Use __kvm_faultin_pfn() to handle
 page faults
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

Convert PPC e500 to use __kvm_faultin_pfn()+kvm_release_faultin_page(),
and continue the inexorable march towards the demise of
kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 334dd96f8081..e5a145b578a4 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -322,6 +322,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 {
 	struct kvm_memory_slot *slot;
 	unsigned long pfn = 0; /* silence GCC warning */
+	struct page *page = NULL;
 	unsigned long hva;
 	int pfnmap = 0;
 	int tsize = BOOK3E_PAGESZ_4K;
@@ -443,7 +444,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = gfn_to_pfn_memslot(slot, gfn);
+		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
@@ -488,8 +489,6 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		}
 	}
 	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
-	if (writable)
-		kvm_set_pfn_dirty(pfn);
 
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
@@ -498,8 +497,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	/* Drop refcount on page, so that mmu notifiers can clear it */
-	kvm_release_pfn_clean(pfn);
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog


