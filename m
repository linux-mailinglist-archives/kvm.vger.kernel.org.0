Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2537D3E7D6A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 18:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbhHJQW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 12:22:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234293AbhHJQWz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 12:22:55 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17AG40o1006620;
        Tue, 10 Aug 2021 12:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=o57hKOOtHquwxKzlL0ZvhltuG65ddbN1taFK0tPSLn4=;
 b=JzX2d93UODyNjcUBiet710YveGi+mRqGAn0LgWxqzvqvB7nkH4l8HU0yQOj1F2JSCRqv
 K9+Ryz1x+6cJVw1afABJu/Hjd043VXaR0d2x7gnRBodK1musnCXoqHimsLb+O38oIk0T
 hAr/WX+JGOCD4T/D/4B3wY8a5ALThm7CCmGrtQrZNFm3hb0cIJdqAjZPF6OGvV9t94fX
 UzimmcFo0PHrAxSTuzuOjbcKmXcdxng/KXaSSxAkPFph3oDHgbvAkpqDBbTn2yXAIrhV
 UJ4p835c4FTKaKDKeGMeVS9QQ2uDaGlsAqyzkgSlMLAYFVgsn0JSNtbHlVbjIqR6+TFX Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abb7pamtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:22:32 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17AG42Ji006774;
        Tue, 10 Aug 2021 12:22:32 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abb7pamtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:22:32 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17AGGXMY001233;
        Tue, 10 Aug 2021 16:22:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8xe2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 16:22:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17AGJF3b59638098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 16:19:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26899AE05A;
        Tue, 10 Aug 2021 16:22:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD93DAE056;
        Tue, 10 Aug 2021 16:22:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.176.19])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Aug 2021 16:22:26 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/4] s390x: topology: Check the Perform Topology Function
Date:   Tue, 10 Aug 2021 18:22:23 +0200
Message-Id: <1628612544-25130-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LUKBq9s7EQBYiaI4_DR8q-VNBzHq_3vr
X-Proofpoint-GUID: eJAjnefmmU9VHc8IjyA9RzR4lCYfvpAz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_07:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 suspectscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100103
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
 s390x/Makefile      |  1 +
 s390x/topology.c    | 99 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  3 ++
 3 files changed, 103 insertions(+)
 create mode 100644 s390x/topology.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 6565561b..c82b7dbf 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
+tests += $(TEST_DIR)/topology.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/topology.c b/s390x/topology.c
new file mode 100644
index 00000000..a0dc3b9e
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,99 @@
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
+
+static int machine_level;
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
+	report(cc == 0, "PTF check clear");
+
+	/*
+	 * In the LPAR we can not assume the state of the polarizatiom
+	 * at this moment.
+	 * Let's skip the tests for LPAR.
+	 */
+	if (machine_level < 3)
+		goto end;
+
+	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
+	       "PTF horizontal already configured");
+
+	cc = ptf(PTF_REQ_VERTICAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_NO_REASON,
+	       "PTF vertical non possible");
+
+end:
+	report_prefix_pop();
+}
+
+int main(int argc, char *argv[])
+{
+	report_prefix_push("CPU Topology");
+
+	if (!test_facility(11)) {
+		report_skip("Topology facility not present");
+		goto end;
+	}
+
+	machine_level = stsi_get_fc();
+	report_info("Machine level %d", machine_level);
+
+	test_ptf();
+
+end:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9e1802fd..0f84d279 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -109,3 +109,6 @@ file = edat.elf
 
 [mvpg-sie]
 file = mvpg-sie.elf
+
+[topology]
+file = topology.elf
-- 
2.25.1

