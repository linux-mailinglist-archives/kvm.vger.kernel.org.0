Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E930563EB88
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 09:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiLAIsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 03:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLAIrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 03:47:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6606288B5A
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 00:46:50 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B18ihUf005191
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 08:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aCuJ66hDc+FTXapIKCGJxRZSHMW6ebvGa8EMLnUV81E=;
 b=F2qsIZ5igvG4sPsFfGIFfwzye5ZsaGIM+Sk13zclwYHiujA9QZyUf+SYwryoe6a9Cfcr
 6af90L0Kz1IDl39Fdd7jW9mKPQQBpu2NC4ARSgIwT0KLdyD6RYMa5lZDGDs/tFoaSWLe
 JApe9+Ury0V+hnQLRqpmrzz82ww/sRwFob1+EErDjBk16SPtaU2PVPkjwImU9FXPXZbw
 0pKhiAWXM9j6o2UEehyf/IEgRq0Ad5eHLNVF+WHz5w5vahYY6PiyHPcbq9wRfQBJOGIa
 3+Zm4NR2CBrRi3DTSiUec2OajGKJnaipcjby338DVjKfXT9ZyZzgcyGUopEyXI+t3r+u Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6s1e822j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 08:46:49 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B18ikmu005477
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 08:46:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6s1e821t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:46:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B18ZtN9029645;
        Thu, 1 Dec 2022 08:46:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3m3ae9f1nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:46:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B18kiFl64094578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 08:46:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14D1CAE045;
        Thu,  1 Dec 2022 08:46:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2DEFAE051;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v1 3/3] s390x: add storage key test during migration
Date:   Thu,  1 Dec 2022 09:46:42 +0100
Message-Id: <20221201084642.3747014-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221201084642.3747014-1-nrb@linux.ibm.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jnxnRiUQYz4umfqglDewWlPpJK7v1HUX
X-Proofpoint-GUID: LOZfeddWrAOVmJpCeQFrYRhc5G82UGAq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test which modifies storage keys while migration is in progress.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                |   1 +
 s390x/migration-during-skey.c | 103 ++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg           |   5 ++
 3 files changed, 109 insertions(+)
 create mode 100644 s390x/migration-during-skey.c

diff --git a/s390x/Makefile b/s390x/Makefile
index d097b7071dfb..d9ba9b5fc392 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
 tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
+tests += $(TEST_DIR)/migration-during-skey.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-during-skey.c b/s390x/migration-during-skey.c
new file mode 100644
index 000000000000..bd0e6feb02bc
--- /dev/null
+++ b/s390x/migration-during-skey.c
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Perform storage key operations during migration
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/facility.h>
+#include <asm/barrier.h>
+#include <hardware.h>
+#include <smp.h>
+#include <skey.h>
+
+#define NUM_PAGES 128
+static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static unsigned int thread_iters;
+static bool thread_should_exit;
+static bool thread_exited;
+static struct skey_verify_result result;
+
+static void test_skeys_during_migration(void)
+{
+	while (!READ_ONCE(thread_should_exit)) {
+		skey_set_keys_with_seed(pagebuf, NUM_PAGES, thread_iters);
+
+		result = skey_verify_keys_with_seed(pagebuf, NUM_PAGES, thread_iters);
+
+		/*
+		 * Always increment even if the verify fails. This ensures primary CPU knows where
+		 * we left off and can do an additional verify round after migration finished.
+		 */
+		thread_iters++;
+
+		if (result.verify_failed)
+			break;
+	}
+
+	WRITE_ONCE(thread_exited, 1);
+}
+
+static void migrate_once(void)
+{
+	static bool migrated;
+
+	if (migrated)
+		return;
+
+	migrated = true;
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+}
+
+int main(void)
+{
+	report_prefix_push("migration-skey");
+	if (test_facility(169)) {
+		report_skip("storage key removal facility is active");
+		goto error;
+	}
+
+	if (smp_query_num_cpus() == 1) {
+		report_skip("need at least 2 cpus for this test");
+		goto error;
+	}
+
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(test_skeys_during_migration));
+
+	migrate_once();
+
+	WRITE_ONCE(thread_should_exit, 1);
+
+	while (!thread_exited)
+		mb();
+
+	report_info("thread completed %u iterations", thread_iters);
+
+	report_prefix_push("during migration");
+	skey_report_verify(&result);
+	report_prefix_pop();
+
+	/*
+	 * Verification of skeys occurs on the thread. We don't know if we
+	 * were still migrating during the verification.
+	 * To be sure, make another verification round after the migration
+	 * finished to catch skeys which might not have been migrated
+	 * correctly.
+	 */
+	report_prefix_push("after migration");
+	assert(thread_iters > 0);
+	result = skey_verify_keys_with_seed(pagebuf, NUM_PAGES, thread_iters - 1);
+	skey_report_verify(&result);
+	report_prefix_pop();
+
+error:
+	migrate_once();
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3caf81eda396..855c352929a4 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -208,3 +208,8 @@ groups = migration
 [exittime]
 file = exittime.elf
 smp = 2
+
+[migration-during-skey]
+file = migration-during-skey.elf
+smp = 2
+groups = migration
-- 
2.36.1

