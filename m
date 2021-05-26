Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E271339191C
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhEZNoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:44:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233906AbhEZNoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:44:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QDfmBa120559;
        Wed, 26 May 2021 09:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tthunQM6TvWqOneQ54r6M/uVz2c93evkxz3BD3njV+M=;
 b=L+rBt73kZMVy4d+wXk71kIuIVRTgAP1o3PUeEN8z0Mx3opy/nFR/BrIAs+Z1uvX0mAIG
 7LyUFaZBmC6Ja2rzlVi3McofKbr1mccG9KNOCkwvwgQKz5i50Jsj2KntbbSyZ1CkVrQg
 kHV7JRt+5QkbQHoGiaSNjZCibiuWwamdz5kzOhJbXOmWXZx+MfI2YTlcDU45qXlZN0TS
 /X1MDIe/vbdszQ5MUtbGLOAcGGQUgVpep+3qmg672BJ98Yq01MbKTRe0Ny5dMkeDpFoR
 3MFJpj930ReFanTee+EmHRCFuyxr2noizOkrxPjE8fthK48GxG1pLinREy5hbeV28qvG wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38sq1krmvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 09:42:52 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QDflHX120528;
        Wed, 26 May 2021 09:42:52 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38sq1krmvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 09:42:52 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QDb4m3012282;
        Wed, 26 May 2021 13:42:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 38sba2rb0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 13:42:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QDglun24904044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 13:42:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FEBA42041;
        Wed, 26 May 2021 13:42:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0508A42049;
        Wed, 26 May 2021 13:42:47 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.7.194])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 13:42:46 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 3/7] s390x: lib: fix pgtable.h
Date:   Wed, 26 May 2021 15:42:41 +0200
Message-Id: <20210526134245.138906-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526134245.138906-1-imbrenda@linux.ibm.com>
References: <20210526134245.138906-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1NuR7t-4MCCnR5khtpCNsRINQJBwpX18
X-Proofpoint-GUID: frgTWQmP5_SR_2fKokl6JGhM-wMZGrwf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_08:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105260091
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

