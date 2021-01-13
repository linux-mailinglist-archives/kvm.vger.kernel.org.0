Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB02F2F47DA
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbhAMJmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727351AbhAMJmZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:25 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9X8i9026893;
        Wed, 13 Jan 2021 04:41:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UylKc0NUbhMzd6u0Mo2VbYCORVL1YYgg3OvT4tFfEzo=;
 b=U82NhEP/Te8gtdCtyueIwJ6JtopZ5lRK8FKMh8FvOVN/3XLDir6g/Yf2+LKmbftjSsOZ
 ULAIeXSzUbxIvT/BQ/wL/lRGv+OZqGKyDCInBt6iyMELcU75MoSacuVYPuYROQpANgL1
 Jg+nmpqCsI9GORDDBb7HKU0QlqG+knLtifU+T1rtigUbUaVfg2Icc2ZyIFKP2KzW27Ht
 NbNLWvDP1/Ro6Q7/KyBGbbPtuGSr0E9ceqU951el0PSmejWjmN0GrShr0IKVbsG8aE78
 rYp1ShLbAxCwju+UMSjhBAJ+SahSR0jA1d5uu3FMx61V2/BsOycUgJkXL8IJsiaMtB81 IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361w5sajsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9Xa2a028356;
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361w5sajrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9SJNQ001175;
        Wed, 13 Jan 2021 09:41:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448cuyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fVgL32244114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 601B0A4040;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EF32A4057;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 04/14] s390/mm: split huge pages in GMAP when protecting
Date:   Wed, 13 Jan 2021 09:41:03 +0000
Message-Id: <20210113094113.133668-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 bulkscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dirty tracking, vsie protection and lowcore invalidation notification
are best done on the smallest page size available to avoid unnecessary
flushing and table management operations.

Hence we now split huge pages and introduce a page table if a
notification bit is set or memory is protected via gmap_protect_range
or gmap_protect_rmap.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h    |  18 +++
 arch/s390/include/asm/pgtable.h |   3 +
 arch/s390/mm/gmap.c             | 247 +++++++++++++++++++++++++-------
 arch/s390/mm/pgtable.c          |  33 +++++
 4 files changed, 251 insertions(+), 50 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 40264f60b0da..a5711c189018 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -19,6 +19,11 @@
 /* Status bits only for huge segment entries */
 #define _SEGMENT_ENTRY_GMAP_IN		0x8000	/* invalidation notify bit */
 #define _SEGMENT_ENTRY_GMAP_UC		0x4000	/* dirty (migration) */
+/* Status bits in the gmap segment entry. */
+#define _SEGMENT_ENTRY_GMAP_SPLIT	0x0001  /* split huge pmd */
+
+#define GMAP_SEGMENT_STATUS_BITS (_SEGMENT_ENTRY_GMAP_UC | _SEGMENT_ENTRY_GMAP_SPLIT)
+#define GMAP_SEGMENT_NOTIFY_BITS _SEGMENT_ENTRY_GMAP_IN
 
 /**
  * struct gmap_struct - guest address space
@@ -62,6 +67,8 @@ struct gmap {
 	struct radix_tree_root host_to_rmap;
 	struct list_head children;
 	struct list_head pt_list;
+	struct list_head split_list;
+	spinlock_t split_list_lock;
 	spinlock_t shadow_lock;
 	struct gmap *parent;
 	unsigned long orig_asce;
@@ -102,6 +109,17 @@ static inline int gmap_is_shadow(struct gmap *gmap)
 	return !!gmap->parent;
 }
 
+/**
+ * gmap_pmd_is_split - Returns if a huge gmap pmd has been split.
+ * @pmdp: pointer to the pmd
+ *
+ * Returns true if the passed huge gmap pmd has been split.
+ */
+static inline bool gmap_pmd_is_split(pmd_t *pmdp)
+{
+	return !!(pmd_val(*pmdp) & _SEGMENT_ENTRY_GMAP_SPLIT);
+}
+
 struct gmap *gmap_create(struct mm_struct *mm, unsigned long limit);
 void gmap_remove(struct gmap *gmap);
 struct gmap *gmap_get(struct gmap *gmap);
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b1643afe1a00..6d6ad508f9c7 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1147,6 +1147,9 @@ int ptep_shadow_pte(struct mm_struct *mm, unsigned long saddr,
 		    pte_t *sptep, pte_t *tptep, pte_t pte);
 void ptep_unshadow_pte(struct mm_struct *mm, unsigned long saddr, pte_t *ptep);
 
