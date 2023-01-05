Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C32865EA83
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 13:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjAEMPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 07:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjAEMPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 07:15:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8378358FAA
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 04:15:47 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305Brf5T008300
        for <kvm@vger.kernel.org>; Thu, 5 Jan 2023 12:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=4p+iSthvHkZy9KpKb7IDTuk3GVBW9fJ3pLrOldwiWpA=;
 b=B91sHkkQ33QRsoeLAdifAM18+GtHyhzTUqf064nHrlA9/0b60pAiIYxS8W5hkfvc6f9R
 D7FNYaSSB2uaflWUIrLDuWrJXKd+0GJTboIRNHpIB/A43veC3TaW5FAxsZJdL7Q65+9x
 qmSAhsSwVCB+H2DreebXGSjX2fRwqmYLKhn9X+Ql2tV0BDjLyPJ37EKPjEww2Yi9qSdz
 runG99SPuGY96bumP8w1jAr+JL6LJnUiJXMNMYDogYMBkns8XnSEsZgUObnmIfAMU9sb
 nozeKmQEgb+24sQIqq6XUFyy/yieH59Ye2NtV4ALwadb0CtxTXFm8LgV43eixKI8MLvt rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwx2y8fas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 12:15:46 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305CCthU019548
        for <kvm@vger.kernel.org>; Thu, 5 Jan 2023 12:15:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwx2y8fa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:15:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30590ooZ005147;
        Thu, 5 Jan 2023 12:15:44 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mtcq6er0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:15:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305CFemI52494782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 12:15:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A216720040;
        Thu,  5 Jan 2023 12:15:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DAA420049;
        Thu,  5 Jan 2023 12:15:40 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.26.82])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 12:15:40 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 3/4] s390x: add parallel skey migration test
Date:   Thu,  5 Jan 2023 13:15:37 +0100
Message-Id: <20230105121538.52008-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105121538.52008-1-imbrenda@linux.ibm.com>
References: <20230105121538.52008-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: l_ymrT16_CbUKT1aqbiHuWrRuQF6b7wc
X-Proofpoint-GUID: wwxWbZ2T0aHwrZieIrq_O5-Cu8MxZoG1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Right now, we have a test which sets storage keys, then migrates the VM
and - after migration finished - verifies the skeys are still there.

Add a new version of the test which changes storage keys while the
migration is in progress. This is achieved by adding a command line
argument to the existing migration-skey test.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20221220083030.30153-2-nrb@linux.ibm.com
Message-Id: <20221220083030.30153-2-nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/migration-skey.c | 218 +++++++++++++++++++++++++++++++++++++----
 s390x/unittests.cfg    |  15 ++-
 2 files changed, 210 insertions(+), 23 deletions(-)

diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
index a91eb6b5..8d6d8ecf 100644
--- a/s390x/migration-skey.c
+++ b/s390x/migration-skey.c
@@ -2,6 +2,12 @@
 /*
  * Storage Key migration tests
  *
+ * There are two variants of this test:
+ * - sequential: set storage keys on some pages, migrates the VM and then
+ *   verifies that the storage keys are still as we expect.
+ * - parallel: start migration and set and check storage keys on some
+ *   pages while migration is in process.
+ *
  * Copyright IBM Corp. 2022
  *
  * Authors:
@@ -13,16 +19,45 @@
 #include <asm/facility.h>
 #include <asm/page.h>
 #include <asm/mem.h>
-#include <asm/interrupt.h>
+#include <asm/barrier.h>
 #include <hardware.h>
+#include <smp.h>
+
+struct verify_result {
+	bool verify_failed;
+	union skey expected_key;
+	union skey actual_key;
+	unsigned long page_mismatch_idx;
+	unsigned long page_mismatch_addr;
+};
 
 #define NUM_PAGES 128
-static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static struct verify_result result;
+
+static unsigned int thread_iters;
+static bool thread_should_exit;
+static bool thread_exited;
+
+static enum {
+	TEST_INVALID,
+	TEST_SEQUENTIAL,
+	TEST_PARALLEL
+} arg_test_to_run;
 
-static void test_migration(void)
+/*
+ * Set storage key test pattern on pagebuf with a seed for the storage keys.
+ *
+ * Each page's storage key is generated by taking the page's index in pagebuf,
+ * XOR-ing that with the given seed and then multipling the result with two.
+ *
+ * Only the lower seven bits of the seed are considered.
+ */
+static void set_test_pattern(unsigned char seed)
 {
-	union skey expected_key, actual_key;
-	int i, key_to_set, key_mismatches = 0;
+	unsigned char key_to_set;
+	unsigned long i;
 
 	for (i = 0; i < NUM_PAGES; i++) {
 		/*
@@ -32,15 +67,34 @@ static void test_migration(void)
 		 * protection as well as reference and change indication for
 		 * some keys.
 		 */
-		key_to_set = i * 2;
-		set_storage_key(pagebuf[i], key_to_set, 1);
+		key_to_set = (i ^ seed) * 2;
+		set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);
 	}
+}
 
