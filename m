Return-Path: <kvm+bounces-31456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C509C3E45
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:15:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ADC11C21ACA
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01EC819C575;
	Mon, 11 Nov 2024 12:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JmSFcsd3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E5F15B0EC;
	Mon, 11 Nov 2024 12:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731327342; cv=none; b=SYce7toCkoqO2fdjLx7plTkZQOD35YBqLVkkck1DjNSj1ihX46FvDc6C359B6gvI8h+oLe8+3Sv0S8xtaycKZIPxPm9FJ618QGlKDEDbeUE/KrB8H7g6GAVviWpO/NRMHwMUKasbjH4t9xoZEQxKUmBmslaEynOM0siWKpY/wDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731327342; c=relaxed/simple;
	bh=1MVzytf3AcW/G2IHcZ2Z+50yYKFyFrFZ3HHtYMyvPGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q3+finxbO2TRnqAwTUtW7Jt5gvlDkFyFyel6VFTKGPrIzei+LCULU2O7C4QKSjVr6CTdU8cCry/FlOXJYc5WSUOK6wA7O+4IJbaxJxctLWp7QXVJz8vBzhZqWC7AXGfFklQUtpIlvXUBB7PJJJvrkMHgpvgTUyZrLB5RElvRFF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JmSFcsd3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABA5Ooo024696;
	Mon, 11 Nov 2024 12:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=LuGelhmyRFxel/8BKJaF8mk6GNMeqcGb6B0ik8wx2
	ew=; b=JmSFcsd3okrsQhcWJnASmnp1R/fzLln+t+jO4oJ8wD643UzwXZXUCmlH1
	7MJMu172GD9WrbnofqQfZIZ+091K8rbJf/cU3qAZlb03AwnEGqBFmrZ7a3eo1HEf
	Uj/LW16+/DcvTHGA2azCqavAtqZlRaGLtFYzOnzQSNUE0BSJx3yvDht44F4scOl5
	h11AoLvg8JNf+G2QcIEfoUhvu/FCyXZAdkU1KRX7ePvQd3IhvUiScoKxlm2JIMlj
	4+oI/OuiBTNfRuEkD70rzxNz8ukCv0uzdeWYiQzXfe5hNNEvqEevCCuexAapSIlF
	ogG+TYkb6753gEE6v/Hln7dCgCL5A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42tpvmvcx9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Nov 2024 12:15:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABBb37J029734;
	Mon, 11 Nov 2024 12:15:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tkjkdd8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Nov 2024 12:15:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ABCFU8642729770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 12:15:30 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E298720043;
	Mon, 11 Nov 2024 12:15:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66E9D20040;
	Mon, 11 Nov 2024 12:15:29 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.179.14.150])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 Nov 2024 12:15:29 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        thuth@redhat.com, david@redhat.com, schlameuss@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/1] s390x: pv: Add test for large host pages backing
Date: Mon, 11 Nov 2024 13:15:29 +0100
Message-ID: <20241111121529.30153-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SdmUF9vZZr_mcDaoxnSesGDn7Cl2Rx3y
X-Proofpoint-GUID: SdmUF9vZZr_mcDaoxnSesGDn7Cl2Rx3y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411110101

Add a new test to check that the host can use 1M large pages to back
protected guests when the corresponding feature is present.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile               |   2 +
 lib/s390x/asm/arch_def.h     |   1 +
 lib/s390x/asm/uv.h           |  18 ++
 s390x/pv-edat1.c             | 463 +++++++++++++++++++++++++++++++++++
 s390x/snippets/c/pv-memhog.c |  59 +++++
 5 files changed, 543 insertions(+)
 create mode 100644 s390x/pv-edat1.c
 create mode 100644 s390x/snippets/c/pv-memhog.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd6..c5c6f92c 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -48,6 +48,7 @@ tests += $(TEST_DIR)/sie-dat.elf
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
 pv-tests += $(TEST_DIR)/pv-ipl.elf
+pv-tests += $(TEST_DIR)/pv-edat1.elf
 
 ifneq ($(HOST_KEY_DOCUMENT),)
 ifneq ($(GEN_SE_HEADER),)
