Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6B2F47D1
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbhAMJm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727364AbhAMJmY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:24 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9XPRs007835;
        Wed, 13 Jan 2021 04:41:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Lbo11U6FHjgeuaZyj0uVo3tgcVejkmwi/Njyi97reyE=;
 b=fXPpGMvWHpcfntuiAYHsMkO255v9siIIOtyhLFqXcOYK6EhZgaN9ZSapptr6iCQsW3wz
 ceaZdvZgalLO2xsq6fNdfkYm2jh25Ecoay6cEmXZVP6p96nCqNHP/3tsmMucmilV4atT
 bYzbnsBIqYAVX/Wo5aM+kBcy+RJCKxotrMMWFpcM/SAFfGx1DyRoWFxDR5d9ZwjTvHAG
 lV/BATzmG6li2OOE5JylY1IJ9j9OvCUvwzz9akiC2/29lObuvv754l5sLORIHN4THg1Q
 k6uMuPo2/R9pfqbgj0u/6FxZ8AxHzn7rn0DOrwou5sIFZiUsfXNXIfWV+eVkI/qPKWWi mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361wdnsk1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9Y3tE009334;
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361wdnsk12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9ROHv019480;
        Wed, 13 Jan 2021 09:41:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447vucc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fWV830867858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8FC1A4057;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7B64A4053;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 06/14] s390/mm: Provide vmaddr to pmd notification
