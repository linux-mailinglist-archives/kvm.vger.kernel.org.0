Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F966EF053
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 10:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbjDZIes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 04:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240169AbjDZIeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 04:34:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19AE4487;
        Wed, 26 Apr 2023 01:34:42 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q8WqBF020720;
        Wed, 26 Apr 2023 08:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dwqBDfnVgQ/sq/qvvkSWmpyGwXI5Y5nbb90QMJp7jlo=;
 b=h9CAJDQlWLlhDGqs2el9ThDozRIKYOs5PqzEB9F6l9P9d1BTs3mbznD9lXgRTpZaov1h
 mh12xBRcF0HssdbVbgQ3GFWjwvufEMw3uggqZIvFzv95jro/4UYDHu5k1gsYvTcj2Iuz
 j/WlObpyJXzDAr2gj04ZtphBcXlqiJcfxFzpbVKlvkpk7f0aOwnqKz5w/+kI24F4sJad
 NJzEQlWFAfrONxbv4A3z3UNK1hmoPbB68gau5rb5IgCBzrHCkMLBZXDCa/JLWtgS3j0/
 eKArM8H0WeHdOzIxAu4KmRNrkul3SJvIBn+G+kX5zimBMP3iNqcvIEK1a9zEgN/iA0Gk EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q70hg069t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 08:34:38 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33Q8X4oE021252;
        Wed, 26 Apr 2023 08:34:37 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q70hg05xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 08:34:36 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33PNY1o9023853;
        Wed, 26 Apr 2023 08:34:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3q4776sub7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 08:34:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33Q8YR7Q50725188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 08:34:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8458120049;
        Wed, 26 Apr 2023 08:34:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 490392004B;
        Wed, 26 Apr 2023 08:34:27 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 08:34:27 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v8 1/2] s390x: topology: Check the Perform Topology Function
Date:   Wed, 26 Apr 2023 10:34:25 +0200
Message-Id: <20230426083426.6806-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230426083426.6806-1-pmorel@linux.ibm.com>
References: <20230426083426.6806-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XR396dk2f_6Q05mQ03V5t6EeHL7lBGMF
X-Proofpoint-ORIG-GUID: FYPLVWXYur0Qvwc42Sc8MsRcX3jFr3KD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_03,2023-04-26_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304260078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We check that the PTF instruction is working correctly when
the cpu topology facility is available.

For KVM only, we test changing of the polarity between horizontal
and vertical and that a reset set the horizontal polarity.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/topology.c    | 191 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 195 insertions(+)
 create mode 100644 s390x/topology.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a80db53..fe77b07 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -40,6 +40,7 @@ tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
