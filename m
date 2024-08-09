Return-Path: <kvm+bounces-23724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 925FF94D455
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10A221F22AC6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C837519E7EB;
	Fri,  9 Aug 2024 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EDJ3sZfv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838BA19DF8D
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219795; cv=none; b=sczpQ/YF70Ya//j69s5a5QgNVTNHAKnpJgSThFzOixo/RAQQ49orQKMJ0EocyUlrQmn5Y2ptyj6T4S8Ym+9bhRTLajSDGaBEgeSi9cPOSYbUW66oY3jiKFxoYFsLUYORwxrenTSAA13cL20dx5uig30CdJuShhK7jrIZ8UvKgcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219795; c=relaxed/simple;
	bh=jYEp23FOIF/6kH+o3wuOpGOrvsbC/NmaM2/0jhGYsK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZcmAUz+GVsM+BibuQchJRnESSUGwl6j1hy4qAFKC+bZGtiJB6GMkp3VWB4ueiFE50uE0ZANVI1/gAx1vSVjRzyXapwv6XOX2VOzlxDZ5fuc67s2AGCLf0Lk9OBREus3ULBBZOwzjrHbdjFeUQ1We1ZN5NZWQoH/yh0h3vL4ysU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EDJ3sZfv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQ5uhZ2uiWdH1/UlOzJ8LVGX9FzFBDg5i1FarWNBfgY=;
	b=EDJ3sZfvJOAoL/XjHxfXyGwrwHufTelKwswGuzgdGQNDGqDvEmTEjKkt5yPmvTfZRw0OMA
	nMRUy+wOJqvy1geBhF/abXLGjZwRAxr7ZWLUgQGN/qt+P9zGa+OOAO+tkiIic05B7BY0DP
	H8I2wpa7K/VwKVGN0bH6/TRCwlg09lQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-YcosiXs-OXyHZjt4TVJ9aw-1; Fri, 09 Aug 2024 12:09:51 -0400
X-MC-Unique: YcosiXs-OXyHZjt4TVJ9aw-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-44fe28cd027so3758561cf.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219791; x=1723824591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQ5uhZ2uiWdH1/UlOzJ8LVGX9FzFBDg5i1FarWNBfgY=;
        b=OgJrEPLPSBhFwZQlm2EwBEcXvImPKOHuT4c4q7aUjU2LFS2KzR3G7zMd3VIcxfNWFZ
         PlfwQ3nukIXZZ7c/mEef5jm1Cy/jFpEUZ7PHLuC6Fq4/4ccSAyE44QzIfCFePVJ41Q0W
         HUkvun32JHmBMRhwSchUzhZLaaXO/lIewtkXY9mAbGoFmW9lV36tR7s9jtKE4jpLPPtz
         kF2+jt3PI5G+87hWu8gcnPaHSdXGfgHbBx7Rhvb+JbSJw1dxSxyOqEaRixmuCdsOZLmi
         7/UUGLq0JVAL9l5/Ejl4q0p+sVcZiSnHsNizr+F6QY8HRb9E/LaYnupG0z4wr6xwDfGA
         DCLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCiY3VA5HmbcYE/0M52QVsa+NcZMD4F7F0vBUcOHTn7QuSL/7JC+j3H1ZQncv13iE6+9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgVmdzMrkKUDLDjGzTPHmuP2H8fhk6YOmR/cnEk0Mrdq7mbnm7
	sUBtLS5eTXG/ze01JeJ2rmwDGDog0N+AtiGdYdX+dbMncJbA9NxxR/PqTWKVhL7gH3yw2+bEKSd
	dWNUSzN2XYgAtoYby+RhmmqoCB8jsRa5C3ORYLaZXL5o+7QqPVw==
X-Received: by 2002:a05:622a:412:b0:444:b935:ebb5 with SMTP id d75a77b69052e-45312359fbcmr13373571cf.0.1723219790803;
        Fri, 09 Aug 2024 09:09:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2UCzm8Bb1pveediLGLwWSJm3e36K8ZWtfh9bSQqsAnCTBAfRwieQENSqzRtCTpHEz3lk41Q==
X-Received: by 2002:a05:622a:412:b0:444:b935:ebb5 with SMTP id d75a77b69052e-45312359fbcmr13373301cf.0.1723219790408;
        Fri, 09 Aug 2024 09:09:50 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:49 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	peterx@redhat.com,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 16/19] mm: Remove follow_pte()
Date: Fri,  9 Aug 2024 12:09:06 -0400
Message-ID: <20240809160909.1023470-17-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240809160909.1023470-1-peterx@redhat.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

follow_pte() users have been converted to follow_pfnmap*().  Remove the
API.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h |  2 --
 mm/memory.c        | 73 ----------------------------------------------
 2 files changed, 75 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7471302658af..c5949b8052c6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2369,8 +2369,6 @@ void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_pte(struct vm_area_struct *vma, unsigned long address,
-	       pte_t **ptepp, spinlock_t **ptlp);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
diff --git a/mm/memory.c b/mm/memory.c
index 313c17eedf56..72f61fffdda2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6265,79 +6265,6 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-/**
- * follow_pte - look up PTE at a user virtual address
- * @vma: the memory mapping
- * @address: user virtual address
- * @ptepp: location to store found PTE
- * @ptlp: location to store the lock for the PTE
- *
- * On a successful return, the pointer to the PTE is stored in @ptepp;
- * the corresponding lock is taken and its location is stored in @ptlp.
- *
- * The contents of the PTE are only stable until @ptlp is released using
- * pte_unmap_unlock(). This function will fail if the PTE is non-present.
- * Present PTEs may include PTEs that map refcounted pages, such as
- * anonymous folios in COW mappings.
- *
- * Callers must be careful when relying on PTE content after
- * pte_unmap_unlock(). Especially if the PTE maps a refcounted page,
- * callers must protect against invalidation with MMU notifiers; otherwise
- * access to the PFN at a later point in time can trigger use-after-free.
- *
- * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
- * should be taken for read.
- *
- * This function must not be used to modify PTE content.
- *
- * Return: zero on success, -ve otherwise.
- */
-int follow_pte(struct vm_area_struct *vma, unsigned long address,
-	       pte_t **ptepp, spinlock_t **ptlp)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep;
-
-	mmap_assert_locked(mm);
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
-		goto out;
-
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		goto out;
-
-	pgd = pgd_offset(mm, address);
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto out;
-
-	p4d = p4d_offset(pgd, address);
-	if (p4d_none(*p4d) || unlikely(p4d_bad(*p4d)))
-		goto out;
-
-	pud = pud_offset(p4d, address);
-	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		goto out;
-
-	pmd = pmd_offset(pud, address);
-	VM_BUG_ON(pmd_trans_huge(*pmd));
-
-	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
-	if (!ptep)
-		goto out;
-	if (!pte_present(ptep_get(ptep)))
-		goto unlock;
-	*ptepp = ptep;
-	return 0;
-unlock:
-	pte_unmap_unlock(ptep, *ptlp);
-out:
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(follow_pte);
-
 static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
 				     spinlock_t *lock, pte_t *ptep,
 				     pgprot_t pgprot, unsigned long pfn_base,
-- 
2.45.0


