Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9090463EC28
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 10:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiLAJRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 04:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLAJRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 04:17:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFFC4A584
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 01:17:49 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B18hk1Z023154
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 09:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uZFMsWS4UXmBb15fiB+SKADQFETP/AliynsMxzffjug=;
 b=Bd0Ravdyw+v4QaAY7OnSky8TpZKHfyYF0AWmlMqSR+MaLRWeBfWRPOQgAyMMXR+Fb1sT
 RJpmQM7Ooqpduy+TS5HHZFIZMtowzmneeOwqnGtYQG19tl1c2vlZFjH+59n7NO2sEcq/
 gnvdZvjd4FoSdykUR0LkbcBi8VkNkoSa4WVln2rAihPrR66Ivrhwu7HYrAA7hmL3qaVX
 zfzqNvYNJrYKD+6tb2TNDk/yAwoYU9LVpV8Lhs4qSgKYCMaWYSb0759TBxroDpxEg+q4
 hdf9oLwrz0iRjGAKCnXzfGe4wyeVJ0KsxiEzIco3T5W8FuNVXZJX1FZJupASDChm5HZU GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6s0nh5yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 09:17:48 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B18tK9v008093
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 09:17:48 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6s0nh5xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 09:17:48 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1969am027066;
        Thu, 1 Dec 2022 09:17:46 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3m3ae954kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 09:17:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B19Hgxr64225788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 09:17:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCB4AA4040;
        Thu,  1 Dec 2022 09:17:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91FC1A4057;
        Thu,  1 Dec 2022 09:17:42 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 09:17:42 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 2/2] s390x: add CMM test during migration
Date:   Thu,  1 Dec 2022 10:17:41 +0100
Message-Id: <20221201091741.3772856-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221201091741.3772856-1-nrb@linux.ibm.com>
References: <20221201091741.3772856-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D3lW1S4qE1a6CYtHMszVsJimNlaSZCQ4
X-Proofpoint-ORIG-GUID: dPJYTibuzvhLbM0ewlNB29Yp_lOc8eIw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010062
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
 s390x/migration-during-cmm.c | 123 +++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg          |   5 ++
 3 files changed, 129 insertions(+)
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
index 000000000000..7e1f9590ae50
--- /dev/null
+++ b/s390x/migration-during-cmm.c
@@ -0,0 +1,123 @@
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
+#include <cmm.h>
+#include <asm-generic/barrier.h>
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
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(test_cmm_during_migration));
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

