Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC6A4FB910
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345115AbiDKKKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243588AbiDKKKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:10:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD763ED05;
        Mon, 11 Apr 2022 03:07:57 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B7MYrj024906;
        Mon, 11 Apr 2022 10:07:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+PqsMJGKUEmMMM35u//Y7G7zb+EWkqi+b/C4I7iLcWw=;
 b=He/8RZndAFR61Fd2pmL+qg8PRkd1glUyh61/qDnYD0EZ7geQO2qrhyeX/rKpbQXug/Wo
 mUTGAbMhVs7TXIAsZpGUm/sgMjlCbXl/6LdSgm9P57J1pMzAyjz2H9WG7QL3n1yxSaN5
 gmLHlXiHRvOx07elhs6t2p+6zBUK4a7t1Wazx0eSBr0/jfgMiGsWRJoCGGGyOsgJfUYw
 37zTLIeECUASpq74NBEqWRRErVkk/JBopoj/YDlKqYjGvbhTzPdQTi+u3Qqx0yJGMs6C
 S7hOaEibzRdmNp9C73BO7RlhAegq75et2qHBlrn4hi2coRV+stjgvngzCUtf0uxDc9x4 +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcfvwu37a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:57 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23B9YEWj038524;
        Mon, 11 Apr 2022 10:07:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcfvwu36e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BA7kWg025612;
        Mon, 11 Apr 2022 10:07:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fb1s8tv9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BA80RV46727672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:08:00 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C157AA405C;
        Mon, 11 Apr 2022 10:07:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85B57A405B;
        Mon, 11 Apr 2022 10:07:51 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 10:07:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 4/4] s390x: add selftest for migration
Date:   Mon, 11 Apr 2022 12:07:50 +0200
Message-Id: <20220411100750.2868587-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220411100750.2868587-1-nrb@linux.ibm.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wTJF2rsqPoVoCfZd0hE9IFO4eGaE-XBp
X-Proofpoint-GUID: 0az5u5Db79NuQ-jQdSVNutK5cdoY4Bha
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_03,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 bulkscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204110057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest to check we can do migration tests.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile             |  1 +
 s390x/selftest-migration.c | 27 +++++++++++++++++++++++++++
 s390x/unittests.cfg        |  4 ++++
 3 files changed, 32 insertions(+)
 create mode 100644 s390x/selftest-migration.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 62e197cb93d7..2e43e323bcb5 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -26,6 +26,7 @@ tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
 tests += $(TEST_DIR)/firq.elf
+tests += $(TEST_DIR)/selftest-migration.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/selftest-migration.c b/s390x/selftest-migration.c
new file mode 100644
index 000000000000..8884322a84ca
--- /dev/null
+++ b/s390x/selftest-migration.c
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Migration Selftest
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+
+int main(void)
+{
+	/* don't say migrate here otherwise we will migrate right away */
+	report_prefix_push("selftest migration");
+
+	/* ask migrate_cmd to migrate (it listens for 'migrate') */
+	puts("Please migrate me\n");
+
+	/* wait for migration to finish, we will read a newline */
+	(void)getchar();
+
+	report_pass("Migrated");
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 1600e714c8b9..b0417a69705d 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -24,6 +24,10 @@ groups = selftest
 # please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
 extra_params = -append 'test 123'
 
+[selftest-migration]
+file = selftest-migration.elf
+groups = selftest migration
+
 [intercept]
 file = intercept.elf
 
-- 
2.31.1

