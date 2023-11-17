Return-Path: <kvm+bounces-1968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E29057EF50F
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:20:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55D82B20CA8
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828F83D3A3;
	Fri, 17 Nov 2023 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qhelr6R1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2E1D5E;
	Fri, 17 Nov 2023 07:20:01 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFHJwF032182;
	Fri, 17 Nov 2023 15:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qBF6zsmyaj5I0L80762pP709SBEX0yQJZrP31rNAlso=;
 b=qhelr6R1w8m+8p3UXmOpnzYFkLnYZ+bskhaPcMMaVlQTtDC1eNLf+qgktGo7EVM+4Dkv
 GVoRCo82ROQIXzU5k6g4ygTT2uE+PIzEhDv9jSoFoig8xn+ykqFU4NLacaXY+4DVqfj0
 M5Mjy7lp4IVlZdYGCw7nl/dJOYHHQ3J6ezXHIU22y2UyGYEhhobZAcEN3vUiYBB8HTUE
 fEW+Ok6mQJIwP6UBikZIvysCAWylalqcqceK5Qzl+5gduSwPVkFWm0N5QczM25ym65no
 03BD9MmL0YmOkU7xAq27YHsGgkzI4X+YP6oifnjU22RTHrbfDY0XGNFCE49FIdnEpmzr 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueap8r2m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:20:00 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHFJa6u007384;
	Fri, 17 Nov 2023 15:19:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueap8r2ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHD41HQ015851;
	Fri, 17 Nov 2023 15:19:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uanem6q3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHFJua065995164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 15:19:56 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BD6E2004B;
	Fri, 17 Nov 2023 15:19:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D096D20040;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 4/7] s390x: ap: Add pqap aqic tests
Date: Fri, 17 Nov 2023 15:19:36 +0000
Message-Id: <20231117151939.971079-5-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: 5sOK0mheNR9_fK1qyuvGFPUIOeHFoq-0
X-Proofpoint-ORIG-GUID: fcRYG3vLFzPJ1CE7-1oW2mju570LRgFb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_14,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311170114

Let's check if we can enable/disable interrupts and if all errors are
reported if we specify bad addresses for the notification indication
byte.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 33 ++++++++++++++++++++++
 lib/s390x/ap.h | 11 ++++++++
 s390x/ap.c     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index 9ba5a037..23338c2d 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -58,6 +58,39 @@ int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
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
+		: [apqsw] "=&T" (*apqsw), [cc] "=&d" (cc)
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
index ac9e59d1..7a91881d 100644
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
index 32feb8db..8ea2b52e 100644
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
2.34.1


