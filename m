Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB887561939
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiF3LbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiF3LbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:31:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BB251B29;
        Thu, 30 Jun 2022 04:31:07 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UBBv2B027286;
        Thu, 30 Jun 2022 11:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UzEvxgWBqw6ksQ5MpQmL5dA2oLRVIVB75s4SlyEP1e0=;
 b=KdoFq5j6SDnum74kNYTz4aI+hUKukqZZcdUsStNa2tF2So6ckF4lwtsH02of271OO62B
 W8z+f7V9GXWAh7NHqDUdiqj5Qq5l3JsDw5hek18aq/Sc9WDqT99G85jy/cF0k4GMRR28
 cPWAlDGsMUxqPyNgotdOWZhzdHBnZrSJ8YYezFXZyKh4kcvON1bCgdVGV1gChXN3BrIM
 FppjYhPPnBdhmhGrQzNZ2iE01F6RSgex102FLITzgfpl0mvDZIcPmu5iYBrdWXj0qcFk
 HxoY/dJa4Z1SIkJwCKHWYQ9SozkuO5rvbeSS/R8EZOL+jKpOq7jRqv4IS5hrhLlP5sY/ CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1ar68gjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:06 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UBLMHE005106;
        Thu, 30 Jun 2022 11:31:06 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1ar68gh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:06 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UBKU6H017342;
        Thu, 30 Jun 2022 11:31:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3gwt08x0cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:03 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UBV0YV17236476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 11:31:00 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 771B2A405F;
        Thu, 30 Jun 2022 11:31:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D24EA405C;
        Thu, 30 Jun 2022 11:31:00 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 11:31:00 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 3/3] s390x: add pgm spec interrupt loop test
Date:   Thu, 30 Jun 2022 13:30:59 +0200
Message-Id: <20220630113059.229221-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630113059.229221-1-nrb@linux.ibm.com>
References: <20220630113059.229221-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ptMOOHpqhw3AvAfYXAIm1GmA4Fvx2eNw
X-Proofpoint-ORIG-GUID: B7yiun4N6e9Ds9FdxOB4lwqk7FHk34-z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 mlxlogscore=739 priorityscore=1501
 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206300045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An invalid PSW causes a program interrupt. When an invalid PSW is
introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
program interrupt is caused.

QEMU should detect that and panick the guest, hence add a test for it.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile      |  1 +
 s390x/pgmint-loop.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  4 ++++
 3 files changed, 51 insertions(+)
 create mode 100644 s390x/pgmint-loop.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 92a020234c9f..a600dbfb3f4c 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -35,6 +35,7 @@ tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
 tests += $(TEST_DIR)/extint-loop.elf
+tests += $(TEST_DIR)/pgmint-loop.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/pgmint-loop.c b/s390x/pgmint-loop.c
new file mode 100644
index 000000000000..5b74f26dbc3d
--- /dev/null
+++ b/s390x/pgmint-loop.c
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Program interrupt loop test
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <bitops.h>
+#include <asm/interrupt.h>
+#include <asm/barrier.h>
+
+static void pgm_int_handler(void)
+{
+	/*
+	 * return to pgm_old_psw. This gives us the chance to print the return_fail
+	 * in case something goes wrong.
+	 */
+	asm volatile (
+		"lpswe %[pgm_old_psw]\n"
+		:
+		: [pgm_old_psw] "Q"(lowcore.pgm_old_psw)
+		: "memory"
+	);
+}
+
+int main(void)
+{
+	report_prefix_push("pgmint-loop");
+
+	lowcore.pgm_new_psw.addr = (uint64_t) pgm_int_handler;
+	/* bit 12 set is invalid */
+	lowcore.pgm_new_psw.mask = extract_psw_mask() | BIT(63 - 12);
+	mb();
+
+	/* cause a pgm int */
+	*((int *)-4) = 0x42;
+	mb();
+
+	report_fail("survived pgmint loop");
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 7d408f2d5310..c3073bfc4363 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -188,3 +188,7 @@ groups = migration
 [extint-loop]
 file = extint-loop.elf
 groups = panic
+
+[pgmint-loop]
+file = pgmint-loop.elf
+groups = panic
-- 
2.36.1

