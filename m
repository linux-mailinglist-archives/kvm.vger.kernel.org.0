Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7C5322BEC
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhBWOIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:08:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230083AbhBWOIr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:08:47 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NE2Zap155324;
        Tue, 23 Feb 2021 09:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6sR+6Ek5Vy+rJYZMbu3ztkKFVdJEXEXVimyPJK5vePA=;
 b=G14EC51rT9Q803wTvEicdfLB0jT+H/UZr9YQOfvuoCADj1V755cjCAa+vaVGzvE9g8TO
 Y/n/aRKnJl2y8fH9TMVSPdNZb8yhWzFVH5WW8ltTQ9BdMHM0xG/Ht9KfzNbeNKfp7rcn
 ZENyKzwczsP4fujE06qWCDvqOVdkAesPxFV3hEY9bHX4OySrw0xtobpReO8cSFgyT9Np
 UwtyFBEQ1ZFfCPYl7V/dmwO7rZfgpwDWI07CHlzsWxwJ2S+jXr+3MsFq9jKHeVxsFQxP
 4PmlnEpfgBN5+KDAameUvx8TzjiUo4440YjcMGZrukUaSYSeLemIEGH2j8ezSkZ+xH5g HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkndqy3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:08:06 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NE2qbK156549;
        Tue, 23 Feb 2021 09:08:06 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkndqy2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:08:06 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NE84mG017530;
        Tue, 23 Feb 2021 14:08:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt282nup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:08:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NE7nIO34931108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 14:07:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BE6CA407D;
        Tue, 23 Feb 2021 14:08:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C486A4084;
        Tue, 23 Feb 2021 14:08:01 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.213])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 14:08:01 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/5] s390x: lib: fix pgtable.h
Date:   Tue, 23 Feb 2021 15:07:56 +0100
Message-Id: <20210223140759.255670-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210223140759.255670-1-imbrenda@linux.ibm.com>
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_07:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 adultscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix pgtable.h:

* SEGMENT_ENTRY_SFAA had one extra bit set
* pmd entries don't have a length
* ipte does not need to clear the lower bits
* pud entries should use SEGMENT_TABLE_LENGTH, as they point to segment tables

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/pgtable.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index 277f3480..a2ff2d4e 100644
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
@@ -183,7 +183,7 @@ static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
 	if (pud_none(*pud)) {
 		pmd_t *pmd = pmd_alloc_one();
 		pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 |
-				REGION_TABLE_LENGTH;
+				SEGMENT_TABLE_LENGTH;
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

