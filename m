Return-Path: <kvm+bounces-35227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E56A0A81D
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 10:57:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E23207A40A3
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 09:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4E01B392A;
	Sun, 12 Jan 2025 09:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVXsJV0k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE081B2183
	for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 09:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736675751; cv=none; b=kCN+8mD2OI5nzM1YGksGuFOFYI0v+dz3C6E8v3QqdmNkpF7eXtjcBvhe6Be22XP97sWbFDXpbpgQKiLmXyS5k0qxuOkF2tJzMY+PM++krlYtlKL5zDg5NtI2sb6lTiG6C7oKUX6ZFCC/mvaizyEnIMXrpeEDptgIwWnZqZqfbCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736675751; c=relaxed/simple;
	bh=hLGdHo4tiVX9rnua7cU6TNNXH51b2lPfYTsAAypovsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNDW9tp3EpSoPtKJdVsXZT69zNe9tcTWjgFdgGOL6mxurTR4Fjn3oJyjEnoP+d7c1Gq0zx82//9EwJ8A0ZuS7JCtffgc2hnA3LI2HHwBwKiMx3IEfu7eU7a5KHE290uqoWKNSNm5xLxABhw/DdVf3wOGiflnJiEDr9yAVEK1dz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KVXsJV0k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736675748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oz+x9gnVbLji0IqeGhkpb/XHZ9boA09CCOsisxRXiHY=;
	b=KVXsJV0kPV05jx456PxUUgHBdIM+8atoZrcyGS7a4aYwxD08PZsuKzG16ASYGt3cUroa/a
	LuB921lNbeOzJOBDCYCY/I5E5ICn8pdAJtogVTX+idcohM37v+ngZCxb+0Y5EmlhUnMjm7
	K4hLP7fUal+p5aZlMFFPIMKm9ng/2YI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-TNe7VltMPty86gXRNsGmxg-1; Sun, 12 Jan 2025 04:55:47 -0500
X-MC-Unique: TNe7VltMPty86gXRNsGmxg-1
X-Mimecast-MFC-AGG-ID: TNe7VltMPty86gXRNsGmxg
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5d3f0411814so2848824a12.0
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 01:55:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736675746; x=1737280546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oz+x9gnVbLji0IqeGhkpb/XHZ9boA09CCOsisxRXiHY=;
        b=UFua4NLoyTKJOHBTIXAknhHkNAc+cqHS9b1YHC9McOgnJlBp1z3QA8tv284CIYjPUg
         3m7kl1dUraYZ1IA3OEyqBVp65kRi+x6BLmA9aW+SS7yuX26hJ2F0Mf0gxlZLrxQgrO3a
         e32r4Q+kvtZmwI2SJbEq6cawyIMrTM2/RD9aRryY1EiHnPvt+mJ9F1C+yzw7sp2iLIay
         4UKH2TVl1mfCQm2Hi4Af3GG6JDHmBZlyC+SEZ9vNL3YKcUhm5+Q45BRn1PsM5c1RBiP6
         0/ONqkypVAtky456mfTizB7FodTGvXwkq+Q9D8RY5nCRkXPJ4VH98mZamzJ+64yYVvQ/
         AgmA==
X-Forwarded-Encrypted: i=1; AJvYcCWMhx9Tw/+crjWrXSucU/+O/gtfxB5Qdq12ITlBt3WC1hsyM7FpAQuOO3vhnvdPuqK+dyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyurAF3dkugMkY6DY97ja3vg5jV3XWH4BA1N4imElQxem0VnOSq
	bYKhafNfvj0c+kpieR/Mu2kGT8pVO9nAPLTP8bcAiRQfIuaHiLIEZ6AU4CNe+TVX37nRmIaJvB1
	iW5U9JI9zo8N2bE1iBrl4sTxZh/e4U8W1AmD6GK37/keK/Sw6sA==
X-Gm-Gg: ASbGncu/J1hUrcyQXDIKZXqHFvNz4jImc5Yv/Bp6nh8o4NH11wYvpbx/dBgKYIQsKpC
	iwtpGTrWFunkqQs2UvzZ9sbKGS9/kOJCTXhYOg43zYNc0w/hCZu+JR1frBawocYWhGwJ1GDbIG7
	GfVaTNB5P6oYCSaGOHSS219JAqNH3My5mb8HXqbEs8tvI900QVfzirZHT4koMz+OJDKPmcy7H4n
	f/9f4TNbaoQQ0tT9AGvMlCtpJY1whIhXNEuZ8QVHnVU4ff1J0huSNhtU7A=
