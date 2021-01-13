Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C822F47D3
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbhAMJm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727374AbhAMJmY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:24 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9XXlm144448;
        Wed, 13 Jan 2021 04:41:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ytoz6F8EHZFNjnZPCEMDO45QXNzbmywtLCmbepU7XYc=;
 b=aSv2Rv0qPq4ChDz5wt+R48l64nBVjjoO1uf6nsRM+DooJpMP9g39jHI2Dr1wpVz7Vxss
 CxI8Pk9IDEk6NLdS/NEsLgfBzPCzQ11Ad8T8o0Tgn9RAmWk65wtrrJN0FikFxVQhwilQ
 2xe/jt+hKNCs/sWzWWikR+I/d6oLs+Mes85MZeklB1LKlbVIIHJEwA9lGb/aeSLaQFHo
 GlGaXECI7YmBaqCbv75GI2FIdlZo87Ie8srGWz4fgXezgh2VQrAIAkxkZhsrjrflMN0g
 Ah2I0ptPlqO7k8n1kFDnwCe8n+rVbFipljqLD3k13kAsJfJWvkesdDGAV2ccfeQgzT5y Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361xb706rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9XxX1149994;
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361xb706qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9SG7T007802;
        Wed, 13 Jan 2021 09:41:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdcej1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fW5Z24641836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AF76A4053;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6993CA4040;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 09/14] s390/mm: Make gmap_protect_rmap EDAT1 compatible
Date:   Wed, 13 Jan 2021 09:41:08 +0000
Message-Id: <20210113094113.133668-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0 spamscore=0
 mlxlogscore=825 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the upcoming large page shadowing support, let's add the
possibility to split a huge page and protect it with
gmap_protect_rmap() for shadowing purposes.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 93 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 20 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 910371dc511d..f20aa49c2791 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1142,7 +1142,8 @@ static int gmap_protect_pmd(struct gmap *gmap, unsigned long gaddr,
  * Expected to be called with sg->mm->mmap_lock in read
  */
 static int gmap_protect_pte(struct gmap *gmap, unsigned long gaddr,
-			    pte_t *ptep, int prot, unsigned long bits)
+			    unsigned long vmaddr, pte_t *ptep,
+			    int prot, unsigned long bits)
 {
 	int rc;
 	unsigned long pbits = 0;
@@ -1191,7 +1192,7 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 				ptep = gmap_pte_from_pmd(gmap, pmdp, gaddr,
 							 &ptl_pte);
 				if (ptep)
-					rc = gmap_protect_pte(gmap, gaddr,
+					rc = gmap_protect_pte(gmap, gaddr, vmaddr,
 							      ptep, prot, bits);
 				else
 					rc = -ENOMEM;
@@ -1354,6 +1355,21 @@ static inline void gmap_insert_rmap(struct gmap *sg, unsigned long vmaddr,
 	}
 }
 
+static int gmap_protect_rmap_pte(struct gmap *sg, struct gmap_rmap *rmap,
+				 unsigned long paddr, unsigned long vmaddr,
+				 pte_t *ptep, int prot)
+{
+	int rc = 0;
+
+	spin_lock(&sg->guest_table_lock);
+	rc = gmap_protect_pte(sg->parent, paddr, vmaddr, ptep,
+			      prot, GMAP_NOTIFY_SHADOW);
+	if (!rc)
+		gmap_insert_rmap(sg, vmaddr, rmap);
+	spin_unlock(&sg->guest_table_lock);
+	return rc;
+}
+
 /**
  * gmap_protect_rmap - restrict access rights to memory (RO) and create an rmap
  * @sg: pointer to the shadow guest address space structure
@@ -1370,16 +1386,15 @@ static int gmap_protect_rmap(struct gmap *sg, unsigned long raddr,
 	struct gmap *parent;
 	struct gmap_rmap *rmap;
 	unsigned long vmaddr;
-	spinlock_t *ptl;
+	pmd_t *pmdp;
 	pte_t *ptep;
+	spinlock_t *ptl_pmd = NULL, *ptl_pte = NULL;
+	struct page *page = NULL;
 	int rc;
 
 	BUG_ON(!gmap_is_shadow(sg));
 	parent = sg->parent;
 	while (len) {
-		vmaddr = __gmap_translate(parent, paddr);
-		if (IS_ERR_VALUE(vmaddr))
-			return vmaddr;
 		rmap = kzalloc(sizeof(*rmap), GFP_KERNEL_ACCOUNT);
 		if (!rmap)
 			return -ENOMEM;
@@ -1390,26 +1405,64 @@ static int gmap_protect_rmap(struct gmap *sg, unsigned long raddr,
 			return rc;
 		}
 		rc = -EAGAIN;
-		ptep = gmap_pte_op_walk(parent, paddr, &ptl);
-		if (ptep) {
-			spin_lock(&sg->guest_table_lock);
-			rc = ptep_force_prot(parent->mm, paddr, ptep, PROT_READ,
-					     PGSTE_VSIE_BIT);
-			if (!rc)
-				gmap_insert_rmap(sg, vmaddr, rmap);
-			spin_unlock(&sg->guest_table_lock);
-			gmap_pte_op_end(ptl);
+		vmaddr = __gmap_translate(parent, paddr);
+		if (IS_ERR_VALUE(vmaddr))
+			return vmaddr;
+		vmaddr |= paddr & ~PMD_MASK;
+		pmdp = gmap_pmd_op_walk(parent, paddr, vmaddr, &ptl_pmd);
+		if (pmdp && !(pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)) {
+			if (!pmd_large(*pmdp)) {
+				ptl_pte = NULL;
+				ptep = gmap_pte_from_pmd(parent, pmdp, paddr,
+							 &ptl_pte);
+				if (ptep)
+					rc = gmap_protect_rmap_pte(sg, rmap, paddr,
+								   vmaddr, ptep,
+								   PROT_READ);
+				else
+					rc = -ENOMEM;
+				gmap_pte_op_end(ptl_pte);
+				gmap_pmd_op_end(ptl_pmd);
+				if (!rc) {
+					paddr += PAGE_SIZE;
+					len -= PAGE_SIZE;
+					radix_tree_preload_end();
+					continue;
+				}
+			} else {
+				if (!page) {
+					/* Drop locks for allocation. */
+					gmap_pmd_op_end(ptl_pmd);
+					ptl_pmd = NULL;
+					radix_tree_preload_end();
+					kfree(rmap);
+					page = page_table_alloc_pgste(parent->mm);
+					if (!page)
+						return -ENOMEM;
+					continue;
+				} else {
+					gmap_pmd_split(parent, paddr, vmaddr,
+						       pmdp, page);
+					gmap_pmd_op_end(ptl_pmd);
+					radix_tree_preload_end();
+					kfree(rmap);
+					page = NULL;
+					continue;
+				}
+
+			}
+		}
+		if (page) {
+			page_table_free_pgste(page);
+			page = NULL;
 		}
 		radix_tree_preload_end();
-		if (rc) {
-			kfree(rmap);
+		kfree(rmap);
+		if (rc == -EAGAIN) {
 			rc = gmap_fixup(parent, paddr, vmaddr, PROT_READ);
 			if (rc)
 				return rc;
-			continue;
 		}
-		paddr += PAGE_SIZE;
-		len -= PAGE_SIZE;
 	}
 	return 0;
 }
-- 
2.27.0

