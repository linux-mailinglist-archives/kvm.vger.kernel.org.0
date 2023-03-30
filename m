Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB966D03A8
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 13:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjC3LpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 07:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjC3Lov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 07:44:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2017A83C8;
        Thu, 30 Mar 2023 04:44:24 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UBb8lj027643;
        Thu, 30 Mar 2023 11:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4JDk3ncKZXU86FTMRQRNJwRzhvtHRmjgsixB4IkaKEg=;
 b=J2qt50Ejf4y/XBJf0B24OG7yLdfbiXISFlcK8uzfMn27gn4LaLwHOUUUv8+Phh2J/zjQ
 9n/2KVZfBiDt/r/cUv160It6map74Y0ZMN/kbuMt2aFOSvjLDdc9sk0na/kJZocJT8ZB
 Oa/0AVy0WKP4Y6/nJietMRWyBLEUt1HvbHt4aD7fQ2jsR7e5I/6CoBCOQ6J7A8v48L4T
 4hFJnOWKt+ofM88muLfQ84MuBiMWqsP9AzXAKvtbNB/OJ3lHG6XbpoYw2KceI4LKuMKJ
 JmGHH1bs44hZ8d/iOBwIlnrG5mOBM0KEWtb84zaUz0CLR0WgC0SLaQYlNVItlFtBGdZV aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp335vtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:46 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UBhj0U025966;
        Thu, 30 Mar 2023 11:43:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp335vtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32U3IgrT011237;
        Thu, 30 Mar 2023 11:43:43 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3phrk6mt8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UBheBL25821544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 11:43:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2EBB20040;
        Thu, 30 Mar 2023 11:43:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B01920043;
        Thu, 30 Mar 2023 11:43:39 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 11:43:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/5] lib: s390x: Add ap library
