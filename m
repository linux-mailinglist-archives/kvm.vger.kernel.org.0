Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE58606319
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJTOcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJTOcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:32:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCFB196362;
        Thu, 20 Oct 2022 07:32:07 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KE3c5P025879;
        Thu, 20 Oct 2022 14:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FTamgyKggJY6GGyaSUbr8mBINfdnyMY4fOslbYAY/ig=;
 b=F6nhpc0Biczt2x06w3hXNCLn3vcERMH9dS6V4GE+P7isazbuj1Jxk9ANzDvdReH3q+7J
 7+bMhk8dp1rIZXw0kDtbPTndLgEhrLbh/mgAP61RFxBBsmQPa0sUHWv3as8TbRB4FzGp
 Rv2O5VRokd+okORkQQxJDikLchIttiEs2JdDjTV+Mgwj+Dm5mMAYZzSvENy/Dp6GxZV/
 1hZwdwIwqvWOiRhiF46RweLO7QMnO7onKiD50X6/aWowkgs+bLrI8SqCEGQChqrJJZsq
 5bCotwU7VLi/EFjQrGqErST3qnaqkL+KHjp7pJ4bvfS5n3tEgYsSwrKF1C/iMy5F0EoN AQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb7rrhfkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KELHtQ021407;
        Thu, 20 Oct 2022 14:32:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg990q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KEW0HN459460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 14:32:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CCE9AE045;
        Thu, 20 Oct 2022 14:32:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 246A1AE053;
        Thu, 20 Oct 2022 14:32:00 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 14:32:00 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [v1 1/5] s390/mm: gmap: sort out physical vs virtual pointers usage
Date:   Thu, 20 Oct 2022 16:31:55 +0200
Message-Id: <20221020143159.294605-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221020143159.294605-1-nrb@linux.ibm.com>
References: <20221020143159.294605-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BuJpvjDrNOXIuAed0TGniWFCZtRA5xqf
X-Proofpoint-ORIG-GUID: BuJpvjDrNOXIuAed0TGniWFCZtRA5xqf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix virtual vs physical address confusion (which currently are the same).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 147 +++++++++++++++++++++++---------------------
 1 file changed, 76 insertions(+), 71 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 02d15c8dc92e..2ccfcc8a3863 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -72,7 +72,7 @@ static struct gmap *gmap_alloc(unsigned long limit)
 		goto out_free;
 	page->index = 0;
 	list_add(&page->lru, &gmap->crst_list);
-	table = (unsigned long *) page_to_phys(page);
+	table = page_to_virt(page);
 	crst_table_init(table, etype);
 	gmap->table = table;
 	gmap->asce = atype | _ASCE_TABLE_LENGTH |
@@ -311,12 +311,12 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
-	new = (unsigned long *) page_to_phys(page);
+	new = page_to_virt(page);
 	crst_table_init(new, init);
 	spin_lock(&gmap->guest_table_lock);
 	if (*table & _REGION_ENTRY_INVALID) {
 		list_add(&page->lru, &gmap->crst_list);
-		*table = (unsigned long) new | _REGION_ENTRY_LENGTH |
+		*table = __pa(new) | _REGION_ENTRY_LENGTH |
 			(*table & _REGION_ENTRY_TYPE_MASK);
 		page->index = gaddr;
 		page = NULL;
@@ -557,7 +557,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 		    gmap_alloc_table(gmap, table, _REGION2_ENTRY_EMPTY,
 				     gaddr & _REGION1_MASK))
 			return -ENOMEM;
-		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		table = __va(*table & _REGION_ENTRY_ORIGIN);
 	}
 	if ((gmap->asce & _ASCE_TYPE_MASK) >= _ASCE_TYPE_REGION2) {
 		table += (gaddr & _REGION2_INDEX) >> _REGION2_SHIFT;
@@ -565,7 +565,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 		    gmap_alloc_table(gmap, table, _REGION3_ENTRY_EMPTY,
 				     gaddr & _REGION2_MASK))
 			return -ENOMEM;
-		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		table = __va(*table & _REGION_ENTRY_ORIGIN);
 	}
 	if ((gmap->asce & _ASCE_TYPE_MASK) >= _ASCE_TYPE_REGION3) {
 		table += (gaddr & _REGION3_INDEX) >> _REGION3_SHIFT;
@@ -573,7 +573,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 		    gmap_alloc_table(gmap, table, _SEGMENT_ENTRY_EMPTY,
 				     gaddr & _REGION3_MASK))
 			return -ENOMEM;
