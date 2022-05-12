Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F917524912
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352042AbiELJfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352026AbiELJfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD8D69B79
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:36 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9CN0W019274
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=y2y9id58Z1PTUjdRrulPrSYmT1ksF1bCZGfBzsC5k4s=;
 b=DiS6s/EDsod1Pxtv+3EmLxur5J0gecWWMD5wW0bdJSwnvUtXAZrlTiDGQURPyWjwT2D3
 w8d6fRylK9m0j8G4MYwGjLvqNpHTNDuNL3U7AxAM4NOZuXMZjGTpEkClcNmSkwY73Gc2
 pO5Ty2r2x/F79wAGHhX1/lZbrrPDhgO31/TP6DjnbGQGCEhCfTfkEGObVWBDfWnu6CL7
 7sqSFn7OLTOIuOTl3pnZ0ALpOitxxV70dYn3HSDUA9iddy88pXtEyrG9ej6zgw2wSCIl
 o5oXZhGxYYyn3DgGvixVeGkLlQV7z5oQ9dumMm78+a5BF/7TU40LidRZnTvd6V+Gbd2h 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd48e0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:35 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9OHir000646
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd48dyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:34 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XN5d008155;
        Thu, 12 May 2022 09:35:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3fwgd8w9yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZTgk31981892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D4CC11C04A;
        Thu, 12 May 2022 09:35:29 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F350411C054;
        Thu, 12 May 2022 09:35:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 02/28] s390x: add test for SIGP STORE_ADTL_STATUS order
Date:   Thu, 12 May 2022 11:34:57 +0200
Message-Id: <20220512093523.36132-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 85bE1C2zrUkSOO5u6mCgll0-E5znxHEp
X-Proofpoint-GUID: iRhVDdbpGqiiahb0hcu3ToiYRHZ8iuxs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Add a test for SIGP STORE_ADDITIONAL_STATUS order.

There are several cases to cover:
- when neither vector nor guarded-storage facility is available, check
  the order is rejected.
- when one of the facilities is there, test the order is rejected and
  adtl_status is not touched when the target CPU is running or when an
  invalid CPU address is specified. Also check the order is rejected
  in case of invalid alignment.
- when the vector facility is there, write some data to the CPU's
  vector registers and check we get the right contents.
- when the guarded-storage facility is there, populate the CPU's
  guarded-storage registers with some data and again check we get the
  right contents.

To make sure we cover all these cases, adjust unittests.cfg to run the
test with both guarded-storage and vector facility off and on. In TCG, we don't
have guarded-storage support, so we just run with vector facility off and on.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile         |   1 +
 lib/s390x/asm/vector.h |  16 ++
 s390x/adtl-status.c    | 408 +++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  25 +++
 4 files changed, 450 insertions(+)
 create mode 100644 lib/s390x/asm/vector.h
 create mode 100644 s390x/adtl-status.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 8ff84db5..c11f6efb 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -29,6 +29,7 @@ tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
 tests += $(TEST_DIR)/firq.elf
 tests += $(TEST_DIR)/epsw.elf
