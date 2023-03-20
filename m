Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8446C11DB
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjCTM0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCTM0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:26:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FA719AF;
        Mon, 20 Mar 2023 05:26:02 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KC3HJv020858;
        Mon, 20 Mar 2023 12:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ZIO9DGTOSBc/GN03K+rveenQjA41WnQFQ0a8x9lM2Xo=;
 b=AmncXFCrc0647JqSlfOv99Enay1BMoOpUlnOOoRWuZOuar90Zo7fGfluE3ChjmxCHXOd
 r405jem7fPIM272WzLafCrvcHgqJZBo7JvKapcDtH8URxtug9069BAvGf4yHc5KI/gmN
 iUzyItEY9FJ3R0H1hlVZs66RmIedBT1M+SUS6w4iTV7y6fBFvzpAeiZZses+ONQUwmzD
 XZEmiJSJnoyrOXpQeHN46+RugHMLQpWSJejXC6i/qY034JCoVYC2g5BPpy9W9gvmrDd5
 Y4xymFPgIAqLH9kEVE8OJeynwggXm7ux0UeXI+YyCc2OBPzknF48OP40trEPmFIh5qXH Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdq6kxf3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:26:02 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32KC3LnR021657;
        Mon, 20 Mar 2023 12:26:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdq6kxf35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:26:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32K4Kd8T018610;
        Mon, 20 Mar 2023 12:25:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6b7fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:25:59 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32KCPtUf60227916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 12:25:55 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC21620043;
        Mon, 20 Mar 2023 12:25:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9221520040;
        Mon, 20 Mar 2023 12:25:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 20 Mar 2023 12:25:55 +0000 (GMT)
Date:   Mon, 20 Mar 2023 13:25:54 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v6] s390x: Add tests for execute-type
 instructions
