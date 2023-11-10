Return-Path: <kvm+bounces-1485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D19527E7CC4
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88BF92809CA
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8E83A27E;
	Fri, 10 Nov 2023 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aAPK0iHa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2670B1BDFB
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:49 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57EA38220
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:47 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADoB6u003417;
	Fri, 10 Nov 2023 13:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=qCL0Te1PXnD3zGTg78WCdv69FXrpjLoxymnS3IPU/D8=;
 b=aAPK0iHa6tXPDrkfE9V3refYgsUrxKlFNd88KMlZvYD5A99JjeqKM8daLi5R3Xr8gWlQ
 51PVpAISsvYokaxvrHZy/L0+pnhhyi5tHC+cWrfiN5XMVF62ajYyLf3sB8l2x7qtKHc6
 QpoEBEWALMo3e/TDpGsWJgBNuWRDIsKk/c+b9+osADFSxa42/FAtOHzbLGBkiMmGy1C6
 lwwU+77Nv7GA19Wd7Dt6L3PT48xAmPQusU1S0Q6LSDAAdCmGgPVaD/SE6Qh/31THXlso
 uZp2HOkORT5Dfhon964QYZ/ibuPh50Ot//GU26XKZmsJHkekVTWF1N8L4kFUnOZDR1tR Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nrd04yn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:45 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADoRit004134;
	Fri, 10 Nov 2023 13:54:45 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nrd04ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:44 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAAueFk014332;
	Fri, 10 Nov 2023 13:54:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b7xv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:44 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADseuC18940476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:40 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FDBA20040;
	Fri, 10 Nov 2023 13:54:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 776472004B;
	Fri, 10 Nov 2023 13:54:38 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:38 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 25/26] s390x: add a test for SIE without MSO/MSL
Date: Fri, 10 Nov 2023 14:52:34 +0100
Message-ID: <20231110135348.245156-26-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VehbY6K1mvRqvwHHL2_94YzV2drit9YR
X-Proofpoint-ORIG-GUID: m20bxVaoQt85Zw6ic0qtmUA68tI6Yu39
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

Since we now have the ability to run guests without MSO/MSL, add a test
to make sure this doesn't break.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106163738.1116942-8-nrb@linux.ibm.com
[ nrb: __pa -> virt_to_pte_phys to fix incompatiblity with 2g align ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile             |   2 +
 s390x/snippets/c/sie-dat.h |   2 +
 s390x/sie-dat.c            | 114 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  57 +++++++++++++++++++
 s390x/unittests.cfg        |   3 +
 5 files changed, 178 insertions(+)
 create mode 100644 s390x/snippets/c/sie-dat.h
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 947a434..f79fd00 100644
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
diff --git a/s390x/snippets/c/sie-dat.h b/s390x/snippets/c/sie-dat.h
new file mode 100644
index 0000000..ed3f99f
--- /dev/null
+++ b/s390x/snippets/c/sie-dat.h
@@ -0,0 +1,2 @@
+#define GUEST_TEST_PAGE_COUNT 10
+#define GUEST_TOTAL_PAGE_COUNT 256
diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
new file mode 100644
index 0000000..f025777
--- /dev/null
+++ b/s390x/sie-dat.c
@@ -0,0 +1,114 @@
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
+	assert(vm.sblk->icptcode == ICPT_INST &&
+	       (vm.sblk->ipa & 0xff00) == 0x8300 && vm.sblk->ipb == 0x9c0000);
+
+	r1 = (vm.sblk->ipa & 0xf0) >> 4;
+	test_page_gpa = vm.save_area.guest.grs[r1];
+	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
+	test_page_hva = __va(test_page_hpa);
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
+	report((lowcore.trans_exc_id & PAGE_MASK) == (GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE), "TEID address match");
+	report_prefix_pop();
+}
+
+static void setup_guest(void)
+{
+	extern const char SNIPPET_NAME_START(c, sie_dat)[];
+	extern const char SNIPPET_NAME_END(c, sie_dat)[];
+	uint64_t guest_max_addr;
+	pgd_t *root;
+
+	setup_vm();
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
+
+	snippet_setup_guest(&vm, false);
+
+	/* allocate a region-1 table */
+	guest_root = pgd_alloc_one();
+
+	/* map guest memory 1:1 */
+	guest_max_addr = GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE;
+	for (uint64_t i = 0; i < guest_max_addr; i += PAGE_SIZE)
+		install_page(guest_root, virt_to_pte_phys(root, vm.guest_mem + i), (void *)i);
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
index 0000000..ecfcb60
--- /dev/null
+++ b/s390x/snippets/c/sie-dat.c
@@ -0,0 +1,57 @@
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
+static uint8_t test_pages[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+
+static inline void force_exit(void)
+{
+	asm volatile("diag	0,0,0x44\n"
+		     :
+		     :
+		     : "memory"
+	);
+}
+
+static inline void force_exit_value(uint64_t val)
+{
+	asm volatile("diag	%[val],0,0x9c\n"
+		     :
+		     : [val] "d"(val)
+		     : "memory"
+	);
+}
+
+int main(void)
+{
+	uint8_t *invalid_ptr;
+
+	memset(test_pages, 0, sizeof(test_pages));
+	/* tell the host the page's physical address (we're running DAT off) */
+	force_exit_value((uint64_t)test_pages);
+
+	/* write some value to the page so the host can verify it */
+	for (size_t i = 0; i < GUEST_TEST_PAGE_COUNT; i++)
+		test_pages[i * PAGE_SIZE] = 42 + i;
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
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b08b0fb..f5024b6 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -380,3 +380,6 @@ extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores
 -device max-s390x-cpu,core-id=97,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
 -device max-s390x-cpu,core-id=111,drawer-id=1,book-id=1,socket-id=1,entitlement=medium,dedicated=false \
 """
+
+[sie-dat]
+file = sie-dat.elf
-- 
2.41.0