+unsigned long ptep_get_and_clear_notification_bits(pte_t *ptep);
+void ptep_remove_protection_split(struct mm_struct *mm, pte_t *ptep,
+				  unsigned long gaddr);
 bool ptep_test_and_clear_uc(struct mm_struct *mm, unsigned long address,
 			    pte_t *ptep);
 int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index c38f49dedf35..41a5bbbc59e6 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -62,11 +62,13 @@ static struct gmap *gmap_alloc(unsigned long limit)
 	INIT_LIST_HEAD(&gmap->crst_list);
 	INIT_LIST_HEAD(&gmap->children);
 	INIT_LIST_HEAD(&gmap->pt_list);
+	INIT_LIST_HEAD(&gmap->split_list);
 	INIT_RADIX_TREE(&gmap->guest_to_host, GFP_KERNEL_ACCOUNT);
 	INIT_RADIX_TREE(&gmap->host_to_guest, GFP_ATOMIC | __GFP_ACCOUNT);
 	INIT_RADIX_TREE(&gmap->host_to_rmap, GFP_ATOMIC | __GFP_ACCOUNT);
 	spin_lock_init(&gmap->guest_table_lock);
 	spin_lock_init(&gmap->shadow_lock);
+	spin_lock_init(&gmap->split_list_lock);
 	refcount_set(&gmap->ref_count, 1);
 	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
@@ -193,6 +195,10 @@ static void gmap_free(struct gmap *gmap)
 	gmap_radix_tree_free(&gmap->guest_to_host);
 	gmap_radix_tree_free(&gmap->host_to_guest);
 
