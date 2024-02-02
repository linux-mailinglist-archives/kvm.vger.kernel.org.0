Return-Path: <kvm+bounces-7860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B71B5847292
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB6261C26DFD
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDF3146911;
	Fri,  2 Feb 2024 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jUdx4xjU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DBB145346;
	Fri,  2 Feb 2024 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706886303; cv=none; b=spbVLI32ZSn0P0HCR45suVfVzmbL0vusgYCpT86Ni7QPPVCyNjDREpT83in8Wz6S7dfIGlD2GtCAgQL3Pwk+Xj2XhHQonwilK+CH8NI2hAQGxj1TfRT18SaZ7Q4iw21XRPt5Nqc8atRriF1Hjb2Xy2NMLULdqwTMQGrFh9FWMqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706886303; c=relaxed/simple;
	bh=MmHFruIEQPPNV6IzR8a9y1V2kpuZAhG2jGPaYq6CLUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jR++jaMTEEOBoTxmgjSPC5zWtVBkzAu0hW1pgDHCQHm8o8dD1rwJb6eol4L+gUvgKM/nfo51AoR+V7L7lZqlIzvHM6ZOfQeIoVTe+OKlj/By4GV1Y9jlYrtIfMYaZn8mXK3tiamFmoN7Ro0D5CTVIaE8//hPMQgP/UIflSDxzFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jUdx4xjU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 412DlEmQ028249;
	Fri, 2 Feb 2024 15:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PlxEm0GI6NfvVvLPF4GC52hpl5uvmNkqBPfzvMvCxpc=;
 b=jUdx4xjUD2+GbZ/ont1s/53HxYsuGvMgsBccpayCs2p12O/3xgAipNJlNzIN2B0SLZQw
 hLdtP89EjqY01//pnWqYxpfDhOhQNaWx53HrY893HdSxr2vf+7WJbk/a0NHeqSvmguvV
 31dhQ/CHVFggPvgYBg1+05WeFC6n4itqBi+9Bd9CndSDnpqg0kSoQNZZWV4UCx1E8C1Z
 kqymWm3ytS74snDhJ/ykw7D+V8diBs+yIdkBP0gBDC0CkTIzHiQdUVDf4d+qU2dmi4er
 REUWizGm2ODiyCEbcPn7TifOBZvcAOp/vyUCy+PnO4NqKK0XMI8dbCU7wPkbmy+tMztq Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w11k0t01e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:05:00 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 412ExjWN019791;
	Fri, 2 Feb 2024 15:04:59 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w11k0t011-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 412DZDFM007188;
	Fri, 2 Feb 2024 15:04:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwev2ujpf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:58 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 412F4t5Y39256670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Feb 2024 15:04:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3BA92004B;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1C1720049;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 7/7] s390x: ap: Add nq/dq len test
Date: Fri,  2 Feb 2024 14:59:13 +0000
Message-Id: <20240202145913.34831-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240202145913.34831-1-frankja@linux.ibm.com>
References: <20240202145913.34831-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QZN35oTWpnaN1SopNV_bX_iFmPxdVnb9
X-Proofpoint-ORIG-GUID: lfGUVY64yK9SIsMQ1Wj2tQ4Wumrbw2T2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-02_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402020109

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
index eecb39be..792149ea 100644
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
index 0f2d03c2..edb4943b 100644
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
2.40.1


