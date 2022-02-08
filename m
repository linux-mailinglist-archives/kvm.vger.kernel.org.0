Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FF44AD9D8
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244512AbiBHN30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358129AbiBHN24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:28:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D3FC02B670;
        Tue,  8 Feb 2022 05:25:13 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218DLfsm030208;
        Tue, 8 Feb 2022 13:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iqMfi4/Um3zz30y/bZBcoTmd1DqIdBgSnuSyvfWTVJk=;
 b=VtQT+qSXODbzWzzhU6VaH94OdEtLu7OfvLZMn2NI+yqRNbzR3tOTFppPHy2ySME0WT34
 LfJ4sVh7B1SMSxR7gjn5OJfiuZJHYJTaWg7ZqTGAn80PTSVuF2wg4e2blggEI7XehqOc
 cvfHMZ4hXQEv67oDbZvCxQVnZKifxESyXreiiEg6KKGeAawiCFIrlWvdz60Hjsm8tMyZ
 vgmFNP4DWZ5eqmm2v2y6fINs985eiO06nSsq3QXygxo9y5OI/3YlpJoXoIYb98mxu/ec
 3SSmN31IUmPBjSocI1ImC9B4tVLLJJe4n19BwXfS/c+C5uY9DSfe3CxyGNdzAgyJZr7W hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u3pvgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:13 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218DMQn5006176;
        Tue, 8 Feb 2022 13:25:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u3pvg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218DFmat012139;
        Tue, 8 Feb 2022 13:25:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv95yve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218DP7Ft30671206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 13:25:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1864742045;
        Tue,  8 Feb 2022 13:25:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A58FD42041;
        Tue,  8 Feb 2022 13:25:06 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.71.76])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 13:25:06 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 3/4] s390x: topology: Check the Perform Topology Function
Date:   Tue,  8 Feb 2022 14:27:08 +0100
Message-Id: <20220208132709.48291-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208132709.48291-1-pmorel@linux.ibm.com>
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3F__EsoiV_o36UgaO4sr9h-SiNBvu1HN
X-Proofpoint-ORIG-GUID: MxkIlSsePFtueNldi9rOCRybbsvHCoQ_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We check the PTF instruction.

- We do not expect to support vertical polarization.

- We do not expect the Modified Topology Change Report to be
pending or not at the moment the first PTF instruction with
PTF_CHECK function code is done as some code already did run
a polarization change may have occur.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/topology.c    | 115 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 ++
 3 files changed, 119 insertions(+)
 create mode 100644 s390x/topology.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 53b0fe04..d833d6a3 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -26,6 +26,7 @@ tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
 tests += $(TEST_DIR)/firq.elf
+tests += $(TEST_DIR)/topology.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/topology.c b/s390x/topology.c
new file mode 100644
index 00000000..a1f9ce51
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,115 @@
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
+#include <s390x/vm.h>
+
+#define PTF_REQ_HORIZONTAL	0
+#define PTF_REQ_VERTICAL	1
+#define PTF_REQ_CHECK		2
+
+#define PTF_ERR_NO_REASON	0
+#define PTF_ERR_ALRDY_POLARIZED	1
+#define PTF_ERR_IN_PROGRESS	2
+
+static int ptf(unsigned long fc, unsigned long *rc)
+{
+	int cc;
+
+	asm volatile(
+		"       .insn   rre,0xb9a20000,%1,0\n"
+		"       ipm     %0\n"
+		"       srl     %0,28\n"
+		: "=d" (cc), "+d" (fc)
+		: "d" (fc)
+		: "cc");
+
+	*rc = fc >> 8;
+	return cc;
+}
+
+static void test_ptf(void)
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
+
+	report_prefix_pop();
+
+	report_prefix_push("Topology polarisation check");
+	/*
+	 * We can not assume the state of the polarization for
+	 * any Virtual Machine but KVM.
+	 * Let's skip the polarisation tests for other VMs.
+	 */
+	if (!vm_is_kvm()) {
+		report_skip("Topology polarisation check is done for KVM only");
+		goto end;
+	}
+
+	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
+	       "KVM always provides horizontal polarization");
+
+	cc = ptf(PTF_REQ_VERTICAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_NO_REASON,
+	       "KVM doesn't support vertical polarization.");
+
+end:
+	report_prefix_pop();
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
+	report_info("Machine level %ld", stsi_get_fc());
+
+	for (i = 0; tests[i].name; i++) {
+		report_prefix_push(tests[i].name);
+		tests[i].func();
+		report_prefix_pop();
+	}
+end:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 054560c2..e2d3e6a5 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -122,3 +122,6 @@ extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -devi
 file = firq.elf
 timeout = 20
 extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
+
+[topology]
+file = topology.elf
-- 
2.27.0