+	/* Free split pmd page tables */
+	list_for_each_entry_safe(page, next, &gmap->split_list, lru)
+		page_table_free_pgste(page);
+
 	/* Free additional data for a shadow gmap */
 	if (gmap_is_shadow(gmap)) {
 		/* Free all page tables. */
@@ -547,6 +553,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	pud_t *pud;
 	pmd_t *pmd;
 	u64 unprot;
+	pte_t *ptep;
 	int rc;
 
 	BUG_ON(gmap_is_shadow(gmap));
@@ -597,9 +604,15 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	rc = radix_tree_preload(GFP_KERNEL_ACCOUNT);
 	if (rc)
 		return rc;
+	/*
+	 * do_exception() does remove the pte index for huge
+	 * pages, so we need to re-add it here to work on the
+	 * correct pte.
+	 */
+	vmaddr = vmaddr | (gaddr & ~PMD_MASK);
 	ptl = pmd_lock(mm, pmd);
-	spin_lock(&gmap->guest_table_lock);
 	if (*table == _SEGMENT_ENTRY_EMPTY) {
+		spin_lock(&gmap->guest_table_lock);
 		rc = radix_tree_insert(&gmap->host_to_guest,
 				       vmaddr >> PMD_SHIFT, table);
 		if (!rc) {
@@ -611,14 +624,24 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 				*table = pmd_val(*pmd) &
 					_SEGMENT_ENTRY_HARDWARE_BITS;
 		}
+		spin_unlock(&gmap->guest_table_lock);
 	} else if (*table & _SEGMENT_ENTRY_PROTECT &&
 		   !(pmd_val(*pmd) & _SEGMENT_ENTRY_PROTECT)) {
 		unprot = (u64)*table;
 		unprot &= ~_SEGMENT_ENTRY_PROTECT;
 		unprot |= _SEGMENT_ENTRY_GMAP_UC;
 		gmap_pmdp_xchg(gmap, (pmd_t *)table, __pmd(unprot), gaddr);
+	} else if (gmap_pmd_is_split((pmd_t *)table)) {
+		/*
+		 * Split pmds are somewhere in-between a normal and a
+		 * large pmd. As we don't share the page table, the
+		 * host does not remove protection on a fault and we
+		 * have to do it ourselves for the guest mapping.
+		 */
+		ptep = pte_offset_map((pmd_t *)table, vmaddr);
+		if (pte_val(*ptep) & _PAGE_PROTECT)
+			ptep_remove_protection_split(mm, ptep, vmaddr);
 	}
-	spin_unlock(&gmap->guest_table_lock);
 	spin_unlock(ptl);
 	radix_tree_preload_end();
 	return rc;
@@ -860,7 +883,7 @@ static pte_t *gmap_pte_op_walk(struct gmap *gmap, unsigned long gaddr,
 }
 
 /**
- * gmap_pte_op_fixup - force a page in and connect the gmap page table
+ * gmap_fixup - force memory in and connect the gmap table entry
  * @gmap: pointer to guest mapping meta data structure
  * @gaddr: virtual address in the guest address space
  * @vmaddr: address in the host process address space
@@ -868,10 +891,10 @@ static pte_t *gmap_pte_op_walk(struct gmap *gmap, unsigned long gaddr,
  *
  * Returns 0 if the caller can retry __gmap_translate (might fail again),
  * -ENOMEM if out of memory and -EFAULT if anything goes wrong while fixing
- * up or connecting the gmap page table.
+ * up or connecting the gmap table entry.
  */
-static int gmap_pte_op_fixup(struct gmap *gmap, unsigned long gaddr,
-			     unsigned long vmaddr, int prot)
+static int gmap_fixup(struct gmap *gmap, unsigned long gaddr,
+		      unsigned long vmaddr, int prot)
 {
 	struct mm_struct *mm = gmap->mm;
 	unsigned int fault_flags;
@@ -957,6 +980,76 @@ static inline void gmap_pmd_op_end(spinlock_t *ptl)
 		spin_unlock(ptl);
 }
 
+static pte_t *gmap_pte_from_pmd(struct gmap *gmap, pmd_t *pmdp,
+				unsigned long addr, spinlock_t **ptl)
+{
+	*ptl = NULL;
+	if (likely(!gmap_pmd_is_split(pmdp)))
+		return pte_alloc_map_lock(gmap->mm, pmdp, addr, ptl);
+
+	return pte_offset_map(pmdp, addr);
+}
+
+/**
+ * gmap_pmd_split_free - Free a split pmd's page table
+ * @pmdp The split pmd that we free of its page table
+ *
+ * If the userspace pmds are exchanged, we'll remove the gmap pmds as
+ * well, so we fault on them and link them again. We would leak
+ * memory, if we didn't free split pmds here.
+ */
+static inline void gmap_pmd_split_free(struct gmap *gmap, pmd_t *pmdp)
+{
+	unsigned long pgt = pmd_val(*pmdp) & _SEGMENT_ENTRY_ORIGIN;
+	struct page *page;
+
+	if (gmap_pmd_is_split(pmdp)) {
+		page = pfn_to_page(pgt >> PAGE_SHIFT);
+		spin_lock(&gmap->split_list_lock);
+		list_del(&page->lru);
+		spin_unlock(&gmap->split_list_lock);
+		page_table_free_pgste(page);
+	}
+}
+
+/**
+ * gmap_pmd_split - Split a huge gmap pmd and use a page table instead
+ * @gmap: pointer to guest mapping meta data structure
+ * @gaddr: virtual address in the guest address space
+ * @pmdp: pointer to the pmd that will be split
+ * @pgtable: Pre-allocated page table
+ *
+ * When splitting gmap pmds, we have to make the resulting page table
+ * look like it's a normal one to be able to use the common pte
+ * handling functions. Also we need to track these new tables as they
+ * aren't tracked anywhere else.
+ */
+static void gmap_pmd_split(struct gmap *gmap, unsigned long gaddr,
+			   pmd_t *pmdp, struct page *page)
+{
+	unsigned long *ptable = (unsigned long *) page_to_phys(page);
+	pmd_t new;
+	int i;
+
+	for (i = 0; i < 256; i++) {
+		ptable[i] = (pmd_val(*pmdp) & HPAGE_MASK) + i * PAGE_SIZE;
+		/* Carry over hardware permission from the pmd */
+		if (pmd_val(*pmdp) & _SEGMENT_ENTRY_PROTECT)
+			ptable[i] |= _PAGE_PROTECT;
+		/* pmd_large() implies pmd/pte_present() */
+		ptable[i] |=  _PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE;
+		/* ptes are directly marked as dirty */
+		ptable[i + PTRS_PER_PTE] |= PGSTE_UC_BIT;
+	}
+
+	pmd_val(new) = ((unsigned long)ptable | _SEGMENT_ENTRY |
+			(_SEGMENT_ENTRY_GMAP_SPLIT));
+	spin_lock(&gmap->split_list_lock);
+	list_add(&page->lru, &gmap->split_list);
+	spin_unlock(&gmap->split_list_lock);
+	gmap_pmdp_xchg(gmap, pmdp, new, gaddr);
+}
+
 /*
  * gmap_protect_pmd - remove access rights to memory and set pmd notification bits
  * @pmdp: pointer to the pmd to be protected
@@ -1045,7 +1138,8 @@ static int gmap_protect_pte(struct gmap *gmap, unsigned long gaddr,
 static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 			      unsigned long len, int prot, unsigned long bits)
 {
-	unsigned long vmaddr, dist;
+	struct page *page = NULL;
+	unsigned long vmaddr;
 	spinlock_t *ptl_pmd = NULL, *ptl_pte = NULL;
 	pmd_t *pmdp;
 	pte_t *ptep;
@@ -1054,12 +1148,12 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 	BUG_ON(gmap_is_shadow(gmap));
 	while (len) {
 		rc = -EAGAIN;
+
 		pmdp = gmap_pmd_op_walk(gmap, gaddr, &ptl_pmd);
-		if (pmdp) {
+		if (pmdp && !(pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)) {
 			if (!pmd_large(*pmdp)) {
-				ptl_pte = NULL;
-				ptep = pte_alloc_map_lock(gmap->mm, pmdp, gaddr,
-							  &ptl_pte);
+				ptep = gmap_pte_from_pmd(gmap, pmdp, gaddr,
+							 &ptl_pte);
 				if (ptep)
 					rc = gmap_protect_pte(gmap, gaddr,
 							      ptep, prot, bits);
@@ -1071,25 +1165,37 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 					gaddr += PAGE_SIZE;
 				}
 			} else {
-				rc = gmap_protect_pmd(gmap, gaddr, pmdp, prot,
-						      bits);
-				if (!rc) {
-					dist = HPAGE_SIZE - (gaddr & ~HPAGE_MASK);
-					len = len < dist ? 0 : len - dist;
-					gaddr = (gaddr & HPAGE_MASK) + HPAGE_SIZE;
+				if (!page) {
+					/* Drop locks for allocation. */
+					gmap_pmd_op_end(ptl_pmd);
+					ptl_pmd = NULL;
+					page = page_table_alloc_pgste(gmap->mm);
+					if (!page)
+						return -ENOMEM;
+					continue;
+				} else {
+					gmap_pmd_split(gmap, gaddr,
+						       pmdp, page);
+					page = NULL;
+					gmap_pmd_op_end(ptl_pmd);
+					continue;
 				}
 			}
 			gmap_pmd_op_end(ptl_pmd);
 		}
