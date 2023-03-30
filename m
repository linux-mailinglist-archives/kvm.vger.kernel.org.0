Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E2F6D03AF
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 13:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjC3LpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 07:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjC3Loy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 07:44:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8947ED6;
        Thu, 30 Mar 2023 04:44:32 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UBA39L003131;
        Thu, 30 Mar 2023 11:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8wADBOx4v+MCrfXi2qtbCPcodyNCWqeWEhoeLdy6kkY=;
 b=AqrupF63KenLFEjyvp3jc9QjaQOYsnA+p/YbDg+U9sHcYfaRRQjqVeHSs3BiWe7T7uvk
 dy5eMp8LBvzexX8TfnNaBzEQug3pZLV0E1U/mU/g/bvyWe1xZYf4NI2XLB3H0ZEz2X/y
 B4Fn9lGRDAsAfdSHd+jf/EqoYI9/7yGIeWJ2U7IKFYWZgIYsnn/sZy9D+tDqGIVFfE/K
 dZE10iTRVaQlER2QfT/FfMUCSk6Sdw9Mpfmi9PIO4qS0BlBn6P+lvc03lxp/GZ1nbGnn
 JSnpTOrSK25iCPDlGZw6qrPO9TkV6DpVsupVXETE04JCcnesm5odcMpZSLCwNjmNFzc5 ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmq1pm1ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:48 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UBhmbu004680;
        Thu, 30 Mar 2023 11:43:48 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmq1pm1s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:47 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32TKZfQa019202;
        Thu, 30 Mar 2023 11:43:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6nujp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UBhg9K22872754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 11:43:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9480D2004B;
        Thu, 30 Mar 2023 11:43:42 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E127B20040;
        Thu, 30 Mar 2023 11:43:41 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 11:43:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 4/5] s390x: ap: Add pqap aqic tests
Date:   Thu, 30 Mar 2023 11:42:43 +0000
Message-Id: <20230330114244.35559-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330114244.35559-1-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BKCE0FjLvtp0jE1QsPShbbowBgEZZAx8
X-Proofpoint-ORIG-GUID: jo3Dv3SrtUCqhVz1Sz7wzRevSsDMu3VT
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

Let's check if we can enable/disable interrupts and if all errors are
reported if we specify bad addresses for the notification indication
byte.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 33 +++++++++++++++++++++++++++++
 lib/s390x/ap.h | 11 ++++++++++
 s390x/ap.c     | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index 8d7f2992..aaf5b4b9 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -51,6 +51,39 @@ int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 	return cc;
 }
 
+int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		 struct ap_qirq_ctrl aqic, unsigned long addr)
+{
+	struct pqap_r0 r0 = {};
+	int cc;
+
+	/*
+	 * AP-Queue Interruption Control
+	 *
+	 * Enables/disables interrupts for a APQN
+	 *
+	 * Inputs: 0,1,2
+	 * Outputs: 1 (APQSW)
+	 * Synchronous
+	 */
+	r0.ap = ap;
+	r0.qn = qn;
+	r0.fc = PQAP_QUEUE_INT_CONTRL;
+	asm volatile(
+		"	lgr	0,%[r0]\n"
+		"	lgr	1,%[aqic]\n"
+		"	lgr	2,%[addr]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	stg	1, %[apqsw]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [apqsw] "=T" (*apqsw), [cc] "=&d" (cc)
+		: [r0] "d" (r0), [aqic] "d" (aqic), [addr] "d" (addr)
+		: "cc", "memory", "0", "2");
+
+	return cc;
+}
+
 int ap_pqap_qci(struct ap_config_info *info)
 {
 	struct pqap_r0 r0 = { .fc = PQAP_QUERY_AP_CONF_INFO };
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index 59595eba..3f9e2eb6 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -79,6 +79,15 @@ struct pqap_r2 {
 } __attribute__((packed))  __attribute__((aligned(8)));
 _Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 size");
 
+struct ap_qirq_ctrl {
+	uint64_t res0 : 16;
+	uint64_t ir    : 1;	/* ir flag: enable (1) or disable (0) irq */
+	uint64_t res1 : 44;
+	uint64_t isc   : 3;	/* irq sub class */
+} __attribute__((packed))  __attribute__((aligned(8)));
+_Static_assert(sizeof(struct ap_qirq_ctrl) == sizeof(uint64_t),
+	       "struct ap_qirq_ctrl size");
+
 #define AP_SETUP_NOINSTR	-1
 #define AP_SETUP_NOAPQN		1
 
@@ -86,4 +95,6 @@ int ap_setup(uint8_t *ap, uint8_t *qn);
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct pqap_r2 *r2);
 int ap_pqap_qci(struct ap_config_info *info);
+int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		 struct ap_qirq_ctrl aqic, unsigned long addr);
 #endif
diff --git a/s390x/ap.c b/s390x/ap.c
index 20b4e76e..31dcfe29 100644
--- a/s390x/ap.c
+++ b/s390x/ap.c
@@ -292,6 +292,55 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_pqap_aqic(void)
+{
+	struct ap_queue_status apqsw = {};
+	static uint8_t not_ind_byte;
+	struct ap_qirq_ctrl aqic = {};
+	struct pqap_r2 r2 = {};
+
+	int cc;
+
+	report_prefix_push("pqap");
+	report_prefix_push("aqic");
+
+	ap_pqap_tapq(apn, qn, &apqsw, &r2);
+
+	aqic.ir = 1;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, 0);
+	report(cc == 3 && apqsw.rc == 6, "invalid addr 0");
+
+	aqic.ir = 1;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, -1);
+	report(cc == 3 && apqsw.rc == 6, "invalid addr -1");
+
+	aqic.ir = 0;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
+	report(cc == 3 && apqsw.rc == 7, "disable");
+
+	aqic.ir = 1;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
+	report(cc == 0 && apqsw.rc == 0, "enable");
+
+	do {
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	} while (cc == 0 && apqsw.irq_enabled == 0);
+
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
+	report(cc == 3 && apqsw.rc == 7, "enable while enabled");
+
+	aqic.ir = 0;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
+	assert(cc == 0 && apqsw.rc == 0);
+
+	do {
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	} while (cc == 0 && apqsw.irq_enabled == 1);
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	int setup_rc = ap_setup(&apn, &qn);
@@ -307,6 +356,13 @@ int main(void)
 	test_pgms_nqap();
 	test_pgms_dqap();
 
+	/* The next tests need queues */
+	if (setup_rc == AP_SETUP_NOAPQN) {
+		report_skip("No APQN available");
+		goto done;
+	}
+	test_pqap_aqic();
+
 done:
 	report_prefix_pop();
 	return report_summary();
-- 
2.34.1

