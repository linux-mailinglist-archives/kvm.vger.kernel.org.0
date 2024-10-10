Return-Path: <kvm+bounces-28545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C96E999120
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00B2C1F21A6A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A27A21018C;
	Thu, 10 Oct 2024 18:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZfysK4Eb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1836F20CCEE
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584837; cv=none; b=TvHlK14wBd8cJJoCMUWoikQgY0mL7u6NHm7Y0Px4LdDHFB8YRJ/OISLqPCAdrrBfmPWBQkXTZ7GW+d4XzKAazhtckRNpQoh46uuZuAFiBDXA9s3m+uEZ+e1VG/HW1zliOJ9epxEc0i1a4XX8uPAj5rBq6AkUyn/SjMianTyoehs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584837; c=relaxed/simple;
	bh=HhUA1PeKZEb/51LjtENBtdXbtQZ0o3j1vGZCLDD8mMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=snPkYl0m5hrEi84c19blsgBdSI+Bkxckij27J0+ylbUNmF7FiMaR9QCgLIMCu1DO0Cy8OdgtlCEuH2qclNAXy5Z6veOZAUgfM1Bg4B2ddPyxAcBuK8ZCM11jMhUTTtLdCYkiBYGLPmv+Kl3xr6cqiCsXaKKaiGhQp68K1bG2v7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZfysK4Eb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71dff575924so1543897b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584835; x=1729189635; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9LTMkDJZxM2S5Qh4t0DfHllWvhtFq1rJ9EqXHTYHy/A=;
        b=ZfysK4EbyW9GP/xSuAfW3U3GxCRMKGJ1uQ0l+1a9fb8m3NTbOSK3zUlXUKjOSQ40T5
         ULvpVNM76l5WMWoFdvGpGrBdcaqid0kWMM1s0kBGxkAqf4kwZrEANqHFgqecmt8eHYgx
         Ik8OK2Vg31lI7rB/rwW7MTUKastSn4QH1xeXn/WK8/jnpqBbiN9Zv5K+jntkQWm890PW
         KjLL2HC/A6kUxWwarJKMFJacXMwAT0kofIlFki+OA82WubYYtrJHX/t4g5yKgnDO+Ptq
         4dA1ZW7S4NyO5r2DrnFx44K0GxT/uIbV+E5cT8JHXE51CWa5Cvp/710I6os174/V43Yl
         h/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584835; x=1729189635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9LTMkDJZxM2S5Qh4t0DfHllWvhtFq1rJ9EqXHTYHy/A=;
        b=BCMv/cVgF6U+YPT64wLkQAz17DjjQ597ZfYSD6cCilrWjSSgJGohRaQw5wlrjZFkrr
         F31gxphIUt4mpY3Sp3CLiyJDASyHkOAIgjP4XAhAptWnK9Aady4u64KhAViO4Ny5HhT2
         SeR+qKk+d2ezxAUFg+F7tfljdxOm2s9yN+NV7qLNzkF/A15g/L/42yvf8jg+88Hte4oU
         P6zLkJSDUhtZlOptLXa1qq+Xhq7+VxOjUWEs5xm5RxwP+xoBIC2k61TprCz/a5C4y07m
         GjSrc7ISqIXTBN+aH33ck5jjSEnkG3WbGUueCVy5w72gbjBwt6/ISMICImPBMXotGBuh
         qojA==
X-Gm-Message-State: AOJu0YxdqB//OzET//B6N9rZZctDNS6HV4oNMo0O4UobP622oDwGC387
	3CshkMvPgtdYO4eP+Jyse+1KVP/Qnk/6ynNgMIEr6TkOOFN+ciGKKMlFWQ1DbkAQ10JSebJudvH
	Kxg==
X-Google-Smtp-Source: AGHT+IExt7obORK9hFSNzpsBdJKygVAVx/dPvrUuCl2bsyTFt9B1GPfq0Q1aHG/lNRl/yht5gsZcWFEXy1g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8614:b0:70d:fba:c51c with SMTP id
 d2e1a72fcca58-71e1dbd032amr6898b3a.3.1728584835380; Thu, 10 Oct 2024 11:27:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:10 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-69-seanjc@google.com>
Subject: [PATCH v13 68/85] KVM: LoongArch: Use kvm_faultin_pfn() to map pfns
 into the guest
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

Convert LoongArch to kvm_faultin_pfn()+kvm_release_faultin_page(), which
are new APIs to consolidate arch code and provide consistent behavior
across all KVM architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 7066cafcce64..4d203294767c 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -780,6 +780,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_memory_slot *memslot;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct page *page;
 
 	/* Try the fast path to handle old / clean pages */
 	srcu_idx = srcu_read_lock(&kvm->srcu);
@@ -807,7 +808,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	mmu_seq = kvm->mmu_invalidate_seq;
 	/*
 	 * Ensure the read of mmu_invalidate_seq isn't reordered with PTE reads in
-	 * gfn_to_pfn_prot() (which calls get_user_pages()), so that we don't
+	 * kvm_faultin_pfn() (which calls get_user_pages()), so that we don't
 	 * risk the page we get a reference to getting unmapped before we have a
 	 * chance to grab the mmu_lock without mmu_invalidate_retry() noticing.
 	 *
@@ -819,7 +820,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	smp_rmb();
 
 	/* Slow path - ask KVM core whether we can access this GPA */
-	pfn = gfn_to_pfn_prot(kvm, gfn, write, &writeable);
+	pfn = kvm_faultin_pfn(vcpu, gfn, write, &writeable, &page);
 	if (is_error_noslot_pfn(pfn)) {
 		err = -EFAULT;
 		goto out;
@@ -831,10 +832,10 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 		/*
 		 * This can happen when mappings are changed asynchronously, but
 		 * also synchronously if a COW is triggered by
-		 * gfn_to_pfn_prot().
+		 * kvm_faultin_pfn().
 		 */
 		spin_unlock(&kvm->mmu_lock);
-		kvm_release_pfn_clean(pfn);
+		kvm_release_page_unused(page);
 		if (retry_no > 100) {
 			retry_no = 0;
 			schedule();
@@ -900,10 +901,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 		++kvm->stat.pages;
 	kvm_set_pte(ptep, new_pte);
 
-	if (writeable)
-		kvm_set_pfn_dirty(pfn);
-	kvm_release_pfn_clean(pfn);
-
+	kvm_release_faultin_page(kvm, page, false, writeable);
 	spin_unlock(&kvm->mmu_lock);
 
 	if (prot_bits & _PAGE_DIRTY)
-- 
2.47.0.rc1.288.g06298d1525-goog


