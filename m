Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EADC6C7DAE
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjCXMGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjCXMGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:06:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC1990
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:06:04 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OAZRUX023146
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=60QsEPulcg8h/eHBE3TBs29X5Ud0Yx9H2TAPz7f/4io=;
 b=BmtJyNH5C68NzNqTgx3ROTO+3xkdjTECIZVv733FQDdSvqfqnnMdZ7skWF4ytC04p0Xe
 AB0pdwvS48EUMAOogWPSqOC4LZNpNbDi23+Dh9tbe0XKTekW5an1X+F1gtnhHYW+Kb7b
 nHJso6Kx/2zShdipGUK2HqQR9bUun2bChFYkhCyeZ+rmcakDNssvvOvu0idJN9n1culb
 3sYpGtdF+MMxVzuEt5zEXW+Tw/fCuO/r3MiseQmG54uw8oVZjIRc3HOWutCqOUoGTmFJ
 cyS7uKsqDXtaB7EaUtjDrwUVif74qoaf/py5rPtTqdKXO9BFuDf4cQXNfTWtizNMnlBX Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pha8b20jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:03 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBqf4D031063
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pha8b20hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:06:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLt4TC012782;
        Fri, 24 Mar 2023 12:06:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pgy3s0sqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:06:01 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OC5vge19727058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:05:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C80C32004D;
        Fri, 24 Mar 2023 12:05:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A7FC20043;
        Fri, 24 Mar 2023 12:05:57 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:05:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/3] s390x: pv: Add IPL reset tests
Date:   Fri, 24 Mar 2023 12:04:31 +0000
Message-Id: <20230324120431.20260-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324120431.20260-1-frankja@linux.ibm.com>
References: <20230324120431.20260-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4U_g_VQcq5SLrvlbffTpC_3doW08HYmT
X-Proofpoint-GUID: ZKNQKtVfWc6NdSf0hPo6l7fvXvE6fBcE
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

The diag308 requires extensive cooperation between the hypervisor and
the Ultravisor so the Ultravisor can make sure all necessary reset
steps have been done.

Let's check if we get the correct validity errors.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile                           |   2 +
 s390x/pv-ipl.c                           | 246 +++++++++++++++++++++++
 s390x/snippets/asm/snippet-pv-diag-308.S |  67 ++++++
 3 files changed, 315 insertions(+)
 create mode 100644 s390x/pv-ipl.c
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-308.S

diff --git a/s390x/Makefile b/s390x/Makefile
index 858f5af4..e8559a4e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -42,6 +42,7 @@ tests += $(TEST_DIR)/exittime.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
+pv-tests += $(TEST_DIR)/pv-ipl.elf
 
 ifneq ($(HOST_KEY_DOCUMENT),)
 ifneq ($(GEN_SE_HEADER),)
