Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610E65EE67F
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 22:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiI1URV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 16:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiI1URT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 16:17:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9466C115;
        Wed, 28 Sep 2022 13:17:18 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SIi3cp020618;
        Wed, 28 Sep 2022 20:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=pG1ghc692U9Q8xE03Gx97GPYR3yPEjzveHJEZlWmu8c=;
 b=SNl129ihOhzZ9CZQ5KduoOzRfifavftOyCZcK3TXzcp/zxeio9VKQ9DV4UpzHLTIfKbe
 CG25oNIavUOH1ZIQg9LAi7qLZtLiN4YQ1UnPXe01xNirCr4dH8UYund04klLbpY88i0R
 WYzCK7B5HA8M1hSRZIZ8l+ZWgHA+aSQWfwcTpeRXWcTKX6VNXh42KuFuCRWSluthM4zb
 HXfgzwdYVWKxWGg4KXgMO9SvaqlxsDf32JsM/iUrj0jN4HeO/foWR0ZWzGZI0E0FIab9
 NeRSRSDLUf5sOqTH1Fhp04BPa2GOGNZU0EhLEVfgHcDYRobxffVo41AShbSGWX42rV4v ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvq2nmq1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 20:17:17 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28SJR79U009946;
        Wed, 28 Sep 2022 20:17:17 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvq2nmq11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 20:17:17 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28SK6u1V020292;
        Wed, 28 Sep 2022 20:17:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3jssh948gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 20:17:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28SKHCJE5309130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 20:17:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 572F0A404D;
        Wed, 28 Sep 2022 20:17:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1669AA4040;
        Wed, 28 Sep 2022 20:17:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 20:17:12 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 0/2] Add specification exception tests
Date:   Wed, 28 Sep 2022 22:17:08 +0200
Message-Id: <20220928201710.3185449-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3fTC2ayBeMBjy7yGgkLaotTBQuwcemhJ
X-Proofpoint-GUID: I3povTG3MmhWHn1JB414HQwWAvw4yyDc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_09,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280120
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

v6 -> v7
	assert that we're expecting the invalid PSW we're seeing
	rebased onto master
	picked up tags (thanks Nico & Janosch)
	comments and style changes

v5 -> v6
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
 s390x/spec_ex.c          | 392 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 4 files changed, 402 insertions(+)
 create mode 100644 s390x/spec_ex.c

Range-diff against v6:
1:  bbfb5d40 ! 1:  a239437a s390x: Add specification exception test
    @@ Commit message
         Generate specification exceptions and check that they occur.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## s390x/Makefile ##
     @@ s390x/Makefile: tests += $(TEST_DIR)/uv-host.elf
    @@ s390x/spec_ex.c (new)
     + */
     +static void fixup_invalid_psw(struct stack_frame_int *stack)
     +{
    ++	assert_msg(invalid_psw_expected,
    ++		   "Unexpected invalid PSW during program interrupt fixup: %#lx %#lx",
    ++		   lowcore.pgm_old_psw.mask, lowcore.pgm_old_psw.addr);
     +	/* signal occurrence of invalid psw fixup */
     +	invalid_psw_expected = false;
     +	invalid_psw = lowcore.pgm_old_psw;
    @@ s390x/spec_ex.c (new)
     +	uint64_t scratch;
     +
     +	/*
    -+	 * The fixup psw is current psw with the instruction address replaced by
    -+	 * the address of the nop following the instruction loading the new psw.
    ++	 * The fixup psw is the current psw with the instruction address replaced
    ++	 * by the address of the nop following the instruction loading the new psw.
     +	 */
     +	fixup_psw.mask = extract_psw_mask();
     +	asm volatile ( "larl	%[scratch],0f\n"
    @@ s390x/spec_ex.c (new)
     +
     +static int check_invalid_psw(void)
     +{
    ++	/* Since the fixup sets this to false we check for false here. */
     +	if (!invalid_psw_expected) {
     +		if (expected_psw.mask == invalid_psw.mask &&
     +		    expected_psw.addr == invalid_psw.addr)
    @@ s390x/spec_ex.c (new)
     +/* A short PSW needs to have bit 12 set to be valid. */
     +static int short_psw_bit_12_is_0(void)
     +{
    ++	struct psw invalid = {
    ++		.mask = BIT(63 - 12),
    ++		.addr = 0x00000000deadbeee
    ++	};
     +	struct short_psw short_invalid = {
     +		.mask = 0x0,
     +		.addr = 0xdeadbeee
     +	};
     +
    ++	expect_invalid_psw(invalid);
    ++	load_short_psw(short_invalid);
     +	/*
     +	 * lpsw may optionally check bit 12 before loading the new psw
     +	 * -> cannot check the expected invalid psw like with lpswe
     +	 */
    -+	load_short_psw(short_invalid);
     +	return 0;
     +}
     +
2:  0f19be7d ! 2:  697409f7 s390x: Test specification exceptions during transaction
    @@ Commit message
         Check that we see the expected code for (some) specification exceptions.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
    +    Acked-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## lib/s390x/asm/arch_def.h ##
     @@ lib/s390x/asm/arch_def.h: struct cpu {
    @@ s390x/spec_ex.c: static int not_even(void)
      /*
       * Harness for specification exception testing.
       * func only triggers exception, reporting is taken care of automatically.
    -+ * If a trigger is transactable it will also  be executed during a transaction.
    ++ * If a trigger is transactable it will also be executed during a transaction.
       */
      struct spec_ex_trigger {
      	const char *name;
    @@ s390x/spec_ex.c: static void test_spec_ex(const struct spec_ex_trigger *trigger)
     +#define TRANSACTION_MAX_RETRIES 5
     +
     +/*
    -+ * NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
    -+ * being NULL to keep things simple
    ++ * NULL must not be passed to __builtin_tbegin via variable, only constant,
    ++ * forbid diagnose from being NULL at all to keep things simple
     + */
     +static int __attribute__((nonnull))
     +with_transaction(int (*trigger)(void), struct __htm_tdb *diagnose)
    @@ s390x/spec_ex.c: static void test_spec_ex(const struct spec_ex_trigger *trigger)
     +
     +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
     +{
    -+	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
    -+				      | PGM_INT_CODE_TX_ABORTED_EVENT;
    ++	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION |
    ++				      PGM_INT_CODE_TX_ABORTED_EVENT;
     +	union {
     +		struct __htm_tdb tdb;
     +		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];

base-commit: d8a4f9e5e8d69d4ef257b40d6cd666bd2f63494e
-- 
2.36.1

