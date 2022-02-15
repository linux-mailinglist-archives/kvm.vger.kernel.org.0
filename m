Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41914B69A2
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 11:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbiBOKok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 05:44:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbiBOKoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 05:44:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39F7AFF4D;
        Tue, 15 Feb 2022 02:44:27 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FAfoXd034682;
        Tue, 15 Feb 2022 10:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qJxxlQJltRTVWdHNOxgBFrc7u81S6EYyQuIlDcO1rSo=;
 b=A9eP4W12z9rKaKcmXw6OxZzH5Y8Eh55bqeCeUISP+78Ym+h70zaYbi7mFXTwUyl5Isw+
 NB8cEDQtKgBxQAquNX9AgwWWtl2vJAubz0tnkZhZEizF1fcUdQ4DYQd6aqB4q0R1ZeNJ
 plZaWBuPMnv0S8bhw9fwmKC9Kv75DCtjkM2GXzgsSw3NaH6rwD86i8KmwuM60p1FdTqi
 IVTrVCGEpKKJ3xBXAEvGBT4U5CvJwBgejLFFew6WqlrEEKa8JR006Oz/QZRRO6xkFqHX
 Wf+AZvbcOBOHSnAZgFV0GKgLAv7AYXNJFI0ItrHgyeJCKMI9V8bUoPL/r9mDE3P4ajsI 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8an601ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:44:27 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FAiQx8040937;
        Tue, 15 Feb 2022 10:44:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8an601jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:44:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FAgRdJ006237;
        Tue, 15 Feb 2022 10:44:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645jp681-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:44:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FAY0YV45351264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 10:34:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 411D54204B;
        Tue, 15 Feb 2022 10:44:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D095B42042;
        Tue, 15 Feb 2022 10:44:20 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.31.140])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 10:44:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/1] s390x: stsi: Define vm_is_kvm to be used in different tests
Date:   Tue, 15 Feb 2022 11:46:32 +0100
Message-Id: <20220215104632.47796-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215104632.47796-1-pmorel@linux.ibm.com>
References: <20220215104632.47796-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u-kpmC9lMc4-7zVQywwsujx7qS7thONw
X-Proofpoint-GUID: 1SiuCmjcunWDZh6mV7zuluuY6BFWi2Uy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_03,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=817
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 malwarescore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202150059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several tests are in need of a way to check on which hypervisor
and virtualization level they are running on to be able to fence
certain tests. This patch adds functions that return true if a
vm is running under KVM, LPAR or generally as a level 2 guest.

To check if we're running under KVM we use the STSI 3.2.2
instruction, let's define it's response structure in a central
header.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++
 lib/s390x/vm.c   | 55 ++++++++++++++++++++++++++++++++++++++++++++++--
 lib/s390x/vm.h   |  3 +++
 s390x/stsi.c     | 23 ++------------------
 4 files changed, 90 insertions(+), 23 deletions(-)
 create mode 100644 lib/s390x/stsi.h

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
new file mode 100644
index 00000000..bebc492d
--- /dev/null
+++ b/lib/s390x/stsi.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Structures used to Store System Information
+ *
+ * Copyright IBM Corp. 2022
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
index a5b92863..91acd05b 100644
--- a/lib/s390x/vm.c
+++ b/lib/s390x/vm.c
@@ -12,6 +12,7 @@
 #include <alloc_page.h>
 #include <asm/arch_def.h>
 #include "vm.h"
+#include "stsi.h"
 
 /**
  * Detect whether we are running with TCG (instead of KVM)
@@ -26,9 +27,13 @@ bool vm_is_tcg(void)
 	if (initialized)
 		return is_tcg;
 
+	if (!vm_is_vm()) {
+		initialized = true;
+		return is_tcg;
+	}
+
 	buf = alloc_page();
-	if (!buf)
-		return false;
+	assert(buf);
 
 	if (stsi(buf, 1, 1, 1))
 		goto out;
@@ -43,3 +48,49 @@ out:
 	free_page(buf);
 	return is_tcg;
 }
+
+/**
+ * Detect whether we are running with KVM
+ */
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
+	if (!vm_is_vm() || vm_is_tcg()) {
+		initialized = true;
+		return is_kvm;
+	}
+
+	stsi_322 = alloc_page();
+	assert(stsi_322);
+
+	if (stsi(stsi_322, 3, 2, 2))
+		goto out;
+
+	/*
+	 * If the manufacturer string is "KVM/" in EBCDIC, then we
+	 * are on KVM.
+	 */
+	is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, sizeof(kvm_ebcdic));
+	initialized = true;
+out:
+	free_page(stsi_322);
+	return is_kvm;
+}
+
+bool vm_is_lpar(void)
+{
+	return stsi_get_fc() == 2;
+}
+
+bool vm_is_vm(void)
+{
+	return stsi_get_fc() == 3;
+}
diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
index 7abba0cc..3aaf76af 100644
--- a/lib/s390x/vm.h
+++ b/lib/s390x/vm.h
@@ -9,5 +9,8 @@
 #define _S390X_VM_H_
 
 bool vm_is_tcg(void);
+bool vm_is_kvm(void);
+bool vm_is_vm(void);
+bool vm_is_lpar(void);
 
 #endif  /* _S390X_VM_H_ */
diff --git a/s390x/stsi.c b/s390x/stsi.c
index 391f8849..dccc53e7 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -13,27 +13,8 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <smp.h>
+#include <stsi.h>
 
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

