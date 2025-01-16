Return-Path: <kvm+bounces-35651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 869F6A13922
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:35:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0E2D1689E6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C731DEFC2;
	Thu, 16 Jan 2025 11:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cQ+QznRc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3041DE4E3;
	Thu, 16 Jan 2025 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027252; cv=none; b=A/rDds/I3ZSGY4mdQ9Mvp9Vzx21gAAaLc8XsZvtUjH8QrbMOMF8hwRcqDzHISEpMmWs7A1eCNlWNHNQuOHfDfL39VN35lTkN30SvZsYiKYUGCXJ1HCV3OKGR9Xeb/0emSA1rnv1DbX8HHT82P8clD6QOYxyQXwPvLhsIADGDVQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027252; c=relaxed/simple;
	bh=mg9AUmbS82yTQW1jrAOyWcyAL/Jy8cCiyarUNTrKy14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbUwyD1pKH+Cp675KXGM9nY4FnOvzNt6RyVWh16ytPvlL5Nsjg5XlrjO1MKilTp8AnnKLvrtDkHxY4kuagE/E03EzEi6kqzTm4GDTAIZd7u2QDtgv/g0eBRvfmJYCndsWt+I/8VxNr4SGaoMpykxIhBwBKWas/p0Ve04MjXzmhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cQ+QznRc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G3qSxn005727;
	Thu, 16 Jan 2025 11:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/QdRCDqttvNkTmQtv
	IEp/z4YiAjwq3/P7yJVN9aZpH4=; b=cQ+QznRc9j3KzrhHiUlZ3/rjORZrfwIVj
	vwTyLp54odRVPAVX2YGCu0e4jaZUPQWM4rBpCSCsaCHxXL3b7TX+ipK/aCw3a57w
	hTLXSYVFTfGK4OcDZ0z4IQGHlwV4025XT64L+7VQky6vO9YiAclSeyy8P1m9sWMr
	03xjvUZeyZUyEeXSUeP8BnLET3GPbddZaIouTyuxFQG6VxKJxzKBI1wo1NR8rGOL
	I2T0HOmI92WPuay6AMBjqnHSrgDzDKNqM7Yi+WEq7vMK0a1tOr15DbyvtALMfUwO
	I2Se3Up2vrbooPLmuELk5k8innElT3f+TnKcv5VCxOz/a2R3ih+Pw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkcj0k3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:04 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBOjeu007036;
	Thu, 16 Jan 2025 11:34:04 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkcj0jw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GBI7tR016491;
	Thu, 16 Jan 2025 11:34:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1w7kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBXxQj65143228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:33:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3305020049;
	Thu, 16 Jan 2025 11:33:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1A6D2004D;
	Thu, 16 Jan 2025 11:33:58 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:33:58 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 10/15] KVM: s390: stop using page->index for non-shadow gmaps
Date: Thu, 16 Jan 2025 12:33:50 +0100
Message-ID: <20250116113355.32184-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250116113355.32184-1-imbrenda@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _r_POu4WuQKtnTpL1SvXi827fkvj0Htq
X-Proofpoint-GUID: pIXi35RkUUEQiPPZanofWbgdaJNxB6WA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501160086

The host_to_guest radix tree will now map userspace addresses to guest
addresses, instead of userspace addresses to segment tables.

When segment tables and page tables are needed, they are found using an
additional gmap_table_walk().

This gets rid of all usage of page->index for non-shadow gmaps.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 96 +++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 51 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 12d681b657b4..c0f79c14277e 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -24,8 +24,11 @@
 #include <asm/page.h>
 #include <asm/tlb.h>
 
+#define GADDR_VALID(gaddr) ((gaddr) & 1)
 #define GMAP_SHADOW_FAKE_TABLE 1ULL
 
+static inline unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
+
 static struct page *gmap_alloc_crst(void)
 {
 	struct page *page;
@@ -82,7 +85,6 @@ struct gmap *gmap_alloc(unsigned long limit)
 	page = gmap_alloc_crst();
 	if (!page)
 		goto out_free;
-	page->index = 0;
 	list_add(&page->lru, &gmap->crst_list);
 	table = page_to_virt(page);
 	crst_table_init(table, etype);
@@ -303,7 +305,6 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 		list_add(&page->lru, &gmap->crst_list);
 		*table = __pa(new) | _REGION_ENTRY_LENGTH |
 			(*table & _REGION_ENTRY_TYPE_MASK);
-		page->index = gaddr;
 		page = NULL;
 	}
 	spin_unlock(&gmap->guest_table_lock);
@@ -312,21 +313,23 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 	return 0;
 }
 
