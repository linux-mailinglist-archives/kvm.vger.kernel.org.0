Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A774EEC40
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbiDALTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345444AbiDALSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF08B1877C0
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:41 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231AKGEH039376
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2EoOWhS0a39fPVtxj96o+mx8iMKKB3uzPfipQIpr8sY=;
 b=AofxaX+ffAw9MFw/Po8eI/Iuj/hCeeRW1ogNUEqeDjukBtB0rf6HGhmWP07yG5sZuzlE
 qMcyefZTaJ5xdhzYCHBhfP5RJT9srm5At3LVUGxXBcw/m2ENNv/bvmtbdJr3KoSvTV25
 Ak/12pA/eQ5pCti25L2FdJLVmlpbvXQW+kkxwVugrE1TnrI98XTebUTzX4QMauXUIFNy
 aArVMUdU4CyQJlyzsiijEPW0+nBADUE2uTvtItsnqC0dOUhXgtH7VvZErC9RkcnAKR9/
 rz939MY76RqLYZ0n422P5YWHRdlSiP6yvuUvQdAdO/CqyGMkXw/b3nDI9VSwoAutvJcr 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5yj0s180-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:40 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231ATCiS026556
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:40 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5yj0s173-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:40 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7Pwu020761;
        Fri, 1 Apr 2022 11:16:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf92wqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGYfH22938094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFD554C05A;
        Fri,  1 Apr 2022 11:16:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 873AC4C06D;
        Fri,  1 Apr 2022 11:16:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:34 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 21/27] s390x: stsi: check zero and ignored bits in r0 and r1
Date:   Fri,  1 Apr 2022 13:16:14 +0200
Message-Id: <20220401111620.366435-22-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OXrUP4s5Kk3rVkdKYP0LF3IyougBKWhn
X-Proofpoint-ORIG-GUID: TMLdtsVCnTtc1lBoyHlZkP3Uz_qYiujO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=919
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

We previously only checked for two zero bits, one in r0 and one in r1.
Let's check all the bits which must be zero and which are ignored
to extend the coverage.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/stsi.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index dccc53e7..94a579dc 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
@@ -19,19 +20,40 @@ static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
 static void test_specs(void)
 {
+	int i;
+	int cc;
+
 	report_prefix_push("specification");
 
-	report_prefix_push("inv r0");
-	expect_pgm_int();
-	stsi(pagebuf, 0, 1 << 8, 0);
-	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
-	report_prefix_pop();
+	for (i = 36; i <= 55; i++) {
+		report_prefix_pushf("set invalid r0 bit %d", i);
+		expect_pgm_int();
+		stsi(pagebuf, 0, BIT(63 - i), 0);
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+		report_prefix_pop();
+	}
 
-	report_prefix_push("inv r1");
-	expect_pgm_int();
-	stsi(pagebuf, 1, 0, 1 << 16);
-	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
-	report_prefix_pop();
+	for (i = 32; i <= 47; i++) {
+		report_prefix_pushf("set invalid r1 bit %d", i);
+		expect_pgm_int();
+		stsi(pagebuf, 1, 0, BIT(63 - i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+		report_prefix_pop();
+	}
+
+	for (i = 0; i < 32; i++) {
+		report_prefix_pushf("r0 bit %d ignored", i);
+		cc = stsi(pagebuf, 3, 2 | BIT(63 - i), 2);
+		report(!cc, "CC = 0");
+		report_prefix_pop();
+	}
+
+	for (i = 0; i < 32; i++) {
+		report_prefix_pushf("r1 bit %d ignored", i);
+		cc = stsi(pagebuf, 3, 2, 2 | BIT(63 - i));
+		report(!cc, "CC = 0");
+		report_prefix_pop();
+	}
 
 	report_prefix_push("unaligned");
 	expect_pgm_int();
-- 
2.34.1