-		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		table = __va(*table & _REGION_ENTRY_ORIGIN);
 	}
 	table += (gaddr & _SEGMENT_INDEX) >> _SEGMENT_SHIFT;
 	/* Walk the parent mm page table */
@@ -813,7 +813,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 			break;
 		if (*table & _REGION_ENTRY_INVALID)
 			return NULL;
-		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		table = __va(*table & _REGION_ENTRY_ORIGIN);
 		fallthrough;
 	case _ASCE_TYPE_REGION2:
 		table += (gaddr & _REGION2_INDEX) >> _REGION2_SHIFT;
@@ -821,7 +821,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 			break;
 		if (*table & _REGION_ENTRY_INVALID)
 			return NULL;
-		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		table = __va(*table & _REGION_ENTRY_ORIGIN);
 		fallthrough;
 	case _ASCE_TYPE_REGION3:
 		table += (gaddr & _REGION3_INDEX) >> _REGION3_SHIFT;
@@ -829,7 +829,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 			break;
 		if (*table & _REGION_ENTRY_INVALID)
 			return NULL;
-		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		table = __va(*table & _REGION_ENTRY_ORIGIN);
 		fallthrough;
 	case _ASCE_TYPE_SEGMENT:
 		table += (gaddr & _SEGMENT_INDEX) >> _SEGMENT_SHIFT;
@@ -837,7 +837,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 			break;
 		if (*table & _REGION_ENTRY_INVALID)
 			return NULL;
-		table = (unsigned long *)(*table & _SEGMENT_ENTRY_ORIGIN);
+		table = __va(*table & _SEGMENT_ENTRY_ORIGIN);
 		table += (gaddr & _PAGE_INDEX) >> _PAGE_SHIFT;
 	}
 	return table;
