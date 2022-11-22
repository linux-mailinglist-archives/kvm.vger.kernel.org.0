Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA51D63412E
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiKVQP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiKVQOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFDD6EB50
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:52 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMEbFUZ010103
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZLGK717oQ4tgdGOwkP+QXXZSQK4t0PpspbxonpYgWyI=;
 b=XlNzcHAoXf6YqUZf/bJ80UiFTpxQ5+jHwXvdkvONwMkNbiaZ8sE7PlJ7zMCegSHECJvW
 +DDRgoQLhVWSmgVGq1/30F9z49fauvctw42mp3Cc6eH2yFTFWsnnlpBv2CaFW4VeE1uX
 UPVLlqCTcKRCdwaBrSyHwkXoL30djUIsn4QWz8W4kH1ywe3ivFbNGJLKeo+v7RaiX41t
 A/6fjlQNo8fFrmKD0sdeWnivu2CIiAXz9w5Fr9MUd38ZwEkXObvzwArIo+EvdkPkK97h
 iqi/RnCeJ6AytjbUfw4IAjHGJyBBy5g7wj1No/FU/61Yygn0xtp19A5t9w/P04uKmhuj LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10bkjn3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:12:52 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AMFlK3K019886
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:12:51 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10bkjn1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 16:12:51 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AMG6fmI002480;
        Tue, 22 Nov 2022 16:12:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8k9jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 16:12:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AMGCilS6292056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 16:12:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC8564C040;
        Tue, 22 Nov 2022 16:12:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 788F44C04A;
        Tue, 22 Nov 2022 16:12:44 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Nov 2022 16:12:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/2] s390x: add a library for CMM-related functions
Date:   Tue, 22 Nov 2022 17:12:42 +0100
Message-Id: <20221122161243.214814-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221122161243.214814-1-nrb@linux.ibm.com>
References: <20221122161243.214814-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y2FabRj5bmI-PTGsbItPzlcxCEyKLETD
X-Proofpoint-GUID: jEuI2Q_jyviNm21N7QylDIB-6YbPjOAM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_10,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=786 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211220121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will add a test which is very similar to the existing
CMM migration test. To reduce code duplication, move the common function
to a library which can be re-used by both tests.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/cmm.c       | 83 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/cmm.h       | 29 +++++++++++++++
 s390x/Makefile        |  1 +
 s390x/migration-cmm.c | 36 ++++++-------------
 4 files changed, 123 insertions(+), 26 deletions(-)
 create mode 100644 lib/s390x/cmm.c
 create mode 100644 lib/s390x/cmm.h

diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
new file mode 100644
index 000000000000..9609cea68950
--- /dev/null
+++ b/lib/s390x/cmm.c
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CMM test library
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <bitops.h>
+#include "cmm.h"
+
+/*
+ * Maps ESSA actions to states the page is allowed to be in after the
+ * respective action was executed.
+ */
+const int allowed_essa_state_masks[4] = {
+	BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
+	BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
+	BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
+	BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
+};
+
+static inline unsigned long get_page_addr(uint8_t *pagebuf, int page_idx)
+{
+	return (unsigned long)(pagebuf + PAGE_SIZE * page_idx);
+}
+
+/*
+ * Set CMM page states on pagebuf.
+ * pagebuf must point to page_count consecutive pages.
+ * page_count must be a multiple of 4.
+ */
+void cmm_set_page_states(uint8_t *pagebuf, int page_count)
+{
+	int i;
+
+	assert(page_count % 4 == 0);
+	for (i = 0; i < page_count; i += 4) {
+		essa(ESSA_SET_STABLE, get_page_addr(pagebuf, i));
+		essa(ESSA_SET_UNUSED, get_page_addr(pagebuf, i + 1));
+		essa(ESSA_SET_VOLATILE, get_page_addr(pagebuf, i + 2));
+		essa(ESSA_SET_POT_VOLATILE, get_page_addr(pagebuf, i + 3));
+	}
+}
+
+/*
+ * Verify CMM page states on pagebuf.
+ * Page states must have been set by cmm_set_page_states on pagebuf before.
+ * page_count must be a multiple of 4.
+ *
+ * If page states match the expected result,
+ * will return true and result will be untouched. When a mismatch occurs, will
+ * return false and result will be filled with details on the first mismatch.
+ */
+bool cmm_verify_page_states(uint8_t *pagebuf, int page_count, struct cmm_verify_result *result)
+{
+	int i, state_mask, actual_state;
+
+	assert(page_count % 4 == 0);
+
+	for (i = 0; i < page_count; i++) {
+		actual_state = essa(ESSA_GET_STATE, get_page_addr(pagebuf, i));
+		/* extract the usage state in bits 60 and 61 */
+		actual_state = (actual_state >> 2) & 0x3;
+		state_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
+		if (!(BIT(actual_state) & state_mask)) {
+			result->page_mismatch = i;
+			result->expected_mask = state_mask;
+			result->actual_mask = BIT(actual_state);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+void cmm_report_verify_fail(struct cmm_verify_result const *result)
+{
+	report_fail("page state mismatch: first page = %d, expected_mask = 0x%x, actual_mask = 0x%x", result->page_mismatch, result->expected_mask, result->actual_mask);
+}
+
diff --git a/lib/s390x/cmm.h b/lib/s390x/cmm.h
new file mode 100644
index 000000000000..56e188c78704
--- /dev/null
+++ b/lib/s390x/cmm.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CMM test library
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#ifndef S390X_CMM_H
+#define S390X_CMM_H
+
+#include <libcflat.h>
+#include <asm/page.h>
+#include <asm/cmm.h>
+
+struct cmm_verify_result {
+	int page_mismatch;
+	int expected_mask;
+	int actual_mask;
+};
+
+void cmm_set_page_states(uint8_t *pagebuf, int page_count);
+
+bool cmm_verify_page_states(uint8_t *pagebuf, int page_count, struct cmm_verify_result *result);
+
+void cmm_report_verify_fail(struct cmm_verify_result const *result);
+
+#endif /* S390X_CMM_H */
diff --git a/s390x/Makefile b/s390x/Makefile
index bf1504f9d58c..401cb6371cee 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -99,6 +99,7 @@ cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
 cflatobjs += lib/s390x/fault.o
+cflatobjs += lib/s390x/cmm.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/migration-cmm.c b/s390x/migration-cmm.c
index aa7910ca76bf..ffd656f4db75 100644
--- a/s390x/migration-cmm.c
+++ b/s390x/migration-cmm.c
@@ -14,41 +14,25 @@
 #include <asm/cmm.h>
 #include <bitops.h>
 
+#include "cmm.h"
+
 #define NUM_PAGES 128
-static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
 static void test_migration(void)
 {
-	int i, state_mask, actual_state;
-	/*
-	 * Maps ESSA actions to states the page is allowed to be in after the
-	 * respective action was executed.
-	 */
-	int allowed_essa_state_masks[4] = {
-		BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
-		BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
-		BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
-		BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
-	};
+	struct cmm_verify_result result = {};
 
-	assert(NUM_PAGES % 4 == 0);
-	for (i = 0; i < NUM_PAGES; i += 4) {
-		essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
-		essa(ESSA_SET_UNUSED, (unsigned long)pagebuf[i + 1]);
-		essa(ESSA_SET_VOLATILE, (unsigned long)pagebuf[i + 2]);
-		essa(ESSA_SET_POT_VOLATILE, (unsigned long)pagebuf[i + 3]);
-	}
+	cmm_set_page_states(pagebuf, NUM_PAGES);
 
 	puts("Please migrate me, then press return\n");
 	(void)getchar();
 
-	for (i = 0; i < NUM_PAGES; i++) {
-		actual_state = essa(ESSA_GET_STATE, (unsigned long)pagebuf[i]);
-		/* extract the usage state in bits 60 and 61 */
-		actual_state = (actual_state >> 2) & 0x3;
-		state_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
-		report(BIT(actual_state) & state_mask, "page %d state: expected_mask=0x%x actual_mask=0x%lx", i, state_mask, BIT(actual_state));
-	}
+	if (!cmm_verify_page_states(pagebuf, NUM_PAGES, &result))
+		cmm_report_verify_fail(&result);
+	else
+		report_pass("page states match");
 }
 
 int main(void)
-- 
2.36.1

