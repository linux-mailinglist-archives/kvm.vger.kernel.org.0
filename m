Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53B92F47D2
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbhAMJm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727356AbhAMJmX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:23 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9Y2N9096463;
        Wed, 13 Jan 2021 04:41:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QvQGci/KkvJd2PvpbMksvlvyanuPqd0JO7N+F1gjXCk=;
 b=bvcD1au5qnfzBifVGMgpqsfCZ66gxnIZ0ZBeFaavPJu7nCuQaPp5bVlYnaRylsovHbSF
 Pd6KypKpuIZm4WXvngI7c8st4I3bGqemp25YMM6uG+IoHFbon3r+67BKU06q7c8qF5XD
 YBp+os8glkwHYWCLgbBDcZ3VoHcTU0e9fU0tIbSou6Zl6YUkeTXFZJuFMsopJl5qmgV5
 FHU93AZfMOMx/6xcKZNKzii5zEpo0tX5QmluvS1OwjMYIBlQrrxHjyPaARArddfifzNn
 rQZKcJerQ8CHcJHTYMa2zb45vqZGzO2ddDGrTdqXnNe37bF4Rgx1KhJpGzrh05pAsv0M mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361vwcu004-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9Y3Mc096503;
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361vwctyy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:42 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9SO87007869;
        Wed, 13 Jan 2021 09:41:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdcej0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fWT627918750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21C1FA4055;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E45F4A4040;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 07/14] s390/mm: factor out idte global flush into gmap_idte_global
Date:   Wed, 13 Jan 2021 09:41:06 +0000
Message-Id: <20210113094113.133668-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=956
 impostorscore=0 malwarescore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a function to do a idte global flush on a gmap pmd and
remove some code duplication.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/gmap.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index b7199c55f98a..f89e710c31af 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1009,6 +1009,18 @@ static pte_t *gmap_pte_from_pmd(struct gmap *gmap, pmd_t *pmdp,
 	return pte_offset_map(pmdp, addr);
 }
 
+static inline void gmap_idte_global(unsigned long asce, pmd_t *pmdp,
+				    unsigned long gaddr)
+{
+	if (MACHINE_HAS_TLB_GUEST)
+		__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE, asce,
+			    IDTE_GLOBAL);
+	else if (MACHINE_HAS_IDTE)
+		__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_GLOBAL);
+	else
+		__pmdp_csp(pmdp);
+}
+
 /**
  * gmap_pmd_split_free - Free a split pmd's page table
  * @pmdp The split pmd that we free of its page table
@@ -2468,13 +2480,7 @@ static void gmap_pmdp_xchg(struct gmap *gmap, pmd_t *pmdp, pmd_t new,
 	pmdp_notify_gmap(gmap, pmdp, gaddr, vmaddr);
 	if (pmd_large(new))
 		pmd_val(new) &= ~GMAP_SEGMENT_NOTIFY_BITS;
-	if (MACHINE_HAS_TLB_GUEST)
-		__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE, gmap->asce,
-			    IDTE_GLOBAL);
-	else if (MACHINE_HAS_IDTE)
-		__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_GLOBAL);
-	else
-		__pmdp_csp(pmdp);
+	gmap_idte_global(gmap->asce, pmdp, gaddr);
 	*pmdp = new;
 }
 
@@ -2587,13 +2593,7 @@ void gmap_pmdp_idte_global(struct mm_struct *mm, unsigned long vmaddr)
 			pmdp_notify_gmap(gmap, pmdp, gaddr, vmaddr);
 			if (pmd_large(*pmdp))
 				WARN_ON(*entry & GMAP_SEGMENT_NOTIFY_BITS);
-			if (MACHINE_HAS_TLB_GUEST)
-				__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE,
-					    gmap->asce, IDTE_GLOBAL);
-			else if (MACHINE_HAS_IDTE)
-				__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_GLOBAL);
-			else
-				__pmdp_csp(pmdp);
+			gmap_idte_global(gmap->asce, pmdp, gaddr);
 			gmap_pmd_split_free(gmap, pmdp);
 			*entry = _SEGMENT_ENTRY_EMPTY;
 		}
-- 
2.27.0

