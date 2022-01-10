Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051B6489A14
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 14:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbiAJNgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 08:36:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43650 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232695AbiAJNg3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 08:36:29 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AD8njD004946;
        Mon, 10 Jan 2022 13:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7l9w43eciHW/7pwNGCg4r56eLxTk7fUqfwWUc9AkAfM=;
 b=qWxZQqoUGpMa/QBeHaLX5HC8zMpx2o7SDnPItX3yG/bmeP5NwfGScLERyx6CGM0mrxue
 HRIqN/GiBjYIcQPSmp8e8Exap4t1fEqWVE06rrC1fUqsKiIs/LEJD/ZNgh925o5rcJQt
 Mbt06h4UBz/kMXIk/f4yEOZ9NwW5sgFk4mTxVzVlI/P+AI3O9rImm2/nZnnQdnMOfMCd
 Wa73f57lIrHkSmrhH3Dgi+uhyZQ+g7wnrsn3AmNBf4wgzWqxAHy1VTjLczKEgYFWns5p
 pE3Rsyd/sMKvOqZ6TTxUEAyclncNSXfCWV20XX2OdvdtIjhgKdZPV0F+lLHtIMPszgBv ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfm8jjj93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:28 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ADK5EY009276;
        Mon, 10 Jan 2022 13:36:27 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfm8jjj8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:27 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ADVu3F026104;
        Mon, 10 Jan 2022 13:36:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3df1vj4ndy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ADaMZX22282520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 13:36:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABD20420A2;
        Mon, 10 Jan 2022 13:36:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4758642070;
        Mon, 10 Jan 2022 13:36:22 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.85.190])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jan 2022 13:36:22 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/4] s390x: topology: Check the Perform Topology Function
Date:   Mon, 10 Jan 2022 14:37:54 +0100
Message-Id: <20220110133755.22238-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110133755.22238-1-pmorel@linux.ibm.com>
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GCknx6K31hiAcyAInyhwRX6SbZ-3imcz
X-Proofpoint-GUID: zW-BH0JwPhPIgLxoz-YBBYwq5j0Q-1W9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_06,2022-01-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100095
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
index 1e567c11..fa21a882 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -26,6 +26,7 @@ tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
 tests += $(TEST_DIR)/firq.elf
+tests += $(TEST_DIR)/topology.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/topology.c b/s390x/topology.c
new file mode 100644
index 00000000..a227555e
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CPU Topology
+ *
+ * Copyright (c) 2021 IBM Corp
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

