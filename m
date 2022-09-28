Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4295EE683
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 22:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbiI1URZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 16:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiI1URV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 16:17:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681716C115;
        Wed, 28 Sep 2022 13:17:20 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SJSBPv028362;
        Wed, 28 Sep 2022 20:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ij3DZvBaMg2cT+j7iCyI87VzLHjgf7crKXLQSpWr014=;
 b=YSaRJC4AmOhxf3g5jgrKIhc42qFU9TyHnJz0mcFsXVCwVOdt/nW5ThJxwk23A6Y7azmE
 hWvydqlwdeDQlyjLtrPd3Y71SU0sXCmR6YUp7/LBKavgWDLHAv3Q43sFzHEu56q6OuAP
 mLihYD6Kf8b/tSJ9Ca6ICVUN9DGv5MXHv7I5xCfyoKYhE8FfxTG8jlpViXfKcCY6RCKn
 sI/np/9SQQLXW5uzNHjeQsIJRRAtWWyfM/iIKkgDtiobAr3AHanq4F9OZ4UycBiQVZoI
 0dbTUYlku3/jLE5MIWw4zvwvaak56HxuLaXCVNfs20yvqdOfZNIDIfVftLxjuks52pYi 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvqhhuu2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 20:17:19 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28SKHJIs024292;
        Wed, 28 Sep 2022 20:17:19 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvqhhuu1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 20:17:19 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28SK5KFE026387;
        Wed, 28 Sep 2022 20:17:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3jssh8v8s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 20:17:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28SKHDvJ3932720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 20:17:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4281BA4051;
        Wed, 28 Sep 2022 20:17:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F16D7A4040;
        Wed, 28 Sep 2022 20:17:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 20:17:12 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 2/2] s390x: Test specification exceptions during transaction
Date:   Wed, 28 Sep 2022 22:17:10 +0200
Message-Id: <20220928201710.3185449-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928201710.3185449-1-scgl@linux.ibm.com>
References: <20220928201710.3185449-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3z9lmtciJEjIKW2afdx5J7eeLpBk8y9y
X-Proofpoint-ORIG-GUID: avVnD7-JBFnf1aW6Xytz2DVHgjQ4SBap
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_09,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Program interruptions during transactional execution cause other
interruption codes.
Check that we see the expected code for (some) specification exceptions.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |   1 +
 s390x/spec_ex.c          | 199 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 195 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index aca3af8e..41c9bd8c 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -73,6 +73,7 @@ struct cpu {
 #define PSW_MASK_BA			0x0000000080000000UL
 #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
 
+#define CTL0_TRANSACT_EX_CTL			(63 -  8)
 #define CTL0_LOW_ADDR_PROT			(63 - 35)
 #define CTL0_EDAT				(63 - 40)
 #define CTL0_FETCH_PROTECTION_OVERRIDE		(63 - 38)
diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 2d4adb8c..42ecaed3 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -4,13 +4,19 @@
  *
  * Specification exception test.
  * Tests that specification exceptions occur when expected.
+ * This includes specification exceptions occurring during transactional execution
+ * as these result in another interruption code (the transactional-execution-aborted
+ * bit is set).
  *
  * Can be extended by adding triggers to spec_ex_triggers, see comments below.
  */
 #include <stdlib.h>
+#include <htmintrin.h>
 #include <libcflat.h>
 #include <bitops.h>
+#include <asm/barrier.h>
 #include <asm/interrupt.h>
+#include <asm/facility.h>
 
 /* toggled to signal occurrence of invalid psw fixup */
 static bool invalid_psw_expected;
@@ -157,20 +163,22 @@ static int not_even(void)
 /*
  * Harness for specification exception testing.
  * func only triggers exception, reporting is taken care of automatically.
+ * If a trigger is transactable it will also be executed during a transaction.
  */
 struct spec_ex_trigger {
 	const char *name;
 	int (*func)(void);
+	bool transactable;
 	void (*fixup)(struct stack_frame_int *stack);
 };
 
 /* List of all tests to execute */
 static const struct spec_ex_trigger spec_ex_triggers[] = {
-	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
-	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, &fixup_invalid_psw },
-	{ "bad_alignment", &bad_alignment, NULL },
-	{ "not_even", &not_even, NULL },
-	{ NULL, NULL, NULL },
+	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
+	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
+	{ "bad_alignment", &bad_alignment, true, NULL },
+	{ "not_even", &not_even, true, NULL },
+	{ NULL, NULL, false, NULL },
 };
 
 static void test_spec_ex(const struct spec_ex_trigger *trigger)
@@ -187,10 +195,181 @@ static void test_spec_ex(const struct spec_ex_trigger *trigger)
 	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 }
 
