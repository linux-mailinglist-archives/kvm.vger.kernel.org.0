Return-Path: <kvm+bounces-22428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 32BD193DC72
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:22:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CA20B293FB
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B81918C359;
	Fri, 26 Jul 2024 23:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oV2QMfbv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8AF18C329
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038094; cv=none; b=Dlm7kO+d3yMZcTspIUA3Vev6aRO4zkedm+ozm6FEFtyp8Op+PPdj2H5KAsfydaIw+MiGCiUslPQBm3o51i/cX1QMoi/OUzviboBFo0rCrTZXeJBba+Nt7c1osYPwCDUPtl3t6S/0WoheqDhIa8LnSqQNoTTZ+OP9cPF7jiiuRfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038094; c=relaxed/simple;
	bh=Z7iItHoG1Un0PHfLJEkTiTxR+0KDEJBb6FOtFGyXsoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RjyhjzgddojLWETebr+khlqAn6lbzHFgfF1HJbzfpUumYW/8SLsST+3ecvq0p9hXowef4VYOZflo7BiIehWuClWDlWhQ53fd+RyZAAw+7neMdq4FpTxjGPo0mA9IodsH87cnPT5201GiGJDcf5+dAMphAfWtiKx35462vUs0QVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oV2QMfbv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc4b03fe76so9984385ad.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038092; x=1722642892; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rpwXsNxFJqP0CEr/yEQ2h0r+lN6KBTuvETCSKMoe8FQ=;
        b=oV2QMfbv2gcxRqY3Insn7uLjyUxURjUUtM+Af5KaqSKhBbAVL3iQlG2lEbfryqSRmg
         qG2aJXEVyURbTvKk4ZEhN+/z49kPW924JEKFzx6O52AB8dk6puPvcsoNWBD9jsmO3mAC
         U8izEzDcI3AO90gx9KJu9RRjihCKH/bmxfuHcx/BC/C9/BLLNmmMeuxfGCcMp+1y5Jnx
         hws3Jxo9vQkBW5Sa8iR62gWqqb4DFAwLv1gXmMz3ze7FsGZktGz7U4EWa7ehMOTyZ4Lr
         IbPuz+gCMJsmo+GgE/SJewCRt89UhVWWGukcbIv71by9F5VjiS3sELBt+v5pZOCy4WhO
         7h2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038092; x=1722642892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rpwXsNxFJqP0CEr/yEQ2h0r+lN6KBTuvETCSKMoe8FQ=;
        b=Wns1b0exUJ5LXDInpLxCtkjOjG6XsjYrLZrkzS3vOc+F187PeDN2cEMV4Rpn8UHjKC
         lLTvsHbNKLmMCwEu+CrWwmsRFA9ymk2okDlRCLOX7m5NT6Q+KsHehIwKigI0CKlq830/
         2aIr17rjRqWGMw1ROzmzknEBwddF6WqM1410PhhAXh94yKUwsSas8gJ6nkPXeHn71B/g
         PyQBaX/gs/O4dK9JVp+G22mKM4n77n5gzfb2Q2Qm7yi84e91//4bTMpVnZqrfVArHdcM
         9nK93Vvmb4MHp7YFLh2j7PHl74XUk3h2s0PqLwgYxf1xVHquajt0N0MfJixB7sGwVyyF
         jnCA==
X-Gm-Message-State: AOJu0YyVJ/TZLyef8Q4yOsaYs5NULaymIrv73UeZ1dkCK6uyqzN9nehu
	LJOmE9gGuw2+L6vptSJ8+7wL0juY7qnUC3EWZVKQUW8bcAu6YBAIDev4mTSxQzQhUO5zyHDadAA
	FDQ==
X-Google-Smtp-Source: AGHT+IEz1qMb/9xSOR6pziERGmR6RlcO2d1FpOxR3ZCse98fOqCGJ5ia3ZBUMMNkI3e0ioyh2oD8FsbOxx8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2341:b0:1fd:63d7:5d34 with SMTP id
 d9443c01a7336-1ff04803eeamr27405ad.5.1722038092373; Fri, 26 Jul 2024 16:54:52
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:14 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-66-seanjc@google.com>
Subject: [PATCH v12 65/84] KVM: LoongArch: Mark "struct page" pfns accessed
 only in "slow" page fault path
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

Mark pages accessed only in the slow path, before dropping mmu_lock when
faulting in guest memory so that LoongArch can convert to
kvm_release_faultin_page() without tripping its lockdep assertion on
mmu_lock being held.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 364dd35e0557..52b5c16cf250 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -552,12 +552,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 {
 	int ret = 0;
-	kvm_pfn_t pfn = 0;
 	kvm_pte_t *ptep, changed, new;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_memory_slot *slot;
-	struct page *page;
 
 	spin_lock(&kvm->mmu_lock);
 
@@ -570,8 +568,6 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 
 	/* Track access to pages marked old */
 	new = kvm_pte_mkyoung(*ptep);
-	/* call kvm_set_pfn_accessed() after unlock */
-
 	if (write && !kvm_pte_dirty(new)) {
 		if (!kvm_pte_write(new)) {
 			ret = -EFAULT;
@@ -595,23 +591,11 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 	}
 
 	changed = new ^ (*ptep);
-	if (changed) {
+	if (changed)
 		kvm_set_pte(ptep, new);
-		pfn = kvm_pte_pfn(new);
-		page = kvm_pfn_to_refcounted_page(pfn);
-		if (page)
-			get_page(page);
-	}
+
 	spin_unlock(&kvm->mmu_lock);
 
-	if (changed) {
-		if (kvm_pte_young(changed))
-			kvm_set_pfn_accessed(pfn);
-
-		if (page)
-			put_page(page);
-	}
-
 	if (kvm_pte_dirty(changed))
 		mark_page_dirty(kvm, gfn);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


