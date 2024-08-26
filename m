Return-Path: <kvm+bounces-25089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D173395FAD5
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E8B4B21E34
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A7519EEA0;
	Mon, 26 Aug 2024 20:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7DgqhFi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F66B19E7E5
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705059; cv=none; b=cCmjMEC4SVyp6KOQrzNJXLUjaKNoMlJ++s7qB8ASyD+PHUldyjPoiRWaCiwJrIykB1YplX6+jdefYtpOlGJ2IZpTj83sBKVsuHBKD7Lizezt8L0/BsnP6U+AHf9UOyZ0eymkWVQqCKoIdAaUfhnOLuke/FQRXRDD+VeQAqDNigY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705059; c=relaxed/simple;
	bh=OG1HOirCXbGLRvA8SpEinM1gGzP9lRsOJkqbcyKglh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORDZ+8Swn9V+y3K9Ll5Qfv8/JpbgqKAggp6A8pdDrRuN2VjJ83aHLrH8borVP4GRnVM8xGm7R2xGuF2B+K4v5+Qvy/u9fWOSDqM0tuzygDewhhoMCrAsCkDO9V7ksAFxVqLUrGQW9IZTmZwY+FHVclhOA3NJuxLtkXEi/QD6krw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7DgqhFi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XzWn17lHZnGD5Tr66iu6y8/zqhTRy72agTNrtdvxzwE=;
	b=Y7DgqhFiU9py8NcaEACQZfKOvi9JTLUlm3mwv9T3grgx/EUGBfkjCso6/IKeYYRt1HtKXL
	XiVkbLQvNckgR3M9urfRaDThtsuXbTmImGekdIXQxtsDR6+9/byPkPiubIq5wSKrBM6Wgv
	K7xmMZQl073267MLHpqeFDd22o5i3n0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-_fChLC89OyS18BA2mVsauA-1; Mon, 26 Aug 2024 16:44:15 -0400
X-MC-Unique: _fChLC89OyS18BA2mVsauA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7a1dc1e5662so663406385a.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705055; x=1725309855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XzWn17lHZnGD5Tr66iu6y8/zqhTRy72agTNrtdvxzwE=;
        b=DsSsCILTllUdyhuvwdJF344x/2fw/c4OJc58ye1okDIOlGP1jAdLi5q4CuCG2dXfF+
         RGpfbEQ6TRvfSBa4D18b3pClTeYLBGT1puF+1LDjsMa7DvIMrWXTFBM12AgbTgtTndnD
         OJJujP0wOHdScUTKjlYbZr84OAhmy6P9gigBOOfR70rqkJUrieDNVTLjSBmK2AiQ74+8
         iS6TGSQKETVY821+fqtf0/QxMBobNkGJENtWeiLcHzqEfOKigo/nE6wRuFQutAvWjwVX
         mSF40pO/GSVTsuwXUkmfWIojNmszXQrg+cSSVS8xPvLIVaOOjG0N8SgqCLS/WoV+/eYb
         J22g==
X-Forwarded-Encrypted: i=1; AJvYcCUqCUOl2HBP1jDO+SDTGkhF7UPCf7OQUMMNhcgv+sfdGGeYb4RnrddI8E8ghjKosnLIjKw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm6zTEGz19Wmu9kVm/WOvDIWPtRNR3CTGEIKKde8vEDky3rTOI
	afhQRB3pskey46o/Vjbr1QTNqHQ981SttDFiJx48Md7zJB6jin/QF6xPGjuprkmV59lnV7PlGLP
	/jq2NKXeC6iDXVXGCBuS2+NbM5DjgpPDLt7iwYjuMXoeLgSFv5Q==
X-Received: by 2002:a05:620a:408d:b0:7a1:e93c:cd04 with SMTP id af79cd13be357-7a6896e0e1cmr1465304585a.9.1724705054677;
        Mon, 26 Aug 2024 13:44:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4kwi4qTohFBFu7kWFKQGbZI396sZSJGmlCvwBl5XfpN0sU8TboRNIhnEyWXLKkBzi4MYP4w==
X-Received: by 2002:a05:620a:408d:b0:7a1:e93c:cd04 with SMTP id af79cd13be357-7a6896e0e1cmr1465302885a.9.1724705054299;
        Mon, 26 Aug 2024 13:44:14 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:13 -0700 (PDT)
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
Subject: [PATCH v2 09/19] mm: New follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:43 -0400
Message-ID: <20240826204353.2228736-10-peterx@redhat.com>
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

