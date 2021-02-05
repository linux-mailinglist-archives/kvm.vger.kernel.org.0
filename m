Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27B31096A
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhBEKpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 05:45:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231448AbhBEKed (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 05:34:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612521186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mj+Ly1k3UYPGQYxAhZFurZVICdhyrknCRIPzRSnG+Xc=;
        b=SMKf7zFYGkxf0DEFZK6mIWNscDR+sv4T8bs2Q4InrQRiRxH4GCIOnjHGKaZ1sAWWfcOIpf
        CdYtj4k8f7Oftb3VA3WKKNhKiH1TNH9R9Kj3RsNN892ulanNBqFFA4DIBQ8/l04Nnm5fkH
        QE75lY8UuAQOA/tRQzay6V5DVfpHLsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-AFUaxDJtPIKnH-bT7enzFA-1; Fri, 05 Feb 2021 05:33:02 -0500
X-MC-Unique: AFUaxDJtPIKnH-bT7enzFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61A60102C7EE;
        Fri,  5 Feb 2021 10:33:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D832F1050E;
        Fri,  5 Feb 2021 10:33:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jgg@ziepe.ca, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        dan.j.williams@intel.com
Subject: [PATCH 1/2] mm: provide a sane PTE walking API for modules
Date:   Fri,  5 Feb 2021 05:32:58 -0500
Message-Id: <20210205103259.42866-2-pbonzini@redhat.com>
In-Reply-To: <20210205103259.42866-1-pbonzini@redhat.com>
References: <20210205103259.42866-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the follow_pfn function is exported for modules but
follow_pte is not.  However, follow_pfn is very easy to misuse,
because it does not provide protections (so most of its callers
assume the page is writable!) and because it returns after having
already unlocked the page table lock.

Provide instead a simplified version of follow_pte that does
not have the pmdpp and range arguments.  The older version
survives as follow_invalidate_pte() for use by fs/dax.c.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/s390/pci/pci_mmio.c |  2 +-
 fs/dax.c                 |  5 +++--
 include/linux/mm.h       |  6 ++++--
 mm/memory.c              | 35 ++++++++++++++++++++++++++++++-----
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 18f2d10c3176..5922dce94bfd 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -170,7 +170,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
@@ -311,7 +311,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
diff --git a/fs/dax.c b/fs/dax.c
index 26d5dcd2d69e..b14874c7b983 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -810,11 +810,12 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 		address = pgoff_address(index, vma);
 
 		/*
-		 * Note because we provide range to follow_pte it will call
+		 * follow_invalidate_pte() will use the range to call
 		 * mmu_notifier_invalidate_range_start() on our behalf before
 		 * taking any lock.
 		 */
-		if (follow_pte(vma->vm_mm, address, &range, &ptep, &pmdp, &ptl))
+		if (follow_invalidate_pte(vma->vm_mm, address, &range, &ptep,
+					  &pmdp, &ptl))
 			continue;
 
 		/*
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ecdf8a8cd6ae..90b527260edf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1658,9 +1658,11 @@ void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
+int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
+			  struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
+			  spinlock_t **ptlp);
 int follow_pte(struct mm_struct *mm, unsigned long address,
-		struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
-		spinlock_t **ptlp);
+	       pte_t **ptepp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
diff --git a/mm/memory.c b/mm/memory.c
index feff48e1465a..b247d296931c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4709,9 +4709,9 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-int follow_pte(struct mm_struct *mm, unsigned long address,
-	       struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
-	       spinlock_t **ptlp)
+int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
+			  struct mmu_notifier_range *range, pte_t **ptepp,
+			  pmd_t **pmdpp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -4776,6 +4776,31 @@ int follow_pte(struct mm_struct *mm, unsigned long address,
 	return -EINVAL;
 }
 
+/**
+ * follow_pte - look up PTE at a user virtual address
+ * @vma: memory mapping
+ * @address: user virtual address
+ * @ptepp: location to store found PTE
+ * @ptlp: location to store the lock for the PTE
+ *
+ * On a successful return, the pointer to the PTE is stored in @ptepp;
+ * the corresponding lock is taken and its location is stored in @ptlp.
+ * The contents of the PTE are only stable until @ptlp is released;
+ * any further use, if any, must be protected against invalidation
+ * with MMU notifiers.
+ *
+ * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
+ * should be taken for read.
+ *
+ * Return: zero on success, -ve otherwise.
+ */
+int follow_pte(struct mm_struct *mm, unsigned long address,
+	       pte_t **ptepp, spinlock_t **ptlp)
+{
+	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
+}
+EXPORT_SYMBOL_GPL(follow_pte);
+
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
@@ -4796,7 +4821,7 @@ int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		return ret;
 
-	ret = follow_pte(vma->vm_mm, address, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, address, &ptep, &ptl);
 	if (ret)
 		return ret;
 	*pfn = pte_pfn(*ptep);
@@ -4817,7 +4842,7 @@ int follow_phys(struct vm_area_struct *vma,
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out;
 
-	if (follow_pte(vma->vm_mm, address, NULL, &ptep, NULL, &ptl))
+	if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
 		goto out;
 	pte = *ptep;
 
-- 
2.26.2


