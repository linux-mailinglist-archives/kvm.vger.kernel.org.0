Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21279704EB3
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 15:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbjEPNGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 09:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbjEPNFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 09:05:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095AE10CE;
        Tue, 16 May 2023 06:05:40 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GCceKF014928;
        Tue, 16 May 2023 13:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NmWEYHHJsQt9oR78Y8qU/6tRj+VEuwf6CQyBnV8YYdw=;
 b=W8ZB7hXVPy9odAo5WsRFVM8ary9kvRhHqJ5YoKdO+1zg+hUsvb6nnRxMawk3OAc2/dL/
 a7xp/tsz/zwBcyvqPzwOqdeCtx2270ywko7zvxF9bK3ruskIENjXOmmyurFFMCUYaiMk
 CUjWObkBgYb1vfkYeejfGK9YXeWQa76nFrkLnXflHvP8SPo5DTh7UD82mluxeI1soyvU
 ucgCoi0G97WIwgrxCM3ofq6CJSny5nlrqXSf2tTkZpGLvoq44yONcyDMDwVeVoP950+n
 SatJSI7hIEL4FTP/GK+KSrnZ5p6UuoRxKi2vamrVOYVe7yz3bi8yWUPSIcOaFk0c6Hme vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8h63xjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:39 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GD54dk024891;
        Tue, 16 May 2023 13:05:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8h63w8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G68OcI009970;
        Tue, 16 May 2023 13:05:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qj264snjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:01 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GD4vKI21627590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 13:04:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1B2D20040;
        Tue, 16 May 2023 13:04:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BAF120043;
        Tue, 16 May 2023 13:04:57 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 13:04:57 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 6/6] s390x: add a test for SIE without MSO/MSL
Date:   Tue, 16 May 2023 15:04:56 +0200
Message-Id: <20230516130456.256205-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230516130456.256205-1-nrb@linux.ibm.com>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aqlUPz_bqFoNnj6Z5htusPPSNysAPN7i
X-Proofpoint-ORIG-GUID: N80oCQeZsXDVnULIrQtgDk0LvIkGNDhY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_06,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we now have the ability to run guests without MSO/MSL, add a test
to make sure this doesn't break.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile             |   2 +
 s390x/sie-dat.c            | 120 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  58 ++++++++++++++++++
 s390x/unittests.cfg        |   3 +
 4 files changed, 183 insertions(+)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a80db538810e..4921669ee4c3 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -40,6 +40,7 @@ tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
+tests += $(TEST_DIR)/sie-dat.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
@@ -120,6 +121,7 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
 $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
