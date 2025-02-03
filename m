Return-Path: <kvm+bounces-37098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E41A25481
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A886E3A46A6
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C121FC7DF;
	Mon,  3 Feb 2025 08:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hnPI2E3j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F051FA859
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571804; cv=none; b=qj8BeUEB9M3OtZ6xgNOcOAv3Z3gI2Aoo5y6/GxJxWVNuroErZvqkk0c5xxhXGYuto6h2rHhCOYgtxs2ulm1xGoK/hWrStX60tWSLXpO/SgcGs5vsYx04RfJhmpPbVJ9uepT5lOfszUByiL1y1axPnbceExjzoqRBpliG57EWDAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571804; c=relaxed/simple;
	bh=ncukha6i9MZuNaCtF7EYBW5F2f1OveHTEVYlPl45Cjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4k8kr3fH3+k4GnApOL45Gc/Os2LDDE20rl9FqYIfha+NvBKEz6vNZAonZk1Jj3GipyVc0V1QfW8JnZKVw72UKetteEuAbwu4+sMukR78nT1393gpTIw/QytDfkzGJalq6/m0QNlhxQtCQMTu/oharr+6X10jiAr1AUeMN6m5qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hnPI2E3j; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5135Ntwh013186;
	Mon, 3 Feb 2025 08:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=oM4QQRK/sxu0mHXYH
	K/yq72fPMU/OB2oKPnDC3Dy79Y=; b=hnPI2E3johAD6TJVEpRROJl/xtl7RGomR
	/7VHXoHu96lKs1VFyAAZ0LLKnMXPceb1yEg0RvZvxt8igLUb4TXK/cSWDO7nHq5X
	BWIa+2x/xfc+jBBLpTzUDFfLf8fI/5i3GnGh+xqLApytR/uSoY0CITd+jZmlHANN
	3MeyNxqlX2djBiRJyfetZeMD3w2G+Cu/6hL0gFrVygopj9O9OFGhFHmBEolP3IAG
	pJgrpOZ0zcqSO9zAm9gvCjaAiCHCeIx5eY0r6LG/bkzitu0RpELodesH6Gb6wHeU
	Wmz08weIqnfHT30eo79lcLDLD57hwzkhF4uhnZWfUtyfbGLJgfOZg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jqm78suq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5134GvmL005266;
	Mon, 3 Feb 2025 08:36:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j05jn6a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aQ4x54985062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:26 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 545D620040;
	Mon,  3 Feb 2025 08:36:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E49C720043;
	Mon,  3 Feb 2025 08:36:25 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:25 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 04/18] s390x: add test for diag258
Date: Mon,  3 Feb 2025 09:35:12 +0100
Message-ID: <20250203083606.22864-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j4rFXslwzpG4I2oX7b0sEN4jDDsr90fV
X-Proofpoint-ORIG-GUID: j4rFXslwzpG4I2oX7b0sEN4jDDsr90fV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502030068

This adds a test for diag258 (page ref service/async page fault).

There recently was a virtual-real address confusion bug, so we should
test:
- diag258 parameter Rx is a real adress
- crossing the end of RAM with the parameter list yields an addressing
  exception
- invalid diagcode in the parameter block yields an specification
  exception
- diag258 correctly applies prefixing.

Note that we're just testing error cases as of now.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20241010071228.565038-3-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/diag258.c     | 259 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 263 insertions(+)
 create mode 100644 s390x/diag258.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd6..66d71351 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -44,6 +44,7 @@ tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
 tests += $(TEST_DIR)/topology.elf
 tests += $(TEST_DIR)/sie-dat.elf
