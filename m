Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA9F373679
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhEEIod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231923AbhEEIoa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:30 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458XhwE042809;
        Wed, 5 May 2021 04:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=GdFoX1wU6DPtisMn3o8P172njLGjYpCBNdARkJ6xn1M=;
 b=l49g6YuJTh2/j4qYNOFJ6WXZkLcjX3HOa5oHM1jlhv3cHA4ArTnuccSGc/PxSDSHOCRd
 KZWa+JRewfAtjWfzKnG1wb03DsZ54UfXZ3u5TKiIFKcNPW02sPuT1xldZRpE2L4SJ5ua
 pPfVgEVTDCf3z+rS6MYZoVlbOCBBExlIXAR85x2Ne8nva3afSLqwg0Xx5cy0aef4vcI1
 d02X0WSf0dMpEs54lTuP3fYcar8FkTjc1VGzPBnQgq2hRhh+3xaNlkRO0OQvRpzKrySS
 9RhGMf2xJo1naLleByUOR4yavRjdxJpVYflwQUsTTREnGyROoFwMzrvhav4eboE3jz6r vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38bpu1a200-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:33 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458aufk056054;
        Wed, 5 May 2021 04:43:33 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38bpu1a1yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:32 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458h920026813;
        Wed, 5 May 2021 08:43:31 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 38beebg3jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458h2m335979752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 212D8A405B;
        Wed,  5 May 2021 08:43:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88241A405C;
        Wed,  5 May 2021 08:43:27 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:27 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 1/9] s390x: mvpg: add checks for op_acc_id
Date:   Wed,  5 May 2021 10:42:53 +0200
Message-Id: <20210505084301.17395-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
References: <20210505084301.17395-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yXDnp0xwnVDb5_kJCE1ilQ-58pgfDUe1
X-Proofpoint-GUID: jXUpoxw74SarxpXGnHPGL6M-UxtJ2360
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_02:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Check the operand access identification when MVPG causes a page fault.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/kvm/20210427121608.157783-1-imbrenda@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/mvpg.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 5743d5b6..2b7c6cc9 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -36,6 +36,7 @@
 
 static uint8_t source[PAGE_SIZE]  __attribute__((aligned(PAGE_SIZE)));
 static uint8_t buffer[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static struct lowcore * const lc;
 
 /* Keep track of fresh memory */
 static uint8_t *fresh;
@@ -77,6 +78,21 @@ static int page_ok(const uint8_t *p)
 	return 1;
 }
 
+/*
+ * Check that the Operand Access Identification matches with the values of
+ * the r1 and r2 fields in the instruction format. The r1 and r2 fields are
+ * in the last byte of the instruction, and the Program Old PSW will point
+ * to the beginning of the instruction after the one that caused the fault
+ * (the fixup code in the interrupt handler takes care of that for
+ * nullifying instructions). Therefore it is enough to compare the byte
+ * before the one contained in the Program Old PSW with the value of the
+ * Operand Access Identification.
+ */
+static inline bool check_oai(void)
+{
+	return *(uint8_t *)(lc->pgm_old_psw.addr - 1) == lc->op_acc_id;
+}
+
 static void test_exceptions(void)
 {
 	int i, expected;
@@ -201,17 +217,25 @@ static void test_mmu_prot(void)
 	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
 	fresh += PAGE_SIZE;
 
+	report_prefix_push("source invalid");
 	protect_page(source, PAGE_ENTRY_I);
+	lc->op_acc_id = 0;
 	expect_pgm_int();
 	mvpg(0, fresh, source);
-	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "source invalid");
+	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "exception");
 	unprotect_page(source, PAGE_ENTRY_I);
+	report(check_oai(), "operand access ident");
+	report_prefix_pop();
 	fresh += PAGE_SIZE;
 
+	report_prefix_push("destination invalid");
 	protect_page(fresh, PAGE_ENTRY_I);
+	lc->op_acc_id = 0;
 	expect_pgm_int();
 	mvpg(0, fresh, source);
-	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "destination invalid");
+	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "exception");
+	report(check_oai(), "operand access ident");
+	report_prefix_pop();
 	fresh += PAGE_SIZE;
 
 	report_prefix_pop();
-- 
2.30.2

