Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AAB356C6B
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352325AbhDGMmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:42:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245644AbhDGMm2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 08:42:28 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137CXJGb100010;
        Wed, 7 Apr 2021 08:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=58CXe0zZy2OcCWJVUTz/tsVYh8CUA9FfDWR2eu9XW+k=;
 b=Kljv2RNcdzL+aBPi1MIRwANc2BusNdgeX7fT4FCek1hTF2ByrlJMnFuWvgXW/4mqL0LI
 T9LIlDYuOq7kflhKqD57SIMNbUJZ9uuD/peEAiUDtZdyuP/l0hsG3Q2BoBNwDjLLxQmc
 g2ycuKkOT6Dm32/aiTnAcX6YZlGEC/44tI9c+Sp6ZT3MQtyJEr/mfhuNTyHQMbPuvYbU
 SlzVfRxS/h24RrqpioT9JygfnzLSSfWmTmTkjBwbQFxDAJv5hvMkozCBKPxX11GI/MVa
 9MKPFTVWWBTKVd/ofJaVC5sm1zSsUE3cCfoFb8eeWtEydoBkHmiuaxcUTUeK1azbRLgQ cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rw7jg9mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 08:42:18 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137CXsmC104091;
        Wed, 7 Apr 2021 08:42:18 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rw7jg9ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 08:42:18 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137CWgdj021634;
        Wed, 7 Apr 2021 12:42:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 37rvmq8c9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 12:42:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137Cfq8w37093758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 12:41:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04CF952054;
        Wed,  7 Apr 2021 12:42:13 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A5F435204F;
        Wed,  7 Apr 2021 12:42:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 6/7] s390x: mmu: add support for large pages
Date:   Wed,  7 Apr 2021 14:42:08 +0200
Message-Id: <20210407124209.828540-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407124209.828540-1-imbrenda@linux.ibm.com>
References: <20210407124209.828540-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XAOwwNpbfmpQwEISJI1LLhI9efCSid4q
X-Proofpoint-ORIG-GUID: diUmVeZXuik4tyvhB8pGytndAOa8YknN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_08:2021-04-07,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for 1M and 2G pages.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/mmu.h |  73 +++++++++++++-
 lib/s390x/mmu.c | 260 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 307 insertions(+), 26 deletions(-)

diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index 603f289e..93208467 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -10,9 +10,78 @@
 #ifndef _ASMS390X_MMU_H_
 #define _ASMS390X_MMU_H_
 
-void protect_page(void *vaddr, unsigned long prot);
+/*
+ * Splits the pagetables down to the given DAT tables level.
+ * Returns a pointer to the DAT table entry of the given level.
+ * @pgtable root of the page table tree
+ * @vaddr address whose page tables are to split
+ * @level 3 (for 2GB pud), 4 (for 1 MB pmd) or 5 (for 4KB pages)
+ */
+void *split_page(pgd_t *pgtable, void *vaddr, unsigned int level);
+
+/*
+ * Applies the given protection bits to the given DAT tables level,
+ * splitting if necessary.
+ * @pgtable root of the page table tree
+ * @vaddr address whose protection bits are to be changed
+ * @prot the protection bits to set
+ * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4KB pages)
+ */
+void protect_dat_entry(void *vaddr, unsigned long prot, unsigned int level);
+/*
+ * Clears the given protection bits from the given DAT tables level,
+ * splitting if necessary.
+ * @pgtable root of the page table tree
+ * @vaddr address whose protection bits are to be changed
+ * @prot the protection bits to clear
+ * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4kB pages)
+ */
+void unprotect_dat_entry(void *vaddr, unsigned long prot, unsigned int level);
+
+/*
+ * Applies the given protection bits to the given 4kB pages range,
+ * splitting if necessary.
+ * @start starting address whose protection bits are to be changed
+ * @len size in bytes
+ * @prot the protection bits to set
+ */
 void protect_range(void *start, unsigned long len, unsigned long prot);
-void unprotect_page(void *vaddr, unsigned long prot);
+/*
+ * Clears the given protection bits from the given 4kB pages range,
+ * splitting if necessary.
+ * @start starting address whose protection bits are to be changed
+ * @len size in bytes
+ * @prot the protection bits to set
+ */
 void unprotect_range(void *start, unsigned long len, unsigned long prot);
 
