Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABBD6F434D
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 14:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbjEBMJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 08:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbjEBMJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 08:09:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520B3358B;
        Tue,  2 May 2023 05:09:00 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342C8Urf030222;
        Tue, 2 May 2023 12:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pnNdwiohBNEufmOADFoUWASVG4Sfa5VvFk/NbcGYpxQ=;
 b=erGu1wfzwodqPp/BGoH5yO1AOD0CGfpSrI0E/Uc4WlX4Bjx9pnfPwFvPzviL72rSUQpj
 5N53bTodnZOU+kWK/RatEywPleB+V8z2wk7Pi1u17AjV+VMlyO7Fdu9vilPDEHE48sSc
 sYHb583EVHkaS9dhXsYUl8DO8lONa2oQnvYBQ1LSNYKmmfNe5b7CRjhe3IMAWFnAJV5b
 E7kbIugvyjqw9YwJP9yisyDpnjqCBMaqsO2ByWphQ+QjnNe5c5SkUZk3sMo5vCQETcll
 YMOeziUWR5K2Z+FScIX5nCbbJKIRVjHLCkuCKBtT+0a6WY6coWR2YWMaBB4Z1uY2BK3e 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb21sg8b0-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:08:58 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342C1rhb012220;
        Tue, 2 May 2023 12:02:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb21sg6ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:02:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3420Zgj8004111;
        Tue, 2 May 2023 12:00:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q8tgg1ju8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:00:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342C0mtk34079156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 12:00:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5191F20043;
        Tue,  2 May 2023 12:00:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81FF320040;
        Tue,  2 May 2023 12:00:47 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 12:00:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v4 6/7] s390x: pv: Add IPL reset tests
Date:   Tue,  2 May 2023 11:59:30 +0000
Message-Id: <20230502115931.86280-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502115931.86280-1-frankja@linux.ibm.com>
References: <20230502115931.86280-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5irsdJv9jF5-7a2o5Gqn2FUt4pu5pMqx
X-Proofpoint-GUID: o6P8GwPVRPzGKYLTNdfQbNDgMetfrEAz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_05,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 s390x/Makefile                   |   2 +
 s390x/pv-ipl.c                   | 143 +++++++++++++++++++++++++++++++
 s390x/snippets/asm/pv-diag-308.S |  51 +++++++++++
 s390x/unittests.cfg              |   4 +
 4 files changed, 200 insertions(+)
 create mode 100644 s390x/pv-ipl.c
 create mode 100644 s390x/snippets/asm/pv-diag-308.S

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
index 00000000..cc46e7f7
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
diff --git a/s390x/snippets/asm/pv-diag-308.S b/s390x/snippets/asm/pv-diag-308.S
new file mode 100644
index 00000000..70aea589
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

