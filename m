Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A91B63A963
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 14:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiK1NXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 08:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiK1NXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 08:23:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D084C120A3
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 05:23:31 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASBj6n0035025
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hmx9Ru3ElltCs+NY6zrSapHZpdn41jq0dM5NN8Vf9Ag=;
 b=sYfEzWjU+It7m3nSlRw+nWZmIpfIxKEsIh0lmTTOS2Q7We6010Hy8eAOJu8tgrsuEbgi
 4ux9QgBuaTG1QrnGVpJ8BnMQKC3X3mLKza3NnpZbl2bkWZtgn51Xgemc/h+q8/w1FLgB
 qRrtXzfa4K8BqHb/RebuXjNbPVi9l+8vgtPvvMRIH5GWO86Pm0YwiFhoXPf5hZYEzp11
 0uleka4ty0AsF9ziKiq557ck7a6qPd+Oo56w5GxFhvndsEKS8yAkfwAGc4Op8tV5LPhQ
 Klt1HZ7VRwEKV/VjknDCYlyxIu/q3Mo0PDQ6aHf0I+RceF0xsOMcNQsxCeewiY7GBNQZ 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vv9rc4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:31 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASBjr6D037224
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vv9rc3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 13:23:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASDMCIT020811;
        Mon, 28 Nov 2022 13:23:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3m3a2htk2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 13:23:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASDGx4x7537390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 13:16:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EE1F4C046;
        Mon, 28 Nov 2022 13:23:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFE4E4C044;
        Mon, 28 Nov 2022 13:23:24 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 13:23:24 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/2] s390x: add CMM test during migration
Date:   Mon, 28 Nov 2022 14:23:23 +0100
Message-Id: <20221128132323.1964532-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221128132323.1964532-1-nrb@linux.ibm.com>
References: <20221128132323.1964532-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ki1tcWEBF-1wnRbZmXDoZAD4Djdm_OYy
X-Proofpoint-GUID: 8p0cn3ZkFBknso_P4wYFvi9VTQXLPs96
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_11,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211280096
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile               |   1 +
 s390x/migration-during-cmm.c | 127 +++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg          |   5 ++
 3 files changed, 133 insertions(+)
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
index 000000000000..1a8dc89f7b32
--- /dev/null
+++ b/s390x/migration-during-cmm.c
@@ -0,0 +1,127 @@
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
+/*
+ * Allocate 3 pages more than we need so we can start at different offsets.
+ * This ensures page states change on every loop iteration.
+ */
+static uint8_t pagebuf[(NUM_PAGES + 3) * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static unsigned int thread_iters;
+static int thread_should_exit;
+static int thread_exited;
+struct cmm_verify_result result;
+
+static void test_cmm_during_migration(void)
+{
+	uint8_t *pagebuf_start;
+	/*
+	 * The second CPU must not print to the console, otherwise it will race with
+	 * the primary CPU on the SCLP buffer.
+	 */
+	while (!READ_ONCE(thread_should_exit)) {
+		/*
+		 * Start on a offset different from the last iteration so page states change with
+		 * every iteration. This is why pagebuf has 3 extra pages.
+		 */
+		pagebuf_start = pagebuf + (thread_iters % 4) * PAGE_SIZE;
+		cmm_set_page_states(pagebuf_start, NUM_PAGES);
+
+		/*
+		 * Always increment even if the verify fails. This ensures primary CPU knows where
+		 * we left off and can do an additional verify round after migration finished.
+		 */
+		thread_iters++;
+
+		result = cmm_verify_page_states(pagebuf_start, NUM_PAGES);
+		if (result.verify_failed)
+			break;
+	}
+
+	WRITE_ONCE(thread_exited, 1);
+}
+
+static void migrate_once(void)
+{
+	static bool migrated;
+
+	if (migrated)
+		return;
+
+	migrated = true;
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
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
+	migrate_once();
+
+	WRITE_ONCE(thread_should_exit, 1);
+
+	while (!thread_exited)
+		mb();
+
+	report_info("thread completed %u iterations", thread_iters);
+
+	report_prefix_push("during migration");
+	cmm_report_verify(&result);
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
+	assert(thread_iters > 0);
+	result = cmm_verify_page_states(pagebuf + ((thread_iters - 1) % 4) * PAGE_SIZE, NUM_PAGES);
+	cmm_report_verify(&result);
+	report_prefix_pop();
+
+error:
+	/*
+	 * If we just exit and don't ask migrate_cmd to migrate us, it
+	 * will just hang forever. Hence, also ask for migration when we
+	 * skip this test altogether.
+	 */
+	migrate_once();
+
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

