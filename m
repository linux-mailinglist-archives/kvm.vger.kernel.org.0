Return-Path: <kvm+bounces-36385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A3FA1A611
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:48:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34C94167A29
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFA02144D7;
	Thu, 23 Jan 2025 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sdXQJx3i"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C5D2135D7;
	Thu, 23 Jan 2025 14:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643611; cv=none; b=Yx5oizB7Pj2JtrA1tFWKRyN93nJZuYXNWmxnGUBrHpBN5i4K/hvjmHo1s0muOMdJOaClwB+/p+xFc9sbKFVQkfrfNEJjyr+jmTc2RlisAd8VIqR2wPXMYro//8evASYHiCNYAx6CzlwHxya3Dn7+i54H9FhxhFydCQ0/gssQbSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643611; c=relaxed/simple;
	bh=audRnsOxmoC01B3yXU5Edc03CYcgYpidRPnZvYYFZag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaqdsbAQc2aPyA10Qa+bEAdWMxAhinREQHMddiJ7PC5EAZH0IfnSBJRM7CjBi7C4SrKXfwiVIi1+Ola+W+LYNTayqjJGgtKmauQQ5qK2bm9CQB55vQ6ttHC64tMAFW86SHE4FovDImqCYB22RGuPyS8ep72w3lFgTiNH+hGx3pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sdXQJx3i; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N7XJjE030461;
	Thu, 23 Jan 2025 14:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DimjIr2Zc1ZLpHO7J
	7lJt1ATZjKcGh2Zadum6EoQIB4=; b=sdXQJx3iIit+vsmrI7WenabqT6pkHAvGG
	MKCDPe+HHaby87Q8BLtmM7WGNp+EpVnCZ8wU8Q62w3qAwYXef+ZddlUX7fTkLSQC
	Hju18n7Wo7Yta79cWWwky9ALFR7MpGte/s7mYHAcSONMcWqacesAbxha4Sv5sOiA
	1E4EU4WFtMenTrUX+8YFsGTf9DUjYcjtisKRojNRYECtocOu0dWOyOAlQXxcigZD
	/aLkOv3PfKnh3Dg3vauYfNejwDO3806TxQ97ugeGS8WQDOd7nZ1z6KXL1L3yKo7b
	k0FiBrcRG7TSyVt1YnOl1eohC/vbfZMhHb+Z1wBzV3pOtC0agRAWg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bhfpj06s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:36 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NEOaMu018033;
	Thu, 23 Jan 2025 14:46:35 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bhfpj06p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NDnRrC019223;
	Thu, 23 Jan 2025 14:46:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 448pmsp5g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkVQn16056616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A65F220040;
	Thu, 23 Jan 2025 14:46:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68EE620043;
	Thu, 23 Jan 2025 14:46:31 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:31 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 11/15] KVM: s390: stop using lists to keep track of used dat tables
Date: Thu, 23 Jan 2025 15:46:23 +0100
Message-ID: <20250123144627.312456-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123144627.312456-1-imbrenda@linux.ibm.com>
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HcaCIsV36YIB3bDoZs-1BajXP8N46YBM
X-Proofpoint-ORIG-GUID: f5BrDvwAhYKBY9JZZWzua1O9mjFyPhuW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230108

Until now, every dat table allocated to map a guest was put in a
linked list. The page->lru field of struct page was used to keep track
of which pages were being used, and when the gmap is torn down, the
list was walked and all pages freed.

This patch gets rid of the usage of page->lru. Page tables are now
freed by recursively walking the dat table tree.

