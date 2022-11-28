Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E005563A962
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 14:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiK1NXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 08:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiK1NXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 08:23:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1599663CE
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 05:23:31 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASBks6l017699
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YGov1YcRyPp+KE1GSlfy+aH+WY/Wj2kNzj2T3jOctYg=;
 b=PVvqnmFbs+29PW2fPjOVV8RmhoHrCH/hQ27aIQjaWXZ27l3RFMGG9CG+/azsfwB3iNv+
 o35FoHU9mA7rQg2alHSImthKHW7hZvcAy3p9FER37fmreH/Mut0NYz3ubX86uSAbNqaj
 ILfhp+kpS4YaNXzrwTZwl0KyTQRrwSprRPJvTXdDXqNG9dXQmY/yReHBkY45p4DWH+BN
 E1+lxS4mt1IhMML2D11GI4iJotWqmrbukKMoG5clQuDnrz1s/CMJDWbly9L+b0ZppP6i
 +maT53qluJWs55HX1NjWoXTJIxM9fDPQc//GAUDQ1VX8vBM8ia+vkU/nJRdupwutS9p6 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vr1g5sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:30 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASCjVf2024732
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vr1g5rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 13:23:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASDLD7M014540;
        Mon, 28 Nov 2022 13:23:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3m3ae99upt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 13:23:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASDO76d4522690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 13:24:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC2724C044;
        Mon, 28 Nov 2022 13:23:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 787FC4C04A;
        Mon, 28 Nov 2022 13:23:24 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 13:23:24 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/2] s390x: add a library for CMM-related functions
Date:   Mon, 28 Nov 2022 14:23:22 +0100
Message-Id: <20221128132323.1964532-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221128132323.1964532-1-nrb@linux.ibm.com>
References: <20221128132323.1964532-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Y44lGYGV7SD81nZUOnTpN2i3WuJtbubW
X-Proofpoint-GUID: JzQDzg6isgsQIqxlMWzdog7r-H3jm3jr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_11,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 mlxlogscore=881 clxscore=1015
 malwarescore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280096
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/cmm.c       | 92 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/cmm.h       | 31 +++++++++++++++
 s390x/Makefile        |  1 +
 s390x/migration-cmm.c | 34 ++++------------
 4 files changed, 132 insertions(+), 26 deletions(-)
 create mode 100644 lib/s390x/cmm.c
 create mode 100644 lib/s390x/cmm.h

diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
new file mode 100644
index 000000000000..d1399a7445c1
--- /dev/null
+++ b/lib/s390x/cmm.c
@@ -0,0 +1,92 @@
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
+static const unsigned long allowed_essa_state_masks[4] = {
+	BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
+	BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
+	BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
+	BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
+};
+
+/*
+ * Set CMM page states on pagebuf.
+ * pagebuf must point to page_count consecutive pages.
+ * page_count must be a multiple of 4.
+ */
+void cmm_set_page_states(uint8_t *pagebuf, unsigned long page_count)
+{
+	unsigned long addr = (unsigned long)pagebuf;
+	unsigned long i;
+
+	assert(page_count % 4 == 0);
+	for (i = 0; i < page_count; i += 4) {
+		essa(ESSA_SET_STABLE, addr + i * PAGE_SIZE);
+		essa(ESSA_SET_UNUSED, addr + (i + 1) * PAGE_SIZE);
+		essa(ESSA_SET_VOLATILE, addr + (i + 2) * PAGE_SIZE);
+		essa(ESSA_SET_POT_VOLATILE, addr + (i + 3) * PAGE_SIZE);
+	}
+}
+
+/*
+ * Verify CMM page states on pagebuf.
+ * Page states must have been set by cmm_set_page_states on pagebuf before.
+ * page_count must be a multiple of 4.
+ *
+ * If page states match the expected result, will return a cmm_verify_result
+ * with verify_failed false. All other fields are then invalid.
+ * If there is a mismatch, the returned struct will have verify_failed true
+ * and will be filled with details on the first mismatch encountered.
+ */
+struct cmm_verify_result cmm_verify_page_states(uint8_t *pagebuf, unsigned long page_count)
+{
+	struct cmm_verify_result result = {
+		.verify_failed = true
+	};
+	unsigned long expected_mask, actual_mask;
+	unsigned long addr, i;
+
+	assert(page_count % 4 == 0);
+
+	for (i = 0; i < page_count; i++) {
+		addr = (unsigned long)(pagebuf + i * PAGE_SIZE);
+		actual_mask = essa(ESSA_GET_STATE, addr);
+		/* usage state in bits 60 and 61 */
+		actual_mask = BIT((actual_mask >> 2) & 0x3);
+		expected_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
+		if (!(actual_mask & expected_mask)) {
+			result.page_mismatch_idx = i;
+			result.page_mismatch_addr = addr;
+			result.expected_mask = expected_mask;
+			result.actual_mask = actual_mask;
+			return result;
+		}
+	}
+
+	result.verify_failed = false;
+	return result;
+}
+
+void cmm_report_verify(struct cmm_verify_result const *result)
+{
+	if (result->verify_failed)
+		report_fail("page state mismatch: first page idx = %lu, addr = %lx, "
+			"expected_mask = 0x%x, actual_mask = 0x%x",
+			result->page_mismatch_idx, result->page_mismatch_addr,
+			result->expected_mask, result->actual_mask);
+	else
+		report_pass("page states match");
+}
diff --git a/lib/s390x/cmm.h b/lib/s390x/cmm.h
new file mode 100644
index 000000000000..9794e091517e
--- /dev/null
+++ b/lib/s390x/cmm.h
@@ -0,0 +1,31 @@
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
+	bool verify_failed;
+	char expected_mask;
+	char actual_mask;
+	unsigned long page_mismatch_idx;
+	unsigned long page_mismatch_addr;
+};
+
+void cmm_set_page_states(uint8_t *pagebuf, unsigned long page_count);
+
+struct cmm_verify_result cmm_verify_page_states(uint8_t *pagebuf, unsigned long page_count);
+
+void cmm_report_verify(struct cmm_verify_result const *result);
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
index aa7910ca76bf..720ef9fb9799 100644
--- a/s390x/migration-cmm.c
+++ b/s390x/migration-cmm.c
@@ -14,41 +14,23 @@
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
+	struct cmm_verify_result result;
 
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
+	result = cmm_verify_page_states(pagebuf, NUM_PAGES);
+	cmm_report_verify(&result);
 }
 
 int main(void)
-- 
2.36.1

