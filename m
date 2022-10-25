Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A8460CB1D
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiJYLoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiJYLnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18555175370
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:53 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB7wOO006377
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YKEaLQCC3x3KI4aay9MuBvNM4mkNNo204dMMqEQ+UiY=;
 b=T+DuwU3HF2Tz8TvQNtRwux2IBba4vczvNt+xuqIxCou+GMhWFddTAk2aMNcf34BHExpB
 V7rKn9hKLkUdTUxqB/HaAFdhlcM2AcLukv4WTXHYtLSkiSWjvYq1vTSaekv2Eo7YxFrB
 Sb+FeNno4BpOFQI5WiQwoWnYbXlcpte6sUSH7XCR5v2Sppoc+8WrOTzOa3Y6iRgIAhpc
 ViEzY/L8D+eYuvo7UTAe3fzOhTZzhp3qM33GE+x7ZqfKll9TtrOBq6wk0F5ReWSg19rn
 86tU/gyFNgKwiVqllJHiff67uS0ymHUF9nu30Lv3/z9Uf7pybqKBbVHvg+IqvHy78p9y Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvf9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:52 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBb86x003328
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:52 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvf96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:52 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBcLF7027544;
        Tue, 25 Oct 2022 11:43:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3kc859dhpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhkSJ34931192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC10BAE045;
        Tue, 25 Oct 2022 11:43:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AB6FAE04D;
        Tue, 25 Oct 2022 11:43:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:46 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 04/22] s390x: add migration TOD clock test
Date:   Tue, 25 Oct 2022 13:43:27 +0200
Message-Id: <20221025114345.28003-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f7Wl09v_AF8O_pyOk8BW1vHK0cxUPGFs
X-Proofpoint-ORIG-GUID: 1XED_DgzlgelU_fszeeX7PR2g5a5nC7x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 bulkscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

On migration, we expect the guest clock value to be preserved. Add a
test to verify this:
- advance the guest TOD by much more than we need to migrate
- migrate the guest
- get the guest TOD

After migration, assert the guest TOD value is at least the value we set
before migration. This is the minimal check for architectural
compliance; implementations may decide to do something more
sophisticated.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221011170024.972135-3-nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile        |  1 +
 s390x/migration-sck.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg   |  4 ++++
 3 files changed, 59 insertions(+)
 create mode 100644 s390x/migration-sck.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 6acb7b16..7b08ed80 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -37,6 +37,7 @@ tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
 tests += $(TEST_DIR)/panic-loop-extint.elf
 tests += $(TEST_DIR)/panic-loop-pgm.elf
+tests += $(TEST_DIR)/migration-sck.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-sck.c b/s390x/migration-sck.c
new file mode 100644
index 00000000..2d9a195a
--- /dev/null
+++ b/s390x/migration-sck.c
@@ -0,0 +1,54 @@
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
+	uint64_t now_before_set = 0, now_after_set = 0, now_after_migration, time_to_set, time_to_advance;
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
+	/* Check the clock is running after being set */
+	cc = stckf(&now_after_set);
+	report(!cc, "clock running after set");
+	report(now_after_set >= time_to_set, "TOD clock value is larger than what has been set");
+
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+	cc = stckf(&now_after_migration);
+	report(!cc, "clock still set");
+
+	/*
+	 * The architectural requirement for the TOD clock is that it doesn't move backwards after
+	 * migration. Implementations can just migrate the guest TOD value or do something more
+	 * sophisticated (e.g. slowly adjust to the host TOD).
+	 */
+	report(now_after_migration >= time_to_set, "TOD clock value did not jump backwards");
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
index 412fd130..1bc79a23 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -200,3 +200,7 @@ file = panic-loop-pgm.elf
 groups = panic
 accel = kvm
 timeout = 5
+
+[migration-sck]
+file = migration-sck.elf
+groups = migration
-- 
2.37.3