+tests += $(TEST_DIR)/adtl-status.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/lib/s390x/asm/vector.h b/lib/s390x/asm/vector.h
new file mode 100644
index 00000000..ee48bfa6
--- /dev/null
+++ b/lib/s390x/asm/vector.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Vector facility related defines and functions
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *    Nico Boehr <nrb@linux.ibm.com>
+ */
+#ifndef _ASMS390X_VECTOR_H_
+#define _ASMS390X_VECTOR_H_
+
+#define VEC_REGISTER_NUM 32
+#define VEC_REGISTER_SIZE 16
+
+#endif
diff --git a/s390x/adtl-status.c b/s390x/adtl-status.c
new file mode 100644
index 00000000..9fb76319
--- /dev/null
+++ b/s390x/adtl-status.c
@@ -0,0 +1,408 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Tests sigp store additional status order
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *    Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/facility.h>
+#include <asm-generic/barrier.h>
+#include <asm/sigp.h>
+#include <asm/vector.h>
+
+#include <smp.h>
+#include <gs.h>
+
+static int testflag = 0;
+
+#define INVALID_CPU_ADDRESS -4711
+
+struct mcesa_lc12 {
+	uint8_t vregs[0x200];		      /* 0x000 */
+	uint8_t reserved200[0x400 - 0x200];   /* 0x200 */
+	struct gs_cb gs_cb;                   /* 0x400 */
+	uint8_t reserved420[0x800 - 0x420];   /* 0x420 */
+	uint8_t reserved800[0x1000 - 0x800];  /* 0x800 */
+};
+
+static struct mcesa_lc12 adtl_status __attribute__((aligned(4096)));
+
+static uint8_t expected_vec_contents[VEC_REGISTER_NUM][VEC_REGISTER_SIZE];
+
+static struct gs_cb gs_cb;
+static struct gs_epl gs_epl;
+
+static bool memisset(void *s, int c, size_t n)
+{
+	uint8_t *p = s;
+	size_t i;
+
+	for (i = 0; i < n; i++) {
+		if (p[i] != c)
+			return false;
+	}
+
+	return true;
+}
+
+static void wait_for_flag(void)
+{
+	while (!testflag)
+		mb();
+}
+
+static void set_flag(int val)
+{
+	mb();
+	testflag = val;
+	mb();
+}
+
+static void test_func(void)
+{
+	set_flag(1);
+}
+
+static bool have_adtl_status(void)
+{
+	return test_facility(133) || test_facility(129);
+}
+
+static void test_store_adtl_status(void)
+{
+	uint32_t status = -1;
+	int cc;
+
+	report_prefix_push("store additional status");
+
+	if (!have_adtl_status()) {
+		report_skip("no guarded-storage or vector facility installed");
+		goto out;
+	}
+
+	memset(&adtl_status, 0xff, sizeof(adtl_status));
+
+	report_prefix_push("running");
+	smp_cpu_restart(1);
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status, &status);
+
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INCORRECT_STATE, "status = INCORRECT_STATE");
+	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
+	       "additional status not touched");
+
+	report_prefix_pop();
+
+	report_prefix_push("invalid CPU address");
+
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status, &status);
+	report(cc == 3, "CC = 3");
+	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
+	       "additional status not touched");
+
+	report_prefix_pop();
+
+	report_prefix_push("unaligned");
+	smp_cpu_stop(1);
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status + 256, &status);
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INVALID_PARAMETER, "status = INVALID_PARAMETER");
+	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
+	       "additional status not touched");
+
+	report_prefix_pop();
+
+out:
+	report_prefix_pop();
+}
+
+static void test_store_adtl_status_unavail(void)
+{
+	uint32_t status = 0;
+	int cc;
+
+	report_prefix_push("store additional status unavailable");
+
+	if (have_adtl_status()) {
+		report_skip("guarded-storage or vector facility installed");
+		goto out;
+	}
+
+	report_prefix_push("not accepted");
+	smp_cpu_stop(1);
+
+	memset(&adtl_status, 0xff, sizeof(adtl_status));
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status, &status);
+
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INVALID_ORDER,
+	       "status = INVALID_ORDER");
+	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
+	       "additional status not touched");
+
+	report_prefix_pop();
+
+out:
+	report_prefix_pop();
+}
+
+static void restart_write_vector(void)
+{
+	uint8_t *vec_reg;
+	/* vlm handles at most 16 registers at a time */
+	uint8_t *vec_reg_16_31 = &expected_vec_contents[16][0];
+	uint64_t cr0, cr0_mask = ~BIT_ULL(CTL0_VECTOR);
+	int i;
+
+	for (i = 0; i < VEC_REGISTER_NUM; i++) {
+		vec_reg = &expected_vec_contents[i][0];
+		/* i+1 to avoid zero content */
+		memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
+	}
+
+	ctl_set_bit(0, CTL0_VECTOR);
+
+	asm volatile (
+		"	.machine z13\n"
+		/* load vector registers */
+		"	vlm 0,15, %[vec_reg_0_15]\n"
+		"	vlm 16,31, %[vec_reg_16_31]\n"
+		/* turn off vector instructions */
+		"	stctg 0,0, %[cr0]\n"
+		"	ng %[cr0_mask], %[cr0]\n"
+		"	stg %[cr0_mask], %[cr0]\n"
+		"	lctlg 0,0, %[cr0]\n"
+		/* inform CPU 0 we are done by setting testflag to 1 */
+		"	mvhi %[testflag], 1\n"
+		/*
+		 * infinite loop. function epilogue will restore floating point
+		 * registers and hence destroy vector register contents
+		 */
+		"0:	j 0\n"
+		: [cr0_mask] "+&d"(cr0_mask)
+		: [vec_reg_0_15] "Q"(expected_vec_contents),
+		  [vec_reg_16_31] "Q"(*vec_reg_16_31),
+		  [cr0] "Q"(cr0),
+		  [testflag] "T"(testflag)
+		: "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
+		  "v10", "v11", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
+		  "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27",
+		  "v28", "v29", "v30", "v31", "cc", "memory"
+	);
+}
+
+static void cpu_write_magic_to_vector_regs(uint16_t cpu_idx)
+{
+	struct psw new_psw;
+
+	smp_cpu_stop(cpu_idx);
+
+	new_psw.mask = extract_psw_mask();
+	new_psw.addr = (unsigned long)restart_write_vector;
+
+	set_flag(0);
+
+	smp_cpu_start(cpu_idx, new_psw);
+
+	wait_for_flag();
+}
+
+static int adtl_status_check_unmodified_fields_for_lc(unsigned long lc)
+{
+	assert (!lc || (lc >= 10 && lc <= 12));
+
+	if (lc <= 10 && !memisset(&adtl_status.gs_cb, 0xff, sizeof(adtl_status.gs_cb)))
+		return false;
+
+	if (!memisset(adtl_status.reserved200, 0xff, sizeof(adtl_status.reserved200)))
+		return false;
+
+	if (!memisset(adtl_status.reserved420, 0xff, sizeof(adtl_status.reserved420)))
+		return false;
+
+	if (!memisset(adtl_status.reserved800, 0xff, sizeof(adtl_status.reserved800)))
+		return false;
+
+	return true;
+}
+
+static void __store_adtl_status_vector_lc(unsigned long lc)
+{
+	uint32_t status = -1;
+	struct psw psw;
+	int cc;
+
+	report_prefix_pushf("LC %lu", lc);
+
+	if (!test_facility(133) && lc) {
+		report_skip("not supported, no guarded-storage facility");
+		goto out;
+	}
+
+	cpu_write_magic_to_vector_regs(1);
+	smp_cpu_stop(1);
+
+	memset(&adtl_status, 0xff, sizeof(adtl_status));
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status | lc, &status);
+	report(!cc, "CC = 0");
+
+	report(!memcmp(adtl_status.vregs,
+		       expected_vec_contents, sizeof(expected_vec_contents)),
+	       "additional status contents match");
+
+	report(adtl_status_check_unmodified_fields_for_lc(lc),
+	       "no write outside expected fields");
+
+	/*
+	 * To avoid the floating point/vector registers being cleaned up, we
+	 * stopped CPU1 right in the middle of a function. Hence the cleanup of
+	 * the function didn't run yet and the stackpointer is messed up.
+	 * Destroy and re-initalize the CPU to fix that.
+	 */
+	smp_cpu_destroy(1);
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)test_func;
+	smp_cpu_setup(1, psw);
+
+out:
+	report_prefix_pop();
+}
+
+static void test_store_adtl_status_vector(void)
+{
+	report_prefix_push("store additional status vector");
+
+	if (!test_facility(129)) {
+		report_skip("vector facility not installed");
+		goto out;
+	}
+
+	__store_adtl_status_vector_lc(0);
+	__store_adtl_status_vector_lc(10);
+	__store_adtl_status_vector_lc(11);
+	__store_adtl_status_vector_lc(12);
+
+out:
+	report_prefix_pop();
+}
+
+static void restart_write_gs_regs(void)
+{
+	const unsigned long gs_area = 0x2000000;
+	const unsigned long gsc = 25; /* align = 32 M, section size = 512K */
+
+	ctl_set_bit(2, CTL2_GUARDED_STORAGE);
+
+	gs_cb.gsd = gs_area | gsc;
+	gs_cb.gssm = 0xfeedc0ffe;
+	gs_cb.gs_epl_a = (uint64_t) &gs_epl;
+
+	load_gs_cb(&gs_cb);
+
+	set_flag(1);
+
+	ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
+
+	/*
+	 * Safe to return here. r14 will point to the endless loop in
+	 * smp_cpu_setup_state.
+	 */
+}
+
+static void cpu_write_to_gs_regs(uint16_t cpu_idx)
+{
+	struct psw new_psw;
+
+	smp_cpu_stop(cpu_idx);
+
+	new_psw.mask = extract_psw_mask();
+	new_psw.addr = (unsigned long)restart_write_gs_regs;
+
+	set_flag(0);
+
+	smp_cpu_start(cpu_idx, new_psw);
+
+	wait_for_flag();
+}
+
+static void __store_adtl_status_gs(unsigned long lc)
+{
+	uint32_t status = 0;
+	int cc;
+
+	report_prefix_pushf("LC %lu", lc);
+
+	cpu_write_to_gs_regs(1);
+	smp_cpu_stop(1);
+
+	memset(&adtl_status, 0xff, sizeof(adtl_status));
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status | lc, &status);
+	report(!cc, "CC = 0");
+
+	report(!memcmp(&adtl_status.gs_cb, &gs_cb, sizeof(gs_cb)),
+	       "additional status contents match");
+
+	report(adtl_status_check_unmodified_fields_for_lc(lc),
+	       "no write outside expected fields");
+
+	report_prefix_pop();
+}
+
+static void test_store_adtl_status_gs(void)
+{
+	report_prefix_push("store additional status guarded-storage");
+
+	if (!test_facility(133)) {
+		report_skip("guarded-storage facility not installed");
+		goto out;
+	}
+
+	__store_adtl_status_gs(11);
+	__store_adtl_status_gs(12);
+
+out:
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	struct psw psw;
+	report_prefix_push("adtl_status");
+
+	if (smp_query_num_cpus() == 1) {
+		report_skip("need at least 2 cpus for this test");
+		goto done;
+	}
+
+	/* Setting up the cpu to give it a stack and lowcore */
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)test_func;
+	smp_cpu_setup(1, psw);
+	smp_cpu_stop(1);
+
+	test_store_adtl_status_unavail();
+	test_store_adtl_status_vector();
+	test_store_adtl_status_gs();
+	test_store_adtl_status();
+	smp_cpu_destroy(1);
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 743013b2..256c7169 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -146,3 +146,28 @@ extra_params = -device virtio-net-ccw
 
 [tprot]
 file = tprot.elf
+
+[adtl-status-kvm]
+file = adtl-status.elf
+smp = 2
+accel = kvm
+extra_params = -cpu host,gs=on,vx=on
+
+[adtl-status-no-vec-no-gs-kvm]
+file = adtl-status.elf
+smp = 2
+accel = kvm
+extra_params = -cpu host,gs=off,vx=off
+
+[adtl-status-tcg]
+file = adtl-status.elf
+smp = 2
+accel = tcg
+# no guarded-storage support in tcg
+extra_params = -cpu qemu,vx=on
+
+[adtl-status-no-vec-no-gs-tcg]
+file = adtl-status.elf
+smp = 2
+accel = tcg
+extra_params = -cpu qemu,gs=off,vx=off
-- 
2.36.1

