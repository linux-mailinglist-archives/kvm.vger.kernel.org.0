Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9C0649D6D
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 12:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiLLLTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 06:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiLLLSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 06:18:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513FEE1D
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 03:17:44 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCA6XEZ007325;
        Mon, 12 Dec 2022 11:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BFULCdgkvC3kJ5cmsY4c1h9e8ReOx/XFgUXhwrS8aj8=;
 b=AEjdTFwWoxFJ8uUVbAeAADYSr5I7vbKFvoTTIp+uTCQUwooW/1SwqRBO5t95lmEdrBeX
 NseAOwueiira88iYRQmvlkLfK1BxJfZgQsCgzPCZYDx0WWB2BP2PnMA1zVVgYPwxK1SX
 lqcPNIE/a7BVA02V/y1OQiWBtZvHW95a6uVyFrabrAas3xcH1AB5349YqFIRSjE8HoTq
 1wy2HXFVjY2p2XMVlXkvkLCYoMDzBB/tnG1gOV9XRGPDObQu5R8W+oQRkwF6YrTTwA3P
 qkt03HjfQRASGcOHmb8lOUG5H9fgvzs3xHzNFs1bv+6F7PGirXACcIfB+TLpNul3QsMv Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3md421ekry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:38 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BCBHcAl010158;
        Mon, 12 Dec 2022 11:17:38 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3md421ekrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:38 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC3GmYE001463;
        Mon, 12 Dec 2022 11:17:36 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3mchr5sth8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BCBHWVr42336692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 11:17:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C41B20040;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AE672004E;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/4] lib: add function to request migration
Date:   Mon, 12 Dec 2022 12:17:28 +0100
Message-Id: <20221212111731.292942-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212111731.292942-1-nrb@linux.ibm.com>
References: <20221212111731.292942-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LuxdEK9ThLejrWwn0YLJXcH1_AcbErPn
X-Proofpoint-GUID: Yv19jdhC-WVYEM3J8iMi0HKiD29ZqS4_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=978 impostorscore=0
 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Migration tests can ask migrate_cmd to migrate them to a new QEMU
process. Requesting migration and waiting for completion is hence a
common pattern which is repeated all over the code base. Add a function
which does all of that to avoid repeating the same pattern.

Since migrate_cmd currently can only migrate exactly once, this function
is called migrate_once() and is a no-op when it has been called before.
This can simplify the control flow, especially when tests are skipped.

Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/migrate.h |  9 +++++++++
 lib/migrate.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 lib/migrate.h
 create mode 100644 lib/migrate.c

diff --git a/lib/migrate.h b/lib/migrate.h
new file mode 100644
index 000000000000..3c94e6af761c
--- /dev/null
+++ b/lib/migrate.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Migration-related functions
+ *
+ * Copyright IBM Corp. 2022
+ * Author: Nico Boehr <nrb@linux.ibm.com>
+ */
+
+void migrate_once(void);
diff --git a/lib/migrate.c b/lib/migrate.c
new file mode 100644
index 000000000000..527e63ae189b
--- /dev/null
+++ b/lib/migrate.c
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Migration-related functions
+ *
+ * Copyright IBM Corp. 2022
+ * Author: Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include "migrate.h"
+
+/* static for now since we only support migrating exactly once per test. */
+static void migrate(void)
+{
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+}
+
+/*
+ * Initiate migration and wait for it to complete.
+ * If this function is called more than once, it is a no-op.
+ * Since migrate_cmd can only migrate exactly once this function can
+ * simplify the control flow, especially when skipping tests.
+ */
+void migrate_once(void)
+{
+	static bool migrated;
+
+	if (migrated)
+		return;
+
+	migrated = true;
+	migrate();
+}
-- 
2.36.1

