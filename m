Return-Path: <kvm+bounces-22445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 964D093DC5B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D104AB2A92B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FAC1922F8;
	Fri, 26 Jul 2024 23:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HtSou+lL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA4E1922C7
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038130; cv=none; b=c0q0FuxMw5lqrlLkswJCWUI+O3LRfIyvT9M6A6Skfa/xh24JSEPyF+4SLlih37hZvvx7JoEcHT7tdcv+pBZ/7MgjfAIgIwJat/a2j9oA6sTapMcyfL5Wf2kdiqn6NIbbnuRlDt89gHf1eyarYNlvtQYsOs8QC9fpkVPl6jJg5KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038130; c=relaxed/simple;
	bh=emk7Z8a7fhL7Xn+sv3OLuYrPeVkEgytK3q87Mr+MFTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jrlJYBEsnPMbvXG1IvFgjbcUsr9OR8lfwcPxWrtyGSf0mVLB27SvT7vQEaWzb61pJrTxVsI0Zl2wG+OIqQQYG/Ue4HXeDzK5lWvX2FMQAKS0+6VHikCpYAwZaktKHrAuEe0Sz8xiA5gLRG4tFpG8R2SvxeIq/yGerYEraDIYNnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HtSou+lL; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d23f0a3d7so1451754b3a.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038128; x=1722642928; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Truk8wLwk4Y9wyHD0oQlYUKlIPfs2FyGYSCSiM9XszU=;
        b=HtSou+lLsw/jwGEJVmqKXKGVqeuzHUbZx694I6qm1xoKmQ6yVJk0N3/fYXSx8GRv3k
         weM8F7K2e4BSWMzqvm17oIV6eeoYX4rAdSo3mbE1ql0K9djTv0McmnQVIJlnVAL0qkpK
         65XnMW2J8y9C899x97lER0Y2zjsL6J0eQQ8Iuoz2ex4Bb+NsgPJpQLoDzTej0I/F/k6s
         Fhuimmh0p+AZlEOhvx5JYDI3+CJjTudj6MzfSH1n/1PFHO7fC2ah65Xs9UWv31Iq33wv
         4cs34PjZ82JBe5nz2wocTsDT4rGQp5t3ySCOkk+AiykKCskG+yT4Q8F1dtD2k1CjLo2u
         ayJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038128; x=1722642928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Truk8wLwk4Y9wyHD0oQlYUKlIPfs2FyGYSCSiM9XszU=;
        b=j8xsNAr8wUB93YUVszq22umvC4H2Itk456EJXYTwSVqi3/IV537US4ttmQa35Lnc7L
         9uMWGgTH3JM4aYrgOhwUa5tjLYBmr17qjBN2gGgXgeKE6hZnr1v09aFkIK8U6j+gjst9
         /WCSxC32GiYeFT1GHPYwStYcIsxBSfY6C6w5MxewylUzbVo/UY7yhs1jl8mdgbgbaGLs
         D8ALAzI1zrWW4+LExIoXeX626Go2iABe9GWgrCMm0Z6AZ79sGbyBHN3swoWt65tNz7rd
         eeRihmyVAwWmC8/16BAKVK2nSDV3WMQ/e0iOusqGT49dpYcJOcXOz6rgnSWO0qARRUiL
         clJQ==
X-Gm-Message-State: AOJu0YyREb8NgaMWCOjG2uJpFUleui/vnXHwerQNW++J4S7wnbcYpnAz
	5Mi+2AS72Q9k0qrdwdSYCkcEsjMoocVkZDkFo++NYtN6uvhtntJ2UrjaHfKUY06ZfkaT2mdpaeN
	amA==
X-Google-Smtp-Source: AGHT+IESez/zxTWutjtLJAUJhIiTiAtRpWSvjJWmuvSpH774la09rZR91czqzlEpBwGUZ+0osFi4L0/wScE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8591:b0:704:3140:5a94 with SMTP id
 d2e1a72fcca58-70ecea0e7ffmr15968b3a.2.1722038127870; Fri, 26 Jul 2024
 16:55:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:31 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-83-seanjc@google.com>
Subject: [PATCH v12 82/84] KVM: arm64: Don't mark "struct page" accessed when
 making SPTE young
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

Don't mark pages/folios as accessed in the primary MMU when making a SPTE
young in KVM's secondary MMU, as doing so relies on
kvm_pfn_to_refcounted_page(), and generally speaking is unnecessary and
wasteful.  KVM participates in page aging via mmu_notifiers, so there's no
need to push "accessed" updates to the primary MMU.

Dropping use of kvm_set_pfn_accessed() also paves the way for removing
kvm_pfn_to_refcounted_page() and all its users.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +---
 arch/arm64/kvm/hyp/pgtable.c         | 7 ++-----
 arch/arm64/kvm/mmu.c                 | 6 +-----
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 19278dfe7978..676d80723c38 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -632,10 +632,8 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
  *
  * If there is a valid, leaf page-table entry used to translate @addr, then
  * set the access flag in that entry.
- *
- * Return: The old page-table entry prior to setting the flag, 0 on failure.
  */
-kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
 
 /**
  * kvm_pgtable_stage2_test_clear_young() - Test and optionally clear the access
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9e2bbee77491..6679e02a02c4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1287,19 +1287,16 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 					NULL, NULL, 0);
 }
 
-kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
-	kvm_pte_t pte = 0;
 	int ret;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				       &pte, NULL,
+				       NULL, NULL,
 				       KVM_PGTABLE_WALK_HANDLE_FAULT |
 				       KVM_PGTABLE_WALK_SHARED);
 	if (!ret)
 		dsb(ishst);
-
-	return pte;
 }
 
 struct stage2_age_data {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 756fc856ab44..8fd8ea5b5795 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1699,18 +1699,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	kvm_pte_t pte;
 	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
 
 	read_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
-	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
+	kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
 	read_unlock(&vcpu->kvm->mmu_lock);
-
-	if (kvm_pte_valid(pte))
-		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
 }
 
 /**
-- 
2.46.0.rc1.232.g9752f9e123-goog


