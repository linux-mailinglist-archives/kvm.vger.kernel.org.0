Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D515F4961CE
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381550AbiAUPKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:10:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1381505AbiAUPJl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 10:09:41 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LEpLn8028750;
        Fri, 21 Jan 2022 15:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TRZ/5mx9el75I6LdoCo4OEoZ6aGqukZQY5Zey+vJJnM=;
 b=B07uaw9u85fd+UHNIxK5oznpOs5uRkLDlJKYX6maEhmIbCPOFX5GVNREpZWSD9hVgdc4
 3SA9bmHET2nhRnAPGJ6au4Tgaiur8EGm7ayxiI+RMeIe2d6LW9rCO04PNE6yas2n3kl3
 D0tN6eCHjRL8j2jHklo8y5+CUlSRdWSskNFkaEeJN7Iwm0TPLIZGv5Hjc9JT7/yLudtg
 TJkAFqm7bvIRRbs7lFUsHav0RmWb3+ie7N4w0nIEMtDsT4yZmLnse6n5D1Of/G1wiI1j
 gjo+4yMAOTQqZBOhVsr4ITlnk5N9JeH1bgPI8/VUUhV2MllVqs2HSt43DBGVQJQDZ3Qe iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqv6748wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:40 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LEqVoM007387;
        Fri, 21 Jan 2022 15:09:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqv6748w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LF2FVp031788;
        Fri, 21 Jan 2022 15:09:38 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3dqjdpnvbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LF9XSn46924098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:09:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 147D042049;
        Fri, 21 Jan 2022 15:09:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB4A442045;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [PATCH kvm-unit-tests v1 3/8] s390x: Add sck tests
Date:   Fri, 21 Jan 2022 16:09:26 +0100
Message-Id: <20220121150931.371720-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121150931.371720-1-nrb@linux.ibm.com>
References: <20220121150931.371720-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: diPStkVHGGgQIoQmNflr_I_Ne_bq-4z2
X-Proofpoint-ORIG-GUID: Ukj3-DKleEdYZtDoyfBneLWKoaVJhz_w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/sck.c         | 127 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 ++
 3 files changed, 131 insertions(+)
 create mode 100644 s390x/sck.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 53b0fe044fe7..a76b78e5a011 100644
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
index 000000000000..dcddd1b2e5f8
--- /dev/null
+++ b/s390x/sck.c
@@ -0,0 +1,127 @@
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
+
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
+	test_align();
+	test_set();
+	test_priv();
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 054560c29942..3b99d22147e2 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -122,3 +122,6 @@ extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -devi
 file = firq.elf
 timeout = 20
 extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
+
+[sck]
+file = sck.elf
-- 
2.31.1

