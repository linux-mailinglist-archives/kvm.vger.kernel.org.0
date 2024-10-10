Return-Path: <kvm+bounces-28369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DB0997F32
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7079B237E7
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F431CEAB6;
	Thu, 10 Oct 2024 07:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o7Vy5llW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F361CDFC6;
	Thu, 10 Oct 2024 07:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728544357; cv=none; b=UWo+Ol4UiTTRrsVcfsrnsXJti+9QbtW5QTSbfue0QpryRxVpNcnBGNFsKj64kFVvdtxLMMxnJHd9y3kA3doTKz1m25CY7lGMvMNEPvRBgigh/WrVXoJ9WvfUA4904hWTomZUfWvplD0UnShnCNDf4AK92OrCiaRtJZxv0vJpMnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728544357; c=relaxed/simple;
	bh=5/m/WQjjjRukyfmX2Dz3nNW4+eeHJCLCO/1ksrgCqw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHVqpZ6tiSgC2ITsmkCXt9cJnPNuO44OCgyaW2xYzPDEvv+dLo8e8HMo1WcZcOu16F3GzdhYM6UGUXWb13qakTgpsdL6TbYFO5spixuQxwq8D8/C49R0KzywXhTDEr5yvu8u1whPWPQU3OeGJvo74k2lxyjIrTWB/rBYyHze//o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o7Vy5llW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A73bSi015830;
	Thu, 10 Oct 2024 07:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=opPhAZHHbFD2e
	bVEnJ03J0G45J5u6NUrSC502kYUb9U=; b=o7Vy5llWyNMtDvrMZPIrmFRDj0G7+
	Mc+e2AQ9TDmbhGSFmKNSKQAdeZ+84ZhJFze48OT+UvsOhnTPSaDBlLmuGZl8OjG1
	T4VMYKYuEJ9zEOmKhXMffKhWa+SOBIcVTIeb+Pp4pNpeVRuhkEnzMHVAicasvscj
	aI2zHiuLfsOu7F6471T2ACaCad9fLOPTY5QzMxQaqNrc+imMEemY/wg90kqzcV7a
	HTvNmGcO6YhyKHjrn+wjblI39DQf6rqENNCQVURhQ1ZhyPgdntaykaTJcuxcDobv
	WvXpAAPq72c0HCiYlGGfPrEcSb+9mS9uc6dzkWT384DKQBb7Po2ykxd5A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 426a6mg1df-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:34 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49A7CYOT001881;
	Thu, 10 Oct 2024 07:12:34 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 426a6mg1dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49A72Lpi010703;
	Thu, 10 Oct 2024 07:12:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 423j0jp4du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:33 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49A7CTbH51708350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Oct 2024 07:12:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D9EA2005A;
	Thu, 10 Oct 2024 07:12:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A6DF2004D;
	Thu, 10 Oct 2024 07:12:29 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Oct 2024 07:12:29 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 2/2] s390x: add test for diag258
Date: Thu, 10 Oct 2024 09:11:52 +0200
Message-ID: <20241010071228.565038-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241010071228.565038-1-nrb@linux.ibm.com>
References: <20241010071228.565038-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JKof4RpAwUTyw6B7fB1oUt_FAge4E0gY
X-Proofpoint-GUID: LezuRSev9onNM5j0Y6em0aVXY-f6f4h2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-10_04,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410100045

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

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/diag258.c     | 259 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 263 insertions(+)
 create mode 100644 s390x/diag258.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd64f44..66d71351caab 100644
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
index 000000000000..4746615bb944
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
+static void* page_map_outside_real_space(phys_addr_t page_real)
+{
+	pgd_t *root = (pgd_t *)(stctg(1) & PAGE_MASK);
+	void* vaddr = alloc_vpage();
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
index 3a9decc932f2..8131ba105d3f 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -392,3 +392,6 @@ file = sie-dat.elf
 
 [pv-attest]
 file = pv-attest.elf
+
+[diag258]
+file = diag258.elf
-- 
2.46.2