+/* Similar to install_page, maps the virtual address to the physical address
+ * for the given page tables, using 1MB large pages.
+ * Returns a pointer to the DAT table entry.
+ * @pgtable root of the page table tree
+ * @phys physical address to map, must be 1MB aligned!
+ * @vaddr virtual address to map, must be 1MB aligned!
+ */
+pmdval_t *install_large_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr);
+
+/* Similar to install_page, maps the virtual address to the physical address
+ * for the given page tables, using 2GB huge pages.
+ * Returns a pointer to the DAT table entry.
+ * @pgtable root of the page table tree
+ * @phys physical address to map, must be 2GB aligned!
+ * @vaddr virtual address to map, must be 2GB aligned!
+ */
+pudval_t *install_huge_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr);
+
+static inline void protect_page(void *vaddr, unsigned long prot)
+{
+	protect_dat_entry(vaddr, prot, 5);
+}
+
+static inline void unprotect_page(void *vaddr, unsigned long prot)
+{
+	unprotect_dat_entry(vaddr, prot, 5);
+}
+void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
+
 #endif /* _ASMS390X_MMU_H_ */
diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
index 5c517366..def91334 100644
--- a/lib/s390x/mmu.c
+++ b/lib/s390x/mmu.c
@@ -15,6 +15,18 @@
 #include <vmalloc.h>
 #include "mmu.h"
 
+/*
+ * The naming convention used here is the same as used in the Linux kernel,
+ * and this is the corrispondence between the s390x architectural names and
+ * the Linux ones:
+ *
+ * pgd - region 1 table entry
+ * p4d - region 2 table entry
+ * pud - region 3 table entry
+ * pmd - segment table entry
+ * pte - page table entry
+ */
+
 static pgd_t *table_root;
 
 void configure_dat(int enable)
@@ -46,54 +58,254 @@ static void mmu_enable(pgd_t *pgtable)
 	lc->pgm_new_psw.mask |= PSW_MASK_DAT;
 }
 
