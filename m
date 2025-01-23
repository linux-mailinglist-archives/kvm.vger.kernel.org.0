Return-Path: <kvm+bounces-36380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 054F4A1A609
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32A82169B38
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F80C2139B0;
	Thu, 23 Jan 2025 14:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fnpLsQ+V"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B60212FBF;
	Thu, 23 Jan 2025 14:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643608; cv=none; b=ByOvevZBBG0Iek+3W597xxy6oxnn9E4zg9OMV06/UdVhZHXYq+jmJvhza2u5H30AnHtsAr927RLj2HjNbws7RqdwvsfQNmZkAWbxMHTVkHSdJHcUx00eTxGbDtMzi9XLjvt1TfgnMV0GOxeaoQkcbzS9UIDMWYJtUuyBucPMOCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643608; c=relaxed/simple;
	bh=eo6aMryRFZsn84AdjJVJChnQbiLM2CKidYz7y1rqUEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dS4faICQpt/T4yqpBoI8SLLFamccMHimN3sbOzKMU1ABqkUM38lPXXsgH4JmYWsgIoRoZS5gjcyRqVdgNthSVLSogPrRqVHDBGhmrTbVqWRpEGkJOwOmVNemS220oFbE0pIcvsQYTThDHzHErvJ06qT4t2CqV1aHxbDm78K6JoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fnpLsQ+V; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N7WkSg028013;
	Thu, 23 Jan 2025 14:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QW3rrS09mZAJvoX9I
	uqF+cyJVRhKh3i+sY45kl0ZwrQ=; b=fnpLsQ+VRMlZzPK6G4wP8HjAIrBf+12ET
	dX8hQSXqHMRLabxTqTsFpM7zATinFSj2IrWe+Ro06EUEi7whAdTh7pk16JeyP0WN
	jDghL3enzpjbKAB3ZQ/ksod8AAyzLfI8nPk8NjjanncLU28CjgR2/l0T0xZ8F8wQ
	ku7GFFhmJRjVdDHi8LOh+noqMYe+6EAamDpOZCnAiOucxOdfCtuYAF4gRSweFvfW
	JItcKS/e8ejZbCQoos9CxAQ2onwEE9ThAmtLX09KWzdtCplf69bmjYiEvSmnkFoP
	pwsrzNuf4LhUqpce+YSCG7XbHpZQZBmFIWI71VMlqNtep0a327gcg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bhfpj06u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:36 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NE6TOO006343;
	Thu, 23 Jan 2025 14:46:36 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bhfpj06q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:36 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NELPYW024240;
	Thu, 23 Jan 2025 14:46:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448q0ye3r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkV0X31785508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6201520040;
	Thu, 23 Jan 2025 14:46:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 248C12004B;
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
Subject: [PATCH v4 10/15] KVM: s390: stop using page->index for non-shadow gmaps
Date: Thu, 23 Jan 2025 15:46:22 +0100
Message-ID: <20250123144627.312456-11-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: xOo6aU0wJEHynUIq98DubRQztEoieMw_
X-Proofpoint-ORIG-GUID: WYXA6zUTpGA_w2ZtwQ5ocfQKc_0UlOn7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230108

The host_to_guest radix tree will now map userspace addresses to guest
addresses, instead of userspace addresses to segment tables.

When segment tables and page tables are needed, they are found using an
additional gmap_table_walk().

This gets rid of all usage of page->index for non-shadow gmaps.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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