Message-ID: <20230320132554.01c2bf1e@p-imbrenda>
In-Reply-To: <20230317112339.774659-1-nsg@linux.ibm.com>
References: <20230317112339.774659-1-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TUaT-sOanjxiYbMEXs9pPyYsTMMjBXaC
X-Proofpoint-ORIG-GUID: bkz2tLJnY2fXpjAv2IToWgreluiICgW6
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_08,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Mar 2023 12:23:39 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Test the instruction address used by targets of an execute instruction.
> When the target instruction calculates a relative address, the result is
> relative to the target instruction, not the execute instruction.
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
> 
> 
> v5 -> v6:
>  * fix section for exrl targets (thanks Claudio)
>  * add comments (thanks Claudio)
> 
> v4 -> v5:
>  * word align the execute-type instruction, preventing a specification
>    exception if the address calculation is wrong, since LLGFRL requires
>    word alignment
>  * change wording of comment
> 
> v3 -> v4:
>  * fix nits (thanks Janosch)
>  * pickup R-b (thanks Janosch)
> 
> v2 -> v3:
>  * add some comments (thanks Janosch)
>  * add two new tests (drop Nico's R-b)
>  * push prefix
> 
> v1 -> v2:
>  * add test to unittests.cfg and .gitlab-ci.yml
>  * pick up R-b (thanks Nico)
> 
> 
> See https://patchew.org/QEMU/20230316210751.302423-1-iii@linux.ibm.com/
> for TCG fixes.
> 
> 
> Range-diff against v5:
> 1:  57f8f256 ! 1:  3893f723 s390x: Add tests for execute-type instructions
>     @@ s390x/ex.c (new)
>      +#include <libcflat.h>
>      +
>      +/*
>     ++ * Accesses to the operand of execute-type instructions are instruction fetches.
>     ++ * Minimum alignment is two, since the relative offset is specified by number of halfwords.
>     ++ */
>     ++asm (  ".pushsection .text.exrl_targets,\"x\"\n"
>     ++"	.balign	2\n"
>     ++"	.popsection\n"
>     ++);
>     ++
>     ++/*
>      + * BRANCH AND SAVE, register register variant.
>      + * Saves the next instruction address (address from PSW + length of instruction)
>      + * to the first register. No branch is taken in this test, because 0 is
>     @@ s390x/ex.c (new)
>      +	uint64_t ret_addr, after_ex;
>      +
>      +	report_prefix_push("BASR");
>     -+	asm volatile ( ".pushsection .rodata\n"
>     ++	asm volatile ( ".pushsection .text.exrl_targets\n"
>      +		"0:	basr	%[ret_addr],0\n"
>      +		"	.popsection\n"
>      +
>     @@ s390x/ex.c (new)
>      +	uint64_t after_target, ret_addr, after_ex, branch_addr;
>      +
>      +	report_prefix_push("BRAS");
>     -+	asm volatile ( ".pushsection .text.ex_bras, \"x\"\n"
>     ++	asm volatile ( ".pushsection .text.exrl_targets\n"
>      +		"0:	bras	%[ret_addr],1f\n"
>      +		"	nopr	%%r7\n"
>      +		"1:	larl	%[branch_addr],0\n"
>     @@ s390x/ex.c (new)
>      +		"	larl	%[after_target],1b\n"
>      +		"	larl	%[after_ex],3f\n"
>      +		"2:	exrl	0,0b\n"
>     ++/*
>     ++ * In case the address calculation is correct, we jump by the relative offset 1b-0b from 0b to 1b.
>     ++ * In case the address calculation is relative to the exrl (i.e. a test failure),
>     ++ * put a valid instruction at the same relative offset from the exrl, so the test continues in a
>     ++ * controlled manner.
>     ++ */
>      +		"3:	larl	%[branch_addr],0\n"
>      +		"4:\n"
>      +
>     @@ s390x/ex.c (new)
>      +	uint64_t target, addr;
>      +
>      +	report_prefix_push("LARL");
>     -+	asm volatile ( ".pushsection .rodata\n"
>     ++	asm volatile ( ".pushsection .text.exrl_targets\n"
>      +		"0:	larl	%[addr],0\n"
>      +		"	.popsection\n"
>      +
>     @@ s390x/ex.c (new)
>      +	uint64_t target, value;
>      +
>      +	report_prefix_push("LLGFRL");
>     -+	asm volatile ( ".pushsection .rodata\n"
>     ++	asm volatile ( ".pushsection .text.exrl_targets\n"
>      +		"	.balign	4\n"
>     ++		 //operand of llgfrl must be word aligned
>      +		"0:	llgfrl	%[value],0\n"
>      +		"	.popsection\n"
>      +
>     @@ s390x/ex.c (new)
>      +	uint32_t program_mask, cc, crl_word;
>      +
>      +	report_prefix_push("CRL");
>     -+	asm volatile ( ".pushsection .rodata\n"
>     ++	asm volatile ( ".pushsection .text.exrl_targets\n"
>      +		 //operand of crl must be word aligned
>      +		 "	.balign	4\n"
>      +		"0:	crl	%[crl_word],0\n"
> 
>  s390x/Makefile      |   1 +
>  s390x/ex.c          | 188 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 +
>  .gitlab-ci.yml      |   1 +
>  4 files changed, 193 insertions(+)
>  create mode 100644 s390x/ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 97a61611..6cf8018b 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>  tests += $(TEST_DIR)/panic-loop-pgm.elf
>  tests += $(TEST_DIR)/migration-sck.elf
>  tests += $(TEST_DIR)/exittime.elf
> +tests += $(TEST_DIR)/ex.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/ex.c b/s390x/ex.c
> new file mode 100644
> index 00000000..dbd8030d
> --- /dev/null
> +++ b/s390x/ex.c
> @@ -0,0 +1,188 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2023
> + *
> + * Test EXECUTE (RELATIVE LONG).
> + * These instructions execute a target instruction. The target instruction is formed
> + * by reading an instruction from memory and optionally modifying some of its bits.
> + * The execution of the target instruction is the same as if it was executed
> + * normally as part of the instruction sequence, except for the instruction
> + * address and the instruction-length code.
> + */
> +
> +#include <libcflat.h>
> +
> +/*
> + * Accesses to the operand of execute-type instructions are instruction fetches.
> + * Minimum alignment is two, since the relative offset is specified by number of halfwords.
> + */
> +asm (  ".pushsection .text.exrl_targets,\"x\"\n"
> +"	.balign	2\n"
> +"	.popsection\n"
> +);
> +
> +/*
> + * BRANCH AND SAVE, register register variant.
> + * Saves the next instruction address (address from PSW + length of instruction)
> + * to the first register. No branch is taken in this test, because 0 is
> + * specified as target.
> + * BASR does *not* perform a relative address calculation with an intermediate.
> + */
> +static void test_basr(void)
> +{
> +	uint64_t ret_addr, after_ex;
> +
> +	report_prefix_push("BASR");
> +	asm volatile ( ".pushsection .text.exrl_targets\n"
> +		"0:	basr	%[ret_addr],0\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[after_ex],1f\n"
> +		"	exrl	0,0b\n"
> +		"1:\n"
> +		: [ret_addr] "=d" (ret_addr),
> +		  [after_ex] "=d" (after_ex)
> +	);
> +
> +	report(ret_addr == after_ex, "return address after EX");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * BRANCH RELATIVE AND SAVE.
> + * According to PoP (Branch-Address Generation), the address calculated relative
> + * to the instruction address is relative to BRAS when it is the target of an
> + * execute-type instruction, not relative to the execute-type instruction.
> + */
> +static void test_bras(void)
> +{
> +	uint64_t after_target, ret_addr, after_ex, branch_addr;
> +
> +	report_prefix_push("BRAS");
> +	asm volatile ( ".pushsection .text.exrl_targets\n"
> +		"0:	bras	%[ret_addr],1f\n"
> +		"	nopr	%%r7\n"
> +		"1:	larl	%[branch_addr],0\n"
> +		"	j	4f\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[after_target],1b\n"
> +		"	larl	%[after_ex],3f\n"
> +		"2:	exrl	0,0b\n"
> +/*
> + * In case the address calculation is correct, we jump by the relative offset 1b-0b from 0b to 1b.
> + * In case the address calculation is relative to the exrl (i.e. a test failure),
> + * put a valid instruction at the same relative offset from the exrl, so the test continues in a
> + * controlled manner.
> + */
> +		"3:	larl	%[branch_addr],0\n"
> +		"4:\n"
> +
> +		"	.if (1b - 0b) != (3b - 2b)\n"
> +		"	.error	\"right and wrong target must have same offset\"\n"
> +		"	.endif\n"
> +		: [after_target] "=d" (after_target),
> +		  [ret_addr] "=d" (ret_addr),
> +		  [after_ex] "=d" (after_ex),
> +		  [branch_addr] "=d" (branch_addr)
> +	);
> +
> +	report(after_target == branch_addr, "address calculated relative to BRAS");
> +	report(ret_addr == after_ex, "return address after EX");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * LOAD ADDRESS RELATIVE LONG.
> + * If it is the target of an execute-type instruction, the address is relative
> + * to the LARL.
> + */
> +static void test_larl(void)
> +{
> +	uint64_t target, addr;
> +
> +	report_prefix_push("LARL");
> +	asm volatile ( ".pushsection .text.exrl_targets\n"
> +		"0:	larl	%[addr],0\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[target],0b\n"
> +		"	exrl	0,0b\n"
> +		: [target] "=d" (target),
> +		  [addr] "=d" (addr)
> +	);
> +
> +	report(target == addr, "address calculated relative to LARL");
> +	report_prefix_pop();
> +}
> +
> +/* LOAD LOGICAL RELATIVE LONG.
> + * If it is the target of an execute-type instruction, the address is relative
> + * to the LLGFRL.
> + */
> +static void test_llgfrl(void)
> +{
> +	uint64_t target, value;
> +
> +	report_prefix_push("LLGFRL");
> +	asm volatile ( ".pushsection .text.exrl_targets\n"
> +		"	.balign	4\n"
> +		 //operand of llgfrl must be word aligned
> +		"0:	llgfrl	%[value],0\n"
> +		"	.popsection\n"
> +
> +		"	llgfrl	%[target],0b\n"
> +		//align (pad with nop), in case the wrong operand is used
> +		"	.balignw 4,0x0707\n"
> +		"	exrl	0,0b\n"
> +		: [target] "=d" (target),
> +		  [value] "=d" (value)
> +	);
> +
> +	report(target == value, "loaded correct value");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * COMPARE RELATIVE LONG
> + * If it is the target of an execute-type instruction, the address is relative
> + * to the CRL.
> + */
> +static void test_crl(void)
> +{
> +	uint32_t program_mask, cc, crl_word;
> +
> +	report_prefix_push("CRL");
> +	asm volatile ( ".pushsection .text.exrl_targets\n"
> +		 //operand of crl must be word aligned
> +		 "	.balign	4\n"
> +		"0:	crl	%[crl_word],0\n"
> +		"	.popsection\n"
> +
> +		"	lrl	%[crl_word],0b\n"
> +		//align (pad with nop), in case the wrong operand is used
> +		"	.balignw 4,0x0707\n"
> +		"	exrl	0,0b\n"
> +		"	ipm	%[program_mask]\n"
> +		: [program_mask] "=d" (program_mask),
> +		  [crl_word] "=d" (crl_word)
> +		:: "cc"
> +	);
> +
> +	cc = program_mask >> 28;
> +	report(!cc, "operand compared to is relative to CRL");
> +	report_prefix_pop();
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	report_prefix_push("ex");
> +	test_basr();
> +	test_bras();
> +	test_larl();
> +	test_llgfrl();
> +	test_crl();
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index d97eb5e9..b61faf07 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -215,3 +215,6 @@ file = migration-skey.elf
>  smp = 2
>  groups = migration
>  extra_params = -append '--parallel'
> +
> +[execute]
> +file = ex.elf
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index ad7949c9..a999f64a 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -275,6 +275,7 @@ s390x-kvm:
>    - ACCEL=kvm ./run_tests.sh
>        selftest-setup intercept emulator sieve sthyi diag10 diag308 pfmf
>        cmm vector gs iep cpumodel diag288 stsi sclp-1g sclp-3g css skrf sie
> +      execute
>        | tee results.txt
>    - grep -q PASS results.txt && ! grep -q FAIL results.txt
>   only:
> 
> base-commit: 20de8c3b54078ebc3df0b47344f9ce55bf52b7a5

