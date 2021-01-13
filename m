Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069672F47E3
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbhAMJmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727366AbhAMJmX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:23 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9XQsN007843;
        Wed, 13 Jan 2021 04:41:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZChRM4aZYZ8sVIBlo4IguNAr6OULwH5eR1sz0dfVC/A=;
 b=H3NvlO6QcFDWUvdSqdq/+XP77L4k9pEVlkCZUdpZamUrsLlHDXeIinsUMA2ml6DEgG9x
 6UqHHFldfG8sfudcmp1yyFYH288f/gGSVDNvYJPuQA7vczu+jW+x13Q/eqdGx9/6X+kF
 smzOB7SIEO5FyIunRwrThaDS8rYIe/ZNasB+zgDly+6QvRVJeTokaAtrMwKMT+7Fw9Yq
 WS/TGb++xi8ewtiZgELm/j1GWC7AgCE3N5/EyIroYEIV0fXNCb42n9W1PTKtxitzSkoz
 6DlzlvFtDBjEXZV61ReLNaUpy2tU9fQ6+9Crvlid//CmJBm4W33l3/j+huUEQIW2B0Jh ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361wdnsk1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9Y3tC009334;
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361wdnsk0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9SHJt001148;
        Wed, 13 Jan 2021 09:41:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448cuym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:38 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fV6B28049664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13114A4055;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6173A4053;
        Wed, 13 Jan 2021 09:41:35 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 03/14] s390/mm: Take locking out of gmap_protect_pte
Date:   Wed, 13 Jan 2021 09:41:02 +0000
Message-Id: <20210113094113.133668-4-frankja@linux.ibm.com>
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
 spamscore=0 suspectscore=0 mlxlogscore=997 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Locking outside of the function gives us the freedom of ordering
locks, which will be important to not get locking issues for
gmap_protect_rmap.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 650c51749f4d..c38f49dedf35 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1017,25 +1017,15 @@ static int gmap_protect_pmd(struct gmap *gmap, unsigned long gaddr,
  * Expected to be called with sg->mm->mmap_lock in read
  */
 static int gmap_protect_pte(struct gmap *gmap, unsigned long gaddr,
-			    pmd_t *pmdp, int prot, unsigned long bits)
+			    pte_t *ptep, int prot, unsigned long bits)
 {
 	int rc;
-	pte_t *ptep;
-	spinlock_t *ptl = NULL;
 	unsigned long pbits = 0;
 
-	if (pmd_val(*pmdp) & _SEGMENT_ENTRY_INVALID)
-		return -EAGAIN;
-
-	ptep = pte_alloc_map_lock(gmap->mm, pmdp, gaddr, &ptl);
-	if (!ptep)
-		return -ENOMEM;
-
 	pbits |= (bits & GMAP_NOTIFY_MPROT) ? PGSTE_IN_BIT : 0;
 	pbits |= (bits & GMAP_NOTIFY_SHADOW) ? PGSTE_VSIE_BIT : 0;
 	/* Protect and unlock. */
 	rc = ptep_force_prot(gmap->mm, gaddr, ptep, prot, pbits);
-	gmap_pte_op_end(ptl);
 	return rc;
 }
 
@@ -1056,18 +1046,26 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 			      unsigned long len, int prot, unsigned long bits)
 {
 	unsigned long vmaddr, dist;
-	spinlock_t *ptl = NULL;
+	spinlock_t *ptl_pmd = NULL, *ptl_pte = NULL;
 	pmd_t *pmdp;
+	pte_t *ptep;
 	int rc;
 
 	BUG_ON(gmap_is_shadow(gmap));
 	while (len) {
 		rc = -EAGAIN;
-		pmdp = gmap_pmd_op_walk(gmap, gaddr, &ptl);
+		pmdp = gmap_pmd_op_walk(gmap, gaddr, &ptl_pmd);
 		if (pmdp) {
 			if (!pmd_large(*pmdp)) {
-				rc = gmap_protect_pte(gmap, gaddr, pmdp, prot,
-						      bits);
+				ptl_pte = NULL;
+				ptep = pte_alloc_map_lock(gmap->mm, pmdp, gaddr,
+							  &ptl_pte);
+				if (ptep)
+					rc = gmap_protect_pte(gmap, gaddr,
+							      ptep, prot, bits);
+				else
+					rc = -ENOMEM;
+				gmap_pte_op_end(ptl_pte);
 				if (!rc) {
 					len -= PAGE_SIZE;
 					gaddr += PAGE_SIZE;
@@ -1081,7 +1079,7 @@ static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 					gaddr = (gaddr & HPAGE_MASK) + HPAGE_SIZE;
 				}
 			}
-			gmap_pmd_op_end(ptl);
+			gmap_pmd_op_end(ptl_pmd);
 		}
 		if (rc) {
 			if (rc == -EINVAL)
-- 
2.27.0

