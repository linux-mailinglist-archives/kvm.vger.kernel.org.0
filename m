Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA99734E86
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjFSIuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjFSItP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:49:15 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50B73C19;
        Mon, 19 Jun 2023 01:47:40 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35J8H7FN029020;
        Mon, 19 Jun 2023 08:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cmdQnQhlazLPaPGHb/eJWPwgmqyOgUe7vLVCn+DsO9s=;
 b=B82X9+wp1isKXKf9EYvMMbmaJqWxRNS8mMUQ/Ph45PdsDslbMLPIeHpRaj8I1sAwC9f6
 ixUJrY2H6CSZyLqiAMkmENZlBvF3gHxFe8xr71XZi769OZ9ZNQqIeKEGIudhY/DnYHXL
 1j4PrcnFg08RyULhyq4YCVMBDFTTmwn31D2QOD3z1fiIeUngPXLJB3rDhpH7wQANn73f
 XZJuZa2RJEb88zQfwi+uNaT2nJHg1bYcBD2NCKL9uSETpyPzvoP8JQX/8yXs61j4MLT1
 S3Z4X8dj8NcY4v/x+qkXGCUyZ4kVDD/6WjUxeAwVLpOeo+78HdS+SnZIze7T7VYsxob3 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rakcf8a85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:05 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35J8JK5w002523;
        Mon, 19 Jun 2023 08:34:04 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rakcf8a7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:04 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35J6RmT3030340;
        Mon, 19 Jun 2023 08:34:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3r94f58xet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:02 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35J8Xxg916646734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jun 2023 08:33:59 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9097E2004F;
        Mon, 19 Jun 2023 08:33:59 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC77220043;
        Mon, 19 Jun 2023 08:33:58 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jun 2023 08:33:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 7/8] s390x: pv: Add IPL reset tests
Date:   Mon, 19 Jun 2023 08:33:28 +0000
Message-Id: <20230619083329.22680-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230619083329.22680-1-frankja@linux.ibm.com>
References: <20230619083329.22680-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oYqOM2Cs8UXhZmX7DA5oh4fYY6LqXoDg
X-Proofpoint-ORIG-GUID: SYWS7wCAWpKzNJ-e_dY_ZFLgM07xqoiG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_05,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                   |   2 +
 s390x/pv-ipl.c                   | 143 +++++++++++++++++++++++++++++++
 s390x/snippets/asm/pv-diag-308.S |  51 +++++++++++
 s390x/unittests.cfg              |   5 ++
 4 files changed, 201 insertions(+)
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
index df25b483..26bab34a 100644
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
2.34.1

