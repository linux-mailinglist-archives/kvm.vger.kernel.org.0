Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2163A6BE7F5
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCQLX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCQLXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:23:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9B7199D5;
        Fri, 17 Mar 2023 04:23:53 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HArSsb027900;
        Fri, 17 Mar 2023 11:23:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=/W8SY+Dm5JHX1qzntUjXw2uscqJTEVruGZMSifc4pZg=;
 b=sNOkmlIyWXbkjwERJ9nrnQ4oBXGGIraDW7+JU6NYvRPxlqkllXZGRfBCy5MXNLlp6Nmf
 tOh14AbOYXgq9cmvjJ0hfeJSKqTUAEYLG+gzCZMiT+o8l9wp9sRWYQBIqLYuNO8kO8BU
 b92NVWIYo4M5Jfzf6MLX8BOw9StWh23VgJXMjMx3uxHrOJ3Xu4Bsmm3XlTXbc4+y3p4X
 k/Zp2kapo1pfIcYg5L2ysPhdMNRjMAXJBP4oUXhDVZOBqjI4ANE6VTO0EkJcULW+LjHn
 l2vRMv5+cDB1dmzrR2KgnGmyHwJSVeJIkFzIMx+4dqm+tEXxSKbcWXy8MdWUVHXudsS5 JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcpurgpmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 11:23:52 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32HAt84j000691;
        Fri, 17 Mar 2023 11:23:51 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcpurgpks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 11:23:51 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32GHUhc7024411;
        Fri, 17 Mar 2023 11:23:49 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pbsmbhpyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 11:23:49 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HBNkLg27656732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 11:23:46 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3711D2004B;
        Fri, 17 Mar 2023 11:23:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFB0020049;
        Fri, 17 Mar 2023 11:23:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 11:23:45 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v6] s390x: Add tests for execute-type instructions
Date:   Fri, 17 Mar 2023 12:23:39 +0100
Message-Id: <20230317112339.774659-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b_vEN9LON6GIRUYvH99np6ZOlhtHdrEn
X-Proofpoint-ORIG-GUID: Dh_2lj6eD882E0a67XfNI7Hl7fgv8Ies
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_06,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the instruction address used by targets of an execute instruction.
When the target instruction calculates a relative address, the result is
relative to the target instruction, not the execute instruction.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---


v5 -> v6:
 * fix section for exrl targets (thanks Claudio)
 * add comments (thanks Claudio)

v4 -> v5:
 * word align the execute-type instruction, preventing a specification
   exception if the address calculation is wrong, since LLGFRL requires
   word alignment
 * change wording of comment

v3 -> v4:
 * fix nits (thanks Janosch)
 * pickup R-b (thanks Janosch)

