Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC22A5A238C
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbiHZIt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 04:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245288AbiHZItw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 04:49:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D14A1B9
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 01:49:51 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q8LOYa012882
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LbheK12N/lqbyYfQ52oiMw8T1zmx25raKvtz6Vgeu1g=;
 b=tFP9YDBUVZhxKCq3tZCGFJJwAyIhMg9MzxTngHqaiJLPFKPv/HkQL6WEBriH6s//qvX3
 9G59zzAlCwGf/0BVktQDx9OSF21/0lePvgkh3XPZClGyYPqr6xT2L2Kvv17M4I4ACJ3l
 +UiAo/Ey4E4El3re77YeQk9cfC8+863MS1mPciRrU4qNfKyW8UM1JO005VvK2wQXGJ+u
 lWiv1vhD8FsuJBFC7xWB3tsnb3BW4mX3AkQygN6s1fxdL1Lqq8291Xfs1zeRT5u5otVn
 h1dgjjCsoWzh72KfyiI8gbey5hcVhkqHGmlvOVkMhIaTZRuUs9JnDc0e4RqIXObM4Rcx uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6tk70s1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:51 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27Q8SXM1009335
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:50 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6tk70s15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 08:49:50 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27Q8Zlea029229;
        Fri, 26 Aug 2022 08:49:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3j2q89dg0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 08:49:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27Q8njr639321986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 08:49:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 346E7AE045;
        Fri, 26 Aug 2022 08:49:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01A34AE051;
        Fri, 26 Aug 2022 08:49:45 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Aug 2022 08:49:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/2] s390x: add migration TOD clock test
Date:   Fri, 26 Aug 2022 10:49:44 +0200
Message-Id: <20220826084944.19466-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220826084944.19466-1-nrb@linux.ibm.com>
References: <20220826084944.19466-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4e-tOT4MXnF78o2srAJgrpDDqwzhsKKO
X-Proofpoint-ORIG-GUID: rTQrvQ4ACzHs5z9osQ6hFaQ2LYgp0pAs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 s390x/migration-sck.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg   |  4 ++++
 3 files changed, 50 insertions(+)
 create mode 100644 s390x/migration-sck.c

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c13102..be8e647bb35f 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
+tests += $(TEST_DIR)/migration-sck.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-sck.c b/s390x/migration-sck.c
new file mode 100644
index 000000000000..701d33f9db5a
--- /dev/null
+++ b/s390x/migration-sck.c
@@ -0,0 +1,45 @@
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
+#include <bitops.h>
+
+static void test_sck_migration(void)
+{
+	uint64_t now_before_set = 0, now_after_migration, time_to_set, time_to_advance;
+	int cc;
+
+	stckf(&now_before_set);
+
+	/* Advance the clock by a lot more than we might ever need to migrate (60s) */
+	time_to_advance = (60ULL * 1000ULL * 1000ULL << STCK_SHIFT_US);
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
index f7b1fc3dbca1..808e8a28ba96 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -185,3 +185,7 @@ groups = migration
 [migration-skey]
 file = migration-skey.elf
 groups = migration
+
+[migration-sck]
+file = migration-sck.elf
+groups = migration
-- 
2.36.1

