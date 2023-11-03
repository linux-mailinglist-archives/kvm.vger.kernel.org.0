Return-Path: <kvm+bounces-476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BCD7E0006
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 10:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35EE9281F3A
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 09:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CE11642F;
	Fri,  3 Nov 2023 09:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GFs9Exox"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14302134B4
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 09:30:04 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41043D49;
	Fri,  3 Nov 2023 02:30:01 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A39BXVf011424;
	Fri, 3 Nov 2023 09:30:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Kr0ruugdYfQ2+j9eszGBFIgWzZ6mr78TM0PEYiLTZOE=;
 b=GFs9ExoxgtIdBYG1zNdFZg52u2d2K3oPbn9Uj3VyAhjiFLyN1g33L4RaJe6uBG7BCbb7
 3XeGIcXj/L0hO1wKBIlFwW56KMD1TaFV+3v8QXX8Fkne3Fk4qtPAl+h0w8RRv2gQlR+8
 IMP2oC8Vy+49c1OfGE+1pf7OaL4byitIHy5AawN++mZKnaQzI/x1gp72++duo9TS5wIt
 QRBDQM0rBaLJ9JJoemSE37zecPTVY9OiLLjljV+4rgG+aBsRnNc9+y4Pi7AIkEu8ynfk
 syd+8vEnl6o/LaNQsd2Y0PTB6KlTxcXY/CW4nr7Ehi1JiGMr8e6echyQM7MEaplw9Hl7 +A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4w811ryy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:30:00 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A39Ax9V010434;
	Fri, 3 Nov 2023 09:30:00 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4w811ryg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:30:00 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A38QZtK019895;
	Fri, 3 Nov 2023 09:29:59 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1d10557g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A39TtRl40239532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 09:29:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDAB520043;
	Fri,  3 Nov 2023 09:29:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB9012004B;
	Fri,  3 Nov 2023 09:29:55 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 09:29:55 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 7/8] s390x: add a test for SIE without MSO/MSL
Date: Fri,  3 Nov 2023 10:29:36 +0100
Message-ID: <20231103092954.238491-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231103092954.238491-1-nrb@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _7-y3skvTj-wT2NaJE9GR2u-IZkgrBky
X-Proofpoint-GUID: d5ttbzT3c9w2EqzoFzq_FNx1Jc_Aw-es
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030078

Since we now have the ability to run guests without MSO/MSL, add a test
to make sure this doesn't break.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile             |   2 +
 s390x/sie-dat.c            | 110 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  52 ++++++++++++++++++
 s390x/snippets/c/sie-dat.h |   2 +
 s390x/unittests.cfg        |   3 +
 5 files changed, 169 insertions(+)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.h

diff --git a/s390x/Makefile b/s390x/Makefile
index 947a4344738f..f79fd0098312 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -41,6 +41,7 @@ tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
 tests += $(TEST_DIR)/topology.elf
+tests += $(TEST_DIR)/sie-dat.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
@@ -123,6 +124,7 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
 $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
+$(TEST_DIR)/sie-dat.elf: snippets = $(SNIPPET_DIR)/c/sie-dat.gbin
 $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
 
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-yield.gbin
diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
new file mode 100644
index 000000000000..89e2c4c13db2
--- /dev/null
+++ b/s390x/sie-dat.c
@@ -0,0 +1,110 @@
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
+#include <asm/pgtable.h>
+#include <mmu.h>
+#include <asm/page.h>
+#include <asm/interrupt.h>
+#include <alloc_page.h>
+#include <sclp.h>
+#include <sie.h>
+#include <snippet.h>
+#include "snippets/c/sie-dat.h"
+
+static struct vm vm;
+static pgd_t *guest_root;
+
+static void test_sie_dat(void)
+{
+	uint64_t test_page_gpa, test_page_hpa;
+	uint8_t *test_page_hva, expected_val;
+	bool contents_match;
+	uint8_t r1;
+
+	/* guest will tell us the guest physical address of the test buffer */
+	sie(&vm);
+
+	r1 = (vm.sblk->ipa & 0xf0) >> 4;
+	test_page_gpa = vm.save_area.guest.grs[r1];
+	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
+	test_page_hva = __va(test_page_hpa);
+	assert(vm.sblk->icptcode == ICPT_INST &&
+	       (vm.sblk->ipa & 0xff00) == 0x8300 && vm.sblk->ipb == 0x9c0000);
+	report_info("test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
+
+	/* guest will now write to the test buffer and we verify the contents */
+	sie(&vm);
+	assert(vm.sblk->icptcode == ICPT_INST &&
+	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
+
+	contents_match = true;
+	for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {
+		expected_val = 42 + i;
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
index 000000000000..e07136bf7430
--- /dev/null
+++ b/s390x/snippets/c/sie-dat.c
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet used by the sie-dat.c test to verify paging without MSO/MSL
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <asm-generic/page.h>
+#include "sie-dat.h"
+
+static uint8_t test_page[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
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
+int main(void)
+{
+	uint8_t *invalid_ptr;
+
+	memset(test_page, 0, sizeof(test_page));
+	/* tell the host the page's physical address (we're running DAT off) */
+	force_exit_value((uint64_t)test_page);
+
+	/* write some value to the page so the host can verify it */
+	for (size_t i = 0; i < GUEST_TEST_PAGE_COUNT; i++)
+		test_page[i * PAGE_SIZE] = 42 + i;
+
+	/* indicate we've written all pages */
+	force_exit();
+
+	/* the first unmapped address */
+	invalid_ptr = (uint8_t *)(GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE);
+	*invalid_ptr = 42;
+
+	/* indicate we've written the non-allowed page (should never get here) */
+	force_exit();
+
+	return 0;
+}
diff --git a/s390x/snippets/c/sie-dat.h b/s390x/snippets/c/sie-dat.h
new file mode 100644
index 000000000000..ed3f99f75f9c
--- /dev/null
+++ b/s390x/snippets/c/sie-dat.h
@@ -0,0 +1,2 @@
+#define GUEST_TEST_PAGE_COUNT 10
+#define GUEST_TOTAL_PAGE_COUNT 256
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 68e119e4fcaa..184658ff7d8d 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -247,3 +247,6 @@ file = topology.elf
 [topology-2]
 file = topology.elf
 extra_params = -cpu max,ctop=on -smp sockets=31,cores=8,maxcpus=248  -append '-sockets 31 -cores 8'
+
+[sie-dat]
+file = sie-dat.elf
-- 
2.41.0


