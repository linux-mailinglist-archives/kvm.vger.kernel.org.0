Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9000363EB86
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 09:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiLAIsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 03:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiLAIrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 03:47:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3DF2529C
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 00:46:49 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B18MkD7018156
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 08:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9A9jejsL7eu/3kxWMCwqZytU8Zdc775D/epFSBVtxhw=;
 b=DPFecrwidvyDgVvfJuCy/qc4I4+4TOdwD8z9pco5LsO3ZnXbvfq3NOg89S3CVwnd5rKg
 omVIAYm6hB5nmCrGAqzfOVXQgae4lzWmRq6IyzlMQaaf7fk8v2omXO0LL0bdNOvBx84K
 I3wmeZFqOx4k9qQj9JKP8SUYbUmKV+4M48otbabt2SGWS5iWFS/VoU16ZCOeZAD8JP69
 jd2m78ZlRVY3QSmnbhux7fEROWerjWGxdL478H7r8GfQQWh+1KUZ71a5qniGLt5iYQbj
 ycaay1V0YPYnyvBM1D5j4l3Ue+EhFLyu9/Ws5I4NPJXBtmcP7l5xqoUNPotLr8EWY7ei gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6qqpt7g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 08:46:49 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B18e8sp031224
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 08:46:49 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6qqpt7f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:46:48 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B18aoTD031592;
        Thu, 1 Dec 2022 08:46:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3m3a2hw3q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:46:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B18khUt9175776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 08:46:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 882B2AE045;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51072AE051;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related functions
Date:   Thu,  1 Dec 2022 09:46:40 +0100
Message-Id: <20221201084642.3747014-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221201084642.3747014-1-nrb@linux.ibm.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RKPIgWG08OefHfw3pNuaQr0VWa6VwNcv
X-Proofpoint-ORIG-GUID: DvnHc9AHXcb5ckTEJ_xCKt5rwjyUntlK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=750
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will add a test which is very similar to the existing
skey migration test. To reduce code duplication, move the common
functions to a library which can be re-used by both tests.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/skey.c       | 92 ++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/skey.h       | 32 +++++++++++++++
 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 44 +++-----------------
 4 files changed, 131 insertions(+), 38 deletions(-)
 create mode 100644 lib/s390x/skey.c
 create mode 100644 lib/s390x/skey.h

