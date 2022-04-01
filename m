Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733E84EEC3F
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345431AbiDALTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345455AbiDALSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E54187B8E
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:42 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231BDqg8005595
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fCJNq6maFgrcKbEcQ4jHn2HBAEZs7i5re9R/P+N3/1g=;
 b=k82q3jVIi6WYCfWITRTQbHChFNIeJy3PlSDuPCyWffBGNsV5e32iMjovQpxVXa/WM1mi
 VSee1uPxHcnqvDbIrxTdtba6cZLmWtE3yzKufljIUzu+u1Nyo2TVnufxQPK9pb/eO2qB
 4MBPpeYzo6ffK0O60F0UKjpaKICnAjoajQIQuYsfg6Zl2QicdqdfhPn3emEFnBdXMbfE
 W9+tAAScWBOJzTmrD2XbB3BI1or1c1Hm1q3+hIntRc+cAtxyN1cVUpHW/Bp8a0+Kym/H
 N2E8dvMnYQAub+Yd7AYftRB+q7SqRFj1QQ0h6r26Z1XW3HFZZHLC3wmer5EAGgjjdTfI iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5wpv3k93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231Avrsn008468
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:41 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5wpv3k8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B90DL028416;
        Fri, 1 Apr 2022 11:16:39 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf94v6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGaZm27001298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 799194C064;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AF954C040;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 25/27] lib: s390x: rename and refactor vm.[ch]
Date:   Fri,  1 Apr 2022 13:16:18 +0200
Message-Id: <20220401111620.366435-26-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dwnd0cSsK7BKncIZ7GIvi9NyvVO08E7n
X-Proofpoint-GUID: DfJOAo8spNjuTa2BzSQcSiifOODUwB_h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor and rename vm.[ch] to hardware.[ch]

* Rename vm.[ch] to hardware.[ch]
* Consolidate all detection functions into detect_host, which returns
  what host system the test is running on
* Rename vm_is_* functions to host_is_*, which are then just wrappers
  around detect_host

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile       |  2 +-
 lib/s390x/hardware.h | 40 +++++++++++++++++++
 lib/s390x/vm.h       | 15 --------
 lib/s390x/hardware.c | 69 +++++++++++++++++++++++++++++++++
 lib/s390x/vm.c       | 92 --------------------------------------------
 s390x/cpumodel.c     |  4 +-
 s390x/epsw.c         |  4 +-
 s390x/mvpg.c         |  4 +-
 8 files changed, 116 insertions(+), 114 deletions(-)
 create mode 100644 lib/s390x/hardware.h
 delete mode 100644 lib/s390x/vm.h
 create mode 100644 lib/s390x/hardware.c
 delete mode 100644 lib/s390x/vm.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 93475972..8ff84db5 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -81,7 +81,7 @@ cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
-cflatobjs += lib/s390x/vm.o
+cflatobjs += lib/s390x/hardware.o
 cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
