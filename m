Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4A36482E9
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 14:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLINsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 08:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiLINsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 08:48:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56884663D1
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 05:48:20 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9B4xcJ003835;
        Fri, 9 Dec 2022 13:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=74cscYancSJBJ0T8wR8WBl2IMdRztU9CVq/SaxkNvto=;
 b=hndHDNvxHnoB8C91TAhGRIUP4vz8wFXHMqCu1+a86DXeI2n33HVsrsxbG4p2tkvTdVMY
 LKrWgl/HWJbldg2uNjiqhSHFZ80TbkWXbKqxcedeTGGPW5DQlpVd43NIQmRLeoAiCkFg
 YXxZya51s/ULTatwJFgvTgUZ92nFGdwWHvHDwjCYxuYXhytpAFx9AEfVGowWNt/pMtTd
 8YQIbh4bw4u96Oc89hbPx2QXEd5NvOHG+q3B5manoRj4ZZq98ltw7gL4Odhc+QkhyGH9
 VxEn69WnaZzZn98xL0wP0GhgNHDy3NENRItFS6db+trrOMtkcM64X8m7kPgQjqFIKvuI ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbxakk3a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:16 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B9BsZk2002151;
        Fri, 9 Dec 2022 13:48:16 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbxakk399-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:16 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B98ibsc026074;
        Fri, 9 Dec 2022 13:48:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3m9ktqme03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B9DmAbo39322018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Dec 2022 13:48:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 499AD20040;
        Fri,  9 Dec 2022 13:48:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F90320049;
        Fri,  9 Dec 2022 13:48:10 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  9 Dec 2022 13:48:10 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/4] lib: add function to request migration
Date:   Fri,  9 Dec 2022 14:48:06 +0100
Message-Id: <20221209134809.34532-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221209134809.34532-1-nrb@linux.ibm.com>
References: <20221209134809.34532-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mcAxEwDjR2NeAvr3MnIlqBlQBNLMmC4e
X-Proofpoint-ORIG-GUID: 4-ELxaQei7j9EQWbF8TXtHPm0N2cp0K_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_07,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxlogscore=949 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212090108
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