+		if (page) {
+			page_table_free_pgste(page);
+			page = NULL;
+		}
 		if (rc) {
-			if (rc == -EINVAL)
+			if (rc == -EINVAL || rc == -ENOMEM)
 				return rc;
 
 			/* -EAGAIN, fixup of userspace mm and gmap */
 			vmaddr = __gmap_translate(gmap, gaddr);
 			if (IS_ERR_VALUE(vmaddr))
 				return vmaddr;
-			rc = gmap_pte_op_fixup(gmap, gaddr, vmaddr, prot);
+			rc = gmap_fixup(gmap, gaddr, vmaddr, prot);
 			if (rc)
 				return rc;
 		}
@@ -1172,7 +1278,7 @@ int gmap_read_table(struct gmap *gmap, unsigned long gaddr, unsigned long *val)
 			rc = vmaddr;
 			break;
 		}
-		rc = gmap_pte_op_fixup(gmap, gaddr, vmaddr, PROT_READ);
+		rc = gmap_fixup(gmap, gaddr, vmaddr, PROT_READ);
 		if (rc)
 			break;
 	}
@@ -1255,7 +1361,7 @@ static int gmap_protect_rmap(struct gmap *sg, unsigned long raddr,
 		radix_tree_preload_end();
 		if (rc) {
 			kfree(rmap);
-			rc = gmap_pte_op_fixup(parent, paddr, vmaddr, PROT_READ);
+			rc = gmap_fixup(parent, paddr, vmaddr, PROT_READ);
 			if (rc)
 				return rc;
 			continue;
@@ -2170,7 +2276,7 @@ int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte)
 		radix_tree_preload_end();
 		if (!rc)
 			break;
-		rc = gmap_pte_op_fixup(parent, paddr, vmaddr, prot);
+		rc = gmap_fixup(parent, paddr, vmaddr, prot);
 		if (rc)
 			break;
 	}
