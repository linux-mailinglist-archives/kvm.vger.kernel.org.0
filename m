Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6555FB8BF
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 19:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJKRAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 13:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiJKRAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 13:00:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D28AE5D
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 10:00:31 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BGLZQC018180
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+crlU5/BxGpHSDR732nxNs4+S/2U6ENBa7iuBuooJ7o=;
 b=jcxEreMfEisosKflNwF/jGthOGs5q4uid5h2sYS664wP2SJ9GhD/FVoOdP93P6iwxvir
 nKiuvHL4LzFFvEs1XsDm0wlXOPIsFQVv96mB3Rggdo7qDwqZTYJ/lXubTjZd0B5XHRah
 GAbecffE1U/c1mn6TRsTOasL6ANcCaapM6V3GVWHgpJSQb/FaovDBgU/4pWV1Y1lKfKx
 OOO1wEQmeMdB2BYYj2RvONGJ6CVf+zWwKyhPCe+bwug+YZ4mBJUw97tF/vsYyidtcg9W
 pTGFtISgXKJXhjmXpl4W1BzK7bK1bfMXKZLFxsDMGBMJtipqsgIN68lOp2EGUjQZfp9E aw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5bxjs2bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:00:30 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BGo4o0028032
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:00:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3k30u8ujrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:00:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BGtgZL39977340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 16:55:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BDD0AE045;
        Tue, 11 Oct 2022 17:00:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C379AE057;
        Tue, 11 Oct 2022 17:00:25 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 17:00:25 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 2/2] s390x: add migration TOD clock test
Date:   Tue, 11 Oct 2022 19:00:24 +0200
Message-Id: <20221011170024.972135-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221011170024.972135-1-nrb@linux.ibm.com>
References: <20221011170024.972135-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I3AAAReW2l-zEnfBJ2FoibAiHEv164lJ
X-Proofpoint-GUID: I3AAAReW2l-zEnfBJ2FoibAiHEv164lJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110095
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
before migration. This is the minimal check for architectural
compliance; implementations may decide to do something more
sophisticated.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile        |  1 +
 s390x/migration-sck.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg   |  4 ++++
 3 files changed, 59 insertions(+)
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
index 000000000000..2d9a195ab4c4
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