X-Received: by 2002:a05:6402:51d0:b0:5d2:7346:3ecb with SMTP id 4fb4d7f45d1cf-5d972e08366mr15294468a12.12.1736675745739;
        Sun, 12 Jan 2025 01:55:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwE26l9isFf3nQZmRGpyTPcP8J8/ysUQYlXL5+4ti/a8bZoN63209mlmD5afvsephqydEaqg==
X-Received: by 2002:a05:6402:51d0:b0:5d2:7346:3ecb with SMTP id 4fb4d7f45d1cf-5d972e08366mr15294450a12.12.1736675745359;
        Sun, 12 Jan 2025 01:55:45 -0800 (PST)
Received: from [192.168.10.3] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9900c3fccsm3491359a12.21.2025.01.12.01.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 01:55:43 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>
Subject: [PATCH 5/5] KVM: e500: perform hugepage check after looking up the PFN
Date: Sun, 12 Jan 2025 10:55:27 +0100
Message-ID: <20250112095527.434998-6-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250112095527.434998-1-pbonzini@redhat.com>
References: <20250112095527.434998-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

e500 KVM tries to bypass __kvm_faultin_pfn() in order to map VM_PFNMAP
VMAs as huge pages.  This is a Bad Idea because VM_PFNMAP VMAs could
become noncontiguous as a result of callsto remap_pfn_range().

Instead, use the already existing host PTE lookup to retrieve a
valid host-side mapping level after __kvm_faultin_pfn() has
returned.  Then find the largest size that will satisfy the
guest's request while staying within a single host PTE.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 178 ++++++++++++-------------------
 1 file changed, 69 insertions(+), 109 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index b38679e5821b..06caf8bbbe2b 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -326,15 +326,14 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	struct tlbe_ref *ref)
 {
 	struct kvm_memory_slot *slot;
-	unsigned long pfn = 0; /* silence GCC warning */
+	unsigned int psize;
+	unsigned long pfn;
 	struct page *page = NULL;
 	unsigned long hva;
-	int pfnmap = 0;
 	int tsize = BOOK3E_PAGESZ_4K;
 	int ret = 0;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu_e500->vcpu.kvm;
-	unsigned long tsize_pages = 0;
 	pte_t *ptep;
 	unsigned int wimg = 0;
 	pgd_t *pgdir;
@@ -356,111 +355,12 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	slot = gfn_to_memslot(vcpu_e500->vcpu.kvm, gfn);
 	hva = gfn_to_hva_memslot(slot, gfn);
 
-	if (tlbsel == 1) {
-		struct vm_area_struct *vma;
-		mmap_read_lock(kvm->mm);
-
-		vma = find_vma(kvm->mm, hva);
-		if (vma && hva >= vma->vm_start &&
-		    (vma->vm_flags & VM_PFNMAP)) {
-			/*
-			 * This VMA is a physically contiguous region (e.g.
-			 * /dev/mem) that bypasses normal Linux page
-			 * management.  Find the overlap between the
-			 * vma and the memslot.
-			 */
-
-			unsigned long start, end;
-			unsigned long slot_start, slot_end;
-
-			pfnmap = 1;
-			writable = vma->vm_flags & VM_WRITE;
-
-			start = vma->vm_pgoff;
-			end = start +
-			      vma_pages(vma);
-
-			pfn = start + ((hva - vma->vm_start) >> PAGE_SHIFT);
-
-			slot_start = pfn - (gfn - slot->base_gfn);
-			slot_end = slot_start + slot->npages;
-
-			if (start < slot_start)
-				start = slot_start;
-			if (end > slot_end)
-				end = slot_end;
-
-			tsize = (gtlbe->mas1 & MAS1_TSIZE_MASK) >>
-				MAS1_TSIZE_SHIFT;
-
-			/*
-			 * e500 doesn't implement the lowest tsize bit,
-			 * or 1K pages.
-			 */
-			tsize = max(BOOK3E_PAGESZ_4K, tsize & ~1);
-
-			/*
-			 * Now find the largest tsize (up to what the guest
-			 * requested) that will cover gfn, stay within the
-			 * range, and for which gfn and pfn are mutually
-			 * aligned.
-			 */
-
-			for (; tsize > BOOK3E_PAGESZ_4K; tsize -= 2) {
-				unsigned long gfn_start, gfn_end;
-				tsize_pages = 1UL << (tsize - 2);
-
-				gfn_start = gfn & ~(tsize_pages - 1);
-				gfn_end = gfn_start + tsize_pages;
-
-				if (gfn_start + pfn - gfn < start)
-					continue;
-				if (gfn_end + pfn - gfn > end)
-					continue;
-				if ((gfn & (tsize_pages - 1)) !=
-				    (pfn & (tsize_pages - 1)))
-					continue;
-
-				gvaddr &= ~((tsize_pages << PAGE_SHIFT) - 1);
-				pfn &= ~(tsize_pages - 1);
-				break;
-			}
-		} else if (vma && hva >= vma->vm_start &&
-			   is_vm_hugetlb_page(vma)) {
-			unsigned long psize = vma_kernel_pagesize(vma);
-
-			tsize = (gtlbe->mas1 & MAS1_TSIZE_MASK) >>
-				MAS1_TSIZE_SHIFT;
-
-			/*
-			 * Take the largest page size that satisfies both host
-			 * and guest mapping
-			 */
-			tsize = min(__ilog2(psize) - 10, tsize);
-
-			/*
-			 * e500 doesn't implement the lowest tsize bit,
-			 * or 1K pages.
-			 */
-			tsize = max(BOOK3E_PAGESZ_4K, tsize & ~1);
-		}
-
-		mmap_read_unlock(kvm->mm);
-	}
-
-	if (likely(!pfnmap)) {
-		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &page);
-		if (is_error_noslot_pfn(pfn)) {
-			if (printk_ratelimit())
-				pr_err("%s: real page not found for gfn %lx\n",
-				       __func__, (long)gfn);
-			return -EINVAL;
-		}
-
-		/* Align guest and physical address to page map boundaries */
-		pfn &= ~(tsize_pages - 1);
-		gvaddr &= ~((tsize_pages << PAGE_SHIFT) - 1);
+	pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &page);
+	if (is_error_noslot_pfn(pfn)) {
+		if (printk_ratelimit())
+			pr_err("%s: real page not found for gfn %lx\n",
+			       __func__, (long)gfn);
+		return -EINVAL;
 	}
 
 	spin_lock(&kvm->mmu_lock);
