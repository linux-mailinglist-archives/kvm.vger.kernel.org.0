Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F81315225
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhBIOzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 09:55:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232137AbhBIOzL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 09:55:11 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119EXbv7194031;
        Tue, 9 Feb 2021 09:54:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wvwLY9dm9iMreposhash9DRICe7s6YQjA9dcMDzFaEc=;
 b=ExMqEdTKtkxqxRvvaGtdiYacc85pkT8puqk5uUguUDX+0jlZIRnfKJrP5nqFpcu+r/A1
 pqMjoo89RHeG3KD8CxgrzhNGhjk6baERPQKz/+J7KSfAncXbQLCO4/25tzqk1JMnGUMi
 Bqfte1OIOKxYTCR85MTcGqZ4cvbJ6rs3PHVpUtIHBg6CXJw3a3g0oYzYO6XCl40fliFX
 jmItb5AvcxPhCwoUTCmz8jqRagmw0CczcmlKgGIYwMT2ih/dRMFlDnWsYKA+4uzU/DgE
 ENlkhz6bBOeb6UYeCSO0tgqp+OCmmd/8Mi0qnbuZx89n6G3BqQx98M+y3wc6rhrnDN/N kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kuyqher2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 09:54:30 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119EY5xB000626;
        Tue, 9 Feb 2021 09:54:30 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kuyqhep8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 09:54:30 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119EXnVc031950;
        Tue, 9 Feb 2021 14:38:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 36hjr81sc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 14:38:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119EcbZF13763000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 14:38:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 171CF11C05B;
        Tue,  9 Feb 2021 14:38:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFB0911C04A;
        Tue,  9 Feb 2021 14:38:36 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.1.216])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 14:38:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 2/4] s390x: lib: fix and improve pgtable.h
Date:   Tue,  9 Feb 2021 15:38:33 +0100
Message-Id: <20210209143835.1031617-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
References: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix and improve pgtable.h:

* SEGMENT_ENTRY_SFAA had one extra bit set
* pmd entries don't have a length
* ipte does not need to clear the lower bits
* add macros to check whether a pmd or a pud are large / huge
* add idte functions for pmd, pud, p4d and pgd

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/pgtable.h | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index 277f3480..4269ab62 100644
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
@@ -100,6 +100,9 @@
 #define pmd_none(entry) (pmd_val(entry) & SEGMENT_ENTRY_I)
 #define pte_none(entry) (pte_val(entry) & PAGE_ENTRY_I)
 
+#define pud_huge(entry)  (pud_val(entry) & REGION3_ENTRY_FC)
+#define pmd_large(entry) (pmd_val(entry) & SEGMENT_ENTRY_FC)
+
 #define pgd_addr(entry) __va(pgd_val(entry) & REGION_ENTRY_ORIGIN)
 #define p4d_addr(entry) __va(p4d_val(entry) & REGION_ENTRY_ORIGIN)
 #define pud_addr(entry) __va(pud_val(entry) & REGION_ENTRY_ORIGIN)
@@ -202,21 +205,48 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
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
 		: : "a" (table_origin), "a" (vaddr) : "memory");
 }
 
+static inline void idte(unsigned long table_origin, unsigned long vaddr)
+{
+	vaddr &= SEGMENT_ENTRY_SFAA;
+	asm volatile(
+		"	idte %0,0,%1\n"
+		: : "a" (table_origin), "a" (vaddr) : "memory");
+}
+
+static inline void idte_pmdp(unsigned long vaddr, pmdval_t *pmdp)
+{
+	idte((unsigned long)(pmdp - pmd_index(vaddr)) | ASCE_DT_SEGMENT, vaddr);
+}
+
+static inline void idte_pudp(unsigned long vaddr, pudval_t *pudp)
+{
+	idte((unsigned long)(pudp - pud_index(vaddr)) | ASCE_DT_REGION3, vaddr);
+}
+
+static inline void idte_p4dp(unsigned long vaddr, p4dval_t *p4dp)
+{
+	idte((unsigned long)(p4dp - p4d_index(vaddr)) | ASCE_DT_REGION2, vaddr);
+}
+
+static inline void idte_pgdp(unsigned long vaddr, pgdval_t *pgdp)
+{
+	idte((unsigned long)(pgdp - pgd_index(vaddr)) | ASCE_DT_REGION1, vaddr);
+}
+
 void configure_dat(int enable);
 
 #endif /* _ASMS390X_PGTABLE_H_ */
-- 
2.26.2