Introduce a pair of APIs to follow pfn mappings to get entry information.
It's very similar to what follow_pte() does before, but different in that
it recognizes huge pfn mappings.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h |  31 ++++++++++
 mm/memory.c        | 150 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d900f15b7650..161d496bfd18 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2373,6 +2373,37 @@ int follow_pte(struct vm_area_struct *vma, unsigned long address,
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
+struct follow_pfnmap_args {
+	/**
+	 * Inputs:
+	 * @vma: Pointer to @vm_area_struct struct
+	 * @address: the virtual address to walk
+	 */
+	struct vm_area_struct *vma;
+	unsigned long address;
+	/**
+	 * Internals:
+	 *
+	 * The caller shouldn't touch any of these.
+	 */
+	spinlock_t *lock;
+	pte_t *ptep;
+	/**
+	 * Outputs:
+	 *
+	 * @pfn: the PFN of the address
+	 * @pgprot: the pgprot_t of the mapping
+	 * @writable: whether the mapping is writable
+	 * @special: whether the mapping is a special mapping (real PFN maps)
+	 */
+	unsigned long pfn;
+	pgprot_t pgprot;
+	bool writable;
+	bool special;
+};
+int follow_pfnmap_start(struct follow_pfnmap_args *args);
+void follow_pfnmap_end(struct follow_pfnmap_args *args);
+
 extern void truncate_pagecache(struct inode *inode, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to);
diff --git a/mm/memory.c b/mm/memory.c
index 93c0c25433d0..0b136c398257 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6173,6 +6173,156 @@ int follow_pte(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(follow_pte);
 
+static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
+				     spinlock_t *lock, pte_t *ptep,
+				     pgprot_t pgprot, unsigned long pfn_base,
+				     unsigned long addr_mask, bool writable,
+				     bool special)
+{
+	args->lock = lock;
+	args->ptep = ptep;
+	args->pfn = pfn_base + ((args->address & ~addr_mask) >> PAGE_SHIFT);
+	args->pgprot = pgprot;
+	args->writable = writable;
+	args->special = special;
+}
+
+static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_LOCKDEP
+	struct address_space *mapping = vma->vm_file->f_mapping;
+
+	if (mapping)
+		lockdep_assert(lockdep_is_held(&vma->vm_file->f_mapping->i_mmap_rwsem) ||
+			       lockdep_is_held(&vma->vm_mm->mmap_lock));
+	else
+		lockdep_assert(lockdep_is_held(&vma->vm_mm->mmap_lock));
+#endif
+}
+
+/**
+ * follow_pfnmap_start() - Look up a pfn mapping at a user virtual address
+ * @args: Pointer to struct @follow_pfnmap_args
+ *
+ * The caller needs to setup args->vma and args->address to point to the
+ * virtual address as the target of such lookup.  On a successful return,
+ * the results will be put into other output fields.
+ *
+ * After the caller finished using the fields, the caller must invoke
+ * another follow_pfnmap_end() to proper releases the locks and resources
+ * of such look up request.
+ *
+ * During the start() and end() calls, the results in @args will be valid
+ * as proper locks will be held.  After the end() is called, all the fields
+ * in @follow_pfnmap_args will be invalid to be further accessed.  Further
+ * use of such information after end() may require proper synchronizations
+ * by the caller with page table updates, otherwise it can create a
+ * security bug.
+ *
+ * If the PTE maps a refcounted page, callers are responsible to protect
+ * against invalidation with MMU notifiers; otherwise access to the PFN at
+ * a later point in time can trigger use-after-free.
+ *
+ * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
+ * should be taken for read, and the mmap semaphore cannot be released
+ * before the end() is invoked.
+ *
+ * This function must not be used to modify PTE content.
+ *
+ * Return: zero on success, negative otherwise.
+ */
+int follow_pfnmap_start(struct follow_pfnmap_args *args)
+{
+	struct vm_area_struct *vma = args->vma;
+	unsigned long address = args->address;
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *lock;
+	pgd_t *pgdp;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
+	pte_t *ptep, pte;
+
+	pfnmap_lockdep_assert(vma);
+
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+		goto out;
+
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		goto out;
+retry:
+	pgdp = pgd_offset(mm, address);
+	if (pgd_none(*pgdp) || unlikely(pgd_bad(*pgdp)))
+		goto out;
+
+	p4dp = p4d_offset(pgdp, address);
+	p4d = READ_ONCE(*p4dp);
+	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
+		goto out;
+
+	pudp = pud_offset(p4dp, address);
+	pud = READ_ONCE(*pudp);
+	if (pud_none(pud))
+		goto out;
+	if (pud_leaf(pud)) {
+		lock = pud_lock(mm, pudp);
+		if (!unlikely(pud_leaf(pud))) {
+			spin_unlock(lock);
+			goto retry;
+		}
+		pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
+				  pud_pfn(pud), PUD_MASK, pud_write(pud),
+				  pud_special(pud));
+		return 0;
+	}
+
+	pmdp = pmd_offset(pudp, address);
+	pmd = pmdp_get_lockless(pmdp);
+	if (pmd_leaf(pmd)) {
+		lock = pmd_lock(mm, pmdp);
+		if (!unlikely(pmd_leaf(pmd))) {
+			spin_unlock(lock);
+			goto retry;
+		}
+		pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
+				  pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
+				  pmd_special(pmd));
+		return 0;
+	}
+
+	ptep = pte_offset_map_lock(mm, pmdp, address, &lock);
+	if (!ptep)
+		goto out;
+	pte = ptep_get(ptep);
+	if (!pte_present(pte))
+		goto unlock;
+	pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
+			  pte_pfn(pte), PAGE_MASK, pte_write(pte),
+			  pte_special(pte));
+	return 0;
+unlock:
+	pte_unmap_unlock(ptep, lock);
+out:
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(follow_pfnmap_start);
+
+/**
+ * follow_pfnmap_end(): End a follow_pfnmap_start() process
+ * @args: Pointer to struct @follow_pfnmap_args
+ *
+ * Must be used in pair of follow_pfnmap_start().  See the start() function
+ * above for more information.
+ */
+void follow_pfnmap_end(struct follow_pfnmap_args *args)
+{
+	if (args->lock)
+		spin_unlock(args->lock);
+	if (args->ptep)
+		pte_unmap(args->ptep);
+}
+EXPORT_SYMBOL_GPL(follow_pfnmap_end);
+
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 /**
  * generic_access_phys - generic implementation for iomem mmap access
-- 
2.45.0


