Return-Path: <kvm+bounces-7858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF09847291
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 274DBB26770
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5781468F9;
	Fri,  2 Feb 2024 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jq1K6tBQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA1414532F;
	Fri,  2 Feb 2024 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706886302; cv=none; b=tmULkPCQODdJdzGf1SIVNfomYpVeTl6JyT3JRgW/KWaZcyn5g9NnrnyFM48RG3ey+Ycea4o2Ev6FWD0HAzOg24Kt7LHHcpkAS/KtbMkU7lhJT5OFAhcFpsHd/vvpYQwJYr4P36d9PLE0+tPpcFcP+SvNlka8AQ5KtJQJ40TloYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706886302; c=relaxed/simple;
	bh=panHm4zVut/UkEbKj8tX2qEd5loaII6ZngoJDwNsZB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y6xby+M6v+QGLj3zla5iMgWhbeMoUmsdItSsVDc5rYwRhfmTA/rCg1ydgvsSCyoUyFHiETOAMlqUJLUmlfdoqayY0aRES/+KLsSDWpx+vFUj+dfnv8qbgOLDyInrIsNAme06zOZnZfkui3pBEcPOd2RML6Otyw5aGJoM6PpD47I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jq1K6tBQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 412EbPMj002743;
	Fri, 2 Feb 2024 15:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WFxjai1+iiCYjwANt4Zuw89dNfb3lF7ItBOSYloffPs=;
 b=jq1K6tBQJc7UHbTOQwqwg6QLHjcZ/M8FZHR4558CwmSSVQr4ZkxUSOPWG2rmX9o9JSeG
 22sVFizzDukg7e8Im5yFh1m8e9ypeIU0GfRd0l0Xi35dn2U1sqel/31xtNk0stUDCyZF
 nZJXOsyNrbe7ToR/irqTCXNEgTAzhOPqoYVlShbzG8mIPPZ4gTlmrGzlBK9KZBLVNFrL
 7IyOvwlZxwMenvFY5/SwtSw0rED7GIEmalU+hKNshujb5+L77VYLzroYOrQLIkjVmbM+
 GRVF9xN0Ap3hYx6Q/FGIU+1l60P3VAlVc1fC3MqkR8LVB/9qFtbsrYBYTrXOX71B1pyP Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w107047dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 412EcXHB006032;
	Fri, 2 Feb 2024 15:04:59 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w107047dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 412D1hQc011067;
	Fri, 2 Feb 2024 15:04:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwd5pby3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:58 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 412F4tbG39256664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Feb 2024 15:04:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2812720040;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA7A22004B;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 4/7] s390x: ap: Add pqap aqic tests
Date: Fri,  2 Feb 2024 14:59:10 +0000
Message-Id: <20240202145913.34831-5-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: gI_UGhRkyPO9NxKSQmAMmr8ONWVGhyYn
X-Proofpoint-ORIG-GUID: 88JB_q1w1l0Pm33U6Ma31pAY9pRQWrjg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-02_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402020109

Let's check if we can enable/disable interrupts and if all errors are
reported if we specify bad addresses for the notification indication
byte.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 35 +++++++++++++++++++++++
 lib/s390x/ap.h | 11 ++++++++
 s390x/ap.c     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index c85172a8..4e7d3d34 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -60,6 +60,41 @@ int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 	return cc;
 }
 
