Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E1C651D14
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiLTJTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbiLTJTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:19:32 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E3B17E0C
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 01:19:30 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK9EXtX003576
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:19:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oZKVr2CbwFIaSyG3uWNsVK8FfI9Y5fDVDLaKlh78nwQ=;
 b=LoqCbp8/E90GyyzBq9RKriNBBExnqiIKCf0GzIhClJbm7BQs+oSkIz8RLWpoYJUI/Q3r
 99Ej1TT4dB7yl2iP6xyqOF/ek1VGDJTR4uDnIXNE0mi+CpCtpjw0Fsm54wTB3Vw+wtga
 W1CShVsCQxzxc3ame/VOIN3Ge/pey3IkAVdPWXe1rHL9DLDRNqNf3y512SSxwDlk30mV
 HcdTt20wuWMLMtbT8sucZHhhcS8i2gAJa8knD7LyP6TbnOsP2a9vuJaoms3HaiQGzNWq
 CVZSNGyse1woNik3+YrD7ccSdagCNvhIyqo9ZLRPMkibKQRP60yBSlMBUqr8i644wkeA pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mka8984qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:19:29 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BK9FVS4006847
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:19:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mka8984q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 09:19:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK60I11013948;
        Tue, 20 Dec 2022 09:19:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw3rje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 09:19:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BK9JOsU30146890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 09:19:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0903D20043;
        Tue, 20 Dec 2022 09:19:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0AAD20049;
        Tue, 20 Dec 2022 09:19:23 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 09:19:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 1/1] s390x: add CMM test during migration
Date:   Tue, 20 Dec 2022 10:19:23 +0100
Message-Id: <20221220091923.69174-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221220091923.69174-1-nrb@linux.ibm.com>
References: <20221220091923.69174-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EjmcNoNoeyNo2dTJh-4FqkVspU1xNoNs
X-Proofpoint-GUID: VJgQlpSV64rBtAvhKJgEvkigT71Naac6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212200069
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

This is added to the existing migration-cmm test, which gets a new
command line argument for the sequential and parallel variants.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/migration-cmm.c | 258 +++++++++++++++++++++++++++++++++++++-----
 s390x/unittests.cfg   |  15 ++-
 2 files changed, 240 insertions(+), 33 deletions(-)