Date:   Thu, 30 Mar 2023 11:42:40 +0000
Message-Id: <20230330114244.35559-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330114244.35559-1-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e9bGNx0CCYFo3ip1Mxx1NbQaJPa9XhyN
X-Proofpoint-ORIG-GUID: MUFAudQSslP7b_C1sKSyZ5MXfK72C5wa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_07,2023-03-30_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303300095
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add functions and definitions needed to test the Adjunct
Processor (AP) crypto interface.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/ap.h | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+)
 create mode 100644 lib/s390x/ap.c
 create mode 100644 lib/s390x/ap.h

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
new file mode 100644
index 00000000..374fa210
--- /dev/null
+++ b/lib/s390x/ap.c
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AP crypto functions
+ *
+ * Some parts taken from the Linux AP driver.
+ *
+ * Copyright IBM Corp. 2023
+ * Author: Janosch Frank <frankja@linux.ibm.com>
+ *	   Tony Krowiak <akrowia@linux.ibm.com>
+ *	   Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *	   Harald Freudenberger <freude@de.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <interrupt.h>
+#include <ap.h>
+#include <asm/time.h>
+
+int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		 struct pqap_r2 *r2)
+{
+	struct pqap_r0 r0 = {};
+	int cc;
+
+	/*
+	 * Test AP Queue
+	 *
+	 * Writes AP configuration information to the memory pointed
+	 * at by GR2.
+	 *
+	 * Inputs: 0
+	 * Outputs: 1 (APQSW), 2 (tapq data)
+	 * Synchronous
+	 */
+	r0.ap = ap;
+	r0.qn = qn;
+	r0.fc = PQAP_TEST_APQ;
+	asm volatile(
+		"	lgr	0,%[r0]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	stg	1, %[apqsw]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [apqsw] "=&T" (*apqsw), [r2] "+&d" (r2), [cc] "=&d" (cc)
+		: [r0] "d" (r0)
+		: "memory");
+
+	return cc;
+}
+
+int ap_pqap_qci(struct ap_config_info *info)
+{
+	struct pqap_r0 r0 = { .fc = PQAP_QUERY_AP_CONF_INFO };
+	unsigned long r1 = 0;
+	int cc;
+
+	/*
+	 * Query AP Configuration Information
+	 *
+	 * Writes AP configuration information to the memory pointed
+	 * at by GR2.
+	 *
+	 * Inputs: 0,2
+	 * Outputs: memory at r2 address
+	 * Synchronous
+	 */
+	asm volatile(
+		"	lgr	0,%[r0]\n"
+		"	lgr	2,%[info]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [r1] "+&d" (r1), [cc] "=&d" (cc)
+		: [r0] "d" (r0), [info] "d" (info)
+		: "cc", "memory", "0", "2");
+
+	return cc;
+}
+
+bool ap_check(void)
+{
+	struct ap_queue_status r1 = {};
+	struct pqap_r2 r2 = {};
+
+	/* Base AP support has no STFLE or SCLP feature bit */
+	expect_pgm_int();
+	ap_pqap_tapq(0, 0, &r1, &r2);
+
+	if (clear_pgm_int() == PGM_INT_CODE_OPERATION)
+		return false;
+
+	return true;
+}
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
new file mode 100644
index 00000000..79fe6eb0
--- /dev/null
+++ b/lib/s390x/ap.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AP definitions
+ *
+ * Copyright IBM Corp. 2023
+ * Author: Janosch Frank <frankja@linux.ibm.com>
+ *	   Tony Krowiak <akrowia@linux.ibm.com>
+ *	   Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *	   Harald Freudenberger <freude@de.ibm.com>
+ */
+
+#ifndef _S390X_AP_H_
+#define _S390X_AP_H_
+
+enum PQAP_FC {
+	PQAP_TEST_APQ,
+	PQAP_RESET_APQ,
+	PQAP_ZEROIZE_APQ,
+	PQAP_QUEUE_INT_CONTRL,
+	PQAP_QUERY_AP_CONF_INFO,
+	PQAP_QUERY_AP_COMP_TYPE,
+	PQAP_BEST_AP,
+};
+
+struct ap_queue_status {
+	uint32_t pad0;			/* Ignored padding for zArch  */
+	uint32_t empty		: 1;
+	uint32_t replies_waiting: 1;
+	uint32_t full		: 1;
+	uint32_t pad1		: 4;
+	uint32_t irq_enabled	: 1;
+	uint32_t rc		: 8;
+	uint32_t pad2		: 16;
+} __attribute__((packed))  __attribute__((aligned(8)));
+_Static_assert(sizeof(struct ap_queue_status) == sizeof(uint64_t), "APQSW size");
+
+struct ap_config_info {
+	uint8_t apsc	 : 1;	/* S bit */
+	uint8_t apxa	 : 1;	/* N bit */
+	uint8_t qact	 : 1;	/* C bit */
+	uint8_t rc8a	 : 1;	/* R bit */
+	uint8_t l	 : 1;	/* L bit */
+	uint8_t lext	 : 3;	/* Lext bits */
+	uint8_t reserved2[3];
+	uint8_t Na;		/* max # of APs - 1 */
+	uint8_t Nd;		/* max # of Domains - 1 */
+	uint8_t reserved6[10];
+	uint32_t apm[8];	/* AP ID mask */
+	uint32_t aqm[8];	/* AP (usage) queue mask */
+	uint32_t adm[8];	/* AP (control) domain mask */
+	uint8_t _reserved4[16];
+} __attribute__((aligned(8))) __attribute__ ((__packed__));
+_Static_assert(sizeof(struct ap_config_info) == 128, "PQAP QCI size");
+
+struct pqap_r0 {
+	uint32_t pad0;
+	uint8_t fc;
+	uint8_t t : 1;		/* Test facilities (TAPQ)*/
+	uint8_t pad1 : 7;
+	uint8_t ap;
+	uint8_t qn;
+} __attribute__((packed))  __attribute__((aligned(8)));
+
+struct pqap_r2 {
+	uint8_t s : 1;		/* Special Command facility */
+	uint8_t m : 1;		/* AP4KM */
+	uint8_t c : 1;		/* AP4KC */
+	uint8_t cop : 1;	/* AP is in coprocessor mode */
+	uint8_t acc : 1;	/* AP is in accelerator mode */
+	uint8_t xcp : 1;	/* AP is in XCP-mode */
+	uint8_t n : 1;		/* AP extended addressing facility */
+	uint8_t pad_0 : 1;
+	uint8_t pad_1[3];
+	uint8_t at;
+	uint8_t nd;
+	uint8_t pad_6;
+	uint8_t pad_7 : 4;
+	uint8_t qd : 4;
+} __attribute__((packed))  __attribute__((aligned(8)));
+_Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 size");
+
+bool ap_check(void);
+int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		 struct pqap_r2 *r2);
+int ap_pqap_qci(struct ap_config_info *info);
+#endif
-- 
2.34.1

