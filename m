Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741616D03AB
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 13:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbjC3LpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 07:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjC3Loz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 07:44:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF419EED;
        Thu, 30 Mar 2023 04:44:33 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UBA5Pp003326;
        Thu, 30 Mar 2023 11:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XO17w8KdyosBV0pUgCFUV4D+xaV6cFlDxqnOuUyBrvo=;
 b=J5FadfI37nklgHdS61+zgAeRIjlufOjKA8WnqIyLvJ5HauEmy3+YGEciu9hmjBtguXeJ
 R/eU+i3bKECU+sMKNpLpjl5tuL6fxhaE+YFgGuy9ctgmVZWQu2zznShEIclJsIjBifoB
 WNDOijl9xqGsbYGNRJR9Blg8HVVFInrpo0kG4VDcO2e42UOQ2ivnmD8XkogLxOXlxWqc
 8HLRcRJov1Hj2Ktb9AYtH3YZSuZyypMuqI7rOD1GZxFWcR65ehkPnnnrI+mYKCthFqpP
 xuqwP1LWUTFZqJjMPhO9UT5qbQpHjUo8gM2X0cW3uBu/L5TdjBhH562x3iOEqFHkYw1L 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmq1pm1tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:49 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UBAJO3004995;
        Thu, 30 Mar 2023 11:43:49 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmq1pm1sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32TLqbsR003825;
        Thu, 30 Mar 2023 11:43:47 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3phrk6ms20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UBhhu440894892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 11:43:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74B0120049;
        Thu, 30 Mar 2023 11:43:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C119620040;
        Thu, 30 Mar 2023 11:43:42 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 11:43:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 5/5] s390x: ap: Add reset tests
Date:   Thu, 30 Mar 2023 11:42:44 +0000
Message-Id: <20230330114244.35559-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330114244.35559-1-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I5_mCWp2ugOhj3MfLEsjAmeStljk8UlL
X-Proofpoint-ORIG-GUID: NMlbosLje0nwTcJhqEQCdYs6Dk_ja9xm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_07,2023-03-30_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300095
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test if the IRQ enablement is turned off on a reset or zeroize PQAP.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/ap.h |  4 +++
 s390x/ap.c     | 52 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index aaf5b4b9..d969b2a5 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -113,6 +113,74 @@ int ap_pqap_qci(struct ap_config_info *info)
 	return cc;
 }
 
+static int pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *r1,
+		      bool zeroize)
+{
+	struct pqap_r0 r0 = {};
+	int cc;
+
+	/*
+	 * Reset/zeroize AP Queue
+	 *
+	 * Resets/zeroizes a queue and disables IRQs
+	 *
+	 * Inputs: 0
+	 * Outputs: 1
+	 * Asynchronous
+	 */
+	r0.ap = ap;
+	r0.qn = qn;
+	r0.fc = zeroize ? PQAP_ZEROIZE_APQ : PQAP_RESET_APQ;
+	asm volatile(
+		"	lgr	0,%[r0]\n"
+		"	lgr	1,%[r1]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [r1] "+&d" (r1), [cc] "=&d" (cc)
+		: [r0] "d" (r0)
+		: "memory");
+
+	return cc;
+}
+
+static int pqap_reset_wait(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+			   bool zeroize)
+{
+	struct pqap_r2 r2 = {};
+	int cc;
+
+	cc = pqap_reset(ap, qn, apqsw, zeroize);
+	/* On a cc == 3 / error we don't need to wait */
+	if (cc)
+		return cc;
+
+	/*
+	 * TAPQ returns AP_RC_RESET_IN_PROGRESS if a reset is being
+	 * processed
+	 */
+	do {
+		cc = ap_pqap_tapq(ap, qn, apqsw, &r2);
+		/* Give it some time to process before the retry */
+		mdelay(20);
+	} while (apqsw->rc == AP_RC_RESET_IN_PROGRESS);
+
+	if (apqsw->rc)
+		printf("Wait for reset failed on ap %d queue %d with tapq rc %d.",
+			ap, qn, apqsw->rc);
+	return cc;
+}
+
+int ap_pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw)
+{
+	return pqap_reset_wait(ap, qn, apqsw, false);
+}
+
+int ap_pqap_reset_zeroize(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw)
+{
+	return pqap_reset_wait(ap, qn, apqsw, true);
+}
+
 static int ap_get_apqn(uint8_t *ap, uint8_t *qn)
 {
 	unsigned long *ptr;
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index 3f9e2eb6..f9343b5f 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -12,6 +12,8 @@
 #ifndef _S390X_AP_H_
 #define _S390X_AP_H_
 
+#define AP_RC_RESET_IN_PROGRESS	0x02
+
 enum PQAP_FC {
 	PQAP_TEST_APQ,
 	PQAP_RESET_APQ,
@@ -94,6 +96,8 @@ _Static_assert(sizeof(struct ap_qirq_ctrl) == sizeof(uint64_t),
 int ap_setup(uint8_t *ap, uint8_t *qn);
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct pqap_r2 *r2);
+int ap_pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
+int ap_pqap_reset_zeroize(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
 int ap_pqap_qci(struct ap_config_info *info);
 int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct ap_qirq_ctrl aqic, unsigned long addr);
diff --git a/s390x/ap.c b/s390x/ap.c
index 31dcfe29..47b4f832 100644
--- a/s390x/ap.c
+++ b/s390x/ap.c
@@ -341,6 +341,57 @@ static void test_pqap_aqic(void)
 	report_prefix_pop();
 }
 
+static void test_pqap_resets(void)
+{
+	struct ap_queue_status apqsw = {};
+	static uint8_t not_ind_byte;
+	struct ap_qirq_ctrl aqic = {};
+	struct pqap_r2 r2 = {};
+
+	int cc;
+
+	report_prefix_push("pqap");
+	report_prefix_push("rapq");
+
+	/* Enable IRQs which the resets will disable */
+	aqic.ir = 1;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
+	report(cc == 0 && apqsw.rc == 0, "enable");
+
+	do {
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	} while (cc == 0 && apqsw.irq_enabled == 0);
+	report(apqsw.irq_enabled == 1, "IRQs enabled");
+
+	ap_pqap_reset(apn, qn, &apqsw);
+	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	assert(!cc);
+	report(apqsw.irq_enabled == 0, "IRQs have been disabled");
+
+	report_prefix_pop();
+
+	report_prefix_push("zapq");
+
+	/* Enable IRQs which the resets will disable */
+	aqic.ir = 1;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
+	report(cc == 0 && apqsw.rc == 0, "enable");
+
+	do {
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	} while (cc == 0 && apqsw.irq_enabled == 0);
+	report(apqsw.irq_enabled == 1, "IRQs enabled");
+
+	ap_pqap_reset_zeroize(apn, qn, &apqsw);
+	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	assert(!cc);
+	report(apqsw.irq_enabled == 0, "IRQs have been disabled");
+
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	int setup_rc = ap_setup(&apn, &qn);
@@ -362,6 +413,7 @@ int main(void)
 		goto done;
 	}
 	test_pqap_aqic();
+	test_pqap_resets();
 
 done:
 	report_prefix_pop();
-- 
2.34.1

