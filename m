Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB92489A13
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 14:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiAJNge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 08:36:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232684AbiAJNg2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 08:36:28 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ACQDuV017141;
        Mon, 10 Jan 2022 13:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+6eDJhZZ5+ZbeRDQj0QMF1dV5t8mJkiop2bLNgsz3aI=;
 b=s8d+u2TWOSwBFqsai3jULkXYHjLd2SvbJl7ftHpPTfvdpGgAIGt48hEh/dWx18SEd142
 6dsrpDt8c30dlHPfdd0bzu2BHSItz7SCazAaWq19M+tU2wXu/+L0D41H6hYinS6cFW6d
 /0HlEUPMyAGeBmTvCdpEyKZdxbigv1FsRHjvFPACpvaafPyhnAUdd2f8h+gOrn19ZqSe
 UAeOsQuaMTz+rmVyA8CFXqPEimxF+RJN6jrB/OB0Ia1AX0o49qSIIjQa7sRzSlQI1vaa
 2JaVbnF6sHS/ntcVj6qi/V1g+J+ZDpqTwTMRGwoaU2UfU5eVQ3Z07ZgavH9tSH9rMXRR uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfmpmtu45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:28 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ADS8Zh017834;
        Mon, 10 Jan 2022 13:36:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfmpmtu3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ADVpgF003072;
        Mon, 10 Jan 2022 13:36:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vhnctk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ADaMYM40501566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 13:36:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 348EF420FC;
        Mon, 10 Jan 2022 13:36:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2A394205F;
        Mon, 10 Jan 2022 13:36:21 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.85.190])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jan 2022 13:36:21 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/4] s390x: stsi: Define vm_is_kvm to be used in different tests
Date:   Mon, 10 Jan 2022 14:37:53 +0100
Message-Id: <20220110133755.22238-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110133755.22238-1-pmorel@linux.ibm.com>
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rq8VkT1H9KLM_gNfdyy8vVqVWi1ArW9D
X-Proofpoint-ORIG-GUID: 48zkHcp9T7LncupOFvYrHCIpXxEge32k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_06,2022-01-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201100095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need in several tests to check if the VM we are running in
is KVM.
Let's add the test.

To check the VM type we use the STSI 3.2.2 instruction, let's
define it's response structure in a central header.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++++
 lib/s390x/vm.c   | 39 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/vm.h   |  1 +
 s390x/stsi.c     | 23 ++---------------------
 4 files changed, 74 insertions(+), 21 deletions(-)
 create mode 100644 lib/s390x/stsi.h

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
new file mode 100644
index 00000000..02cc94a6
--- /dev/null
+++ b/lib/s390x/stsi.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Structures used to Store System Information
+ *
+ * Copyright (c) 2021 IBM Inc
+ */
+
+#ifndef _S390X_STSI_H_
+#define _S390X_STSI_H_
+
+struct sysinfo_3_2_2 {
+	uint8_t reserved[31];
+	uint8_t count;
+	struct {
+		uint8_t reserved2[4];
+		uint16_t total_cpus;
+		uint16_t conf_cpus;
+		uint16_t standby_cpus;
+		uint16_t reserved_cpus;
+		uint8_t name[8];
+		uint32_t caf;
+		uint8_t cpi[16];
+		uint8_t reserved5[3];
+		uint8_t ext_name_encoding;
+		uint32_t reserved3;
+		uint8_t uuid[16];
+	} vm[8];
+	uint8_t reserved4[1504];
+	uint8_t ext_names[8][256];
+};
+
+#endif  /* _S390X_STSI_H_ */
diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
index a5b92863..3e11401e 100644
--- a/lib/s390x/vm.c
+++ b/lib/s390x/vm.c
@@ -12,6 +12,7 @@
 #include <alloc_page.h>
 #include <asm/arch_def.h>
 #include "vm.h"
+#include "stsi.h"
 
 /**
  * Detect whether we are running with TCG (instead of KVM)
@@ -43,3 +44,41 @@ out:
 	free_page(buf);
 	return is_tcg;
 }
+
+/**
+ * Detect whether we are running with KVM
+ */
+
+bool vm_is_kvm(void)
+{
+	/* EBCDIC for "KVM/" */
+	const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
+	static bool initialized;
+	static bool is_kvm;
+	struct sysinfo_3_2_2 *stsi_322;
+
+	if (initialized)
+		return is_kvm;
+
+	if (stsi_get_fc() < 3) {
+		initialized = true;
+		return is_kvm;
+	}
+
+	stsi_322 = alloc_page();
+	if (!stsi_322)
+		return false;
+
+	if (stsi(stsi_322, 3, 2, 2))
+		goto out;
+
+	/*
+	 * If the manufacturer string is "KVM/" in EBCDIC, then we
+	 * are on KVM (otherwise the string is "IBM" in EBCDIC)
+	 */
+	is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, sizeof(kvm_ebcdic));
+	initialized = true;
+out:
+	free_page(stsi_322);
+	return is_kvm;
+}
diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
index 7abba0cc..44097b4a 100644
--- a/lib/s390x/vm.h
+++ b/lib/s390x/vm.h
@@ -9,5 +9,6 @@
 #define _S390X_VM_H_
 
 bool vm_is_tcg(void);
+bool vm_is_kvm(void);
 
 #endif  /* _S390X_VM_H_ */
diff --git a/s390x/stsi.c b/s390x/stsi.c
index 391f8849..1ed045e2 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -13,27 +13,8 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <smp.h>
+#include "stsi.h"
 
-struct stsi_322 {
-	uint8_t reserved[31];
-	uint8_t count;
-	struct {
-		uint8_t reserved2[4];
-		uint16_t total_cpus;
-		uint16_t conf_cpus;
-		uint16_t standby_cpus;
-		uint16_t reserved_cpus;
-		uint8_t name[8];
-		uint32_t caf;
-		uint8_t cpi[16];
-		uint8_t reserved5[3];
-		uint8_t ext_name_encoding;
-		uint32_t reserved3;
-		uint8_t uuid[16];
-	} vm[8];
-	uint8_t reserved4[1504];
-	uint8_t ext_names[8][256];
-};
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
 static void test_specs(void)
@@ -91,7 +72,7 @@ static void test_3_2_2(void)
 	/* EBCDIC for "KVM/" */
 	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
 	const char vm_name_ext[] = "kvm-unit-test";
-	struct stsi_322 *data = (void *)pagebuf;
+	struct sysinfo_3_2_2 *data = (void *)pagebuf;
 
 	report_prefix_push("3.2.2");
 
-- 
2.27.0

