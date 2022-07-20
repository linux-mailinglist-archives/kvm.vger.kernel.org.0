Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7872157B864
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 16:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiGTOZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 10:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiGTOZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 10:25:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CD3BEE;
        Wed, 20 Jul 2022 07:25:41 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KEGjDe003553;
        Wed, 20 Jul 2022 14:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8lSB9mafGrjcKZov6yb9ftoj03r2mOT0OLi8qPwQRFg=;
 b=bg4rxpVcn2kykTzqOW4WyOCkUshY8u7lXJNecHRkahisEKa9hpQQtNqpxswlJnOk/LeP
 lc6qPlM1QgebyXgbAvNbOay3tTlJVb1mTJRYLaUuMnwGkCxqtnvRv8rEGpjsXJi8qONa
 41UMBafY09VcyGA+rfOKtyauDYHuHsAdL9LBgABrN9/yGqVuTPt3hDghgYRfxzT1mv8t
 FR09SF//va2DpQAGWGdQMljwakOXgA6s8+1dH2tAyTy0O7aivtyrOJDo38gU0VOBI79X
 uCajphcfCqDAmWO8LPo0BRLJ+L5a1DuEGsO5f4wPegrVph37xuXaqZrLzwrVkioVzpwC +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hekat89dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 14:25:34 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26KEIjrU013767;
        Wed, 20 Jul 2022 14:25:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hekat89cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 14:25:33 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26KEKmDt004755;
        Wed, 20 Jul 2022 14:25:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3hbmy8wtd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 14:25:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26KEPSiO18874746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 14:25:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B35611C052;
        Wed, 20 Jul 2022 14:25:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF37211C04C;
        Wed, 20 Jul 2022 14:25:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jul 2022 14:25:27 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, qemu-s390x@nongnu.org
Subject: [kvm-unit-tests PATCH v5 0/2] Add specification exception tests
Date:   Wed, 20 Jul 2022 16:25:24 +0200
Message-Id: <20220720142526.29634-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Rai7SP80XDD8cFTTqcsD4jmDEFTMlpRl
X-Proofpoint-GUID: En4q4iHDiXdhKTEbA5SaKt1LEI65tuD8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_08,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207200056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that specification exceptions cause the correct interruption code
during both normal and transactional execution.

TCG fails the tests setting an invalid PSW bit.
I had a look at how best to fix it, but where best to check for early
PSW exceptions was not immediately clear to me. Ideas welcome.

v4 -> v5
	add lpsw with invalid bit 12 test
		TCG fails as with lpswe but must also invert bit 12
	update copyright statement
	add comments
	cleanups and style fixes

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
 lib/s390x/asm/arch_def.h |   6 +
 s390x/spec_ex.c          | 369 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 4 files changed, 379 insertions(+)
 create mode 100644 s390x/spec_ex.c