-static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
+/*
+ * Get the pud (region 3) DAT table entry for the given address and root,
+ * allocating it if necessary
+ */
+static inline pud_t *get_pud(pgd_t *pgtable, uintptr_t vaddr)
 {
 	pgd_t *pgd = pgd_offset(pgtable, vaddr);
 	p4d_t *p4d = p4d_alloc(pgd, vaddr);
 	pud_t *pud = pud_alloc(p4d, vaddr);
-	pmd_t *pmd = pmd_alloc(pud, vaddr);
-	pte_t *pte = pte_alloc(pmd, vaddr);
 
-	return &pte_val(*pte);
+	return pud;
+}
+
+/*
+ * Get the pmd (segment) DAT table entry for the given address and pud,
+ * allocating it if necessary.
+ * The pud must not be huge.
+ */
+static inline pmd_t *get_pmd(pud_t *pud, uintptr_t vaddr)
+{
+	pmd_t *pmd;
+
+	assert(!pud_huge(*pud));
+	pmd = pmd_alloc(pud, vaddr);
+	return pmd;
+}
+
+/*
+ * Get the pte (page) DAT table entry for the given address and pmd,
+ * allocating it if necessary.
+ * The pmd must not be large.
+ */
+static inline pte_t *get_pte(pmd_t *pmd, uintptr_t vaddr)
+{
+	pte_t *pte;
+
+	assert(!pmd_large(*pmd));
+	pte = pte_alloc(pmd, vaddr);
+	return pte;
+}
+
+/*
+ * Splits a large pmd (segment) DAT table entry into equivalent 4kB small
+ * pages.
+ * @pmd The pmd to split, it must be large.
+ * @va the virtual address corresponding to this pmd.
+ */
+static void split_pmd(pmd_t *pmd, uintptr_t va)
+{
+	phys_addr_t pa = pmd_val(*pmd) & SEGMENT_ENTRY_SFAA;
+	unsigned long i;
+	pte_t *pte;
+
+	assert(pmd_large(*pmd));
+	pte = alloc_pages(PAGE_TABLE_ORDER);
+	for (i = 0; i < PAGE_TABLE_ENTRIES; i++)
+		pte_val(pte[i]) =  pa | PAGE_SIZE * i;
+	idte_pmdp(va, &pmd_val(*pmd));
+	pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;
+
+}
+
+/*
+ * Splits a huge pud (region 3) DAT table entry into equivalent 1MB large
+ * pages.
+ * @pud The pud to split, it must be huge.
+ * @va the virtual address corresponding to this pud.
+ */
+static void split_pud(pud_t *pud, uintptr_t va)
+{
+	phys_addr_t pa = pud_val(*pud) & REGION3_ENTRY_RFAA;
+	unsigned long i;
+	pmd_t *pmd;
+
+	assert(pud_huge(*pud));
+	pmd = alloc_pages(SEGMENT_TABLE_ORDER);
+	for (i = 0; i < SEGMENT_TABLE_ENTRIES; i++)
+		pmd_val(pmd[i]) =  pa | SZ_1M * i | SEGMENT_ENTRY_FC | SEGMENT_ENTRY_TT_SEGMENT;
+	idte_pudp(va, &pud_val(*pud));
+	pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 | REGION_TABLE_LENGTH;
+}
+
+void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level)
+{
+	uintptr_t va = (uintptr_t)vaddr;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	assert(level && (level <= 5));
+	pgd = pgd_offset(pgtable, va);
+	if (level == 1)
+		return pgd;
+	p4d = p4d_alloc(pgd, va);
+	if (level == 2)
+		return p4d;
+	pud = pud_alloc(p4d, va);
+
+	if (level == 3)
+		return pud;
+	if (!pud_none(*pud) && pud_huge(*pud))
+		split_pud(pud, va);
+	pmd = get_pmd(pud, va);
+	if (level == 4)
+		return pmd;
+	if (!pmd_none(*pmd) && pmd_large(*pmd))
+		split_pmd(pmd, va);
+	return get_pte(pmd, va);
+}
+
+void *split_page(pgd_t *pgtable, void *vaddr, unsigned int level)
+{
+	assert((level >= 3) && (level <= 5));
+	return get_dat_entry(pgtable ? pgtable : table_root, vaddr, level);
 }
 
 phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *vaddr)
 {
-	return (*get_pte(pgtable, (uintptr_t)vaddr) & PAGE_MASK) +
-	       ((unsigned long)vaddr & ~PAGE_MASK);
+	uintptr_t va = (uintptr_t)vaddr;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pud = get_pud(pgtable, va);
+	if (pud_huge(*pud))
+		return (pud_val(*pud) & REGION3_ENTRY_RFAA) | (va & ~REGION3_ENTRY_RFAA);
+	pmd = get_pmd(pud, va);
+	if (pmd_large(*pmd))
+		return (pmd_val(*pmd) & SEGMENT_ENTRY_SFAA) | (va & ~SEGMENT_ENTRY_SFAA);
+	pte = get_pte(pmd, va);
+	return (pte_val(*pte) & PAGE_MASK) | (va & ~PAGE_MASK);
+}
+
+/*
+ * Get the DAT table entry of the given level for the given address,
+ * splitting if necessary. If the entry was not invalid, invalidate it, and
+ * return the pointer to the entry and, if requested, its old value.
+ * @pgtable root of the page tables
+ * @vaddr virtual address
+ * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4kB pages)
+ * @old if not NULL, will be written with the old value of the DAT table
+ * entry before invalidation
+ */
+static void *dat_get_and_invalidate(pgd_t *pgtable, void *vaddr, unsigned int level, unsigned long *old)
+{
+	unsigned long va = (unsigned long)vaddr;
+	void *ptr;
+
+	ptr = get_dat_entry(pgtable, vaddr, level);
+	if (old)
+		*old = *(unsigned long *)ptr;
+	if ((level == 1) && !pgd_none(*(pgd_t *)ptr))
+		idte_pgdp(va, ptr);
+	else if ((level == 2) && !p4d_none(*(p4d_t *)ptr))
+		idte_p4dp(va, ptr);
+	else if ((level == 3) && !pud_none(*(pud_t *)ptr))
+		idte_pudp(va, ptr);
+	else if ((level == 4) && !pmd_none(*(pmd_t *)ptr))
+		idte_pmdp(va, ptr);
+	else if (!pte_none(*(pte_t *)ptr))
+		ipte(va, ptr);
+	return ptr;
 }
 
-static pteval_t *set_pte(pgd_t *pgtable, pteval_t val, void *vaddr)
+static void cleanup_pmd(pmd_t *pmd)
 {
-	pteval_t *p_pte = get_pte(pgtable, (uintptr_t)vaddr);
+	/* was invalid or large, nothing to do */
+	if (pmd_none(*pmd) || pmd_large(*pmd))
+		return;
+	/* was not large, free the corresponding page table */
+	free_pages((void *)(pmd_val(*pmd) & PAGE_MASK));
+}
 
