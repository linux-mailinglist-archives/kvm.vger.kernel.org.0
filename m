Return-Path: <kvm+bounces-22414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F28693DBF1
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91D711C20DC2
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120CF185633;
	Fri, 26 Jul 2024 23:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F69ABjzb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8239715665C
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038065; cv=none; b=Uuu3DMNBFFqTNcfZSoNUW53kstq9Yg1HVhilh5dhhN2i66REhydhOAM9Vu9PZJVCQc0hYi9NBcoZZYjYQx5ne2xvwiSG8SN937XAVpyQsrO3Xqg3xoXqqYJANWbMyNwU7oKC90M/6QFYLBEv9feU5domK71jrmI+6IjcScht2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038065; c=relaxed/simple;
	bh=VbnqqafRlYMVLvo8/KpvTNYaOUVhm0RY4zV5HGgCgQE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KUzasNOEvDs00K7CopbuPlJaqZGIKNDHHKzv1zJPp3JB3q8UA5muRZ9G4p9e5IENpMqhGFl8PRoUBlzGx6AAJ/tj9DmbR6I4ZWWvBcew2pWnb/MWYfjovrnRUq/GHbeMMfo2uF7jWFma7HCgYw1q9+RE5Gj/9IGcpR1bjDRayxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F69ABjzb; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-668e964ffd9so6369447b3.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038062; x=1722642862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cHTm12hU98ihrn/4YhoQtTNxFr6qD1GrOX0sqy5dmrg=;
        b=F69ABjzbLXFZ/ejnJdvIloSN3rsH/NEOPtgkPHhfyYn0YVTiqn7c1Yg8yhxjN3i/cx
         XNswgWuSZlajr6wW5FkEOEJHFQFRTcD0MAqFFartwEF9/JV5fPxXBAj9mCf26Ur7nqxc
         UtMHVYIHS+xELcBIJDCET7wtcppyGhkZWSXOMEeCzbR/kzY/PB+jZBM47cZDgaYcYVu5
         G+GR5+xpvGBHtV6/GsY+tRtCFr538d3QH0xaou6GxzvB/9CZE9RP0tczxRyQotEW8KDH
         39rHL5nO+qgYyQ4kywIMuRE0gXDQC+5K9FSQRtdzczWzF6PElTYhwdT8f5iMrZB9+CCD
         jHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038062; x=1722642862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cHTm12hU98ihrn/4YhoQtTNxFr6qD1GrOX0sqy5dmrg=;
        b=D7Vnq1cFFKAd9SobMGZ6uckScR0cdyhqqeObHEPd9CsevXtWjs5tajttBUo9pH+r/u
         Ugabo7IMj575DtbeEnPqp3E18mTRp/RVpCwH0hv6DPu1BtzxdsBcdRPk1Ttu2m8Flu9W
         +Y5TsbSe+MDRXwCyBW4BW09aZhORh413pYsV0/BayaSh1kjaoDmWuOMFDdTdLLUkaae1
         Ix7Lo5d72EryNV3J3pi53fzp+7p1GZlesTSLQwAfyOd+zVtPhC7TtJR15SoXrrv3mpC4
         B2RChIMXLqZvdJRvlJcEt5W5l9jhS+m7EqvVlZojUeEYjm/R1mJuTK1iIXnt96lHV0OA
         yljg==
X-Gm-Message-State: AOJu0Yz2D/iCA/bJ+RbgSAaxCq6wx0auk9b2nivyxf01AuJvyLm2rJZM
	bKR2E1whZB0ilfGLJlr8DJcyWT/BCJBdfCzcIA2TpN5XExQqIAlDp7xaV9aQkgi4O+9aaEi9jTM
	nXw==
X-Google-Smtp-Source: AGHT+IE591qeJqHACb7CkRANjpP2e5907DfMapi1wU/6IAMP+NJSB5aPgL5hiS9fj7k9JDiJNu7gQfM60rI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1005:b0:e0b:f93:fe8c with SMTP id
 3f1490d57ef6-e0b5427fa67mr79886276.0.1722038062601; Fri, 26 Jul 2024 16:54:22
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:00 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-52-seanjc@google.com>
Subject: [PATCH v12 51/84] KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()
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

Mark the underlying page as dirty in kvmppc_e500_ref_setup()'s sole
caller, kvmppc_e500_shadow_map(), which will allow converting e500 to
__kvm_faultin_pfn() + kvm_release_faultin_page() without having to do
a weird dance between ref_setup() and shadow_map().

Opportunistically drop the redundant kvm_set_pfn_accessed(), as
shadow_map() puts the page via kvm_release_pfn_clean().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index c664fdec75b1..5c2adfd19e12 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -242,7 +242,7 @@ static inline int tlbe_is_writable(struct kvm_book3e_206_tlb_entry *tlbe)
 	return tlbe->mas7_3 & (MAS3_SW|MAS3_UW);
 }
 
-static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
+static inline bool kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 					 struct kvm_book3e_206_tlb_entry *gtlbe,
 					 kvm_pfn_t pfn, unsigned int wimg)
 {
@@ -252,11 +252,7 @@ static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 	/* Use guest supplied MAS2_G and MAS2_E */
 	ref->flags |= (gtlbe->mas2 & MAS2_ATTRIB_MASK) | wimg;
 
-	/* Mark the page accessed */
-	kvm_set_pfn_accessed(pfn);
-
-	if (tlbe_is_writable(gtlbe))
-		kvm_set_pfn_dirty(pfn);
+	return tlbe_is_writable(gtlbe);
 }
 
 static inline void kvmppc_e500_ref_release(struct tlbe_ref *ref)
@@ -337,6 +333,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	unsigned int wimg = 0;
 	pgd_t *pgdir;
 	unsigned long flags;
+	bool writable = false;
 
 	/* used to check for invalidations in progress */
 	mmu_seq = kvm->mmu_invalidate_seq;
@@ -490,7 +487,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			goto out;
 		}
 	}
-	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	if (writable)
+		kvm_set_pfn_dirty(pfn);
 
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
-- 
2.46.0.rc1.232.g9752f9e123-goog


