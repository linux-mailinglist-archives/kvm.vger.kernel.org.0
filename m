Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2957C6D0BCD
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjC3Qud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 12:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjC3Qtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 12:49:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FA5DBE7;
        Thu, 30 Mar 2023 09:48:47 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UG78P5003098;
        Thu, 30 Mar 2023 16:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=q5Q6CryTogyCGCF0LU0RTxLqxkNaxOr+crjtzPe+0vA=;
 b=ehsP44f0JTPtokuNP1jnj1N+DIcONLBVQH/74Ss2A3QRHHAf9xs4/oXYDysRg1EBJAUk
 8hb6zrDzZYiWgCNzxwXIosWOluqkEuFn0rzhyL8wrNqgfOTDzjAT9q1lLrin3R2BELvv
 onVMgwiGC667E2gjiaoOefOAvGYfu1zZLRvxrbyev2zZ0UBiz9QHRuKTMHqg0MbqfVBR
 KBTzOBMK3l44JOlM+asNfnjCP6zl0Mb2aBI1jnQ0uZNyAE4VVERoJZ0pVhh7nruTt/kA
 x82a30gY1yaNux/p5MGPSwmfD3KuhFL84uWTaGmShtO1cj4M9LXHcK//53f9LdYpbWZZ rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmq1pvdeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:26 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UGKDAQ034170;
        Thu, 30 Mar 2023 16:48:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmq1pvde6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UAtC73003455;
        Thu, 30 Mar 2023 16:48:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3phrk6vxuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UGmLVn21496568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 16:48:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02BF62004B;
        Thu, 30 Mar 2023 16:48:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2EF520040;
        Thu, 30 Mar 2023 16:48:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 16:48:20 +0000 (GMT)
Date:   Thu, 30 Mar 2023 18:34:31 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: Add guest 2 AP test
Message-ID: <20230330183431.3003b391@p-imbrenda>
In-Reply-To: <20230330114244.35559-3-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
        <20230330114244.35559-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4YFM0Azq52DCWISVCg_VKCy1wtEbnaVE
X-Proofpoint-ORIG-GUID: zlW4aGyY_OHVZl5O82bVGaTq4eMNXb0L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_09,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300130
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Mar 2023 11:42:41 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Add a test that checks the exceptions for the PQAP, NQAP and DQAP
> adjunct processor (AP) crypto instructions.
> 
> Since triggering the exceptions doesn't require actual AP hardware,
> this test can run without complicated setup.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---

[...]

> +
> +static void test_pgms_pqap(void)
> +{
> +	unsigned long grs[3] = {};
> +	struct pqap_r0 *r0 = (struct pqap_r0 *)grs;
> +	uint8_t *data = alloc_page();
> +	uint16_t pgm;
> +	int fails = 0;
> +	int i;
> +
> +	report_prefix_push("pqap");
> +
> +	/* Wrong FC code */
> +	report_prefix_push("invalid fc");
> +	r0->fc = 42;

maybe make a macro out of it, both to avoid magic numbers and to change
it easily if code 42 will ever become defined in the future.

> +	expect_pgm_int();
> +	pqap(grs);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	memset(grs, 0, sizeof(grs));
> +	report_prefix_pop();
> +
> +	report_prefix_push("invalid gr0 bits");
> +	for (i = 42; i < 6; i++) {

42 is not < 6, this whole thing will be skipped?

> +		expect_pgm_int();
> +		grs[0] = BIT(63 - i);
> +		pqap(grs);
> +		pgm = clear_pgm_int();
> +
> +		if (pgm != PGM_INT_CODE_SPECIFICATION) {
> +			report_fail("fail on bit %d", i);
> +			fails++;
> +		}
> +	}
> +	report(!fails, "All bits tested");
> +	memset(grs, 0, sizeof(grs));
> +	fails = 0;
> +	report_prefix_pop();
> +
> +	report_prefix_push("alignment");
> +	report_prefix_push("fc=4");
> +	r0->fc = PQAP_QUERY_AP_CONF_INFO;
> +	grs[2] = (unsigned long)data;
> +	for (i = 1; i < 8; i++) {
> +		expect_pgm_int();
> +		grs[2]++;
> +		pqap(grs);
> +		pgm = clear_pgm_int();
> +		if (pgm != PGM_INT_CODE_SPECIFICATION) {
> +			report_fail("fail on bit %d", i);
> +			fails++;
> +		}
> +	}
> +	report(!fails, "All bits tested");

you mean "All alignments tested" ?

> +	report_prefix_pop();
> +	report_prefix_push("fc=6");
> +	r0->fc = PQAP_BEST_AP;
> +	grs[2] = (unsigned long)data;
> +	for (i = 1; i < 8; i++) {
> +		expect_pgm_int();
> +		grs[2]++;
> +		pqap(grs);
> +		pgm = clear_pgm_int();
> +		if (pgm != PGM_INT_CODE_SPECIFICATION) {
> +			report_fail("fail on bit %d", i);
> +			fails++;
> +		}
> +	}
> +	report(!fails, "All bits tested");

same here?

> +	report_prefix_pop();
> +	report_prefix_pop();
> +
> +	free_page(data);
> +	report_prefix_pop();
> +}
> +
> +static void test_pgms_nqap(void)
> +{
> +	uint8_t gr0_zeroes_bits[] = {
> +		32, 34, 35, 40
> +	};
> +	uint64_t gr0;
> +	bool fail;
> +	int i;
> +
> +	report_prefix_push("nqap");
> +
> +	/* Registers 0 and 1 are always used, the others are
> even/odd pairs */
> +	report_prefix_push("spec");
> +	report_prefix_push("r1");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ad0000,3,6\n"
> +		: : : "cc", "memory", "0", "1", "2", "3");

