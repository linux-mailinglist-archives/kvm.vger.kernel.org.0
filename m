Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5469F39C
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 12:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjBVLrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 06:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjBVLrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 06:47:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4669046B3;
        Wed, 22 Feb 2023 03:47:51 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MBKbX2014545;
        Wed, 22 Feb 2023 11:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dNzx9hCcFyizYPZylMpU9zX9/4dCBiRnCvClANQidg0=;
 b=NxI3GUyyXOtsBXKPBYy4SfdB1/+LNMUWnsWrhLqQ7jNVCnxcHwIrLz4QD3UTdcDa8f4J
 tv780ZpnGaDQ1FFJFyv2o3L67oicYPWPF3I02Titi0pC9f5frdDXGFT2/FttHIbqKqdr
 Z83+3NzKQU+bKhZCLSDiQq39BcZ1FUTjn5h/Y/7ezJu1sNc+7uI7L7NAXNS/IGM0gy+/
 +X3BHK/6h4w17Ru/exxMFDKtpBUvAYPQW9ORuHzmnUY2wm9kunlWG7rqDPf+Px51VFD6
 YlUvhy0H1rNz6evM5R3bHabgly6Beg2BvTVbRGn/lDkSrhcyuEm/FfCiZHHIdjXsRdHG iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwj3g0khd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 11:47:50 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MBPLGr030380;
        Wed, 22 Feb 2023 11:47:50 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwj3g0kgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 11:47:50 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31M9vSHP001735;
        Wed, 22 Feb 2023 11:47:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6418n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 11:47:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MBliiE22741458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 11:47:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 448972004F;
        Wed, 22 Feb 2023 11:47:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE4D02004B;
        Wed, 22 Feb 2023 11:47:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 11:47:43 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: Add tests for execute-type instructions
Date:   Wed, 22 Feb 2023 12:47:42 +0100
Message-Id: <20230222114742.1208584-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pX1ewMghN8Ka7BRZI7V-nK7sSred1X56
X-Proofpoint-ORIG-GUID: 9Wt9Hzw4tZDiixMRH07O7P1_lSjJgoVf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302220102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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


TCG does the address calculation relative to the execute instruction.


 s390x/Makefile |  1 +
 s390x/ex.c     | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)
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
index 00000000..1bf4d8cd
--- /dev/null
+++ b/s390x/ex.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright IBM Corp. 2023
+ *
+ * Test EXECUTE (RELATIVE LONG).
+ */
+
+#include <libcflat.h>
+
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
+ * According to PoP (Branch-Address Generation), the address is relative to
+ * BRAS when it is the target of an execute-type instruction.
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
+int main(int argc, char **argv)
+{
+	test_basr();
+	test_bras();
+	test_larl();
+
+	return report_summary();
+}

base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
-- 
2.36.1

