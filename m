Return-Path: <kvm+bounces-1964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B4E7EF509
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DCABB20AC1
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42942374F5;
	Fri, 17 Nov 2023 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bCKL3huy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB2AD57;
	Fri, 17 Nov 2023 07:20:00 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFHsld032666;
	Fri, 17 Nov 2023 15:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uXngpEpqKrdvxWVxKscGwesmwSzGjkt0nz0zZlt94vw=;
 b=bCKL3huy7JPLyWR3boQOkXW2j/yEDPV8gsDh60bIw+tH5wSKteYx6B+rOH//Ou7ON++C
 OSSxhcKj31Rm7CA0L2fyGP4brAmygAMiWa1iVf8gp2UKQMlZxrwMoTTUC0zceJBdoCCa
 MUSA4b95EHB1hPYOZl9/PRNeNybYO07uzsSNycHjZgGDBTmiGynVVRBDaWmCFZ8yfbPV
 euV59PCXY6ZMHBp7/cH3cIGaU2CLR3Hyw49MDiACBB0Jj07nv/kVUUw0TBTovsC36fQp
 nAnJc+yQDjs+J35QKn8HOk5DAkhpdPGUEsObznykcPQJR8rwVnR6UVQPacSFIaXqWEX5 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueap8r2jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHFI3W3002015;
	Fri, 17 Nov 2023 15:19:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueap8r2j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFJMw6015911;
	Fri, 17 Nov 2023 15:19:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uanem6q3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHFJtPW45482314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 15:19:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 284FE20043;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC4BE2004F;
	Fri, 17 Nov 2023 15:19:54 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 15:19:54 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 1/7] lib: s390x: Add ap library
Date: Fri, 17 Nov 2023 15:19:33 +0000
Message-Id: <20231117151939.971079-2-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: xpRzy0KE5ZQOO-o-ztdt-dr1ToofaDXo
X-Proofpoint-ORIG-GUID: B1ZRAI6tDsYCWLbKxzUcQKK2aeWsrq37
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_14,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311170114

Add functions and definitions needed to test the Adjunct
Processor (AP) crypto interface.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/ap.h | 88 +++++++++++++++++++++++++++++++++++++++++++++++
 s390x/Makefile |  1 +
 3 files changed, 182 insertions(+)
 create mode 100644 lib/s390x/ap.c
 create mode 100644 lib/s390x/ap.h

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
new file mode 100644
index 00000000..17a32d66
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
+/* Will later be extended to a proper setup function */
+bool ap_setup(void)
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
index 00000000..cda1e564
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
+bool ap_setup(void);
+int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		 struct pqap_r2 *r2);
+int ap_pqap_qci(struct ap_config_info *info);
+#endif
diff --git a/s390x/Makefile b/s390x/Makefile
index f79fd009..2199eeba 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -110,6 +110,7 @@ cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
 cflatobjs += lib/s390x/fault.o
+cflatobjs += lib/s390x/ap.o
 
 OBJDIRS += lib/s390x
 
-- 
2.34.1


