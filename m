Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177283A43C6
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhFKOJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:09:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231705AbhFKOJK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 10:09:10 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BE4v7p014006;
        Fri, 11 Jun 2021 10:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dI8Asb4v1eAgzN68mLxDAuUsQNicQJPLRvlEYv7tI74=;
 b=B+wxeLScIKwfRjGJ6gRJuJvKcLX1awGgf9boSmdCYtdKYXjUy9hhZuauUWHfY3iLs1Dp
 HL70H9qzi5NwGnrnAHR3LWBpm3HjQBK4vtAD3um9WBxVp/3FyYwXM2GKwdZc9fGmU/gM
 vG5dQXW+dcyuNwSL7mf3ULLe/EJGplHd3lQacrrD1Q6uuGpPapnMpu0FXfISHrJt3pvR
 MDHXmkvEJ3j3dl2XgAkbnIlu2ETU0bzexbOqJeVBtZH6x96HKjRwzCrCjyK6ZCHPYW4R
 hD4Mh/7fE/RQaeBQMUSZ/3OKdjHVerJMRAGz3zgE+ZVuOCYqzyiybHakTzxh2fYeDvq0 VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3948cn28ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:12 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15BE60Ex021846;
        Fri, 11 Jun 2021 10:07:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3948cn28td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15BDvgle028243;
        Fri, 11 Jun 2021 14:07:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8kg0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 14:07:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15BE77lb35324370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 14:07:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C22852057;
        Fri, 11 Jun 2021 14:07:07 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4F5FE52067;
        Fri, 11 Jun 2021 14:07:07 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 4/7] s390x: lib: Add idte and other huge pages functions/macros
Date:   Fri, 11 Jun 2021 16:07:02 +0200
Message-Id: <20210611140705.553307-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611140705.553307-1-imbrenda@linux.ibm.com>
References: <20210611140705.553307-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xmwUA2CsxriCPCoTU7CGA3j1bfnTlEVw
X-Proofpoint-ORIG-GUID: fzIEeNCO2xyOtdMDHsl5cBiIi95GtYXQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_05:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110090
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

