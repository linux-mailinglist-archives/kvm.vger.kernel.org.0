Return-Path: <kvm+bounces-34815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D65C8A06418
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22A423A5D13
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E39202F70;
	Wed,  8 Jan 2025 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gyjbg6mn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF07200BBE;
	Wed,  8 Jan 2025 18:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360106; cv=none; b=VmQBKkVCuHtdGqV+Dxt6nuttYV/xyzhcmp6klzVIbCZ9QvV75tLXvF7g5V7kzVY4NM4o2RKLB8+QjV+uzZgnEYeHxnZ3WQutzwgWlSMfrWUf7iXXMhM08EWLGdvnpM7tdtH+B/u0Hu/wZyJh+wD2oZNbIgwAD6etXe8Dm79jPSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360106; c=relaxed/simple;
	bh=BazJ50shCic6/AMV/bQhG71QwtcYtx3hYhgyQNSmkfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvFfXl1M/iNOCWpSO9cnvKPD96dfcGTDZClaSY2hoFFWZ6fju7p/B+hW4uBxE9DbD/fFkD5LRP8sP0eTw8VfH3PMl7m5X7b7XgwtKziO8+o82ZbwpqlD0dLmeHznsa1NBD+c+XPmHemhDE3jKN1y70UGEePH70HtCGix9OCrl8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gyjbg6mn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508Ema9V016174;
	Wed, 8 Jan 2025 18:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4xzgjqa4HWBxnCAEB
	D/v9xIv4dQkiMF3xkg/riCVh/4=; b=gyjbg6mngPY4Bnri2bOiBfAeW9JuvY7XI
	BSbgI4QOExRUCvx3oXX5dpsFRFgvaWWTwHhWfWvApr7fd/nTFnTI8DVABG06C2T4
	y3zqJF5hS2zGiESiH44AHwmsDWKGhgYrV5iY1g8SqYZ9XmrfdaRf9T2hhTubGRHp
	BrUuSi/sDJAyPaCJrlt/dI9HvgipL1fYURUX3uH7pdmGcLJ2h7N7Ud3KLEGYAdZN
	Oz2iC1EZuCkTgiO9ulHl85I7lt87lgg/8zgde9SZ38sgKj241T+JEBpZDvPAveln
	RHg2j7lOBrCPy1Y2kK1beso3MH3Y0XnVcLm1VjxquAVjtyRE+fquQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441huc3tqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:59 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508GnOZw013641;
	Wed, 8 Jan 2025 18:14:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygap12f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEsRq38338886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3669A20043;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 091A72004D;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:53 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 09/13] KVM: s390: stop using lists to keep track of used dat tables
Date: Wed,  8 Jan 2025 19:14:47 +0100
Message-ID: <20250108181451.74383-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108181451.74383-1-imbrenda@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TUwDyetiDonrJtqXAVYfIzRJV5B22qsO
X-Proofpoint-GUID: TUwDyetiDonrJtqXAVYfIzRJV5B22qsO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080148

Until now, every dat table allocated to map a guest was put in a
linked list. The page->lru field of struct page was used to keep track
of which pages were being used, and when the gmap is torn down, the
list was walked and all pages freed.

This patch gets rid of the usage of page->lru. Page table are now freed
by recursively walking the dat table tree.

