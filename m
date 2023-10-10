Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CCF7BF67C
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjJJIvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjJJIv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:51:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F381FDB
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:51:24 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8k0pZ029383
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G0XnmZfu2SkHR+t0qTf9/eCWhw8RbAwq5JQajxUkXjo=;
 b=iVruL+olqpvT2UGkmAj3RbDbtS2qA9CVagScYHCyUE0G5Izy6ryg9zTTO4Q6lz+UI2LW
 4zeqjwqcNl8KsTvx9gSZqrvleblykxu6C/GO27cJiXGhWG6dOTHar3zjZYvXw+lH8SUw
 q5MUhVXyJRx9sxQJBp9CB3g3Ds2b8Zb8KbG3lkPugDGKs+sEs3x2Dkz8TD2Ep3DWXNV0
 eb8R9OTfHCkiBzYZVYiaIcP8nyJ9F3W92pUz1IaIkcre2NRDpz+PGJ8V+mmYjDL3syN9
 hRPp0oommanNDahAyzGybbnXu+CPa/juvRiATg3yM3maZSPIMdhdaMY5SATNBGcqUk6N vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cug8ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:23 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8k1U7029460
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:12 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cug81s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:12 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6uAl1024445;
        Tue, 10 Oct 2023 08:51:09 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkhnsffpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8p6iQ17105602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:51:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2C5320043;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87F342005A;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 7/7] s390x: ap: Add nq/dq len test
Date:   Tue, 10 Oct 2023 08:49:36 +0000
Message-Id: <20231010084936.70773-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010084936.70773-1-frankja@linux.ibm.com>
References: <20231010084936.70773-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A3aLEmFTzJCqZeYFjU-HWID7Q55kBXhk
X-Proofpoint-ORIG-GUID: LCqsg8Nj_H4fpcw0uXq0Zeq3sFUZEBtj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For years the nqap/dqap max length was 12KB but with a recent machine
extended message length support was introduced. The support is AP type
and generation specific, so it can vary from card to card which
complicates testing by a lot.

This test will use the APQN that all other tests use no matter if
there's extended length support or not. But if longer messages are
supported by the APQN we need to adapt our tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.h |   3 +-
 s390x/ap.c     | 103 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index 17f8016d..2511074d 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -77,7 +77,8 @@ struct pqap_r2 {
 	uint8_t pad_1[3];
 	uint8_t at;
 	uint8_t nd;
-	uint8_t pad_6;
+	uint8_t pad_6 : 4;
+	uint8_t ml : 4;
 	uint8_t pad_7 : 4;
 	uint8_t qd : 4;
 } __attribute__((packed))  __attribute__((aligned(8)));
diff --git a/s390x/ap.c b/s390x/ap.c
index 05664df8..89c22b81 100644
--- a/s390x/ap.c
+++ b/s390x/ap.c
@@ -257,6 +257,106 @@ static void test_pgms_dqap(void)
 	report_prefix_pop();
 }
 
+/*
+ * For years the nqap/dqap max length was 12KB but with a recent
+ * machine extended message length support was introduced. The support
+ * is AP type and generation specific, so it can vary from card to
+ * card.
+ *
+ * This test will use the APQN that all other tests use no matter if
+ * there's extended length support or not. But if longer messages are
+ * supported by the APQN we need to adapt our tests.
+ */
+static void test_pgms_nqdq_len(void)
+{
+	struct ap_queue_status apqsw = {};
+	struct pqap_r2 r2 = {};
+	uint64_t len, mlen;
+	bool fail;
+	int i;
+
+	/* Extended message support is reported via tapq with T=1 */
+	ap_pqap_tapq(apn, qn, &apqsw, &r2, true);
+	/* < 3 means 3 because of backwards compatibility */
+	mlen = r2.ml ? r2.ml : 3;
+	/* Len is reported in pages */
+	mlen *= PAGE_SIZE;
+
+	report_prefix_push("nqap");
+	report_prefix_push("spec");
+
+	report_prefix_push("len + 1");
+	expect_pgm_int();
+	len = mlen + 1;
+	asm volatile (
+		"lg	5,  0(%[len])\n"
+		".insn	rre,0xb2ae0000,2,4\n"
+		: : [len] "a" (&len)
+		: "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("len bits");
+	fail = false;
+	for (i = 12; i < 63; i++) {
+		len = BIT(i);
+		if (len < mlen)
+			continue;
+		expect_pgm_int();
+		asm volatile (
+			"lg	5,  0(%[len])\n"
+			".insn	rre,0xb2ae0000,2,4\n"
+			: : [len] "a" (&len)
+			: "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
+		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("setting len to %lx did not result in a spec exception",
+				    len);
+			fail = true;
+		}
+	}
+	report(!fail, "length pgms");
+	report_prefix_pop();
+	report_prefix_pop();
+	report_prefix_pop();
+
+	report_prefix_push("dqap");
+	report_prefix_push("spec");
+
+	report_prefix_push("len + 1");
+	expect_pgm_int();
+	len = mlen + 1;
+	asm volatile (
+		"lg	5,  0(%[len])\n"
+		".insn	rre,0xb2ae0000,2,4\n"
+		: : [len] "a" (&len)
+		: "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("len bits");
+	fail = false;
+	for (i = 12; i < 63; i++) {
+		len = BIT(i);
+		if (len < mlen)
+			continue;
+		expect_pgm_int();
+		asm volatile (
+			"lg	5,  0(%[len])\n"
+			".insn	rre,0xb2ae0000,2,4\n"
+			: : [len] "a" (&len)
+			: "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
+		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("setting len to %lx did not result in a spec exception",
+				    len);
+			fail = true;
+		}
+	}
+	report(!fail, "length pgms");
+	report_prefix_pop();
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
 static void test_priv(void)
 {
 	struct ap_config_info info = {};
@@ -446,6 +546,9 @@ int main(void)
 	}
 	apn = apns[0];
 	qn = qns[0];
+
+	test_pgms_nqdq_len();
+
 	report_prefix_push("pqap");
 	if (test_facility(65)) {
 		test_pqap_aqic();
-- 
2.34.1

