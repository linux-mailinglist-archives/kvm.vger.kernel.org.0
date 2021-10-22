Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AE9437656
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 14:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhJVMEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 08:04:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhJVMEf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 08:04:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MB0Qlu009418;
        Fri, 22 Oct 2021 08:02:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SckNpGiWQDiz1do1sX8nIoKADmLIRGl6RgRq8T9gVaM=;
 b=OXXvgwCM/XZB6SrItmCJH5g5fBUGg/dOgswy0fwNqQdg3xHrHOnPPjd2Hq43HGmu28+i
 fHgl+i7uuFEbJKWZXvw9W0pDCcgmQJ9oBDtLJjhzBTJ19v8hnum5oblxbdceEBPxT3zJ
 9JpKzUU8SWZS2A42EIZjhzQg381QaJ7WlvRJaLH8mS79QVakKsFa8eQTXNkso5U0Q5FU
 lanSB5aNM6Tk6EjvL/dg0rc8hRXJzBJsJjsZiPP2sp2XBl39R3BrIrVKWnCtmZwB30Ni
 dIeB7C8yPxbWbRpFRS9aBmFEoIVuD0Cp/joJWv3X2NYSd/CJsvUKD0v21otxq4LSrkTs Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3busa14p4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:02:17 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19MAoMoW025489;
        Fri, 22 Oct 2021 08:02:17 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3busa14p3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:02:17 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MBvjwB000738;
        Fri, 22 Oct 2021 12:02:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0kr3u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 12:02:11 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MBu5NI54067530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 11:56:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B10C5208C;
        Fri, 22 Oct 2021 12:02:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 639555205A;
        Fri, 22 Oct 2021 12:02:00 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 2/2] s390x: Test specification exceptions during transaction
Date:   Fri, 22 Oct 2021 14:01:56 +0200
Message-Id: <20211022120156.281567-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022120156.281567-1-scgl@linux.ibm.com>
References: <20211022120156.281567-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w8pWsi2gERWSm-lWaPPMYqjsOrOEcIsF
X-Proofpoint-ORIG-GUID: 0Z-TX7hKC5dfJkbQ0yYoItMv4Vm0ktqR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_03,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Program interruptions during transactional execution cause other
interruption codes.
Check that we see the expected code for (some) specification exceptions.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |   1 +
 s390x/spec_ex.c          | 172 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 168 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 40626d7..f7fb467 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -55,6 +55,7 @@ struct psw {
 #define PSW_MASK_BA			0x0000000080000000UL
 #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
 
+#define CTL0_TRANSACT_EX_CTL		(63 -  8)
 #define CTL0_LOW_ADDR_PROT		(63 - 35)
 #define CTL0_EDAT			(63 - 40)
 #define CTL0_IEP			(63 - 43)
diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index ec3322a..f3628bd 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -4,9 +4,14 @@
  *
  * Specification exception test.
  * Tests that specification exceptions occur when expected.
+ * This includes specification exceptions occurring during transactional execution
+ * as these result in another interruption code (the transactional-execution-aborted
+ * bit is set).
  */
 #include <stdlib.h>
+#include <htmintrin.h>
 #include <libcflat.h>
+#include <asm/barrier.h>
 #include <asm/interrupt.h>
 #include <asm/facility.h>
 
@@ -92,18 +97,23 @@ static void not_even(void)
 struct spec_ex_trigger {
 	const char *name;
 	void (*func)(void);
+	bool transactable;
 	void (*fixup)(void);
 };
 
 static const struct spec_ex_trigger spec_ex_triggers[] = {
-	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
-	{ "bad_alignment", &bad_alignment, NULL},
-	{ "not_even", &not_even, NULL},
-	{ NULL, NULL, NULL},
+	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw},
+	{ "bad_alignment", &bad_alignment, true, NULL},
+	{ "not_even", &not_even, true, NULL},
+	{ NULL, NULL, true, NULL},
 };
 
 struct args {
 	uint64_t iterations;
+	uint64_t max_retries;
+	uint64_t suppress_info;
+	uint64_t max_failures;
+	bool diagnose;
 };
 
 static void test_spec_ex(struct args *args,
@@ -131,14 +141,132 @@ static void test_spec_ex(struct args *args,
 		    expected_pgm);
 }
 