@@ -1150,7 +1150,7 @@ int gmap_read_table(struct gmap *gmap, unsigned long gaddr, unsigned long *val)
 			if (pte_present(pte) && (pte_val(pte) & _PAGE_READ)) {
 				address = pte_val(pte) & PAGE_MASK;
 				address += gaddr & ~PAGE_MASK;
-				*val = *(unsigned long *) address;
+				*val = *(unsigned long *)__va(address);
 				set_pte(ptep, set_pte_bit(*ptep, __pgprot(_PAGE_YOUNG)));
 				/* Do *NOT* clear the _PAGE_INVALID bit! */
 				rc = 0;
@@ -1335,7 +1335,8 @@ static void __gmap_unshadow_pgt(struct gmap *sg, unsigned long raddr,
  */
 static void gmap_unshadow_pgt(struct gmap *sg, unsigned long raddr)
 {
-	unsigned long sto, *ste, *pgt;
+	unsigned long *ste;
+	phys_addr_t sto, pgt;
 	struct page *page;
 
 	BUG_ON(!gmap_is_shadow(sg));
@@ -1343,13 +1344,13 @@ static void gmap_unshadow_pgt(struct gmap *sg, unsigned long raddr)
 	if (!ste || !(*ste & _SEGMENT_ENTRY_ORIGIN))
 		return;
 	gmap_call_notifier(sg, raddr, raddr + _SEGMENT_SIZE - 1);
-	sto = (unsigned long) (ste - ((raddr & _SEGMENT_INDEX) >> _SEGMENT_SHIFT));
+	sto = __pa(ste - ((raddr & _SEGMENT_INDEX) >> _SEGMENT_SHIFT));
 	gmap_idte_one(sto | _ASCE_TYPE_SEGMENT, raddr);
-	pgt = (unsigned long *)(*ste & _SEGMENT_ENTRY_ORIGIN);
+	pgt = *ste & _SEGMENT_ENTRY_ORIGIN;
 	*ste = _SEGMENT_ENTRY_EMPTY;
-	__gmap_unshadow_pgt(sg, raddr, pgt);
+	__gmap_unshadow_pgt(sg, raddr, __va(pgt));
 	/* Free page table */
-	page = pfn_to_page(__pa(pgt) >> PAGE_SHIFT);
+	page = phys_to_page(pgt);
 	list_del(&page->lru);
 	page_table_free_pgste(page);
 }
@@ -1365,19 +1366,19 @@ static void gmap_unshadow_pgt(struct gmap *sg, unsigned long raddr)
 static void __gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr,
 				unsigned long *sgt)
 {
-	unsigned long *pgt;
 	struct page *page;
+	phys_addr_t pgt;
 	int i;
 
 	BUG_ON(!gmap_is_shadow(sg));
 	for (i = 0; i < _CRST_ENTRIES; i++, raddr += _SEGMENT_SIZE) {
 		if (!(sgt[i] & _SEGMENT_ENTRY_ORIGIN))
 			continue;
-		pgt = (unsigned long *)(sgt[i] & _REGION_ENTRY_ORIGIN);
+		pgt = sgt[i] & _REGION_ENTRY_ORIGIN;
 		sgt[i] = _SEGMENT_ENTRY_EMPTY;
-		__gmap_unshadow_pgt(sg, raddr, pgt);
+		__gmap_unshadow_pgt(sg, raddr, __va(pgt));
 		/* Free page table */
-		page = pfn_to_page(__pa(pgt) >> PAGE_SHIFT);
+		page = phys_to_page(pgt);
 		list_del(&page->lru);
 		page_table_free_pgste(page);
 	}
@@ -1392,7 +1393,8 @@ static void __gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr,
  */
 static void gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr)
 {
-	unsigned long r3o, *r3e, *sgt;
+	unsigned long r3o, *r3e;
+	phys_addr_t sgt;
 	struct page *page;
 
 	BUG_ON(!gmap_is_shadow(sg));
@@ -1401,12 +1403,12 @@ static void gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr)
 		return;
 	gmap_call_notifier(sg, raddr, raddr + _REGION3_SIZE - 1);
 	r3o = (unsigned long) (r3e - ((raddr & _REGION3_INDEX) >> _REGION3_SHIFT));
-	gmap_idte_one(r3o | _ASCE_TYPE_REGION3, raddr);
-	sgt = (unsigned long *)(*r3e & _REGION_ENTRY_ORIGIN);
+	gmap_idte_one(__pa(r3o) | _ASCE_TYPE_REGION3, raddr);
+	sgt = *r3e & _REGION_ENTRY_ORIGIN;
 	*r3e = _REGION3_ENTRY_EMPTY;
-	__gmap_unshadow_sgt(sg, raddr, sgt);
+	__gmap_unshadow_sgt(sg, raddr, __va(sgt));
 	/* Free segment table */
-	page = pfn_to_page(__pa(sgt) >> PAGE_SHIFT);
+	page = phys_to_page(sgt);
 	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
@@ -1422,19 +1424,19 @@ static void gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr)
 static void __gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr,
 				unsigned long *r3t)
 {
-	unsigned long *sgt;
 	struct page *page;
+	phys_addr_t sgt;
 	int i;
 
 	BUG_ON(!gmap_is_shadow(sg));
 	for (i = 0; i < _CRST_ENTRIES; i++, raddr += _REGION3_SIZE) {
 		if (!(r3t[i] & _REGION_ENTRY_ORIGIN))
 			continue;
-		sgt = (unsigned long *)(r3t[i] & _REGION_ENTRY_ORIGIN);
+		sgt = r3t[i] & _REGION_ENTRY_ORIGIN;
 		r3t[i] = _REGION3_ENTRY_EMPTY;
-		__gmap_unshadow_sgt(sg, raddr, sgt);
+		__gmap_unshadow_sgt(sg, raddr, __va(sgt));
 		/* Free segment table */
-		page = pfn_to_page(__pa(sgt) >> PAGE_SHIFT);
+		page = phys_to_page(sgt);
 		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
@@ -1449,7 +1451,8 @@ static void __gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr,
  */
 static void gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr)
 {
-	unsigned long r2o, *r2e, *r3t;
+	unsigned long r2o, *r2e;
+	phys_addr_t r3t;
 	struct page *page;
 
 	BUG_ON(!gmap_is_shadow(sg));
@@ -1458,12 +1461,12 @@ static void gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr)
 		return;
 	gmap_call_notifier(sg, raddr, raddr + _REGION2_SIZE - 1);
 	r2o = (unsigned long) (r2e - ((raddr & _REGION2_INDEX) >> _REGION2_SHIFT));
-	gmap_idte_one(r2o | _ASCE_TYPE_REGION2, raddr);
-	r3t = (unsigned long *)(*r2e & _REGION_ENTRY_ORIGIN);
+	gmap_idte_one(__pa(r2o) | _ASCE_TYPE_REGION2, raddr);
+	r3t = *r2e & _REGION_ENTRY_ORIGIN;
 	*r2e = _REGION2_ENTRY_EMPTY;
-	__gmap_unshadow_r3t(sg, raddr, r3t);
+	__gmap_unshadow_r3t(sg, raddr, __va(r3t));
 	/* Free region 3 table */
-	page = pfn_to_page(__pa(r3t) >> PAGE_SHIFT);
+	page = phys_to_page(r3t);
 	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
@@ -1479,7 +1482,7 @@ static void gmap_unshadow_r3t(struct gmap *sg, unsigned long raddr)
 static void __gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr,
 				unsigned long *r2t)
 {
-	unsigned long *r3t;
+	phys_addr_t r3t;
 	struct page *page;
 	int i;
 
@@ -1487,11 +1490,11 @@ static void __gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr,
 	for (i = 0; i < _CRST_ENTRIES; i++, raddr += _REGION2_SIZE) {
 		if (!(r2t[i] & _REGION_ENTRY_ORIGIN))
 			continue;
-		r3t = (unsigned long *)(r2t[i] & _REGION_ENTRY_ORIGIN);
+		r3t = r2t[i] & _REGION_ENTRY_ORIGIN;
 		r2t[i] = _REGION2_ENTRY_EMPTY;
-		__gmap_unshadow_r3t(sg, raddr, r3t);
+		__gmap_unshadow_r3t(sg, raddr, __va(r3t));
 		/* Free region 3 table */
-		page = pfn_to_page(__pa(r3t) >> PAGE_SHIFT);
+		page = phys_to_page(r3t);
 		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
@@ -1506,8 +1509,9 @@ static void __gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr,
  */
 static void gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr)
 {
-	unsigned long r1o, *r1e, *r2t;
+	unsigned long r1o, *r1e;
 	struct page *page;
+	phys_addr_t r2t;
 
 	BUG_ON(!gmap_is_shadow(sg));
 	r1e = gmap_table_walk(sg, raddr, 4); /* get region-1 pointer */
@@ -1515,12 +1519,12 @@ static void gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr)
 		return;
 	gmap_call_notifier(sg, raddr, raddr + _REGION1_SIZE - 1);
 	r1o = (unsigned long) (r1e - ((raddr & _REGION1_INDEX) >> _REGION1_SHIFT));
-	gmap_idte_one(r1o | _ASCE_TYPE_REGION1, raddr);
-	r2t = (unsigned long *)(*r1e & _REGION_ENTRY_ORIGIN);
+	gmap_idte_one(__pa(r1o) | _ASCE_TYPE_REGION1, raddr);
+	r2t = *r1e & _REGION_ENTRY_ORIGIN;
 	*r1e = _REGION1_ENTRY_EMPTY;
-	__gmap_unshadow_r2t(sg, raddr, r2t);
+	__gmap_unshadow_r2t(sg, raddr, __va(r2t));
 	/* Free region 2 table */
-	page = pfn_to_page(__pa(r2t) >> PAGE_SHIFT);
+	page = phys_to_page(r2t);
 	list_del(&page->lru);
 	__free_pages(page, CRST_ALLOC_ORDER);
 }
