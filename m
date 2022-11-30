Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238AB63D803
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiK3OXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiK3OXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:23:05 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2A513CD3
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:23:01 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUCKRPc011460;
        Wed, 30 Nov 2022 14:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=egONSukQoF2qIrqjHYgWiDkisLKzEDJ70Hz6Epe/pMs=;
 b=ICTm+q++sZK8o3GNIdqQ54Lp3BWyMnNZhTVldeUUiAcA+JFaJJ07SB6N/UkeYjlAV1ZL
 WzzDB62qiNVKQvzalXGn+OxKwRxj15QSkohayJkKbYZe2n5RTIIQ4kPMQXuPvyYjtOAD
 NCwhIqiDY9VKp/qC+axWEuR1vV+nhkly+xxYBzpENxUGOK41FxU+Ll52JUoh6QjaeTcb
 sqAXQZMFv/FKRvhJuawI0h3aiipIxXTBaS+aTjwfwyZ0mpdGZJaDwVsbmA3XUB78H1eL
 lskdhGXEJmIQ2lXQmm2sXcF5r4/7q4gfuv3TEeUf4osfHJ1SgAda3iV04i+H7Gu/odeM 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m65abnmud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUCQV9S027801;
        Wed, 30 Nov 2022 14:22:55 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m65abnmtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:55 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUEJxDL019961;
        Wed, 30 Nov 2022 14:22:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3m3ae8v9yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUEMo436816484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 14:22:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CF25AE056;
        Wed, 30 Nov 2022 14:22:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5920DAE057;
        Wed, 30 Nov 2022 14:22:50 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 14:22:50 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/4] lib: add function to request migration
Date:   Wed, 30 Nov 2022 15:22:46 +0100
Message-Id: <20221130142249.3558647-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221130142249.3558647-1-nrb@linux.ibm.com>
References: <20221130142249.3558647-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G_oX2jFULv0ruvivYnZHRs45i1ew7s1p
X-Proofpoint-GUID: ELeoxyj86fcRxcTaj-k2S-0zhjJ2LaQY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1011
 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0 mlxlogscore=967
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211300099
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
 lib/migrate.c | 34 ++++++++++++++++++++++++++++++++++
 lib/migrate.h |  9 +++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 lib/migrate.c
 create mode 100644 lib/migrate.h

diff --git a/lib/migrate.c b/lib/migrate.c
new file mode 100644
index 000000000000..50e78fb08865
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
+	puts("Please migrate me, then press return\n");
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
-- 
2.36.1