Since s390_unlist_old_asce() becomes useless now, remove it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  3 --
 arch/s390/mm/gmap.c          | 94 +++++++++---------------------------
 2 files changed, 23 insertions(+), 74 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 8637ebbf618a..65d3565b1e86 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -45,7 +45,6 @@
  */
 struct gmap {
 	struct list_head list;
-	struct list_head crst_list;
 	struct mm_struct *mm;
 	struct radix_tree_root guest_to_host;
 	struct radix_tree_root host_to_guest;
@@ -61,7 +60,6 @@ struct gmap {
 	/* Additional data for shadow guest address spaces */
 	struct radix_tree_root host_to_rmap;
 	struct list_head children;
-	struct list_head pt_list;
 	spinlock_t shadow_lock;
 	struct gmap *parent;
 	unsigned long orig_asce;
@@ -143,7 +141,6 @@ int gmap_protect_one(struct gmap *gmap, unsigned long gaddr, int prot, unsigned
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int s390_disable_cow_sharing(void);
-void s390_unlist_old_asce(struct gmap *gmap);
 int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index c0f79c14277e..57a1ee47af73 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -73,9 +73,7 @@ struct gmap *gmap_alloc(unsigned long limit)
 	gmap = kzalloc(sizeof(struct gmap), GFP_KERNEL_ACCOUNT);
 	if (!gmap)
 		goto out;
-	INIT_LIST_HEAD(&gmap->crst_list);
 	INIT_LIST_HEAD(&gmap->children);
-	INIT_LIST_HEAD(&gmap->pt_list);
 	INIT_RADIX_TREE(&gmap->guest_to_host, GFP_KERNEL_ACCOUNT);
 	INIT_RADIX_TREE(&gmap->host_to_guest, GFP_ATOMIC | __GFP_ACCOUNT);
 	INIT_RADIX_TREE(&gmap->host_to_rmap, GFP_ATOMIC | __GFP_ACCOUNT);
@@ -85,7 +83,6 @@ struct gmap *gmap_alloc(unsigned long limit)
 	page = gmap_alloc_crst();
 	if (!page)
 		goto out_free;
-	list_add(&page->lru, &gmap->crst_list);
 	table = page_to_virt(page);
 	crst_table_init(table, etype);
 	gmap->table = table;
@@ -188,6 +185,27 @@ static void gmap_rmap_radix_tree_free(struct radix_tree_root *root)
 	} while (nr > 0);
 }
 
+static void gmap_free_crst(unsigned long *table, bool free_ptes)
+{
+	bool is_segment = (table[0] & _SEGMENT_ENTRY_TYPE_MASK) == 0;
+	int i;
+
+	if (is_segment) {
+		if (!free_ptes)
+			goto out;
+		for (i = 0; i < _CRST_ENTRIES; i++)
+			if (!(table[i] & _SEGMENT_ENTRY_INVALID))
+				page_table_free_pgste(page_ptdesc(phys_to_page(table[i])));
+	} else {
+		for (i = 0; i < _CRST_ENTRIES; i++)
+			if (!(table[i] & _REGION_ENTRY_INVALID))
+				gmap_free_crst(__va(table[i] & PAGE_MASK), free_ptes);
+	}
+
+out:
+	free_pages((unsigned long)table, CRST_ALLOC_ORDER);
+}
+
 /**
  * gmap_free - free a guest address space
  * @gmap: pointer to the guest address space structure
@@ -196,24 +214,17 @@ static void gmap_rmap_radix_tree_free(struct radix_tree_root *root)
  */
 void gmap_free(struct gmap *gmap)
 {
-	struct page *page, *next;
-
 	/* Flush tlb of all gmaps (if not already done for shadows) */
 	if (!(gmap_is_shadow(gmap) && gmap->removed))
 		gmap_flush_tlb(gmap);
 	/* Free all segment & region tables. */
-	list_for_each_entry_safe(page, next, &gmap->crst_list, lru)
-		__free_pages(page, CRST_ALLOC_ORDER);
+	gmap_free_crst(gmap->table, gmap_is_shadow(gmap));
+
 	gmap_radix_tree_free(&gmap->guest_to_host);
 	gmap_radix_tree_free(&gmap->host_to_guest);
 
 	/* Free additional data for a shadow gmap */
 	if (gmap_is_shadow(gmap)) {
-		struct ptdesc *ptdesc, *n;
-
-		/* Free all page tables. */
-		list_for_each_entry_safe(ptdesc, n, &gmap->pt_list, pt_list)
-			page_table_free_pgste(ptdesc);
 		gmap_rmap_radix_tree_free(&gmap->host_to_rmap);
 		/* Release reference to the parent */
 		gmap_put(gmap->parent);
@@ -302,7 +313,6 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 	crst_table_init(new, init);
 	spin_lock(&gmap->guest_table_lock);
 	if (*table & _REGION_ENTRY_INVALID) {
-		list_add(&page->lru, &gmap->crst_list);
 		*table = __pa(new) | _REGION_ENTRY_LENGTH |
 			(*table & _REGION_ENTRY_TYPE_MASK);
 		page = NULL;
@@ -1230,7 +1240,6 @@ static void gmap_unshadow_pgt(struct gmap *sg, unsigned long raddr)
 	__gmap_unshadow_pgt(sg, raddr, __va(pgt));
 	/* Free page table */
 	ptdesc = page_ptdesc(phys_to_page(pgt));
-	list_del(&ptdesc->pt_list);
 	page_table_free_pgste(ptdesc);
 }
 
@@ -1258,7 +1267,6 @@ static void __gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr,
 		__gmap_unshadow_pgt(sg, raddr, __va(pgt));
 		/* Free page table */
 		ptdesc = page_ptdesc(phys_to_page(pgt));
-		list_del(&ptdesc->pt_list);
 		page_table_free_pgste(ptdesc);
 	}
 }
@@ -1288,7 +1296,6 @@ static void gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr)
 	__gmap_unshadow_sgt(sg, raddr, __va(sgt));
 	/* Free segment table */
 	page = phys_to_page(sgt);
-	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
 
@@ -1316,7 +1323,6 @@ static void __gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr,
 		__gmap_unshadow_sgt(sg, raddr, __va(sgt));
 		/* Free segment table */
 		page = phys_to_page(sgt);
-		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
 }