new file mode 100644
index 00000000..e5910ea5
--- /dev/null
+++ b/lib/s390x/hardware.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Functions to retrieve information about the host system.
+ *
+ * Copyright (c) 2020 Red Hat Inc
+ * Copyright 2022 IBM Corp.
+ *
+ * Authors:
+ *  Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#ifndef _S390X_HARDWARE_H_
+#define _S390X_HARDWARE_H_
+#include <asm/arch_def.h>
+
+enum s390_host {
+	HOST_IS_UNKNOWN,
+	HOST_IS_LPAR,
+	HOST_IS_KVM,
+	HOST_IS_TCG
+};
+
+enum s390_host detect_host(void);
+
+static inline bool host_is_tcg(void)
+{
+	return detect_host() == HOST_IS_TCG;
+}
+
+static inline bool host_is_kvm(void)
+{
+	return detect_host() == HOST_IS_KVM;
+}
+
+static inline bool host_is_lpar(void)
+{
+	return detect_host() == HOST_IS_LPAR;
+}
+
+#endif  /* _S390X_HARDWARE_H_ */
diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
deleted file mode 100644
index 4456b48c..00000000
--- a/lib/s390x/vm.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Functions to retrieve VM-specific information
- *
- * Copyright (c) 2020 Red Hat Inc
- */
-
-#ifndef _S390X_VM_H_
-#define _S390X_VM_H_
-
-bool vm_is_tcg(void);
-bool vm_is_kvm(void);
-bool vm_is_lpar(void);
-
-#endif  /* _S390X_VM_H_ */
diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
new file mode 100644
index 00000000..2bcf9c4c
--- /dev/null
+++ b/lib/s390x/hardware.c
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Functions to retrieve information about the host system.
+ *
+ * Copyright (c) 2020 Red Hat Inc
+ * Copyright 2022 IBM Corp.
+ *
+ * Authors:
+ *  Thomas Huth <thuth@redhat.com>
+ *  Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/arch_def.h>
+#include "hardware.h"
+#include "stsi.h"
+
+/* The string "QEMU" in EBCDIC */
+static const uint8_t qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
+/* The string "KVM/" in EBCDIC */
+static const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
+
+static enum s390_host do_detect_host(void *buf)
+{
+	struct sysinfo_3_2_2 *stsi_322 = buf;
+
+	if (stsi_get_fc() == 2)
+		return HOST_IS_LPAR;
+
+	if (stsi_get_fc() != 3)
+		return HOST_IS_UNKNOWN;
+
+	if (!stsi(buf, 1, 1, 1)) {
+		/*
+		 * If the manufacturer string is "QEMU" in EBCDIC, then we
+		 * are on TCG (otherwise the string is "IBM" in EBCDIC)
+		 */
+		if (!memcmp((char *)buf + 32, qemu_ebcdic, sizeof(qemu_ebcdic)))
+			return HOST_IS_TCG;
+	}
+
+	if (!stsi(buf, 3, 2, 2)) {
+		/*
+		 * If the manufacturer string is "KVM/" in EBCDIC, then we
+		 * are on KVM.
+		 */
+		if (!memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, sizeof(kvm_ebcdic)))
+			return HOST_IS_KVM;
+	}
+
+	return HOST_IS_UNKNOWN;
+}
+
+enum s390_host detect_host(void)
+{
+	static enum s390_host host = HOST_IS_UNKNOWN;
+	static bool initialized = false;
+	void *buf;
+
+	if (initialized)
+		return host;
+
+	buf = alloc_page();
+	host = do_detect_host(buf);
+	free_page(buf);
+	initialized = true;
+	return host;
+}
diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
deleted file mode 100644
index 33fb1c45..00000000
--- a/lib/s390x/vm.c
+++ /dev/null
@@ -1,92 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Functions to retrieve VM-specific information
- *
- * Copyright (c) 2020 Red Hat Inc
- *
- * Authors:
- *  Thomas Huth <thuth@redhat.com>
- */
-
-#include <libcflat.h>
-#include <alloc_page.h>
-#include <asm/arch_def.h>
-#include "vm.h"
-#include "stsi.h"
-
-/**
- * Detect whether we are running with TCG (instead of KVM)
- */
-bool vm_is_tcg(void)
-{
-	const char qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
-	static bool initialized = false;
-	static bool is_tcg = false;
-	uint8_t *buf;
-
-	if (initialized)
-		return is_tcg;
-
-	if (stsi_get_fc() != 3) {
-		initialized = true;
-		return is_tcg;
-	}
-
-	buf = alloc_page();
-	assert(buf);
-
-	if (stsi(buf, 1, 1, 1))
-		goto out;
-
-	/*
-	 * If the manufacturer string is "QEMU" in EBCDIC, then we
-	 * are on TCG (otherwise the string is "IBM" in EBCDIC)
-	 */
-	is_tcg = !memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic));
-	initialized = true;
-out:
-	free_page(buf);
-	return is_tcg;
-}
-
-/**
- * Detect whether we are running with KVM
- */
-bool vm_is_kvm(void)
-{
-	/* EBCDIC for "KVM/" */
-	const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
-	static bool initialized;
-	static bool is_kvm;
-	struct sysinfo_3_2_2 *stsi_322;
-
-	if (initialized)
-		return is_kvm;
-
-	if (stsi_get_fc() != 3 || vm_is_tcg()) {
-		initialized = true;
-		return is_kvm;
-	}
-
-	stsi_322 = alloc_page();
-	assert(stsi_322);
-
-	if (stsi(stsi_322, 3, 2, 2))
-		goto out;
-
-	/*
-	 * If the manufacturer string is "KVM/" in EBCDIC, then we
-	 * are on KVM.
-	 */
-	is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, sizeof(kvm_ebcdic));
-	initialized = true;
-out:
-	free_page(stsi_322);
-	return is_kvm;
-}
-
-bool vm_is_lpar(void)
-{
-	return stsi_get_fc() == 2;
-}
-
diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 23ccf842..5c0b73e0 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -10,7 +10,7 @@
  */
 
 #include <asm/facility.h>
-#include <vm.h>
+#include <hardware.h>
 #include <sclp.h>
 #include <uv.h>
 #include <asm/uv.h>
@@ -118,7 +118,7 @@ int main(void)
 	for (i = 0; i < ARRAY_SIZE(dep); i++) {
 		report_prefix_pushf("%d implies %d", dep[i].facility, dep[i].implied);
 		if (test_facility(dep[i].facility)) {
-			report_xfail(dep[i].expected_tcg_fail && vm_is_tcg(),
+			report_xfail(dep[i].expected_tcg_fail && host_is_tcg(),
 				     test_facility(dep[i].implied),
 				     "implication not correct");
 		} else {
diff --git a/s390x/epsw.c b/s390x/epsw.c
index 192115cf..5b73f4b3 100644
--- a/s390x/epsw.c
+++ b/s390x/epsw.c
@@ -9,7 +9,7 @@
  */
 #include <libcflat.h>
 #include <css.h>
-#include <vm.h>
+#include <hardware.h>
 
 static uint32_t zero_out_cc_from_epsw_op1(uint32_t epsw_op1)
 {
@@ -97,7 +97,7 @@ static void test_epsw(void)
 
 int main(int argc, char **argv)
 {
-	if (!vm_is_kvm() && !vm_is_tcg()) {
+	if (!host_is_kvm() && !host_is_tcg()) {
 		report_skip("Not running under QEMU");
 		goto done;
 	}
diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 2b7c6cc9..62f0fc5a 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -20,7 +20,7 @@
 #include <smp.h>
 #include <alloc_page.h>
 #include <bitops.h>
-#include <vm.h>
+#include <hardware.h>
 
 /* Used to build the appropriate test values for register 0 */
 #define KFC(x) ((x) << 10)
@@ -251,7 +251,7 @@ static void test_mmu_prot(void)
 	fresh += PAGE_SIZE;
 
 	/* Known issue in TCG: CCO flag is not honoured */
-	if (vm_is_tcg()) {
+	if (host_is_tcg()) {
 		report_prefix_push("TCG");
 		report_skip("destination invalid");
 		report_skip("source invalid");
-- 
2.34.1

