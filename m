Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4E48B266
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 17:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343677AbiAKQjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 11:39:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1349958AbiAKQjM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 11:39:12 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BFsMmE001774;
        Tue, 11 Jan 2022 16:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lMSGQca29FcT27b3JSNSTo/jl2ulc58VGH0oQFzap9k=;
 b=sO1ORye6tiDJrTmrxHQ5slaq8TIcSuXbfI588r0/kwpyqMgXBkfr3g4w0kL62IfDMQvb
 r9fJi9jyPQ2Fnd7Xi/omA5fomV8guL4HVygO57jnq0ak/kCqQuRPskiVnasl5kxT0jJ3
 bnGIMemEZByerhkJNioMAGnFlUGkmH8FIPMhutF+oYimrtSVCVXdikHrFi5Cv9RFN8pI
 DWzcgaJ98nYRNdkpsdz/+kVAO7JDeuRd/r0pLZNMzosXipW1+dyNXoOx4NIDQJbk/Q2/
 4KTWtOSRTek8L+3FC8ln2RiJCoejGrZI1msV9lOj88JKbVXpXSRJ+3cZnL/u54MdLFR5 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhb7um4pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:39:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BGaCGu025698;
        Tue, 11 Jan 2022 16:39:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhb7um4nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:39:11 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BGXjr4026934;
        Tue, 11 Jan 2022 16:39:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhj33bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:39:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BGd3rm38863284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 16:39:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F4B852054;
        Tue, 11 Jan 2022 16:39:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5D62C5205F;
        Tue, 11 Jan 2022 16:39:03 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/2] Add specification exception tests
Date:   Tue, 11 Jan 2022 17:38:59 +0100
Message-Id: <20220111163901.1263736-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BLSCkAFjWaK0EN3CE-cJpf0TmTATUDZJ
X-Proofpoint-GUID: hbI_5aBdrKiy8nWRlkENMxzkya9HXCpv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201110093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that specification exceptions cause the correct interruption code
during both normal and transactional execution.

v3 -> v4
	remove iterations argument in order to simplify the code
		for manual performance testing adding a for loop is easy
	move report out of fixup_invalid_psw
	simplify/improve readability of triggers
	use positive error values

v2 -> v3
	remove non-ascii symbol
	clean up load_psw
	fix nits

v1 -> v2
	Add license and test description
	Split test patch into normal test and transactional execution test
	Add comments to
		invalid PSW fixup function
		with_transaction
	Rename some variables/functions
	Pass mask as single parameter to asm
	Get rid of report_info_if macro
	Introduce report_pass/fail and use them

Janis Schoetterl-Glausch (2):
  s390x: Add specification exception test
  s390x: Test specification exceptions during transaction

 s390x/Makefile           |   1 +
 lib/s390x/asm/arch_def.h |   1 +
 s390x/spec_ex.c          | 323 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 4 files changed, 328 insertions(+)
 create mode 100644 s390x/spec_ex.c

