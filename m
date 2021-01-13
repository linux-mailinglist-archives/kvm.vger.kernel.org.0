Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7222F47E0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbhAMJmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727376AbhAMJmY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:24 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9Z8HY108770;
        Wed, 13 Jan 2021 04:41:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=k3OplJUc4AVcnR5ntOrQ76a0rAywIkaQOUKsli+701U=;
 b=Ixi4hB0RujVUNy/hubD6BaqG8u1U3vdwV9uZs6fs/BioJe6B5s0gO3Vn5sn11F3c09R/
 Scdoh7UTIDGK76336RoZXzPfufnJPLNSF94tBJmeVcbF4uR0tPhH8WfG0u8KHJuQQWrk
 IIGjzV12pI3QLiBuxRYme4K1R//wPkrJ/5owqaEXBoS2iQDZmTJ//2qT12JwO7A/Rf+0
 YyEJtDpFF3GVYQQvxv9bgPrrx63s3VGXFEbepGcSoxEU87td5TEnTrkGC2ff2L4YOHHi
 tE+D/SNQ05LjlCiHUPT9xrdsbfC4p5po0c0EfDRd0d8vV7ojLNPrQhuBDzTZffGvqwpr hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361vq9bb9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9ZJl8109485;
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361vq9bb8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9SUQu009883;
        Wed, 13 Jan 2021 09:41:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 35y448jg08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fWkf29360446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54C21A405B;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D230A405D;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 08/14] s390/mm: Make gmap_read_table EDAT1 compatible
Date:   Wed, 13 Jan 2021 09:41:07 +0000
Message-Id: <20210113094113.133668-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 adultscore=0 mlxlogscore=866 lowpriorityscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the upcoming support of VSIE guests on huge page backed hosts, we
need to be able to read from large segments.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index f89e710c31af..910371dc511d 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1282,35 +1282,44 @@ EXPORT_SYMBOL_GPL(gmap_mprotect_notify);
 int gmap_read_table(struct gmap *gmap, unsigned long gaddr, unsigned long *val)
 {
 	unsigned long address, vmaddr;
-	spinlock_t *ptl;
+	spinlock_t *ptl_pmd = NULL, *ptl_pte = NULL;
+	pmd_t *pmdp;
 	pte_t *ptep, pte;
 	int rc;
 
-	if (gmap_is_shadow(gmap))
-		return -EINVAL;
+	BUG_ON(gmap_is_shadow(gmap));
 
 	while (1) {
 		rc = -EAGAIN;
-		ptep = gmap_pte_op_walk(gmap, gaddr, &ptl);
-		if (ptep) {
-			pte = *ptep;
-			if (pte_present(pte) && (pte_val(pte) & _PAGE_READ)) {
-				address = pte_val(pte) & PAGE_MASK;
-				address += gaddr & ~PAGE_MASK;
+		vmaddr = __gmap_translate(gmap, gaddr);
+		if (IS_ERR_VALUE(vmaddr))
+			return vmaddr;
+		pmdp = gmap_pmd_op_walk(gmap, gaddr, vmaddr, &ptl_pmd);
+		if (pmdp && !(pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)) {
+			if (!pmd_large(*pmdp)) {
+				ptep = gmap_pte_from_pmd(gmap, pmdp, vmaddr, &ptl_pte);
+				if (ptep) {
+					pte = *ptep;
+					if (pte_present(pte) && (pte_val(pte) & _PAGE_READ)) {
+						address = pte_val(pte) & PAGE_MASK;
+						address += gaddr & ~PAGE_MASK;
+						*val = *(unsigned long *) address;
+						pte_val(*ptep) |= _PAGE_YOUNG;
+						/* Do *NOT* clear the _PAGE_INVALID bit! */
+						rc = 0;
+					}
+				}
+				gmap_pte_op_end(ptl_pte);
+			} else {
+				address = pmd_val(*pmdp) & HPAGE_MASK;
+				address += gaddr & ~HPAGE_MASK;
 				*val = *(unsigned long *) address;
-				pte_val(*ptep) |= _PAGE_YOUNG;
-				/* Do *NOT* clear the _PAGE_INVALID bit! */
 				rc = 0;
 			}
-			gmap_pte_op_end(ptl);
+			gmap_pmd_op_end(ptl_pmd);
 		}
 		if (!rc)
 			break;
-		vmaddr = __gmap_translate(gmap, gaddr);
-		if (IS_ERR_VALUE(vmaddr)) {
-			rc = vmaddr;
-			break;
-		}
 		rc = gmap_fixup(gmap, gaddr, vmaddr, PROT_READ);
 		if (rc)
 			break;
-- 
2.27.0