+#define TRANSACTION_COMPLETED 4
+#define TRANSACTION_MAX_RETRIES 5
+
+/*
+ * NULL must not be passed to __builtin_tbegin via variable, only constant,
+ * forbid diagnose from being NULL at all to keep things simple
+ */
+static int __attribute__((nonnull))
+with_transaction(int (*trigger)(void), struct __htm_tdb *diagnose)
+{
+	int cc;
+
+	cc = __builtin_tbegin(diagnose);
+	/*
+	 * Everything between tbegin and tend is part of the transaction,
+	 * which either completes in its entirety or does not have any effect.
+	 * If the transaction fails, execution is reset to this point with another
+	 * condition code indicating why the transaction failed.
+	 */
+	if (cc == _HTM_TBEGIN_STARTED) {
+		/*
+		 * return code is meaningless: transaction needs to complete
+		 * in order to return and completion indicates a test failure
+		 */
+		trigger();
+		__builtin_tend();
+		return TRANSACTION_COMPLETED;
+	} else {
+		return cc;
+	}
+}
+
+static int retry_transaction(const struct spec_ex_trigger *trigger, unsigned int max_retries,
+			     struct __htm_tdb *tdb, uint16_t expected_pgm)
+{
+	int trans_result, i;
+	uint16_t pgm;
+
+	for (i = 0; i < max_retries; i++) {
+		expect_pgm_int();
+		trans_result = with_transaction(trigger->func, tdb);
+		if (trans_result == _HTM_TBEGIN_TRANSIENT) {
+			mb();
+			pgm = lowcore.pgm_int_code;
+			if (pgm == expected_pgm)
+				return 0;
+			else if (pgm == 0)
+				/*
+				 * Transaction failed for unknown reason but not because
+				 * of an unexpected program exception. Give it another
+				 * go so that hopefully it reaches the triggering instruction.
+				 */
+				continue;
+		}
+		return trans_result;
+	}
+	return TRANSACTION_MAX_RETRIES;
+}
+
+struct args {
+	uint64_t max_retries;
+	bool diagnose;
+};
+
+static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
+{
+	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION |
+				      PGM_INT_CODE_TX_ABORTED_EVENT;
+	union {
+		struct __htm_tdb tdb;
+		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
+	} diag;
+	unsigned int i;
+	int trans_result;
+
+	if (!test_facility(73)) {
+		report_skip("transactional-execution facility not installed");
+		return;
+	}
+	ctl_set_bit(0, CTL0_TRANSACT_EX_CTL); /* enable transactional-exec */
+
+	register_pgm_cleanup_func(trigger->fixup);
+	trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);
+	register_pgm_cleanup_func(NULL);
+	switch (trans_result) {
+	case 0:
+		report_pass("Program interrupt: expected(%d) == received(%d)",
+			    expected_pgm, expected_pgm);
+		break;
+	case _HTM_TBEGIN_INDETERMINATE:
+	case _HTM_TBEGIN_PERSISTENT:
+		report_info("transaction failed with cc %d", trans_result);
+		report_info("transaction abort code: %llu", diag.tdb.abort_code);
+		if (args->diagnose)
+			for (i = 0; i < 32; i++)
+				report_info("diag+%03d: %016lx", i * 8, diag.dwords[i]);
+		break;
+	case _HTM_TBEGIN_TRANSIENT:
+		report_fail("Program interrupt: expected(%d) == received(%d)",
+			    expected_pgm, clear_pgm_int());
+		break;
+	case TRANSACTION_COMPLETED:
+		report_fail("Transaction completed without exception");
+		break;
+	case TRANSACTION_MAX_RETRIES:
+		report_skip("Transaction retried %lu times with transient failures, giving up",
+			    args->max_retries);
+		break;
+	default:
+		report_fail("Invalid transaction result");
+		break;
+	}
+
+	ctl_clear_bit(0, CTL0_TRANSACT_EX_CTL);
+}
+
+static bool parse_unsigned(const char *arg, unsigned int *out)
+{
+	char *end;
+	long num;
+
+	if (arg[0] == '\0')
+		return false;
+	num = strtol(arg, &end, 10);
+	if (end[0] != '\0' || num < 0)
+		return false;
+	*out = num;
+	return true;
+}
+
+static struct args parse_args(int argc, char **argv)
+{
+	struct args args = {
+		.max_retries = 20,
+		.diagnose = false
+	};
+	unsigned int i, arg;
+	bool has_arg;
+	const char *flag;
+
+	for (i = 1; i < argc; i++) {
+		if (i + 1 < argc)
+			has_arg = parse_unsigned(argv[i + 1], &arg);
+		else
+			has_arg = false;
+
+		flag = "--max-retries";
+		if (!strcmp(flag, argv[i])) {
+			if (!has_arg)
+				report_abort("%s needs a positive parameter", flag);
+			args.max_retries = arg;
+			++i;
+			continue;
+		}
+		if (!strcmp("--diagnose", argv[i])) {
+			args.diagnose = true;
+			continue;
+		}
+		if (!strcmp("--no-diagnose", argv[i])) {
+			args.diagnose = false;
+			continue;
+		}
+		report_abort("Unsupported parameter '%s'",
+			     argv[i]);
+	}
+
+	return args;
+}
+
 int main(int argc, char **argv)
 {
 	unsigned int i;
 
+	struct args args = parse_args(argc, argv);
+
 	report_prefix_push("specification exception");
 	for (i = 0; spec_ex_triggers[i].name; i++) {
 		report_prefix_push(spec_ex_triggers[i].name);
@@ -199,5 +378,15 @@ int main(int argc, char **argv)
 	}
 	report_prefix_pop();
 
+	report_prefix_push("specification exception during transaction");
+	for (i = 0; spec_ex_triggers[i].name; i++) {
+		if (spec_ex_triggers[i].transactable) {
+			report_prefix_push(spec_ex_triggers[i].name);
+			test_spec_ex_trans(&args, &spec_ex_triggers[i]);
+			report_prefix_pop();
+		}
+	}
+	report_prefix_pop();
+
 	return report_summary();
 }
-- 
2.36.1

