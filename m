Return-Path: <kvm+bounces-1966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C76A57EF50B
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D4F9280E23
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518713A8E6;
	Fri, 17 Nov 2023 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jzc+f7iV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AFCD67;
	Fri, 17 Nov 2023 07:20:02 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFG9ig031782;
	Fri, 17 Nov 2023 15:20:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G0XnmZfu2SkHR+t0qTf9/eCWhw8RbAwq5JQajxUkXjo=;
 b=Jzc+f7iV/KnHWMuI0a0CiWWndAFQuroFfUme27ONIbxW9svIBSr964vqUFRlFn1f//ei
 Cx/IUhxVTFK6hDF35lp3uSiJbt7B2Kq2ap+AcKtBcQp8hjn4hfbqmz5mdEDMte08O4I4
 pmUBl1dSldboByOdJ+Gicd2tyzLlMeGp6QQYcksp9OKiPcvMLbO0EmYJEtvqYWOu8V+O
 e4vwTm9GqkUeFKhJ1Ch9N+8ROKLKRepn1YJ5DeP0CTdGulU7BIo9Y5fuQ1R9EgzoG5Qh
 t+3nNgH9YpILmtUBOdPUAzdq0g/L4T5gFDX19ef0YYu3Rwfkw1cX/gdz4jSkO+uLFSg6 gw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueanvg41t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:20:01 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHFGFao032004;
	Fri, 17 Nov 2023 15:20:00 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueanvg411-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:20:00 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFJImg020641;
	Fri, 17 Nov 2023 15:20:00 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uap5kpdgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHFJvDj16188136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 15:19:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0916120040;
	Fri, 17 Nov 2023 15:19:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD9342004B;
	Fri, 17 Nov 2023 15:19:56 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 15:19:56 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 7/7] s390x: ap: Add nq/dq len test
Date: Fri, 17 Nov 2023 15:19:39 +0000
Message-Id: <20231117151939.971079-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231117151939.971079-1-frankja@linux.ibm.com>
References: <20231117151939.971079-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YBVUBK7Y9Q1V0I0j8_LmGNprubW69iLn
X-Proofpoint-GUID: iMWZWFfZvI73_xo7qzwYtQWicImqHyIU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_14,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 phishscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311170114

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


