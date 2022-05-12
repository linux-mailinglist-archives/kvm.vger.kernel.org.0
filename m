Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0121052490F
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352077AbiELJfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352023AbiELJfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649CF69B76
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:35 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9Psj9010031
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MgPjSiU4NR1DHDB7eQFp+haFZTPfZLuFDntuV/lZB+4=;
 b=Bvu8ZNsZm1N2qshsiIMACb+prtWtKLY7U7tW/wFtjiLUn0Mp5gydIyuAcTgIuvsQTzrp
 ufnOtx0aUSHHOMcPhs3a1+C3Cw+BF8v1url0MHvT3s9vXXK82K/EYzbDRIjxQSp/PySF
 Xl1uu4blbWULfryouqWuUMcpi9QiLjbYr5UwQ3pr80qAcAEnh/KTqvw3Gby73uryxu5B
 oMQGcWSdsFwjfWtDMoSSuJdcpurJssnXvA/IWSeD5Kjd1d1wUX3o4fnVax4tlRdnvSYM
 Ex9qEqF6D8k/2VhBCCeQTLYvWH2pw21xwvheUY7zhthL3hkppo9X27MAoiVxFA1VnUCi kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0ykpr5n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:34 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9RSQX013270
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:34 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0ykpr5kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:34 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XLW2009710;
        Thu, 12 May 2022 09:35:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3fwg1hw8yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9LoJX53936506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:21:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1BFB11C052;
        Thu, 12 May 2022 09:35:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B74511C050;
        Thu, 12 May 2022 09:35:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 01/28] s390x: gs: move to new header file
Date:   Thu, 12 May 2022 11:34:56 +0200
Message-Id: <20220512093523.36132-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GcFAwM_QnnP2LXVxuSw2OQY406MgZMwX
X-Proofpoint-ORIG-GUID: tFpM9KQSjbGG8Q5W2LQMxDd4xIa20O5p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=761 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Move the guarded-storage related structs and instructions to a new
header file because we will also need them for the SIGP store additional
status tests.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/gs.h | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/gs.c     | 54 +--------------------------------------
 2 files changed, 70 insertions(+), 53 deletions(-)
 create mode 100644 lib/s390x/gs.h

diff --git a/lib/s390x/gs.h b/lib/s390x/gs.h
new file mode 100644
index 00000000..9c94e580
--- /dev/null
+++ b/lib/s390x/gs.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Guarded storage related definitions
+ *
+ * Copyright 2018 IBM Corp.
+ *
+ * Authors:
+ *    Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <stdint.h>
+
+#ifndef _S390X_GS_H_
+#define _S390X_GS_H_
+
+struct gs_cb {
+	uint64_t reserved;
+	uint64_t gsd;
+	uint64_t gssm;
+	uint64_t gs_epl_a;
+};
+
+struct gs_epl {
+	uint8_t pad1;
+	union {
+		uint8_t gs_eam;
+		struct {
+			uint8_t		: 6;
+			uint8_t e	: 1;
+			uint8_t b	: 1;
+		};
+	};
+	union {
+		uint8_t gs_eci;
+		struct {
+			uint8_t tx	: 1;
+			uint8_t cx	: 1;
+			uint8_t		: 5;
+			uint8_t in	: 1;
+		};
+	};
+	union {
+		uint8_t gs_eai;
+		struct {
+			uint8_t		: 1;
+			uint8_t t	: 1;
+			uint8_t as	: 2;
+			uint8_t ar	: 4;
+		};
+	};
+	uint32_t pad2;
+	uint64_t gs_eha;
+	uint64_t gs_eia;
+	uint64_t gs_eoa;
+	uint64_t gs_eir;
+	uint64_t gs_era;
+};
+
+static inline void load_gs_cb(struct gs_cb *gs_cb)
+{
+	asm volatile(".insn rxy,0xe3000000004d,0,%0" : : "Q" (*gs_cb));
+}
+
+static inline void store_gs_cb(struct gs_cb *gs_cb)
+{
+	asm volatile(".insn rxy,0xe30000000049,0,%0" : : "Q" (*gs_cb));
+}
+
+#endif
diff --git a/s390x/gs.c b/s390x/gs.c
index 7567bb78..4993eb8f 100644
--- a/s390x/gs.c
+++ b/s390x/gs.c
@@ -13,49 +13,7 @@
 #include <asm/facility.h>
 #include <asm/interrupt.h>
 #include <asm-generic/barrier.h>
-
-struct gs_cb {
-	uint64_t reserved;
-	uint64_t gsd;
-	uint64_t gssm;
-	uint64_t gs_epl_a;
-};
-
-struct gs_epl {
-	uint8_t pad1;
-	union {
-		uint8_t gs_eam;
-		struct {
-			uint8_t		: 6;
-			uint8_t e	: 1;
-			uint8_t b	: 1;
-		};
-	};
-	union {
-		uint8_t gs_eci;
-		struct {
-			uint8_t tx	: 1;
-			uint8_t cx	: 1;
-			uint8_t		: 5;
-			uint8_t in	: 1;
-		};
-	};
-	union {
-		uint8_t gs_eai;
-		struct {
-			uint8_t		: 1;
-			uint8_t t	: 1;
-			uint8_t as	: 2;
-			uint8_t ar	: 4;
-		};
-	};
-	uint32_t pad2;
-	uint64_t gs_eha;
-	uint64_t gs_eia;
-	uint64_t gs_eoa;
-	uint64_t gs_eir;
-	uint64_t gs_era;
-};
+#include <gs.h>
 
 static volatile int guarded = 0;
 static struct gs_cb gs_cb;
@@ -64,16 +22,6 @@ static unsigned long gs_area = 0x2000000;
 
 void gs_handler(struct gs_cb *this_cb);
 
-static inline void load_gs_cb(struct gs_cb *gs_cb)
-{
-	asm volatile(".insn rxy,0xe3000000004d,0,%0" : : "Q" (*gs_cb));
-}
-
-static inline void store_gs_cb(struct gs_cb *gs_cb)
-{
-	asm volatile(".insn rxy,0xe30000000049,0,%0" : : "Q" (*gs_cb));
-}
-
 static inline unsigned long load_guarded(unsigned long *p)
 {
 	unsigned long v;
-- 
2.36.1