@@ -2236,6 +2342,30 @@ static void gmap_shadow_notify(struct gmap *sg, unsigned long vmaddr,
 	spin_unlock(&sg->guest_table_lock);
 }
 
+/*
+ * ptep_notify_gmap - call all invalidation callbacks for a specific pte of a gmap
+ * @mm: pointer to the process mm_struct
+ * @addr: virtual address in the process address space
+ * @pte: pointer to the page table entry
+ * @bits: bits from the pgste that caused the notify call
+ *
+ * This function is assumed to be called with the guest_table_lock held.
+ */
+static void ptep_notify_gmap(struct gmap *gmap, unsigned long gaddr,
+			     unsigned long vmaddr, unsigned long bits)
+{
+	struct gmap *sg, *next;
+
+	if (!list_empty(&gmap->children) && (bits & PGSTE_VSIE_BIT)) {
+		spin_lock(&gmap->shadow_lock);
+		list_for_each_entry_safe(sg, next, &gmap->children, list)
+			gmap_shadow_notify(sg, vmaddr, gaddr);
+		spin_unlock(&gmap->shadow_lock);
+	}
+	if (bits & PGSTE_IN_BIT)
+		gmap_call_notifier(gmap, gaddr, gaddr + PAGE_SIZE - 1);
+}
+
 /**
  * ptep_notify - call all invalidation callbacks for a specific pte.
  * @mm: pointer to the process mm_struct
@@ -2251,7 +2381,7 @@ void ptep_notify(struct mm_struct *mm, unsigned long vmaddr,
 {
 	unsigned long offset, gaddr = 0;
 	unsigned long *table;
-	struct gmap *gmap, *sg, *next;
+	struct gmap *gmap;
 
 	offset = ((unsigned long) pte) & (255 * sizeof(pte_t));
 	offset = offset * (PAGE_SIZE / sizeof(pte_t));
@@ -2266,23 +2396,34 @@ void ptep_notify(struct mm_struct *mm, unsigned long vmaddr,
 		if (!table)
 			continue;
 
-		if (!list_empty(&gmap->children) && (bits & PGSTE_VSIE_BIT)) {
-			spin_lock(&gmap->shadow_lock);
-			list_for_each_entry_safe(sg, next,
-						 &gmap->children, list)
-				gmap_shadow_notify(sg, vmaddr, gaddr);
-			spin_unlock(&gmap->shadow_lock);
-		}
-		if (bits & PGSTE_IN_BIT)
-			gmap_call_notifier(gmap, gaddr, gaddr + PAGE_SIZE - 1);
+		ptep_notify_gmap(gmap, gaddr, vmaddr, bits);
 	}
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ptep_notify);
 
-static void pmdp_notify_gmap(struct gmap *gmap, pmd_t *pmdp,
-			     unsigned long gaddr)
+static inline void pmdp_notify_split(struct gmap *gmap, pmd_t *pmdp,
+				     unsigned long gaddr, unsigned long vmaddr)
 {
+	int i = 0;
+	unsigned long bits;
+	pte_t *ptep = (pte_t *)(pmd_val(*pmdp) & PAGE_MASK);
+
+	for (; i < 256; i++, gaddr += PAGE_SIZE, vmaddr += PAGE_SIZE, ptep++) {
+		bits = ptep_get_and_clear_notification_bits(ptep);
+		if (bits)
+			ptep_notify_gmap(gmap, gaddr, vmaddr, bits);
+	}
+}
+
+static void pmdp_notify_gmap(struct gmap *gmap, pmd_t *pmdp,
+			     unsigned long gaddr, unsigned long vmaddr)
+{
+	if (gmap_pmd_is_split(pmdp))
+		return pmdp_notify_split(gmap, pmdp, gaddr, vmaddr);
+
+	if (!(pmd_val(*pmdp) & _SEGMENT_ENTRY_GMAP_IN))
+		return;
 	pmd_val(*pmdp) &= ~_SEGMENT_ENTRY_GMAP_IN;
 	gmap_call_notifier(gmap, gaddr, gaddr + HPAGE_SIZE - 1);
 }
@@ -2301,8 +2442,9 @@ static void gmap_pmdp_xchg(struct gmap *gmap, pmd_t *pmdp, pmd_t new,
 			   unsigned long gaddr)
 {
 	gaddr &= HPAGE_MASK;
-	pmdp_notify_gmap(gmap, pmdp, gaddr);
-	pmd_val(new) &= ~_SEGMENT_ENTRY_GMAP_IN;
+	pmdp_notify_gmap(gmap, pmdp, gaddr, 0);
+	if (pmd_large(new))
+		pmd_val(new) &= ~GMAP_SEGMENT_NOTIFY_BITS;
 	if (MACHINE_HAS_TLB_GUEST)
 		__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE, gmap->asce,
 			    IDTE_GLOBAL);
@@ -2327,11 +2469,13 @@ static void gmap_pmdp_clear(struct mm_struct *mm, unsigned long vmaddr,
 						  vmaddr >> PMD_SHIFT);
 		if (pmdp) {
 			gaddr = __gmap_segment_gaddr((unsigned long *)pmdp);
-			pmdp_notify_gmap(gmap, pmdp, gaddr);
-			WARN_ON(pmd_val(*pmdp) & ~(_SEGMENT_ENTRY_HARDWARE_BITS_LARGE |
-						   _SEGMENT_ENTRY_GMAP_UC));
+			pmdp_notify_gmap(gmap, pmdp, gaddr, vmaddr);
+			if (pmd_large(*pmdp))
+				WARN_ON(pmd_val(*pmdp) &
+					GMAP_SEGMENT_NOTIFY_BITS);
 			if (purge)
 				__pmdp_csp(pmdp);
+			gmap_pmd_split_free(gmap, pmdp);
 			pmd_val(*pmdp) = _SEGMENT_ENTRY_EMPTY;
 		}
 		spin_unlock(&gmap->guest_table_lock);
@@ -2381,14 +2525,15 @@ void gmap_pmdp_idte_local(struct mm_struct *mm, unsigned long vmaddr)
 		if (entry) {
 			pmdp = (pmd_t *)entry;
 			gaddr = __gmap_segment_gaddr(entry);
-			pmdp_notify_gmap(gmap, pmdp, gaddr);
-			WARN_ON(*entry & ~(_SEGMENT_ENTRY_HARDWARE_BITS_LARGE |
-					   _SEGMENT_ENTRY_GMAP_UC));
+			pmdp_notify_gmap(gmap, pmdp, gaddr, vmaddr);
+			if (pmd_large(*pmdp))
+				WARN_ON(*entry & GMAP_SEGMENT_NOTIFY_BITS);
 			if (MACHINE_HAS_TLB_GUEST)
 				__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE,
 					    gmap->asce, IDTE_LOCAL);
 			else if (MACHINE_HAS_IDTE)
 				__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_LOCAL);
+			gmap_pmd_split_free(gmap, pmdp);
 			*entry = _SEGMENT_ENTRY_EMPTY;
 		}
 		spin_unlock(&gmap->guest_table_lock);
@@ -2416,9 +2561,9 @@ void gmap_pmdp_idte_global(struct mm_struct *mm, unsigned long vmaddr)
 		if (entry) {
 			pmdp = (pmd_t *)entry;
 			gaddr = __gmap_segment_gaddr(entry);
-			pmdp_notify_gmap(gmap, pmdp, gaddr);
-			WARN_ON(*entry & ~(_SEGMENT_ENTRY_HARDWARE_BITS_LARGE |
-					   _SEGMENT_ENTRY_GMAP_UC));
+			pmdp_notify_gmap(gmap, pmdp, gaddr, vmaddr);
+			if (pmd_large(*pmdp))
+				WARN_ON(*entry & GMAP_SEGMENT_NOTIFY_BITS);
 			if (MACHINE_HAS_TLB_GUEST)
 				__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE,
 					    gmap->asce, IDTE_GLOBAL);
@@ -2426,6 +2571,7 @@ void gmap_pmdp_idte_global(struct mm_struct *mm, unsigned long vmaddr)
 				__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_GLOBAL);
 			else
 				__pmdp_csp(pmdp);
+			gmap_pmd_split_free(gmap, pmdp);
 			*entry = _SEGMENT_ENTRY_EMPTY;
 		}
 		spin_unlock(&gmap->guest_table_lock);
@@ -2476,9 +2622,10 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long bitmap[4],
 	int i;
 	pmd_t *pmdp;
 	pte_t *ptep;
-	spinlock_t *ptl = NULL;
+	spinlock_t *ptl_pmd = NULL;
+	spinlock_t *ptl_pte = NULL;
 
-	pmdp = gmap_pmd_op_walk(gmap, gaddr, &ptl);
+	pmdp = gmap_pmd_op_walk(gmap, gaddr, &ptl_pmd);
 	if (!pmdp)
 		return;
 
@@ -2487,15 +2634,15 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long bitmap[4],
 			bitmap_fill(bitmap, _PAGE_ENTRIES);
 	} else {
 		for (i = 0; i < _PAGE_ENTRIES; i++, vmaddr += PAGE_SIZE) {
-			ptep = pte_alloc_map_lock(gmap->mm, pmdp, vmaddr, &ptl);
+			ptep = gmap_pte_from_pmd(gmap, pmdp, vmaddr, &ptl_pte);
 			if (!ptep)
 				continue;
 			if (ptep_test_and_clear_uc(gmap->mm, vmaddr, ptep))
 				set_bit(i, bitmap);
-			spin_unlock(ptl);
+			gmap_pte_op_end(ptl_pte);
 		}
 	}
-	gmap_pmd_op_end(ptl);
+	gmap_pmd_op_end(ptl_pmd);
 }
 EXPORT_SYMBOL_GPL(gmap_sync_dirty_log_pmd);
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index a0e674a9c70a..16896f936d32 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -739,6 +739,39 @@ void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 	preempt_enable();
 }
 
+unsigned long ptep_get_and_clear_notification_bits(pte_t *ptep)
+{
+	pgste_t pgste;
+	unsigned long bits;
+
+	pgste = pgste_get_lock(ptep);
+	bits = pgste_val(pgste) & (PGSTE_IN_BIT | PGSTE_VSIE_BIT);
+	pgste_val(pgste) ^= bits;
+	pgste_set_unlock(ptep, pgste);
+
+	return bits;
+}
+EXPORT_SYMBOL_GPL(ptep_get_and_clear_notification_bits);
+
+void ptep_remove_protection_split(struct mm_struct *mm, pte_t *ptep,
+				  unsigned long gaddr)
+{
+	pte_t pte;
+	pgste_t pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste_val(pgste) |= PGSTE_UC_BIT;
+	pte = *ptep;
+	pte_val(pte) &= ~_PAGE_PROTECT;
+
+	pgste = pgste_pte_notify(mm, gaddr, ptep, pgste);
+	ptep_ipte_global(mm, gaddr, ptep, 0);
+
+	*ptep = pte;
+	pgste_set_unlock(ptep, pgste);
+}
+EXPORT_SYMBOL_GPL(ptep_remove_protection_split);
+
 /*
  * Test and reset if a guest page is dirty
  */
-- 
2.27.0

