Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6492774F195
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbjGKORM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjGKORB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:17:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8845619B5
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:46 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEGCEt009972;
        Tue, 11 Jul 2023 14:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=czcHP0OZs7yDTSwPOAR3mpy/V8UabklBvFiilwW5IW4=;
 b=Li6Ggdqc+UoCJzbYe8goJEHfYRDdVdYp9F+QvSX3vXPlyR0PN0Mo8bPItidBBtknMfFv
 KoVloOon5+Bwm7vb9dVphjOXVD18BE9L4KqzS8tvEWWaTq2e3+ejJhp6DjHaR3uXXcG6
 SfWeH15jNxoP2KHNDcKtoLfQ+fLqeGoE+ZS2yO67Q1UFJBSTqG3mGhIdSKBlAYwxdb1B
 bc7y8J+7Oy2q+Z8VhZBHK4IKFK5ix9yhzFfG1mcNRFV/R81kJ6kx8DRMkZfalaqaVVd4
 F68mPAw5TKFSe55lvuumvigVTSGky4yhYemjx+fOEQznnOy9vkGxaNIIKY19Z/9/mV6+ zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8de0r9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:42 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BE6Ked026441;
        Tue, 11 Jul 2023 14:16:36 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8de0qys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BCFmhF015101;
        Tue, 11 Jul 2023 14:16:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3rpye5hcj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGNTW17957388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F30742004B;
        Tue, 11 Jul 2023 14:16:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72FB320040;
        Tue, 11 Jul 2023 14:16:22 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [PATCH 21/22] s390x: topology: Check the Perform Topology Function
Date:   Tue, 11 Jul 2023 16:15:54 +0200
Message-ID: <20230711141607.40742-22-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tBY9LupMJMUB3zd0SU97bV35EYkvWBxp
X-Proofpoint-GUID: kaes2aFSpfcbqga0_RASL2JuWiHp5hs7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=974 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

We check that the PTF instruction is working correctly when
the cpu topology facility is available.

For KVM only, we test changing of the polarity between horizontal
and vertical and that a reset set the horizontal polarity.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230627082155.6375-2-pmorel@linux.ibm.com
[ nrb: replace snprintf/report_prefix_push with report_prefix_pushf ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/topology.c    | 188 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 192 insertions(+)
 create mode 100644 s390x/topology.c

diff --git a/s390x/Makefile b/s390x/Makefile
index b5b9481..706be79 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -40,6 +40,7 @@ tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
+tests += $(TEST_DIR)/topology.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
diff --git a/s390x/topology.c b/s390x/topology.c
new file mode 100644
index 0000000..79f667f
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,188 @@
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
+	report_prefix_pushf("Privileged fc %d", fc);
+	enter_pstate();
+	expect_pgm_int();
+	ptf(fc, &rc);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+static void check_specifications(void)
+{
+	unsigned long error = 0;
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
+		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("FC %d did not yield specification exception", i);
+			error = 1;
+		}
+	}
+	report(!error, "Undefined function codes");
+
+	/* Reserved bits must be 0 */
+	for (i = 8, error = 0; i < 64; i++) {
+		ptf_bits = 0x01UL << i;
+		expect_pgm_int();
+		ptf(ptf_bits, &rc);
+		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("Reserved bit %d did not yield specification exception", i);
+			error = 1;
+		}
+	}
+
+	report(!error, "Reserved bits");
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
index b081345..5898879 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -240,3 +240,6 @@ file = uv-host.elf
 smp = 2
 groups = pv-host
 extra_params = -m 2200
+
+[topology]
+file = topology.elf
-- 
2.41.0

