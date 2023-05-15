Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB95702C0A
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 13:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbjEOL5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 07:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241472AbjEOL40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 07:56:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7841FC3;
        Mon, 15 May 2023 04:53:28 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34FBaw9v006760;
        Mon, 15 May 2023 11:53:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K0QxA65+8NWHV7vdKCSTU9FN80KjNN+++lch8ECJIgo=;
 b=Jp5aybFwyxNgBB4X8RH1yBf7L9FuYOlyVpTduh6JItiPhRoWftmITV5I92hI9sGRWvX8
 vjpxsEcyUw6/4VEsWCmHGjRfwLq503ZcV8Uxk9ij1CF1JrLHUlf8se4/ZLz+z88etG0k
 K6Q4VYKzdYK9mFz8XV5QlrxV17KBKcj4wJUfWSIXQlJAk6icj9WrL4gBCHQKX0bkBX2x
 8NRGoDyhC6C/MHHHQJbPBqsmQRKI4HTNLlwZxFDT3+iIoQ25DbspV7QYRysibtKb9XkT
 bPLji98tI767OSclhviMYYwFpxCmmWOKqPEJL/+NM425yGX0JztrF+kZ04DjTGmna/k7 CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qkda85gjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 May 2023 11:53:28 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34FBqmo3029602;
        Mon, 15 May 2023 11:53:27 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qkda85ghr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 May 2023 11:53:27 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34F5XZSU000834;
        Mon, 15 May 2023 11:53:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qj264rv9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 May 2023 11:53:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34FBrLjb26870190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 May 2023 11:53:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DA0C20040;
        Mon, 15 May 2023 11:53:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34C622004B;
        Mon, 15 May 2023 11:53:20 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 15 May 2023 11:53:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v5] s390x: pv: Add sie entry intercept and validity test
Date:   Mon, 15 May 2023 11:53:11 +0000
Message-Id: <20230515115311.1970-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <168370369446.357872.12935361214141873283@t14-nrb>
References: <168370369446.357872.12935361214141873283@t14-nrb>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zqpKSaKFSfsPy8vOFesoQ6A2pw6nDIS_
X-Proofpoint-GUID: 25jR2Bm0M0j9gazgLB57DaA0mUK2nLr3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_09,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305150100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lowcore is an important part of any s390 cpu so we need to make
sure it's always available when we virtualize one. For non-PV guests
that would mean ensuring that the lowcore page is read and writable by
the guest.

For PV guests we additionally need to make sure that the page is owned
by the guest as it is only allowed to access them if that's the
case. The code 112 SIE intercept tells us if the lowcore pages aren't
secure anymore.

Let's check if that intercept is reported by SIE if we export the
lowcore pages. Additionally check if that's also the case if the guest
shares the lowcore which will make it readable to the host but
ownership of the page should not change.

Also we check for validities in these conditions:
     * Manipulated cpu timer
     * Double SIE for same vcpu
     * Re-use of VCPU handle from another secure configuration
     * ASCE re-use

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 - Added missing sie() call
 - Fixed S390_CLOCK_SHIFT_US * 1000
 - Fixed stp/spt confusion
---
 s390x/Makefile                          |   5 +
 s390x/pv-icptcode.c                     | 376 ++++++++++++++++++++++++
 s390x/snippets/asm/icpt-loop.S          |  15 +
 s390x/snippets/asm/loop.S               |  13 +
 s390x/snippets/asm/pv-icpt-112.S        |  81 +++++
 s390x/snippets/asm/pv-icpt-vir-timing.S |  21 ++
 s390x/unittests.cfg                     |   5 +
 7 files changed, 516 insertions(+)
 create mode 100644 s390x/pv-icptcode.c
 create mode 100644 s390x/snippets/asm/icpt-loop.S
 create mode 100644 s390x/snippets/asm/loop.S
 create mode 100644 s390x/snippets/asm/pv-icpt-112.S
 create mode 100644 s390x/snippets/asm/pv-icpt-vir-timing.S

diff --git a/s390x/Makefile b/s390x/Makefile
index 8d1cfc7c..67be5360 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -42,6 +42,7 @@ tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
+pv-tests += $(TEST_DIR)/pv-icptcode.elf
 
 ifneq ($(HOST_KEY_DOCUMENT),)
 ifneq ($(GEN_SE_HEADER),)
