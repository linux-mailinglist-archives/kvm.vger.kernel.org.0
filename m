Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104E7356C68
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352277AbhDGMma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:42:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243163AbhDGMm1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 08:42:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137CXM0i095371;
        Wed, 7 Apr 2021 08:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0+PwPuNcTz6ZrOr95+iYxPab//xkIRycSKU1QTzOlo0=;
 b=GgYWktAY+jPUjw9PLPV64ajGkY4weKE8Y91wDydyHTezy9eAOnK8PvFoezk3kXyqWAj3
 2UvWpBd6HCQ7RkFgv4LSngVB4zinkH8bEVjlapKXq0iG0TGY43Sm4KjQPiqsKP8kyWZf
 J/lhLdpRV2rNdSl5D3yE9OcS1H9UqizYcrs1ew5TrGyJlCALssV7Sj0vYOKYZYaXBNm0
 HJM5ES+rVFouhapb4sI37mnI2xgUIRUWljQxugykXGtfM5C0ypReHZSrQd3W2rVvno0O
 dSB/fQZF03f4GkFLqYl+9+PZMUpsVPddBHaOy2aClI0LdgEgloDEGdRDaPF2mTxUp8Nd Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rw6k8cmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 08:42:17 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137CY0eI097269;
        Wed, 7 Apr 2021 08:42:17 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rw6k8ck5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 08:42:17 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137CYHJL032097;
        Wed, 7 Apr 2021 12:42:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 37rvbsgctn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 12:42:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137CgB3e21627142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 12:42:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8A3352050;
        Wed,  7 Apr 2021 12:42:11 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6E57052052;
        Wed,  7 Apr 2021 12:42:11 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 3/7] s390x: lib: fix pgtable.h
Date:   Wed,  7 Apr 2021 14:42:05 +0200
Message-Id: <20210407124209.828540-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407124209.828540-1-imbrenda@linux.ibm.com>
References: <20210407124209.828540-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6PUAEz5WDOPxqKGvjm4RHSxJufD9ix-S
X-Proofpoint-ORIG-GUID: oVXzz4M-HnSaFqRXEgjL3o7eNcpgEaDS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_07:2021-04-07,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070087
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
2.26.2