@@ -1536,22 +1540,23 @@ static void gmap_unshadow_r2t(struct gmap *sg, unsigned long raddr)
 static void __gmap_unshadow_r1t(struct gmap *sg, unsigned long raddr,
 				unsigned long *r1t)
 {
-	unsigned long asce, *r2t;
+	unsigned long asce;
 	struct page *page;
+	phys_addr_t r2t;
 	int i;
 
 	BUG_ON(!gmap_is_shadow(sg));
-	asce = (unsigned long) r1t | _ASCE_TYPE_REGION1;
+	asce = __pa(r1t) | _ASCE_TYPE_REGION1;
 	for (i = 0; i < _CRST_ENTRIES; i++, raddr += _REGION1_SIZE) {
 		if (!(r1t[i] & _REGION_ENTRY_ORIGIN))
 			continue;
-		r2t = (unsigned long *)(r1t[i] & _REGION_ENTRY_ORIGIN);
-		__gmap_unshadow_r2t(sg, raddr, r2t);
+		r2t = r1t[i] & _REGION_ENTRY_ORIGIN;
+		__gmap_unshadow_r2t(sg, raddr, __va(r2t));
 		/* Clear entry and flush translation r1t -> r2t */
 		gmap_idte_one(asce, raddr);
 		r1t[i] = _REGION1_ENTRY_EMPTY;
 		/* Free region 2 table */
-		page = pfn_to_page(__pa(r2t) >> PAGE_SHIFT);
+		page = phys_to_page(r2t);
 		list_del(&page->lru);
 		__free_pages(page, CRST_ALLOC_ORDER);
 	}
@@ -1573,7 +1578,7 @@ static void gmap_unshadow(struct gmap *sg)
 	sg->removed = 1;
 	gmap_call_notifier(sg, 0, -1UL);
 	gmap_flush_tlb(sg);
-	table = (unsigned long *)(sg->asce & _ASCE_ORIGIN);
+	table = __va(sg->asce & _ASCE_ORIGIN);
 	switch (sg->asce & _ASCE_TYPE_MASK) {
 	case _ASCE_TYPE_REGION1:
 		__gmap_unshadow_r1t(sg, 0, table);
@@ -1748,7 +1753,8 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 		    int fake)
 {
 	unsigned long raddr, origin, offset, len;
-	unsigned long *s_r2t, *table;
+	unsigned long *table;
+	phys_addr_t s_r2t;
 	struct page *page;
 	int rc;
 
@@ -1760,7 +1766,7 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 	page->index = r2t & _REGION_ENTRY_ORIGIN;
 	if (fake)
 		page->index |= GMAP_SHADOW_FAKE_TABLE;
-	s_r2t = (unsigned long *) page_to_phys(page);
+	s_r2t = page_to_phys(page);
 	/* Install shadow region second table */
 	spin_lock(&sg->guest_table_lock);
 	table = gmap_table_walk(sg, saddr, 4); /* get region-1 pointer */
@@ -1775,9 +1781,9 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 		rc = -EAGAIN;		/* Race with shadow */
 		goto out_free;
 	}
-	crst_table_init(s_r2t, _REGION2_ENTRY_EMPTY);
+	crst_table_init(__va(s_r2t), _REGION2_ENTRY_EMPTY);
 	/* mark as invalid as long as the parent table is not protected */
-	*table = (unsigned long) s_r2t | _REGION_ENTRY_LENGTH |
+	*table = s_r2t | _REGION_ENTRY_LENGTH |
 		 _REGION_ENTRY_TYPE_R1 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= (r2t & _REGION_ENTRY_PROTECT);
@@ -1798,8 +1804,7 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 	spin_lock(&sg->guest_table_lock);
 	if (!rc) {
 		table = gmap_table_walk(sg, saddr, 4);
-		if (!table || (*table & _REGION_ENTRY_ORIGIN) !=
-			      (unsigned long) s_r2t)
+		if (!table || (*table & _REGION_ENTRY_ORIGIN) != s_r2t)
 			rc = -EAGAIN;		/* Race with unshadow */
 		else
 			*table &= ~_REGION_ENTRY_INVALID;
@@ -1832,7 +1837,8 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 		    int fake)
 {
 	unsigned long raddr, origin, offset, len;
-	unsigned long *s_r3t, *table;
+	unsigned long *table;
+	phys_addr_t s_r3t;
 	struct page *page;
 	int rc;
 
@@ -1844,7 +1850,7 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 	page->index = r3t & _REGION_ENTRY_ORIGIN;
 	if (fake)
 		page->index |= GMAP_SHADOW_FAKE_TABLE;
-	s_r3t = (unsigned long *) page_to_phys(page);
+	s_r3t = page_to_phys(page);
 	/* Install shadow region second table */
 	spin_lock(&sg->guest_table_lock);
 	table = gmap_table_walk(sg, saddr, 3); /* get region-2 pointer */
@@ -1859,9 +1865,9 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 		rc = -EAGAIN;		/* Race with shadow */
 		goto out_free;
 	}
-	crst_table_init(s_r3t, _REGION3_ENTRY_EMPTY);
+	crst_table_init(__va(s_r3t), _REGION3_ENTRY_EMPTY);
 	/* mark as invalid as long as the parent table is not protected */
-	*table = (unsigned long) s_r3t | _REGION_ENTRY_LENGTH |
+	*table = s_r3t | _REGION_ENTRY_LENGTH |
 		 _REGION_ENTRY_TYPE_R2 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= (r3t & _REGION_ENTRY_PROTECT);
@@ -1882,8 +1888,7 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 	spin_lock(&sg->guest_table_lock);
 	if (!rc) {
 		table = gmap_table_walk(sg, saddr, 3);
-		if (!table || (*table & _REGION_ENTRY_ORIGIN) !=
-			      (unsigned long) s_r3t)
+		if (!table || (*table & _REGION_ENTRY_ORIGIN) != s_r3t)
 			rc = -EAGAIN;		/* Race with unshadow */
 		else
 			*table &= ~_REGION_ENTRY_INVALID;
@@ -1916,7 +1921,8 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		    int fake)
 {
 	unsigned long raddr, origin, offset, len;
-	unsigned long *s_sgt, *table;
+	unsigned long *table;
+	phys_addr_t s_sgt;
 	struct page *page;
 	int rc;
 
@@ -1928,7 +1934,7 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 	page->index = sgt & _REGION_ENTRY_ORIGIN;
 	if (fake)
 		page->index |= GMAP_SHADOW_FAKE_TABLE;
-	s_sgt = (unsigned long *) page_to_phys(page);
+	s_sgt = page_to_phys(page);
 	/* Install shadow region second table */
 	spin_lock(&sg->guest_table_lock);
 	table = gmap_table_walk(sg, saddr, 2); /* get region-3 pointer */
@@ -1943,9 +1949,9 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		rc = -EAGAIN;		/* Race with shadow */
 		goto out_free;
 	}
-	crst_table_init(s_sgt, _SEGMENT_ENTRY_EMPTY);
+	crst_table_init(__va(s_sgt), _SEGMENT_ENTRY_EMPTY);
 	/* mark as invalid as long as the parent table is not protected */
-	*table = (unsigned long) s_sgt | _REGION_ENTRY_LENGTH |
+	*table = s_sgt | _REGION_ENTRY_LENGTH |
 		 _REGION_ENTRY_TYPE_R3 | _REGION_ENTRY_INVALID;
 	if (sg->edat_level >= 1)
 		*table |= sgt & _REGION_ENTRY_PROTECT;
@@ -1966,8 +1972,7 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 	spin_lock(&sg->guest_table_lock);
 	if (!rc) {
 		table = gmap_table_walk(sg, saddr, 2);
-		if (!table || (*table & _REGION_ENTRY_ORIGIN) !=
-			      (unsigned long) s_sgt)
+		if (!table || (*table & _REGION_ENTRY_ORIGIN) != s_sgt)
 			rc = -EAGAIN;		/* Race with unshadow */
 		else
 			*table &= ~_REGION_ENTRY_INVALID;
@@ -2040,8 +2045,9 @@ int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 		    int fake)
 {
 	unsigned long raddr, origin;
-	unsigned long *s_pgt, *table;
+	unsigned long *table;
 	struct page *page;
+	phys_addr_t s_pgt;
 	int rc;
 
 	BUG_ON(!gmap_is_shadow(sg) || (pgt & _SEGMENT_ENTRY_LARGE));
@@ -2052,7 +2058,7 @@ int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 	page->index = pgt & _SEGMENT_ENTRY_ORIGIN;
 	if (fake)
 		page->index |= GMAP_SHADOW_FAKE_TABLE;
-	s_pgt = (unsigned long *) page_to_phys(page);
+	s_pgt = page_to_phys(page);
 	/* Install shadow page table */
 	spin_lock(&sg->guest_table_lock);
 	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */
@@ -2085,8 +2091,7 @@ int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 	spin_lock(&sg->guest_table_lock);
 	if (!rc) {
 		table = gmap_table_walk(sg, saddr, 1);
-		if (!table || (*table & _SEGMENT_ENTRY_ORIGIN) !=
-			      (unsigned long) s_pgt)
+		if (!table || (*table & _SEGMENT_ENTRY_ORIGIN) != s_pgt)
 			rc = -EAGAIN;		/* Race with unshadow */
 		else
 			*table &= ~_SEGMENT_ENTRY_INVALID;
-- 
2.37.3

