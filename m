Return-Path: <kvm+bounces-28529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7DE9990F1
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86A3A285D49
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF95207216;
	Thu, 10 Oct 2024 18:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g5hzo9jY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9712071E2
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584805; cv=none; b=O4l3GRD9EyvdDVTQygJdygDmKPVUkU8Jqkl/RHh7LqNrRvf06RhrmzHjCdvmWphr/CfpfRaftFTYJPXfnngYvkGc5/1t0Cgd06LtitIQekjJIfCWrbEDrVMEZCRk/k0VvB6pCGqk9J9g+C+jpTnBWsa2kcu/IrMUWmgnv5eIo4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584805; c=relaxed/simple;
	bh=NP4IgcbBDVq5DZEeFtyiO8CdEZFJxxnULnDPMD13pKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PPATC4KFtowOFz5A0n0CKFjXmInIZnfW1ZO7bRtqvzN7JSoWuB6RUBaKSZjjDZN/dz3UFouA2xlYIEcD1WH1isBXo6Ru6MQjzywJAzGO3CFlFpFYmQ6/eZeXKO2fgwbDgNgNq9/pnSW9c33iandvvAzgOBF7c4cO+YyNTauj8ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g5hzo9jY; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e29b4f8837so18952267b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584803; x=1729189603; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/fC7L3Fchvvuu9GyGKk9VEzuiyLOIeBtO2SWEaXDNWE=;
        b=g5hzo9jYuMsLef5elH7BXii/Rz3O5NNAzg3BaELLMkoxekYgKvv3GlwOx0MeUswR5S
         u7D79PlxCqfi2Eui27GQ/wf2PDK/FtSU9HQpxYIEp6FYcUNcZ4RxRkWKsOxypmmScggd
         bXGvbabN+3GVR3u3Z5evpvBvV7hTapUH6bSv1xuzsGrxP42UL0bRjk5kLAIDqUd2xwc1
         HxptH7WG5BO6Qq5eztg3t9rrh5agOngJ9zqfaGOzOhRlW/rHlxLQl7mVwlclH/5jU39z
         SiwFtCrrtukpmLM9KZ9QtNIJl9cGgY/kEqCKhzMSjtywjCUbz1pRhU34CDuRasgyTV4R
         S5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584803; x=1729189603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/fC7L3Fchvvuu9GyGKk9VEzuiyLOIeBtO2SWEaXDNWE=;
        b=et9MFAwz/MLNQlqE6lr2ZnupGslnicGRhNry2nRXr9GTxtkE++uOQFbWrod0T8y0mm
         HLel7OKczqgjgcqiW349d7vZWYvWtzwSUSBnchUNCjc8fNus+envY7XsIqFQMWL6PfF+
         9bQKeTCOLSLJf/8T+VyDAclrgRBoo/Lc9d+HrZxQOwoNudVAZml/P6fV1pMe9qGhmV7i
         JIIpiVmfhAswSj43UYiH4qzdl59XXEocbe+z4TUZBcQOkPNMX0B45Ujsz4PYzeo4YhXL
         5KkwBLqeRVW2B8A0EaygFGLkZ2zxyihFyPaPpYlpj9BxMtuVUnHZxcQZZrr4tPFiaurU
         B4Lg==
X-Gm-Message-State: AOJu0YwYvPS7OCXcf2cX3AEEefjiOt8DaJUECaYW29Nvj4ZYLEI1Lnzg
	JzEYtCLnmGfBZnqv3B++/N33VrxNljgSp1gRtl/r70H/6JZp2XGlMFBMm+6kDvP3gc1jL3ho7Z8
	Vsg==
X-Google-Smtp-Source: AGHT+IF0bQSeBV+k7XDKFBXYzNvC7N99ueMTlOEEH5KNk6JZHzu/00W1ndtLnT51eyBFoV94Bmz3yNyB+P4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:dd1:b0:6db:e464:addc with SMTP id
 00721157ae682-6e344ce9308mr1337b3.4.1728584803335; Thu, 10 Oct 2024 11:26:43
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:54 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-53-seanjc@google.com>
Subject: [PATCH v13 52/85] KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()
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
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
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
2.47.0.rc1.288.g06298d1525-goog


