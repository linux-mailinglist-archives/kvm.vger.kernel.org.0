Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD833A43C5
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhFKOJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:09:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231707AbhFKOJK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 10:09:10 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BE5Nk9132012;
        Fri, 11 Jun 2021 10:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JNHRLGlp5sWIQO101kEV4yJSVyWGwupfFwPbQL/1veE=;
 b=XZ3YqogtiTDMc1vxMShnQ213LE1gM/+DngLggSql2TRtK6cUetFhkrSx1q+bkELigPSw
 RHDLEf91uufyz0xyaZ+TDEeTVCNWtKXaSkizpaJyp8FX7D1jrYCJGU2Vk73rN2Pdawux
 QVfXiGP+5yNTpBeflG/oDtI+NrLX3Ojp9ZEIRpaKmDPXx2Afe4cYTrDKxVI9DslQTwT5
 f+n+bkyIkfgX+79RMd4jzLjrWIB+KZDXI1zwWFz8LlOv5VXom5/cTS7ul4yt14Xl2E5L
 MtAh7J6jx7f+0SmB+ZOY1IbV9Vg7GcBtrcc5GFhrIMh/ajvmFPeQBN1xcetPP/G/BoSt 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3948t8h8qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:12 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15BE6OY3135461;
        Fri, 11 Jun 2021 10:07:12 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3948t8h8pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:12 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15BDwC28013112;
        Fri, 11 Jun 2021 14:07:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhugak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 14:07:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15BE77kQ34537964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 14:07:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 450135205A;
        Fri, 11 Jun 2021 14:07:07 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E82575205F;
        Fri, 11 Jun 2021 14:07:06 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 3/7] s390x: lib: fix pgtable.h
Date:   Fri, 11 Jun 2021 16:07:01 +0200
Message-Id: <20210611140705.553307-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611140705.553307-1-imbrenda@linux.ibm.com>
References: <20210611140705.553307-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GAWjqqf9oc8LBqmWyOisXS53l1FGGi97
X-Proofpoint-ORIG-GUID: _AYO6lAwN62FWza96uS3i-eJBCPFdCLT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_05:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix pgtable.h:

* SEGMENT_ENTRY_SFAA had one extra bit set
* pmd entries don't have a length field
* ipte does not need to clear the lower bits
 - clearing the 12 lower bits is technically incorrect, as page tables are
   architecturally aligned to 11 bit addresses (even though the unit tests
   allocate always one full page)
* region table entries should use REGION_ENTRY_TL instead of *_TABLE_LENGTH
 - *_TABLE_LENGTH need to stay, because they should be used for ASCEs

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/pgtable.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index 277f3480..1a21f175 100644
--- a/lib/s390x/asm/pgtable.h
+++ b/lib/s390x/asm/pgtable.h
@@ -60,7 +60,7 @@
 #define SEGMENT_SHIFT			20
 
 #define SEGMENT_ENTRY_ORIGIN		0xfffffffffffff800UL
-#define SEGMENT_ENTRY_SFAA		0xfffffffffff80000UL
+#define SEGMENT_ENTRY_SFAA		0xfffffffffff00000UL
 #define SEGMENT_ENTRY_AV		0x0000000000010000UL
 #define SEGMENT_ENTRY_ACC		0x000000000000f000UL
 #define SEGMENT_ENTRY_F			0x0000000000000800UL
@@ -143,7 +143,7 @@ static inline p4d_t *p4d_alloc(pgd_t *pgd, unsigned long addr)
 	if (pgd_none(*pgd)) {
 		p4d_t *p4d = p4d_alloc_one();
 		pgd_val(*pgd) = __pa(p4d) | REGION_ENTRY_TT_REGION1 |
-				REGION_TABLE_LENGTH;
+				REGION_ENTRY_TL;
 	}
 	return p4d_offset(pgd, addr);
 }
@@ -163,7 +163,7 @@ static inline pud_t *pud_alloc(p4d_t *p4d, unsigned long addr)
 	if (p4d_none(*p4d)) {
 		pud_t *pud = pud_alloc_one();
 		p4d_val(*p4d) = __pa(pud) | REGION_ENTRY_TT_REGION2 |
-				REGION_TABLE_LENGTH;
+				REGION_ENTRY_TL;
 	}
 	return pud_offset(p4d, addr);
 }
@@ -183,7 +183,7 @@ static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
 	if (pud_none(*pud)) {
 		pmd_t *pmd = pmd_alloc_one();
 		pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 |
-				REGION_TABLE_LENGTH;
+				REGION_ENTRY_TL;
 	}
 	return pmd_offset(pud, addr);
 }
@@ -202,15 +202,14 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 {
 	if (pmd_none(*pmd)) {
 		pte_t *pte = pte_alloc_one();
-		pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT |
-				SEGMENT_TABLE_LENGTH;
+		pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;
 	}
 	return pte_offset(pmd, addr);
 }
 
 static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
 {
-	unsigned long table_origin = (unsigned long)p_pte & PAGE_MASK;
+	unsigned long table_origin = (unsigned long)p_pte;
 
 	asm volatile(
 		"	ipte %0,%1\n"
-- 
2.31.1

