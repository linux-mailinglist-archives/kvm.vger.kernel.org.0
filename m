Return-Path: <kvm+bounces-36990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B03A23D16
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4192169530
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54211F3D31;
	Fri, 31 Jan 2025 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pBe6nNHQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178A01F37A0;
	Fri, 31 Jan 2025 11:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322736; cv=none; b=OmvFz+D8bWe/sX14i3i5lM8d7/+u2NoLDChsvhNmXLZzCSONoEwMSMBJUGIFkConySzo3P9FRydPWDI2eSY9p+y3HL0JKCtOi3U3bjegcEdpydxS9xHjuffE+PwGOItKxTtAY1tfLmTFh9Da8CUyiE//c7+klbAO0u6XdiG9G1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322736; c=relaxed/simple;
	bh=lZ1e9OHd+eUEkHkPgH7aklZsUqKDbXcoxTEYH0w7KJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOaV6RVW7SRwLZBn44s21ODD7qm+laRanz6ZlSOBhzt3+JBuCNzHWNE9WINrg5ZxnVLn+PFHOyPfZ0Puq+11CO7t8RvaHEmBm7UQjV7J+ErGC02qEjWoHB+pkMRfWKsNWK8MpOu3+cXyari/83G5tl1IdiWMT3RR0jwlen+qkJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pBe6nNHQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2ORHf030636;
	Fri, 31 Jan 2025 11:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zoqiHtOA6GUlQvNN9
	AAnvm1g8AEX0jV4hqOYmLz5i3k=; b=pBe6nNHQOjEKocDV4FD5c970ftx+ujbcL
	NZEdp6py930RdEUFtKy3McBYnrimURL1Ii1zCyxN+orT8cuNSDrOwwRpem8cddHk
	crvHxWZHrsnhM/171MVOd9Xp0l86Kn4j71DvfFcXH3WPyjhK25UxAKypFk/h8SIb
	XPnYjg1weZxUAkt+4IhWq6U7Mhg3SmIZAccqnHDkYbmRlR/Akmc28ELmCu3P5F3C
	n6JMewLXeUqkpliTq8bc0aQkm9ebc7EXZRYTTczirI35OYcPiiQrA2hNf2vQ5Avj
	AvP+iXrvBUI/vABgACD3Yh4IaGagYNUCOeGC70JTF+aEkSdlZMn3A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gfn5b8sy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:31 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8Keud010260;
	Fri, 31 Jan 2025 11:25:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gfa0k950-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:30 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPRXg55836968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C4B12012F;
	Fri, 31 Jan 2025 11:25:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B1A3220133;
	Fri, 31 Jan 2025 11:25:25 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:25 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 14/20] KVM: s390: stop using page->index for non-shadow gmaps
Date: Fri, 31 Jan 2025 12:25:04 +0100
Message-ID: <20250131112510.48531-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m2m6LIh9SHAAOZFizZ9dC0vegs5gIj6o
X-Proofpoint-GUID: m2m6LIh9SHAAOZFizZ9dC0vegs5gIj6o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2501310083

The host_to_guest radix tree will now map userspace addresses to guest
addresses, instead of userspace addresses to segment tables.

When segment tables and page tables are needed, they are found using an
additional gmap_table_walk().

This gets rid of all usage of page->index for non-shadow gmaps.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-11-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-11-imbrenda@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 105 +++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 51 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index ae71b401312b..1f83262a5a55 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -24,8 +24,20 @@
 #include <asm/page.h>
 #include <asm/tlb.h>
 
+/*
+ * The address is saved in a radix tree directly; NULL would be ambiguous,
+ * since 0 is a valid address, and NULL is returned when nothing was found.
+ * The lower bits are ignored by all users of the macro, so it can be used
+ * to distinguish a valid address 0 from a NULL.
+ */
+#define VALID_GADDR_FLAG 1
+#define IS_GADDR_VALID(gaddr) ((gaddr) & VALID_GADDR_FLAG)
+#define MAKE_VALID_GADDR(gaddr) (((gaddr) & HPAGE_MASK) | VALID_GADDR_FLAG)
+
 #define GMAP_SHADOW_FAKE_TABLE 1ULL
 
+static inline unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
+
 static struct page *gmap_alloc_crst(void)
 {
 	struct page *page;
@@ -82,7 +94,6 @@ struct gmap *gmap_alloc(unsigned long limit)
 	page = gmap_alloc_crst();
 	if (!page)
 		goto out_free;
-	page->index = 0;
 	list_add(&page->lru, &gmap->crst_list);
 	table = page_to_virt(page);
 	crst_table_init(table, etype);
@@ -303,7 +314,6 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 		list_add(&page->lru, &gmap->crst_list);
 		*table = __pa(new) | _REGION_ENTRY_LENGTH |
 			(*table & _REGION_ENTRY_TYPE_MASK);
-		page->index = gaddr;
 		page = NULL;
 	}
 	spin_unlock(&gmap->guest_table_lock);
@@ -312,21 +322,23 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
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
+	if (IS_GADDR_VALID(*gaddr))
+		return (pmd_t *)gmap_table_walk(gmap, *gaddr, 1);
+	return NULL;
 }
 
 /**
@@ -338,16 +350,19 @@ static unsigned long __gmap_segment_gaddr(unsigned long *entry)
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
@@ -564,7 +579,8 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	spin_lock(&gmap->guest_table_lock);
 	if (*table == _SEGMENT_ENTRY_EMPTY) {
 		rc = radix_tree_insert(&gmap->host_to_guest,
-				       vmaddr >> PMD_SHIFT, table);
+				       vmaddr >> PMD_SHIFT,
+				       (void *)MAKE_VALID_GADDR(gaddr));
 		if (!rc) {
 			if (pmd_leaf(*pmd)) {
 				*table = (pmd_val(*pmd) &
@@ -1995,7 +2011,6 @@ void ptep_notify(struct mm_struct *mm, unsigned long vmaddr,
 		 pte_t *pte, unsigned long bits)
 {
 	unsigned long offset, gaddr = 0;
-	unsigned long *table;
 	struct gmap *gmap, *sg, *next;
 
 	offset = ((unsigned long) pte) & (255 * sizeof(pte_t));
@@ -2003,12 +2018,9 @@ void ptep_notify(struct mm_struct *mm, unsigned long vmaddr,
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
+		if (!IS_GADDR_VALID(gaddr))
 			continue;
 
 		if (!list_empty(&gmap->children) && (bits & PGSTE_VSIE_BIT)) {
@@ -2068,10 +2080,8 @@ static void gmap_pmdp_clear(struct mm_struct *mm, unsigned long vmaddr,
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
@@ -2115,28 +2125,25 @@ EXPORT_SYMBOL_GPL(gmap_pmdp_csp);
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
@@ -2151,22 +2158,19 @@ EXPORT_SYMBOL_GPL(gmap_pmdp_idte_local);
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
@@ -2174,7 +2178,7 @@ void gmap_pmdp_idte_global(struct mm_struct *mm, unsigned long vmaddr)
 				__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_GLOBAL);
 			else
 				__pmdp_csp(pmdp);
-			*entry = _SEGMENT_ENTRY_EMPTY;
+			*pmdp = __pmd(_SEGMENT_ENTRY_EMPTY);
 		}
 		spin_unlock(&gmap->guest_table_lock);
 	}
@@ -2690,7 +2694,6 @@ int s390_replace_asce(struct gmap *gmap)
 	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
-	page->index = 0;
 	table = page_to_virt(page);
 	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
 
-- 
2.48.1


