Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A21E2F47D0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbhAMJmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727342AbhAMJmX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:23 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9Vpmc040528;
        Wed, 13 Jan 2021 04:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9WZYSa7JbW9fugCMfA4EOQxhXDZxIz1Ry9oawJjpNWQ=;
 b=Jr5vG7/he/tEBmR8NGAJSpGeIaW3WN0Ui7MSV1LQ/3YqRXE+bAMvWH2V9gNP6owfY/9S
 HR0YjOukWhZRi4TsM9wXzq+jn1KiEbZc/BckvSM2xVe08qjLfgOAT9l1I88NhsBzo/hp
 YGcHmdAoHgnJb3DqkMp3LYlfNcjpYWWgMN4XEJFzOCu2dqlswlLpykR/s/19xNlUfic/
 V3ZPHSEBRS9JTWM4s/nmVz2gQNL8vJvqJVuR60WY1rShJcpmYL5Unujr5u9vR4NI1QNI
 /TGigkKuRBSb+i+rRltqfNOxncHcuwBnmd5xpjjGyhnanHlHiqle+4KRinBzHbkA2TIi wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361wrysb56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9VrCe040663;
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361wrysb4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9S67B007667;
        Wed, 13 Jan 2021 09:41:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdcehy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fVQo25821694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CB19A4051;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B113A4055;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 05/14] s390/mm: Split huge pages when migrating
Date:   Wed, 13 Jan 2021 09:41:04 +0000
Message-Id: <20210113094113.133668-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now we mark the huge page that is being written to as dirty
although only a single byte may have changed. This means we have to
migrate 1MB although only a very limited amount of memory in that
range might be dirty.

To speed up migration this patch splits up write protected huge pages
into normal pages. The protection for the normal pages is only removed
for the page that caused the fault.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 41a5bbbc59e6..d8c9b295294b 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -532,6 +532,9 @@ void gmap_unlink(struct mm_struct *mm, unsigned long *table,
 static void gmap_pmdp_xchg(struct gmap *gmap, pmd_t *old, pmd_t new,
 			   unsigned long gaddr);
 
+static void gmap_pmd_split(struct gmap *gmap, unsigned long gaddr,
+			   pmd_t *pmdp, struct page *page);
+
 /**
  * gmap_link - set up shadow page tables to connect a host to a guest address
  * @gmap: pointer to guest mapping meta data structure
@@ -547,12 +550,12 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 {
 	struct mm_struct *mm;
 	unsigned long *table;
+	struct page *page = NULL;
 	spinlock_t *ptl;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	u64 unprot;
 	pte_t *ptep;
 	int rc;
 
@@ -600,6 +603,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	/* Are we allowed to use huge pages? */
 	if (pmd_large(*pmd) && !gmap->mm->context.allow_gmap_hpage_1m)
 		return -EFAULT;
+retry_split:
 	/* Link gmap segment table entry location to page table. */
 	rc = radix_tree_preload(GFP_KERNEL_ACCOUNT);
 	if (rc)
@@ -627,10 +631,25 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 		spin_unlock(&gmap->guest_table_lock);
 	} else if (*table & _SEGMENT_ENTRY_PROTECT &&
 		   !(pmd_val(*pmd) & _SEGMENT_ENTRY_PROTECT)) {
-		unprot = (u64)*table;
-		unprot &= ~_SEGMENT_ENTRY_PROTECT;
-		unprot |= _SEGMENT_ENTRY_GMAP_UC;
-		gmap_pmdp_xchg(gmap, (pmd_t *)table, __pmd(unprot), gaddr);
+		if (page) {
+			gmap_pmd_split(gmap, gaddr, (pmd_t *)table, page);
+			page = NULL;
+		} else {
+			spin_unlock(ptl);
+			ptl = NULL;
+			radix_tree_preload_end();
+			page = page_table_alloc_pgste(mm);
+			if (!page)
+				rc = -ENOMEM;
+			else
+				goto retry_split;
+		}
+		/*
+		 * The split moves over the protection, so we still
+		 * need to unprotect.
+		 */
+		ptep = pte_offset_map((pmd_t *)table, vmaddr);
+		ptep_remove_protection_split(mm, ptep, vmaddr);
 	} else if (gmap_pmd_is_split((pmd_t *)table)) {
 		/*
 		 * Split pmds are somewhere in-between a normal and a
@@ -642,7 +661,10 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 		if (pte_val(*ptep) & _PAGE_PROTECT)
 			ptep_remove_protection_split(mm, ptep, vmaddr);
 	}
-	spin_unlock(ptl);
+	if (page)
+		page_table_free_pgste(page);
+	if (ptl)
+		spin_unlock(ptl);
 	radix_tree_preload_end();
 	return rc;
 }
-- 
2.27.0