diff --git a/s390x/migration-cmm.c b/s390x/migration-cmm.c
index 43673f18e45a..8855069f05f9 100644
--- a/s390x/migration-cmm.c
+++ b/s390x/migration-cmm.c
@@ -2,6 +2,12 @@
 /*
  * CMM migration tests (ESSA)
  *
+ * There are two variants of this test:
+ * - sequential: sets the CMM page states, then migrates the VM and - after
+ *   migration finished - verifies the page states have been preserved.
+ * - parallel: migrate the VM and - while migration is in progress - change the
+ *   page states and verify they are preserved.
+ *
  * Copyright IBM Corp. 2022
  *
  * Authors:
@@ -13,55 +19,249 @@
 #include <asm/interrupt.h>
 #include <asm/page.h>
 #include <asm/cmm.h>
+#include <asm/barrier.h>
 #include <bitops.h>
+#include <smp.h>
+
+struct verify_result {
+	bool verify_failed;
+	char expected_mask;
+	char actual_mask;
+	unsigned long page_mismatch_idx;
+	unsigned long page_mismatch_addr;
+};
+
+static enum {
+	TEST_INVLALID,
+	TEST_SEQUENTIAL,
+	TEST_PARALLEL
+} arg_test_to_run;
 
 #define NUM_PAGES 128
-static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
-static void test_migration(void)
+/*
+ * Allocate 3 pages more than we need so we can start at different offsets.
+ * For the parallel test, this ensures page states change on every loop iteration.
+ */
+static uint8_t pagebuf[(NUM_PAGES + 3) * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static struct verify_result result;
+
+static unsigned int thread_iters;
+static int thread_should_exit;
+static int thread_exited;
+
+/*
+ * Maps ESSA actions to states the page is allowed to be in after the
+ * respective action was executed.
+ */
+static const unsigned long allowed_essa_state_masks[4] = {
+	BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
+	BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
+	BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
+	BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
+};
+
+/*
+ * Set CMM page state test pattern on pagebuf.
+ * pagebuf must point to page_count consecutive pages.
+ * page_count must be a multiple of 4.
+ */
+static void set_test_pattern(uint8_t *pagebuf, size_t page_count)
+{
+	unsigned long addr = (unsigned long)pagebuf;
+	size_t i;
+
+	assert(page_count % 4 == 0);
+	for (i = 0; i < page_count; i += 4) {
+		essa(ESSA_SET_STABLE, addr + i * PAGE_SIZE);
+		essa(ESSA_SET_UNUSED, addr + (i + 1) * PAGE_SIZE);
+		essa(ESSA_SET_VOLATILE, addr + (i + 2) * PAGE_SIZE);
+		essa(ESSA_SET_POT_VOLATILE, addr + (i + 3) * PAGE_SIZE);
+	}
+}
+
+/*
+ * Verify CMM page states on pagebuf.
+ * Page states must have been set by set_test_pattern on pagebuf before.
+ * page_count must be a multiple of 4.
+ *
+ * If page states match the expected result, will return a verify_result
+ * with verify_failed false. All other fields are then invalid.
+ * If there is a mismatch, the returned struct will have verify_failed true
+ * and will be filled with details on the first mismatch encountered.
+ */
+static struct verify_result verify_page_states(uint8_t *pagebuf, size_t page_count)
+{
+	unsigned long expected_mask, actual_mask;
+	struct verify_result result = {
+		.verify_failed = true
+	};
+	unsigned long addr;
+	size_t i;
+
+	assert(page_count % 4 == 0);
+	for (i = 0; i < page_count; i++) {
+		addr = (unsigned long)(pagebuf + i * PAGE_SIZE);
+		actual_mask = essa(ESSA_GET_STATE, addr);
+		/* usage state in bits 60 and 61 */
+		actual_mask = BIT((actual_mask >> 2) & 0x3);
+		expected_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
+		if (!(actual_mask & expected_mask)) {
+			result.page_mismatch_idx = i;
+			result.page_mismatch_addr = addr;
+			result.expected_mask = expected_mask;
+			result.actual_mask = actual_mask;
+			return result;
+		}
+	}
+
+	result.verify_failed = false;
+	return result;
+}
+
+static void report_verify_result(const struct verify_result *result)
+{
+	if (result->verify_failed)
+		report_fail("page state mismatch: first page idx = %lu, addr = %lx, "
+			"expected_mask = 0x%x, actual_mask = 0x%x",
+			result->page_mismatch_idx, result->page_mismatch_addr,
+			result->expected_mask, result->actual_mask);
+	else
+		report_pass("page states match");
+}
+
+static void test_cmm_migration_sequential(void)
+{
+	report_prefix_push("sequential");
+
+	set_test_pattern(pagebuf, NUM_PAGES);
+
+	migrate_once();
+
+	result = verify_page_states(pagebuf, NUM_PAGES);
+	report_verify_result(&result);
+
+	report_prefix_pop();
+}
+
+static void set_cmm_thread(void)
 {
-	int i, state_mask, actual_state;
+	uint8_t *pagebuf_start;
 	/*
-	 * Maps ESSA actions to states the page is allowed to be in after the
-	 * respective action was executed.
+	 * The second CPU must not print to the console, otherwise it will race with
+	 * the primary CPU on the SCLP buffer.
 	 */
-	int allowed_essa_state_masks[4] = {
-		BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
-		BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
-		BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
-		BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
-	};
+	while (!READ_ONCE(thread_should_exit)) {
+		/*
+		 * Start on a offset different from the last iteration so page states change with
+		 * every iteration. This is why pagebuf has 3 extra pages.
+		 */
+		pagebuf_start = pagebuf + (thread_iters % 4) * PAGE_SIZE;
+		set_test_pattern(pagebuf_start, NUM_PAGES);
+
+		/*
+		 * Always increment even if the verify fails. This ensures primary CPU knows where
+		 * we left off and can do an additional verify round after migration finished.
+		 */
+		thread_iters++;
 
-	assert(NUM_PAGES % 4 == 0);
-	for (i = 0; i < NUM_PAGES; i += 4) {
-		essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
-		essa(ESSA_SET_UNUSED, (unsigned long)pagebuf[i + 1]);
-		essa(ESSA_SET_VOLATILE, (unsigned long)pagebuf[i + 2]);
-		essa(ESSA_SET_POT_VOLATILE, (unsigned long)pagebuf[i + 3]);
+		result = verify_page_states(pagebuf_start, NUM_PAGES);
+		if (result.verify_failed)
+			break;
 	}
 
+	WRITE_ONCE(thread_exited, 1);
+}
+
+static void test_cmm_migration_parallel(void)
+{
+	report_prefix_push("parallel");
+
+	if (smp_query_num_cpus() == 1) {
+		report_skip("need at least 2 cpus for this test");
+		goto error;
+	}
+
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(set_cmm_thread));
+
 	migrate_once();
 
-	for (i = 0; i < NUM_PAGES; i++) {
-		actual_state = essa(ESSA_GET_STATE, (unsigned long)pagebuf[i]);
-		/* extract the usage state in bits 60 and 61 */
-		actual_state = (actual_state >> 2) & 0x3;
-		state_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
-		report(BIT(actual_state) & state_mask, "page %d state: expected_mask=0x%x actual_mask=0x%lx", i, state_mask, BIT(actual_state));
+	WRITE_ONCE(thread_should_exit, 1);
+
+	while (!READ_ONCE(thread_exited))
+		;
+
+	/* Ensure thread_iters and result below are read from memory after thread completed */
+	mb();
+
+	report_info("thread completed %u iterations", thread_iters);
+
+	report_prefix_push("during migration");
+	report_verify_result(&result);
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
+	result = verify_page_states(pagebuf + ((thread_iters - 1) % 4) * PAGE_SIZE, NUM_PAGES);
+	report_verify_result(&result);
+	report_prefix_pop();
+
+error:
+	report_prefix_pop();
+}
+
+static void print_usage(void)
+{
+	report_info("Usage: migration-cmm [--parallel|--sequential]");
+}
+
+static void parse_args(int argc, char **argv)
+{
+	if (argc < 2) {
+		/* default to sequential since it only needs one CPU */
+		arg_test_to_run = TEST_SEQUENTIAL;
+		return;
 	}
+
+	if (!strcmp("--parallel", argv[1]))
+		arg_test_to_run = TEST_PARALLEL;
+	else if (!strcmp("--sequential", argv[1]))
+		arg_test_to_run = TEST_SEQUENTIAL;
+	else
+		arg_test_to_run = TEST_INVLALID;
 }
 
-int main(void)
+int main(int argc, char **argv)
 {
 	report_prefix_push("migration-cmm");
-
-	if (!check_essa_available())
+	if (!check_essa_available()) {
 		report_skip("ESSA is not available");
-	else
-		test_migration();
+		goto error;
+	}
 
-	migrate_once();
+	parse_args(argc, argv);
+
+	switch (arg_test_to_run) {
+	case TEST_SEQUENTIAL:
+		test_cmm_migration_sequential();
+	break;
+	case TEST_PARALLEL:
+		test_cmm_migration_parallel();
+	break;
+	default:
+		print_usage();
+	}
 
+error:
+	migrate_once();
 	report_prefix_pop();
 	return report_summary();
 }
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3caf81eda396..a16c9682e638 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -181,10 +181,6 @@ file = migration.elf
 groups = migration
 smp = 2
 
-[migration-cmm]
-file = migration-cmm.elf
-groups = migration
-
 [migration-skey]
 file = migration-skey.elf
 groups = migration
@@ -208,3 +204,14 @@ groups = migration
 [exittime]
 file = exittime.elf
 smp = 2
+
+[migration-cmm-sequential]
+file = migration-cmm.elf
+groups = migration
+extra_params = -append '--sequential'
+
+[migration-cmm-parallel]
+file = migration-during-cmm.elf
+groups = migration
+smp = 2
+extra_params = -append '--parallel'
-- 
2.36.1