Range-diff against v3:
1:  75d0bf1 ! 1:  a242e84 s390x: Add specification exception test
    @@ Commit message
         s390x: Add specification exception test
     
         Generate specification exceptions and check that they occur.
    -    With the iterations argument one can check if specification
    -    exception interpretation occurs, e.g. by using a high value and
    -    checking that the debugfs counters are substantially lower.
    -    The argument is also useful for estimating the performance benefit
    -    of interpretation.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
     
      ## s390x/Makefile ##
    -@@ s390x/Makefile: tests += $(TEST_DIR)/mvpg.elf
    - tests += $(TEST_DIR)/uv-host.elf
    +@@ s390x/Makefile: tests += $(TEST_DIR)/uv-host.elf
      tests += $(TEST_DIR)/edat.elf
      tests += $(TEST_DIR)/mvpg-sie.elf
    + tests += $(TEST_DIR)/spec_ex-sie.elf
     +tests += $(TEST_DIR)/spec_ex.elf
    + tests += $(TEST_DIR)/firq.elf
      
      tests_binary = $(patsubst %.elf,%.bin,$(tests))
    - ifneq ($(HOST_KEY_DOCUMENT),)
     
      ## s390x/spec_ex.c (new) ##
     @@
    @@ s390x/spec_ex.c (new)
     + *
     + * Specification exception test.
     + * Tests that specification exceptions occur when expected.
    ++ *
    ++ * Can be extended by adding triggers to spec_ex_triggers, see comments below.
     + */
     +#include <stdlib.h>
     +#include <libcflat.h>
     +#include <asm/interrupt.h>
    -+#include <asm/facility.h>
     +
     +static struct lowcore *lc = (struct lowcore *) 0;
     +
    -+static bool expect_invalid_psw;
    ++static bool invalid_psw_expected;
     +static struct psw expected_psw;
    ++static struct psw invalid_psw;
     +static struct psw fixup_psw;
     +
     +/* The standard program exception handler cannot deal with invalid old PSWs,
    @@ s390x/spec_ex.c (new)
     + */
     +static void fixup_invalid_psw(void)
     +{
    -+	if (expect_invalid_psw) {
    -+		report(expected_psw.mask == lc->pgm_old_psw.mask
    -+		       && expected_psw.addr == lc->pgm_old_psw.addr,
    -+		       "Invalid program new PSW as expected");
    -+		expect_invalid_psw = false;
    -+	}
    ++	// signal occurrence of invalid psw fixup
    ++	invalid_psw_expected = false;
    ++	invalid_psw = lc->pgm_old_psw;
     +	lc->pgm_old_psw = fixup_psw;
     +}
     +
     +/* Load possibly invalid psw, but setup fixup_psw before,
     + * so that *fixup_invalid_psw() can bring us back onto the right track.
    ++ * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
     + */
     +static void load_psw(struct psw psw)
     +{
     +	uint64_t scratch;
     +
     +	fixup_psw.mask = extract_psw_mask();
    -+	asm volatile (
    -+		"	larl	%[scratch],nop%=\n"
    ++	asm volatile ( "larl	%[scratch],nop%=\n"
     +		"	stg	%[scratch],%[addr]\n"
     +		"	lpswe	%[psw]\n"
     +		"nop%=:	nop\n"
    @@ s390x/spec_ex.c (new)
     +	);
     +}
     +
    -+static void psw_bit_12_is_1(void)
    ++static void expect_invalid_psw(struct psw psw)
     +{
    -+	expected_psw.mask = 0x0008000000000000;
    -+	expected_psw.addr = 0x00000000deadbeee;
    -+	expect_invalid_psw = true;
    ++	expected_psw = psw;
    ++	invalid_psw_expected = true;
    ++}
    ++
    ++static int check_invalid_psw(void)
    ++{
    ++	// toggled to signal occurrence of invalid psw fixup
    ++	if (!invalid_psw_expected) {
    ++		if (expected_psw.mask == invalid_psw.mask &&
    ++		    expected_psw.addr == invalid_psw.addr)
    ++			return 0;
    ++		report_fail("Wrong invalid PSW");
    ++	} else {
    ++		report_fail("Expected exception due to invalid PSW");
    ++	}
    ++	return 1;
    ++}
    ++
    ++static int psw_bit_12_is_1(void)
    ++{
    ++	struct psw invalid = { .mask = 0x0008000000000000, .addr = 0x00000000deadbeee};
    ++
    ++	expect_invalid_psw(invalid);
     +	load_psw(expected_psw);
    ++	return check_invalid_psw();
     +}
     +
    -+static void bad_alignment(void)
    ++static int bad_alignment(void)
     +{
    -+	uint32_t words[5] = {0, 0, 0};
    -+	uint32_t (*bad_aligned)[4];
    -+
    -+	register uint64_t r1 asm("6");
    -+	register uint64_t r2 asm("7");
    -+	if (((uintptr_t)&words[0]) & 0xf)
    -+		bad_aligned = (uint32_t (*)[4])&words[0];
    -+	else
    -+		bad_aligned = (uint32_t (*)[4])&words[1];
    -+	asm volatile ("lpq %0,%2"
    -+		      : "=r"(r1), "=r"(r2)
    -+		      : "T"(*bad_aligned)
    ++	uint32_t words[5] __attribute__((aligned(16)));
    ++	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
    ++
    ++	asm volatile ("lpq %%r6,%[bad]"
    ++		      : : [bad] "T"(*bad_aligned)
    ++		      : "%r6", "%r7"
     +	);
    ++	return 0;
     +}
     +
    -+static void not_even(void)
    ++static int not_even(void)
     +{
    -+	uint64_t quad[2];
    ++	uint64_t quad[2] __attribute__((aligned(16))) = {0};
     +
    -+	register uint64_t r1 asm("7");
    -+	register uint64_t r2 asm("8");
    -+	asm volatile (".insn	rxy,0xe3000000008f,%0,%2" //lpq %0,%2
    -+		      : "=r"(r1), "=r"(r2)
    -+		      : "T"(quad)
    ++	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" //lpq %%r7,%[quad]
    ++		      : : [quad] "T"(quad)
    ++		      : "%r7", "%r8"
     +	);
    ++	return 0;
     +}
     +
    ++/*
    ++ * Harness for specification exception testing.
    ++ * func only triggers exception, reporting is taken care of automatically.
    ++ */
     +struct spec_ex_trigger {
     +	const char *name;
    -+	void (*func)(void);
    ++	int (*func)(void);
     +	void (*fixup)(void);
     +};
     +
    ++/* List of all tests to execute */
     +static const struct spec_ex_trigger spec_ex_triggers[] = {
    -+	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
    -+	{ "bad_alignment", &bad_alignment, NULL},
    -+	{ "not_even", &not_even, NULL},
    -+	{ NULL, NULL, NULL},
    ++	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
    ++	{ "bad_alignment", &bad_alignment, NULL },
    ++	{ "not_even", &not_even, NULL },
    ++	{ NULL, NULL, NULL },
     +};
     +
    -+struct args {
    -+	uint64_t iterations;
    -+};
    -+
    -+static void test_spec_ex(struct args *args,
    -+			 const struct spec_ex_trigger *trigger)
    ++static void test_spec_ex(const struct spec_ex_trigger *trigger)
     +{
     +	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
     +	uint16_t pgm;
    -+	unsigned int i;
    -+
    -+	for (i = 0; i < args->iterations; i++) {
    -+		expect_pgm_int();
    -+		register_pgm_cleanup_func(trigger->fixup);
    -+		trigger->func();
    -+		register_pgm_cleanup_func(NULL);
    -+		pgm = clear_pgm_int();
    -+		if (pgm != expected_pgm) {
    -+			report_fail("Program interrupt: expected(%d) == received(%d)",
    -+				    expected_pgm,
    -+				    pgm);
    -+			return;
    -+		}
    -+	}
    -+	report_pass("Program interrupt: always expected(%d) == received(%d)",
    -+		    expected_pgm,
    -+		    expected_pgm);
    -+}
    -+
    -+static struct args parse_args(int argc, char **argv)
    -+{
    -+	struct args args = {
    -+		.iterations = 1,
    -+	};
    -+	unsigned int i;
    -+	long arg;
    -+	bool no_arg;
    -+	char *end;
    -+
    -+	for (i = 1; i < argc; i++) {
    -+		no_arg = true;
    -+		if (i < argc - 1) {
    -+			no_arg = *argv[i + 1] == '\0';
    -+			arg = strtol(argv[i + 1], &end, 10);
    -+			no_arg |= *end != '\0';
    -+			no_arg |= arg < 0;
    -+		}
    -+
    -+		if (!strcmp("--iterations", argv[i])) {
    -+			if (no_arg)
    -+				report_abort("--iterations needs a positive parameter");
    -+			args.iterations = arg;
    -+			++i;
    -+		} else {
    -+			report_abort("Unsupported parameter '%s'",
    -+				     argv[i]);
    -+		}
    -+	}
    -+	return args;
    ++	int rc;
    ++
    ++	expect_pgm_int();
    ++	register_pgm_cleanup_func(trigger->fixup);
    ++	rc = trigger->func();
    ++	register_pgm_cleanup_func(NULL);
    ++	if (rc)
    ++		return;
    ++	pgm = clear_pgm_int();
    ++	report(pgm == expected_pgm, "Program interrupt: expected(%d) == received(%d)",
    ++	       expected_pgm, pgm);
     +}
     +
     +int main(int argc, char **argv)
     +{
     +	unsigned int i;
     +
    -+	struct args args = parse_args(argc, argv);
    -+
     +	report_prefix_push("specification exception");
     +	for (i = 0; spec_ex_triggers[i].name; i++) {
     +		report_prefix_push(spec_ex_triggers[i].name);
    -+		test_spec_ex(&args, &spec_ex_triggers[i]);
    ++		test_spec_ex(&spec_ex_triggers[i]);
     +		report_prefix_pop();
     +	}
     +	report_prefix_pop();
    @@ s390x/spec_ex.c (new)
     +}
     
      ## s390x/unittests.cfg ##
    -@@ s390x/unittests.cfg: file = edat.elf
    +@@ s390x/unittests.cfg: file = mvpg-sie.elf
    + [spec_ex-sie]
    + file = spec_ex-sie.elf
      
    - [mvpg-sie]
    - file = mvpg-sie.elf
    -+
     +[spec_ex]
     +file = spec_ex.elf
    ++
    + [firq-linear-cpu-ids]
    + file = firq.elf
    + timeout = 20
2:  0593951 ! 2:  16ce8bb s390x: Test specification exceptions during transaction
    @@ s390x/spec_ex.c
     + * This includes specification exceptions occurring during transactional execution
     + * as these result in another interruption code (the transactional-execution-aborted
     + * bit is set).
    +  *
    +  * Can be extended by adding triggers to spec_ex_triggers, see comments below.
       */
      #include <stdlib.h>
     +#include <htmintrin.h>
      #include <libcflat.h>
     +#include <asm/barrier.h>
      #include <asm/interrupt.h>
    - #include <asm/facility.h>
    ++#include <asm/facility.h>
    + 
    + static struct lowcore *lc = (struct lowcore *) 0;
      
    -@@ s390x/spec_ex.c: static void not_even(void)
    +@@ s390x/spec_ex.c: static int not_even(void)
    + /*
    +  * Harness for specification exception testing.
    +  * func only triggers exception, reporting is taken care of automatically.
    ++ * If a trigger is transactable it will also  be executed during a transaction.
    +  */
      struct spec_ex_trigger {
      	const char *name;
    - 	void (*func)(void);
    + 	int (*func)(void);
     +	bool transactable;
      	void (*fixup)(void);
      };
      
    + /* List of all tests to execute */
      static const struct spec_ex_trigger spec_ex_triggers[] = {
    --	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
    --	{ "bad_alignment", &bad_alignment, NULL},
    --	{ "not_even", &not_even, NULL},
    --	{ NULL, NULL, NULL},
    -+	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw},
    -+	{ "bad_alignment", &bad_alignment, true, NULL},
    -+	{ "not_even", &not_even, true, NULL},
    -+	{ NULL, NULL, true, NULL},
    - };
    - 
    - struct args {
    - 	uint64_t iterations;
    -+	uint64_t max_retries;
    -+	uint64_t suppress_info;
    -+	uint64_t max_failures;
    -+	bool diagnose;
    +-	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
    +-	{ "bad_alignment", &bad_alignment, NULL },
    +-	{ "not_even", &not_even, NULL },
    +-	{ NULL, NULL, NULL },
    ++	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
    ++	{ "bad_alignment", &bad_alignment, true, NULL },
    ++	{ "not_even", &not_even, true, NULL },
    ++	{ NULL, NULL, false, NULL },
      };
      
    - static void test_spec_ex(struct args *args,
    -@@ s390x/spec_ex.c: static void test_spec_ex(struct args *args,
    - 		    expected_pgm);
    + static void test_spec_ex(const struct spec_ex_trigger *trigger)
    +@@ s390x/spec_ex.c: static void test_spec_ex(const struct spec_ex_trigger *trigger)
    + 	       expected_pgm, pgm);
      }
      
     +#define TRANSACTION_COMPLETED 4
    @@ s390x/spec_ex.c: static void test_spec_ex(struct args *args,
     + * being NULL to keep things simple
     + */
     +static int __attribute__((nonnull))
    -+with_transaction(void (*trigger)(void), struct __htm_tdb *diagnose)
    ++with_transaction(int (*trigger)(void), struct __htm_tdb *diagnose)
     +{
     +	int cc;
     +
     +	cc = __builtin_tbegin(diagnose);
     +	if (cc == _HTM_TBEGIN_STARTED) {
    ++		/* return code is meaningless: transaction needs to complete
    ++		 * in order to return and completion indicates a test failure
    ++		 */
     +		trigger();
     +		__builtin_tend();
    -+		return -TRANSACTION_COMPLETED;
    ++		return TRANSACTION_COMPLETED;
     +	} else {
    -+		return -cc;
    ++		return cc;
     +	}
     +}
     +
    @@ s390x/spec_ex.c: static void test_spec_ex(struct args *args,
     +	for (i = 0; i < max_retries; i++) {
     +		expect_pgm_int();
     +		trans_result = with_transaction(trigger->func, tdb);
    -+		if (trans_result == -_HTM_TBEGIN_TRANSIENT) {
    ++		if (trans_result == _HTM_TBEGIN_TRANSIENT) {
     +			mb();
     +			pgm = lc->pgm_int_code;
     +			if (pgm == 0)
    @@ s390x/spec_ex.c: static void test_spec_ex(struct args *args,
     +		}
     +		return trans_result;
     +	}
    -+	return -TRANSACTION_MAX_RETRIES;
    ++	return TRANSACTION_MAX_RETRIES;
     +}
     +
    ++struct args {
    ++	uint64_t max_retries;
    ++	bool diagnose;
    ++};
    ++
     +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
     +{
     +	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
    -+			      | PGM_INT_CODE_TX_ABORTED_EVENT;
    ++				      | PGM_INT_CODE_TX_ABORTED_EVENT;
     +	union {
     +		struct __htm_tdb tdb;
     +		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
     +	} diag;
    -+	unsigned int i, failures = 0;
    ++	unsigned int i;
     +	int trans_result;
     +
     +	if (!test_facility(73)) {
    @@ s390x/spec_ex.c: static void test_spec_ex(struct args *args,
     +	}
     +	ctl_set_bit(0, CTL0_TRANSACT_EX_CTL); /* enable transactional-exec */
     +
    -+	for (i = 0; i < args->iterations && failures <= args->max_failures; i++) {
    -+		register_pgm_cleanup_func(trigger->fixup);
    -+		trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);
    -+		register_pgm_cleanup_func(NULL);
    -+		switch (trans_result) {
    -+		case 0:
    -+			continue;
    -+		case -_HTM_TBEGIN_INDETERMINATE:
    -+		case -_HTM_TBEGIN_PERSISTENT:
    -+			if (failures < args->suppress_info)
    -+				report_info("transaction failed with cc %d",
    -+					    -trans_result);
    -+			break;
    -+		case -_HTM_TBEGIN_TRANSIENT:
    -+			report_fail("Program interrupt: expected(%d) == received(%d)",
    -+				    expected_pgm,
    -+				    clear_pgm_int());
    -+			goto out;
    -+		case -TRANSACTION_COMPLETED:
    -+			report_fail("Transaction completed without exception");
    -+			goto out;
    -+		case -TRANSACTION_MAX_RETRIES:
    -+			if (failures < args->suppress_info)
    -+				report_info("Retried transaction %lu times without exception",
    -+					    args->max_retries);
    -+			break;
    -+		default:
    -+			report_fail("Invalid return transaction result");
    -+			goto out;
    -+		}
    -+
    -+		if (failures < args->suppress_info)
    -+			report_info("transaction abort code: %llu", diag.tdb.abort_code);
    -+		if (args->diagnose && failures < args->suppress_info) {
    ++	register_pgm_cleanup_func(trigger->fixup);
    ++	trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);
    ++	register_pgm_cleanup_func(NULL);
    ++	switch (trans_result) {
    ++	case 0:
    ++		report_pass("Program interrupt: expected(%d) == received(%d)",
    ++			    expected_pgm, expected_pgm);
    ++		break;
    ++	case _HTM_TBEGIN_INDETERMINATE:
    ++	case _HTM_TBEGIN_PERSISTENT:
    ++		report_info("transaction failed with cc %d", trans_result);
    ++		report_info("transaction abort code: %llu", diag.tdb.abort_code);
    ++		if (args->diagnose)
     +			for (i = 0; i < 32; i++)
    -+				report_info("diag+%03d: %016lx", i*8, diag.dwords[i]);
    -+		}
    -+		++failures;
    -+	}
    -+	if (failures <= args->max_failures) {
    -+		report_pass(
    -+			"Program interrupt: always expected(%d) == received(%d), transaction failures: %u",
    -+			expected_pgm,
    -+			expected_pgm,
    -+			failures);
    -+	} else {
    -+		report_fail("Too many transaction failures: %u", failures);
    ++				report_info("diag+%03d: %016lx", i * 8, diag.dwords[i]);
    ++		break;
    ++	case _HTM_TBEGIN_TRANSIENT:
    ++		report_fail("Program interrupt: expected(%d) == received(%d)",
    ++			    expected_pgm, clear_pgm_int());
    ++		break;
    ++	case TRANSACTION_COMPLETED:
    ++		report_fail("Transaction completed without exception");
    ++		break;
    ++	case TRANSACTION_MAX_RETRIES:
    ++		report_info("Retried transaction %lu times without exception",
    ++			    args->max_retries);
    ++		break;
    ++	default:
    ++		report_fail("Invalid return transaction result");
    ++		break;
     +	}
    -+	if (failures > args->suppress_info)
    -+		report_info("Suppressed some transaction failure information messages");
     +
    -+out:
     +	ctl_clear_bit(0, CTL0_TRANSACT_EX_CTL);
     +}
     +
    - static struct args parse_args(int argc, char **argv)
    - {
    - 	struct args args = {
    - 		.iterations = 1,
    ++static struct args parse_args(int argc, char **argv)
    ++{
    ++	struct args args = {
     +		.max_retries = 20,
    -+		.suppress_info = 20,
     +		.diagnose = false
    - 	};
    - 	unsigned int i;
    - 	long arg;
    --	bool no_arg;
    -+	bool no_arg, max_failures = false;
    - 	char *end;
    - 
    - 	for (i = 1; i < argc; i++) {
    -@@ s390x/spec_ex.c: static struct args parse_args(int argc, char **argv)
    - 				report_abort("--iterations needs a positive parameter");
    - 			args.iterations = arg;
    - 			++i;
    -+		} else if (!strcmp("--max-retries", argv[i])) {
    -+			if (no_arg)
    -+				report_abort("--max-retries needs a positive parameter");
    -+			args.max_retries = arg;
    -+			++i;
    -+		} else if (!strcmp("--suppress-info", argv[i])) {
    -+			if (no_arg)
    -+				report_abort("--suppress-info needs a positive parameter");
    -+			args.suppress_info = arg;
    -+			++i;
    -+		} else if (!strcmp("--max-failures", argv[i])) {
    ++	};
    ++	unsigned int i;
    ++	long arg;
    ++	bool no_arg;
    ++	char *end;
    ++	const char *flag;
    ++	uint64_t *argp;
    ++
    ++	for (i = 1; i < argc; i++) {
    ++		no_arg = true;
    ++		if (i < argc - 1) {
    ++			no_arg = *argv[i + 1] == '\0';
    ++			arg = strtol(argv[i + 1], &end, 10);
    ++			no_arg |= *end != '\0';
    ++			no_arg |= arg < 0;
    ++		}
    ++
    ++		flag = "--max-retries";
    ++		argp = &args.max_retries;
    ++		if (!strcmp(flag, argv[i])) {
     +			if (no_arg)
    -+				report_abort("--max-failures needs a positive parameter");
    -+			args.max_failures = arg;
    -+			max_failures = true;
    ++				report_abort("%s needs a positive parameter", flag);
    ++			*argp = arg;
     +			++i;
    -+		} else if (!strcmp("--diagnose", argv[i])) {
    ++			continue;
    ++		}
    ++		if (!strcmp("--diagnose", argv[i])) {
     +			args.diagnose = true;
    -+		} else if (!strcmp("--no-diagnose", argv[i])) {
    ++			continue;
    ++		}
    ++		if (!strcmp("--no-diagnose", argv[i])) {
     +			args.diagnose = false;
    - 		} else {
    - 			report_abort("Unsupported parameter '%s'",
    - 				     argv[i]);
    - 		}
    - 	}
    ++			continue;
    ++		}
    ++		report_abort("Unsupported parameter '%s'",
    ++			     argv[i]);
    ++	}
     +
    -+	if (!max_failures)
    -+		args.max_failures = args.iterations / 1000;
    ++	return args;
    ++}
     +
    - 	return args;
    - }
    + int main(int argc, char **argv)
    + {
    + 	unsigned int i;
      
    ++	struct args args = parse_args(argc, argv);
    ++
    + 	report_prefix_push("specification exception");
    + 	for (i = 0; spec_ex_triggers[i].name; i++) {
    + 		report_prefix_push(spec_ex_triggers[i].name);
     @@ s390x/spec_ex.c: int main(int argc, char **argv)
      	}
      	report_prefix_pop();

base-commit: ca785dae0dd343b1de4b3f5d6c1223d41fbc39e7
-- 
2.33.1

