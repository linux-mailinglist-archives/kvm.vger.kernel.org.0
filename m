Return-Path: <kvm+bounces-22441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 549CE93DC4D
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F5DF285743
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1578119069B;
	Fri, 26 Jul 2024 23:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XKKg8iPW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8CF19049C
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038122; cv=none; b=Gocz9AjZqx9vWxPtHa0buDCTy1X9otRVI+CXpctVF3aZu8QKhxDQxXNMo0KBADJ2DLZOHtbVI/+auK9G1YG9xJEdepnnFttsYhrcXmj2n2R2+JzLG3/7Ht+boy/6jbeZPUSOGZyAaQSRg92Cuc4grItyqZXOu6uVoPSA1OpjY10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038122; c=relaxed/simple;
	bh=/5ISP65ZKB4aAJCrgFo/a/dmCj6FCUM4/FLOnd814Lo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tUSXME9gbTn3AMDuuH2UxUh4ckvN0lc9CROtYC5LcE53FiNh84sbaEDBOrjWoMJl4CK8Yd4HdkHXYV4K4czXsBV0Tu8ekJIkSrdYVO3O3wUJzbZ9ILVRbArHqYuqlOVt+AUXjTCoEUMroWs9muyJNf1niprQSkQzFHx8ww4PLW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XKKg8iPW; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso140503276.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038120; x=1722642920; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B5cS3fQCyroPznI2D76vYSWht1aEO90tb+OiOa938C4=;
        b=XKKg8iPWPEXGuEA1KPOl8c3qgaOM+ADtHl5/ja3ME/+ZWWY55iaKicznwTjhCAPpVR
         pDWp9ektuMbLgLwSXB1OYwKg8ohNcXdOe5K63fNaxOOdpSLJl2c7nyKrxS5RrzkVHp+C
         WXHE4TLK2Mx4DsbQBFerwyFFsNNKkJEoqemk29sGzpyt13jkTlnNIZ741kav+vY9C8+F
         rYDzbx1Dm/Awfr30yFZZOngzI2OxZebQGdmQzdYkujAlfhn9TkViXPRkJP6wx1aQPUdi
         m+0+eQf420b5tO8IuM1GYZtKriYE3koNz95MLMONU2lkNYqR/9CZ772JqGtgFE6CLzlf
         9Odg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038120; x=1722642920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B5cS3fQCyroPznI2D76vYSWht1aEO90tb+OiOa938C4=;
        b=jPPPQbdRz/CSuy2tMvlrju0vcT0g1Oa0W4s2Z4tDlOKFkDikbUTwBukw3u1osLaUvC
         Hwrwz3rnEtulBsToZ4T5lrO4U1uSeikIkZf1MYdHIkMunO6/7CMi2hX7FShe7qwpMWzX
         +EdIeYFIug++f4nYe64qMGfBEed+tA6yKO2f9ZsvWm0flqoytT+Z84LdQSZp8DP7Hfub
         FnRZa0Kzyx+x0u343ItGRmMYy+x/aXITD8wa4D7uy1tbSVQH9njrqoma6Xb+/k6feOYl
         JALmnQMyf7KHT2by+QVMgFV5CTAIpR3oIk8bK3zzRe1AijfX6k6psZqoxkp0Z1K8+9Bw
         U6mQ==
X-Gm-Message-State: AOJu0YxcFjjpiXjzCZl4rp1q6FzdzexngpBq02DEkTElNq6OxdU3pFxR
	voNinwAl+tmD1gifIdu0FYVXjE9NAw8TynwkKuSdGGatI+jenkWjd9xKwv3Z3EBz/Vv5I2mfvDf
	yDw==
X-Google-Smtp-Source: AGHT+IFMnVGgr4kpL4f9GKaKFvGezuIshpJ8eZPypNhpoA7Mjxc5gf+mvj1jThnEcafAjrCOymr+lPlnWyQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:606:0:b0:e0b:3139:7ce5 with SMTP id
 3f1490d57ef6-e0b55d079camr27265276.5.1722038119814; Fri, 26 Jul 2024 16:55:19
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:27 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-79-seanjc@google.com>
Subject: [PATCH v12 78/84] KVM: Drop gfn_to_pfn() APIs now that all users are gone
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

Drop gfn_to_pfn() and all its variants now that all users are gone.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 11 --------
 virt/kvm/kvm_main.c      | 59 ----------------------------------------
 2 files changed, 70 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f2d3c3c436cc..34a1cadb1b80 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1260,14 +1260,6 @@ static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				 write ? FOLL_WRITE : 0, writable, refcounted_page);
 }
 
-kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
-kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
-		      bool *writable);
-kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
-kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool interruptible, bool no_wait,
-			       bool write_fault, bool *writable);
-
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
@@ -1342,9 +1334,6 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
-
-kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
-
 int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map,
 		   bool writable);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 16bc3ac3ff84..5dcf3561b829 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3059,65 +3059,6 @@ static kvm_pfn_t kvm_follow_pfn(struct kvm_follow_pfn *kfp)
 	return hva_to_pfn(kfp);
 }
 
-kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool interruptible, bool no_wait,
-			       bool write_fault, bool *writable)
-{
-	struct kvm_follow_pfn kfp = {
-		.slot = slot,
-		.gfn = gfn,
-		.map_writable = writable,
-	};
-
-	if (write_fault)
-		kfp.flags |= FOLL_WRITE;
-	if (no_wait)
-		kfp.flags |= FOLL_NOWAIT;
-	if (interruptible)
-		kfp.flags |= FOLL_INTERRUPTIBLE;
-
-	return kvm_follow_pfn(&kfp);
-}
-EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
-
-kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
-		      bool *writable)
-{
-	struct kvm_follow_pfn kfp = {
-		.slot = gfn_to_memslot(kvm, gfn),
-		.gfn = gfn,
-		.flags = write_fault ? FOLL_WRITE : 0,
-		.map_writable = writable,
-	};
-
-	return kvm_follow_pfn(&kfp);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
-
-kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	struct kvm_follow_pfn kfp = {
-		.slot = slot,
-		.gfn = gfn,
-		.flags = FOLL_WRITE,
-	};
-
-	return kvm_follow_pfn(&kfp);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
-
-kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn);
-
-kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
-
 kvm_pfn_t kvm_lookup_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	struct page *refcounted_page = NULL;
-- 
2.46.0.rc1.232.g9752f9e123-goog


