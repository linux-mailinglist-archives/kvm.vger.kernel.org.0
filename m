Return-Path: <kvm+bounces-22402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CDA93DBC8
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE685284859
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8261181B9D;
	Fri, 26 Jul 2024 23:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vK0VXi5v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FFC181322
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038040; cv=none; b=FwS+zwPDAlAF+qfiCTtGvgNb2sil1bW02sHvONtRtNs39K81uozi7Lfje7knEpa3IMB4qReYw05ntPMyAYHhJEfjJww3fC9rrxliRyxwQxM5ugYHZRXzOx0gDYFUplEtGg9aYpU4eMqjOPUBOdfYfhKtucIkAEUKEZOxzSYyQn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038040; c=relaxed/simple;
	bh=wGZHvIOm+uvxUha7v63Q2rhvuGfIObXUhdqt56QjUZg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G8bL8jDn9KFpH7z6wZM++SA3S3ysXc1q/DnBLh+tow0lydvqYMFa6+K0MwZq6v5kGojUEQ8nrX3BYr2VSshiy2RWaTipyPaqQiTmDVGLPB5zMEd9uVlSGWEJIScACeAWy6hZocqBqGQ5kYce0BRt8HmYMQ6kKrcuEI1ZCQ1+U8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vK0VXi5v; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cd4e722d82so1585503a91.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038038; x=1722642838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Qh6T21uN8n1VHf7Uf0xlt62GR+52F2/YXe/M8yozbBs=;
        b=vK0VXi5vVMYQJjvZhe71mwVeVUHVb8jJnn3FMFVcVxiO9Ci4yN0qAPSp7XdGcY5RAM
         xEMEm80RCefdybk2ZdegISuMx8WcAogIi8dkt2/S4D4Gy9jOKOYAmJIOvSoVfcoEF3kO
         0x3JuVgNWEwMG6erjQxDn1h4yBFN3IgbcivQZdV2O6Xg0P90+otcVMpFZbv5PuIbHt1f
         pKBdI2Jz14V24L8rlRbItxge8E6eo1FT9kEJIy6kPpH3i+cpJO7nzCflzAJJ0rPxJPxn
         fbxC2gDrzdJ1Obl1z77jesVUD94GByOdDrwQGLnyfcUR6ZYuMeknpyrwbW+B329wH2HZ
         G0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038038; x=1722642838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qh6T21uN8n1VHf7Uf0xlt62GR+52F2/YXe/M8yozbBs=;
        b=tuzhKcUDJOSutRwbqHCN9rp1zLMdCps1Uaq3NnPO6tGOkpcfI/uANfoqhKP2IYg8HE
         Qeq+cMSfWCOor0L0GPW9rX5TixSKTPiNTbUi0LyehuEPDGns54IGoCjcx5mRJKCBCzXR
         8xQ8vaW8Jzun80S3bA7tbEtXkA0+TjYLESvQ1UGF9tS/PyidcV2HT0LjQMOlD1eEkarJ
         GlHnn6F2VMJHqhFBCFPM13wMOmkAIbpFq4xOOzIwAWfOXfT65wsb5lntkrMKvv2GbtNA
         BnFFaaVeB6qm0ZPOCTDoTr7exQnflgayLkbIbhNFou+xitj14fcS4buC+yRtAOTKvubg
         Zt6Q==
X-Gm-Message-State: AOJu0YwfFbIXo6mC5VCJezCTTNjkd0fPjiH/zrieeSw2KbleMp7nvXiO
	Uw9xfLtnpKOihW4YpDddJ9ifh1fVFX9tep561vUjHDweVQDnaXnJz5NqYTCTTpfHXhe6V14evpI
	cgA==
X-Google-Smtp-Source: AGHT+IHJ/uNdZAPdurru3IzCEMezhYQEvGsVQTc+qIu+wSY9S108IorpvBbDocczOA6aFsvKzrBA+JBrX4Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4495:b0:2c9:61e2:ce26 with SMTP id
 98e67ed59e1d1-2cf7e1c639emr12819a91.2.1722038038053; Fri, 26 Jul 2024
 16:53:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:48 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-40-seanjc@google.com>
Subject: [PATCH v12 39/84] KVM: x86/mmu: Add common helper to handle
 prefetching SPTEs
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

Deduplicate the prefetching code for indirect and direct MMUs.  The core
logic is the same, the only difference is that indirect MMUs need to
prefetch SPTEs one-at-a-time, as contiguous guest virtual addresses aren't
guaranteed to yield contiguous guest physical addresses.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 40 +++++++++++++++++++++-------------
 arch/x86/kvm/mmu/paging_tmpl.h | 13 +----------
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0def1444c01c..e76f64f55c4a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2897,32 +2897,41 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	return ret;
 }
 
-static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp,
-				    u64 *start, u64 *end)
+static bool kvm_mmu_prefetch_sptes(struct kvm_vcpu *vcpu, gfn_t gfn, u64 *sptep,
+				   int nr_pages, unsigned int access)
 {
 	struct page *pages[PTE_PREFETCH_NUM];
 	struct kvm_memory_slot *slot;
-	unsigned int access = sp->role.access;
-	int i, ret;
-	gfn_t gfn;
+	int i;
+
+	if (WARN_ON_ONCE(nr_pages > PTE_PREFETCH_NUM))
+		return false;
 
-	gfn = kvm_mmu_page_get_gfn(sp, spte_index(start));
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
 	if (!slot)
-		return -1;
+		return false;
 
-	ret = kvm_prefetch_pages(slot, gfn, pages, end - start);
-	if (ret <= 0)
-		return -1;
+	nr_pages = kvm_prefetch_pages(slot, gfn, pages, nr_pages);
+	if (nr_pages <= 0)
+		return false;
 
-	for (i = 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, slot, start, access, gfn,
+	for (i = 0; i < nr_pages; i++, gfn++, sptep++) {
+		mmu_set_spte(vcpu, slot, sptep, access, gfn,
 			     page_to_pfn(pages[i]), NULL);
 		kvm_release_page_clean(pages[i]);
 	}
 
-	return 0;
+	return true;
+}
+
+static bool direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
+				     struct kvm_mmu_page *sp,
+				     u64 *start, u64 *end)
+{
+	gfn_t gfn = kvm_mmu_page_get_gfn(sp, spte_index(start));
+	unsigned int access = sp->role.access;
+
+	return kvm_mmu_prefetch_sptes(vcpu, gfn, start, end - start, access);
 }
 
 static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
@@ -2940,8 +2949,9 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 		if (is_shadow_present_pte(*spte) || spte == sptep) {
 			if (!start)
 				continue;
-			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
+			if (!direct_pte_prefetch_many(vcpu, sp, start, spte))
 				return;
+
 			start = NULL;
 		} else if (!start)
 			start = spte;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b02d0abfca68..e1c2f098d9d5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -533,9 +533,7 @@ static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     u64 *spte, pt_element_t gpte)
 {
-	struct kvm_memory_slot *slot;
 	unsigned pte_access;
-	struct page *page;
 	gfn_t gfn;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
@@ -545,16 +543,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, pte_access & ACC_WRITE_MASK);
-	if (!slot)
-		return false;
-
-	if (kvm_prefetch_pages(slot, gfn, &page, 1) != 1)
-		return false;
-
-	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
-	kvm_release_page_clean(page);
-	return true;
+	return kvm_mmu_prefetch_sptes(vcpu, gfn, spte, 1, pte_access);
 }
 
 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
-- 
2.46.0.rc1.232.g9752f9e123-goog