+tests += $(TEST_DIR)/diag258.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
diff --git a/s390x/diag258.c b/s390x/diag258.c
new file mode 100644
index 00000000..8ba75a72
--- /dev/null
+++ b/s390x/diag258.c
@@ -0,0 +1,259 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Diag 258: Async Page Fault Handler
+ *
+ * Copyright (c) 2024 IBM Corp
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm-generic/barrier.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/mem.h>
+#include <asm/pgtable.h>
+#include <mmu.h>
+#include <sclp.h>
+#include <vmalloc.h>
+
+static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
+
+#define __PF_RES_FIELD 0x8000000000000000UL
+
+/* copied from Linux arch/s390/mm/pfault.c */
+struct pfault_refbk {
+	u16 refdiagc;
+	u16 reffcode;
+	u16 refdwlen;
+	u16 refversn;
+	u64 refgaddr;
+	u64 refselmk;
+	u64 refcmpmk;
+	u64 reserved;
+};
+
+uint64_t pfault_token = 0x0123fadec0fe3210UL;
+
+static struct pfault_refbk pfault_init_refbk __attribute__((aligned(8))) = {
+	.refdiagc = 0x258,
+	.reffcode = 0, /* TOKEN */
+	.refdwlen = sizeof(struct pfault_refbk) / sizeof(uint64_t),
+	.refversn = 2,
+	.refgaddr = (u64)&pfault_token,
+	.refselmk = 1UL << 48,
+	.refcmpmk = 1UL << 48,
+	.reserved = __PF_RES_FIELD
+};
+
+static struct pfault_refbk pfault_cancel_refbk __attribute((aligned(8))) = {
+	.refdiagc = 0x258,
+	.reffcode = 1, /* CANCEL */
+	.refdwlen = sizeof(struct pfault_refbk) / sizeof(uint64_t),
+	.refversn = 2,
+	.refgaddr = 0,
+	.refselmk = 0,
+	.refcmpmk = 0,
+	.reserved = 0
+};
+
+static inline int diag258(struct pfault_refbk *refbk)
+{
+	int rc = -1;
+
+	asm volatile(
+		"	diag	%[refbk],%[rc],0x258\n"
+		: [rc] "+d" (rc)
+		: [refbk] "a" (refbk), "m" (*(refbk))
+		: "cc");
+	return rc;
+}
+
+static void test_priv(void)
+{
+	report_prefix_push("privileged");
+	expect_pgm_int();
+	enter_pstate();
+	diag258(&pfault_init_refbk);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+static void *page_map_outside_real_space(phys_addr_t page_real)
+{
+	pgd_t *root = (pgd_t *)(stctg(1) & PAGE_MASK);
+	void *vaddr = alloc_vpage();
+
+	install_page(root, page_real, vaddr);
+
+	return vaddr;
+}
+
+/*
+ * Verify that the refbk pointer is a real address and not a virtual
+ * address. This is tested by enabling DAT and establishing a mapping
+ * for the refbk that is outside of the bounds of our (guest-)physical
+ * address space.
+ */
+static void test_refbk_real(void)
+{
+	struct pfault_refbk *refbk;
+	void *refbk_page;
+	pgd_t *root;
+
+	report_prefix_push("refbk is real");
+
+	/* Set up virtual memory and allocate a physical page for storing the refbk */
+	setup_vm();
+	refbk_page = alloc_page();
+
+	/* Map refblk page outside of physical memory identity mapping */
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
+	refbk = page_map_outside_real_space(virt_to_pte_phys(root, refbk_page));
+
+	/* Assert the mapping really is outside identity mapping */
+	report_info("refbk is at 0x%lx", (u64)refbk);
+	report_info("ram size is 0x%lx", get_ram_size());
+	assert((u64)refbk > get_ram_size());
+
+	/* Copy the init refbk to the page */
+	memcpy(refbk, &pfault_init_refbk, sizeof(struct pfault_refbk));
+
+	/* Protect the virtual mapping to avoid diag258 actually doing something */
+	protect_page(refbk, PAGE_ENTRY_I);
+
+	expect_pgm_int();
+	diag258(refbk);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+
+	free_page(refbk_page);
+	disable_dat();
+	irq_set_dat_mode(false, 0);
+}
+
+/*
+ * Verify diag258 correctly applies prefixing.
+ */
+static void test_refbk_prefixing(void)
+{
+	const size_t lowcore_offset_for_refbk = offsetof(struct lowcore, pad_0x03a0);
+	struct pfault_refbk *refbk_in_prefix, *refbk_in_reverse_prefix;
+	uint32_t old_prefix;
+	uint64_t ry;
+
+	report_prefix_push("refbk prefixing");
+
+	report_info("refbk at lowcore offset 0x%lx", lowcore_offset_for_refbk);
+
+	assert((unsigned long)&prefix_buf < SZ_2G);
+
+	memcpy(prefix_buf, 0, LC_SIZE);
+
+	/*
+	 * After the call to set_prefix() below, this will refer to absolute
+	 * address lowcore_offset_for_refbk (reverse prefixing).
+	 */
+	refbk_in_reverse_prefix = (struct pfault_refbk *)(&prefix_buf[0] + lowcore_offset_for_refbk);
+
+	/*
+	 * After the call to set_prefix() below, this will refer to absolute
+	 * address &prefix_buf[0] + lowcore_offset_for_refbk (forward prefixing).
+	 */
+	refbk_in_prefix = (struct pfault_refbk *)OPAQUE_PTR(lowcore_offset_for_refbk);
+
+	old_prefix = get_prefix();
+	set_prefix((uint32_t)(uintptr_t)prefix_buf);
+
+	/*
+	 * If diag258 would not be applying prefixing on access to
+	 * refbk_in_reverse_prefix correctly, it would access absolute address
+	 * refbk_in_reverse_prefix (which to us is accessible at real address
+	 * refbk_in_prefix).
+	 * Make sure it really fails by putting invalid function code
+	 * at refbk_in_prefix.
+	 */
+	refbk_in_prefix->refdiagc = 0xc0fe;
+
+	/*
+	 * Put a valid refbk at refbk_in_reverse_prefix.
+	 */
+	memcpy(refbk_in_reverse_prefix, &pfault_init_refbk, sizeof(pfault_init_refbk));
+
+	ry = diag258(refbk_in_reverse_prefix);
+	report(!ry, "real address refbk accessed");
+
+	/*
+	 * Activating should have worked. Cancel the activation and expect
+	 * return 0. If activation would not have worked, this should return with
+	 * 4 (pfault handshaking not active).
+	 */
+	ry = diag258(&pfault_cancel_refbk);
+	report(!ry, "handshaking canceled");
+
+	set_prefix(old_prefix);
+
+	report_prefix_pop();
+}
+
+/*
+ * Verify that a refbk exceeding physical memory is not accepted, even
+ * when crossing a frame boundary.
+ */
+static void test_refbk_crossing(void)
+{
+	const size_t bytes_in_last_page = 8;
+	struct pfault_refbk *refbk = (struct pfault_refbk *)(get_ram_size() - bytes_in_last_page);
+
+	report_prefix_push("refbk crossing");
+
+	report_info("refbk is at 0x%lx", (u64)refbk);
+	report_info("ram size is 0x%lx", get_ram_size());
+	assert(sizeof(struct pfault_refbk) > bytes_in_last_page);
+
+	/* Copy bytes_in_last_page bytes of the init refbk to the page */
+	memcpy(refbk, &pfault_init_refbk, bytes_in_last_page);
+
+	expect_pgm_int();
+	diag258(refbk);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+}
+
+/*
+ * Verify that a refbk with an invalid refdiagc is not accepted.
+ */
+static void test_refbk_invalid_diagcode(void)
+{
+	struct pfault_refbk refbk __attribute__((aligned(8))) = pfault_init_refbk;
+
+	report_prefix_push("invalid refdiagc");
+	refbk.refdiagc = 0xc0fe;
+
+	expect_pgm_int();
+	diag258(&refbk);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("diag258");
+
+	expect_pgm_int();
+	diag258((struct pfault_refbk *)0xfffffffffffffff0);
+	if (clear_pgm_int() == PGM_INT_CODE_SPECIFICATION) {
+		report_skip("diag258 not supported");
+	} else {
+		test_priv();
+		/* Other tests rely on invalid diagcodes doing nothing */
+		test_refbk_invalid_diagcode();
+		test_refbk_real();
+		test_refbk_prefixing();
+		test_refbk_crossing();
+	}
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3a9decc9..8131ba10 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -392,3 +392,6 @@ file = sie-dat.elf
 
 [pv-attest]
 file = pv-attest.elf
+
+[diag258]
+file = diag258.elf
-- 
2.47.1


