Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B437BF67B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjJJIvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjJJIvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:51:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08929C6
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:51:20 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8j2ZN011006
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qBF6zsmyaj5I0L80762pP709SBEX0yQJZrP31rNAlso=;
 b=oFNJ/ysS+9T+i5t5rmdXOeO5f9kEKmXWdQhWVw+hlZSY24sWqNyY44JLBhmt5Mv3wW9F
 T4aqAPFUyNINYCJzunC0HgGLN95Q2sBSDPN6dS8Ha5fsoZMzvZ7gb8Btyk8r5i/dDfDy
 q93wXptub33FU6ezMqRqFKr9Yk6p8616VWGXSsK0uO6ZJ4J6nZqWP63R4qMP6zzeOZoj
 EwPR+ON2xU30DK/ArvsRVm73dt1Du4XzJkKCMJHBiyd1Zviw3bhQJrzgbmOnGx0WQx0w
 QIFWwjTR4AXlbUDN0eWPTtSHw1gYz0qc2CHbL0RHo7rJfc4CiZJjr3Kq9Y3H5Uexq+4J 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cf0bg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:19 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8j75s011824
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:12 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cf0b8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:12 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8LJsW000693;
        Tue, 10 Oct 2023 08:51:09 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkk5kf01p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8p67Z14418580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:51:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18FA220040;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1B6420043;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/7] s390x: ap: Add pqap aqic tests
Date:   Tue, 10 Oct 2023 08:49:33 +0000
Message-Id: <20231010084936.70773-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010084936.70773-1-frankja@linux.ibm.com>
References: <20231010084936.70773-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ivvEro_IlXkin99p5NmpVQ9nNjspBrbU
X-Proofpoint-GUID: GmrePOVUxhj45ziyklmRkUutRwhQXrme
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=932 malwarescore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

