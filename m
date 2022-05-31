Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE68538D00
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 10:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbiEaIhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 04:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244912AbiEaIhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 04:37:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B8D52B07;
        Tue, 31 May 2022 01:37:20 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24V8Y1nJ025699;
        Tue, 31 May 2022 08:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hAy+jEIdLpjx9hm9K+00nwh0Iute2GCfb/jd1LLmrYI=;
 b=if3424ltHXwQHPiPJd0bgtepCuQHWulsdejyn9O1q3KqFLGCLKt/NK8MXfJEYgUZXiJA
 PuvV795sna1vvr1VBYt4p6eDaRitTX/lzWw7MBtPhoEzGDakjVvjUJRHd6D10RDauzNU
 RkSfwnkwn0e4GyGB0KrA/m3xtdamGBkthubk+RcpC4Ek3iwSE8W2M8YpRnTb6aUJw/FI
 AnjSALsiB5u99xJLTiLrLZdjAEd7GuYFrbZ1WQzDiyBYaCjga+hJ+ONuMyx9TCyK4eaU
 l4gSAnUd/yHAVSbQtclpI5TmwJkizat+Jk4dMvkS+ecl2J7rjtmvHiT4IlyBid710in0 Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdct7bbyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:37:20 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24V806oR007251;
        Tue, 31 May 2022 08:37:20 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdct7bbxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:37:19 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24V8ZrFR016460;
        Tue, 31 May 2022 08:37:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gbcb7jvcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:37:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24V8a9dN25952704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 08:36:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2261D11C052;
        Tue, 31 May 2022 08:37:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D94C811C050;
        Tue, 31 May 2022 08:37:13 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 May 2022 08:37:13 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 1/1] s390x: add migration test for storage keys
Date:   Tue, 31 May 2022 10:37:13 +0200
Message-Id: <20220531083713.48534-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531083713.48534-1-nrb@linux.ibm.com>
References: <20220531083713.48534-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NDYxqEd4hhIeRNTIqaw7J0lDfNRsnAjT
X-Proofpoint-ORIG-GUID: bzJ3AkoN-G1-tcXwb8-cfirUY_d_L_79
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_02,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205310041
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
---
 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 +++
 3 files changed, 81 insertions(+)
 create mode 100644 s390x/migration-skey.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 25802428fa13..94fc5c1a3527 100644
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
index 000000000000..f846ac435836
--- /dev/null
+++ b/s390x/migration-skey.c
@@ -0,0 +1,76 @@
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
+	int i, key_to_set;
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		/*
+		 * Storage keys are 7 bit, lowest bit is always returned as zero
+		 * by iske
+		 */
+		key_to_set = i * 2;
+		set_storage_key(pagebuf[i], key_to_set, 1);
+	}
+
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		report_prefix_pushf("page %d", i);
+
+		actual_key.val = get_storage_key(pagebuf[i]);
+		expected_key.val = i * 2;
+
+		/* ignore reference bit */
+		actual_key.str.rf = 0;
+		expected_key.str.rf = 0;
+
+		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);
+
+		report_prefix_pop();
+	}
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
+
+		goto done;
+	}
+
+	test_migration();
+
+done:
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