@@ -137,6 +138,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/icpt-loop.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/loop.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timing.gbin
 $(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
+$(TEST_DIR)/pv-edat1.elf: pv-snippets += $(SNIPPET_DIR)/c/pv-memhog.gbin
 
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 745a3387..481ede8f 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -249,6 +249,7 @@ extern struct lowcore lowcore;
 #define PGM_INT_CODE_REGION_FIRST_TRANS		0x39
 #define PGM_INT_CODE_REGION_SECOND_TRANS	0x3a
 #define PGM_INT_CODE_REGION_THIRD_TRANS		0x3b
+#define PGM_INT_CODE_SECURE_PAGE_SIZE		0x3c
 #define PGM_INT_CODE_SECURE_STOR_ACCESS		0x3d
 #define PGM_INT_CODE_NON_SECURE_STOR_ACCESS	0x3e
 #define PGM_INT_CODE_SECURE_STOR_VIOLATION	0x3f
diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 611dcd3f..7527be48 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -35,6 +35,7 @@
 #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
 #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
 #define UVC_CMD_DESTR_SEC_STOR		0x0202
+#define UVC_CMD_VERIFY_LARGE_FRAME	0x0203
 #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
 #define UVC_CMD_UNPACK_IMG		0x0301
 #define UVC_CMD_VERIFY_IMG		0x0302
@@ -74,6 +75,11 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
 	BIT_UVC_CMD_ATTESTATION = 28,
+	BIT_UVC_CMD_VERIFY_LARGE_FRAME = 32,
+};
+
+enum uv_features {
+	BIT_UV_1M_BACKING = 6,
 };
 
 struct uv_cb_header {
@@ -312,6 +318,18 @@ static inline int uv_import(uint64_t handle, unsigned long gaddr)
 	return uv_call(0, (uint64_t)&uvcb);
 }
 
