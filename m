Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6115709672
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 13:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjESLW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 07:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjESLWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 07:22:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87B510EC;
        Fri, 19 May 2023 04:22:45 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JB4Q03032647;
        Fri, 19 May 2023 11:22:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hRINxzRqY/j0nLSlVpD/PoCEzJihz/npp8Y0usd0ReQ=;
 b=lt/1D+j7imYxHfq1WOvJUnkGspjpK6UAGqL9t6umv68KCDWY82iJGpJjYM0/uaukbwnj
 EiiX0nT+UY7GLr33NWh6l6kzjeIL8ggp/bng4QXGJJtJ7HT6ClGUz4d29NKOEnGQlDaU
 IfLLduyVSzChPaQZoD0cX6G5s548Uqy1AcTyyVeuz0yfxKOlPA9setLippJ5Ni8KbMWx
 D9au8Con2S9kBlAkXZ68tntz//2MgtgyOXu18yS5CuHzPLjm/n4+jjHoOtEGZIjbBb2n
 5cUIBNjCHsKgLxGKX7xWBo2OTH8xjYgvnJvQZbXq2PJE3wuR5OaKySqQBQmofkWLzhX0 eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qp7wu8r7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 11:22:44 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34JB5EOT003607;
        Fri, 19 May 2023 11:22:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qp7wu8r7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 11:22:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34JALYf9019841;
        Fri, 19 May 2023 11:22:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qj264u4x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 11:22:42 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34JBMcEY5505538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 11:22:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D35FB20043;
        Fri, 19 May 2023 11:22:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A9DD20040;
        Fri, 19 May 2023 11:22:38 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.54.120])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 19 May 2023 11:22:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v9 1/2] s390x: topology: Check the Perform Topology Function
Date:   Fri, 19 May 2023 13:22:35 +0200
Message-Id: <20230519112236.14332-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230519112236.14332-1-pmorel@linux.ibm.com>
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V3JoObmvrtR0HfMunMyrtP1Lfb1h5iN4
X-Proofpoint-GUID: _Vhiguvrpom_z4T8khWcue2Pk_xTmNh_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_07,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305190094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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
 s390x/topology.c    | 189 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 193 insertions(+)
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
index 0000000..2acede0
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,189 @@
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

