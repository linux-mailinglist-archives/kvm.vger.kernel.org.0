Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740ED4E2434
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346284AbiCUKUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346262AbiCUKUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2374C2CC9C;
        Mon, 21 Mar 2022 03:19:15 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L9Pt0q015588;
        Mon, 21 Mar 2022 10:19:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=b9rgkHJbHKZ27YCfeW4MQUexcpse6aSh3Py6GAPryYk=;
 b=OYhsLPvZl6ajaZobBKQz6fBo2h3n3HVEU8sVZ0d3ycJa0AzOaoXJcjoLEZCYBki9FMY+
 zVXNtrM1++PSL2xvuobFHw/ywqFo6vDorA6Osftrvkec5pepGmBxlhw6GGnppFM5EzJl
 EW5m6QBh3RGPtryr8og84Xo+VSpB0x4rWDa2T6j8neMFFqfOdfY/fbSsfjAiCd6qGY2a
 xfM5QfINTKvGZuHcX/3V8HGJ11y1g+iuDQHbH7CAKfi9CaVPgOxa94tu+j65tAlml3x4
 ubQVNPAVrvbW3bRqT8zqz/B4YoLDXjA90JWyKTIY5VdL8hcP7wGpzFjzs90P3+ajGnXM qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exkk3w1x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:14 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LA7Icx035236;
        Mon, 21 Mar 2022 10:19:13 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exkk3w1w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LAEZ2G029744;
        Mon, 21 Mar 2022 10:19:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t8uju7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LAJ8Zc36831596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:19:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D76E11C052;
        Mon, 21 Mar 2022 10:19:08 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC8B511C04C;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 9/9] s390x: stsi: check zero and ignored bits in r0 and r1
Date:   Mon, 21 Mar 2022 11:19:04 +0100
Message-Id: <20220321101904.387640-10-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Oh9hi1Fos_GJSgRcd_8ogjMvAOCs7Mxx
X-Proofpoint-ORIG-GUID: oWQ0L9xq_X1hgYSZGx-ehmfjktzwSxrm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We previously only checked for two zero bits, one in r0 and one in r1.
Let's check all the bits which must be zero and which are ignored
to extend the coverage.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/stsi.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index dccc53e7a816..94a579dc3b58 100644
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
2.31.1