-/**
- * __gmap_segment_gaddr - find virtual address from segment pointer
- * @entry: pointer to a segment table entry in the guest address space
- *
- * Returns the virtual address in the guest address space for the segment
- */
-static unsigned long __gmap_segment_gaddr(unsigned long *entry)
+static unsigned long host_to_guest_lookup(struct gmap *gmap, unsigned long vmaddr)
 {
-	struct page *page;
-	unsigned long offset;
+	return (unsigned long)radix_tree_lookup(&gmap->host_to_guest, vmaddr >> PMD_SHIFT);
+}
 
-	offset = (unsigned long) entry / sizeof(unsigned long);
-	offset = (offset & (PTRS_PER_PMD - 1)) * PMD_SIZE;
-	page = pmd_pgtable_page((pmd_t *) entry);
-	return page->index + offset;
+static unsigned long host_to_guest_delete(struct gmap *gmap, unsigned long vmaddr)
+{
+	return (unsigned long)radix_tree_delete(&gmap->host_to_guest, vmaddr >> PMD_SHIFT);
+}
+
+static pmd_t *host_to_guest_pmd_delete(struct gmap *gmap, unsigned long vmaddr,
+				       unsigned long *gaddr)
+{
+	*gaddr = host_to_guest_delete(gmap, vmaddr);
+	if (GADDR_VALID(*gaddr))
+		return (pmd_t *)gmap_table_walk(gmap, *gaddr, 1);
+	return NULL;
 }
 
 /**
@@ -338,16 +341,19 @@ static unsigned long __gmap_segment_gaddr(unsigned long *entry)
  */
 static int __gmap_unlink_by_vmaddr(struct gmap *gmap, unsigned long vmaddr)
 {
-	unsigned long *entry;
+	unsigned long gaddr;
 	int flush = 0;
+	pmd_t *pmdp;
 
 	BUG_ON(gmap_is_shadow(gmap));
 	spin_lock(&gmap->guest_table_lock);
-	entry = radix_tree_delete(&gmap->host_to_guest, vmaddr >> PMD_SHIFT);
-	if (entry) {
-		flush = (*entry != _SEGMENT_ENTRY_EMPTY);
-		*entry = _SEGMENT_ENTRY_EMPTY;
+
+	pmdp = host_to_guest_pmd_delete(gmap, vmaddr, &gaddr);
+	if (pmdp) {
+		flush = (pmd_val(*pmdp) != _SEGMENT_ENTRY_EMPTY);
+		*pmdp = __pmd(_SEGMENT_ENTRY_EMPTY);
 	}
+
 	spin_unlock(&gmap->guest_table_lock);
 	return flush;
 }
@@ -564,7 +570,8 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	spin_lock(&gmap->guest_table_lock);
 	if (*table == _SEGMENT_ENTRY_EMPTY) {
 		rc = radix_tree_insert(&gmap->host_to_guest,
-				       vmaddr >> PMD_SHIFT, table);
+				       vmaddr >> PMD_SHIFT,
+				       (void *)((gaddr & HPAGE_MASK) | 1));
 		if (!rc) {
 			if (pmd_leaf(*pmd)) {
 				*table = (pmd_val(*pmd) &
@@ -1991,7 +1998,6 @@ void ptep_notify(struct mm_struct *mm, unsigned long vmaddr,
 		 pte_t *pte, unsigned long bits)
 {
 	unsigned long offset, gaddr = 0;
-	unsigned long *table;
 	struct gmap *gmap, *sg, *next;
 
 	offset = ((unsigned long) pte) & (255 * sizeof(pte_t));
@@ -1999,12 +2005,9 @@ void ptep_notify(struct mm_struct *mm, unsigned long vmaddr,
 	rcu_read_lock();
 	list_for_each_entry_rcu(gmap, &mm->context.gmap_list, list) {
 		spin_lock(&gmap->guest_table_lock);
-		table = radix_tree_lookup(&gmap->host_to_guest,
-					  vmaddr >> PMD_SHIFT);
-		if (table)
-			gaddr = __gmap_segment_gaddr(table) + offset;
+		gaddr = host_to_guest_lookup(gmap, vmaddr) + offset;
 		spin_unlock(&gmap->guest_table_lock);
-		if (!table)
+		if (!GADDR_VALID(gaddr))
 			continue;
 
 		if (!list_empty(&gmap->children) && (bits & PGSTE_VSIE_BIT)) {
@@ -2064,10 +2067,8 @@ static void gmap_pmdp_clear(struct mm_struct *mm, unsigned long vmaddr,
 	rcu_read_lock();
 	list_for_each_entry_rcu(gmap, &mm->context.gmap_list, list) {
 		spin_lock(&gmap->guest_table_lock);
-		pmdp = (pmd_t *)radix_tree_delete(&gmap->host_to_guest,
-						  vmaddr >> PMD_SHIFT);
+		pmdp = host_to_guest_pmd_delete(gmap, vmaddr, &gaddr);
 		if (pmdp) {
-			gaddr = __gmap_segment_gaddr((unsigned long *)pmdp);
 			pmdp_notify_gmap(gmap, pmdp, gaddr);
 			WARN_ON(pmd_val(*pmdp) & ~(_SEGMENT_ENTRY_HARDWARE_BITS_LARGE |
 						   _SEGMENT_ENTRY_GMAP_UC |
@@ -2111,28 +2112,25 @@ EXPORT_SYMBOL_GPL(gmap_pmdp_csp);
  */
 void gmap_pmdp_idte_local(struct mm_struct *mm, unsigned long vmaddr)
 {
-	unsigned long *entry, gaddr;
+	unsigned long gaddr;
 	struct gmap *gmap;
 	pmd_t *pmdp;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(gmap, &mm->context.gmap_list, list) {
 		spin_lock(&gmap->guest_table_lock);
-		entry = radix_tree_delete(&gmap->host_to_guest,
-					  vmaddr >> PMD_SHIFT);
-		if (entry) {
-			pmdp = (pmd_t *)entry;
-			gaddr = __gmap_segment_gaddr(entry);
+		pmdp = host_to_guest_pmd_delete(gmap, vmaddr, &gaddr);
+		if (pmdp) {
 			pmdp_notify_gmap(gmap, pmdp, gaddr);
-			WARN_ON(*entry & ~(_SEGMENT_ENTRY_HARDWARE_BITS_LARGE |
-					   _SEGMENT_ENTRY_GMAP_UC |
-					   _SEGMENT_ENTRY));
+			WARN_ON(pmd_val(*pmdp) & ~(_SEGMENT_ENTRY_HARDWARE_BITS_LARGE |
+						   _SEGMENT_ENTRY_GMAP_UC |
+						   _SEGMENT_ENTRY));
 			if (MACHINE_HAS_TLB_GUEST)
 				__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE,
 					    gmap->asce, IDTE_LOCAL);
 			else if (MACHINE_HAS_IDTE)
 				__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_LOCAL);
-			*entry = _SEGMENT_ENTRY_EMPTY;
+			*pmdp = __pmd(_SEGMENT_ENTRY_EMPTY);
 		}
 		spin_unlock(&gmap->guest_table_lock);
 	}
@@ -2147,22 +2145,19 @@ EXPORT_SYMBOL_GPL(gmap_pmdp_idte_local);
  */
 void gmap_pmdp_idte_global(struct mm_struct *mm, unsigned long vmaddr)
 {
-	unsigned long *entry, gaddr;
+	unsigned long gaddr;
 	struct gmap *gmap;
 	pmd_t *pmdp;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(gmap, &mm->context.gmap_list, list) {
 		spin_lock(&gmap->guest_table_lock);
-		entry = radix_tree_delete(&gmap->host_to_guest,
-					  vmaddr >> PMD_SHIFT);
-		if (entry) {
-			pmdp = (pmd_t *)entry;
-			gaddr = __gmap_segment_gaddr(entry);
+		pmdp = host_to_guest_pmd_delete(gmap, vmaddr, &gaddr);
+		if (pmdp) {
 			pmdp_notify_gmap(gmap, pmdp, gaddr);
-			WARN_ON(*entry & ~(_SEGMENT_ENTRY_HARDWARE_BITS_LARGE |
-					   _SEGMENT_ENTRY_GMAP_UC |
-					   _SEGMENT_ENTRY));
+			WARN_ON(pmd_val(*pmdp) & ~(_SEGMENT_ENTRY_HARDWARE_BITS_LARGE |
+						   _SEGMENT_ENTRY_GMAP_UC |
+						   _SEGMENT_ENTRY));
 			if (MACHINE_HAS_TLB_GUEST)
 				__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE,
 					    gmap->asce, IDTE_GLOBAL);
@@ -2170,7 +2165,7 @@ void gmap_pmdp_idte_global(struct mm_struct *mm, unsigned long vmaddr)
 				__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_GLOBAL);
 			else
 				__pmdp_csp(pmdp);
-			*entry = _SEGMENT_ENTRY_EMPTY;
+			*pmdp = __pmd(_SEGMENT_ENTRY_EMPTY);
 		}
 		spin_unlock(&gmap->guest_table_lock);
 	}
@@ -2686,7 +2681,6 @@ int s390_replace_asce(struct gmap *gmap)
 	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
-	page->index = 0;
 	table = page_to_virt(page);
 	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
 
-- 
2.47.1