v2 -> v3:
 * add some comments (thanks Janosch)
 * add two new tests (drop Nico's R-b)
 * push prefix

v1 -> v2:
 * add test to unittests.cfg and .gitlab-ci.yml
 * pick up R-b (thanks Nico)


See https://patchew.org/QEMU/20230316210751.302423-1-iii@linux.ibm.com/
for TCG fixes.


Range-diff against v5:
1:  57f8f256 ! 1:  3893f723 s390x: Add tests for execute-type instructions
    @@ s390x/ex.c (new)
     +#include <libcflat.h>
     +
     +/*
    ++ * Accesses to the operand of execute-type instructions are instruction fetches.
    ++ * Minimum alignment is two, since the relative offset is specified by number of halfwords.
    ++ */
    ++asm (  ".pushsection .text.exrl_targets,\"x\"\n"
    ++"	.balign	2\n"
    ++"	.popsection\n"
    ++);
    ++
    ++/*
     + * BRANCH AND SAVE, register register variant.
     + * Saves the next instruction address (address from PSW + length of instruction)
     + * to the first register. No branch is taken in this test, because 0 is
    @@ s390x/ex.c (new)
     +	uint64_t ret_addr, after_ex;
     +
     +	report_prefix_push("BASR");
    -+	asm volatile ( ".pushsection .rodata\n"
    ++	asm volatile ( ".pushsection .text.exrl_targets\n"
     +		"0:	basr	%[ret_addr],0\n"
     +		"	.popsection\n"
     +
    @@ s390x/ex.c (new)
     +	uint64_t after_target, ret_addr, after_ex, branch_addr;
     +
     +	report_prefix_push("BRAS");
    -+	asm volatile ( ".pushsection .text.ex_bras, \"x\"\n"
    ++	asm volatile ( ".pushsection .text.exrl_targets\n"
     +		"0:	bras	%[ret_addr],1f\n"
     +		"	nopr	%%r7\n"
     +		"1:	larl	%[branch_addr],0\n"
    @@ s390x/ex.c (new)
     +		"	larl	%[after_target],1b\n"
     +		"	larl	%[after_ex],3f\n"
     +		"2:	exrl	0,0b\n"
    ++/*
    ++ * In case the address calculation is correct, we jump by the relative offset 1b-0b from 0b to 1b.
    ++ * In case the address calculation is relative to the exrl (i.e. a test failure),
    ++ * put a valid instruction at the same relative offset from the exrl, so the test continues in a
    ++ * controlled manner.
    ++ */
     +		"3:	larl	%[branch_addr],0\n"
     +		"4:\n"
     +
    @@ s390x/ex.c (new)
     +	uint64_t target, addr;
     +
     +	report_prefix_push("LARL");
    -+	asm volatile ( ".pushsection .rodata\n"
    ++	asm volatile ( ".pushsection .text.exrl_targets\n"
     +		"0:	larl	%[addr],0\n"
     +		"	.popsection\n"
     +
    @@ s390x/ex.c (new)
     +	uint64_t target, value;
     +
     +	report_prefix_push("LLGFRL");
    -+	asm volatile ( ".pushsection .rodata\n"
    ++	asm volatile ( ".pushsection .text.exrl_targets\n"
     +		"	.balign	4\n"
    ++		 //operand of llgfrl must be word aligned
     +		"0:	llgfrl	%[value],0\n"
     +		"	.popsection\n"
     +
    @@ s390x/ex.c (new)
     +	uint32_t program_mask, cc, crl_word;
     +
     +	report_prefix_push("CRL");
    -+	asm volatile ( ".pushsection .rodata\n"
    ++	asm volatile ( ".pushsection .text.exrl_targets\n"
     +		 //operand of crl must be word aligned
     +		 "	.balign	4\n"
     +		"0:	crl	%[crl_word],0\n"

 s390x/Makefile      |   1 +
 s390x/ex.c          | 188 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 .gitlab-ci.yml      |   1 +
 4 files changed, 193 insertions(+)
 create mode 100644 s390x/ex.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 97a61611..6cf8018b 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
 tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
+tests += $(TEST_DIR)/ex.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/ex.c b/s390x/ex.c
new file mode 100644
index 00000000..dbd8030d
--- /dev/null
+++ b/s390x/ex.c
@@ -0,0 +1,188 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright IBM Corp. 2023
+ *
+ * Test EXECUTE (RELATIVE LONG).
+ * These instructions execute a target instruction. The target instruction is formed
+ * by reading an instruction from memory and optionally modifying some of its bits.
+ * The execution of the target instruction is the same as if it was executed
+ * normally as part of the instruction sequence, except for the instruction
+ * address and the instruction-length code.
+ */
+
+#include <libcflat.h>
+
+/*
+ * Accesses to the operand of execute-type instructions are instruction fetches.
+ * Minimum alignment is two, since the relative offset is specified by number of halfwords.
+ */
+asm (  ".pushsection .text.exrl_targets,\"x\"\n"
+"	.balign	2\n"
+"	.popsection\n"
+);
+
+/*
+ * BRANCH AND SAVE, register register variant.
+ * Saves the next instruction address (address from PSW + length of instruction)
+ * to the first register. No branch is taken in this test, because 0 is
+ * specified as target.
+ * BASR does *not* perform a relative address calculation with an intermediate.
+ */
+static void test_basr(void)
+{
+	uint64_t ret_addr, after_ex;
+
+	report_prefix_push("BASR");
+	asm volatile ( ".pushsection .text.exrl_targets\n"
+		"0:	basr	%[ret_addr],0\n"
+		"	.popsection\n"
+
+		"	larl	%[after_ex],1f\n"
+		"	exrl	0,0b\n"
+		"1:\n"
+		: [ret_addr] "=d" (ret_addr),
+		  [after_ex] "=d" (after_ex)
+	);
+
+	report(ret_addr == after_ex, "return address after EX");
+	report_prefix_pop();
+}
+
+/*
+ * BRANCH RELATIVE AND SAVE.
+ * According to PoP (Branch-Address Generation), the address calculated relative
+ * to the instruction address is relative to BRAS when it is the target of an
+ * execute-type instruction, not relative to the execute-type instruction.
+ */
+static void test_bras(void)
+{
+	uint64_t after_target, ret_addr, after_ex, branch_addr;
+
+	report_prefix_push("BRAS");
+	asm volatile ( ".pushsection .text.exrl_targets\n"
+		"0:	bras	%[ret_addr],1f\n"
+		"	nopr	%%r7\n"
+		"1:	larl	%[branch_addr],0\n"
+		"	j	4f\n"
+		"	.popsection\n"
+
+		"	larl	%[after_target],1b\n"
+		"	larl	%[after_ex],3f\n"
+		"2:	exrl	0,0b\n"
+/*
+ * In case the address calculation is correct, we jump by the relative offset 1b-0b from 0b to 1b.
+ * In case the address calculation is relative to the exrl (i.e. a test failure),
+ * put a valid instruction at the same relative offset from the exrl, so the test continues in a
+ * controlled manner.
+ */
+		"3:	larl	%[branch_addr],0\n"
+		"4:\n"
+
+		"	.if (1b - 0b) != (3b - 2b)\n"
+		"	.error	\"right and wrong target must have same offset\"\n"
+		"	.endif\n"
+		: [after_target] "=d" (after_target),
+		  [ret_addr] "=d" (ret_addr),
+		  [after_ex] "=d" (after_ex),
+		  [branch_addr] "=d" (branch_addr)
+	);
+
+	report(after_target == branch_addr, "address calculated relative to BRAS");
+	report(ret_addr == after_ex, "return address after EX");
+	report_prefix_pop();
+}
+
+/*
+ * LOAD ADDRESS RELATIVE LONG.
+ * If it is the target of an execute-type instruction, the address is relative
+ * to the LARL.
+ */
+static void test_larl(void)
+{
+	uint64_t target, addr;
+
+	report_prefix_push("LARL");
+	asm volatile ( ".pushsection .text.exrl_targets\n"
+		"0:	larl	%[addr],0\n"
+		"	.popsection\n"
+
+		"	larl	%[target],0b\n"
+		"	exrl	0,0b\n"
+		: [target] "=d" (target),
+		  [addr] "=d" (addr)
+	);
+
+	report(target == addr, "address calculated relative to LARL");
+	report_prefix_pop();
+}
+
+/* LOAD LOGICAL RELATIVE LONG.
+ * If it is the target of an execute-type instruction, the address is relative
+ * to the LLGFRL.
+ */
+static void test_llgfrl(void)
+{
+	uint64_t target, value;
+
+	report_prefix_push("LLGFRL");
+	asm volatile ( ".pushsection .text.exrl_targets\n"
+		"	.balign	4\n"
+		 //operand of llgfrl must be word aligned
+		"0:	llgfrl	%[value],0\n"
+		"	.popsection\n"
+
+		"	llgfrl	%[target],0b\n"
+		//align (pad with nop), in case the wrong operand is used
+		"	.balignw 4,0x0707\n"
+		"	exrl	0,0b\n"
+		: [target] "=d" (target),
+		  [value] "=d" (value)
+	);
+
+	report(target == value, "loaded correct value");
+	report_prefix_pop();
+}
+
+/*
+ * COMPARE RELATIVE LONG
+ * If it is the target of an execute-type instruction, the address is relative
+ * to the CRL.
+ */
+static void test_crl(void)
+{
+	uint32_t program_mask, cc, crl_word;
+
+	report_prefix_push("CRL");
+	asm volatile ( ".pushsection .text.exrl_targets\n"
+		 //operand of crl must be word aligned
+		 "	.balign	4\n"
+		"0:	crl	%[crl_word],0\n"
+		"	.popsection\n"
+
+		"	lrl	%[crl_word],0b\n"
+		//align (pad with nop), in case the wrong operand is used
+		"	.balignw 4,0x0707\n"
+		"	exrl	0,0b\n"
+		"	ipm	%[program_mask]\n"
+		: [program_mask] "=d" (program_mask),
+		  [crl_word] "=d" (crl_word)
+		:: "cc"
+	);
+
+	cc = program_mask >> 28;
+	report(!cc, "operand compared to is relative to CRL");
+	report_prefix_pop();
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_push("ex");
+	test_basr();
+	test_bras();
+	test_larl();
+	test_llgfrl();
+	test_crl();
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index d97eb5e9..b61faf07 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -215,3 +215,6 @@ file = migration-skey.elf
 smp = 2
 groups = migration
 extra_params = -append '--parallel'
+
+[execute]
+file = ex.elf
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index ad7949c9..a999f64a 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -275,6 +275,7 @@ s390x-kvm:
   - ACCEL=kvm ./run_tests.sh
       selftest-setup intercept emulator sieve sthyi diag10 diag308 pfmf
       cmm vector gs iep cpumodel diag288 stsi sclp-1g sclp-3g css skrf sie
+      execute
       | tee results.txt
   - grep -q PASS results.txt && ! grep -q FAIL results.txt
  only:

base-commit: 20de8c3b54078ebc3df0b47344f9ce55bf52b7a5
-- 
2.39.1

