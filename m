Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257075FB7DC
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiJKP7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 11:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJKP7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 11:59:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EE933A09
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:59:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BEiQEi024070
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wZU5mE6ovOVdBPSp6OpGmyuj3fXZ0OphGglmrDtJApk=;
 b=ZNkZ2EjENzs/rdMdSmMmk7eHqJXo6jy8F90jR/mBB3FgA66H9+/5HiG4JJAJ4CJFFQEm
 3ZVe3ChPpc04/eZAKvIQVtv1dV4NEQ5CFl1ySSu6cgoTvJEHp7kVFdz4NppnJtw1+4RE
 HXu9GCs0F/g8iJ6woLSHLeVDY5/+80+eqrBslXvHhgPN55vbOOQzpNI/sMrFyMB6XYE1
 bcdTT5VMLwJ9lK6ZdMpTXSIv0ewuqWQct2Ya58rnmwQzvC+KreICF2GJ0e+fIob2O+O6
 Za9TT6arlRKY32y4oG/IGqj0A6t4Mr/kyp4Ytt9ul4EWCZu2sAO8kRBaLNz8pk9VhAGc +Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k54d0w43x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:39 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BF6bIn013020
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:37 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9cn34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BFEYqu52953574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 15:14:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82B5A42045;
        Tue, 11 Oct 2022 15:14:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C1AD42041;
        Tue, 11 Oct 2022 15:14:34 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 15:14:34 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/2] s390x: add migration TOD clock test
Date:   Tue, 11 Oct 2022 17:14:33 +0200
Message-Id: <20221011151433.886294-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221011151433.886294-1-nrb@linux.ibm.com>
References: <20221011151433.886294-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 67a0nUAJd02QpBv3hcQFEWOurYjQAlCe
X-Proofpoint-ORIG-GUID: 67a0nUAJd02QpBv3hcQFEWOurYjQAlCe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On migration, we expect the guest clock value to be preserved. Add a
test to verify this:
- advance the guest TOD by much more than we need to migrate
- migrate the guest
- get the guest TOD

After migration, assert the guest TOD value is at least the value we set
before migration.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile        |  1 +
 s390x/migration-sck.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg   |  4 ++++
 3 files changed, 49 insertions(+)
 create mode 100644 s390x/migration-sck.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 649486f2d4a0..fba09bc2df3a 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -36,6 +36,7 @@ tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
 tests += $(TEST_DIR)/panic-loop-extint.elf
 tests += $(TEST_DIR)/panic-loop-pgm.elf
+tests += $(TEST_DIR)/migration-sck.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-sck.c b/s390x/migration-sck.c
new file mode 100644
index 000000000000..286a693b4858
--- /dev/null
+++ b/s390x/migration-sck.c
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * SET CLOCK migration tests
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/time.h>
+
+static void test_sck_migration(void)
+{
+	uint64_t now_before_set = 0, now_after_migration, time_to_set, time_to_advance;
+	int cc;
+
+	stckf(&now_before_set);
+
+	/* Advance the clock by a lot more than we might ever need to migrate (600s) */
+	time_to_advance = (600ULL * 1000000) << STCK_SHIFT_US;
+	time_to_set = now_before_set + time_to_advance;
+
+	cc = sck(&time_to_set);
+	report(!cc, "setting clock succeeded");
+
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+	cc = stckf(&now_after_migration);
+	report(!cc, "clock still set");
+
+	report(now_after_migration >= time_to_set, "TOD clock value preserved");
+}
+
+int main(void)
+{
+	report_prefix_push("migration-sck");
+
+	test_sck_migration();
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f9f102abfa89..2c04ae7c7c15 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -197,3 +197,7 @@ file = panic-loop-pgm.elf
 groups = panic
 accel = kvm
 timeout = 5
+
+[migration-sck]
+file = migration-sck.elf
+groups = migration
-- 
2.36.1

