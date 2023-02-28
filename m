Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47AC6A608C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjB1UoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjB1UoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:44:14 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CFD34F61;
        Tue, 28 Feb 2023 12:44:12 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SKIiP1028980;
        Tue, 28 Feb 2023 20:44:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3cAKNPdY/je/VAJCQqPJXqOobmzmeY3lD9oc6tOrSm4=;
 b=Zt8lu7GLTdEVV1rzyKt7G0dzpLvlEM4Uk1B7HXCT47Omrrrmyn6YWMK8P8fQ0eRiXkn3
 nhmcwx20Z9m13EsvxfyVqh2yMipHGO5OJPZSnc4xNfPT755NhgRREnjnq4ovk9GK9JZV
 pNeOkFKXLCb1naMHodIuX3laKGPhCB/Ux+szPilGkVWVNmiL+bCE5MDMddyYQgrtuIsr
 mkJvGg9/U26cXE6qIJrcXJ+CRReZ7bLnZkQ1P6aZLBIcIwrwR5qPAx5X0ABo3Tt1rp7k
 v80RQ4nr5bbukvITnZJMay6LXMGUVo95KdC+ghoT3zf9KUgzd0IXDjHL8S4BudYFmH/S qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1rhrghdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 20:44:11 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SKRaC7031755;
        Tue, 28 Feb 2023 20:44:10 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1rhrghch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 20:44:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31SJbgvx026427;
        Tue, 28 Feb 2023 20:44:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nybb4kjtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 20:44:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31SKi5vD63242742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 20:44:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2183D20040;
        Tue, 28 Feb 2023 20:44:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E315220043;
        Tue, 28 Feb 2023 20:44:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Feb 2023 20:44:04 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3] s390x: Add tests for execute-type instructions
Date:   Tue, 28 Feb 2023 21:44:03 +0100
Message-Id: <20230228204403.460107-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BkB8BnzdQhlwMty4XDzEmxjyOlv17ykq
X-Proofpoint-GUID: A9dEaEdLHRIsfDr846pp8L1XLOkEfojx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_17,2023-02-28_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302280169
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the instruction address used by targets of an execute instruction.
When the target instruction calculates a relative address, the result is
relative to the target instruction, not the execute instruction.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---