@@ -1346,7 +1352,6 @@ static void gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr)
 	__gmap_unshadow_r3t(sg, raddr, __va(r3t));
 	/* Free region 3 table */
 	page = phys_to_page(r3t);
-	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
 
@@ -1374,7 +1379,6 @@ static void __gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr,
 		__gmap_unshadow_r3t(sg, raddr, __va(r3t));
 		/* Free region 3 table */
 		page = phys_to_page(r3t);
-		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
 }
@@ -1404,7 +1408,6 @@ static void gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr)
 	__gmap_unshadow_r2t(sg, raddr, __va(r2t));
 	/* Free region 2 table */
 	page = phys_to_page(r2t);
-	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
 
@@ -1436,7 +1439,6 @@ static void __gmap_unshadow_r1t(struct gmap *sg, unsigned long raddr,
 		r1t[i] = _REGION1_ENTRY_EMPTY;
 		/* Free region 2 table */
 		page = phys_to_page(r2t);
-		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
 }
@@ -1531,7 +1533,6 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 		 _REGION_ENTRY_TYPE_R1 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= (r2t & _REGION_ENTRY_PROTECT);
-	list_add(&page->lru, &sg->crst_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_REGION_ENTRY_INVALID;
@@ -1615,7 +1616,6 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 		 _REGION_ENTRY_TYPE_R2 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= (r3t & _REGION_ENTRY_PROTECT);
-	list_add(&page->lru, &sg->crst_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_REGION_ENTRY_INVALID;
@@ -1699,7 +1699,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		 _REGION_ENTRY_TYPE_R3 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= sgt & _REGION_ENTRY_PROTECT;
-	list_add(&page->lru, &sg->crst_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_REGION_ENTRY_INVALID;
@@ -1820,7 +1819,6 @@ int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 	/* mark as invalid as long as the parent table is not protected */
 	*table = (unsigned long) s_pgt | _SEGMENT_ENTRY |
 		 (pgt & _SEGMENT_ENTRY_PROTECT) | _SEGMENT_ENTRY_INVALID;
-	list_add(&ptdesc->pt_list, &sg->pt_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_SEGMENT_ENTRY_INVALID;
@@ -2610,49 +2608,6 @@ int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 }
 EXPORT_SYMBOL_GPL(__s390_uv_destroy_range);
 
-/**
- * s390_unlist_old_asce - Remove the topmost level of page tables from the
- * list of page tables of the gmap.
- * @gmap: the gmap whose table is to be removed
- *
- * On s390x, KVM keeps a list of all pages containing the page tables of the
- * gmap (the CRST list). This list is used at tear down time to free all
- * pages that are now not needed anymore.
- *
- * This function removes the topmost page of the tree (the one pointed to by
- * the ASCE) from the CRST list.
- *
- * This means that it will not be freed when the VM is torn down, and needs
- * to be handled separately by the caller, unless a leak is actually
- * intended. Notice that this function will only remove the page from the
- * list, the page will still be used as a top level page table (and ASCE).
- */
-void s390_unlist_old_asce(struct gmap *gmap)
-{
-	struct page *old;
-
-	old = virt_to_page(gmap->table);
-	spin_lock(&gmap->guest_table_lock);
-	list_del(&old->lru);
-	/*
-	 * Sometimes the topmost page might need to be "removed" multiple
-	 * times, for example if the VM is rebooted into secure mode several
-	 * times concurrently, or if s390_replace_asce fails after calling
-	 * s390_remove_old_asce and is attempted again later. In that case
-	 * the old asce has been removed from the list, and therefore it
-	 * will not be freed when the VM terminates, but the ASCE is still
-	 * in use and still pointed to.
-	 * A subsequent call to replace_asce will follow the pointer and try
-	 * to remove the same page from the list again.
-	 * Therefore it's necessary that the page of the ASCE has valid
-	 * pointers, so list_del can work (and do nothing) without
-	 * dereferencing stale or invalid pointers.
-	 */
-	INIT_LIST_HEAD(&old->lru);
-	spin_unlock(&gmap->guest_table_lock);
-}
-EXPORT_SYMBOL_GPL(s390_unlist_old_asce);
-
 /**
  * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
  * @gmap: the gmap whose ASCE needs to be replaced
@@ -2672,8 +2627,6 @@ int s390_replace_asce(struct gmap *gmap)
 	struct page *page;
 	void *table;
 
-	s390_unlist_old_asce(gmap);
-
 	/* Replacing segment type ASCEs would cause serious issues */
 	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
 		return -EINVAL;
@@ -2690,7 +2643,6 @@ int s390_replace_asce(struct gmap *gmap)
 	 * it will be freed when the VM is torn down.
 	 */
 	spin_lock(&gmap->guest_table_lock);
-	list_add(&page->lru, &gmap->crst_list);
 	spin_unlock(&gmap->guest_table_lock);
 
 	/* Set new table origin while preserving existing ASCE control bits */
-- 
2.47.1


