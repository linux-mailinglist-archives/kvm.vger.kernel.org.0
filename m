Return-Path: <kvm+bounces-28492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0545E99904C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7400A1F24FBC
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D37F1F12F4;
	Thu, 10 Oct 2024 18:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TYQRQk+w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1071EF937
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584726; cv=none; b=cwNVgq5gpLOVtbaRmz/5hbNKay5RfKsavnVqqV6IdqNboZsbuKSlXlTETwQ8dUTu9yRqLTVSUPv262vPNBkgSg5JaZAgqHbvjxieqj6CODiO6ZyT6a08DRrIGOVL8tU7tT10hoeCX6Fv+bdQ/hWZB/4BJque+8USmd01o8ntuYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584726; c=relaxed/simple;
	bh=xKxLUn1wM/pJucT4/ZxvVNmNhzhyHMbiLj3YVf1FNHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hIF4vwXmjczPA+1dll0kHaeh5kgazP1q6uL3i5pTc0MzEgKw6quKNj9hT3KWnJ6Z6zrQGfRxL9FMEEMJqtGz1nBJWStdRnb39ECFAqVQKEtm84uIvXkT2bTvuAMnUi6SAARTMNPmYukZuOsQi+M3wcGT/d+dZmqE6+a9QFRjMjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TYQRQk+w; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3231725c9so23542457b3.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584724; x=1729189524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=86tNdlyX8HXR/WHFYCj/131p34DPDBwWgQrhOuSjETM=;
        b=TYQRQk+w7SZ6hxu000ERFTE/19nobGDZp4qfI4lUGaKSkx65llk5i8OtSPaWktaPe+
         5XozsAEpjOmnyoNqatnrYMAZ60RWiIscI44p1xR028Kq4YBFHeziOBq1g5YMW369+ewe
         DBbnBBj7uyWKhzvNHIsKPh1xm7J41dcuSCTEYZDqgPyXGvJRHeKaxnjlU+Q7xVjJlTj+
         Py4wWC7F64nR2FkwHexXSLRXrQRj5eudodYY+PhBwB9w0LCVub3wGLZ+EE1KRXqo1yqd
         P1/WIlzQG/PMilWwZm1sDFH2cYInsL65Bp0RatNOaVo01u0iAbnToWRI8vRt9jBA3Mti
         z40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584724; x=1729189524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=86tNdlyX8HXR/WHFYCj/131p34DPDBwWgQrhOuSjETM=;
        b=fn8WYU8oK7GYy+0BRDX/gdMy/fvR8Mq0WRgWgQNPo5dh8kV1sOnZV88htqylY8Qr64
         51GvufVha3v3jajq/4N601rZgZdR47GrnmCETxSvBoHmO51NWlE4kTakA/alVhvBw70j
         sVrhcok5c9SdhjiMa71SCMicTRp/Rewab/hDbXDUtFTWBgZ9hecHGRo6e9wePGvpdDDn
         AUEGXFsSufl6j8jR/FlqoDFPkOijrgnvcNgSn1FR13caVE+4r2c6qAdc2tqTPIvalMgH
         3ZCtGW1t9rOQfg7H2g7z+IeJhERmiV6FRyv1oEm8VvNSTAFIKaRnSr2Tb4JNKnC0rIUp
         oWCQ==
X-Gm-Message-State: AOJu0YwV/W63yydUDVaFhEMPcgbMhAkCpsY4HHvhzdt4l5gZZGKR6xai
	As2iiBg72u6oYEy5yiSLfIASaQPjwyGXvL/PV20l51nnW4Bn/oNAKsWCVvvsQvxjdhlyekGLgUs
	iGA==
X-Google-Smtp-Source: AGHT+IGf82b/hxj2IWFe54/TAnEDS4XyhakmYGUWxryxrCLTzb83+cUU5J1DZhSXbLBNZQvipdjBbhmVkR8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8e09:0:b0:e28:ef25:5f13 with SMTP id
 3f1490d57ef6-e28fe0e7352mr200743276.0.1728584723790; Thu, 10 Oct 2024
 11:25:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:17 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-16-seanjc@google.com>
Subject: [PATCH v13 15/85] KVM: Drop extra GUP (via check_user_page_hwpoison())
 to detect poisoned page
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

Remove check_user_page_hwpoison() as it's effectively dead code.  Prior to
commit 234b239bea39 ("kvm: Faults which trigger IO release the mmap_sem"),
hva_to_pfn_slow() wasn't actually a slow path in all cases, i.e. would do
get_user_pages_fast() without ever doing slow GUP with FOLL_HWPOISON.

Now that hva_to_pfn_slow() is a straight shot to get_user_pages_unlocked(),
and unconditionally passes FOLL_HWPOISON, it is impossible for hva_to_pfn()
to get an -errno that needs to be morphed to -EHWPOISON.

There are essentially four cases in KVM:

  - npages == 0, then FOLL_NOWAIT, a.k.a. @async, must be true, and thus
    check_user_page_hwpoison() will not be called
  - npages == 1 || npages == -EHWPOISON, all good
  - npages == -EINTR || npages == -EAGAIN, bail early, all good
  - everything else, including -EFAULT, can go down the vma_lookup() path,
    as npages < 0 means KVM went through hva_to_pfn_slow() which passes
    FOLL_HWPOISON

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ebba5d22db2d..87f81e74cbc0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2746,14 +2746,6 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *w
 	return gfn_to_hva_memslot_prot(slot, gfn, writable);
 }
 
-static inline int check_user_page_hwpoison(unsigned long addr)
-{
-	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
-
-	rc = get_user_pages(addr, 1, flags, NULL);
-	return rc == -EHWPOISON;
-}
-
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.
@@ -2948,14 +2940,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
 		return pfn;
 	if (npages == -EINTR || npages == -EAGAIN)
 		return KVM_PFN_ERR_SIGPENDING;
+	if (npages == -EHWPOISON)
+		return KVM_PFN_ERR_HWPOISON;
 
 	mmap_read_lock(current->mm);
-	if (npages == -EHWPOISON ||
-	      (!async && check_user_page_hwpoison(addr))) {
-		pfn = KVM_PFN_ERR_HWPOISON;
-		goto exit;
-	}
-
 retry:
 	vma = vma_lookup(current->mm, addr);
 
@@ -2972,7 +2960,6 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
 			*async = true;
 		pfn = KVM_PFN_ERR_FAULT;
 	}
-exit:
 	mmap_read_unlock(current->mm);
 	return pfn;
 }
-- 
2.47.0.rc1.288.g06298d1525-goog