@@ -125,6 +126,10 @@ $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-yield.gbin
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-288.gbin
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-500.gbin
+$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-112.gbin
+$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/icpt-loop.gbin
+$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/loop.gbin
+$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timing.gbin
 
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
new file mode 100644
index 00000000..d7c47d6f
--- /dev/null
+++ b/s390x/pv-icptcode.c
@@ -0,0 +1,376 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * PV virtualization interception tests for intercepts that are not
+ * caused by an instruction.
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <sie.h>
+#include <smp.h>
+#include <sclp.h>
+#include <snippet.h>
+#include <pv_icptdata.h>
+#include <asm/facility.h>
+#include <asm/barrier.h>
+#include <asm/sigp.h>
+#include <asm/uv.h>
+#include <asm/time.h>
+
+static struct vm vm, vm2;
+
+/*
+ * The hypervisor should not be able to decrease the cpu timer by an
+ * amount that is higher than the amount of time spent outside of
+ * SIE.
+ *
+ * Warning: A lot of things influence time so decreasing the timer by
+ * a more significant amount than the difference to have a safety
+ * margin is advised.
+ */
+static void test_validity_timing(void)
+{
+	extern const char SNIPPET_NAME_START(asm, pv_icpt_vir_timing)[];
+	extern const char SNIPPET_NAME_END(asm, pv_icpt_vir_timing)[];
+	extern const char SNIPPET_HDR_START(asm, pv_icpt_vir_timing)[];
+	extern const char SNIPPET_HDR_END(asm, pv_icpt_vir_timing)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, pv_icpt_vir_timing);
+	int size_gbin = SNIPPET_LEN(asm, pv_icpt_vir_timing);
+	uint64_t time_exit, time_entry, tmp;
+
+	report_prefix_push("manipulated cpu time");
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_icpt_vir_timing),
+			SNIPPET_HDR_START(asm, pv_icpt_vir_timing),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	sie(&vm);
+	report(pv_icptdata_check_diag(&vm, 0x44), "spt done");
+	stck(&time_exit);
+	tmp = vm.sblk->cputm;
+	mb();
+
+	/* Cpu timer counts down so adding a ms should lead to a validity */
+	vm.sblk->cputm += S390_CLOCK_SHIFT_US * 1000;
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity entry cput > exit cput");
+	vm.sblk->cputm = tmp;
+
+	/*
+	 * We are not allowed to decrement the timer more than the
+	 * time spent outside of SIE
+	 */
+	stck(&time_entry);
+	vm.sblk->cputm -= (time_entry - time_exit) + S390_CLOCK_SHIFT_US * 1000;
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity entry cput < time spent outside SIE");
+	vm.sblk->cputm = tmp;
+
+	uv_destroy_guest(&vm);
+	report_prefix_pop();
+}
+
+static void run_loop(void)
+{
+	sie(&vm);
+	sigp_retry(stap(), SIGP_STOP, 0, NULL);
+}
+
+static void test_validity_already_running(void)
+{
+	extern const char SNIPPET_NAME_START(asm, loop)[];
+	extern const char SNIPPET_NAME_END(asm, loop)[];
+	extern const char SNIPPET_HDR_START(asm, loop)[];
+	extern const char SNIPPET_HDR_END(asm, loop)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, loop);
+	int size_gbin = SNIPPET_LEN(asm, loop);
+	struct psw psw = {
+		.mask = PSW_MASK_64,
+		.addr = (uint64_t)run_loop,
+	};
+
+	report_prefix_push("already running");
+	if (smp_query_num_cpus() < 3) {
+		report_skip("need at least 3 cpus for this test");
+		goto out;
+	}
+
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, loop),
+			SNIPPET_HDR_START(asm, loop),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	smp_cpu_setup(1, psw);
+	sie_expect_validity(&vm);
+	smp_cpu_setup(2, psw);
+	while (vm.sblk->icptcode != ICPT_VALIDITY) {
+		mb();
+	}
+
+	/*
+	 * One cpu will enter SIE and one will receive the validity.
+	 * We rely on the expectation that the cpu in SIE won't exit
+	 * until we had a chance to observe the validity as the exit
+	 * would overwrite the validity.
+	 *
+	 * In general that expectation is valid but HW/FW can in
+	 * theory still exit to handle their interrupts.
+	 */
+	report(uv_validity_check(&vm), "validity");
+	smp_cpu_stop(1);
+	smp_cpu_stop(2);
+	uv_destroy_guest(&vm);
+
+out:
+	report_prefix_pop();
+}
+
+/* Tests if a vcpu handle from another configuration results in a validity intercept. */
+static void test_validity_handle_not_in_config(void)
+{
+	extern const char SNIPPET_NAME_START(asm, icpt_loop)[];
+	extern const char SNIPPET_NAME_END(asm, icpt_loop)[];
+	extern const char SNIPPET_HDR_START(asm, icpt_loop)[];
+	extern const char SNIPPET_HDR_END(asm, icpt_loop)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, icpt_loop);
+	int size_gbin = SNIPPET_LEN(asm, icpt_loop);
+
+	report_prefix_push("handle not in config");
+	/* Setup our primary vm */
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, icpt_loop),
+			SNIPPET_HDR_START(asm, icpt_loop),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	/* Setup secondary vm */
+	snippet_setup_guest(&vm2, true);
+	snippet_pv_init(&vm2, SNIPPET_NAME_START(asm, icpt_loop),
+			SNIPPET_HDR_START(asm, icpt_loop),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	vm.sblk->pv_handle_cpu = vm2.sblk->pv_handle_cpu;
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "switched cpu handle");
+	vm.sblk->pv_handle_cpu = vm.uv.vcpu_handle;
+
+	vm.sblk->pv_handle_config = vm2.uv.vm_handle;
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "switched configuration handle");
+	vm.sblk->pv_handle_config = vm.uv.vm_handle;
+
+	/* Destroy the second vm, since we don't need it for further tests */
+	uv_destroy_guest(&vm2);
+	sie_guest_destroy(&vm2);
+
+	uv_destroy_guest(&vm);
+	report_prefix_pop();
+}
+
+/* Tests if a wrong vm or vcpu handle results in a validity intercept. */
+static void test_validity_seid(void)
+{
+	extern const char SNIPPET_NAME_START(asm, icpt_loop)[];
+	extern const char SNIPPET_NAME_END(asm, icpt_loop)[];
+	extern const char SNIPPET_HDR_START(asm, icpt_loop)[];
+	extern const char SNIPPET_HDR_END(asm, icpt_loop)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, icpt_loop);
+	int size_gbin = SNIPPET_LEN(asm, icpt_loop);
+	int fails = 0;
+	int i;
+
+	report_prefix_push("handles");
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, icpt_loop),
+			SNIPPET_HDR_START(asm, icpt_loop),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	for (i = 0; i < 64; i++) {
+		vm.sblk->pv_handle_config ^= 1UL << i;
+		sie_expect_validity(&vm);
+		sie(&vm);
+		if (!uv_validity_check(&vm)) {
+			report_fail("SIE accepted wrong VM SEID, changed bit %d",
+				    63 - i);
+			fails++;
+		}
+		vm.sblk->pv_handle_config ^= 1UL << i;
+	}
+	report(!fails, "No wrong vm handle accepted");
+
+	fails = 0;
+	for (i = 0; i < 64; i++) {
+		vm.sblk->pv_handle_cpu ^= 1UL << i;
+		sie_expect_validity(&vm);
+		sie(&vm);
+		if (!uv_validity_check(&vm)) {
+			report_fail("SIE accepted wrong CPU SEID, changed bit %d",
+				    63 - i);
+			fails++;
+		}
+		vm.sblk->pv_handle_cpu ^= 1UL << i;
+	}
+	report(!fails, "No wrong cpu handle accepted");
+
+	uv_destroy_guest(&vm);
+	report_prefix_pop();
+}
+
+/*
+ * Tests if we get a validity intercept if the CR1 asce at SIE entry
+ * is not the same as the one given at the UV creation of the VM.
+ */
+static void test_validity_asce(void)
+{
+	extern const char SNIPPET_NAME_START(asm, pv_icpt_112)[];
+	extern const char SNIPPET_NAME_END(asm, pv_icpt_112)[];
+	extern const char SNIPPET_HDR_START(asm, pv_icpt_112)[];
+	extern const char SNIPPET_HDR_END(asm, pv_icpt_112)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, pv_icpt_112);
+	int size_gbin = SNIPPET_LEN(asm, pv_icpt_112);
+	uint64_t asce_old, asce_new;
+	void *pgd_new, *pgd_old;
+
+	report_prefix_push("asce");
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_icpt_112),
+			SNIPPET_HDR_START(asm, pv_icpt_112),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	asce_old = vm.save_area.guest.asce;
+	pgd_new = memalign_pages_flags(PAGE_SIZE, PAGE_SIZE * 4, 0);
+	pgd_old = (void *)(asce_old & PAGE_MASK);
+
+	/* Copy the contents of the top most table */
+	memcpy(pgd_new, pgd_old, PAGE_SIZE * 4);
+
+	/* Create the replacement ASCE */
+	asce_new = __pa(pgd_new) | ASCE_DT_REGION1 | REGION_TABLE_LENGTH | ASCE_P;
+	vm.save_area.guest.asce = asce_new;
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "wrong CR1 validity");
+
+	/* Restore the old ASCE */
+	vm.save_area.guest.asce = asce_old;
+
+	/* Try if we can still do an entry with the correct asce */
+	sie(&vm);
+	report(pv_icptdata_check_diag(&vm, 0x44), "re-entry with valid CR1");
+	uv_destroy_guest(&vm);
+	free_pages(pgd_new);
+	report_prefix_pop();
+}
+
+static void run_icpt_122_tests(unsigned long lc_off)
+{
+	uv_export(vm.sblk->mso + lc_off);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 0");
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
+
+	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 1");
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
+}
+
+static void run_icpt_122_tests_prefix(unsigned long prefix)
+{
+	uint32_t *ptr = 0;
+
+	report_prefix_pushf("0x%lx", prefix);
+	report_prefix_push("unshared");
+	run_icpt_122_tests(prefix);
+	report_prefix_pop();
+
+	/*
+	 * Guest will share the lowcore and we need to check if that
+	 * makes a difference (which it should not).
+	 */
+	report_prefix_push("shared");
+
+	sie(&vm);
+	/* Guest indicates that it has been setup via the diag 0x44 */
+	assert(pv_icptdata_check_diag(&vm, 0x44));
+	/* If the pages have not been shared these writes will cause exceptions */
+	ptr = (uint32_t *)prefix;
+	WRITE_ONCE(ptr, 0);
+	ptr = (uint32_t *)(prefix + offsetof(struct lowcore, ars_sa[0]));
+	WRITE_ONCE(ptr, 0);
+
+	run_icpt_122_tests(prefix);
+
+	/* shared*/
+	report_prefix_pop();
+	/* prefix hex value */
+	report_prefix_pop();
+}
+
+static void test_icpt_112(void)
+{
+	extern const char SNIPPET_NAME_START(asm, pv_icpt_112)[];
+	extern const char SNIPPET_NAME_END(asm, pv_icpt_112)[];
+	extern const char SNIPPET_HDR_START(asm, pv_icpt_112)[];
+	extern const char SNIPPET_HDR_END(asm, pv_icpt_112)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, pv_icpt_112);
+	int size_gbin = SNIPPET_LEN(asm, pv_icpt_112);
+
+	unsigned long lc_off = 0;
+
+	report_prefix_push("prefix");
+
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_icpt_112),
+			SNIPPET_HDR_START(asm, pv_icpt_112),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	/* Setup of the guest's state for 0x0 prefix */
+	sie(&vm);
+	assert(pv_icptdata_check_diag(&vm, 0x44));
+
+	/* Test on standard 0x0 prefix */
+	run_icpt_122_tests_prefix(0);
+
+	/* Setup of the guest's state for 0x8000 prefix */
+	lc_off = 0x8000;
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
+	/* Guest will set prefix to 0x8000 */
+	sie(&vm);
+	/* SPX generates a PV instruction notification */
+	assert(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0xb210);
+	assert(*(u32 *)vm.sblk->sidad == 0x8000);
+
+	/* Test on 0x8000 prefix */
+	run_icpt_122_tests_prefix(0x8000);
+
+	/* Try a re-entry after everything has been imported again */
+	sie(&vm);
+	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	       vm.save_area.guest.grs[0] == 42,
+	       "re-entry successful");
+	report_prefix_pop();
+	uv_destroy_guest(&vm);
+}
+
+int main(void)
+{
+	report_prefix_push("pv-icpts");
+	if (!uv_host_requirement_checks())
+		goto done;
+
+	snippet_setup_guest(&vm, true);
+	test_icpt_112();
+	test_validity_asce();
+	test_validity_seid();
+	test_validity_handle_not_in_config();
+	test_validity_already_running();
+	test_validity_timing();
+	sie_guest_destroy(&vm);
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/snippets/asm/icpt-loop.S b/s390x/snippets/asm/icpt-loop.S
new file mode 100644
index 00000000..2aa59c01
--- /dev/null
+++ b/s390x/snippets/asm/icpt-loop.S
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Infinite loop snippet which can be used to test manipulated SIE
+ * control block intercepts. E.g. when manipulating the PV handles.
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+.section .text
+xgr	%r0, %r0
+retry:
+diag	0,0,0x44
+j 	retry
diff --git a/s390x/snippets/asm/loop.S b/s390x/snippets/asm/loop.S
new file mode 100644
index 00000000..a75bf00d
--- /dev/null
+++ b/s390x/snippets/asm/loop.S
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Infinite loop snippet with no exit
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+.section .text
+
+retry:
+j 	retry
diff --git a/s390x/snippets/asm/pv-icpt-112.S b/s390x/snippets/asm/pv-icpt-112.S
new file mode 100644
index 00000000..d9545fff
--- /dev/null
+++ b/s390x/snippets/asm/pv-icpt-112.S
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Intercept 112 PV snippet
+ *
+ * We setup and share a prefix at 0x0 and 0x8000 which the hypervisor
+ * test will try to export and then execute a SIE entry which
+ * should result in a 112 SIE intercept.
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <asm/asm-offsets.h>
+
+.section .text
+xgr	%r0, %r0
+xgr	%r1, %r1
+
+/* Let's tell the hypervisor we're ready to start */
+diag	0,0,0x44
+
+/*
+ * Hypervisor will export the lowcore and try a SIE entry which should
+ * result in a 112. It will then import the lowcore again and we
+ * should continue with the code below.
+ */
+
+/* Share the lowcore */
+larl	%r1, share
+.insn rrf,0xB9A40000,0,1,0,0
+xgr	%r1, %r1
+
+/*  Let's tell the hypervisor we're ready to start shared testing */
+diag	0,0,0x44
+
+/* Host: icpt:  PV instruction diag 0x44 */
+/* Host: icpt:  112 */
+
+/* Copy the invalid PGM new PSW to the new lowcore */
+larl	%r1, prfx
+l	%r2, 0(%r1)
+mvc     GEN_LC_PGM_NEW_PSW(16, %r2), GEN_LC_PGM_NEW_PSW(%r0)
+
+/* Change the prefix to 0x8000 and re-try */
+xgr	%r1, %r1
+xgr	%r2, %r2
+larl	%r2, prfx
+spx	0(%r2)
+
+/* Host: icpt:  PV instruction notification SPX*/
+/* Host: icpt:  112 */
+
+/* Share the new lowcore */
+larl	%r3, share_addr
+stg	%r2, 0(%r3)
+larl	%r2, share
+.insn rrf,0xB9A40000,0,2,0,0
+
+/* Let's tell the hypervisor we're ready to start shared testing */
+diag	0,0,0x44
+
+/* Host: icpt:  PV instruction diag 0x44 */
+/* Host: icpt:  112 */
+
+/* Test re-entry */
+lghi	%r1, 42
+diag	1,0,0x9c
+
+/* Host: icpt:  PV instruction diag 0x9c */
+
+.align 8
+share:
+	.quad 0x0030100000000000
+	.quad 0x0, 0x0, 0x0
+share_addr:
+	.quad 0x0
+	.quad 0x0
+.align 4
+prfx:
+	.long 0x00008000
diff --git a/s390x/snippets/asm/pv-icpt-vir-timing.S b/s390x/snippets/asm/pv-icpt-vir-timing.S
new file mode 100644
index 00000000..939134a2
--- /dev/null
+++ b/s390x/snippets/asm/pv-icpt-vir-timing.S
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Sets a cpu timer which the host can manipulate to check if it will
+ * receive a validity
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+.section .text
+larl	%r1, time_val
+spt	0 (%r1)
+diag    0, 0, 0x44
+lghi	%r1, 42
+diag	1, 0, 0x9c
+
+
+.align 8
+time_val:
+	.quad 0x280de80000
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b61faf07..e2d3478e 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -218,3 +218,8 @@ extra_params = -append '--parallel'
 
 [execute]
 file = ex.elf
+
+[pv-icptcode]
+file = pv-icptcode.elf
+smp = 3
+extra_params = -m 2200
-- 
2.34.1