Since s390_unlist_old_asce() becomes useless now, remove it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |   5 --
 arch/s390/mm/gmap.c          | 102 ++++++++---------------------------
 arch/s390/mm/pgalloc.c       |   2 -
 3 files changed, 23 insertions(+), 86 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index dbf2329281d2..b489c4589618 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -23,7 +23,6 @@
 /**
  * struct gmap_struct - guest address space
  * @list: list head for the mm->context gmap list
- * @crst_list: list of all crst tables used in the guest address space
  * @mm: pointer to the parent mm_struct
  * @guest_to_host: radix tree with guest to host address translation
  * @host_to_guest: radix tree with pointer to segment table entries
@@ -35,7 +34,6 @@
  * @guest_handle: protected virtual machine handle for the ultravisor
  * @host_to_rmap: radix tree with gmap_rmap lists
  * @children: list of shadow gmap structures
- * @pt_list: list of all page tables used in the shadow guest address space
  * @shadow_lock: spinlock to protect the shadow gmap list
  * @parent: pointer to the parent gmap for shadow guest address spaces
  * @orig_asce: ASCE for which the shadow page table has been created
@@ -45,7 +43,6 @@
  */
 struct gmap {
 	struct list_head list;
-	struct list_head crst_list;
 	struct mm_struct *mm;
 	struct radix_tree_root guest_to_host;
 	struct radix_tree_root host_to_guest;
@@ -61,7 +58,6 @@ struct gmap {
 	/* Additional data for shadow guest address spaces */
 	struct radix_tree_root host_to_rmap;
 	struct list_head children;
-	struct list_head pt_list;
 	spinlock_t shadow_lock;
 	struct gmap *parent;
 	unsigned long orig_asce;
@@ -141,7 +137,6 @@ int gmap_protect_one(struct gmap *gmap, unsigned long gaddr, int prot, unsigned
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int s390_disable_cow_sharing(void);
-void s390_unlist_old_asce(struct gmap *gmap);
 int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 1f83262a5a55..07df1a7b5ebe 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -82,9 +82,7 @@ struct gmap *gmap_alloc(unsigned long limit)
 	gmap = kzalloc(sizeof(struct gmap), GFP_KERNEL_ACCOUNT);
 	if (!gmap)
 		goto out;
-	INIT_LIST_HEAD(&gmap->crst_list);
 	INIT_LIST_HEAD(&gmap->children);
-	INIT_LIST_HEAD(&gmap->pt_list);
 	INIT_RADIX_TREE(&gmap->guest_to_host, GFP_KERNEL_ACCOUNT);
 	INIT_RADIX_TREE(&gmap->host_to_guest, GFP_ATOMIC | __GFP_ACCOUNT);
 	INIT_RADIX_TREE(&gmap->host_to_rmap, GFP_ATOMIC | __GFP_ACCOUNT);
@@ -94,7 +92,6 @@ struct gmap *gmap_alloc(unsigned long limit)
 	page = gmap_alloc_crst();
 	if (!page)
 		goto out_free;
-	list_add(&page->lru, &gmap->crst_list);
 	table = page_to_virt(page);
 	crst_table_init(table, etype);
 	gmap->table = table;
@@ -197,6 +194,27 @@ static void gmap_rmap_radix_tree_free(struct radix_tree_root *root)
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
@@ -205,24 +223,17 @@ static void gmap_rmap_radix_tree_free(struct radix_tree_root *root)
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
@@ -311,7 +322,6 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 	crst_table_init(new, init);
 	spin_lock(&gmap->guest_table_lock);
 	if (*table & _REGION_ENTRY_INVALID) {
-		list_add(&page->lru, &gmap->crst_list);
 		*table = __pa(new) | _REGION_ENTRY_LENGTH |
 			(*table & _REGION_ENTRY_TYPE_MASK);
 		page = NULL;
@@ -1243,7 +1253,6 @@ static void gmap_unshadow_pgt(struct gmap *sg, unsigned long raddr)
 	__gmap_unshadow_pgt(sg, raddr, __va(pgt));
 	/* Free page table */
 	ptdesc = page_ptdesc(phys_to_page(pgt));
-	list_del(&ptdesc->pt_list);
 	page_table_free_pgste(ptdesc);
 }
 
@@ -1271,7 +1280,6 @@ static void __gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr,
 		__gmap_unshadow_pgt(sg, raddr, __va(pgt));
 		/* Free page table */
 		ptdesc = page_ptdesc(phys_to_page(pgt));
-		list_del(&ptdesc->pt_list);
 		page_table_free_pgste(ptdesc);
 	}
 }
@@ -1301,7 +1309,6 @@ static void gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr)
 	__gmap_unshadow_sgt(sg, raddr, __va(sgt));
 	/* Free segment table */
 	page = phys_to_page(sgt);