-	/* first flush the old entry (if we're replacing anything) */
-	if (!(*p_pte & PAGE_ENTRY_I))
-		ipte((uintptr_t)vaddr, p_pte);
+static void cleanup_pud(pud_t *pud)
+{
+	unsigned long i;
+	pmd_t *pmd;
 
-	*p_pte = val;
-	return p_pte;
+	/* was invalid or large, nothing to do */
+	if (pud_none(*pud) || pud_huge(*pud))
+		return;
+	/* recursively clean up all pmds if needed */
+	pmd = (pmd_t *)(pud_val(*pud) & PAGE_MASK);
+	for (i = 0; i < SEGMENT_TABLE_ENTRIES; i++)
+		cleanup_pmd(pmd + i);
+	/* free the corresponding segment table */
+	free_pages(pmd);
+}
+
+/*
+ * Set the DAT entry for the given level of the given virtual address. If a
+ * mapping already existed, it is overwritten. If an existing mapping with
+ * smaller pages existed, all the lower tables are freed.
+ * Returns the pointer to the DAT table entry.
+ * @pgtable root of the page tables
+ * @val the new value for the DAT table entry
+ * @vaddr the virtual address
+ * @level 3 for pud (region 3), 4 for pmd (segment) and 5 for pte (pages)
+ */
+static void *set_dat_entry(pgd_t *pgtable, unsigned long val, void *vaddr, unsigned int level)
+{
+	unsigned long old, *res;
+
+	res = dat_get_and_invalidate(pgtable, vaddr, level, &old);
+	if (level == 4)
+		cleanup_pmd((pmd_t *)&old);
+	if (level == 3)
+		cleanup_pud((pud_t *)&old);
+	*res = val;
+	return res;
 }
 
 pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
 {
-	return set_pte(pgtable, __pa(phys), vaddr);
+	assert(IS_ALIGNED(phys, PAGE_SIZE));
+	assert(IS_ALIGNED((uintptr_t)vaddr, PAGE_SIZE));
+	return set_dat_entry(pgtable, phys, vaddr, 5);
+}
+
+pmdval_t *install_large_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
+{
+	assert(IS_ALIGNED(phys, SZ_1M));
+	assert(IS_ALIGNED((uintptr_t)vaddr, SZ_1M));
+	return set_dat_entry(pgtable, phys | SEGMENT_ENTRY_FC, vaddr, 4);
+}
+
+pudval_t *install_huge_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
+{
+	assert(IS_ALIGNED(phys, SZ_2G));
+	assert(IS_ALIGNED((uintptr_t)vaddr, SZ_2G));
+	return set_dat_entry(pgtable, phys | REGION3_ENTRY_FC | REGION_ENTRY_TT_REGION3, vaddr, 3);
 }
 
-void protect_page(void *vaddr, unsigned long prot)
+void protect_dat_entry(void *vaddr, unsigned long prot, unsigned int level)
 {
-	pteval_t *p_pte = get_pte(table_root, (uintptr_t)vaddr);
-	pteval_t n_pte = *p_pte | prot;
+	unsigned long old, *ptr;
 
-	set_pte(table_root, n_pte, vaddr);
+	ptr = dat_get_and_invalidate(table_root, vaddr, level, &old);
+	*ptr = old | prot;
 }
 
-void unprotect_page(void *vaddr, unsigned long prot)
+void unprotect_dat_entry(void *vaddr, unsigned long prot, unsigned int level)
 {
-	pteval_t *p_pte = get_pte(table_root, (uintptr_t)vaddr);
-	pteval_t n_pte = *p_pte & ~prot;
+	unsigned long old, *ptr;
 
-	set_pte(table_root, n_pte, vaddr);
+	ptr = dat_get_and_invalidate(table_root, vaddr, level, &old);
+	*ptr = old & ~prot;
 }
 
 void protect_range(void *start, unsigned long len, unsigned long prot)
@@ -102,7 +314,7 @@ void protect_range(void *start, unsigned long len, unsigned long prot)
 
 	len &= PAGE_MASK;
 	for (; len; len -= PAGE_SIZE, curr += PAGE_SIZE)
-		protect_page((void *)curr, prot);
+		protect_dat_entry((void *)curr, prot, 5);
 }
 
 void unprotect_range(void *start, unsigned long len, unsigned long prot)
@@ -111,7 +323,7 @@ void unprotect_range(void *start, unsigned long len, unsigned long prot)
 
 	len &= PAGE_MASK;
 	for (; len; len -= PAGE_SIZE, curr += PAGE_SIZE)
-		unprotect_page((void *)curr, prot);
+		unprotect_dat_entry((void *)curr, prot, 5);
 }
 
 static void setup_identity(pgd_t *pgtable, phys_addr_t start_addr,
-- 
2.26.2

