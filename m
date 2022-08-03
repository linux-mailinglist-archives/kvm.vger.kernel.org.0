Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5543588755
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 08:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbiHCG1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 02:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiHCG06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 02:26:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F4F1F2D5
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 23:26:55 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2736CPk7005098
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 06:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=IyYjYdIH6Zf5yjjtop4W0cWwD6ioFrzJ3C5ofARkDsE=;
 b=n30+mcf4NCzmFv2HOn99kZH+CshW1cz98jKnE7eG5N6AUV8PEgzIPCP5w/k6TBB1Z6+p
 OaH5n9tVUN0vWTI2XqvD46XMhPrw31z4+MgUM4UFyiAlWfq3/jLV4b1Z6SJ1XDxv2lAl
 u41Ca421WfYfoyY/Ll8GQjs9t1JKI73LWCkDnMjKrw7rzBqwZLVgyUaEjUNnVqtzctDl
 nQeNH6s6XNCBdDFddZY8aQ7awxEvQhx8eLOp4jnuB6nT5JGCBt4fEr/tu+LG/vGRMIMA
 lwhC3qPXZxstCIqZTbpFjqzUSsEb8mgOOIjyvGBMgLjkxosh8c+glv9ATyk0ILfCAnPV bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqkhn8av3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 06:26:55 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2736CvlT007320
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 06:26:55 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqkhn8auf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 06:26:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2736654b001975;
        Wed, 3 Aug 2022 06:26:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hmuwhvjrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 06:26:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2736R4Jn31195550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 06:27:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B0C411C052;
        Wed,  3 Aug 2022 06:26:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB06C11C04C;
        Wed,  3 Aug 2022 06:26:48 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 06:26:48 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2] s390x: verify EQBS/SQBS is unavailable
Date:   Wed,  3 Aug 2022 08:26:48 +0200
Message-Id: <20220803062648.13780-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4syStUCOsFEZoP6LSRzRw_OVNARSSoBI
X-Proofpoint-GUID: n6fK4xf4_JkKzWEerssZObOmnd14BtPR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 mlxlogscore=950 mlxscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030030
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU doesn't provide EQBS/SQBS instructions, so we should check they
result in an exception.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/intercept.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 9e826b6c79ad..d342f273b3c0 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -197,6 +197,34 @@ static void test_diag318(void)
 
 }
 
+static void test_qbs(void)
+{
+	report_prefix_push("qbs");
+	if (!host_is_qemu()) {
+		report_skip("QEMU-only test");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("sqbs");
+	expect_pgm_int();
+	asm volatile(
+		"	.insn   rsy,0xeb000000008a,0,0,0(0)\n"
+		: : : "memory", "cc", "1");
+	check_pgm_int_code(PGM_INT_CODE_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_push("eqbs");
+	expect_pgm_int();
+	asm volatile(
+		"	.insn   rrf,0xb99c0000,0,0,0,0\n"
+		: : : "memory", "cc", "1");
+	check_pgm_int_code(PGM_INT_CODE_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 struct {
 	const char *name;
 	void (*func)(void);
@@ -208,6 +236,7 @@ struct {
 	{ "stidp", test_stidp, false },
 	{ "testblock", test_testblock, false },
 	{ "diag318", test_diag318, false },
+	{ "qbs", test_qbs, false },
 	{ NULL, NULL, false }
 };
 
-- 
2.36.1

