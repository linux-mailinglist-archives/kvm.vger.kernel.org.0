Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0666C7DAF
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjCXMGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjCXMGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:06:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFEC9760
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:06:05 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OAZQmg023139
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JaBuy/MmU9317WwlzzDDbI3OJ7IFB3CdoxYKWYmOTSg=;
 b=Az4w/EzZmBTHG/hUl8escC8kioeLrr5yCFT4Lld/ThOF6RO+GMKIoRgEmVYlgQ8vA3In
 cFfYcno8e/cACRcNmPt+FCvCEs7oe80vyXMODDzxrqh4cEndGbHHz+5YljDyVzBoEaRs
 nhiUhGU6JC+qaWLDVJwkY2al2lLSV7dfav/okk37vUnpmauar/qq3R/b0PC3OyfnXrKG
 ExlpcrN2lzhWoO2Qp36E4MhT6KQy9uLVTk8JuTwObDFKFkMYtASC8/Xm6RwUk1k7AnBc
 SQVyzABR2O8OYk1fLxCS8zUlWE9k81sblPhqlgb1eCp3DJ6t/0FT28+rC4AynhdxbVIF 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pha8b20k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBgGUS023780
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pha8b20jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:06:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLKhNX024778;
        Fri, 24 Mar 2023 12:06:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pgxkrrtf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:06:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OC5vlN44695998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:05:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E7992004B;
        Fri, 24 Mar 2023 12:05:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B8F52004E;
        Fri, 24 Mar 2023 12:05:56 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:05:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/3] s390x: pv: Test sie entry intercepts and validities
Date:   Fri, 24 Mar 2023 12:04:30 +0000
Message-Id: <20230324120431.20260-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324120431.20260-1-frankja@linux.ibm.com>
References: <20230324120431.20260-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lmgH29TgYVVS6DfE5leKICfRDenU6rjH
X-Proofpoint-GUID: C9BzvCSxRMMbico5PvyPj8zkiGDBZhfY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 s390x/Makefile                                |   5 +
 s390x/pv-icptcode.c                           | 403 ++++++++++++++++++
 s390x/snippets/asm/snippet-loop.S             |  12 +
 s390x/snippets/asm/snippet-pv-icpt-112.S      |  77 ++++
 s390x/snippets/asm/snippet-pv-icpt-loop.S     |  15 +
 .../snippets/asm/snippet-pv-icpt-vir-timing.S |  22 +
 6 files changed, 534 insertions(+)
 create mode 100644 s390x/pv-icptcode.c
 create mode 100644 s390x/snippets/asm/snippet-loop.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-112.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-loop.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-vir-timing.S

diff --git a/s390x/Makefile b/s390x/Makefile
index 97a61611..858f5af4 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -41,6 +41,7 @@ tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
+pv-tests += $(TEST_DIR)/pv-icptcode.elf
 
 ifneq ($(HOST_KEY_DOCUMENT),)
 ifneq ($(GEN_SE_HEADER),)
@@ -119,6 +120,10 @@ $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-288.gbin
 $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-500.gbin
