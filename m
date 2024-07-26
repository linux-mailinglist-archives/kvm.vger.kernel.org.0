Return-Path: <kvm+bounces-22436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A286693DC3C
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4F671C23300
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5849018FDAE;
	Fri, 26 Jul 2024 23:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zFAZvaTC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E293D18FC6D
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038112; cv=none; b=Yp7RsyXp33ZA74zaV7Dea1ggtrNk5TxveABN4RyH78lkn46Uc3niScQA442UW6cPI+zPTHbkVXJJ/0PlFxkwHBXXdW029E9GFQHNIMz1ErmnlBiUIAffLOGY6e06yfVSEG/8KtZnOKiBETWyQCV9UK7ZYjLV6NnvqzjdLdMVxmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038112; c=relaxed/simple;
	bh=MKtv9E2m62lbMOtLTcz5DheM9a7Qrx2EJNoDq9m1CG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pFFe1L8yWEpFG58hh6GxNc9iBtlzGwIAH9Ms11ipNKDSAUhJJWKYnDo96OG/oq7ssmKV5xy3rHq/H7XLmBP/FRQ3WgQ367RQtMDy4LRz4RNVdVvWOzTuaDZo+c0gH6esinhqKmxpCxNCewkg+hl/dnT3xygNEr65K37GgABxGDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zFAZvaTC; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6648363b329so5175997b3.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038110; x=1722642910; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FGNMZjC6zrq4QPk0aaY9W+lI1TKYWYG7APrsjifVvZM=;
        b=zFAZvaTCknt7/gua0u+ec+6x0FU09gH3ubH3kdDCEvbQgtKx9k+r+6Vjoyg1I74k5G
         qA+Kf+8WZWBB11enpMm2CVK5FRVRF6NUsskdrqXXdnXiZY6B0nuzc+gqeDJ2HST7jwhF
         RLSlwHntdomZvh2IcA1XECrHNUR2IrEGW3wFvYGUye9EMegOF/MYO/+pykIZ3IwBwRf1
         EYLHUIGy5c1bx4yFig3dUHpx/XPYCcwOobhHgNp/j9fad1mpuDh2n/pOXNMd6sXvaFNt
         wQSwCdZNIpwf3zoDsdpyB95LiGrOiCkUdqpLc1SR/yfF3eXE804jtiuE/yqzVk0zk7Vu
         tRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038110; x=1722642910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FGNMZjC6zrq4QPk0aaY9W+lI1TKYWYG7APrsjifVvZM=;
        b=xNO79NnNRwyICJENw6BZ+RrZ4eASwhgJb8UIL+rk9BwQTNZ9q2lnH4uoh3hh4mxgdB
         f3q41tThXjnK9/f3axJb8m8N2BOBQ+YXLueStgWODPjZq3/wHaSg4cJHYSkBvEOGC470
         kLGapTXAvgRu//qDRWpr7NxZFjWlXp3eb42uyIYuJRMH9tnG/5k30Q6kw7xnCItZYX/q
         x0MQLA9HoKLp3wdm8OJbahQQ2nSPPE98nxGfMrF8ePOydNDpguo0G8Oy/wRlsXytAud+
         00GPmX4mWMQFkJEHgKj/H1VDLsW8HxbYKVYRYLrJMFqYKE+30FpvxUyqcmHyCJeKCWiI
         6Vaw==
X-Gm-Message-State: AOJu0YxNkNdqdcgQZ9U9gfy7hJNO7zaq1CxXXUyWhoQLDQafTMW8nG7V
	0c8Ja4vA/SoQcBrsx5/NbS5OIh8KbADM6gtRD5uUeEPVfLU3EwsqCl+oIxlScs6YVzY8STwGLGZ
	16A==
X-Google-Smtp-Source: AGHT+IFLZWO6XOpdLpjl0c1N0cYikN5d5kXLguU/WRS6HZfMhk4D9x8u+2tsxxP6CN0/8qHX8YjuuRQeC7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:830:b0:61b:e103:804d with SMTP id
 00721157ae682-67a004a2a4amr37877b3.0.1722038109325; Fri, 26 Jul 2024 16:55:09
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:22 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-74-seanjc@google.com>
Subject: [PATCH v12 73/84] KVM: PPC: Use kvm_vcpu_map() to map guest memory to
 patch dcbz instructions
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

Use kvm_vcpu_map() when patching dcbz in guest memory, as a regular GUP
isn't technically sufficient when writing to data in the target pages.
As per Documentation/core-api/pin_user_pages.rst:

      Correct (uses FOLL_PIN calls):
          pin_user_pages()
          write to the data within the pages
          unpin_user_pages()

      INCORRECT (uses FOLL_GET calls):
          get_user_pages()
          write to the data within the pages
          put_page()

As a happy bonus, using kvm_vcpu_{,un}map() takes care of creating a
mapping and marking the page dirty.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index ae4757ac0848..393c18958a5b 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -639,28 +639,27 @@ static void kvmppc_set_pvr_pr(struct kvm_vcpu *vcpu, u32 pvr)
  */
 static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 {
-	struct page *hpage;
+	struct kvm_host_map map;
 	u64 hpage_offset;
 	u32 *page;
-	int i;
+	int i, r;
 
-	hpage = gfn_to_page(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
-	if (!hpage)
+	r = kvm_vcpu_map(vcpu, pte->raddr >> PAGE_SHIFT, &map);
+	if (r)
 		return;
 
 	hpage_offset = pte->raddr & ~PAGE_MASK;
 	hpage_offset &= ~0xFFFULL;
 	hpage_offset /= 4;
 
-	page = kmap_atomic(hpage);
+	page = map.hva;
 
 	/* patch dcbz into reserved instruction, so we trap */
 	for (i=hpage_offset; i < hpage_offset + (HW_PAGE_SIZE / 4); i++)
 		if ((be32_to_cpu(page[i]) & 0xff0007ff) == INS_DCBZ)
 			page[i] &= cpu_to_be32(0xfffffff7);
 
-	kunmap_atomic(page);
-	put_page(hpage);
+	kvm_vcpu_unmap(vcpu, &map);
 }
 
 static bool kvmppc_visible_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
-- 
2.46.0.rc1.232.g9752f9e123-goog


