Return-Path: <kvm+bounces-28537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B86F999109
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDFD31F214FC
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E1320A5C9;
	Thu, 10 Oct 2024 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E4/Nn2nf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09919209F36
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584822; cv=none; b=oKyM32EnEymfT4TjDto11aGOjxWX8OChJIBogEt7E3ZWDLfenQxZLOEngDN2xY8Roju5HZNMyLWY4ruZolloA84HvwjhabnPp3nwKHfQJyarIjO388Lqckz489riFrD296sVhydgsFw/0b5tP6keHVhzJy3L43Q41N6BWnHgiKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584822; c=relaxed/simple;
	bh=dTkbtmFokyvOqUKSDyYRNtMSjRIKbeJnigSrLVN5f5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TNkw4ukEQjNlXWze98zX2nAhmSxmm1U0VJ44KyCJ5kbB6xHW8qz4PFwpioZwUcz+H9oghoBF9UInIGYC/zsyA6rszZCvHsX4NQFkeYtFRoVZq5RSRD0nDaX+NquY0OAjDTHcS4B+UPU9SKQN2D9NNhFHu/aDxhtrsxExnD8ue3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E4/Nn2nf; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2904d0cad0so2052464276.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584820; x=1729189620; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SD6mqWUZeYJtl6GnT7U0LdjoV3gPIs/AdF7iNpavyUo=;
        b=E4/Nn2nftJfFfMfz7XGdS1N64U1kTObHmK9jXjNfOx0RjrtgUP73dR5xAlk3+GMtGB
         VyKZy9lVNuNg6pbjDWdFmORwCovT3DjZBTB+WZ837kHeHvK2326FSbxxs8lJBmA+cqfJ
         AzLzFEr8HhjDktjfMFXgEDl8CY1fwEV6eCqYsTZqVWyTx1h236L085DUqUUmeS6vrvHB
         GSntK4yQbkZEuyozHwXiNZd4wO+6Z3lbwa+JRbDcIw4FDtwcrBqi9nXBbIffNp9qA3U0
         zaS4plFaV8cXO7/+pyiIv0T2C+lmVigBUlVA+qtqRH+dtAzYEjWbWCUNPXbPKT5e2PWb
         3B2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584820; x=1729189620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SD6mqWUZeYJtl6GnT7U0LdjoV3gPIs/AdF7iNpavyUo=;
        b=VzYG20vy+/jA5Smed6JS8w20RslU+ZEVbwWzUnvzfzgmiB4I4IJ6DaUzTW82NeQIpv
         ZodSMphACsk3DeXstVxJ4XYkuoB8xdtvogVzUIQfAaVNSc62eDWdiLkBZZ+2JvCDfY4p
         AAbROSNiZ1NQTc4AgeWJuybLHyMHwSsv9BeGI6n7tZhuReL2CamAkfaB5qJAYVEmPgiI
         U1Q2xQk9LeKMRh1PxlI12FITf8FuMhg0IlyYXafsMEKiMHyvA09ewKCgSgbgRLtF5RCH
         pf+PqAlZJob0OYNnRR/Oy+eDuxhWJwNhIFU3XV089IgPpZlbmEN5DPdxfC8w/r1PECLX
         EBSQ==
X-Gm-Message-State: AOJu0YyypIhsdpiuhsyps6ESHRwLxQfKX2ImMc4xB7lYzS8keOTwX2jc
	Jrr2V8rRy1nh/1WZKtUSJf/QxoESrkS4OY2k47sQiJicU2BhpqXeXd/PoHbAcuHi2VL1i7ECWX+
	iwA==
X-Google-Smtp-Source: AGHT+IGRQvxFZI4ySDHPZ8aV1dJi8vCYkQEt4dLiT8ndc3AvxflLIddldJBCv79vdNFr7/DaBU5iasgDdOk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ce11:0:b0:e28:fb96:d0f4 with SMTP id
 3f1490d57ef6-e28fe33505emr40781276.2.1728584819828; Thu, 10 Oct 2024 11:26:59
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:02 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-61-seanjc@google.com>
Subject: [PATCH v13 60/85] KVM: PPC: Use __kvm_faultin_pfn() to handle page
 faults on Book3s HV
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

Replace Book3s HV's homebrewed fault-in logic with __kvm_faultin_pfn(),
which functionally does pretty much the exact same thing.

Note, when the code was written, KVM indeed didn't do fast GUP without
"!atomic && !async", but that has long since changed (KVM tries fast GUP
for all writable mappings).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 2f1d58984b41..f305395cf26e 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -603,27 +603,10 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	write_ok = writing;
 	hva = gfn_to_hva_memslot(memslot, gfn);
 
-	/*
-	 * Do a fast check first, since __gfn_to_pfn_memslot doesn't
-	 * do it with !atomic && !async, which is how we call it.
-	 * We always ask for write permission since the common case
-	 * is that the page is writable.
-	 */
-	if (get_user_page_fast_only(hva, FOLL_WRITE, &page)) {
-		write_ok = true;
-	} else {
-		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok);
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
+				&write_ok, &page);
+	if (is_error_noslot_pfn(pfn))
+		return -EFAULT;
 
 	/*
 	 * Read the PTE from the process' radix tree and use that
-- 
2.47.0.rc1.288.g06298d1525-goog


