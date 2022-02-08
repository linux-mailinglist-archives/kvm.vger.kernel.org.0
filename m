Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE644AD9D6
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355470AbiBHN3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356057AbiBHN24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:28:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F930C02B66E;
        Tue,  8 Feb 2022 05:25:13 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218Cgrk4026249;
        Tue, 8 Feb 2022 13:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=44iy9I6pZdWBllep4pSo63fcW9B/pW2cMuiwmdj87Qo=;
 b=U9BdKN95WmCNI//890Om1hsa/mvUqzXjIpeI5KvlFTSV9ze4Xh2p0ShkI/DgYSdnMxoa
 X/JdwQC+hd7ceRjDS0SCogrQZLniCUddlESz4HMuFeEqF8hWHMPZOT9x59l9aHsc5Wav
 dvtKlgrQd1sorK8JfBaMF4jFHbbf8JWaD1TVa2uZeOhvaC9TwF/frpShNIaFYlubIfN8
 cnvWZeUAyEhbuNkDcBRtPgUBP536PMfEkXU/9chZNOsv4LuR49rrKs5oAjoXHLgOKPTi
 eelHKui6P2ottLHGkhF/eUFzRdI9uMizNLZOHzgzY2Ih4ENh3Wnn5GAK6diBdkUUs98z og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22su0fcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:12 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218CrFnY011338;
        Tue, 8 Feb 2022 13:25:12 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22su0fbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:12 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218DFlhH027083;
        Tue, 8 Feb 2022 13:25:10 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygq3qnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218DP6U241025840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 13:25:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A7724204F;
        Tue,  8 Feb 2022 13:25:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EA6842041;
        Tue,  8 Feb 2022 13:25:06 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.71.76])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 13:25:06 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 2/4] s390x: stsi: Define vm_is_kvm to be used in different tests
Date:   Tue,  8 Feb 2022 14:27:07 +0100
Message-Id: <20220208132709.48291-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208132709.48291-1-pmorel@linux.ibm.com>
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0lRJxf2h4UDVSnbpaHttSKKSwky-5dtl
X-Proofpoint-ORIG-GUID: 96imSC2dz1E3YVfYd2zP4JiJnRaFj7hK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=793 priorityscore=1501 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 lib/s390x/stsi.h | 32 +++++++++++++++++++++++++++
 lib/s390x/vm.c   | 56 ++++++++++++++++++++++++++++++++++++++++++++++--
 lib/s390x/vm.h   |  3 +++
 s390x/stsi.c     | 23 ++------------------
 4 files changed, 91 insertions(+), 23 deletions(-)
 create mode 100644 lib/s390x/stsi.h

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
new file mode 100644
index 00000000..9b40664f
--- /dev/null
+++ b/lib/s390x/stsi.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
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
index a5b92863..38886b76 100644
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
 
-	buf = alloc_page();
-	if (!buf)
+	if (!vm_is_vm()) {
+		initialized = true;
 		return false;
+	}
+
+	buf = alloc_page();
+	assert(buf);
 
 	if (stsi(buf, 1, 1, 1))
 		goto out;
@@ -43,3 +48,50 @@ out:
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