-	migrate_once();
+/*
+ * Verify storage keys on pagebuf.
+ * Storage keys must have been set by set_test_pattern on pagebuf before.
+ * set_test_pattern must have been called with the same seed value.
+ *
+ * If storage keys match the expected result, will return a verify_result
+ * with verify_failed false. All other fields are then invalid.
+ * If there is a mismatch, returned struct will have verify_failed true and will
+ * be filled with the details on the first mismatch encountered.
+ */
+static struct verify_result verify_test_pattern(unsigned char seed)
+{
+	union skey expected_key, actual_key;
+	struct verify_result result = {
+		.verify_failed = true
+	};
+	uint8_t *cur_page;
+	unsigned long i;
 
 	for (i = 0; i < NUM_PAGES; i++) {
-		actual_key.val = get_storage_key(pagebuf[i]);
-		expected_key.val = i * 2;
+		cur_page = pagebuf + i * PAGE_SIZE;
+		actual_key.val = get_storage_key(cur_page);
+		expected_key.val = (i ^ seed) * 2;
 
 		/*
 		 * The PoP neither gives a guarantee that the reference bit is
@@ -51,27 +105,153 @@ static void test_migration(void)
 		actual_key.str.rf = 0;
 		expected_key.str.rf = 0;
 
-		/* don't log anything when key matches to avoid spamming the log */
 		if (actual_key.val != expected_key.val) {
-			key_mismatches++;
-			report_fail("page %d expected_key=0x%x actual_key=0x%x", i, expected_key.val, actual_key.val);
+			result.expected_key.val = expected_key.val;
+			result.actual_key.val = actual_key.val;
+			result.page_mismatch_idx = i;
+			result.page_mismatch_addr = (unsigned long)cur_page;
+			return result;
 		}
 	}
 
-	report(!key_mismatches, "skeys after migration match");
+	result.verify_failed = false;
+	return result;
+}
+
+static void report_verify_result(const struct verify_result * result)
+{
+	if (result->verify_failed)
+		report_fail("page skey mismatch: first page idx = %lu, addr = 0x%lx, "
+			    "expected_key = 0x%02x, actual_key = 0x%02x",
+			    result->page_mismatch_idx, result->page_mismatch_addr,
+			    result->expected_key.val, result->actual_key.val);
+	else
+		report_pass("skeys match");
+}
+
+static void test_skey_migration_sequential(void)
+{
+	report_prefix_push("sequential");
+
+	set_test_pattern(0);
+
+	migrate_once();
+
+	result = verify_test_pattern(0);
+	report_verify_result(&result);
+
+	report_prefix_pop();
+}
+
+static void set_skeys_thread(void)
+{
+	while (!READ_ONCE(thread_should_exit)) {
+		set_test_pattern(thread_iters);
+
+		result = verify_test_pattern(thread_iters);
+
+		/*
+		 * Always increment even if the verify fails. This ensures primary CPU knows where
+		 * we left off and can do an additional verify round after migration finished.
+		 */
+		thread_iters++;
+
+		if (result.verify_failed)
+			break;
+	}
+
+	WRITE_ONCE(thread_exited, 1);
+}
+
+static void test_skey_migration_parallel(void)
+{
+	report_prefix_push("parallel");
+
+	if (smp_query_num_cpus() == 1) {
+		report_skip("need at least 2 cpus for this test");
+		goto error;
+	}
+
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(set_skeys_thread));
+
+	migrate_once();
+
+	WRITE_ONCE(thread_should_exit, 1);
+
+	while (!READ_ONCE(thread_exited))
+		;
+
+	/* Ensure we read result and thread_iters below from memory after thread exited */
+	mb();
+	report_info("thread completed %u iterations", thread_iters);
+
+	report_prefix_push("during migration");
+	report_verify_result(&result);
+	report_prefix_pop();
+
+	/*
+	 * Verification of skeys occurs on the thread. We don't know if we
+	 * were still migrating during the verification.
+	 * To be sure, make another verification round after the migration
+	 * finished to catch skeys which might not have been migrated
+	 * correctly.
+	 */
+	report_prefix_push("after migration");
+	assert(thread_iters > 0);
+	result = verify_test_pattern(thread_iters - 1);
+	report_verify_result(&result);
+	report_prefix_pop();
+
+error:
+	report_prefix_pop();
+}
+
+static void print_usage(void)
+{
+	report_info("Usage: migration-skey [--parallel|--sequential]");
+}
+
+static void parse_args(int argc, char **argv)
+{
+	if (argc < 2) {
+		/* default to sequential since it only needs one cpu */
+		arg_test_to_run = TEST_SEQUENTIAL;
+		return;
+	}
+
+	if (!strcmp("--parallel", argv[1]))
+		arg_test_to_run = TEST_PARALLEL;
+	else if (!strcmp("--sequential", argv[1]))
+		arg_test_to_run = TEST_SEQUENTIAL;
+	else
+		arg_test_to_run = TEST_INVALID;
 }
 
-int main(void)
+int main(int argc, char **argv)
 {
 	report_prefix_push("migration-skey");
 
-	if (test_facility(169))
+	if (test_facility(169)) {
 		report_skip("storage key removal facility is active");
-	else
-		test_migration();
+		goto error;
+	}
 
-	migrate_once();
+	parse_args(argc, argv);
+
+	switch (arg_test_to_run) {
+	case TEST_SEQUENTIAL:
+		test_skey_migration_sequential();
+		break;
+	case TEST_PARALLEL:
+		test_skey_migration_parallel();
+		break;
+	default:
+		print_usage();
+		break;
+	}
 
+error:
+	migrate_once();
 	report_prefix_pop();
 	return report_summary();
 }
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3caf81ed..d97eb5e9 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -185,10 +185,6 @@ smp = 2
 file = migration-cmm.elf
 groups = migration
 
-[migration-skey]
-file = migration-skey.elf
-groups = migration
-
 [panic-loop-extint]
 file = panic-loop-extint.elf
 groups = panic
@@ -208,3 +204,14 @@ groups = migration
 [exittime]
 file = exittime.elf
 smp = 2
+
+[migration-skey-sequential]
+file = migration-skey.elf
+groups = migration
+extra_params = -append '--sequential'
+
+[migration-skey-parallel]
+file = migration-skey.elf
+smp = 2
+groups = migration
+extra_params = -append '--parallel'
-- 
2.39.0

