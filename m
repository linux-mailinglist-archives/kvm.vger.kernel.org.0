Return-Path: <kvm+bounces-27054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AADDD97B234
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 17:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F0721F2AEAD
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 15:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A84D192580;
	Tue, 17 Sep 2024 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Lnk5hjoz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5D2191F75;
	Tue, 17 Sep 2024 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726587380; cv=none; b=jqO9M2jk8Bi5yWVpNdgra4NBc5hv6AiDcWerjkSAAA5pphqS+va5AMOSQ6kOi3Db/zI6kPEi7ORLzx4xqQYYBsLjn6Yxvjq0A1qucwCLbreUn9nXm0DugJL+vkFYqBUNXohnmLxS9M27REpPEwsHJbj9bghobSOHcKtsgxEPHdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726587380; c=relaxed/simple;
	bh=Q8jIhtRG01uthv4YHSEwnfhuILkuvji3GYRKgr5uw8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1HR+rp4aHbLiw1aamRfxOSVB02cdPs99XMaKAqy3lBYLAJa9jFf4fBqtKdw9zOcrQ526B7JWFkM3PNPoC/wxGHb6+qqgWLfB01THKW8Ecmni1Hzoe/ELnb0GQEGzD6+xRAOUGFS2BZ90XmupVfotjvZtSSHBwUiGGWWCvIGqgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Lnk5hjoz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48HAxvF5031103;
	Tue, 17 Sep 2024 15:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=GO0BGjCEskz17
	XCHIXXgGiiftNO9aHThOIYtdCSizP8=; b=Lnk5hjozZlL9EJ8/oCYjUDB2GyXra
	mANR6snbwtblnWofduBE+SU7Mtz4ioXP0MifOEIl0mbAAMRqZLV/ZSUv2B99j8DO
	2xn7wPAL5/8tiwWG9VUC/hVdfdwNzSXXpSapMQJG9z03l3QTz3bSeY8yD99e4QEl
	/gmCUeSeQE9XeCzacKVBRtOp5pLzVT3QA1yA1pv7YMsNE05um9pkYNUDWlgV76jk
	7ylu/AroSofOPulSNchdF4q3dx1MjGX604SW9EmAJqNNBK6y1bfy+acQVcZZ3Uwx
	pucTnlnoZstY/FdRNRD4PNawBPX3u0EjMKC5Ur0Cjgy2Urhz+ZQ05FPFA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vnrfk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:16 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48HFWk7h032198;
	Tue, 17 Sep 2024 15:36:16 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vnrfk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48HFC1Sj001892;
	Tue, 17 Sep 2024 15:36:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nmtup8hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48HFaBGs45941102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Sep 2024 15:36:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A070F20040;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C9AF2004E;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 1/2] s390x: add test for diag258
Date: Tue, 17 Sep 2024 17:35:34 +0200
Message-ID: <20240917153611.138883-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240917153611.138883-1-nrb@linux.ibm.com>
References: <20240917153611.138883-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dIxYuSneD8HXq0t4kWoE_fn0OGuhOldQ
X-Proofpoint-GUID: rDhPKeZpr0GqlSJDrboH6G3n6aKXVqqZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-17_07,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409170110

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
 s390x/diag258.c     | 250 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 254 insertions(+)
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
index 000000000000..20f3ff220d6c
--- /dev/null
+++ b/s390x/diag258.c
@@ -0,0 +1,250 @@
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
+	pgd_t *root;
+	struct pfault_refbk *refbk;
+	void *refbk_page;
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
+	uint64_t ry;
+	uint32_t old_prefix;
+	struct pfault_refbk *refbk_in_prefix, *refbk_in_reverse_prefix;
+	const size_t lowcore_offset_for_refbk = offsetof(struct lowcore, pad_0x03a0);
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
+	struct pfault_refbk refbk = pfault_init_refbk;
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
+	test_priv();
+	test_refbk_real();
+	test_refbk_prefixing();
+	test_refbk_crossing();
+	test_refbk_invalid_diagcode();
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
2.46.0


