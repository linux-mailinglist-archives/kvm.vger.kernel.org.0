Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068254961CD
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381509AbiAUPKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:10:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1381504AbiAUPJl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 10:09:41 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LEoUCe024085;
        Fri, 21 Jan 2022 15:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eq5mIyptuCWeTYO1JjS7B+FUEpXGCgS1AnfUylFZ0y8=;
 b=A8Pu3MpHYwjyZoPCszmXYO5R4ztjDoIaTESh/JmOU3+9OWl5JFEU8h39UI0JlvtkPwLM
 tKER2pqEqVwsLaThBzAsEn2pQOD6GbDWMvt1TSTf3gBLklGgGEbuCYwd7my1norxt6As
 pUmQPG1wp+oOJazugfnBM5lCi8qG2MpxwR+NPR19EFk2fauyiSTOzrh2V+c5Wi2IlDGY
 6qFxiLE7XREl6rsDOc+GjUIG8pEMnKY5A3QPwmaUc5UpktbSM2r3g/3B07Gn1YQfwcS9
 aQBErKgOFQ1nEe17FFmNBurAEDBDRqRpBVL0XUjI1Lc95y9gDBNkkuX2w3Q0olJXIOn7 zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqtv5nn42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:40 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LF5tIN016838;
        Fri, 21 Jan 2022 15:09:40 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqtv5nn3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LF1xPF013926;
        Fri, 21 Jan 2022 15:09:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3dqj37wx3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LF9YUf37683678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:09:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C0DF42049;
        Fri, 21 Jan 2022 15:09:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F12442045;
        Fri, 21 Jan 2022 15:09:34 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 15:09:34 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [PATCH kvm-unit-tests v1 8/8] s390x: Add EPSW test
Date:   Fri, 21 Jan 2022 16:09:31 +0100
Message-Id: <20220121150931.371720-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121150931.371720-1-nrb@linux.ibm.com>
References: <20220121150931.371720-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: btHg7hbSCj82AqU_h-l250ca6B4gkJI-
X-Proofpoint-ORIG-GUID: 1RYZTZAdasPHM15vMdWWaIuOCUXCiEzT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EPSW is only intercepted in certain cases. One of these cases is if we
have a CRW pending and machine check interrupts are masked. This can be
achieved by issuing a RCHP on a valid channel path. This is why we need
the CSS lib and an IO device in this test and hence need to skip it
when not running under QEMU.

Three special cases deserve our attention:

- upper 32 bits of both operands are never modified,
- second operand is not modified if it is zero.
- when both operands are zero, bits 0-11 and 13-31 of the PSW are
  stored in r0.

We also verify we get the correct contents when the second operand is
zero. To do so, we save the data stored at the first operand in the
first case as a reference. As we don't mess with the PSW, the only thing
that might change is the Condition Code (CC) due to some instruction in
between, so we zero it out using zero_out_cc_from_epsw_op1().

This test must be fenced when running in non-QEMU. For this, we need
vm_is_kvm() from Pierre's patchset
"[kvm-unit-tests PATCH v3 0/4] S390x: CPU Topology Information"
(Message-Id: <20220110133755.22238-3-pmorel@linux.ibm.com>)

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/epsw.c        | 113 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 ++
 3 files changed, 118 insertions(+)
 create mode 100644 s390x/epsw.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a76b78e5a011..25449708da0d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -27,6 +27,7 @@ tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
 tests += $(TEST_DIR)/firq.elf
+tests += $(TEST_DIR)/epsw.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/epsw.c b/s390x/epsw.c
new file mode 100644
index 000000000000..192115cf2fac
--- /dev/null
+++ b/s390x/epsw.c
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * EPSW Interception Tests
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <css.h>
+#include <vm.h>
+
+static uint32_t zero_out_cc_from_epsw_op1(uint32_t epsw_op1)
+{
+	return epsw_op1 & ~GENMASK(31 - 18, 31 - 20);
+}
+
+static void generate_crw(void)
+{
+	int test_device_sid = css_enumerate();
+	int cc, ret;
+
+	if (!(test_device_sid & SCHID_ONE)) {
+		report_fail("No I/O device found");
+		return;
+	}
+
+	cc = css_enable(test_device_sid, IO_SCH_ISC);
+	report(cc == 0, "Enable subchannel %08x", test_device_sid);
+
+	ret = css_generate_crw(test_device_sid);
+	if (ret)
+		report_fail("Couldn't generate CRW");
+}
+
+static void test_epsw(void)
+{
+	const uint64_t MAGIC1 = 0x1234567890abcdefUL;
+	const uint64_t MAGIC2 = 0xcafedeadbeeffaceUL;
+
+	uint64_t op1 = MAGIC1;
+	uint64_t op2 = MAGIC2;
+	uint32_t prev_epsw_op1;
+
+	/*
+	 * having machine check interrupts masked and pending CRW ensures
+	 * EPSW is intercepted under KVM
+	 */
+	generate_crw();
+
+	report_prefix_push("both operands given");
+	asm volatile(
+		"epsw %0, %1\n"
+		: "+&d" (op1), "+&a" (op2));
+	report(upper_32_bits(op1) == upper_32_bits(MAGIC1) &&
+	       upper_32_bits(op2) == upper_32_bits(MAGIC2),
+	       "upper 32 bits unmodified");
+	report(lower_32_bits(op1) != lower_32_bits(MAGIC1) &&
+	       lower_32_bits(op2) != lower_32_bits(MAGIC2),
+	       "lower 32 bits modified");
+	prev_epsw_op1 = zero_out_cc_from_epsw_op1(lower_32_bits(op1));
+	report_prefix_pop();
+
+	report_prefix_push("second operand 0");
+	op1 = MAGIC1;
+	op2 = MAGIC2;
+	asm volatile(
+		"	lgr 0,%[op2]\n"
+		"	epsw %[op1], 0\n"
+		"	lgr %[op2],0\n"
+		: [op2] "+&d" (op2), [op1] "+&a" (op1)
+		:
+		: "0");
+	report(upper_32_bits(op1) == upper_32_bits(MAGIC1),
+	       "upper 32 bits of first operand unmodified");
+	report(zero_out_cc_from_epsw_op1(lower_32_bits(op1)) == prev_epsw_op1,
+	       "first operand matches previous reading");
+	report(op2 == MAGIC2, "r0 unmodified");
+	report_prefix_pop();
+
+	report_prefix_push("both operands 0");
+	op1 = MAGIC1;
+	asm volatile(
+		"	lgr 0,%[op1]\n"
+		"	epsw 0, 0\n"
+		"	lgr %[op1],0\n"
+		: [op1] "+&d" (op1)
+		:
+		: "0");
+	report(upper_32_bits(op1) == upper_32_bits(MAGIC1),
+	       "upper 32 bits of first operand unmodified");
+	report(zero_out_cc_from_epsw_op1(lower_32_bits(op1)) == prev_epsw_op1,
+	       "first operand matches previous reading");
+	report_prefix_pop();
+}
+
+int main(int argc, char **argv)
+{
+	if (!vm_is_kvm() && !vm_is_tcg()) {
+		report_skip("Not running under QEMU");
+		goto done;
+	}
+
+	report_prefix_push("epsw");
+
+	test_epsw();
+
+done:
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3b99d22147e2..1fd177c4b24c 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -125,3 +125,7 @@ extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -devi
 
 [sck]
 file = sck.elf
+
+[epsw]
+file = epsw.elf
+extra_params = -device virtio-net-ccw
-- 
2.31.1

