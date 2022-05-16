Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D4528060
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbiEPJH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiEPJHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:07:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C33DF45;
        Mon, 16 May 2022 02:07:09 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G91Qrp022338;
        Mon, 16 May 2022 09:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VOwLRW16PkVTJ5zWs3Z6F9x7+K/rClebQu70/6EylBE=;
 b=L3R0qnlovq3R0z/O6uJsf2OEbVhbHp/xC2S76bRwjmSIP8YZoGMbuecThN9gaXr9Mt2S
 9OSsN+jMn0NQF4S+sdkSQODIkA6RZ0g5B3t634AO9ybgN/2+dzNSY4GGkvyYNl2ZrMjU
 gCGleKp2YKeziEeLdP22ClFqreKRe+/QX8xLuendfAUsHV8zX8U/BegySxYYsK69R0PO
 VC9nobtowNVV5USjiA4QEKQqRqsKQJqE5tWTtoAIbJTKglwGhcXk16cZgDdSyxFSplwD
 NJRFrFsJ7E8XPrnlz3Qn8/Sm6y7SO0vDIqTYyeHoB3zoidR34kNOj2t5tn8g1SAJ3uqG Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3km403eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:07:09 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G91Slh022650;
        Mon, 16 May 2022 09:07:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3km403e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:07:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G95uCP006672;
        Mon, 16 May 2022 09:07:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429abpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:07:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G973Mq18350380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 09:07:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C96DA4054;
        Mon, 16 May 2022 09:07:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02AB3A4062;
        Mon, 16 May 2022 09:07:03 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:07:02 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/1] s390x: add migration test for storage keys
Date:   Mon, 16 May 2022 11:07:02 +0200
Message-Id: <20220516090702.1939253-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220516090702.1939253-1-nrb@linux.ibm.com>
References: <20220516090702.1939253-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aWtuuT5aH79WYigauQDsC-14Ht9q0wDU
X-Proofpoint-ORIG-GUID: R6iGAbTJ778mb9hIHcw3Tvs6mrnwdYj2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 spamscore=0 mlxlogscore=949 clxscore=1015
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon migration, we expect storage keys being set by the guest to be preserved,
so add a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
they can be read back and the respective access restrictions are in place when
the access key in the PSW doesn't match.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 +++
 3 files changed, 83 insertions(+)
 create mode 100644 s390x/migration-skey.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a8e04aa6fe4d..f8ea594b641d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -32,6 +32,7 @@ tests += $(TEST_DIR)/epsw.elf
 tests += $(TEST_DIR)/adtl-status.elf
 tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
+tests += $(TEST_DIR)/migration-skey.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
new file mode 100644
index 000000000000..ee4622eb94ba
--- /dev/null
+++ b/s390x/migration-skey.c
@@ -0,0 +1,78 @@
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
+	int i, key_to_set;
+	uint8_t *page;
+	union skey expected_key, actual_key;
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
+		page = &pagebuf[i][0];
+		actual_key.val = get_storage_key(page);
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
index b456b2881448..1e851d8e3dd8 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -176,3 +176,7 @@ extra_params = -cpu qemu,gs=off,vx=off
 file = migration.elf
 groups = migration
 smp = 2
+
+[migration-skey]
+file = migration-skey.elf
+groups = migration
-- 
2.31.1

