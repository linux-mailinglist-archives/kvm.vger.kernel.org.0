Return-Path: <kvm+bounces-34920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28DE4A077ED
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:43:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 256B81617AC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41564222593;
	Thu,  9 Jan 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YVJLmmvt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F86C2206B9
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736429918; cv=none; b=A1tVShsUg1xExGADyhVJypeq2an1MS6giXwCR4LxfpjELlAgNqxiEX7Y/zZRV9FgJS6+LOtkq0dVbtV+YfmwOjI7wy00vVo1V4LVaJO7MmBmAWXq9DL6W1DkdALzp4gWH3OCB3wOvelySDoE/7uwWe7eySYjtyJXPkCinn8Q+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736429918; c=relaxed/simple;
	bh=P7sSfp0wHvngJJFC7alhWn4VcAvboR/GnnVkh2D7CyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jp3Z23QpgfP/4f0MeasjiWG68Z/S1iy2lhVEOsbcyLDmgAqIQFNOkLp/+O/iL1uYcSibq5q8rpMabPlEVRbEyqaVKuoAXoHUKPKiGBKlxq5XRPNcYnbRpT0Z+Gx+ULLQbuyrM2+YAobtXuqyNTPQGFCjF30IpImviw/bnfQ3HHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YVJLmmvt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736429915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6U5GaYmzSeHIwPHM2TLhTcGPV4HaT+bdvS3rFAmfbSs=;
	b=YVJLmmvtLiaG90URK05B/4L6UHc5Xhop3vVYGy4ncntqkbaJN46HJtSzBIxvBYZIqMJuzX
	m+QmU5M3Wf1dWfTfCPQm8flekRfO7N8Y42DP7w/bZ1MFqVyLweVaJDJkYUudlnnOGPvWyV
	scTAMmlQWpQdGf8DEIKKWZrRwhTDqjk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-yKKacJ_DM7W4uYrrEVR3HQ-1; Thu, 09 Jan 2025 08:38:34 -0500
X-MC-Unique: yKKacJ_DM7W4uYrrEVR3HQ-1
X-Mimecast-MFC-AGG-ID: yKKacJ_DM7W4uYrrEVR3HQ
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5d40c0c728aso685728a12.2
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 05:38:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736429913; x=1737034713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6U5GaYmzSeHIwPHM2TLhTcGPV4HaT+bdvS3rFAmfbSs=;
        b=Yji7FOiwJqB+nj9W+o35t3N4bgG1cNY3UH67P88SckerAvwHPqULZjoEwQKQuNeqLj
         ZtxDY2QFz9bPP99yGwWMk9UnIVH7GLVbeGthHftpNrR/yH93uPg0pzdbVY6/pKX8R45k
         2gtLqmPEllQAnJTRcgfD8PvkPfRxYxLh38BGDmjTwcTtV4rHmab77YI3Y/ICK4kFC7ZY
         gPDnLKoCqgMbSJVoekTlvaemkM6ni93ZzVRjcj7QAEmjUgd3E0UYlbGfpz5MvNMLb0AH
         ARPpbvRA1boTSAxDoRoSFsGA4t+HFKYaTAiNuGEL3lWZSw/EShdrWYOayJUbn34YZrt8
         mcUg==
X-Forwarded-Encrypted: i=1; AJvYcCVKk00fD4ayHKbITvYTviCF4YKiOeGvDODwVO5aTvvRrSGwapl+3fXFezQC5ude5lb+/SQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWvjqDczKffg32hzq1V3SBVlxijIU3C60QTPb7PErR7kB3S/gj
	nYYAoxLj1J+d5eoqBybQC4ljRRupI78NiQcGQHM9iushdEuDkaDbWWYzienhr4mQS2puwvPINhv
	RZT5wXYRFR6cohrKpQumJCb6wTFk9zSfZGVnWghnmY8V3TediJg==
X-Gm-Gg: ASbGncvs2iO7o72NZN9+bkfrt9Uwds70+LpQ1b1A7+A3h3XoNJJM8tWF3yPE/PKFaoM
	RYmQv5QzJA/rw1xP7ivXh3kBpcIkz2W7NLF5KYMg9ue8X7tfb8+wr77ae6Jyz9alQ9AFB/wV4EW
	7MoEmaKA411zYdT4sVlafMLRIgXj9AYLA+nHJpT6m95mYvq1RpHGyFKM7XaJkpt3V0miBZAyHgV
	jR+rtHSRV6Y1ydN6p6Tvz9UpYx1oPslRxO9vJ/M6lAiaFB+BJoIA6pgsIHD
X-Received: by 2002:a05:6402:5251:b0:5d0:bf5e:eb8 with SMTP id 4fb4d7f45d1cf-5d972e63ddfmr13854959a12.23.1736429913102;
        Thu, 09 Jan 2025 05:38:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvrvZyCjR9P8H1XfDQSbpZ1ii019x3nOmgFJfPU4BSjpH27IgNbkbMhVv45gD16B6Iwt+Skw==
X-Received: by 2002:a05:6402:5251:b0:5d0:bf5e:eb8 with SMTP id 4fb4d7f45d1cf-5d972e63ddfmr13854906a12.23.1736429912705;
        Thu, 09 Jan 2025 05:38:32 -0800 (PST)
Received: from [192.168.10.47] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90d6a4csm73856966b.71.2025.01.09.05.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 05:38:32 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oliver.upton@linux.dev,
	Will Deacon <will@kernel.org>,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev
Subject: [PATCH 5/5] KVM: e500: perform hugepage check after looking up the PFN
Date: Thu,  9 Jan 2025 14:38:17 +0100
Message-ID: <20250109133817.314401-6-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109133817.314401-1-pbonzini@redhat.com>
References: <20250109133817.314401-1-pbonzini@redhat.com>
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
 arch/powerpc/kvm/e500_mmu_host.c | 180 ++++++++++++-------------------
 1 file changed, 70 insertions(+), 110 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 7752b7f24c51..0457bbc2526f 100644
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
@@ -361,111 +360,12 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
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
@@ -483,7 +383,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	 * can't run hence pfn won't change.
 	 */
 	local_irq_save(flags);
-	ptep = find_linux_pte(pgdir, hva, NULL, NULL);
+	ptep = find_linux_pte(pgdir, hva, NULL, &psize);
 	if (ptep) {
 		pte_t pte = READ_ONCE(*ptep);
 
@@ -500,6 +400,66 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		}
 	}
 
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


