Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EF56D773B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbjDEIp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbjDEIpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:45:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B7930EB
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:45:46 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3358GwbX010324;
        Wed, 5 Apr 2023 08:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=6vQIEc45YjyGTXCb/xEzWj/VP3kupG9LnmmYxwBfKp0=;
 b=pFWEf/xzaBqryQaZX30vtUr/YWg0S7DE6SbtzfZ5c3KYxtIIpCxbwNag2ysQGPEhJKG8
 P3XNUrwstePAD9bVSPcg8OS9OBH7YoVOEAoqRtQK9U++0sFYu7B4F33FEUtIfeuSUZNu
 wwGgykaBh9ZmBmnT7eyZPbs4l2u3um/uzW1/as/ul1hnu2keCB+hiCnR+YXbTQjZg38W
 dLiVoXlVLvO/d6SFcKgLCYEyk3gxGeg5LGb9eY97p13PjxQnVdoQ6gJfnkmn2KUf0rdW
 9d1f+zi+07bpscnk7Ircp6teGw3JA7TBrvHnsfezQlJvV/+CL8g2GpnJtzVIXx7WD1Aw 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5be0p69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:43 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3358XBXg009649;
        Wed, 5 Apr 2023 08:45:43 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5be0p5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:43 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342FJ2w015573;
        Wed, 5 Apr 2023 08:45:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ppc86td3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3358jb4O17105592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 08:45:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 655E020043;
        Wed,  5 Apr 2023 08:45:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA52820040;
        Wed,  5 Apr 2023 08:45:36 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.30.226])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 08:45:36 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v3 11/14] s390x: Add tests for execute-type instructions
Date:   Wed,  5 Apr 2023 10:45:25 +0200
Message-Id: <20230405084528.16027-12-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405084528.16027-1-nrb@linux.ibm.com>
References: <20230405084528.16027-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _acHhSDnmaZb0kB4FFQd_wVtJGpArkS_
X-Proofpoint-ORIG-GUID: FtZ-EWUEge-CgbaVVFvZ6y8GZGFYtSGC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_04,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Test the instruction address used by targets of an execute instruction.
When the target instruction calculates a relative address, the result is
relative to the target instruction, not the execute instruction.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230317112339.774659-1-nsg@linux.ibm.com
[ nrb: add ifndef __clang__ guard around if in assembly ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/ex.c          | 197 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 .gitlab-ci.yml      |   1 +
 4 files changed, 202 insertions(+)
 create mode 100644 s390x/ex.c

diff --git a/s390x/Makefile b/s390x/Makefile
index ab146eb..a80db53 100644
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
index 0000000..92b387c
--- /dev/null
+++ b/s390x/ex.c
@@ -0,0 +1,197 @@
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
+/*
+ * Clang 15 doesn't like the if below, guard it s.t. we still have the assertion
+ * when compiling with GCC.
+ *
+ * s390x/ex.c:81:4: error: expected absolute expression
+ *                  "       .if (1b - 0b) != (3b - 2b)\n"
+ */
+#ifndef __clang__
+		"	.if (1b - 0b) != (3b - 2b)\n"
+		"	.error	\"right and wrong target must have same offset\"\n"
+		"	.endif\n"
+#endif
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
index d97eb5e..b61faf0 100644
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
index ad7949c..a999f64 100644
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
-- 
2.39.2