+tests += $(TEST_DIR)/topology.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/topology.c b/s390x/topology.c
new file mode 100644
index 0000000..07f1650
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,191 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CPU Topology
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/facility.h>
+#include <asm/barrier.h>
+#include <smp.h>
+#include <sclp.h>
+#include <s390x/hardware.h>
+
+#define PTF_REQ_HORIZONTAL	0
+#define PTF_REQ_VERTICAL	1
+#define PTF_CHECK		2
+#define PTF_INVALID_FUNCTION	0xff
+
+#define PTF_ERR_NO_REASON	0
+#define PTF_ERR_ALRDY_POLARIZED	1
+#define PTF_ERR_IN_PROGRESS	2
+
+extern int diag308_load_reset(u64);
+
+static int ptf(unsigned long fc, unsigned long *rc)
+{
+	int cc;
+
+	asm volatile(
+		"	ptf	%1	\n"
+		"       ipm     %0	\n"
+		"       srl     %0,28	\n"
+		: "=d" (cc), "+d" (fc)
+		:
+		: "cc");
+
+	*rc = fc >> 8;
+	return cc;
+}
+
+static void check_privilege(int fc)
+{
+	unsigned long rc;
+
+	report_prefix_push("Privilege");
+	report_info("function code %d", fc);
+	enter_pstate();
+	expect_pgm_int();
+	ptf(fc, &rc);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+static void check_specifications(void)
+{
+	unsigned long wrong_bits = 0;
+	unsigned long ptf_bits;
+	unsigned long rc;
+	int i;
+
+	report_prefix_push("Specifications");
+
+	/* Function codes above 3 are undefined */
+	for (i = 4; i < 255; i++) {
+		expect_pgm_int();
+		ptf(i, &rc);
+		mb();
+		if (lowcore.pgm_int_code != PGM_INT_CODE_SPECIFICATION) {
+			report_info("Undefined %d", i);
+			wrong_bits = 1;
+		}
+	}
+
+	report(!wrong_bits, "Undefined function codes");
+
+	/* Reserved bits must be 0 */
+	for (i = 8, wrong_bits = 0; i < 64; i++) {
+		ptf_bits = 0x01UL << i;
+		expect_pgm_int();
+		ptf(ptf_bits, &rc);
+		mb();
+		if (lowcore.pgm_int_code != PGM_INT_CODE_SPECIFICATION)
+			wrong_bits |= ptf_bits;
+	}
+
+	report(!wrong_bits, "Reserved bits: 0x%016lx", wrong_bits);
+
+	report_prefix_pop();
+}
+
+static void check_polarization_change(void)
+{
+	unsigned long rc;
+	int cc;
+
+	report_prefix_push("Polarization change");
+
+	/* We expect a clean state through reset */
+	report(diag308_load_reset(1), "load normal reset done");
+
+	/*
+	 * Set vertical polarization to verify that RESET sets
+	 * horizontal polarization back.
+	 */
+	cc = ptf(PTF_REQ_VERTICAL, &rc);
+	report(cc == 0, "Set vertical polarization.");
+
+	report(diag308_load_reset(1), "load normal reset done");
+
+	cc = ptf(PTF_CHECK, &rc);
+	report(cc == 0, "Reset should clear topology report");
+
+	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
+	       "After RESET polarization is horizontal");
+
+	/* Flip between vertical and horizontal polarization */
+	cc = ptf(PTF_REQ_VERTICAL, &rc);
+	report(cc == 0, "Change to vertical");
+
+	cc = ptf(PTF_CHECK, &rc);
+	report(cc == 1, "Should report");
+
+	cc = ptf(PTF_REQ_VERTICAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED, "Double change to vertical");
+
+	cc = ptf(PTF_CHECK, &rc);
+	report(cc == 0, "Should not report");
+
+	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
+	report(cc == 0, "Change to horizontal");
+
+	cc = ptf(PTF_CHECK, &rc);
+	report(cc == 1, "Should Report");
+
+	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED, "Double change to horizontal");
+
+	cc = ptf(PTF_CHECK, &rc);
+	report(cc == 0, "Should not report");
+
+	report_prefix_pop();
+}
+
+static void test_ptf(void)
+{
+	check_privilege(PTF_REQ_HORIZONTAL);
+	check_privilege(PTF_REQ_VERTICAL);
+	check_privilege(PTF_CHECK);
+	check_specifications();
+	check_polarization_change();
+}
+
+static struct {
+	const char *name;
+	void (*func)(void);
+} tests[] = {
+	{ "PTF", test_ptf },
+	{ NULL, NULL }
+};
+
+int main(int argc, char *argv[])
+{
+	int i;
+
+	report_prefix_push("CPU Topology");
+
+	if (!test_facility(11)) {
+		report_skip("Topology facility not present");
+		goto end;
+	}
+
+	report_info("Virtual machine level %ld", stsi_get_fc());
+
+	for (i = 0; tests[i].name; i++) {
+		report_prefix_push(tests[i].name);
+		tests[i].func();
+		report_prefix_pop();
+	}
+
+end:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b61faf0..fc3666b 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -218,3 +218,6 @@ extra_params = -append '--parallel'
 
 [execute]
 file = ex.elf
+
+[topology]
+file = topology.elf
-- 
2.31.1

