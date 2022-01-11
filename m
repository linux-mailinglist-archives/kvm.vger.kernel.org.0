Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBA248B267
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 17:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350133AbiAKQjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 11:39:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1350090AbiAKQjN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 11:39:13 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BGJ0xk007863;
        Tue, 11 Jan 2022 16:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vtJjfVRVFvxUruJifBuxeLoaxVKKjLKnBJxu0ng9/54=;
 b=a87oBUu3mcGenO2gBTXPPRWz6riORTOCMkiIRF5Rj7inVdplGz2yRYkJCOUzUwuSBMBX
 em7mE/bTxLNVcjH8t3uWxvceAq4xWP6YhwBNF7Kj7vpT3Ve7UL6b8Hf7dWcCRvATvT5N
 vvhR7rZIe9tkISVj5rc7aBBIj/P4p8NYv4F24SmujQHTS5Bwz++empolEDEl5uW2bJnB
 onsxck1PJJfsZFXPLVt7fTlVbdyzr/NjHYpnhz369Ckf7hQXJmgKb37V+OQBOUBJgWfG
 JTX/WwurYKKJLVxDdEiOqYYF5wDgkOLVrs+9++2fZ4TLtWX21VGxruIW9KzpXQ9IDKib EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfm05ke0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:39:11 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BGa120029941;
        Tue, 11 Jan 2022 16:39:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfm05ke08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:39:11 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BGXjr6026934;
        Tue, 11 Jan 2022 16:39:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhj33bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:39:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BGd4U243057506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 16:39:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 322CF5207C;
        Tue, 11 Jan 2022 16:39:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 008365206B;
        Tue, 11 Jan 2022 16:39:03 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 2/2] s390x: Test specification exceptions during transaction
Date:   Tue, 11 Jan 2022 17:39:01 +0100
Message-Id: <20220111163901.1263736-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220111163901.1263736-1-scgl@linux.ibm.com>
References: <20220111163901.1263736-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CxwZB2sUPwNcjP0b6ja0TT3PXQYHFVdM
X-Proofpoint-ORIG-GUID: lDdOfMGVNT7kPNNmbo5tn7QFqn7ZYgWo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 adultscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Program interruptions during transactional execution cause other
interruption codes.
Check that we see the expected code for (some) specification exceptions.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
I don't think we can use constraint transactions to guarantee successful
execution of the transaction unless we implement it completely in asm,
otherwise we cannot ensure that the constraints of the transaction are met.

 lib/s390x/asm/arch_def.h |   1 +
 s390x/spec_ex.c          | 177 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 174 insertions(+), 4 deletions(-)

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
index a9f9f31..e599994 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -4,12 +4,18 @@
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
+#include <asm/barrier.h>
 #include <asm/interrupt.h>
+#include <asm/facility.h>
 
 static struct lowcore *lc = (struct lowcore *) 0;
 
@@ -106,19 +112,21 @@ static int not_even(void)
 /*
  * Harness for specification exception testing.
  * func only triggers exception, reporting is taken care of automatically.
+ * If a trigger is transactable it will also  be executed during a transaction.
  */
 struct spec_ex_trigger {
 	const char *name;
 	int (*func)(void);
+	bool transactable;
 	void (*fixup)(void);
 };
 
 /* List of all tests to execute */
 static const struct spec_ex_trigger spec_ex_triggers[] = {
-	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
-	{ "bad_alignment", &bad_alignment, NULL },
-	{ "not_even", &not_even, NULL },
-	{ NULL, NULL, NULL },
+	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
+	{ "bad_alignment", &bad_alignment, true, NULL },
+	{ "not_even", &not_even, true, NULL },
+	{ NULL, NULL, false, NULL },
 };
 
 static void test_spec_ex(const struct spec_ex_trigger *trigger)
@@ -138,10 +146,161 @@ static void test_spec_ex(const struct spec_ex_trigger *trigger)
 	       expected_pgm, pgm);
 }
 
+#define TRANSACTION_COMPLETED 4
+#define TRANSACTION_MAX_RETRIES 5
+
+/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
+ * being NULL to keep things simple
+ */
+static int __attribute__((nonnull))
+with_transaction(int (*trigger)(void), struct __htm_tdb *diagnose)
+{
+	int cc;
+
+	cc = __builtin_tbegin(diagnose);
+	if (cc == _HTM_TBEGIN_STARTED) {
+		/* return code is meaningless: transaction needs to complete
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
+			pgm = lc->pgm_int_code;
+			if (pgm == 0)
+				continue;
+			else if (pgm == expected_pgm)
+				return 0;
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
+	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
+				      | PGM_INT_CODE_TX_ABORTED_EVENT;
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
+		report_info("Retried transaction %lu times without exception",
+			    args->max_retries);
+		break;
+	default:
+		report_fail("Invalid return transaction result");
+		break;
+	}
+
+	ctl_clear_bit(0, CTL0_TRANSACT_EX_CTL);
+}
+
+static struct args parse_args(int argc, char **argv)
+{
+	struct args args = {
+		.max_retries = 20,
+		.diagnose = false
+	};
+	unsigned int i;
+	long arg;
+	bool no_arg;
+	char *end;
+	const char *flag;
+	uint64_t *argp;
+
+	for (i = 1; i < argc; i++) {
+		no_arg = true;
+		if (i < argc - 1) {
+			no_arg = *argv[i + 1] == '\0';
+			arg = strtol(argv[i + 1], &end, 10);
+			no_arg |= *end != '\0';
+			no_arg |= arg < 0;
+		}
+
+		flag = "--max-retries";
+		argp = &args.max_retries;
+		if (!strcmp(flag, argv[i])) {
+			if (no_arg)
+				report_abort("%s needs a positive parameter", flag);
+			*argp = arg;
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
@@ -150,5 +309,15 @@ int main(int argc, char **argv)
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
2.33.1

