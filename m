Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F017BF67E
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjJJIvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjJJIvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:51:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12E397
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:51:32 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8k7nF020416
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bBt+AcKEPwHlT1mhIG6eOxmu5yk+gOSnOCal5q7tATg=;
 b=HcPwWT/vNJaoWhQP9fenVS4Q71f1iT4q4tv3q9pLrd9EryeSkb4AjR1CqfPQOUC1yIqu
 uUW+REN2aKfVbRRlDd+PsAgMXGTvUqTtvztfJY9Wb7Zbm1L//uI8gjOhclTnjhoi5+dm
 tklEwwuDGUe09B0DuNOgTrXf1EuSQfdnTdjuT7rHPYmH0vDw8m0Qi5poOFal9BJhOYKf
 ayWqJ2oT75b/Jz7/4d5ZVOyjmy+hX03d8/MA0bu3AYsEVThL62dzehimGEEN5FQy/6Sh
 Qgu667bYogbE/9gWsHiT7884rcu+ofXqvx+nVK97XBwfu712JTTty+/MypgbU2D3U83+ uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3ct08u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:29 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8kbXS021575
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:19 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3ct07xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:18 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A7B6M7028255;
        Tue, 10 Oct 2023 08:51:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkj1xybyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:08 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8p5JJ6554112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:51:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A25C2004F;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E9FD2004E;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/7] lib: s390x: Add ap library
Date:   Tue, 10 Oct 2023 08:49:30 +0000
Message-Id: <20231010084936.70773-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010084936.70773-1-frankja@linux.ibm.com>
References: <20231010084936.70773-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KITtciHsIDcmo0Da8wS0YPAm_0lMjtMQ
X-Proofpoint-GUID: nn2wUdaZC6udytAyxCoVcOe92dbmJ-rb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 phishscore=0
 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add functions and definitions needed to test the Adjunct
Processor (AP) crypto interface.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/ap.h | 88 +++++++++++++++++++++++++++++++++++++++++++++++
 s390x/Makefile |  1 +
 3 files changed, 181 insertions(+)
 create mode 100644 lib/s390x/ap.c
 create mode 100644 lib/s390x/ap.h

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
new file mode 100644
index 00000000..4af3cdee
--- /dev/null
+++ b/lib/s390x/ap.c
@@ -0,0 +1,92 @@
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
+#include <asm/facility.h>
+
+int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		 struct pqap_r2 *r2)
+{
+	struct pqap_r0 r0 = {
+		.ap = ap,
+		.qn = qn,
+		.fc = PQAP_TEST_APQ
+	};
+	int cc;
+
+	/*
+	 * Test AP Queue
+	 *
+	 * Writes AP configuration information to the memory pointed
+	 * at by GR2.
+	 *
+	 * Inputs: GR0
+	 * Outputs: GR1 (APQSW), GR2 (tapq data)
+	 * Synchronous
+	 */
+	asm volatile(
+		"	lgr	0,%[r0]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	stg	1,%[apqsw]\n"
+		"	stg	2,%[r2]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [apqsw] "=&T" (*apqsw), [r2] "=&T" (*r2), [cc] "=&d" (cc)
+		: [r0] "d" (r0));
+
+	return cc;
+}
+
+int ap_pqap_qci(struct ap_config_info *info)
+{
+	struct pqap_r0 r0 = { .fc = PQAP_QUERY_AP_CONF_INFO };
+	int cc;
+
+	/*
+	 * Query AP Configuration Information
+	 *
+	 * Writes AP configuration information to the memory pointed
+	 * at by GR2.
+	 *
+	 * Inputs: GR0, GR2 (QCI block address)
+	 * Outputs: memory at GR2 address
+	 * Synchronous
+	 */
+	asm volatile(
+		"	lgr	0,%[r0]\n"
+		"	lgr	2,%[info]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=&d" (cc)
+		: [r0] "d" (r0), [info] "d" (info)
+		: "cc", "memory", "0", "2");
+
+	return cc;
+}
+
+bool ap_check(void)
+{
+	/*
+	 * Base AP support has no STFLE or SCLP feature bit but the
+	 * PQAP QCI support is indicated via stfle bit 12. As this
+	 * library relies on QCI we bail out if it's not available.
+	 */
+	if (!test_facility(12))
+		return false;
+
+	return true;
+}
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
new file mode 100644
index 00000000..411591f2
--- /dev/null
+++ b/lib/s390x/ap.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AP definitions
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
diff --git a/s390x/Makefile b/s390x/Makefile
index 6e967194..d9abe5c1 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -109,6 +109,7 @@ cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
 cflatobjs += lib/s390x/fault.o
+cflatobjs += lib/s390x/ap.o
 
 OBJDIRS += lib/s390x
 
-- 
2.34.1

