Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4615A2C0F
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 18:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244755AbiHZQL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 12:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244394AbiHZQLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 12:11:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB86C2E99;
        Fri, 26 Aug 2022 09:11:21 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QFqf5Z038400;
        Fri, 26 Aug 2022 16:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=KvSq3rQ6avUrO8ZWdfgydaN/tv1LIyqjq/WAdVa7cSc=;
 b=TsYwnIS8VEK5HgajmWrS5YB1mymWvpYg4dAvwWi8tzKn+/xkAzgsbEKDll/8pRyjmq3b
 Zj++HWaSV8Qo6G58x4sPyB5gEPJN/BovpvJ7D/Oo8FCfi3tfZ5NQAB0JzB0/zELbmwE6
 ppoG5TNmISeNUHOMkvHAmtRdFDzBdifJZmjVyqqc80JvsFdRUo+yw+6tqcLB0z8wW36Q
 oSpbyTHlhDEDoL74I2naBd2MUtRL8iT5CGZeLxQMq20P0U5XHA1TzBdIW7K58Qugh+fJ
 VSrr9QY5/Xg2N/EfU09xc4VuWUMQTAKL6ghiPue/3gYppv4WA920X2FKGrDFhbLqls5B Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j71718nrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 16:11:20 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27QFu7Vt009270;
        Fri, 26 Aug 2022 16:11:20 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j71718nq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 16:11:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27QFpd5t032245;
        Fri, 26 Aug 2022 16:11:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88yy33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 16:11:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27QGBEdg30933406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 16:11:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A3A14C040;
        Fri, 26 Aug 2022 16:11:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25CC04C046;
        Fri, 26 Aug 2022 16:11:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Aug 2022 16:11:14 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v6 0/2] Add specification exception tests
Date:   Fri, 26 Aug 2022 18:11:10 +0200
Message-Id: <20220826161112.3786131-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W4-BNrVVJIdfwbspgpPADDfQuPxQzVyi
X-Proofpoint-ORIG-GUID: B9dw-MVPqpg4tpSYMkz3_pAPukVGVyYR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_08,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

v5 -> b6
	rebased onto master
	comments and style changes

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
 s390x/spec_ex.c          | 383 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 4 files changed, 393 insertions(+)
 create mode 100644 s390x/spec_ex.c

