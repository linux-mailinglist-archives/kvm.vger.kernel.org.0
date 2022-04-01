Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189E64EEC2E
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345037AbiDALSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345512AbiDALSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56AB184B5B
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:35 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231AgIAl011995
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=jETxoVn08qvds5M+02q9Vnysuogk8CrqcXWGecc1vYI=;
 b=NBVIJW++ZcEJ5muS2W8ZB9G0jRChEsDhMG+7Guhf+GLT1jnZyca8YHMXEAIBTvCqZXHu
 pyIRaITn8mHwiGSDfCsTYLHh7XwbAYYi4wh5rKWiJ8H8lx1AI4fC1E8N5GrVAgqyE+aZ
 kRcLMM+GrAL1yrApFbOBjr6uoWCjY7VfOpCel5KiLFdkCs5phfiZtdZT4InWhvDi/DfV
 7+5TbKoxgpSGp/FoP2OHMXHw4BlbHMXFbGJ6U5LImRflijnhlmb7+ZUe9bC6yZ6kCF06
 QMgsA0huVz5g9DhOxXnR1wdTDAsQ8yLQ/KcyWW6sBK21hlE4gfbwjJsY+7jHUig1HnFA 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5yv50mqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:35 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231BDowi029980
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:35 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5yv50mq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:35 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7Qf6020778;
        Fri, 1 Apr 2022 11:16:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf92wqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGTMR33227070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 824994C066;
        Fri,  1 Apr 2022 11:16:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 269F64C05A;
        Fri,  1 Apr 2022 11:16:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:29 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 09/27] s390x: Add sck tests
Date:   Fri,  1 Apr 2022 13:16:02 +0200
Message-Id: <20220401111620.366435-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D-0yRWKN2iz7REiEYaci13qmicif6XBC
X-Proofpoint-GUID: axgKBLpPFLDw0ww4HqSy0HPXlb9ZbsZ8
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

SCK updates the guest's TOD clock. It needs to be intercepted, hence we
should have some tests for it:

- its operand must be 8-byte aligned. We test for 1, 2 and 4 byte
  misalignment.
- it should actually update the clock value. As guests are unable to
  stop their clock, we can only check the clock value is at least higher
  than the value we set.
- it is a privileged call, so expect it to fail when in problem state.
  We also test the clock value is not changed in this case. We do so by first
  adjusting it (privileged) to a high value. We then attempt, in
  nonprivileged mode, to set the clock to a comparatively small value.
  We can then store the clock value and test its value is strictly higher
  than the high value we set previously.

SCK is currently broken in QEMU TCG. A fix was posted upstream ("s390x: sck:
load into a temporary not into in1"):
https://lore.kernel.org/qemu-devel/20220126084201.774457-1-nrb@linux.ibm.com/

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/sck.c         | 136 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 140 insertions(+)
 create mode 100644 s390x/sck.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 53b0fe04..a76b78e5 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -17,6 +17,7 @@ tests += $(TEST_DIR)/stsi.elf
 tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
+tests += $(TEST_DIR)/sck.elf
 tests += $(TEST_DIR)/css.elf
 tests += $(TEST_DIR)/uv-guest.elf
 tests += $(TEST_DIR)/sie.elf
diff --git a/s390x/sck.c b/s390x/sck.c
new file mode 100644
index 00000000..88d52b74
--- /dev/null
+++ b/s390x/sck.c
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Perform Set Clock tests
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <uv.h>
+#include <asm/interrupt.h>
+#include <asm/time.h>
+
+static inline int sck(uint64_t *time)
+{
+	int cc;
+
+	asm volatile(
+		"	sck %[time]\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=d"(cc)
+		: [time] "Q"(*time)
+		: "cc"
+	);
+
+	return cc;
+}
+
+static inline int stck(uint64_t *time)
+{
+	int cc;
+
+	asm volatile(
+		"	stck %[time]\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=d" (cc), [time] "=Q" (*time)
+		:
+		: "cc", "memory"
+	);
+
+	return cc;
+}
+
+static void test_priv(void)
+{
+	uint64_t time_to_set_privileged = 0xfacef00dcafe0000,
+	    time_to_set_nonprivileged = 0xcafe0000,
+	    time_verify;
+	int cc;
+
+	report_prefix_push("privileged");
+	cc = sck(&time_to_set_privileged);
+	report(!cc, "set clock cc=%d", cc);
+
+	cc = stck(&time_verify);
+	report(!cc, "store clock cc=%d", cc);
+	report(time_verify > time_to_set_privileged,
+	       "privileged set affected the clock");
+	report_prefix_pop();
+
+	report_prefix_push("unprivileged");
+	expect_pgm_int();
+	enter_pstate();
+	sck(&time_to_set_nonprivileged);
+	leave_pstate();
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+
+	cc = stck(&time_verify);
+	report(!cc, "store clock cc=%d", cc);
+	report(time_verify > time_to_set_privileged,
+	       "unprivileged set did not affect the clock");
+	report_prefix_pop();
+}
+
+static void test_align(void)
+{
+	const int align_to = 8;
+	char unalign[sizeof(uint64_t) + align_to] __attribute__((aligned(8)));
+
+	report_prefix_push("Unaligned operand");
+	for (int i = 1; i < align_to; i *= 2) {
+		report_prefix_pushf("%d", i);
+		expect_pgm_int();
+		sck((uint64_t *)(unalign + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+}
+
+static void test_set(void)
+{
+	uint64_t start = 0, end = 0, time = 0xcafef00dbeef;
+	const uint64_t ticks_per_ms = 1000 << 12, ms_to_wait = 5;
+	int cc;
+
+	report_prefix_push("set");
+
+	cc = sck(&time);
+	report(!cc, "set clock cc=%d", cc);
+
+	cc = stck(&start);
+	report(!cc, "store start clock cc=%d", cc);
+	report(start >= time, "start >= set value");
+
+	mdelay(ms_to_wait);
+
+	cc = stck(&end);
+	report(!cc, "store end clock cc=%d", cc);
+	report(end > time, "end > set value");
+
+	report(end - start > (ticks_per_ms * ms_to_wait), "Advances");
+
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("sck");
+
+	if (uv_os_is_guest()) {
+		report_skip("Test unsupported under PV");
+		goto out;
+	}
+
+	test_align();
+	test_set();
+	test_priv();
+
+out:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 1600e714..8b148fe3 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -136,3 +136,6 @@ file = firq.elf
 timeout = 20
 extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
 accel = tcg
+
+[sck]
+file = sck.elf
-- 
2.34.1