I would say 
"0", "1", "2", "3", "4", "6", "7"

since there are two ways of doing it wrong when it comes to even-odd
register pairs (r and r+1, r&~1 and r&~1+1)

> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("r2");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ad0000,2,7\n"
> +		: : : "cc", "memory", "0", "1", "3", "4");

same here (with the right numbers of course)

and I would even add a test with both odd registers

> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("len==0");
> +	expect_pgm_int();
> +	asm volatile (
> +		"xgr	0,0\n"
> +		"xgr	5,5\n"
> +		".insn	rre,0xb2ad0000,2,4\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "5");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("len>12288");
> +	expect_pgm_int();
> +	asm volatile (
> +		"xgr	5,5\n"
> +		"lghi	5, 12289\n"

I would also check setting all the bits above bit 13 (i.e. if an
implementation wrongly checks only the lower 16 or 32 bits of the value

> +		".insn	rre,0xb2ad0000,2,4\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "5");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("gr0_zero_bits");
> +	fail = false;
> +	for (i = 0; i < 4; i++) {

i < ARRAY_SIZE(gr0_zeroes_bits) might be more robust and future-proof

> +		expect_pgm_int();
> +		gr0 = BIT_ULL(63 - gr0_zeroes_bits[i]);
> +		asm volatile (
> +			"xgr	5,5\n"
> +			"lghi	5, 128\n"
> +			"lg	0, 0(%[val])\n"
> +			".insn	rre,0xb2ad0000,2,4\n"
> +			: : [val] "a" (&gr0)
> +			: "cc", "memory", "0", "1", "2", "3", "4", "5");
> +		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
> +			report_fail("setting gr0 bit %d did not result in a spec exception",
> +				    gr0_zeroes_bits[i]);
> +			fail = true;
> +		}
> +	}
> +	report(!fail, "set bit specification pgms");
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
> +static void test_pgms_dqap(void)
> +{
> +	uint8_t gr0_zeroes_bits[] = {
> +		33, 34, 35, 40, 41
> +	};
> +	uint64_t gr0;
> +	bool fail;
> +	int i;
> +
> +	report_prefix_push("dqap");
> +
> +	/* Registers 0 and 1 are always used, the others are even/odd pairs */
> +	report_prefix_push("spec");
> +	report_prefix_push("r1");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ae0000,3,6\n"
> +		: : : "cc", "memory", "0", "1", "2", "3");

same concern here with the registers like in the previous test

> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("r2");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ae0000,2,7\n"
> +		: : : "cc", "memory", "0", "1", "3", "4");

as above, plus add a test for both odd

> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("len==0");
> +	expect_pgm_int();
> +	asm volatile (
> +		"xgr	0,0\n"
> +		"xgr	5,5\n"
> +		".insn	rre,0xb2ae0000,2,4\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "5");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("len>12288");
> +	expect_pgm_int();
> +	asm volatile (
> +		"xgr	5,5\n"
> +		"lghi	5, 12289\n"

like the previous test, also test the high bits

> +		".insn	rre,0xb2ae0000,2,4\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "5");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("gr0_zero_bits");
> +	fail = false;
> +	for (i = 0; i < 5; i++) {

same concern here with ARRAY_SIZE

> +		expect_pgm_int();
> +		gr0 = BIT_ULL(63 - gr0_zeroes_bits[i]);
> +		asm volatile (
> +			"xgr	5,5\n"
> +			"lghi	5, 128\n"
> +			"lg	0, 0(%[val])\n"
> +			".insn	rre,0xb2ae0000,2,4\n"
> +			: : [val] "a" (&gr0)
> +			: "cc", "memory", "0", "1", "2", "3", "4", "5");
> +		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
> +			report_info("setting gr0 bit %d did not result in a spec exception",
> +				    gr0_zeroes_bits[i]);
> +			fail = true;
> +		}
> +	}
> +	report(!fail, "set bit specification pgms");
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
> +static void test_priv(void)
> +{
> +	struct ap_config_info info = {};
> +
> +	report_prefix_push("privileged");
> +
> +	report_prefix_push("pqap");
> +	expect_pgm_int();
> +	enter_pstate();
> +	ap_pqap_qci(&info);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	/*
> +	 * Enqueue and dequeue take too many registers so a simple
> +	 * inline assembly makes more sense than using the library
> +	 * functions.
> +	 */
> +	report_prefix_push("nqap");
> +	expect_pgm_int();
> +	enter_pstate();
> +	asm volatile (
> +		".insn	rre,0xb2ad0000,0,2\n"
> +		: : : "cc", "memory", "0", "1", "2", "3");
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("dqap");
> +	expect_pgm_int();
> +	enter_pstate();
> +	asm volatile (
> +		".insn	rre,0xb2ae0000,0,2\n"
> +		: : : "cc", "memory", "0", "1", "2", "3");
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("ap");
> +	if (!ap_check()) {
> +		report_skip("AP instructions not available");
> +		goto done;
> +	}
> +
> +	test_priv();
> +	test_pgms_pqap();
> +	test_pgms_nqap();
> +	test_pgms_dqap();
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index d97eb5e9..9b7c65c8 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -215,3 +215,7 @@ file = migration-skey.elf
>  smp = 2
>  groups = migration
>  extra_params = -append '--parallel'
> +
> +[ap]
> +file = ap.elf
> +