Range-diff against v5:
1:  fd9780d8 ! 1:  bbfb5d40 s390x: Add specification exception test
    @@ lib/s390x/asm/arch_def.h: struct psw {
     +	uint32_t	addr;
     +};
     +
    - #define AS_PRIM				0
    - #define AS_ACCR				1
    - #define AS_SECN				2
    + struct cpu {
    + 	struct lowcore *lowcore;
    + 	uint64_t *stack;
     
      ## s390x/spec_ex.c (new) ##
     @@
    @@ s390x/spec_ex.c (new)
     + */
     +#include <stdlib.h>
     +#include <libcflat.h>
    ++#include <bitops.h>
     +#include <asm/interrupt.h>
     +
    ++/* toggled to signal occurrence of invalid psw fixup */
     +static bool invalid_psw_expected;
     +static struct psw expected_psw;
     +static struct psw invalid_psw;
    @@ s390x/spec_ex.c (new)
     + * find the instruction following the faulting one from the old PSW.
     + * The PSW to return to is set by load_psw.
     + */
    -+static void fixup_invalid_psw(void)
    ++static void fixup_invalid_psw(struct stack_frame_int *stack)
     +{
     +	/* signal occurrence of invalid psw fixup */
     +	invalid_psw_expected = false;
    @@ s390x/spec_ex.c (new)
     +{
     +	uint64_t scratch;
     +
    ++	/*
    ++	 * The fixup psw is current psw with the instruction address replaced by
    ++	 * the address of the nop following the instruction loading the new psw.
    ++	 */
     +	fixup_psw.mask = extract_psw_mask();
     +	asm volatile ( "larl	%[scratch],0f\n"
    -+		"	stg	%[scratch],%[addr]\n"
    ++		"	stg	%[scratch],%[fixup_addr]\n"
     +		"	lpswe	%[psw]\n"
     +		"0:	nop\n"
    -+		: [scratch] "=&d"(scratch),
    -+		  [addr] "=&T"(fixup_psw.addr)
    -+		: [psw] "Q"(psw)
    ++		: [scratch] "=&d" (scratch),
    ++		  [fixup_addr] "=&T" (fixup_psw.addr)
    ++		: [psw] "Q" (psw)
     +		: "cc", "memory"
     +	);
     +}
    @@ s390x/spec_ex.c (new)
     +
     +	fixup_psw.mask = extract_psw_mask();
     +	asm volatile ( "larl	%[scratch],0f\n"
    -+		"	stg	%[scratch],%[addr]\n"
    ++		"	stg	%[scratch],%[fixup_addr]\n"
     +		"	lpsw	%[psw]\n"
     +		"0:	nop\n"
    -+		: [scratch] "=&d"(scratch),
    -+		  [addr] "=&T"(fixup_psw.addr)
    -+		: [psw] "Q"(psw)
    ++		: [scratch] "=&d" (scratch),
    ++		  [fixup_addr] "=&T" (fixup_psw.addr)
    ++		: [psw] "Q" (psw)
     +		: "cc", "memory"
     +	);
     +}
    @@ s390x/spec_ex.c (new)
     +
     +static int check_invalid_psw(void)
     +{
    -+	/* toggled to signal occurrence of invalid psw fixup */
     +	if (!invalid_psw_expected) {
     +		if (expected_psw.mask == invalid_psw.mask &&
     +		    expected_psw.addr == invalid_psw.addr)
    @@ s390x/spec_ex.c (new)
     +	return 1;
     +}
     +
    ++/* For normal PSWs bit 12 has to be 0 to be a valid PSW*/
     +static int psw_bit_12_is_1(void)
     +{
    -+	struct psw invalid = { .mask = 0x0008000000000000, .addr = 0x00000000deadbeee};
    ++	struct psw invalid = {
    ++		.mask = BIT(63 - 12),
    ++		.addr = 0x00000000deadbeee
    ++	};
     +
     +	expect_invalid_psw(invalid);
     +	load_psw(invalid);
     +	return check_invalid_psw();
     +}
     +
    ++/* A short PSW needs to have bit 12 set to be valid. */
     +static int short_psw_bit_12_is_0(void)
     +{
    -+	struct short_psw short_invalid = { .mask = 0x00000000, .addr = 0xdeadbeee};
    ++	struct short_psw short_invalid = {
    ++		.mask = 0x0,
    ++		.addr = 0xdeadbeee
    ++	};
     +
     +	/*
     +	 * lpsw may optionally check bit 12 before loading the new psw
    @@ s390x/spec_ex.c (new)
     +	uint32_t words[5] __attribute__((aligned(16)));
     +	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
     +
    ++	/* LOAD PAIR FROM QUADWORD (LPQ) requires quadword alignment */
     +	asm volatile ("lpq %%r6,%[bad]"
    -+		      : : [bad] "T"(*bad_aligned)
    ++		      : : [bad] "T" (*bad_aligned)
     +		      : "%r6", "%r7"
     +	);
     +	return 0;
    @@ s390x/spec_ex.c (new)
     +	uint64_t quad[2] __attribute__((aligned(16))) = {0};
     +
     +	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" /* lpq %%r7,%[quad] */
    -+		      : : [quad] "T"(quad)
    ++		      : : [quad] "T" (quad)
     +		      : "%r7", "%r8"
     +	);
     +	return 0;
    @@ s390x/spec_ex.c (new)
     +struct spec_ex_trigger {
     +	const char *name;
     +	int (*func)(void);
    -+	void (*fixup)(void);
    ++	void (*fixup)(struct stack_frame_int *stack);
     +};
     +
     +/* List of all tests to execute */
2:  c14092a3 ! 2:  0f19be7d s390x: Test specification exceptions during transaction
    @@ Commit message
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
     
      ## lib/s390x/asm/arch_def.h ##
    -@@ lib/s390x/asm/arch_def.h: struct short_psw {
    +@@ lib/s390x/asm/arch_def.h: struct cpu {
      #define PSW_MASK_BA			0x0000000080000000UL
      #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
      
    @@ s390x/spec_ex.c
      #include <stdlib.h>
     +#include <htmintrin.h>
      #include <libcflat.h>
    + #include <bitops.h>
     +#include <asm/barrier.h>
      #include <asm/interrupt.h>
     +#include <asm/facility.h>
      
    + /* toggled to signal occurrence of invalid psw fixup */
      static bool invalid_psw_expected;
    - static struct psw expected_psw;
     @@ s390x/spec_ex.c: static int not_even(void)
      /*
       * Harness for specification exception testing.
    @@ s390x/spec_ex.c: static int not_even(void)
      	const char *name;
      	int (*func)(void);
     +	bool transactable;
    - 	void (*fixup)(void);
    + 	void (*fixup)(struct stack_frame_int *stack);
      };
      
      /* List of all tests to execute */

base-commit: 7362976db651a2142ec64b5cea2029ab77a5b157
-- 
2.36.1

