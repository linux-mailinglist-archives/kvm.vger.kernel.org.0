Return-Path: <kvm+bounces-22435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9676593DC39
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16BCA1F227F8
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDD518F2FC;
	Fri, 26 Jul 2024 23:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JPZR7Ksa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB9118F2F5
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038110; cv=none; b=qwDzmYHaiQvZkwbW8OSvznrhMPzO3p/4xPJbX5xC/LQCPjh8r4ecCzDwGDHE18nNdCYiMDOTeuOUI3D3EwYyR7oV23wrTYb65zUX9ehqIIjHZR86XDrl89i5H5hSVUkfLr2wD3TKqDFYRQzD9CGb4aG4IySp4aohIPqWQWJZm3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038110; c=relaxed/simple;
	bh=lhHYI4ZmXcFxea+okVo57sctSAMSkRMQQrnLBVGt6rM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kZ/aUFIjC1AxDEXcSbOOtZgu/UTZs0gB6GPi1ewlz4ljDk5JA8W/xuWXttvuysYvQSbNWTOuSFJwBd9mQiGYTPANhGJt+/+x9o92UXlB8F51B1vrrxSQejPQ6ES6I59f9T52vmqbDielJjNnXvGIY0WLSVYHVo18BhKr6c04zBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JPZR7Ksa; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-76522d1dca5so1518490a12.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038108; x=1722642908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M9eYn37tam32k4Zpbs9VqSvLY6wlhZ916YFlgyF6peA=;
        b=JPZR7KsawhAY1zNkBfaIrr09R1PzXxNpOHyTk0B9Cl+jcRbMCFjmRTstg6s3HTXb3q
         NLP4m5v51UINbmhW7/b4Dyt4YRU8NVRr0579tWUfeaJNdpssw6QSfs2QViwGBfehMq//
         JpINpjMO56z132eYkp2/CN0ZJkcOhwiSC8pKzUzS+i3yDgZiKBVSdKmtkzazyejCp7bu
         0Waej+sWdLftXSrTMTyXiuWLlOA9wEGyRv9HpaNZ0X5UwCgFf26miHhETfo9tStm3gna
         Q+Aj6VUs5uQ7PYzqOg0SJu4NfrX0rrX02ya8zTUOIv+WAY7hhUwxe22iXwU4S9aovat6
         Ma7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038108; x=1722642908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M9eYn37tam32k4Zpbs9VqSvLY6wlhZ916YFlgyF6peA=;
        b=cLJIom/szDi0iRmNYgIIGWkK2gaenCYUQXRkwlMpE+nqoHnD/5JM9dh6tkZl333hNu
         xZz5/ybwTpCsnwitBM+8l3eetlbl+khD/wkcJ9DWS7P04cfLGzo1eodDz1jIK3HV882y
         348Af6qSiFEN/69Y6kR/QNvm3kKX6JqODl93r2EzOkaOj+rGWmnq1RnbmAVMLF2RnsZc
         lgRPk07saoI426xXhMbLSo7mhKsE+1Nmua0mhtxRdC+EhI55SkSiQMhOpO5HZKcyHyQr
         KI5t5AYv9QiUYhgAqHgHI3RsnO5vunvO+/D9jSAnI9du0VrRKRl+znUkkIY0xITQpELk
         o+5w==
X-Gm-Message-State: AOJu0Yy3g7e718yTzEXmTUCHIFmM6ejaz3BCmhTKuSZ7YqTUQ5nYU1KX
	S71U7XkjVbgw/IMMeSx4bWCkk3zX5LEjuTtERGSScIYcCE5kQdDJUI9egm4Shj9Lq0BW63qzqgG
	29w==
X-Google-Smtp-Source: AGHT+IG8TH3qPrjAadwsmfbGVL51l5vDfwJrWL4CCM6knLIepOGyFeiwzAiBROJulbOiIHONd5UuXBO9hTI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:526:b0:6e3:e0bc:a332 with SMTP id
 41be03b00d2f7-7ac8dbc497emr2439a12.2.1722038105187; Fri, 26 Jul 2024 16:55:05
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:20 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-72-seanjc@google.com>
Subject: [PATCH v12 71/84] KVM: MIPS: Use kvm_faultin_pfn() to map pfns into
 the guest
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

Convert MIPS to kvm_faultin_pfn()+kvm_release_faultin_page(), which
are new APIs to consolidate arch code and provide consistent behavior
across all KVM architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mmu.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 69463ab24d97..d2c3b6b41f18 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -557,6 +557,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	bool writeable;
 	unsigned long prot_bits;
 	unsigned long mmu_seq;
+	struct page *page;
 
 	/* Try the fast path to handle old / clean pages */
 	srcu_idx = srcu_read_lock(&kvm->srcu);
@@ -578,7 +579,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	mmu_seq = kvm->mmu_invalidate_seq;
 	/*
 	 * Ensure the read of mmu_invalidate_seq isn't reordered with PTE reads
-	 * in gfn_to_pfn_prot() (which calls get_user_pages()), so that we don't
+	 * in kvm_faultin_pfn() (which calls get_user_pages()), so that we don't
 	 * risk the page we get a reference to getting unmapped before we have a
 	 * chance to grab the mmu_lock without mmu_invalidate_retry() noticing.
 	 *
@@ -590,7 +591,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	smp_rmb();
 
 	/* Slow path - ask KVM core whether we can access this GPA */
-	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writeable);
+	pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writeable, &page);
 	if (is_error_noslot_pfn(pfn)) {
 		err = -EFAULT;
 		goto out;
@@ -602,10 +603,10 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 		/*
 		 * This can happen when mappings are changed asynchronously, but
 		 * also synchronously if a COW is triggered by
-		 * gfn_to_pfn_prot().
+		 * kvm_faultin_pfn().
 		 */
 		spin_unlock(&kvm->mmu_lock);
-		kvm_release_pfn_clean(pfn);
+		kvm_release_page_unused(page);
 		goto retry;
 	}
 
@@ -632,10 +633,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	if (out_buddy)
 		*out_buddy = *ptep_buddy(ptep);
 
-	if (writeable)
-		kvm_set_pfn_dirty(pfn);
-	kvm_release_pfn_clean(pfn);
-
+	kvm_release_faultin_page(kvm, page, false, writeable);
 	spin_unlock(&kvm->mmu_lock);
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
-- 
2.46.0.rc1.232.g9752f9e123-goog