Range-diff against v4:
1:  a242e84b ! 1:  fd9780d8 s390x: Add specification exception test
    @@ s390x/Makefile: tests += $(TEST_DIR)/uv-host.elf
      tests += $(TEST_DIR)/spec_ex-sie.elf
     +tests += $(TEST_DIR)/spec_ex.elf
      tests += $(TEST_DIR)/firq.elf
    + tests += $(TEST_DIR)/epsw.elf
    + tests += $(TEST_DIR)/adtl-status.elf
    +
    + ## lib/s390x/asm/arch_def.h ##
    +@@ lib/s390x/asm/arch_def.h: struct psw {
    + 	uint64_t	addr;
    + };
      
    - tests_binary = $(patsubst %.elf,%.bin,$(tests))
    ++struct short_psw {
    ++	uint32_t	mask;
    ++	uint32_t	addr;
    ++};
    ++
    + #define AS_PRIM				0
    + #define AS_ACCR				1
    + #define AS_SECN				2
     
      ## s390x/spec_ex.c (new) ##
     @@
     +// SPDX-License-Identifier: GPL-2.0-only
     +/*
    -+ * Copyright IBM Corp. 2021
    ++ * Copyright IBM Corp. 2021, 2022
     + *
     + * Specification exception test.
     + * Tests that specification exceptions occur when expected.
    @@ s390x/spec_ex.c (new)
     +#include <libcflat.h>
     +#include <asm/interrupt.h>
     +
    -+static struct lowcore *lc = (struct lowcore *) 0;
    -+
     +static bool invalid_psw_expected;
     +static struct psw expected_psw;
     +static struct psw invalid_psw;
     +static struct psw fixup_psw;
     +
    -+/* The standard program exception handler cannot deal with invalid old PSWs,
    ++/*
    ++ * The standard program exception handler cannot deal with invalid old PSWs,
     + * especially not invalid instruction addresses, as in that case one cannot
     + * find the instruction following the faulting one from the old PSW.
     + * The PSW to return to is set by load_psw.
     + */
     +static void fixup_invalid_psw(void)
     +{
    -+	// signal occurrence of invalid psw fixup
    ++	/* signal occurrence of invalid psw fixup */
     +	invalid_psw_expected = false;
    -+	invalid_psw = lc->pgm_old_psw;
    -+	lc->pgm_old_psw = fixup_psw;
    ++	invalid_psw = lowcore.pgm_old_psw;
    ++	lowcore.pgm_old_psw = fixup_psw;
     +}
     +
    -+/* Load possibly invalid psw, but setup fixup_psw before,
    -+ * so that *fixup_invalid_psw() can bring us back onto the right track.
    ++/*
    ++ * Load possibly invalid psw, but setup fixup_psw before,
    ++ * so that fixup_invalid_psw() can bring us back onto the right track.
     + * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
     + */
     +static void load_psw(struct psw psw)
    @@ s390x/spec_ex.c (new)
     +	uint64_t scratch;
     +
     +	fixup_psw.mask = extract_psw_mask();
    -+	asm volatile ( "larl	%[scratch],nop%=\n"
    ++	asm volatile ( "larl	%[scratch],0f\n"
     +		"	stg	%[scratch],%[addr]\n"
     +		"	lpswe	%[psw]\n"
    -+		"nop%=:	nop\n"
    -+		: [scratch] "=&r"(scratch),
    ++		"0:	nop\n"
    ++		: [scratch] "=&d"(scratch),
    ++		  [addr] "=&T"(fixup_psw.addr)
    ++		: [psw] "Q"(psw)
    ++		: "cc", "memory"
    ++	);
    ++}
    ++
    ++static void load_short_psw(struct short_psw psw)
    ++{
    ++	uint64_t scratch;
    ++
    ++	fixup_psw.mask = extract_psw_mask();
    ++	asm volatile ( "larl	%[scratch],0f\n"
    ++		"	stg	%[scratch],%[addr]\n"
    ++		"	lpsw	%[psw]\n"
    ++		"0:	nop\n"
    ++		: [scratch] "=&d"(scratch),
     +		  [addr] "=&T"(fixup_psw.addr)
     +		: [psw] "Q"(psw)
     +		: "cc", "memory"
    @@ s390x/spec_ex.c (new)
     +
     +static int check_invalid_psw(void)
     +{
    -+	// toggled to signal occurrence of invalid psw fixup
    ++	/* toggled to signal occurrence of invalid psw fixup */
     +	if (!invalid_psw_expected) {
     +		if (expected_psw.mask == invalid_psw.mask &&
     +		    expected_psw.addr == invalid_psw.addr)
    @@ s390x/spec_ex.c (new)
     +	struct psw invalid = { .mask = 0x0008000000000000, .addr = 0x00000000deadbeee};
     +
     +	expect_invalid_psw(invalid);
    -+	load_psw(expected_psw);
    ++	load_psw(invalid);
     +	return check_invalid_psw();
     +}
     +
    ++static int short_psw_bit_12_is_0(void)
    ++{
    ++	struct short_psw short_invalid = { .mask = 0x00000000, .addr = 0xdeadbeee};
    ++
    ++	/*
    ++	 * lpsw may optionally check bit 12 before loading the new psw
    ++	 * -> cannot check the expected invalid psw like with lpswe
    ++	 */
    ++	load_short_psw(short_invalid);
    ++	return 0;
    ++}
    ++
     +static int bad_alignment(void)
     +{
     +	uint32_t words[5] __attribute__((aligned(16)));
    @@ s390x/spec_ex.c (new)
     +{
     +	uint64_t quad[2] __attribute__((aligned(16))) = {0};
     +
    -+	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" //lpq %%r7,%[quad]
    ++	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" /* lpq %%r7,%[quad] */
     +		      : : [quad] "T"(quad)
     +		      : "%r7", "%r8"
     +	);
    @@ s390x/spec_ex.c (new)
     +/* List of all tests to execute */
     +static const struct spec_ex_trigger spec_ex_triggers[] = {
     +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
    ++	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, &fixup_invalid_psw },
     +	{ "bad_alignment", &bad_alignment, NULL },
     +	{ "not_even", &not_even, NULL },
     +	{ NULL, NULL, NULL },
    @@ s390x/spec_ex.c (new)
     +
     +static void test_spec_ex(const struct spec_ex_trigger *trigger)
     +{
    -+	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
    -+	uint16_t pgm;
     +	int rc;
     +
     +	expect_pgm_int();
     +	register_pgm_cleanup_func(trigger->fixup);
     +	rc = trigger->func();
     +	register_pgm_cleanup_func(NULL);
    ++	/* test failed, nothing to be done, reporting responsibility of trigger */
     +	if (rc)
     +		return;
    -+	pgm = clear_pgm_int();
    -+	report(pgm == expected_pgm, "Program interrupt: expected(%d) == received(%d)",
    -+	       expected_pgm, pgm);
    ++	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
     +}
     +
     +int main(int argc, char **argv)
    @@ s390x/unittests.cfg: file = mvpg-sie.elf
     +[spec_ex]
     +file = spec_ex.elf
     +
    - [firq-linear-cpu-ids]
    + [firq-linear-cpu-ids-kvm]
      file = firq.elf
      timeout = 20
2:  16ce8bb0 ! 2:  c14092a3 s390x: Test specification exceptions during transaction
    @@ Commit message
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
     
      ## lib/s390x/asm/arch_def.h ##
    -@@ lib/s390x/asm/arch_def.h: struct psw {
    +@@ lib/s390x/asm/arch_def.h: struct short_psw {
      #define PSW_MASK_BA			0x0000000080000000UL
      #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
      
    -+#define CTL0_TRANSACT_EX_CTL		(63 -  8)
    - #define CTL0_LOW_ADDR_PROT		(63 - 35)
    - #define CTL0_EDAT			(63 - 40)
    - #define CTL0_IEP			(63 - 43)
    ++#define CTL0_TRANSACT_EX_CTL			(63 -  8)
    + #define CTL0_LOW_ADDR_PROT			(63 - 35)
    + #define CTL0_EDAT				(63 - 40)
    + #define CTL0_FETCH_PROTECTION_OVERRIDE		(63 - 38)
     
      ## s390x/spec_ex.c ##
     @@
    @@ s390x/spec_ex.c
      #include <asm/interrupt.h>
     +#include <asm/facility.h>
      
    - static struct lowcore *lc = (struct lowcore *) 0;
    - 
    + static bool invalid_psw_expected;
    + static struct psw expected_psw;
     @@ s390x/spec_ex.c: static int not_even(void)
      /*
       * Harness for specification exception testing.
    @@ s390x/spec_ex.c: static int not_even(void)
      /* List of all tests to execute */
      static const struct spec_ex_trigger spec_ex_triggers[] = {
     -	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
    +-	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, &fixup_invalid_psw },
     -	{ "bad_alignment", &bad_alignment, NULL },
     -	{ "not_even", &not_even, NULL },
     -	{ NULL, NULL, NULL },
     +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
    ++	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
     +	{ "bad_alignment", &bad_alignment, true, NULL },
     +	{ "not_even", &not_even, true, NULL },
     +	{ NULL, NULL, false, NULL },
    @@ s390x/spec_ex.c: static int not_even(void)
      
      static void test_spec_ex(const struct spec_ex_trigger *trigger)
     @@ s390x/spec_ex.c: static void test_spec_ex(const struct spec_ex_trigger *trigger)
    - 	       expected_pgm, pgm);
    + 	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
      }
      
     +#define TRANSACTION_COMPLETED 4
     +#define TRANSACTION_MAX_RETRIES 5
     +
    -+/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
    ++/*
    ++ * NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
     + * being NULL to keep things simple
     + */
     +static int __attribute__((nonnull))
    @@ s390x/spec_ex.c: static void test_spec_ex(const struct spec_ex_trigger *trigger)
     +	int cc;
     +
     +	cc = __builtin_tbegin(diagnose);
    ++	/*
    ++	 * Everything between tbegin and tend is part of the transaction,
    ++	 * which either completes in its entirety or does not have any effect.
    ++	 * If the transaction fails, execution is reset to this point with another
    ++	 * condition code indicating why the transaction failed.
    ++	 */
     +	if (cc == _HTM_TBEGIN_STARTED) {
    -+		/* return code is meaningless: transaction needs to complete
    ++		/*
    ++		 * return code is meaningless: transaction needs to complete
     +		 * in order to return and completion indicates a test failure
     +		 */
     +		trigger();
    @@ s390x/spec_ex.c: static void test_spec_ex(const struct spec_ex_trigger *trigger)
     +		trans_result = with_transaction(trigger->func, tdb);
     +		if (trans_result == _HTM_TBEGIN_TRANSIENT) {
     +			mb();
    -+			pgm = lc->pgm_int_code;
    -+			if (pgm == 0)
    -+				continue;
    -+			else if (pgm == expected_pgm)
    ++			pgm = lowcore.pgm_int_code;
    ++			if (pgm == expected_pgm)
     +				return 0;
    ++			else if (pgm == 0)
    ++				/*
    ++				 * Transaction failed for unknown reason but not because
    ++				 * of an unexpected program exception. Give it another
    ++				 * go so that hopefully it reaches the triggering instruction.
    ++				 */
    ++				continue;
     +		}
     +		return trans_result;
     +	}
    @@ s390x/spec_ex.c: static void test_spec_ex(const struct spec_ex_trigger *trigger)
     +		report_fail("Transaction completed without exception");
     +		break;
     +	case TRANSACTION_MAX_RETRIES:
    -+		report_info("Retried transaction %lu times without exception",
    ++		report_skip("Transaction retried %lu times with transient failures, giving up",
     +			    args->max_retries);
     +		break;
     +	default:
    -+		report_fail("Invalid return transaction result");
    ++		report_fail("Invalid transaction result");
     +		break;
     +	}
     +
     +	ctl_clear_bit(0, CTL0_TRANSACT_EX_CTL);
     +}
     +
    ++static bool parse_unsigned(const char *arg, unsigned int *out)
    ++{
    ++	char *end;
    ++	long num;
    ++
    ++	if (arg[0] == '\0')
    ++		return false;
    ++	num = strtol(arg, &end, 10);
    ++	if (end[0] != '\0' || num < 0)
    ++		return false;
    ++	*out = num;
    ++	return true;
    ++}
    ++
     +static struct args parse_args(int argc, char **argv)
     +{
     +	struct args args = {
     +		.max_retries = 20,
     +		.diagnose = false
     +	};
    -+	unsigned int i;
    -+	long arg;
    -+	bool no_arg;
    -+	char *end;
    ++	unsigned int i, arg;
    ++	bool has_arg;
     +	const char *flag;
    -+	uint64_t *argp;
     +
     +	for (i = 1; i < argc; i++) {
    -+		no_arg = true;
    -+		if (i < argc - 1) {
    -+			no_arg = *argv[i + 1] == '\0';
    -+			arg = strtol(argv[i + 1], &end, 10);
    -+			no_arg |= *end != '\0';
    -+			no_arg |= arg < 0;
    -+		}
    ++		if (i + 1 < argc)
    ++			has_arg = parse_unsigned(argv[i + 1], &arg);
    ++		else
    ++			has_arg = false;
     +
     +		flag = "--max-retries";
    -+		argp = &args.max_retries;
     +		if (!strcmp(flag, argv[i])) {
    -+			if (no_arg)
    ++			if (!has_arg)
     +				report_abort("%s needs a positive parameter", flag);
    -+			*argp = arg;
    ++			args.max_retries = arg;
     +			++i;
     +			continue;
     +		}

base-commit: ca85dda2671e88d34acfbca6de48a9ab32b1810d
-- 
2.36.1

