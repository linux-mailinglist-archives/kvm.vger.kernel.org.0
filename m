Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FD46C0CA0
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 09:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjCTI54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 04:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjCTI5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 04:57:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B572110263;
        Mon, 20 Mar 2023 01:57:52 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32K7ioWJ025800;
        Mon, 20 Mar 2023 08:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dE4YqiM+TRgsSSwfh3HSupRLIdO/Zs6efpew80vDpz0=;
 b=TuxjZsV/QEO62eBa+T+5K+KvUBFe02vi2srf2jASudzYNGYrC3wD7MMAsDeUDglgY1Rw
 Cf1I0RqF/1NXfmoSjEyf5sIve7GHUX8tnTYe0OBoUw9j7pmrsfBUrSHYKjAxDGX9oqv5
 lN6c8itb7Q1ZWkp3IEKt4JiV7s5t3cTFHcNZexonmZXsgf8WtlGmoqUR77r/LLbkeBe0
 WJbHzaMa3d4/MIVRf39prt0dwv7FL51dVMTlNiqxAkGmQDhUG8NQ2F/94Mw7LysSrgqJ
 WvztkSqwiROywc2VEkwFIThRLQomRFiFh/5STpV21WJSeTdbs3NBYkqSRSdxeAj65NLS ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdq56thr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:57:51 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32K8QWdu009342;
        Mon, 20 Mar 2023 08:57:51 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdq56thc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:57:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32K3W1i6016519;
        Mon, 20 Mar 2023 08:56:48 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6ay3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:56:48 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32K8ui1v9568818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 08:56:44 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8612220040;
        Mon, 20 Mar 2023 08:56:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFE062004B;
        Mon, 20 Mar 2023 08:56:43 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.19.239])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 20 Mar 2023 08:56:43 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v7 1/2] s390x: topology: Check the Perform Topology Function
Date:   Mon, 20 Mar 2023 09:56:41 +0100
Message-Id: <20230320085642.12251-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230320085642.12251-1-pmorel@linux.ibm.com>
References: <20230320085642.12251-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z-KszCGLREVMFMl4yALOH9MwWPsM7U6P
X-Proofpoint-GUID: L-5EVy-vq0FPjqsS8pkjAE-YXQx5zTGI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_04,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 s390x/topology.c    | 180 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 184 insertions(+)
 create mode 100644 s390x/topology.c

diff --git a/s390x/Makefile b/s390x/Makefile
index e94b720..05dac04 100644
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
index 0000000..ce248f1
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,180 @@
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
+#include <smp.h>
+#include <sclp.h>
+#include <s390x/hardware.h>
+
+#define PTF_REQ_HORIZONTAL	0
+#define PTF_REQ_VERTICAL	1
+#define PTF_REQ_CHECK		2
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
+static void check_function_code(void)
+{
+	unsigned long rc;
+
+	report_prefix_push("Undefined fc");
+	expect_pgm_int();
+	ptf(0xff, &rc);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+}
+
+static void check_reserved_bits(void)
+{
+	unsigned long rc;
+
+	report_prefix_push("Reserved bits");
+	expect_pgm_int();
+	ptf(0xffffffffffffff00UL, &rc);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+}
+
+static void check_mtcr_pending(void)
+{
+	unsigned long rc;
+	int cc;
+
+	report_prefix_push("Topology Report pending");
+	/*
+	 * At this moment the topology may already have changed
+	 * since the VM has been started.
+	 * However, we can test if a second PTF instruction
+	 * reports that the topology did not change since the
+	 * preceding PFT instruction.
+	 */
+	ptf(PTF_REQ_CHECK, &rc);
+	cc = ptf(PTF_REQ_CHECK, &rc);
+	report(cc == 0, "PTF check should clear topology report");
+	report_prefix_pop();
+}
+
+static void check_polarization_change(void)
+{
+	unsigned long rc;
+	int cc;
+
+	report_prefix_push("Topology polarization check");
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
+	cc = ptf(PTF_REQ_CHECK, &rc);
+	report(cc == 0, "Reset should clear topology report");
+
+	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
+	       "After RESET polarization is horizontal");
+
+	/* Flip between vertical and horizontal polarization */
+	cc = ptf(PTF_REQ_VERTICAL, &rc);
+	report(cc == 0, "Change to vertical polarization.");
+
+	cc = ptf(PTF_REQ_CHECK, &rc);
+	report(cc == 1, "Polarization change should set topology report");
+
+	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
+	report(cc == 0, "Change to horizontal polarization.");
+
+	report_prefix_pop();
+}
+
+static void test_ptf(void)
+{
+	check_privilege(PTF_REQ_HORIZONTAL);
+	check_privilege(PTF_REQ_VERTICAL);
+	check_privilege(PTF_REQ_CHECK);
+	check_function_code();
+	check_reserved_bits();
+	check_mtcr_pending();
+	check_polarization_change();
+}
+
+static struct {
+	const char *name;
+	void (*func)(void);
+} tests[] = {
+	{ "PTF", test_ptf},
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
index 453ee9c..d0ac683 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -233,3 +233,6 @@ extra_params = -append '--parallel'
 
 [execute]
 file = ex.elf
+
+[topology]
+file = topology.elf
-- 
2.31.1

