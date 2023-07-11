Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE68F74F19C
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjGKORq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjGKORc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:17:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC0519AF
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:17:20 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEExr3031451;
        Tue, 11 Jul 2023 14:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=7IW72iTLxon9KuqOR8IMFOns3ibecSClaPy/uwxqxw8=;
 b=Imj9kgXeum2JwfH7Njzf2ijtMQ538rjdBxIt2zwk9ZFlBqGU3OLsbzlHmJDavhFfeP6j
 5M3B8ou5UdysVJzruGBfaRCROBT4m1khYNuslfJZGfVG49Oi0s6+PuUmMxML9ljpFwE/
 I3WHeE7ERFasDXAa4chwmPMJnbfoMdktLwndiQ8lL0Y9opfENYqI2ZgnrLVaWtR5EgGB
 nqDPWVYIqvnGbxK5NwJb5epNje+aZZfyfBTWmaEge+QomlIgqJJj3/9tVwZsDNxRrBXO
 kldx0LPQtjsMKD1CYSCN7EDzm56veds2Ue8HjL0CcIic5SaUuu89EH0qIfkVxMLhFG76 xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8p482fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:24 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BEFBYl032729;
        Tue, 11 Jul 2023 14:16:21 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8p482an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:20 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEDFJ2009180;
        Tue, 11 Jul 2023 14:16:18 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rqk4mg14k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGEhH33686056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAD7220040;
        Tue, 11 Jul 2023 14:16:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DF3E2004B;
        Tue, 11 Jul 2023 14:16:14 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:14 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 08/22] s390x: pv: Add sie entry intercept and validity test
Date:   Tue, 11 Jul 2023 16:15:41 +0200
Message-ID: <20230711141607.40742-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V3OlFKMPEB0m8FUKGwcOTJzbcoM1fXRN
X-Proofpoint-ORIG-GUID: tsLtDuWFuvbOAYFqXDBs-pQzYiE_R_T5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 adultscore=0 suspectscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230619083329.22680-7-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                          |   5 +
 s390x/snippets/asm/icpt-loop.S          |  15 +
 s390x/snippets/asm/loop.S               |  13 +
 s390x/snippets/asm/pv-icpt-112.S        |  81 +++++
 s390x/snippets/asm/pv-icpt-vir-timing.S |  21 ++
 s390x/pv-icptcode.c                     | 376 ++++++++++++++++++++++++
 s390x/unittests.cfg                     |   6 +
 7 files changed, 517 insertions(+)
 create mode 100644 s390x/snippets/asm/icpt-loop.S
 create mode 100644 s390x/snippets/asm/loop.S
 create mode 100644 s390x/snippets/asm/pv-icpt-112.S
 create mode 100644 s390x/snippets/asm/pv-icpt-vir-timing.S
 create mode 100644 s390x/pv-icptcode.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 8d1cfc7..67be536 100644
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
diff --git a/s390x/snippets/asm/icpt-loop.S b/s390x/snippets/asm/icpt-loop.S
new file mode 100644
index 0000000..2aa59c0
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
index 0000000..a75bf00
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
index 0000000..d9545ff
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
index 0000000..939134a
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
diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
new file mode 100644
index 0000000..d7c47d6
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
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b61faf0..df25b48 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -218,3 +218,9 @@ extra_params = -append '--parallel'
 
 [execute]
 file = ex.elf
+
+[pv-icptcode]
+file = pv-icptcode.elf
+smp = 3
+groups = pv-host
+extra_params = -m 2200
-- 
2.41.0