v2 -> v3:
 * add some comments (thanks Janosch)
 * add two new tests (drop Nico's R-b)
 * push prefix

v1 -> v2:
 * add test to unittests.cfg and .gitlab-ci.yml
 * pick up R-b (thanks Nico)


TCG does the address calculation relative to the execute instruction.
Everything that has an operand that is relative to the instruction given by
the immediate in the instruction and goes through in2_ri2 in TCG has this
problem, because in2_ri2 does the calculation relative to pc_next which is the
address of the EX(RL).
That should make fixing it easier tho.


Range-diff against v2:
1:  08bae04a ! 1:  136eb2a2 s390x: Add tests for execute-type instructions
    @@ Commit message
         relative to the target instruction, not the execute instruction.
     
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
    -    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
     
      ## s390x/Makefile ##
     @@ s390x/Makefile: tests += $(TEST_DIR)/panic-loop-extint.elf
    @@ s390x/ex.c (new)
     + * Copyright IBM Corp. 2023
     + *
     + * Test EXECUTE (RELATIVE LONG).
    ++ * These instruction execute a target instruction. The target instruction is formed
    ++ * by reading an instruction from memory and optionally modifying some of its bits.
    ++ * The execution of the target instruction is the same as if it was executed
    ++ * normally as part of the instruction sequence, except for the instruction
    ++ * address and the instruction-length code.
     + */
     +
     +#include <libcflat.h>
     +
    ++/*
    ++ * BRANCH AND SAVE, register register variant.
    ++ * Saves the next instruction address (address from PSW + length of instruction)
    ++ * to the first register. No branch is taken in this test, because 0 is
    ++ * specified as target.
    ++ * BASR does *not* perform a relative address calculation with an intermediate.
    ++ */
     +static void test_basr(void)
     +{
     +	uint64_t ret_addr, after_ex;
    @@ s390x/ex.c (new)
     +}
     +
     +/*
    -+ * According to PoP (Branch-Address Generation), the address is relative to
    -+ * BRAS when it is the target of an execute-type instruction.
    ++ * BRANCH RELATIVE AND SAVE.
    ++ * According to PoP (Branch-Address Generation), the address calculated relative
    ++ * to the instruction address is relative to BRAS when it is the target of an
    ++ * execute-type instruction, not relative to the execute-type instruction.
     + */
     +static void test_bras(void)
     +{
    @@ s390x/ex.c (new)
     +	report_prefix_pop();
     +}
     +
    ++/*
    ++ * LOAD ADDRESS RELATIVE LONG.
    ++ * If it is the target of an execute-type instruction, the address is relative
    ++ * to the LARL.
    ++ */
     +static void test_larl(void)
     +{
     +	uint64_t target, addr;
    @@ s390x/ex.c (new)
     +	report_prefix_pop();
     +}
     +
    ++/* LOAD LOGICAL RELATIVE LONG.
    ++ * If it is the target of an execute-type instruction, the address is relative
    ++ * to the LLGFRL.
    ++ */
    ++static void test_llgfrl(void)
    ++{
    ++	uint64_t target, value;
    ++
    ++	report_prefix_push("LLGFRL");
    ++	asm volatile ( ".pushsection .rodata\n"
    ++		"	.balign	4\n"
    ++		"0:	llgfrl	%[value],0\n"
    ++		"	.popsection\n"
    ++
    ++		"	llgfrl	%[target],0b\n"
    ++		"	exrl	0,0b\n"
    ++		: [target] "=d" (target),
    ++		  [value] "=d" (value)
    ++	);
    ++
    ++	report(target == value, "loaded correct value");
    ++	report_prefix_pop();
    ++}
    ++
    ++/*
    ++ * COMPARE RELATIVE LONG
    ++ * If it is the target of an execute-type instruction, the address is relative
    ++ * to the CRL.
    ++ */
    ++static void test_crl(void)
    ++{
    ++	uint32_t program_mask, cc, crl_word;
    ++
    ++	report_prefix_push("CRL");
    ++	asm volatile ( ".pushsection .rodata\n"
    ++		"	.balign	4\n" //operand of crl must be word aligned
    ++		"0:	crl	%[crl_word],0\n"
    ++		"	.popsection\n"
    ++
    ++		"	lrl	%[crl_word],0b\n"
    ++		//align (pad with nop), in case the wrong bad operand is used
    ++		"	.balignw 4,0x0707\n"
    ++		"	exrl	0,0b\n"
    ++		"	ipm	%[program_mask]\n"
    ++		: [program_mask] "=d" (program_mask),
    ++		  [crl_word] "=d" (crl_word)
    ++		:: "cc"
    ++	);
    ++
    ++	cc = program_mask >> 28;
    ++	report(!cc, "operand compared to is relative to CRL");
    ++	report_prefix_pop();
    ++}
    ++
     +int main(int argc, char **argv)
     +{
    ++	report_prefix_push("ex");
     +	test_basr();
     +	test_bras();
     +	test_larl();
    ++	test_llgfrl();
    ++	test_crl();
    ++	report_prefix_pop();
     +
     +	return report_summary();
     +}

 s390x/Makefile      |   1 +
 s390x/ex.c          | 169 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 .gitlab-ci.yml      |   1 +
 4 files changed, 174 insertions(+)
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
index 00000000..3a22e496
--- /dev/null
+++ b/s390x/ex.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright IBM Corp. 2023
+ *
+ * Test EXECUTE (RELATIVE LONG).
+ * These instruction execute a target instruction. The target instruction is formed
+ * by reading an instruction from memory and optionally modifying some of its bits.
+ * The execution of the target instruction is the same as if it was executed
+ * normally as part of the instruction sequence, except for the instruction
+ * address and the instruction-length code.
+ */
+
+#include <libcflat.h>
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
+	asm volatile ( ".pushsection .rodata\n"
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
+	asm volatile ( ".pushsection .text.ex_bras, \"x\"\n"
+		"0:	bras	%[ret_addr],1f\n"
+		"	nopr	%%r7\n"
+		"1:	larl	%[branch_addr],0\n"
+		"	j	4f\n"
+		"	.popsection\n"
+
+		"	larl	%[after_target],1b\n"
+		"	larl	%[after_ex],3f\n"
+		"2:	exrl	0,0b\n"
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
+	asm volatile ( ".pushsection .rodata\n"
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
+	asm volatile ( ".pushsection .rodata\n"
+		"	.balign	4\n"
+		"0:	llgfrl	%[value],0\n"
+		"	.popsection\n"
+
+		"	llgfrl	%[target],0b\n"
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
+	asm volatile ( ".pushsection .rodata\n"
+		"	.balign	4\n" //operand of crl must be word aligned
+		"0:	crl	%[crl_word],0\n"
+		"	.popsection\n"
+
+		"	lrl	%[crl_word],0b\n"
+		//align (pad with nop), in case the wrong bad operand is used
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

base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
-- 
2.36.1