+static inline int uv_merge(uint64_t handle, unsigned long gaddr)
+{
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_VERIFY_LARGE_FRAME,
+		.header.len = sizeof(uvcb),
+		.guest_handle = handle,
+		.gaddr = gaddr,
+	};
+
+	return uv_call(0, (uint64_t)&uvcb);
+}
+
 static inline int uv_export(unsigned long paddr)
 {
 	struct uv_cb_cfs uvcb = {
diff --git a/s390x/pv-edat1.c b/s390x/pv-edat1.c
new file mode 100644
index 00000000..328a6e34
--- /dev/null
+++ b/s390x/pv-edat1.c
@@ -0,0 +1,463 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * PV huge page backing tests
+ *
+ * Copyright (c) 2024 IBM Corp
+ *
+ * Authors:
+ *  Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+#include <asm/interrupt.h>
+#include <asm/facility.h>
+#include <asm/time.h>
+#include <asm/mem.h>
+#include <pv_icptdata.h>
+#include <libcflat.h>
+#include <vmalloc.h>
+#include <snippet.h>
+#include <sclp.h>
+#include <mmu.h>
+
+#define GUEST_ORDER	REGION3_SHIFT
+#define GUEST_SIZE	BIT_ULL(REGION3_SHIFT)
+#define N_ITER 		32
+#define MAGIC_ADDRESS	0x12a000
+
+#define FIRST		42
+#define SECOND		23
+
+#define STR(x)		((x) ? "1m" : "4k")
+#define STR3(x)		((x) != -1 ? STR(x) : "no")
+#define PARAM(n, step)	(((unsigned long)(n) << 32) | (step))
+
+static struct vm vm;
+static void *root;
+
+extern const char SNIPPET_NAME_START(c, pv_memhog)[];
+extern const char SNIPPET_NAME_END(c, pv_memhog)[];
+extern const char SNIPPET_HDR_START(c, pv_memhog)[];
+extern const char SNIPPET_HDR_END(c, pv_memhog)[];
+
+static void init_snippet(struct vm *vm) {
+	const unsigned long size_hdr = SNIPPET_HDR_LEN(c, pv_memhog);
+	const unsigned long size_gbin = SNIPPET_LEN(c, pv_memhog);
+
+	snippet_pv_init(vm, SNIPPET_NAME_START(c, pv_memhog),
+			SNIPPET_HDR_START(c, pv_memhog),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+}
+
+static uint64_t tod_to_us(uint64_t tod)
+{
+	return tod >> STCK_SHIFT_US;
+}
+
+static inline uint64_t guest_start(struct vm *vm)
+{
+	return vm->sblk->mso;
+}
+
+static inline uint64_t guest_end(struct vm *vm)
+{
+	return vm->sblk->msl + SZ_1M;
+}
+
+static inline uint64_t guest_size(struct vm *vm)
+{
+	return guest_end(vm) - guest_start(vm);
+}
+
+static uint16_t uvc_merge(struct vm *vm, uint64_t addr)
+{
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_VERIFY_LARGE_FRAME,
+		.header.len = sizeof(uvcb),
+		.guest_handle = vm->uv.vm_handle,
+		.gaddr = addr,
+	};
+	int cc;
+
+	cc = uv_call(0, (uint64_t)&uvcb);
+	assert(cc ? uvcb.header.rc != 1 : uvcb.header.rc == 1);
+	return uvcb.header.rc;
+}
+
+static void map_identity_range(struct vm *vm, uint64_t start, uint64_t end, bool map1m)
+{
+	uint64_t mem = guest_start(vm);
+
+	if (map1m) {
+		for (start &= HPAGE_MASK; start < end; start += HPAGE_SIZE)
+			install_large_page(root, mem + start, (void *)(mem + start));
+	} else {
+		for (start &= PAGE_SIZE; start < end; start += PAGE_SIZE)
+			install_page(root, mem + start, (void *)(mem + start));
+	}
+}
+
+static inline void map_identity_all(struct vm *vm, bool map1m)
+{
+	map_identity_range(vm, 0, guest_size(vm), map1m);
+}
+
+static void import_range(struct vm *vm, uint64_t start, uint64_t end)
+{
+	for (start &= PAGE_MASK; start < end; start += PAGE_SIZE)
+		assert(uv_import(vm->uv.vm_handle, guest_start(vm) + start) == 0);
+}
+
+static inline void import_all(struct vm *vm)
+{
+	import_range(vm, 0, guest_size(vm));
+}
+
+static void export_range(struct vm *vm, uint64_t start, uint64_t end)
+{
+	for (start &= PAGE_MASK; start < end; start += PAGE_SIZE)
+		assert(uv_export(guest_start(vm) + start) == 0);
+}
+
+static void merge_range(struct vm *vm, uint64_t start, uint64_t end)
+{
+	for (start &= HPAGE_MASK; start < end; start += HPAGE_SIZE)
+		assert(uvc_merge(vm, guest_start(vm) + start) == 1);
+}
+
+static inline void merge_all(struct vm *vm)
+{
+	merge_range(vm, 0, guest_size(vm));
+}
+
+static inline bool pgm_3c_addr_is(struct vm *vm, uint64_t gaddr)
+{
+	union teid teid = { .val = lowcore.trans_exc_id };
+	bool res;
+
+	res = (lowcore.pgm_int_code == PGM_INT_CODE_SECURE_PAGE_SIZE) &&
+		(teid.addr == (guest_start(vm) + gaddr) >> PAGE_SHIFT);
+	clear_pgm_int();
+	return res;
+}
+
+static inline void assert_diag500_val(struct vm *vm, uint64_t val)
+{
+	assert(pv_icptdata_check_diag(vm, 0x500));
+	assert(vm->save_area.guest.grs[2] == val);
+}
+
+static void run_iterations(struct vm *vm, uint64_t param, bool ptlb_always, bool merge)
+{
+	uint64_t total, elapsed, best, worst;
+	uint64_t before, after;
+	int i;
+
+	map_identity_all(vm, 0);
+	init_snippet(vm);
+	import_all(vm);
+	map_identity_all(vm, merge);
+	if (merge)
+		merge_all(vm);
+
+	sie(vm);
+	assert_diag500_val(vm, FIRST);
+	vm->save_area.guest.grs[2] = PARAM(0, param);
+
+	total = worst = 0;
+	best = -1;
+
+	ptlb();
+	for (i = 0; i < N_ITER; i++) {
+		if (ptlb_always)
+			ptlb();
+
+		stckf(&before);
+		sie(vm);
+		stckf(&after);
+
+		assert_diag500_val(vm, SECOND);
+		vm->save_area.guest.grs[2] = 42;
+
+		elapsed = tod_to_us(after - before);
+
+		total += elapsed;
+
+		best = best > elapsed ? elapsed : best;
+		worst = worst < elapsed ? elapsed : worst;
+	}
+	uv_destroy_guest(vm);
+
+	report_info("%5lu %5lu %5lu", best, total / N_ITER, worst);
+}
+
+static void timings(void)
+{
+	const uint64_t seqs[] = { 0, 1, 3, 7, 17, 27, 63, 127};
+	unsigned int purge, map1m, seq;
+
+	report_prefix_push("timings");
+
+	report_info("Averages over %u iterations, in us (best/average/worst)", N_ITER);
+	for (purge = 0; purge < 2; purge++) {
+		report_prefix_pushf("ptlb %s", purge ? "always" : "  once");
+		for (seq = 0; seq < ARRAY_SIZE(seqs); seq++) {
+			if (seqs[seq])
+				report_prefix_pushf("seq step %3lu", seqs[seq]);
+			else
+				report_prefix_push("pseudorandom");
+			for (map1m = 0; map1m < 2; map1m++) {
+				report_prefix_pushf("%s", STR(map1m));
+				run_iterations(&vm, seqs[seq], purge, map1m);
+				report_prefix_pop();
+			}
+			report_prefix_pop();
+		}
+		report_prefix_pop();
+	}
+
+	report_pass("Timing tests successful");
+	report_prefix_pop();
+}
+
+
+static void do_one_test(struct vm *vm, bool init1m, bool import1m, int merge, bool run1m)
+{
+	map_identity_all(vm, init1m);
+	init_snippet(vm);
+
+	map_identity_all(vm, import1m);
+	import_all(vm);
+
+	if (merge >= 0) {
+		map_identity_all(vm, merge);
+		merge_all(vm);
+	}
+
+	map_identity_all(vm, run1m);
+	if ((merge == -1) && run1m) {
+		sie(vm);
+		report(vm->sblk->icptcode == ICPT_PV_PREF, "ICPT 112");
+		merge_range(vm, 0, SZ_1M);
+		expect_pgm_int();
+		sie(vm);
+		report(pgm_3c_addr_is(vm, MAGIC_ADDRESS), "PGM 3C at address %#x", MAGIC_ADDRESS);
+		map_identity_all(vm, false);
+	}
+
+	sie(vm);
+	assert_diag500_val(vm, FIRST);
+	vm->save_area.guest.grs[2] = PARAM(4096, 1);
+	sie(vm);
+	assert_diag500_val(vm, 23);
+
+	uv_destroy_guest(vm);
+}
+
+
+static void test_run(void)
+{
+	int init1m, import1m, merge, run1m;
+
+	report_prefix_push("test run");
+
+	for (init1m = 0; init1m < 1; init1m++) {
+		for (import1m = 0; import1m < 2; import1m++) {
+			for (merge = -1; merge < 2; merge++) {
+				for (run1m = 0; run1m < 2; run1m++) {
+					report_prefix_pushf("init %s, import %s, merge %s, run %s",
+						STR(init1m), STR(import1m), STR3(merge), STR(run1m));
+
+					do_one_test(&vm, init1m, import1m, merge, run1m);
+					report_pass("Execution successful");
+
+					report_prefix_pop();
+				}
+			}
+		}
+	}
+
+	report_prefix_pop();
+}
+
+static void test_merge(void)
+{
+	uint64_t tmp, mem;
+	int cc;
+
+	report_prefix_push("merge");
+	init_snippet(&vm);
+
+	mem = guest_start(&vm);
+
+	map_identity_all(&vm, false);
+	install_page(root, mem + 0x101000, (void *)(mem + 0x102000));
+	install_page(root, mem + 0x102000, (void *)(mem + 0x101000));
+	install_page(root, mem + 0x205000, (void *)(mem + 0x305000));
+	install_page(root, mem + 0x305000, (void *)(mem + 0x205000));
+	import_range(&vm, 0, 0x400000);
+	import_range(&vm, 0x401000, 0x501000);
+	import_range(&vm, 0x600000, 0x700000);
+
+	/* Address lower than MSO */
+	report(uvc_merge(&vm, 0) == 0x103, "Address below MSO");
+	report(uvc_merge(&vm, mem - SZ_1M) == 0x103, "Address below MSO");
+
+	/* Address higher than MSL */
+	install_large_page(root, guest_end(&vm), (void *)guest_end(&vm));
+	report(uvc_merge(&vm, guest_end(&vm)) == 0x103, "Address above MSL");
+
+	/* Not all pages are imported */
+	report(uvc_merge(&vm, mem + 0x400000) == 0x106, "First page not imported");
+	report(uvc_merge(&vm, mem + 0x500000) == 0x106, "Only first page imported");
+
+	/* Large 2G page used */
+	tmp = mem & REGION3_ENTRY_RFAA;
+	install_huge_page(root, tmp, (void *)tmp);
+	report(uvc_merge(&vm, mem) == 0x109, "Large region-3 table entry (2G page)");
+	map_identity_range(&vm, 0, SZ_2G, false);
+
+	/* Not all pages are aligned correctly */
+	report(uvc_merge(&vm, mem + 0x100000) == 0x104, "Pages not consecutive");
+	report(uvc_merge(&vm, mem + 0x200000) == 0x104, "Pages not in the same 1M frame");
+
+	/* Invalid host virtual to host aboslute mapping */
+	install_large_page(root, get_ram_size(), (void *)(mem + 0x600000));
+	report(uvc_merge(&vm, mem + 0x600000) == 0x107, "Invalid mapping");
+	map_identity_range(&vm, 0x600000, 0x700000, false);
+
+	/* Success */
+	report(uvc_merge(&vm, mem) == 1, "Successful merge");
+
+	cc = uv_export(mem + 0xff000);
+	report(cc == 0, "Successful export of merged page");
+
+	uv_destroy_guest(&vm);
+	report_prefix_pop();
+}
+
+static void test_one_export(struct vm *vm, int pre1m, bool exportfirst, int page, bool post1m)
+{
+	uint64_t addr = SZ_1M + page * PAGE_SIZE;
+	int expected = FIRST;
+
+	report_prefix_pushf("page %d", page);
+
+	map_identity_all(vm, pre1m == 1);
+	init_snippet(vm);
+	import_all(vm);
+	merge_all(vm);
+
+	if (pre1m != -1) {
+		sie(vm);
+		assert_diag500_val(vm, expected);
+		vm->save_area.guest.grs[2] = PARAM(4, 256 + 42);
+		expected = SECOND;
+	}
+
+	if (exportfirst) {
+		export_range(vm, addr, addr + PAGE_SIZE);
+		if (pre1m != 1)
+			map_identity_all(vm, true);
+	} else {
+		if (pre1m != 1)
+			map_identity_all(vm, true);
+		export_range(vm, addr, addr + PAGE_SIZE);
+	}
+	expect_pgm_int();
+	sie(vm);
+	assert(pgm_3c_addr_is(vm, MAGIC_ADDRESS));
+
+	import_range(vm, addr, addr + PAGE_SIZE);
+	if (post1m) {
+		merge_range(vm, SZ_1M, 2 * SZ_1M);
+	} else {
+		map_identity_all(vm, false);
+	}
+	sie(vm);
+	assert_diag500_val(vm, expected);
+	report_pass("Successful");
+
+	uv_destroy_guest(vm);
+	report_prefix_pop();
+}
+
+static void test_export(void)
+{
+	int pre1m, post1m, exportfirst;
+
+	report_prefix_push("export");
+
+	for (pre1m = -1; pre1m < 1; pre1m++) {
+		for (post1m = 0; post1m < 2; post1m++) {
+			for (exportfirst = 0; exportfirst < 2; exportfirst++) {
+				report_prefix_pushf("%s pre-run, %s post-run, export %s remap",
+						    STR3(pre1m), STR(post1m), exportfirst ? "before" : "after");
+
+				test_one_export(&vm, pre1m, exportfirst, 0, post1m);
+				test_one_export(&vm, pre1m, exportfirst, 1, post1m);
+				test_one_export(&vm, pre1m, exportfirst, 42, post1m);
+				test_one_export(&vm, pre1m, exportfirst, 128, post1m);
+				test_one_export(&vm, pre1m, exportfirst, 254, post1m);
+				test_one_export(&vm, pre1m, exportfirst, 255, post1m);
+
+				report_prefix_pop();
+			}
+		}
+	}
+
+	report_prefix_pop();
+}
+
+static bool check_facilities(void)
+{
+	if (!uv_host_requirement_checks())
+		return false;
+	if (!test_facility(8) || !test_facility(78)) {
+		report_skip("EDAT1 and EDAT2 not available in the host.");
+		return false;
+	}
+	if (!uv_query_test_call(BIT_UVC_CMD_VERIFY_LARGE_FRAME)) {
+		report_skip("Verify Large Frame UVC not supported.");
+		return false;
+	}
+	if (!uv_query_test_feature(BIT_UV_1M_BACKING)) {
+		report_skip("Large frames not supported for Secure Execution.");
+		return false;
+	}
+	return true;
+}
+
+static void init(void)
+{
+	uint8_t *guest_memory;
+
+	setup_vm();
+
+	root = (void *)(stctg(1) & PAGE_MASK);
+	ctl_set_bit(0, CTL0_EDAT);
+
+	guest_memory = alloc_pages(GUEST_ORDER - PAGE_SHIFT);
+	sie_guest_create(&vm, (uint64_t)guest_memory, GUEST_SIZE);
+	sie_guest_sca_create(&vm);
+	uv_init();
+	uv_setup_asces();
+}
+
+int main(void)
+{
+	report_prefix_push("uv-edat1-host");
+
+	if (check_facilities()) {
+		init();
+
+		test_merge();
+		test_export();
+		test_run();
+
+		timings();
+
+		sie_guest_destroy(&vm);
+	}
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/snippets/c/pv-memhog.c b/s390x/snippets/c/pv-memhog.c
new file mode 100644
index 00000000..43f0c2b1
--- /dev/null
+++ b/s390x/snippets/c/pv-memhog.c
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet used by the pv-edat1.c test.
+ * This snippet expects to run with at least 2G or memory.
+ *
+ * Copyright (c) 2024 IBM Corp
+ *
+ * Authors:
+ *  Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <asm-generic/page.h>
+#include <asm/mem.h>
+
+#define N_PAGES		(SZ_2G / PAGE_SIZE)
+#define MID_OF_PAGE	(PAGE_SIZE / 2)
+#define MASK_2G		(SZ_2G - 1)
+#define MIDPAGE_PTR(x)	((uint64_t *)((x) + MID_OF_PAGE))
+
+static inline void sie_exit(void)
+{
+	asm volatile("diag	0,0,0x44\n" : : : "memory");
+}
+
+static inline uint64_t get_value(uint64_t res)
+{
+	asm volatile("lgr	%%r2, %[res]\n"
+		"	diag	0, 0, 0x500\n"
+		"	lgr	%[res], %%r2\n"
+		     : [res] "+d"(res)
+		     :
+		     : "2", "memory"
+	);
+	return res;
+}
+
+int main(void)
+{
+	uint64_t param, addr, i, n;
+
+	READ_ONCE(*MIDPAGE_PTR(SZ_1M + 42 * PAGE_SIZE));
+	param = get_value(42);
+
+	n = (param >> 32) & 0x1fffffff;
+	n = n ? n : N_PAGES;
+	param &= 0x7fffffff;
+
+	while (true) {
+		for (i = 0; i < n; i++) {
+			addr = ((param ? i * param : i * i * i) * PAGE_SIZE) & MASK_2G;
+			WRITE_ONCE(*MIDPAGE_PTR(addr), addr);
+		}
+
+		i = get_value(23);
+		if (i != 42)
+			sie_exit();
+	}
+	return 0;
+}
-- 
2.47.0