+int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		 struct ap_qirq_ctrl aqic, unsigned long addr)
+{
+	uint64_t bogus_cc = 2;
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
+		"       tmll	%[bogus_cc],3\n"
+		"	lgr	0,%[r0]\n"
+		"	lgr	1,%[aqic]\n"
+		"	lgr	2,%[addr]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	stg	1, %[apqsw]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [apqsw] "=&T" (*apqsw), [cc] "=&d" (cc)
+		: [r0] "d" (r0), [aqic] "d" (aqic), [addr] "d" (addr), [bogus_cc] "d" (bogus_cc)
+		: "cc", "memory", "0", "2");
+
+	return cc;
+}
+
 int ap_pqap_qci(struct ap_config_info *info)
 {
 	struct pqap_r0 r0 = { .fc = PQAP_QUERY_AP_CONF_INFO };
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index 8feca43a..15394d56 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -81,6 +81,15 @@ struct pqap_r2 {
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
 /*
  * Maximum number of APQNs that we keep track of.
  *
@@ -100,4 +109,6 @@ int ap_setup(uint8_t **ap_array, uint8_t **qn_array, uint8_t *naps, uint8_t *nqn
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct pqap_r2 *r2);
 int ap_pqap_qci(struct ap_config_info *info);
+int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		 struct ap_qirq_ctrl aqic, unsigned long addr);
 #endif
diff --git a/s390x/ap.c b/s390x/ap.c
index 5c458e7e..6f95a716 100644
--- a/s390x/ap.c
+++ b/s390x/ap.c
@@ -12,10 +12,15 @@
 #include <interrupt.h>
 #include <bitops.h>
 #include <alloc_page.h>
+#include <malloc_io.h>
+#include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/time.h>
 #include <ap.h>
 
+static uint8_t apn;
+static uint8_t qn;
+
 /* For PQAP PGM checks where we need full control over the input */
 static void pqap(unsigned long grs[3])
 {
@@ -290,9 +295,63 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_pqap_aqic(void)
+{
+	uint8_t *not_ind_byte = alloc_io_mem(PAGE_SIZE, 0);
+	struct ap_queue_status apqsw = {};
+	struct ap_qirq_ctrl aqic = {};
+	struct pqap_r2 r2 = {};
+	int cc;
+
+	report_prefix_push("aqic");
+	*not_ind_byte = 0;
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
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)not_ind_byte);
+	report(cc == 3 && apqsw.rc == 7, "disable IRQs while already disabled");
+
+	aqic.ir = 1;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)not_ind_byte);
+	report(cc == 0 && apqsw.rc == 0, "enable IRQs");
+
+	do {
+		mdelay(20);
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	} while (cc == 0 && apqsw.irq_enabled == 0);
+	report(cc == 0 && apqsw.irq_enabled == 1, "enable IRQs tapq data");
+
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)not_ind_byte);
+	report(cc == 3 && apqsw.rc == 7, "enable IRQs while already enabled");
+
+	aqic.ir = 0;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)not_ind_byte);
+	report(cc == 0 && apqsw.rc == 0, "disable IRQs");
+
+	do {
+		mdelay(20);
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	} while (cc == 0 && apqsw.irq_enabled == 1);
+	report(cc == 0 && apqsw.irq_enabled == 0, "disable IRQs tapq data");
+
+	report_prefix_pop();
+
+	free_io_mem(not_ind_byte, PAGE_SIZE);
+}
+
 int main(void)
 {
-	int setup_rc = ap_setup(NULL, NULL, NULL, NULL);
+	uint8_t num_ap, num_qn;
+	uint8_t *apns;
+	uint8_t *qns;
+	int setup_rc = ap_setup(&apns, &qns, &num_ap, &num_qn);
 
 	report_prefix_push("ap");
 	if (setup_rc == AP_SETUP_NOINSTR) {
@@ -305,6 +364,20 @@ int main(void)
 	test_pgms_nqap();
 	test_pgms_dqap();
 
+	/* The next tests need queues */
+	if (setup_rc == AP_SETUP_NOAPQN) {
+		report_skip("No APQN available");
+		goto done;
+	}
+	apn = apns[0];
+	qn = qns[0];
+	report_prefix_push("pqap");
+	if (test_facility(65))
+		test_pqap_aqic();
+	else
+		report_skip("no AQIC and reset tests without IRQ support");
+	report_prefix_pop();
+
 done:
 	report_prefix_pop();
 	return report_summary();
-- 
2.40.1


