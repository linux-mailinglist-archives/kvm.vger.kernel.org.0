Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37146EA95F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 13:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjDULjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 07:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjDULjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 07:39:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B843C665;
        Fri, 21 Apr 2023 04:38:26 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LBXxGR026529;
        Fri, 21 Apr 2023 11:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qUkOxiXPrxZWeZG0ZI1NQXc9ZWtSGgUCM1b129joIXE=;
 b=Sv5f80ZsrcVyqRL/cJ3RACarv7XW0jjiBo1APYqfpAe3ppAmRQHebQAWkfNAxxS2AjTr
 nYAz1JISpILFC6blpyPYMd/QrxgCP2wj1v/vbMG4qAMnA+OBVdxtr246uhuphelwV9DE
 3nayXapaZ1yTMJ3YiSqB4l0MRGAFiwc5V9bM53KsDWwlyc/i/5wvm0Cwh8q8KZ/JTfg1
 bKrTdseiM/gEQEDRM0kaMBbzh7Y4w6FfUiW6TkvDlMFXBUFNTJqYMfaETqUfADUXb60E
 bqO7Fz9iViTJ4EkOiefCwA21Wazn5h3Hg27eF7HdFG6hnGZKHIPO5MFa/JPUY7ksWdw9 dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3rhe2n3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:29 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LBYmtC001485;
        Fri, 21 Apr 2023 11:37:28 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3rhe2n05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:28 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L9aIAN015113;
        Fri, 21 Apr 2023 11:37:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pykj6kata-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LBbMNA15860258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 11:37:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B723920043;
        Fri, 21 Apr 2023 11:37:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E901D20040;
        Fri, 21 Apr 2023 11:37:21 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Apr 2023 11:37:21 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 6/7] s390x: pv: Add IPL reset tests
Date:   Fri, 21 Apr 2023 11:36:46 +0000
Message-Id: <20230421113647.134536-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421113647.134536-1-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: b2fucuycnkqfW-FZO5Tsm_cAVTVYhj5Y
X-Proofpoint-GUID: QhGUhhrFG-JOqJ1mndi5psCwRp-Udtb3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_05,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 s390x/Makefile      |   2 +
 s390x/pv-ipl.c      | 145 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 ++
 3 files changed, 151 insertions(+)
 create mode 100644 s390x/pv-ipl.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 67be5360..b5b94810 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -43,6 +43,7 @@ tests += $(TEST_DIR)/ex.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
+pv-tests += $(TEST_DIR)/pv-ipl.elf
 
 ifneq ($(HOST_KEY_DOCUMENT),)
 ifneq ($(GEN_SE_HEADER),)
@@ -130,6 +131,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-112.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/icpt-loop.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/loop.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timing.gbin
+$(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
 
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
new file mode 100644
index 00000000..aad1275e
--- /dev/null
+++ b/s390x/pv-ipl.c
@@ -0,0 +1,145 @@
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
+#include <pv_icptdata.h>
+#include <asm/facility.h>
+#include <asm/uv.h>
+
+static struct vm vm;
+
+static void test_diag_308(int subcode)
+{
+	extern const char SNIPPET_NAME_START(asm, pv_diag_308)[];
+	extern const char SNIPPET_NAME_END(asm, pv_diag_308)[];
+	extern const char SNIPPET_HDR_START(asm, pv_diag_308)[];
+	extern const char SNIPPET_HDR_END(asm, pv_diag_308)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, pv_diag_308);
+	int size_gbin = SNIPPET_LEN(asm, pv_diag_308);
+	uint16_t rc, rrc;
+	char prefix[10];
+	int cc;
+
+	snprintf(prefix, sizeof(prefix), "subcode %d", subcode);
+
+	report_prefix_push(prefix);
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_308),
+			SNIPPET_HDR_START(asm, pv_diag_308),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	/* First exit is a diag 0x500 */
+	sie(&vm);
+	assert(pv_icptdata_check_diag(&vm, 0x500));
+
+	/*
+	 * The snippet asked us for the subcode and we answer with 0 in gr2
+	 * SIE will copy gr2 to the guest
+	 */
+	vm.save_area.guest.grs[2] = subcode;
+
+	/* Continue after diag 0x500, next icpt should be the 0x308 */
+	sie(&vm);
+	assert(pv_icptdata_check_diag(&vm, 0x308));
+	assert(vm.save_area.guest.grs[2] == subcode);
+
+	/*
+	 * We need to perform several UV calls to emulate the subcode
+	 * 0/1. Failing to do that should result in a validity.
+	 *
+	 * - Mark all cpus as stopped
+	 * - Unshare all memory
+	 * - Prepare the reset
+	 * - Reset the cpus
+	 * - Load the reset PSW
+	 */
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity, no action");
+
+	/* Mark the CPU as stopped so we can unshare and reset */
+	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_STP);
+	report(!cc, "Set cpu stopped");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity, stopped");
+
+	/* Unshare all memory */
+	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
+			   UVC_CMD_SET_UNSHARED_ALL, &rc, &rrc);
+	report(cc == 0 && rc == 1, "Unshare all");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity, stopped, unshared");
+
+	/* Prepare the CPU reset */
+	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
+			   UVC_CMD_PREPARE_RESET, &rc, &rrc);
+	report(cc == 0 && rc == 1, "Prepare reset call");
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity, stopped, unshared, prep reset");
+
+	/*
+	 * Do the reset on the initiating cpu
+	 *
+	 * Reset clear for subcode 0
+	 * Reset initial for subcode 1
+	 */
+	if (subcode == 0) {
+		cc = uv_cmd_nodata(vm.sblk->pv_handle_cpu,
+				   UVC_CMD_CPU_RESET_CLEAR, &rc, &rrc);
+		report(cc == 0 && rc == 1, "Clear reset cpu");
+	} else {
+		cc = uv_cmd_nodata(vm.sblk->pv_handle_cpu,
+				   UVC_CMD_CPU_RESET_INITIAL, &rc, &rrc);
+		report(cc == 0 && rc == 1, "Initial reset cpu");
+	}
+
+	sie_expect_validity(&vm);
+	sie(&vm);
+	report(uv_validity_check(&vm), "validity, stopped, unshared, prep reset, cpu reset");
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
+	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	       vm.save_area.guest.grs[0] == 42,
+	       "continue after load");
+
+	uv_destroy_guest(&vm);
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("uv-sie");
+	if (!uv_guest_requirement_checks())
+		goto done;
+
+	snippet_setup_guest(&vm, true);
+	test_diag_308(0);
+	test_diag_308(1);
+	sie_guest_destroy(&vm);
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index e2d3478e..e08e5c84 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -223,3 +223,7 @@ file = ex.elf
 file = pv-icptcode.elf
 smp = 3
 extra_params = -m 2200
+
+[pv-ipl]
+file = pv-ipl.elf
+extra_params = -m 2200
-- 
2.34.1