diff --git a/lib/s390x/skey.c b/lib/s390x/skey.c
new file mode 100644
index 000000000000..100f0949a244
--- /dev/null
+++ b/lib/s390x/skey.c
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Storage key migration test library
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/facility.h>
+#include <asm/mem.h>
+#include <skey.h>
+
+/*
+ * Set storage keys on pagebuf.
+ * pagebuf must point to page_count consecutive pages.
+ */
+void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
+{
+	unsigned char key_to_set;
+	unsigned long i;
+
+	for (i = 0; i < page_count; i++) {
+		/*
+		 * Storage keys are 7 bit, lowest bit is always returned as zero
+		 * by iske.
+		 * This loop will set all 7 bits which means we set fetch
+		 * protection as well as reference and change indication for
+		 * some keys.
+		 */
+		key_to_set = i * 2;
+		set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);
+	}
+}
+
+/*
+ * Verify storage keys on pagebuf.
+ * Storage keys must have been set by skey_set_keys on pagebuf before.
+ *
+ * If storage keys match the expected result, will return a skey_verify_result
+ * with verify_failed false. All other fields are then invalid.
+ * If there is a mismatch, returned struct will have verify_failed true and will
+ * be filled with the details on the first mismatch encountered.
+ */
+struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count)
+{
+	union skey expected_key, actual_key;
+	struct skey_verify_result result = {
+		.verify_failed = true
+	};
+	uint8_t *cur_page;
+	unsigned long i;
+
+	for (i = 0; i < page_count; i++) {
+		cur_page = pagebuf + i * PAGE_SIZE;
+		actual_key.val = get_storage_key(cur_page);
+		expected_key.val = i * 2;
+
+		/*
+		 * The PoP neither gives a guarantee that the reference bit is
+		 * accurate nor that it won't be cleared by hardware. Hence we
+		 * don't rely on it and just clear the bits to avoid compare
+		 * errors.
+		 */
+		actual_key.str.rf = 0;
+		expected_key.str.rf = 0;
+
+		if (actual_key.val != expected_key.val) {
+			result.expected_key.val = expected_key.val;
+			result.actual_key.val = actual_key.val;
+			result.page_mismatch_idx = i;
+			result.page_mismatch_addr = (unsigned long)cur_page;
+			return result;
+		}
+	}
+
+	result.verify_failed = false;
+	return result;
+}
+
+void skey_report_verify(struct skey_verify_result * const result)
+{
+	if (result->verify_failed)
+		report_fail("page skey mismatch: first page idx = %lu, addr = 0x%lx, "
+			"expected_key = 0x%x, actual_key = 0x%x",
+			result->page_mismatch_idx, result->page_mismatch_addr,
+			result->expected_key.val, result->actual_key.val);
+	else
+		report_pass("skeys match");
+}
diff --git a/lib/s390x/skey.h b/lib/s390x/skey.h
new file mode 100644
index 000000000000..a0f8caa1270b
--- /dev/null
+++ b/lib/s390x/skey.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Storage key migration test library
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#ifndef S390X_SKEY_H
+#define S390X_SKEY_H
+
+#include <libcflat.h>
+#include <asm/facility.h>
+#include <asm/page.h>
+#include <asm/mem.h>
+
+struct skey_verify_result {
+	bool verify_failed;
+	union skey expected_key;
+	union skey actual_key;
+	unsigned long page_mismatch_idx;
+	unsigned long page_mismatch_addr;
+};
+
+void skey_set_keys(uint8_t *pagebuf, unsigned long page_count);
+
+struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count);
+
+void skey_report_verify(struct skey_verify_result * const result);
+
+#endif /* S390X_SKEY_H */
diff --git a/s390x/Makefile b/s390x/Makefile
index bf1504f9d58c..d097b7071dfb 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -99,6 +99,7 @@ cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
 cflatobjs += lib/s390x/fault.o
+cflatobjs += lib/s390x/skey.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
index b7bd82581abe..fed6fc1ed0f8 100644
--- a/s390x/migration-skey.c
+++ b/s390x/migration-skey.c
@@ -10,55 +10,23 @@
 
 #include <libcflat.h>
 #include <asm/facility.h>
-#include <asm/page.h>
-#include <asm/mem.h>
-#include <asm/interrupt.h>
 #include <hardware.h>
+#include <skey.h>
 
 #define NUM_PAGES 128
-static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
 static void test_migration(void)
 {
-	union skey expected_key, actual_key;
-	int i, key_to_set, key_mismatches = 0;
+	struct skey_verify_result result;
 
-	for (i = 0; i < NUM_PAGES; i++) {
-		/*
-		 * Storage keys are 7 bit, lowest bit is always returned as zero
-		 * by iske.
-		 * This loop will set all 7 bits which means we set fetch
-		 * protection as well as reference and change indication for
-		 * some keys.
-		 */
-		key_to_set = i * 2;
-		set_storage_key(pagebuf[i], key_to_set, 1);
-	}
+	skey_set_keys(pagebuf, NUM_PAGES);
 
 	puts("Please migrate me, then press return\n");
 	(void)getchar();
 
-	for (i = 0; i < NUM_PAGES; i++) {
-		actual_key.val = get_storage_key(pagebuf[i]);
-		expected_key.val = i * 2;
-
-		/*
-		 * The PoP neither gives a guarantee that the reference bit is
-		 * accurate nor that it won't be cleared by hardware. Hence we
-		 * don't rely on it and just clear the bits to avoid compare
-		 * errors.
-		 */
-		actual_key.str.rf = 0;
-		expected_key.str.rf = 0;
-
-		/* don't log anything when key matches to avoid spamming the log */
-		if (actual_key.val != expected_key.val) {
-			key_mismatches++;
-			report_fail("page %d expected_key=0x%x actual_key=0x%x", i, expected_key.val, actual_key.val);
-		}
-	}
-
-	report(!key_mismatches, "skeys after migration match");
+	result = skey_verify_keys(pagebuf, NUM_PAGES);
+	skey_report_verify(&result);
 }
 
 int main(void)
-- 
2.36.1

