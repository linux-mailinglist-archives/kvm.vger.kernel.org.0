Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D8754B425
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355636AbiFNPBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355471AbiFNPBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:01:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1049940927
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:01:01 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EEqCjA010830
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:01:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wOPcrSDbNwAupg/tu3V+b2eJGB2c590AycC27gd/P+I=;
 b=DLuEdZNJn69Igpw/l98qo90ePcYG9iK+oHKzxKMMOMG33pim4rRL+YyQDUz+Dh5RVybg
 qIKTvPTEFbSBefPKz1RoYf1Pd3MsPqjbM7qYZOuD+ZpSGfhazd0NyeffWomxHwwFiBjG
 wNA9XZ6ZClvYj6JNWIoh40d67H+qT0pNDHPqB0H0QxxLsJbj91UguhvHoDSrmeAVjOYH
 8zys8nVQ4TLym0uHX63EylZpGvATCFKVsZhIA9h40aXBfZlXK3Ah7cW8gCjZcOyFxg3e
 FauW5B71chhZSLcpg8JJ3SRDZaXeyLvbja67dl1ayf09TWBpnqtslTOTkGwcOvqhOFva LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpp6hn3n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:01:00 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25EEqVZx013209
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:01:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpp6hn3kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 15:00:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25EEoUVX003454;
        Tue, 14 Jun 2022 15:00:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3gmjajchvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 15:00:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25EF0sEW15794438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 15:00:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E659942047;
        Tue, 14 Jun 2022 15:00:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70B6342049;
        Tue, 14 Jun 2022 15:00:53 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 15:00:53 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 5/5] s390x: add migration test for storage keys
Date:   Tue, 14 Jun 2022 17:00:49 +0200
Message-Id: <20220614150049.55787-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614150049.55787-1-imbrenda@linux.ibm.com>
References: <20220614150049.55787-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BirG65VfgBCs3n3oEJBNf-Wdlp8zcJ0g
X-Proofpoint-ORIG-GUID: P_cykVyeGhKzT1rqwTO0-gns6TMy0_iI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_05,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 mlxlogscore=953 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Upon migration, we expect storage keys set by the guest to be preserved, so add
a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
that they can be read back and match the value originally set.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20220614110521.123205-2-nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 ++
 3 files changed, 88 insertions(+)
 create mode 100644 s390x/migration-skey.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 1877c8a6..efd5e0c1 100644
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
index 00000000..b7bd8258
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
index 9b97d047..8e52f560 100644
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

