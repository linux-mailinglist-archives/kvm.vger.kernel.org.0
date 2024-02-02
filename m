Return-Path: <kvm+bounces-7854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 745D7847288
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEE271F2C226
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A9A145B20;
	Fri,  2 Feb 2024 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RUZ+xsU4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43430144627;
	Fri,  2 Feb 2024 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706886302; cv=none; b=DSLYPr+7oNaRVqVAHH4fRe7DUJKozVuwtrEgNAkh8ZpCnm8mLGud7rv7shHa5zr0ozr4iGsZZRfoL5Y/XCVS/bYZr0R51L5EAYyh5CLhiDTy+Fw6gA8rWnAiDUzNQl5CiBCzjrhdmjSYgAToNok/zzKBKHBOtNHyaaz/bBid4Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706886302; c=relaxed/simple;
	bh=x7JE9DASJYozsZKxALLVlIDwl6DgDE+PDvIhIOu9x3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UYiBQgbzCCM6raLJPAERMfrwqeNegscSj1VmHcVTwm9s+k1B9YNAMt0JEQwE7zrBE/3NGc7DMTjmuJHHhygwqAvCK4xPXkYmJtgoakPxW7N0wLhzi6dSjToSD8Ca0fx1lzETNfbqKl6O/V3hkRp/QLNwCk/I2kEPfffzKwgHe3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RUZ+xsU4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 412ESufO031624;
	Fri, 2 Feb 2024 15:04:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=voz/5rT1CNnOTFJsV+PGqPQfIRYtzHgSr+ZPUW6xx5Y=;
 b=RUZ+xsU4APaREmKpdZLTPq9zSiwc1y0DG/QA+a1mEDWPQjbv+odu//TKWrSIUcPz0aSg
 +/cvX1QBkgGYqUi4I8CMI6tW2UNkfjqT8dj0ZYDzCZiY+LBt4qUZwIPYxDF1OfzZGle5
 GIMH3Gkz6peo6VtmSwDSaQLMZn1BKNlG/cbfLRTkn9Qw8sbZOn91Ge9DaiHN4Q4CLraw
 EzgJMmgyBVifcJFJzyA3jQrG0vmznAfWhRTunL1ZgIgkr98jXvv2KX0vUskPUHquX6MO
 SkDH9y/QN1dv5lzDKNd/HY2S+sFxNqIzqet+QlS6efSAf4VnKIrFG0RpORbXwuBaAggh Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w126h8v3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:58 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 412ESrFX031537;
	Fri, 2 Feb 2024 15:04:58 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w126h8v3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:58 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 412DAB5L008086;
	Fri, 2 Feb 2024 15:04:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwdnmku0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:57 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 412F4sjB18678274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Feb 2024 15:04:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67D9C20040;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 351BE20049;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 1/7] lib: s390x: Add ap library
Date: Fri,  2 Feb 2024 14:59:07 +0000
Message-Id: <20240202145913.34831-2-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: qvep5Pll98jG3w3Qk2uTF2jS22xxPgpK
X-Proofpoint-ORIG-GUID: Imb2og9KbL4iHRFKOTcAJZuL_d6E_hH8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-02_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402020109

Add functions and definitions needed to test the Adjunct
Processor (AP) crypto interface.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/ap.h | 88 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/Makefile |  1 +
 3 files changed, 186 insertions(+)
 create mode 100644 lib/s390x/ap.c
 create mode 100644 lib/s390x/ap.h

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
new file mode 100644
index 00000000..9560ff64
--- /dev/null
+++ b/lib/s390x/ap.c
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AP crypto functions
+ *
+ * Some parts taken from the Linux AP driver.
+ *
+ * Copyright IBM Corp. 2024
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
+	uint64_t bogus_cc = 2;
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
+		"       tmll	%[bogus_cc],3\n"
+		"	lgr	0,%[r0]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	stg	1,%[apqsw]\n"
+		"	stg	2,%[r2]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [apqsw] "=&T" (*apqsw), [r2] "=&T" (*r2), [cc] "=&d" (cc)
+		: [r0] "d" (r0), [bogus_cc] "d" (bogus_cc));
+
+	return cc;
+}
+
+int ap_pqap_qci(struct ap_config_info *info)
+{
+	struct pqap_r0 r0 = { .fc = PQAP_QUERY_AP_CONF_INFO };
+	uint64_t bogus_cc = 2;
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
+		"       tmll	%[bogus_cc],3\n"
+		"	lgr	0,%[r0]\n"
+		"	lgr	2,%[info]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=&d" (cc)
+		: [r0] "d" (r0), [info] "d" (info), [bogus_cc] "d" (bogus_cc)
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
index 00000000..b806513f
--- /dev/null
+++ b/lib/s390x/ap.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AP definitions
+ *
+ * Some parts taken from the Linux AP driver.
+ *
+ * Copyright IBM Corp. 2024
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
index 7fce9f9d..4f6c627d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -110,6 +110,7 @@ cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
 cflatobjs += lib/s390x/fault.o
+cflatobjs += lib/s390x/ap.o
 
 OBJDIRS += lib/s390x
 
-- 
2.40.1


