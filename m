Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241104E242F
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346278AbiCUKUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346258AbiCUKUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314432B1B0;
        Mon, 21 Mar 2022 03:19:13 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L9flfv002475;
        Mon, 21 Mar 2022 10:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KOW4B+B+gvXGH4dB/xR21fTFmttn5uOgaEpBLMciALg=;
 b=L+x9PMcmXFfcrplPySmdlMu/fkItW9QwJf2NvFi+10XnnotKCbIgeVFD7qkiTUysawns
 qc4POAFrJ8D4a/iT+3USLJlo820uIk8qNCKB8mydrjiDyX0SewPF5lZjqcR/CMulXi+j
 oMmrosGFQmxdGO/CroCr9Gsrt79jhs4X5W8tzKWMqUI46VqWXBjBYhPMTwZTR7hQiD9l
 sANcs2sUp2NukYJXHPPxlPH9Pz7yUFtR8o6QMS3YE/vN1JtJmE7L8QDldKRpe5zZmpp3
 sVU5aS15WGaB5WylhRIx6GsnReddTML0AakjUIiwA2TutjuTPyzUWgQXnepnjtVFpQO3 rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3expy08pd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:12 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LAFi1X029837;
        Mon, 21 Mar 2022 10:19:11 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3expy08pcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:11 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LACUII012471;
        Mon, 21 Mar 2022 10:19:09 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3ew6t8k3b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LAJ6ua23003480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:19:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77CD711C04A;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DCD911C054;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 4/9] s390x: smp: add test for SIGP_STORE_ADTL_STATUS order
Date:   Mon, 21 Mar 2022 11:18:59 +0100
Message-Id: <20220321101904.387640-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ut_OJbF31xAn6scFmtDGkjMcz6wEa4PM
X-Proofpoint-GUID: x7dC2Lwwd15hEe43iRLkPpmXnvx582p-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test for SIGP_STORE_ADDITIONAL_STATUS order.

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
smp tests with both guarded-storage and vector facility off and on.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c         | 259 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   6 +
 2 files changed, 265 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index e5a16eb5a46a..5d3265f6be64 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -16,6 +16,7 @@
 #include <asm/sigp.h>
 
 #include <smp.h>
+#include <gs.h>
 #include <alloc_page.h>
 
 static int testflag = 0;
@@ -37,6 +38,19 @@ static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
 	{ INVALID_ORDER_CODE,         "invalid order code" },
 };
 
+/*
+ * We keep two structs, one for comparing when we want to assert it's not
+ * touched.
+ */
+static uint8_t adtl_status[2][4096] __attribute__((aligned(4096)));
+
+#define NUM_VEC_REGISTERS 32
+#define VEC_REGISTER_SIZE 16
+static uint8_t expected_vec_contents[NUM_VEC_REGISTERS][VEC_REGISTER_SIZE];
+
+static struct gs_cb gs_cb;
+static struct gs_epl gs_epl;
+
 static void test_invalid(void)
 {
 	const struct sigp_invalid_cases *c;
@@ -200,6 +214,247 @@ static void test_store_status(void)
 	report_prefix_pop();
 }
 
