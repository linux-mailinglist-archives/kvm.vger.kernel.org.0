Return-Path: <kvm+bounces-22373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E9493DB5B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D85231F24498
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC3715D5CE;
	Fri, 26 Jul 2024 23:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nu6YJ8ah"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF0115B13C
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037980; cv=none; b=EzhK/s+M/YQ5TuxlA1KUrgMJrRH974sHr79XaFneOblF0Bd9zMWTakpJKrb9BFPUhVxzbno8y+tPwBiYJOQYhqH5VDTlvkpCVNrqokQaWCbKedScVyA262Yf4lT26EDYpUBL4ak6ebv1wDviDUClSCHTq2yteMgG1FzVxSbfh1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037980; c=relaxed/simple;
	bh=eYPpE7SnzshOjYhzmXkcsAp87ERqXcDPZzZJ9L8u3ZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CbCWT1aivE6RcBY9o9ysljWDQE1QNu7B0Yo7cjTzyaCr3LvdDD+VjahY+T9W4Ws0u20QCQdV0AZl4Y3gvuTeoVtefIzTQ70D2ZyqodvcGUINFhaTQbC2FGu5xXzuzATteFuQSxcEKtXvewXJP8vjdSTqVzrgW75YuxzoctI+NQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nu6YJ8ah; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0b3c65c71dso452288276.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037978; x=1722642778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e1uaEfwlbucR9PkkwcUB/hlZrD43F2tYkTCYXf9cR5U=;
        b=nu6YJ8ahAfVxD3gSiVkVf2rbA0LtCA3av8e+T60YGtz4ztjNWZ8o5aOSn93X3kfAJk
         TR6hbY+cYWxFUpzhRMkajkVViLQLXFMuUroBPWdzyD4BobLFbl+lCSS4kc/61Ht55hjT
         QHqcGn0HcJ4pqbNqTOUjzzLvzaYCGlTYrnRjRAunLCg7NwZJ7fBiXIm382qdJMeehnIY
         P/30SKbgqTT4gaiecwWTPkVJIvAgLRYbxMGyFF/ocj/uexD5bqU2p/3/3nIsoaw6nBWc
         jDYN4AB7laan4qpa/AvdHPoOPeMXGa5FPcJ/c6kYtpfuAwHuJ+kiPwFceYlcGe6RS1SR
         yehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037978; x=1722642778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1uaEfwlbucR9PkkwcUB/hlZrD43F2tYkTCYXf9cR5U=;
        b=dwWpJnHJisL6gIfjRT7+MF2VdhN3PYmaWHr8Vzggbw8JvojRnpaVIed3Bt755F66zn
         lGGsZAkC7N5z5uscgIlVwHDqzOXhj7GvArXJ9OSikFnfV6Ah80p8DykzqnO7JNZeSGz3
         P9mxJra6uwNg0JJGfyLUxlVS2RzL/JfQrHA2L725Pb4lB0pH9OSXks31Y8/pZCeYZOH8
         qIIuecWEJH1CKGo2wKc+7Q5rx8N0fGnt9v6POpfruxJ3xm7JkQMmBABJsM69H+Gmf4dO
         phKa6azfE+KMksiPE5JA9/mMgzr6QjRQTH965A9QOHjc4lthDWmQ85RVQGdIpRATunEM
         6O1g==
X-Gm-Message-State: AOJu0Yy/ZaamSMYpQ1rLPOLCFOUffPCYE2sg7G67CxgMxEcvOJexiNtB
	icqhdy2ESn3LITBbNNpEYtJ9iBCPQvrrC2I4XNgS2JHTUTxcUWKpWGOLf3akMGk8DMuNPXzArKX
	Ahw==
X-Google-Smtp-Source: AGHT+IG4XdyN3FgjZWItv/Lgg5QEKJKUQifoplgps87wy/mf6q3lv4u9rcIn8zN490p0nZ8TWmWhP2C2xyU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1081:b0:e0b:1407:e357 with SMTP id
 3f1490d57ef6-e0b543f0dc9mr70203276.3.1722037977844; Fri, 26 Jul 2024 16:52:57
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:19 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-11-seanjc@google.com>
Subject: [PATCH v12 10/84] KVM: x86/mmu: Use gfn_to_page_many_atomic() when
 prefetching indirect PTEs
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

Use gfn_to_page_many_atomic() instead of gfn_to_pfn_memslot_atomic() when
prefetching indirect PTEs (direct_pte_prefetch_many() already uses the
"to page" APIS).  Functionally, the two are subtly equivalent, as the "to
pfn" API short-circuits hva_to_pfn() if hva_to_pfn_fast() fails, i.e. is
just a wrapper for get_user_page_fast_only()/get_user_pages_fast_only().

Switching to the "to page" API will allow dropping the @atomic parameter
from the entire hva_to_pfn() callchain.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ef0b3b213e5b..6b215a932158 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -535,8 +535,8 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 {
 	struct kvm_memory_slot *slot;
 	unsigned pte_access;
+	struct page *page;
 	gfn_t gfn;
-	kvm_pfn_t pfn;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -549,12 +549,11 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!slot)
 		return false;
 
-	pfn = gfn_to_pfn_memslot_atomic(slot, gfn);
-	if (is_error_pfn(pfn))
+	if (gfn_to_page_many_atomic(slot, gfn, &page, 1) != 1)
 		return false;
 
-	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, pfn, NULL);
-	kvm_release_pfn_clean(pfn);
+	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
+	kvm_release_page_clean(page);
 	return true;
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


