Return-Path: <kvm+bounces-25096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E06795FAE6
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E8D7288852
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2F31A08C6;
	Mon, 26 Aug 2024 20:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GLRXzQZt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A381A01BB
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705074; cv=none; b=url4E0M46otMHAJOFluahFk2+2L8Bz228nd3cI6TppxWd1FwhaTeQMytkKXMxsbLS6kjo5zxBsoE1UQ7JwNPmwYl6dynjPpl2sZpTHwXrhAHXEFeVaMcdAFTpcqAqP1lPGQBtFkFHn1z/6mHUSZVwZBsT1WSj71hlp8dA3Y17Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705074; c=relaxed/simple;
	bh=Eh2leUymwhy+QIbtX8/+/NdJiGHoDFC3uu2OHYBcoWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRielPX2pk5bT1oQJQMAHyaDVQX/DHZat/vYAOv6JJ0vXVBMBL0E98OUX3sOB2iyTQRNYAzOMCWPLBuI/EJlH+X9VJ31ztWpp5unOQGeKBn6ubp8Pa6BLUdLcDHOnXoY/3IU6ruRVRqfbsjt5V8A7rvyAGpQF/7Vb/bw5wZAIEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GLRXzQZt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8WHCJ7kNzF2XCQH70BbHdio2suKNHxAf6rhsHMkPbs=;
	b=GLRXzQZtGfDxos/RYkF6U37Ksutcne5zEVq5cZMb/h2eBdKI79hxQoXBOwfNTTSHUoXyHE
	fhf8ifPAPzZlcUkyGU66GaouUN+FRya69xbOO44n0PnMPj6UaRML5iEpE8MxbEQJIIDCdU
	XDjbeHfC1cqSgrSq81hze5JpfT/Amj0=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-etn_Z8nVOgOfYUK9M1_ijA-1; Mon, 26 Aug 2024 16:44:29 -0400
X-MC-Unique: etn_Z8nVOgOfYUK9M1_ijA-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-842f9f7509eso1359979241.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705068; x=1725309868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X8WHCJ7kNzF2XCQH70BbHdio2suKNHxAf6rhsHMkPbs=;
        b=obXMh20bNYR29p6iGFj2Aacbs+0S64OtbkVG5mm00QFaozSg3xQg5vhK6TtXvMTO8K
         SyKRnCRltyBHC5dCiJgNwAhv+Ytl5VXxOq1mE64nGxqal230/jLXSF6gxodvjg3FpIVf
         7j9LyTQmXDuw5fWDlNLc676lXJ+AYyu/CfJZpu3kEp68hMkx7Vfx9OuPjzNIagOAVFYe
         g+mMIyPty3AWO+DnZX7VBTOy9ASAm8jcx0PX1lrp38FM2ghvJ2CqEVPmhyeEs+fQTvg7
         Ymox3UkaTBY27b8p1ijZw8BjNo4TVrYSIzC5lbsZtxr3Az3mdU6qjltLGocmQLbQXBsg
         r4Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUBqRgN+uLy+5068dSUkHPu2LpaBfOjVJuDou2DxzRZ2hOCnFF4SX9DtQwhFvBELGc4HKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRCkAynaQMZ8mr8qs89yweaA3RpJelGx/CVJGevY7kpb6esoRg
	zV0JDnJLyexCROr565nDOnk73oz1kI7uX4h8J1zeZTpX8Lks6+xA7xEOM11uyFTJlQS6WIB+vkj
	AISY3ll3HLeoroJ8rCbVeTE6A1mjToQC+W+STZ82q+UdhG3uQTQ==
X-Received: by 2002:a05:6102:3e94:b0:493:e585:6ce3 with SMTP id ada2fe7eead31-49a3bd1cd83mr1005200137.31.1724705068479;
        Mon, 26 Aug 2024 13:44:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKOe4NKlkU/HSIr+h3CCvXyG5C70MeRvYsCyQPr65oWdFZ+m1iMwzpLlsyBV/cJVa8qCplQQ==
X-Received: by 2002:a05:6102:3e94:b0:493:e585:6ce3 with SMTP id ada2fe7eead31-49a3bd1cd83mr1005176137.31.1724705068153;
        Mon, 26 Aug 2024 13:44:28 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:27 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 16/19] mm: Remove follow_pte()
Date: Mon, 26 Aug 2024 16:43:50 -0400
Message-ID: <20240826204353.2228736-17-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
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
index 161d496bfd18..b31d4bdd65ad 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2368,8 +2368,6 @@ void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_pte(struct vm_area_struct *vma, unsigned long address,
-	       pte_t **ptepp, spinlock_t **ptlp);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
diff --git a/mm/memory.c b/mm/memory.c
index b5d07f493d5d..288f81a8698e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6100,79 +6100,6 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
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


