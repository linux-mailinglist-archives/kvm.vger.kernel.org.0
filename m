Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0666154AEFB
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 13:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347495AbiFNLFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 07:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241526AbiFNLFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 07:05:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F83E427C7;
        Tue, 14 Jun 2022 04:05:29 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E9r2vJ001765;
        Tue, 14 Jun 2022 11:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CnX0mQNoGiPeHfBu13OM9XfUOR80CVwSXQ7qy7N+sHY=;
 b=YPXTd4x1A3V1TQFsve8NM3z9AunEdCZdqAI7xXJT3B9VBP6AKx5d1hKN95Ok9oYHH68o
 UcX5JL4sj3sfHKu8rDM9l206/2WLiY5FoRrTjP7clqb1U0VpE+jQtmmL1m6FLoERIuHG
 a0PXhPlfezeL2ittc4wEoNG5DJN3Bbpgk/4JI017juRSG61pMkHUuvDAzUmNp1KSmuPh
 kYx7YXG8Ofu6N0z5TLKF6Q/ZgJ/pcCAtF4SxwhdPxOViJqVzccP7+zPiwGgZVFDVDCZR
 ddHgbwkJVQSWH29bMlfmOfxxf2brTsWd/d4ZaTnB0JJh18NmkNEm+wKpreouTudoIsQ9 Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpr3f1rdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 11:05:28 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25EAmPGC019687;
        Tue, 14 Jun 2022 11:05:27 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpr3f1rcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 11:05:27 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25EAomnN032376;
        Tue, 14 Jun 2022 11:05:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3gmjp8u95w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 11:05:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25EB5MM715663516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 11:05:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F74942041;
        Tue, 14 Jun 2022 11:05:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C41A42045;
        Tue, 14 Jun 2022 11:05:22 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 11:05:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 1/1] s390x: add migration test for storage keys
Date:   Tue, 14 Jun 2022 13:05:21 +0200
Message-Id: <20220614110521.123205-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614110521.123205-1-nrb@linux.ibm.com>
References: <20220614110521.123205-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s71FgHgDPsEJ-rAiBhNT87FsYJgk6uWc
X-Proofpoint-GUID: GKxYjrEKHY190MqAPChrINxSh-LWTH5-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_03,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon migration, we expect storage keys set by the guest to be preserved, so add
a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
that they can be read back and match the value originally set.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 ++
 3 files changed, 88 insertions(+)
 create mode 100644 s390x/migration-skey.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 1877c8a6e86e..efd5e0c13102 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -33,6 +33,7 @@ tests += $(TEST_DIR)/adtl-status.elf
 tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
+tests += $(TEST_DIR)/migration-skey.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
new file mode 100644
index 000000000000..b7bd82581abe
--- /dev/null
+++ b/s390x/migration-skey.c
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Storage Key migration tests
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/facility.h>
+#include <asm/page.h>
+#include <asm/mem.h>
+#include <asm/interrupt.h>
+#include <hardware.h>
+
+#define NUM_PAGES 128
+static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static void test_migration(void)
+{
+	union skey expected_key, actual_key;
+	int i, key_to_set, key_mismatches = 0;
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		/*
+		 * Storage keys are 7 bit, lowest bit is always returned as zero
+		 * by iske.
+		 * This loop will set all 7 bits which means we set fetch
+		 * protection as well as reference and change indication for
+		 * some keys.
+		 */
+		key_to_set = i * 2;
+		set_storage_key(pagebuf[i], key_to_set, 1);
+	}
+
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		actual_key.val = get_storage_key(pagebuf[i]);
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
+		/* don't log anything when key matches to avoid spamming the log */
+		if (actual_key.val != expected_key.val) {
+			key_mismatches++;
+			report_fail("page %d expected_key=0x%x actual_key=0x%x", i, expected_key.val, actual_key.val);
+		}
+	}
+
+	report(!key_mismatches, "skeys after migration match");
+}
+
+int main(void)
+{
+	report_prefix_push("migration-skey");
+	if (test_facility(169)) {
+		report_skip("storage key removal facility is active");
+
+		/*
+		 * If we just exit and don't ask migrate_cmd to migrate us, it
+		 * will just hang forever. Hence, also ask for migration when we
+		 * skip this test altogether.
+		 */
+		puts("Please migrate me, then press return\n");
+		(void)getchar();
+	} else {
+		test_migration();
+	}
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9b97d0471bcf..8e52f560bb1e 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -180,3 +180,7 @@ smp = 2
 [migration-cmm]
 file = migration-cmm.elf
 groups = migration
+
+[migration-skey]
+file = migration-skey.elf
+groups = migration
-- 
2.36.1