+static int have_adtl_status(void)
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
+	memset(adtl_status, 0xff, sizeof(adtl_status));
+
+	report_prefix_push("running");
+	smp_cpu_restart(1);
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)adtl_status, &status);
+
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INCORRECT_STATE, "status = INCORRECT_STATE");
+	report(!memcmp(adtl_status[0], adtl_status[1], sizeof(adtl_status[0])),
+	       "additional status not touched");
+
+	report_prefix_pop();
+
+	report_prefix_push("invalid CPU address");
+
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)adtl_status, &status);
+	report(cc == 3, "CC = 3");
+	report(!memcmp(adtl_status[0], adtl_status[1], sizeof(adtl_status[0])),
+	       "additional status not touched");
+
+	report_prefix_pop();
+
+	report_prefix_push("unaligned");
+	smp_cpu_stop(1);
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)adtl_status + 256, &status);
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INVALID_PARAMETER, "status = INVALID_PARAMETER");
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
+	report_prefix_push("store additional status unvailable");
+
+	if (have_adtl_status()) {
+		report_skip("guarded-storage or vector facility installed");
+		goto out;
+	}
+
+	report_prefix_push("not accepted");
+	smp_cpu_stop(1);
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)adtl_status, &status);
+
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INVALID_ORDER,
+	       "status = INVALID_ORDER");
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
+	uint8_t *vec_reg_16_31 = &expected_vec_contents[16][0];
+	int i;
+
+	for (i = 0; i < NUM_VEC_REGISTERS; i++) {
+		vec_reg = &expected_vec_contents[i][0];
+		memset(vec_reg, i, VEC_REGISTER_SIZE);
+	}
+
+	ctl_set_bit(0, CTL0_VECTOR);
+
+	asm volatile (
+		"	.machine z13\n"
+		"	vlm 0,15, %[vec_reg_0_15]\n"
+		"	vlm 16,31, %[vec_reg_16_31]\n"
+		:
+		: [vec_reg_0_15] "Q"(expected_vec_contents),
+		  [vec_reg_16_31] "Q"(*vec_reg_16_31)
+		: "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
+		  "v10", "v11", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
+		  "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27",
+		  "v28", "v29", "v30", "v31", "memory"
+	);
+
+	ctl_clear_bit(0, CTL0_VECTOR);
+
+	set_flag(1);
+
+	/*
+	 * function epilogue will restore floating point registers and hence
+	 * destroy vector register contents
+	 */
+	while (1)
+		;
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
+static void test_store_adtl_status_vector(void)
+{
+	uint32_t status = -1;
+	struct psw psw;
+	int cc;
+
+	report_prefix_push("store additional status vector");
+
+	if (!test_facility(129)) {
+		report_skip("vector facility not installed");
+		goto out;
+	}
+
+	cpu_write_magic_to_vector_regs(1);
+	smp_cpu_stop(1);
+
+	memset(adtl_status, 0xff, sizeof(adtl_status));
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)adtl_status, &status);
+	report(!cc, "CC = 0");
+
+	report(!memcmp(adtl_status, expected_vec_contents, sizeof(expected_vec_contents)),
+	       "additional status contents match");
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
+static void test_store_adtl_status_gs(void)
+{
+	const unsigned long adtl_status_lc_11 = 11;
+	uint32_t status = 0;
+	int cc;
+
+	report_prefix_push("store additional status guarded-storage");
+
+	if (!test_facility(133)) {
+		report_skip("guarded-storage facility not installed");
+		goto out;
+	}
+
+	cpu_write_to_gs_regs(1);
+	smp_cpu_stop(1);
+
+	memset(adtl_status, 0xff, sizeof(adtl_status));
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)adtl_status | adtl_status_lc_11, &status);
+	report(!cc, "CC = 0");
+
+	report(!memcmp(&adtl_status[0][1024], &gs_cb, sizeof(gs_cb)),
+	       "additional status contents match");
+
+out:
+	report_prefix_pop();
+}
+
 static void ecall(void)
 {
 	unsigned long mask;
@@ -388,6 +643,10 @@ int main(void)
 	test_stop();
 	test_stop_store_status();
 	test_store_status();
+	test_store_adtl_status_unavail();
+	test_store_adtl_status_vector();
+	test_store_adtl_status_gs();
+	test_store_adtl_status();
 	test_ecall();
 	test_emcall();
 	test_sense_running();
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 1600e714c8b9..2d0adc503917 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -77,6 +77,12 @@ extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003 -sm
 [smp]
 file = smp.elf
 smp = 2
+extra_params = -cpu host,gs=on,vx=on
+
+[smp-no-vec-no-gs]
+file = smp.elf
+smp = 2
+extra_params = -cpu host,gs=off,vx=off
 
 [sclp-1g]
 file = sclp.elf
-- 
2.31.1