+#define TRANSACTION_COMPLETED 4
+#define TRANSACTION_MAX_RETRIES 5
+
+/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
+ * being NULL to keep things simple
+ */
+static int __attribute__((nonnull))
+with_transaction(void (*trigger)(void), struct __htm_tdb *diagnose)
+{
+	int cc;
+
+	cc = __builtin_tbegin(diagnose);
+	if (cc == _HTM_TBEGIN_STARTED) {
+		trigger();
+		__builtin_tend();
+		return -TRANSACTION_COMPLETED;
+	} else {
+		return -cc;
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
+		if (trans_result == -_HTM_TBEGIN_TRANSIENT) {
+			mb();
+			pgm = lc->pgm_int_code;
+			if (pgm == 0)
+				continue;
+			else if (pgm == expected_pgm)
+				return 0;
+		}
+		return trans_result;
+	}
+	return -TRANSACTION_MAX_RETRIES;
+}
+
+static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
+{
+	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
+			      | PGM_INT_CODE_TX_ABORTED_EVENT;
+	union {
+		struct __htm_tdb tdb;
+		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
+	} diag;
+	unsigned int i, failures = 0;
+	int trans_result;
+
+	if (!test_facility(73)) {
+		report_skip("transactional-execution facility not installed");
+		return;
+	}
+	ctl_set_bit(0, CTL0_TRANSACT_EX_CTL); /* enable transactional-exec */
+
+	for (i = 0; i < args->iterations && failures <= args->max_failures; i++) {
+		register_pgm_cleanup_func(trigger->fixup);
+		trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);
+		register_pgm_cleanup_func(NULL);
+		switch (trans_result) {
+		case 0:
+			continue;
+		case -_HTM_TBEGIN_INDETERMINATE:
+		case -_HTM_TBEGIN_PERSISTENT:
+			if (failures < args->suppress_info)
+				report_info("transaction failed with cc %d",
+					    -trans_result);
+			break;
+		case -_HTM_TBEGIN_TRANSIENT:
+			report_fail("Program interrupt: expected(%d) == received(%d)",
+				    expected_pgm,
+				    clear_pgm_int());
+			goto out;
+		case -TRANSACTION_COMPLETED:
+			report_fail("Transaction completed without exception");
+			goto out;
+		case -TRANSACTION_MAX_RETRIES:
+			if (failures < args->suppress_info)
+				report_info("Retried transaction %lu times without exception",
+					    args->max_retries);
+			break;
+		default:
+			report_fail("Invalid return transaction result");
+			goto out;
+		}
+
+		if (failures < args->suppress_info)
+			report_info("transaction abort code: %llu", diag.tdb.abort_code);
+		if (args->diagnose && failures < args->suppress_info) {
+			for (i = 0; i < 32; i++)
+				report_info("diag+%03d: %016lx", i*8, diag.dwords[i]);
+		}
+		++failures;
+	}
+	if (failures <= args->max_failures) {
+		report_pass(
+			"Program interrupt: always expected(%d) == received(%d), transaction failures: %u",
+			expected_pgm,
+			expected_pgm,
+			failures);
+	} else {
+		report_fail("Too many transaction failures: %u", failures);
+	}
+	if (failures > args->suppress_info)
+		report_info("Suppressed some transaction failure information messages");
+
+out:
+	ctl_clear_bit(0, CTL0_TRANSACT_EX_CTL);
+}
+
 static struct args parse_args(int argc, char **argv)
 {
 	struct args args = {
 		.iterations = 1,
+		.max_retries = 20,
+		.suppress_info = 20,
+		.diagnose = false
 	};
 	unsigned int i;
 	long arg;
-	bool no_arg;
+	bool no_arg, max_failures = false;
 	char *end;
 
 	for (i = 1; i < argc; i++) {
@@ -155,11 +283,35 @@ static struct args parse_args(int argc, char **argv)
 				report_abort("--iterations needs a positive parameter");
 			args.iterations = arg;
 			++i;
+		} else if (!strcmp("--max-retries", argv[i])) {
+			if (no_arg)
+				report_abort("--max-retries needs a positive parameter");
+			args.max_retries = arg;
+			++i;
+		} else if (!strcmp("--suppress-info", argv[i])) {
+			if (no_arg)
+				report_abort("--suppress-info needs a positive parameter");
+			args.suppress_info = arg;
+			++i;
+		} else if (!strcmp("--max-failures", argv[i])) {
+			if (no_arg)
+				report_abort("--max-failures needs a positive parameter");
+			args.max_failures = arg;
+			max_failures = true;
+			++i;
+		} else if (!strcmp("--diagnose", argv[i])) {
+			args.diagnose = true;
+		} else if (!strcmp("--no-diagnose", argv[i])) {
+			args.diagnose = false;
 		} else {
 			report_abort("Unsupported parameter '%s'",
 				     argv[i]);
 		}
 	}
+
+	if (!max_failures)
+		args.max_failures = args.iterations / 1000;
+
 	return args;
 }
 
@@ -177,5 +329,15 @@ int main(int argc, char **argv)
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
2.31.1

