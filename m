Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C167A74F193
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjGKORD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjGKOQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7251711
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:42 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BDups1001814;
        Tue, 11 Jul 2023 14:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=xukQPVlw0z3kiiqWbL5Ns22GC+gV5qt2t3p2QZL1iwk=;
 b=cnrQKmXabJPKwsaG7ij0FMshZvlBRO+MBnC2SpNmhMkENgX6FUQ7YHpJTVoWSTKRa/gf
 oQEasaV2OqfOwDHHaS3vXwy9xvRXjbDYRdiJkkVInb1YOE3Rt0VJSO/uBCXQ8P5d6tCM
 K1xlmPz+D0mMdMkbVxhElfXHOGyDuS2YYMsUuNu7iPvjtET0qU4KIOadtSabjZfCEc48
 ox3misRAMtq2kSjhsCJhk2OJ8JdWStCkvDF05G+g94PY7qUbyF9AO4Us1/cHhKOBR40y
 Ll4AecX+3XJ1FeyT8/0h12k/qv0QjVXvZKTXaWEyz8kMQtAb8oJVbONyIUFT2CV0mHUU +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8de0r0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:30 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BE6I6E026058;
        Tue, 11 Jul 2023 14:16:27 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8de0qtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:26 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B848mo008781;
        Tue, 11 Jul 2023 14:16:19 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rpye51c2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:18 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGFhi48038208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 707FC2004B;
        Tue, 11 Jul 2023 14:16:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E43E220049;
        Tue, 11 Jul 2023 14:16:14 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:14 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 09/22] s390x: pv: Add IPL reset tests
Date:   Tue, 11 Jul 2023 16:15:42 +0200
Message-ID: <20230711141607.40742-10-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ocX1Mj7A29jSYx_C-F00v_1fx1l2L1DM
X-Proofpoint-GUID: n1_dSjPPVKKiqxvVXv8MZCPK3HUvHWAX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 24 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The diag308 requires extensive cooperation between the hypervisor and
the Ultravisor so the Ultravisor can make sure all necessary reset
steps have been done.

Let's check if we get the correct validity errors.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230619083329.22680-8-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                   |   2 +
 s390x/snippets/asm/pv-diag-308.S |  51 +++++++++++
 s390x/pv-ipl.c                   | 143 +++++++++++++++++++++++++++++++
 s390x/unittests.cfg              |   5 ++
 4 files changed, 201 insertions(+)
 create mode 100644 s390x/snippets/asm/pv-diag-308.S
 create mode 100644 s390x/pv-ipl.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 67be536..b5b9481 100644
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
diff --git a/s390x/snippets/asm/pv-diag-308.S b/s390x/snippets/asm/pv-diag-308.S
new file mode 100644
index 0000000..70aea58
--- /dev/null
+++ b/s390x/snippets/asm/pv-diag-308.S
@@ -0,0 +1,51 @@
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
+/*
+ * Entry
+ * Execute the diag500 which will set the diag 308 subcode in gr2
+ */
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
+/* Set up the reset psw at 0x0 */
+lgrl	%r5, reset_psw
+larl	%r6, done
+ogr	%r5, %r6
+stg	%r5, 0
+
+/* Diag 308, subcode is in gr2 */
+diag	%r0, %r2, 0x308
+
+/* Should never be executed because of the reset PSW */
+diag	0, 0, 0x44
+
+/* Pass on a special value indicating success */
+done:
+lghi	%r1, 42
+diag	%r1, 0, 0x9c
+
+
+	.align	8
+reset_psw:
+	.quad	0x0008000180000000
diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
new file mode 100644
index 0000000..cc46e7f
--- /dev/null
+++ b/s390x/pv-ipl.c
@@ -0,0 +1,143 @@
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
+	int cc;
+
+	report_prefix_pushf("subcode %d", subcode);
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_308),
+			SNIPPET_HDR_START(asm, pv_diag_308),
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
+
+	/* First exit is a diag 0x500 */
+	sie(&vm);
+	assert(pv_icptdata_check_diag(&vm, 0x500));
+
+	/*
+	 * The snippet asked us for the subcode and we answer by
+	 * putting the value in gr2.
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
+	if (!uv_host_requirement_checks())
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
index df25b48..26bab34 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -224,3 +224,8 @@ file = pv-icptcode.elf
 smp = 3
 groups = pv-host
 extra_params = -m 2200
+
+[pv-ipl]
+file = pv-ipl.elf
+groups = pv-host
+extra_params = -m 2200
-- 
2.41.0