Date:   Wed, 13 Jan 2021 09:41:05 +0000
Message-Id: <20210113094113.133668-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It will be needed for shadow tables.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 52 +++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index d8c9b295294b..b7199c55f98a 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -530,10 +530,10 @@ void gmap_unlink(struct mm_struct *mm, unsigned long *table,
 }
 
 static void gmap_pmdp_xchg(struct gmap *gmap, pmd_t *old, pmd_t new,
-			   unsigned long gaddr);
+			   unsigned long gaddr, unsigned long vmaddr);
 
 static void gmap_pmd_split(struct gmap *gmap, unsigned long gaddr,
-			   pmd_t *pmdp, struct page *page);
+			   unsigned long vmaddr, pmd_t *pmdp, struct page *page);
 
 /**
  * gmap_link - set up shadow page tables to connect a host to a guest address
@@ -632,7 +632,8 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	} else if (*table & _SEGMENT_ENTRY_PROTECT &&
 		   !(pmd_val(*pmd) & _SEGMENT_ENTRY_PROTECT)) {
 		if (page) {
-			gmap_pmd_split(gmap, gaddr, (pmd_t *)table, page);
+			gmap_pmd_split(gmap, gaddr, vmaddr,
+				       (pmd_t *)table, page);
 			page = NULL;
 		} else {
 			spin_unlock(ptl);
@@ -952,19 +953,15 @@ static void gmap_pte_op_end(spinlock_t *ptl)
  * Returns a pointer to the pmd for a guest address, or NULL
  */
 static inline pmd_t *gmap_pmd_op_walk(struct gmap *gmap, unsigned long gaddr,
-				      spinlock_t **ptl)
+				      unsigned long vmaddr, spinlock_t **ptl)
 {
 	pmd_t *pmdp, *hpmdp;
-	unsigned long vmaddr;
 
 
 	BUG_ON(gmap_is_shadow(gmap));
 
 	*ptl = NULL;
 	if (gmap->mm->context.allow_gmap_hpage_1m) {
-		vmaddr = __gmap_translate(gmap, gaddr);
-		if (IS_ERR_VALUE(vmaddr))
-			return NULL;
 		hpmdp = pmd_alloc_map(gmap->mm, vmaddr);
 		if (!hpmdp)
 			return NULL;
@@ -1047,7 +1044,7 @@ static inline void gmap_pmd_split_free(struct gmap *gmap, pmd_t *pmdp)
  * aren't tracked anywhere else.
  */
 static void gmap_pmd_split(struct gmap *gmap, unsigned long gaddr,
-			   pmd_t *pmdp, struct page *page)
+			   unsigned long vmaddr, pmd_t *pmdp, struct page *page)
 {
 	unsigned long *ptable = (unsigned long *) page_to_phys(page);
 	pmd_t new;
@@ -1069,7 +1066,7 @@ static void gmap_pmd_split(struct gmap *gmap, unsigned long gaddr,
 	spin_lock(&gmap->split_list_lock);
 	list_add(&page->lru, &gmap->split_list);
 	spin_unlock(&gmap->split_list_lock);
-	gmap_pmdp_xchg(gmap, pmdp, new, gaddr);
+	gmap_pmdp_xchg(gmap, pmdp, new, gaddr, vmaddr);
 }
 
 /*
@@ -1087,7 +1084,8 @@ static void gmap_pmd_split(struct gmap *gmap, unsigned long gaddr,
  * guest_table_lock held.
  */
 static int gmap_protect_pmd(struct gmap *gmap, unsigned long gaddr,
-			    pmd_t *pmdp, int prot, unsigned long bits)
+			    unsigned long vmaddr, pmd_t *pmdp, int prot,
+			    unsigned long bits)
 {
 	int pmd_i = pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID;
 	int pmd_p = pmd_val(*pmdp) & _SEGMENT_ENTRY_PROTECT;
@@ -1099,13 +1097,13 @@ static int gmap_protect_pmd(struct gmap *gmap, unsigned long gaddr,
 
 	if (prot == PROT_NONE && !pmd_i) {
 		pmd_val(new) |= _SEGMENT_ENTRY_INVALID;
-		gmap_pmdp_xchg(gmap, pmdp, new, gaddr);
+		gmap_pmdp_xchg(gmap, pmdp, new, gaddr, vmaddr);
 	}
 
 	if (prot == PROT_READ && !pmd_p) {
 		pmd_val(new) &= ~_SEGMENT_ENTRY_INVALID;
 		pmd_val(new) |= _SEGMENT_ENTRY_PROTECT;
-		gmap_pmdp_xchg(gmap, pmdp, new, gaddr);
+		gmap_pmdp_xchg(gmap, pmdp, new, gaddr, vmaddr);
 	}
 
 	if (bits & GMAP_NOTIFY_MPROT)
@@ -1168,10 +1166,14 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 	int rc;
 
 	BUG_ON(gmap_is_shadow(gmap));
+
 	while (len) {
 		rc = -EAGAIN;
-
-		pmdp = gmap_pmd_op_walk(gmap, gaddr, &ptl_pmd);
+		vmaddr = __gmap_translate(gmap, gaddr);
+		if (IS_ERR_VALUE(vmaddr))
+			return vmaddr;
+		vmaddr |= gaddr & ~PMD_MASK;
+		pmdp = gmap_pmd_op_walk(gmap, gaddr, vmaddr, &ptl_pmd);
 		if (pmdp && !(pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)) {
 			if (!pmd_large(*pmdp)) {
 				ptep = gmap_pte_from_pmd(gmap, pmdp, gaddr,
@@ -1196,7 +1198,7 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 						return -ENOMEM;
 					continue;
 				} else {
-					gmap_pmd_split(gmap, gaddr,
+					gmap_pmd_split(gmap, gaddr, vmaddr,
 						       pmdp, page);
 					page = NULL;
 					gmap_pmd_op_end(ptl_pmd);
@@ -1214,9 +1216,6 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 				return rc;
 
 			/* -EAGAIN, fixup of userspace mm and gmap */
-			vmaddr = __gmap_translate(gmap, gaddr);
-			if (IS_ERR_VALUE(vmaddr))
-				return vmaddr;
 			rc = gmap_fixup(gmap, gaddr, vmaddr, prot);
 			if (rc)
 				return rc;
@@ -2441,6 +2440,7 @@ static inline void pmdp_notify_split(struct gmap *gmap, pmd_t *pmdp,
 static void pmdp_notify_gmap(struct gmap *gmap, pmd_t *pmdp,
 			     unsigned long gaddr, unsigned long vmaddr)
 {
+	BUG_ON((gaddr & ~HPAGE_MASK) || (vmaddr & ~HPAGE_MASK));
 	if (gmap_pmd_is_split(pmdp))
 		return pmdp_notify_split(gmap, pmdp, gaddr, vmaddr);
 
@@ -2461,10 +2461,11 @@ static void pmdp_notify_gmap(struct gmap *gmap, pmd_t *pmdp,
  * held.
  */
 static void gmap_pmdp_xchg(struct gmap *gmap, pmd_t *pmdp, pmd_t new,
-			   unsigned long gaddr)
+			   unsigned long gaddr, unsigned long vmaddr)
 {
 	gaddr &= HPAGE_MASK;
-	pmdp_notify_gmap(gmap, pmdp, gaddr, 0);
+	vmaddr &= HPAGE_MASK;
+	pmdp_notify_gmap(gmap, pmdp, gaddr, vmaddr);
 	if (pmd_large(new))
 		pmd_val(new) &= ~GMAP_SEGMENT_NOTIFY_BITS;
 	if (MACHINE_HAS_TLB_GUEST)
@@ -2612,7 +2613,8 @@ EXPORT_SYMBOL_GPL(gmap_pmdp_idte_global);
  * held.
  */
 static bool gmap_test_and_clear_dirty_pmd(struct gmap *gmap, pmd_t *pmdp,
-					  unsigned long gaddr)
+					  unsigned long gaddr,
+					  unsigned long vmaddr)
 {
 	if (pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)
 		return false;
@@ -2624,7 +2626,7 @@ static bool gmap_test_and_clear_dirty_pmd(struct gmap *gmap, pmd_t *pmdp,
 
 	/* Clear UC indication and reset protection */
 	pmd_val(*pmdp) &= ~_SEGMENT_ENTRY_GMAP_UC;
-	gmap_protect_pmd(gmap, gaddr, pmdp, PROT_READ, 0);
+	gmap_protect_pmd(gmap, gaddr, vmaddr, pmdp, PROT_READ, 0);
 	return true;
 }
 
@@ -2647,12 +2649,12 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long bitmap[4],
 	spinlock_t *ptl_pmd = NULL;
 	spinlock_t *ptl_pte = NULL;
 
-	pmdp = gmap_pmd_op_walk(gmap, gaddr, &ptl_pmd);
+	pmdp = gmap_pmd_op_walk(gmap, gaddr, vmaddr, &ptl_pmd);
 	if (!pmdp)
 		return;
 
 	if (pmd_large(*pmdp)) {
-		if (gmap_test_and_clear_dirty_pmd(gmap, pmdp, gaddr))
+		if (gmap_test_and_clear_dirty_pmd(gmap, pmdp, gaddr, vmaddr))
 			bitmap_fill(bitmap, _PAGE_ENTRIES);
 	} else {
 		for (i = 0; i < _PAGE_ENTRIES; i++, vmaddr += PAGE_SIZE) {
-- 
2.27.0