-	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
 
@@ -1329,7 +1336,6 @@ static void __gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr,
 		__gmap_unshadow_sgt(sg, raddr, __va(sgt));
 		/* Free segment table */
 		page = phys_to_page(sgt);
-		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
 }
@@ -1359,7 +1365,6 @@ static void gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr)
 	__gmap_unshadow_r3t(sg, raddr, __va(r3t));
 	/* Free region 3 table */
 	page = phys_to_page(r3t);
-	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
 
@@ -1387,7 +1392,6 @@ static void __gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr,
 		__gmap_unshadow_r3t(sg, raddr, __va(r3t));
 		/* Free region 3 table */
 		page = phys_to_page(r3t);
-		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
 }
@@ -1417,7 +1421,6 @@ static void gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr)
 	__gmap_unshadow_r2t(sg, raddr, __va(r2t));
 	/* Free region 2 table */
 	page = phys_to_page(r2t);
-	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
 
@@ -1449,7 +1452,6 @@ static void __gmap_unshadow_r1t(struct gmap *sg, unsigned long raddr,
 		r1t[i] = _REGION1_ENTRY_EMPTY;
 		/* Free region 2 table */
 		page = phys_to_page(r2t);
-		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
 }
@@ -1544,7 +1546,6 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 		 _REGION_ENTRY_TYPE_R1 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= (r2t & _REGION_ENTRY_PROTECT);
-	list_add(&page->lru, &sg->crst_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_REGION_ENTRY_INVALID;
@@ -1628,7 +1629,6 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 		 _REGION_ENTRY_TYPE_R2 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= (r3t & _REGION_ENTRY_PROTECT);
-	list_add(&page->lru, &sg->crst_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_REGION_ENTRY_INVALID;
@@ -1712,7 +1712,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		 _REGION_ENTRY_TYPE_R3 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= sgt & _REGION_ENTRY_PROTECT;
-	list_add(&page->lru, &sg->crst_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_REGION_ENTRY_INVALID;
@@ -1833,7 +1832,6 @@ int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 	/* mark as invalid as long as the parent table is not protected */
 	*table = (unsigned long) s_pgt | _SEGMENT_ENTRY |
 		 (pgt & _SEGMENT_ENTRY_PROTECT) | _SEGMENT_ENTRY_INVALID;
-	list_add(&ptdesc->pt_list, &sg->pt_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_SEGMENT_ENTRY_INVALID;
@@ -2623,49 +2621,6 @@ int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
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
@@ -2685,8 +2640,6 @@ int s390_replace_asce(struct gmap *gmap)
 	struct page *page;
 	void *table;
 
-	s390_unlist_old_asce(gmap);
-
 	/* Replacing segment type ASCEs would cause serious issues */
 	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
 		return -EINVAL;
@@ -2697,15 +2650,6 @@ int s390_replace_asce(struct gmap *gmap)
 	table = page_to_virt(page);
 	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
 
-	/*
-	 * The caller has to deal with the old ASCE, but here we make sure
-	 * the new one is properly added to the CRST list, so that
-	 * it will be freed when the VM is torn down.
-	 */
-	spin_lock(&gmap->guest_table_lock);
-	list_add(&page->lru, &gmap->crst_list);
-	spin_unlock(&gmap->guest_table_lock);
-
 	/* Set new table origin while preserving existing ASCE control bits */
 	asce = (gmap->asce & ~_ASCE_ORIGIN) | __pa(table);
 	WRITE_ONCE(gmap->asce, asce);
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index 58696a0c4e4a..e7627bb98bb2 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -173,8 +173,6 @@ unsigned long *page_table_alloc(struct mm_struct *mm)
 	}
 	table = ptdesc_to_virt(ptdesc);
 	__arch_set_page_dat(table, 1);
-	/* pt_list is used by gmap only */
-	INIT_LIST_HEAD(&ptdesc->pt_list);
 	memset64((u64 *)table, _PAGE_INVALID, PTRS_PER_PTE);
 	memset64((u64 *)table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
 	return table;
-- 
2.48.1