@@ -124,6 +125,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-1
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-loop.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-loop.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-vir-timing.gbin
+$(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-308.gbin
 
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
new file mode 100644
index 00000000..d17cf59d
--- /dev/null
+++ b/s390x/pv-ipl.c
@@ -0,0 +1,246 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * PV diagnose 308 (IPL) tests
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <sie.h>
+#include <sclp.h>
+#include <snippet.h>
+#include <asm/facility.h>
+#include <asm/uv.h>
+
+static struct vm vm;
+
+static void setup_gbin(void)
+{
+	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_308)[];
+	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_308)[];
+	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_308)[];
+	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_308)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_308);
+	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_308);
+
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_308),
+			SNIPPET_HDR_START(asm, snippet_pv_diag_308),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+}
+
+static void test_diag_308_1(void)
+{
+	uint16_t rc, rrc;
+	int cc;
+
+	report_prefix_push("subcode 1");
+	setup_gbin();
+
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x500,
+	       "intercept values diag 500");
+	/* The snippet asked us for the subcode and we answer with 1 in gr2 */
+	vm.save_area.guest.grs[2] = 1;
+
+	/* Continue after diag 0x500, next icpt should be the 0x308 */
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x308,
+	       "intercept values diag 0x308");
+	report(vm.save_area.guest.grs[2] == 1,
+	       "subcode 1");
+
+	/*
+	 * We need to perform several UV calls to emulate the subcode
+	 * 1. Failing to do that should result in a validity.
+	 *
+	 * - Mark all cpus as stopped
+	 * - Unshare all
+	 * - Prepare for reset
+	 * - Reset the cpus, calling one gets an initial reset
+	 * - Load the reset PSW
+	 */
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity no UVCs");
+
+	/* Mark the CPU as stopped so we can unshare and reset */
+	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_STP);
+	report(!cc, "Set cpu stopped");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity stopped");
+
+	/* Unshare all memory */
+	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
+			   UVC_CMD_SET_UNSHARED_ALL, &rc, &rrc);
+	report(cc == 0 && rc == 1, "Unshare all");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000,
+	       "validity stopped, unshared");
+
+	/* Prepare the CPU reset */
+	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
+			   UVC_CMD_PREPARE_RESET, &rc, &rrc);
+	report(cc == 0 && rc == 1, "Prepare reset call");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000,
+	       "validity stopped, unshared, prepare");
+
+	/* Do the reset */
+	cc = uv_cmd_nodata(vm.sblk->pv_handle_cpu,
+			   UVC_CMD_CPU_RESET_INITIAL, &rc, &rrc);
+	report(cc == 0 && rc == 1, "Initial reset cpu");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000,
+	       "validity stopped, unshared, prepare, reset");
+
+	/* Load the PSW from 0x0 */
+	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_OPR_LOAD);
+	report(!cc, "Set cpu load");
+
+	/*
+	 * Check if we executed the iaddr of the reset PSW, we should
+	 * see a diagnose 0x9c PV instruction notification.
+	 */
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c &&
+	       vm.save_area.guest.grs[0] == 42,
+	       "intercept values after diag 0x308");
+
+
+	uv_destroy_guest(&vm);
+	report_prefix_pop();
+}
+
+static void test_diag_308_0(void)
+{
+	uint16_t rc, rrc;
+	int cc;
+
+	report_prefix_push("subcode 0");
+	setup_gbin();
+
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x500,
+	       "intercept values diag 500");
+	/* The snippet asked us for the subcode and we answer with 0 in gr2 */
+	vm.save_area.guest.grs[2] = 0;
+
+	/* Continue after diag 0x500, next icpt should be the 0x308 */
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x308,
+	       "intercept values");
+	report(vm.save_area.guest.grs[2] == 0,
+	       "subcode 0");
+
+	/*
+	 * We need to perform several UV calls to emulate the subcode
+	 * 0. Failing to do that should result in a validity.
+	 *
+	 * - Mark all cpus as stopped
+	 * - Unshare all memory
+	 * - Prepare the reset
+	 * - Reset the cpus
+	 * - Load the reset PSW
+	 */
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity, no action");
+
+	/* Mark the CPU as stopped so we can unshare and reset */
+	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_STP);
+	report(!cc, "Set cpu stopped");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity, stopped");
+
+	/* Unshare all memory */
+	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
+			   UVC_CMD_SET_UNSHARED_ALL, &rc, &rrc);
+	report(cc == 0 && rc == 1, "Unshare all");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity stopped, unshared");
+
+	/* Prepare the CPU reset */
+	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
+			   UVC_CMD_PREPARE_RESET, &rc, &rrc);
+	report(cc == 0 && rc == 1, "Prepare reset call");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity stopped, unshared, prep reset");
+
+	/* Do the reset */
+	cc = uv_cmd_nodata(vm.sblk->pv_handle_cpu,
+			   UVC_CMD_CPU_RESET_CLEAR, &rc, &rrc);
+	report(cc == 0 && rc == 1, "Clear reset cpu");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity stopped, unshared, prep reset, cpu reset");
+
+	/* Load the PSW from 0x0 */
+	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_OPR_LOAD);
+	report(!cc, "Set cpu load");
+
+	/*
+	 * Check if we executed the iaddr of the reset PSW, we should
+	 * see a diagnose 0x9c PV instruction notification.
+	 */
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
+	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c &&
+	       vm.save_area.guest.grs[0] == 42,
+	       "intercept values");
+
+	uv_destroy_guest(&vm);
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("uv-sie");
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
+	test_diag_308_0();
+	test_diag_308_1();
+	sie_guest_destroy(&vm);
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/snippets/asm/snippet-pv-diag-308.S b/s390x/snippets/asm/snippet-pv-diag-308.S
new file mode 100644
index 00000000..58c96173
--- /dev/null
+++ b/s390x/snippets/asm/snippet-pv-diag-308.S
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Diagnose 0x308 snippet used for PV IPL and reset testing
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <asm/asm-offsets.h>
+.section .text
+
+/* Sets a reset PSW with the given PSW address */
+.macro SET_RESET_PSW_ADDR label
+lgrl	%r5, reset_psw
+larl	%r6, \label
+ogr	%r5, %r6
+stg	%r5, 0
+.endm
+
+/* Does a diagnose 308 with the given subcode */
+.macro DIAG308 subcode
+xgr	%r3, %r3
+lghi	%r3, \subcode
+diag	1, 3, 0x308
+.endm
+
+sam64
+
+/* Execute the diag500 which will set the subcode we execute in gr2 */
+diag	0, 0, 0x500
+
+/*
+ * A valid PGM new PSW can be a real problem since we never fall out
+ * of SIE and therefore effectively loop forever. 0 is a valid PSW
+ * therefore we re-use the reset_psw as this has the short PSW
+ * bit set which is invalid for a long PSW like the exception new
+ * PSWs.
+ *
+ * For subcode 0/1 there are no PGMs to consider.
+ */
+lgrl   %r5, reset_psw
+stg    %r5, GEN_LC_PGM_NEW_PSW
+
+/* Clean registers that are used */
+xgr	%r0, %r0
+xgr	%r1, %r1
+xgr	%r3, %r3
+xgr	%r4, %r4
+xgr	%r5, %r5
+xgr	%r6, %r6
+
+/* Subcode 0 - Modified Clear */
+SET_RESET_PSW_ADDR done
+diag	%r0, %r2, 0x308
+
+/* Should never be executed because of the reset PSW */
+diag	0, 0, 0x44
+
+done:
+lghi	%r1, 42
+diag	%r1, 0, 0x9c
+
+
+	.align	8
+reset_psw:
+	.quad	0x0008000180000000
-- 
2.34.1

