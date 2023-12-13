Return-Path: <kvm+bounces-4325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B215C8111A3
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6957B1F2131A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B87B29435;
	Wed, 13 Dec 2023 12:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MulCm4ME"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871B7F7;
	Wed, 13 Dec 2023 04:49:54 -0800 (PST)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDCfKTv027272;
	Wed, 13 Dec 2023 12:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PoeWTyV0kZNdQX7BfxGA5W7kDFdwH1b/DaBzb7aRoRA=;
 b=MulCm4MEzvz9iN0T1fWOKt/pXB6aq6Pq7td3OUtUgfSaK9e7CC61Dj0NKV8m76Imh89i
 t606rAmWZhNHL7xZZ8+QwfFZUuARuwl/PqN5XuCXO1h16Jor8hqERGrAefmM6Hu66R9S
 YBTTN+pdzAlkCxdvPMoY7J4gNU1XWbXYGQbG59zTSsQ1XC79fCzKaRmAhX+3JdpwCzHV
 GP3aSMeJouF91EuDkxxH8qaaydelG8Bi69j5up+iiKO97fp6DouxS6S8jg3Q2vwwM6hQ
 YmKh0AMVqZbPSXew1qBxpj61YSyO34G60+KMH/RYcvQVdWEtQKPB8GkVPM6//b8x8Ypq Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybhn2agf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:48 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDCnmQO023442;
	Wed, 13 Dec 2023 12:49:48 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybhn2ag4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:48 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDBlD1t028244;
	Wed, 13 Dec 2023 12:49:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw2xyrw6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDCni2x42992342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 12:49:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DDE520040;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C9E220043;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/5] lib: Add pseudo random functions
Date: Wed, 13 Dec 2023 13:49:38 +0100
Message-Id: <20231213124942.604109-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231213124942.604109-1-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kfu0LXyPqkB3k34U33es9PnIeR6VlhrL
X-Proofpoint-GUID: O2TkKxU39Fy4vdBFiUE9jK84YD7BV17u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_05,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 mlxlogscore=906 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130093

Add functions for generating pseudo random 32 and 64 bit values.
The implementation is very simple and the randomness likely not
of high quality.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 Makefile       |  1 +
 lib/libcflat.h |  7 +++++++
 lib/rand.c     | 19 +++++++++++++++++++
 3 files changed, 27 insertions(+)
 create mode 100644 lib/rand.c

diff --git a/Makefile b/Makefile
index 602910dd..7997e035 100644
--- a/Makefile
+++ b/Makefile
@@ -28,6 +28,7 @@ cflatobjs := \
 	lib/printf.o \
 	lib/string.o \
 	lib/abort.o \
+	lib/rand.o \
 	lib/report.o \
 	lib/stack.o
 
diff --git a/lib/libcflat.h b/lib/libcflat.h
index 700f4352..ed947f98 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -83,6 +83,13 @@ extern void abort(void) __attribute__((noreturn));
 extern long atol(const char *ptr);
 extern char *getenv(const char *name);
 
+typedef struct {
+	uint32_t val;
+} rand_state;
+#define RAND_STATE_INIT(x) ((rand_state){ .val = (x) })
+uint32_t rand32(rand_state *state);
+uint64_t rand64(rand_state *state);
+
 extern int printf(const char *fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern int snprintf(char *buf, int size, const char *fmt, ...)
diff --git a/lib/rand.c b/lib/rand.c
new file mode 100644
index 00000000..658c4cbf
--- /dev/null
+++ b/lib/rand.c
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * pseudo random functions
+ *
+ * Copyright IBM Corp. 2023
+ */
+
+#include "libcflat.h"
+
+uint32_t rand32(rand_state *state)
+{
+	state->val = 0x915f77f5 * state->val + 1;
+	return state->val ^ (state->val >> 16);
+}
+
+uint64_t rand64(rand_state *state)
+{
+	return (uint64_t)rand32(state) << 32 | rand32(state);
+}
-- 
2.41.0