@@ -478,7 +378,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	 * can't run hence pfn won't change.
 	 */
 	local_irq_save(flags);
-	ptep = find_linux_pte(pgdir, hva, NULL, NULL);
+	ptep = find_linux_pte(pgdir, hva, NULL, &psize);
 	if (ptep) {
 		pte_t pte = READ_ONCE(*ptep);
 
@@ -495,6 +395,66 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	}
 	local_irq_restore(flags);
 
+	if (psize && tlbsel == 1) {
+		unsigned long psize_pages, tsize_pages;
+		unsigned long start, end;
+		unsigned long slot_start, slot_end;
+
+		psize_pages = 1UL << (psize - PAGE_SHIFT);
+		start = pfn & ~(psize_pages - 1);
+		end = start + psize_pages;
+
+		slot_start = pfn - (gfn - slot->base_gfn);
+		slot_end = slot_start + slot->npages;
+
+		if (start < slot_start)
+			start = slot_start;
+		if (end > slot_end)
+			end = slot_end;
+
+		tsize = (gtlbe->mas1 & MAS1_TSIZE_MASK) >>
+			MAS1_TSIZE_SHIFT;
+
+		/*
+		 * Any page size that doesn't satisfy the host mapping
+		 * will fail the start and end tests.
+		 */
+		tsize = min(psize - PAGE_SHIFT + BOOK3E_PAGESZ_4K, tsize);
+
+		/*
+		 * e500 doesn't implement the lowest tsize bit,
+		 * or 1K pages.
+		 */
+		tsize = max(BOOK3E_PAGESZ_4K, tsize & ~1);
+
+		/*
+		 * Now find the largest tsize (up to what the guest
+		 * requested) that will cover gfn, stay within the
+		 * range, and for which gfn and pfn are mutually
+		 * aligned.
+		 */
+
+		for (; tsize > BOOK3E_PAGESZ_4K; tsize -= 2) {
+			unsigned long gfn_start, gfn_end;
+			tsize_pages = 1UL << (tsize - 2);
+
+			gfn_start = gfn & ~(tsize_pages - 1);
+			gfn_end = gfn_start + tsize_pages;
+
+			if (gfn_start + pfn - gfn < start)
+				continue;
+			if (gfn_end + pfn - gfn > end)
+				continue;
+			if ((gfn & (tsize_pages - 1)) !=
+			    (pfn & (tsize_pages - 1)))
+				continue;
+
+			gvaddr &= ~((tsize_pages << PAGE_SHIFT) - 1);
+			pfn &= ~(tsize_pages - 1);
+			break;
+		}
+	}
+
 	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg, writable);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
-- 
2.47.1


