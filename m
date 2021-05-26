Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C614539191A
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhEZNoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:44:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233940AbhEZNoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:44:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QDfnqE120602;
        Wed, 26 May 2021 09:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dI8Asb4v1eAgzN68mLxDAuUsQNicQJPLRvlEYv7tI74=;
 b=UPj/BeRTiKEDFmcAy/FrDY1AuwAfWzY/Ns1hTpYabhu69jtpvqi05jrHH3EHlPAoiWEm
 0K0KEBqrgdhh4QuveTbOGHHPeIWaqUfXb0T8umuj8ULwv99s5pvJKb4NpYYWm0N6EIlW
 CSKpnXKpy+DeczzEhASdPcKmDYObv6dwzEZxbHW7PhVsqo95iWKLo7NyeBKuK4wg0Bhj
 7POj1BrAOJ+xNAmFqagYxporKXlIAGYEPt4AWllBE06aofnBy8+lv/PWF1ChXiBxlLg5
 HhFH6dLiGbiBvKbjCHkNS2jeupqzDKK0xG3CkzypxS+zrGv6WWtUbQKUPODei18rPtFV Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38sq1krmvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 09:42:52 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QDfmw8120565;
        Wed, 26 May 2021 09:42:52 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38sq1krmvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 09:42:52 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QDdUmr022406;
        Wed, 26 May 2021 13:42:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 38s1r48jpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 13:42:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QDgll221823804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 13:42:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF4A04203F;
        Wed, 26 May 2021 13:42:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6409642047;
        Wed, 26 May 2021 13:42:47 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.7.194])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 13:42:47 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 4/7] s390x: lib: Add idte and other huge pages functions/macros
Date:   Wed, 26 May 2021 15:42:42 +0200
Message-Id: <20210526134245.138906-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526134245.138906-1-imbrenda@linux.ibm.com>
References: <20210526134245.138906-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -zoWfWHaZjIJb3SlFYvFlVHperHnusFK
X-Proofpoint-GUID: Mz3e5aL5aL_uvsa0AZokHBowbCNn7eYC
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

Improve pgtable.h:

* add macros to check whether a pmd or a pud are large / huge
* add idte functions for pmd, pud, p4d and pgd

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/pgtable.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index 1a21f175..f166dcc6 100644
--- a/lib/s390x/asm/pgtable.h
+++ b/lib/s390x/asm/pgtable.h
@@ -100,6 +100,9 @@
 #define pmd_none(entry) (pmd_val(entry) & SEGMENT_ENTRY_I)
 #define pte_none(entry) (pte_val(entry) & PAGE_ENTRY_I)
 
+#define pud_huge(entry)  (pud_val(entry) & REGION3_ENTRY_FC)
+#define pmd_large(entry) (pmd_val(entry) & SEGMENT_ENTRY_FC)
+
 #define pgd_addr(entry) __va(pgd_val(entry) & REGION_ENTRY_ORIGIN)
 #define p4d_addr(entry) __va(p4d_val(entry) & REGION_ENTRY_ORIGIN)
 #define pud_addr(entry) __va(pud_val(entry) & REGION_ENTRY_ORIGIN)
@@ -216,6 +219,34 @@ static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
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
2.31.1

