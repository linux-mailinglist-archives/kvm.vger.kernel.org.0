Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4739863412D
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbiKVQP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbiKVQOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA396EB7C
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:53 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMG1DTN030333
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IAG8gCjGyVDBkZYJCCeyZuZ53p57vfPUFeEiq0fIR68=;
 b=TRUFRvMqXSB2/RKQukwErTQuY+jWCisqBaZ3+vmXAfzIorcLHmJr/u6L4MMB8Dosxdrl
 TZsAwkPnyCZtoAi1hAvCYZCD6cjpFcxbO66KF7a3QgAdEiBXsAoOaq0PxDXOK5ZKJDtl
 3kw0Vk5Ysqg3aDGVqB4rgqpCtftyR51FLR2UKe7Xr/3xoQXpT4EXzVbFd/JWjDOp1AZ6
 DgMOp8W1xuWF8x9Oqw1mjMzWHHrBbjCXbgUxz3M8Yiz495CsIo/9i/HJueKnvOhEx4+2
 dBGG9qyjmedmy1E+u2RiPD3D0cnHrX9rKoLJRsyOWbKVTppOn1Y/Q/aDKQkagVz6wg8H Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0yk6m2mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:12:52 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AMFUWF3000592
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:12:52 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0yk6m2k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 16:12:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AMG7a4v018846;
        Tue, 22 Nov 2022 16:12:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdhvgmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 16:12:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AMGCjiR63177030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 16:12:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED52A4C040;
        Tue, 22 Nov 2022 16:12:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8D0D4C046;
        Tue, 22 Nov 2022 16:12:44 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Nov 2022 16:12:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/2] s390x: add CMM test during migration
Date:   Tue, 22 Nov 2022 17:12:43 +0100
Message-Id: <20221122161243.214814-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221122161243.214814-1-nrb@linux.ibm.com>
References: <20221122161243.214814-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y60KZHK8cENzw--Py1BeUC7-0oPdmiGt
X-Proofpoint-ORIG-GUID: WvMDJk9YhNhSL3kGNkhGswx8mNZBR9B3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_09,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test which modifies CMM page states while migration is in
progress.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile               |   1 +
 s390x/migration-during-cmm.c | 111 +++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg          |   5 ++
 3 files changed, 117 insertions(+)
 create mode 100644 s390x/migration-during-cmm.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 401cb6371cee..64c7c04409ae 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
 tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
+tests += $(TEST_DIR)/migration-during-cmm.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-during-cmm.c b/s390x/migration-during-cmm.c
new file mode 100644
index 000000000000..3c96283d7b00
--- /dev/null
+++ b/s390x/migration-during-cmm.c
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Perform CMMA actions while migrating.
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <smp.h>
+#include <asm-generic/barrier.h>
+
+#include "cmm.h"
+
+#define NUM_PAGES 128
+
+static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static int thread_iters;
+static int thread_should_exit;
+static int thread_exited;
+static bool verification_failure_occured;
+struct cmm_verify_result result;
+
+static void test_cmm_during_migration(void)
+{
+	/*
+	 * The second CPU must not print on the console, otherwise it will race with
+	 * the primary CPU on the SCLP buffer.
+	 */
+	while (!thread_should_exit) {
+		cmm_set_page_states(pagebuf, NUM_PAGES);
+		if (!cmm_verify_page_states(pagebuf, NUM_PAGES, &result)) {
+			verification_failure_occured = true;
+			goto out;
+		}
+		thread_iters++;
+	}
+
+out:
+	thread_exited = 1;
+}
+
+int main(void)
+{
+	bool has_essa = check_essa_available();
+	struct psw psw;
+
+	report_prefix_push("migration-during-cmm");
+	if (!has_essa) {
+		report_skip("ESSA is not available");
+		goto error;
+	}
+
+	if (smp_query_num_cpus() == 1) {
+		report_skip("need at least 2 cpus for this test");
+		goto error;
+	}
+
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)test_cmm_during_migration;
+	smp_cpu_setup(1, psw);
+
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+	thread_should_exit = 1;
+
+	while (!thread_exited)
+		mb();
+
+	report_info("thread completed %d iterations", thread_iters);
+
+	report_prefix_push("during migration");
+	if (verification_failure_occured)
+		cmm_report_verify_fail(&result);
+	else
+		report_pass("page states matched");
+	report_prefix_pop();
+
+	/*
+	 * Verification of page states occurs on the thread. We don't know if we
+	 * were still migrating during the verification.
+	 * To be sure, make another verification round after the migration
+	 * finished to catch page states which might not have been migrated
+	 * correctly.
+	 */
+	report_prefix_push("after migration");
+	if (!cmm_verify_page_states(pagebuf, NUM_PAGES, &result))
+		cmm_report_verify_fail(&result);
+	else
+		report_pass("page states matched");
+	report_prefix_pop();
+
+	goto done;
+
+error:
+	/*
+	 * If we just exit and don't ask migrate_cmd to migrate us, it
+	 * will just hang forever. Hence, also ask for migration when we
+	 * skip this test alltogether.
+	 */
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3caf81eda396..f6889bd4da01 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -208,3 +208,8 @@ groups = migration
 [exittime]
 file = exittime.elf
 smp = 2
+
+[migration-during-cmm]
+file = migration-during-cmm.elf
+groups = migration
+smp = 2
-- 
2.36.1