+$(TEST_DIR)/sie-dat.elf: snippets = $(SNIPPET_DIR)/c/sie-dat.gbin
 $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
 
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
new file mode 100644
index 000000000000..c490a2aa825c
--- /dev/null
+++ b/s390x/sie-dat.c
@@ -0,0 +1,120 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Tests SIE with paging.
+ *
+ * Copyright 2023 IBM Corp.
+ *
+ * Authors:
+ *    Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <vmalloc.h>
+#include <asm/asm-offsets.h>
+#include <asm-generic/barrier.h>
+#include <asm/pgtable.h>
+#include <mmu.h>
+#include <asm/page.h>
+#include <asm/facility.h>
+#include <asm/interrupt.h>
+#include <asm/mem.h>
+#include <alloc_page.h>
+#include <sclp.h>
+#include <sie.h>
+#include <snippet.h>
+
+static struct vm vm;
+static pgd_t *guest_root;
+
+/* keep in sync with TEST_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
+#define GUEST_TEST_PAGE_COUNT 10
+
+/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
+#define GUEST_TOTAL_PAGE_COUNT 256
+
+static void test_sie_dat(void)
+{
+	uint8_t r1;
+	bool contents_match;
+	uint64_t test_page_gpa, test_page_hpa;
+	uint8_t *test_page_hva;
+
+	/* guest will tell us the guest physical address of the test buffer */
+	sie(&vm);
+
+	r1 = (vm.sblk->ipa & 0xf0) >> 4;
+	test_page_gpa = vm.save_area.guest.grs[r1];
+	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
+	test_page_hva = __va(test_page_hpa);
+	report(vm.sblk->icptcode == ICPT_INST &&
+	       (vm.sblk->ipa & 0xFF00) == 0x8300 && vm.sblk->ipb == 0x9c0000,
+	       "test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
+
+	/* guest will now write to the test buffer and we verify the contents */
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_INST &&
+	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000,
+	       "guest wrote to test buffer");
+
+	contents_match = true;
+	for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {
+		uint8_t expected_val = 42 + i;
+		if (test_page_hva[i * PAGE_SIZE] != expected_val) {
+			report_fail("page %u mismatch actual_val=%x expected_val=%x",
+				    i, test_page_hva[i], expected_val);
+			contents_match = false;
+		}
+	}
+	report(contents_match, "test buffer contents match");
+
+	/* the guest will now write to an unmapped address and we check that this causes a segment translation exception */
+	report_prefix_push("guest write to unmapped");
+	expect_pgm_int();
+	sie(&vm);
+	check_pgm_int_code(PGM_INT_CODE_SEGMENT_TRANSLATION);
+	report_prefix_pop();
+}
+
+static void setup_guest(void)
+{
+	extern const char SNIPPET_NAME_START(c, sie_dat)[];
+	extern const char SNIPPET_NAME_END(c, sie_dat)[];
+	uint64_t guest_max_addr;
+
+	setup_vm();
+	snippet_setup_guest(&vm, false);
+
+	/* allocate a region-1 table */
+	guest_root = pgd_alloc_one();
+
+	/* map guest memory 1:1 */
+	guest_max_addr = GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE;
+	for (uint64_t i = 0; i < guest_max_addr; i += PAGE_SIZE)
+		install_page(guest_root, __pa(vm.guest_mem + i), (void *)i);
+
+	/* set up storage limit supression - leave mso and msl intact they are ignored anyways */
+	vm.sblk->cpuflags |= CPUSTAT_SM;
+
+	/* set up the guest asce */
+	vm.save_area.guest.asce = __pa(guest_root) | ASCE_DT_REGION1 | REGION_TABLE_LENGTH;
+
+	snippet_init(&vm, SNIPPET_NAME_START(c, sie_dat),
+		     SNIPPET_LEN(c, sie_dat), SNIPPET_UNPACK_OFF);
+}
+
+int main(void)
+{
+	report_prefix_push("sie-dat");
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto done;
+	}
+
+	setup_guest();
+	test_sie_dat();
+	sie_guest_destroy(&vm);
+
+done:
+	report_prefix_pop();
+	return report_summary();
+
+}
diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
new file mode 100644
index 000000000000..e156d0c36c4c
--- /dev/null
+++ b/s390x/snippets/c/sie-dat.c
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet used by the sie-dat.c test to verify paging without MSO/MSL
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <stddef.h>
+#include <inttypes.h>
+#include <string.h>
+#include <asm-generic/page.h>
+
+/* keep in sync with GUEST_TEST_PAGE_COUNT in s390x/sie-dat.c */
+#define TEST_PAGE_COUNT 10
+static uint8_t test_page[TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+
+/* keep in sync with GUEST_TOTAL_PAGE_COUNT in s390x/sie-dat.c */
+#define TOTAL_PAGE_COUNT 256
+
+static inline void force_exit(void)
+{
+	asm volatile("diag	0,0,0x44\n");
+}
+
+static inline void force_exit_value(uint64_t val)
+{
+	asm volatile(
+		"diag	%[val],0,0x9c\n"
+		: : [val] "d"(val)
+	);
+}
+
+__attribute__((section(".text"))) int main(void)
+{
+	uint8_t *invalid_ptr;
+
+	memset(test_page, 0, sizeof(test_page));
+	/* tell the host the page's physical address (we're running DAT off) */
+	force_exit_value((uint64_t)test_page);
+
+	/* write some value to the page so the host can verify it */
+	for (size_t i = 0; i < TEST_PAGE_COUNT; i++)
+		test_page[i * PAGE_SIZE] = 42 + i;
+
+	/* indicate we've written all pages */
+	force_exit();
+
+	/* the first unmapped address */
+	invalid_ptr = (uint8_t *)(TOTAL_PAGE_COUNT * PAGE_SIZE);
+	*invalid_ptr = 42;
+
+	/* indicate we've written the non-allowed page (should never get here) */
+	force_exit();
+
+	return 0;
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b61faf0737c3..24cd27202a08 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -218,3 +218,6 @@ extra_params = -append '--parallel'
 
 [execute]
 file = ex.elf
+
+[sie-dat]
+file = sie-dat.elf
-- 
2.39.1