+$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-112.gbin
+$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-loop.gbin
+$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-loop.gbin
+$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-vir-timing.gbin
 
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
new file mode 100644
index 00000000..a535d76f
--- /dev/null
+++ b/s390x/pv-icptcode.c
@@ -0,0 +1,403 @@
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
+	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_vir_timing)[];
+	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_vir_timing)[];
+	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_vir_timing)[];
+	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_vir_timing)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_vir_timing);
+	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_vir_timing);
+	uint64_t time_exit, time_entry;
+
+	report_prefix_push("manipulated cpu time");
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_vir_timing),
+			SNIPPET_HDR_START(asm, snippet_pv_icpt_vir_timing),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
+	       "stp done");
+	stck(&time_exit);
+	mb();
+
+
+	/* Cpu timer counts down so adding a us should lead to a validity */
+	vm.sblk->cputm += S390_CLOCK_SHIFT_US;
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity entry cput > exit cput");
+	vm.sblk->cputm -= S390_CLOCK_SHIFT_US;
+
+	/* Cpu timer counts down so adding a us should lead to a validity */
+	stck(&time_entry);
+	vm.sblk->cputm -= (time_entry - time_exit) + S390_CLOCK_SHIFT_US;
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity entry cput < time spent outside SIE");
+
+	/* Todo: Handle wrapping */
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
+	extern const char SNIPPET_NAME_START(asm, snippet_loop)[];
+	extern const char SNIPPET_NAME_END(asm, snippet_loop)[];
+	extern const char SNIPPET_HDR_START(asm, snippet_loop)[];
+	extern const char SNIPPET_HDR_END(asm, snippet_loop)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_loop);
+	int size_gbin = SNIPPET_LEN(asm, snippet_loop);
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
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_loop),
+			SNIPPET_HDR_START(asm, snippet_loop),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	sie_expect_validity(&vm);
+	smp_cpu_setup(1, psw);
+	smp_cpu_setup(2, psw);
+	while (vm.sblk->icptcode != ICPT_VALIDITY) { mb(); }
+	/* Yes I know this is not reliable as one cpu might overwrite it */
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
+	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_loop)[];
+	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_loop)[];
+	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_loop)[];
+	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_loop)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_loop);
+	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_loop);
+
+	report_prefix_push("handle not in config");
+	/* Setup our primary vm */
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_loop),
+			SNIPPET_HDR_START(asm, snippet_pv_icpt_loop),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	/* Setup secondary vm */
+	snippet_setup_guest(&vm2, true);
+	snippet_pv_init(&vm2, SNIPPET_NAME_START(asm, snippet_pv_icpt_loop),
+			SNIPPET_HDR_START(asm, snippet_pv_icpt_loop),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	vm.sblk->pv_handle_cpu = vm2.sblk->pv_handle_cpu;
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity");
+
+	/* Restore cpu handle and destroy the second vm */
+	vm.sblk->pv_handle_cpu = vm.uv.vcpu_handle;
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
+	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_loop)[];
+	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_loop)[];
+	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_loop)[];
+	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_loop)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_loop);
+	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_loop);
+	int fails = 0;
+	int i;
+
+	report_prefix_push("handles");
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_loop),
+			SNIPPET_HDR_START(asm, snippet_pv_icpt_loop),
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
+	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_112)[];
+	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_112)[];
+	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_112)[];
+	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_112)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_112);
+	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_112);
+	uint64_t asce_old, asce_new;
+	void *pgd_new, *pgd_old;
+
+	report_prefix_push("asce");
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_112),
+			SNIPPET_HDR_START(asm, snippet_pv_icpt_112),
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
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
+	       "re-entry with valid CR1");
+	uv_destroy_guest(&vm);
+	free_pages(pgd_new);
+	report_prefix_pop();
+}
+
+static void test_icpt_112(void)
+{
+	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_112)[];
+	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_112)[];
+	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_112)[];
+	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_112)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_112);
+	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_112);
+
+	u64 lc_off = 0;
+
+	report_prefix_push("prefix");
+
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_112),
+			SNIPPET_HDR_START(asm, snippet_pv_icpt_112),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	report_prefix_push("0x0");
+	sie(&vm);
+
+	/* Guest indicates that it has been setup via the diag 0x44 */
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
+	       "guest set up");
+
+	/*
+	 * Let's export the standard prefix 0x0 and check for the 112
+	 * intercept.
+	 */
+	uv_export(vm.sblk->mso + lc_off);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 0");
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
+
+	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 1");
+
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
+
+	/*
+	 * Guest will share the lowcore and we need to check if that
+	 * makes a difference (which it should not).
+	 */
+	report_prefix_push("shared");
+	sie(&vm);
+	/* Guest indicates that it has been setup via the diag 0x44 */
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
+	       "guest shared the first lowcore page");
+
+	/*
+	 * Let's export the standard prefix 0x0 and check for the 112
+	 * intercept.
+	 */
+	uv_export(vm.sblk->mso + lc_off);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112");
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
+	report_prefix_pop();
+
+	report_prefix_pop();
+
+
+	report_prefix_push("0x8000");
+	/*
+	 * Import the new prefix pages so we don't get a PGM 0x3E on
+	 * the guest's spx instruction.
+	 */
+	lc_off = 0x8000;
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
+	sie(&vm);
+
+	/* SPX generates a PV instruction notification */
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0xb210,
+	       "Received a PV instruction notification intercept for spx");
+	report(*(u32 *)vm.sblk->sidad == 0x8000, "New prefix is 0x8000");
+
+	/* Let's export the prefix at 0x8000 and check for the 112 intercept */
+	uv_export(vm.sblk->mso + lc_off);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 0");
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
+
+	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 1");
+
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
+
+	report_prefix_push("shared");
+	sie(&vm);
+	/* Guest indicates that it has shared the new lowcore */
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
+	       "intercept values");
+
+	uv_export(vm.sblk->mso + lc_off);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 0");
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
+
+	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 1");
+	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
+
+	/* Try a re-entry */
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c &&
+	       vm.save_area.guest.grs[0] == 42,
+	       "re-entry successful");
+	report_prefix_pop();
+
+	report_prefix_pop();
+
+	report_prefix_pop();
+	uv_destroy_guest(&vm);
+}
+
+int main(void)
+{
+	report_prefix_push("pv-icpts");
+	if (!test_facility(158)) {
+		report_skip("UV Call facility unavailable");
+		goto done;
+	}
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto done;
+	}
+	/*
+	 * Some of the UV memory needs to be allocated with >31 bit
+	 * addresses which means we need a lot more memory than other
+	 * tests.
+	 */
+	if (get_ram_size() < (SZ_1M * 2200UL)) {
+		report_skip("Not enough memory. This test needs about 2200MB of memory");
+		goto done;
+	}
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
diff --git a/s390x/snippets/asm/snippet-loop.S b/s390x/snippets/asm/snippet-loop.S
new file mode 100644
index 00000000..ee7cd863
--- /dev/null
+++ b/s390x/snippets/asm/snippet-loop.S
@@ -0,0 +1,12 @@
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
+retry:
+j 	retry
diff --git a/s390x/snippets/asm/snippet-pv-icpt-112.S b/s390x/snippets/asm/snippet-pv-icpt-112.S
new file mode 100644
index 00000000..aef82dbb
--- /dev/null
+++ b/s390x/snippets/asm/snippet-pv-icpt-112.S
@@ -0,0 +1,77 @@
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
+# Let's tell the hypervisor we're ready to start
+diag	0,0,0x44
+
+/*
+ * Hypervisor will export the lowcore and try a SIE entry which should
+ * result in a 112. It will then import the lowcore again and we
+ * should continue with the code below.
+ */
+
+# Share the lowcore
+larl	%r1, share
+.insn rrf,0xB9A40000,0,1,0,0
+xgr	%r1, %r1
+
+# Let's tell the hypervisor we're ready to start shared testing
+diag	0,0,0x44
+/* Host: icpt:  PV instruction diag 0x44 */
+/* Host: icpt:  112 */
+
+# Copy the invalid PGM new PSW to the new lowcore
+larl	%r1, prfx
+l	%r2, 0(%r1)
+mvc     GEN_LC_PGM_NEW_PSW(16, %r2), GEN_LC_PGM_NEW_PSW(%r0)
+
+# Change the prefix to 0x8000 and re-try
+xgr	%r1, %r1
+xgr	%r2, %r2
+larl	%r2, prfx
+spx	0(%r2)
+/* Host: icpt:  PV instruction notification SPX*/
+/* Host: icpt:  112 */
+
+# Share the new lowcore
+larl	%r3, share_addr
+stg	%r2, 0(%r3)
+larl	%r2, share
+.insn rrf,0xB9A40000,0,2,0,0
+
+# Let's tell the hypervisor we're ready to start shared testing
+diag	0,0,0x44
+/* Host: icpt:  PV instruction diag 0x44 */
+/* Host: icpt:  112 */
+
+# Test re-entry
+lghi	%r1, 42
+diag	1,0,0x9c
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
diff --git a/s390x/snippets/asm/snippet-pv-icpt-loop.S b/s390x/snippets/asm/snippet-pv-icpt-loop.S
new file mode 100644
index 00000000..2aa59c01
--- /dev/null
+++ b/s390x/snippets/asm/snippet-pv-icpt-loop.S
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
diff --git a/s390x/snippets/asm/snippet-pv-icpt-vir-timing.S b/s390x/snippets/asm/snippet-pv-icpt-vir-timing.S
new file mode 100644
index 00000000..a0f9fe21
--- /dev/null
+++ b/s390x/snippets/asm/snippet-pv-icpt-vir-timing.S
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Sets a cpu timer which the host can manipulate to check if it will
+ *receive a validity
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+.section .text
+larl	%r1, time_val
+spt	0(%r1)
+diag    0,0,0x44
+xgr	%r1, %r1
+lghi	%r1, 42
+diag	1,0,0x9c
+
+
+.align 8
+time_val:
+	.quad 0x280de80000
-- 
2.34.1

