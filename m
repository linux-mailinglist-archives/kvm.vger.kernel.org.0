Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B8F63D99C
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 16:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiK3Pkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 10:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiK3Pkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 10:40:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A48848422
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 07:40:46 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUFC0i5018637
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RpdeuqYYHgDk8zIfLHGH9SsiSdE0CztYVnwJ9WktkkY=;
 b=sjpkyPGweHh8q7TihuujX0732eDfrZgK4SY4LbwlSPapumgdhlz2Uwc235WynDlqNW5j
 ZL2GApY6rxg8Heb1eCEZIW3YyHOU01Y/GqXOp94PE0bRlibotcN37bI5Jx4ItLqaEeKQ
 sNx2IVKN4q6Kv+CB74CMX360MHiqrm0WYHSlmFnt9XyOPo55UZteciB+LWYkImWwyd8b
 hj4FngRBH9Ijpw2CCHl4VY5fsEQSkDQ+Pt+0XbBFp3OgTfzNdXuWCqrmzqDCX/xYeb/w
 l/LGHoWhxueoRVWfEymoLzROtOQvUkNk5Jy96ELPJ/+I/1GL3oBrk4TjUmqaW4yHmW5e JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m69ku8qmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:45 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUFYdsk029935
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:45 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m69ku8qkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 15:40:44 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUFcbd6013867;
        Wed, 30 Nov 2022 15:40:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3m3a2hvc8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 15:40:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUFY9D42491014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 15:34:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 663B05204E;
        Wed, 30 Nov 2022 15:40:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2E05752050;
        Wed, 30 Nov 2022 15:40:39 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/2] s390x: use the new PSW and PSW_WITH_CUR_MASK macros
Date:   Wed, 30 Nov 2022 16:40:38 +0100
Message-Id: <20221130154038.70492-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130154038.70492-1-imbrenda@linux.ibm.com>
References: <20221130154038.70492-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _B3dLHNtOoAUu74_kgODNTnVmXphCl1P
X-Proofpoint-ORIG-GUID: TdKjRl3RFVFkSfIVwN6tVYwzbXMgP6to
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 mlxlogscore=897 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new macros in the existing code. No functional changes intended.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/adtl-status.c | 24 ++++----------------
 s390x/firq.c        |  5 +----
 s390x/migration.c   |  6 +----
 s390x/skrf.c        |  7 +-----
 s390x/smp.c         | 53 ++++++++++-----------------------------------
 s390x/uv-host.c     |  5 +----
 6 files changed, 19 insertions(+), 81 deletions(-)

diff --git a/s390x/adtl-status.c b/s390x/adtl-status.c
index 9fb76319..2db650a1 100644
--- a/s390x/adtl-status.c
+++ b/s390x/adtl-status.c
@@ -205,16 +205,11 @@ static void restart_write_vector(void)
 
 static void cpu_write_magic_to_vector_regs(uint16_t cpu_idx)
 {
-	struct psw new_psw;
-
 	smp_cpu_stop(cpu_idx);
 
-	new_psw.mask = extract_psw_mask();
-	new_psw.addr = (unsigned long)restart_write_vector;
-
 	set_flag(0);
 
-	smp_cpu_start(cpu_idx, new_psw);
+	smp_cpu_start(cpu_idx, PSW_WITH_CUR_MASK(restart_write_vector));
 
 	wait_for_flag();
 }
@@ -241,7 +236,6 @@ static int adtl_status_check_unmodified_fields_for_lc(unsigned long lc)
 static void __store_adtl_status_vector_lc(unsigned long lc)
 {
 	uint32_t status = -1;
-	struct psw psw;
 	int cc;
 
 	report_prefix_pushf("LC %lu", lc);
@@ -274,9 +268,7 @@ static void __store_adtl_status_vector_lc(unsigned long lc)
 	 * Destroy and re-initalize the CPU to fix that.
 	 */
 	smp_cpu_destroy(1);
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func;
-	smp_cpu_setup(1, psw);
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(test_func));
 
 out:
 	report_prefix_pop();
@@ -325,16 +317,11 @@ static void restart_write_gs_regs(void)
 
 static void cpu_write_to_gs_regs(uint16_t cpu_idx)
 {
-	struct psw new_psw;
-
 	smp_cpu_stop(cpu_idx);
 
-	new_psw.mask = extract_psw_mask();
-	new_psw.addr = (unsigned long)restart_write_gs_regs;
-
 	set_flag(0);
 
-	smp_cpu_start(cpu_idx, new_psw);
+	smp_cpu_start(cpu_idx, PSW_WITH_CUR_MASK(restart_write_gs_regs));
 
 	wait_for_flag();
 }
@@ -382,7 +369,6 @@ out:
 
 int main(void)
 {
-	struct psw psw;
 	report_prefix_push("adtl_status");
 
 	if (smp_query_num_cpus() == 1) {
@@ -391,9 +377,7 @@ int main(void)
 	}
 
 	/* Setting up the cpu to give it a stack and lowcore */
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func;
-	smp_cpu_setup(1, psw);
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(test_func));
 	smp_cpu_stop(1);
 
 	test_store_adtl_status_unavail();
diff --git a/s390x/firq.c b/s390x/firq.c
index b4b3542e..0d65d87f 100644
--- a/s390x/firq.c
+++ b/s390x/firq.c
@@ -33,7 +33,6 @@ static void wait_for_sclp_int(void)
  */
 static void test_wait_state_delivery(void)
 {
-	struct psw psw;
 	SCCBHeader *h;
 	int ret;
 
@@ -55,9 +54,7 @@ static void test_wait_state_delivery(void)
 	sclp_mark_busy();
 
 	/* Start CPU #1 and let it wait for the interrupt. */
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)wait_for_sclp_int;
-	ret = smp_cpu_setup(1, psw);
+	ret = smp_cpu_setup(1, PSW_WITH_CUR_MASK(wait_for_sclp_int));
 	/* This must not fail because we have at least 3 CPUs */
 	assert(!ret);
 
diff --git a/s390x/migration.c b/s390x/migration.c
index a4529637..a4aa22e7 100644
--- a/s390x/migration.c
+++ b/s390x/migration.c
@@ -158,8 +158,6 @@ static void test_func(void)
 
 int main(void)
 {
-	struct psw psw;
-
 	/* don't say migrate here otherwise we will migrate right away */
 	report_prefix_push("migration");
 
@@ -169,9 +167,7 @@ int main(void)
 	}
 
 	/* Second CPU does the actual tests */
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func;
-	smp_cpu_setup(1, psw);
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(test_func));
 
 	/* wait for thread setup */
 	while(!flag_thread_complete)
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 4cb563c3..e72a2b19 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -151,11 +151,6 @@ static void ecall_setup(void)
 
 static void test_exception_ext_new(void)
 {
-	struct psw psw = {
-		.mask = extract_psw_mask(),
-		.addr = (unsigned long)ecall_setup
-	};
-
 	report_prefix_push("exception external new");
 	if (smp_query_num_cpus() < 2) {
 		report_skip("Need second cpu for exception external new test.");
@@ -163,7 +158,7 @@ static void test_exception_ext_new(void)
 		return;
 	}
 
-	smp_cpu_setup(1, psw);
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(ecall_setup));
 	wait_for_flag();
 	set_flag(0);
 
diff --git a/s390x/smp.c b/s390x/smp.c
index 91f3e3bc..2b03bf0c 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -101,12 +101,8 @@ static void test_func(void)
 
 static void test_start(void)
 {
-	struct psw psw;
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func;
-
 	set_flag(0);
-	smp_cpu_start(1, psw);
+	smp_cpu_start(1, PSW_WITH_CUR_MASK(test_func));
 	wait_for_flag();
 	report_pass("start");
 }
@@ -120,8 +116,7 @@ static void test_restart(void)
 	report_prefix_push("restart");
 	report_prefix_push("stopped");
 
-	lc->restart_new_psw.mask = extract_psw_mask();
-	lc->restart_new_psw.addr = (unsigned long)test_func;
+	lc->restart_new_psw = PSW_WITH_CUR_MASK(test_func);
 
 	/* Make sure cpu is stopped */
 	smp_cpu_stop(1);
@@ -256,7 +251,6 @@ static void test_set_prefix(void)
 	struct lowcore *new_lc = alloc_pages_flags(1, AREA_DMA31);
 	struct cpu *cpu1 = smp_cpu_from_idx(1);
 	uint32_t status = 0;
-	struct psw new_psw;
 	int cc;
 
 	report_prefix_push("set prefix");
@@ -268,9 +262,7 @@ static void test_set_prefix(void)
 
 	report_prefix_push("running");
 	set_flag(0);
-	new_psw.addr = (unsigned long)stpx_and_set_flag;
-	new_psw.mask = extract_psw_mask();
-	smp_cpu_start(1, new_psw);
+	smp_cpu_start(1, PSW_WITH_CUR_MASK(stpx_and_set_flag));
 	wait_for_flag();
 	cpu1_prefix = 0xFFFFFFFF;
 
@@ -326,7 +318,6 @@ static void call_received(void)
 static void test_calls(void)
 {
 	int i;
-	struct psw psw;
 
 	for (i = 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
 		current_sigp_call_case = &cases_sigp_call[i];
@@ -339,9 +330,7 @@ static void test_calls(void)
 		}
 
 		set_flag(0);
-		psw.mask = extract_psw_mask();
-		psw.addr = (unsigned long)call_received;
-		smp_cpu_start(1, psw);
+		smp_cpu_start(1, PSW_WITH_CUR_MASK(call_received));
 
 		/* Wait until the receiver has finished setup */
 		wait_for_flag();
@@ -389,7 +378,6 @@ static void call_in_wait_cleanup(void)
 static void test_calls_in_wait(void)
 {
 	int i;
-	struct psw psw;
 
 	report_prefix_push("psw wait");
 	for (i = 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
@@ -404,9 +392,7 @@ static void test_calls_in_wait(void)
 
 		/* Let the secondary CPU setup the external mask and the external interrupt cleanup function */
 		set_flag(0);
-		psw.mask = extract_psw_mask();
-		psw.addr = (unsigned long)call_in_wait_setup;
-		smp_cpu_start(1, psw);
+		smp_cpu_start(1, PSW_WITH_CUR_MASK(call_in_wait_setup));
 
 		/* Wait until the receiver has finished setup */
 		wait_for_flag();
@@ -422,9 +408,7 @@ static void test_calls_in_wait(void)
 		 * wait until the CPU becomes operating (done by smp_cpu_start).
 		 */
 		smp_cpu_stop(1);
-		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
-		psw.addr = (unsigned long)call_in_wait_received;
-		smp_cpu_start(1, psw);
+		smp_cpu_start(1, PSW(extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT, call_in_wait_received));
 
 		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
 
@@ -439,9 +423,7 @@ static void test_calls_in_wait(void)
 		 * to catch an interrupt that is presented twice since we would
 		 * disable the external call on the first interrupt.
 		 */
-		psw.mask = extract_psw_mask();
-		psw.addr = (unsigned long)call_in_wait_cleanup;
-		smp_cpu_start(1, psw);
+		smp_cpu_start(1, PSW_WITH_CUR_MASK(call_in_wait_cleanup));
 
 		/* Wait until the cleanup has been completed */
 		wait_for_flag();
@@ -478,15 +460,11 @@ static void test_func_initial(void)
 static void test_reset_initial(void)
 {
 	struct cpu_status *status = alloc_pages_flags(0, AREA_DMA31);
-	struct psw psw;
 	int i;
 
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func_initial;
-
 	report_prefix_push("reset initial");
 	set_flag(0);
-	smp_cpu_start(1, psw);
+	smp_cpu_start(1, PSW_WITH_CUR_MASK(test_func_initial));
 	wait_for_flag();
 
 	smp_sigp(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
@@ -525,22 +503,16 @@ static void test_local_ints(void)
 
 static void test_reset(void)
 {
-	struct psw psw;
-
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func;
-
 	report_prefix_push("cpu reset");
 	smp_sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
 	smp_sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
-	smp_cpu_start(1, psw);
+	smp_cpu_start(1, PSW_WITH_CUR_MASK(test_func));
 
 	smp_sigp(1, SIGP_CPU_RESET, 0, NULL);
 	report(smp_cpu_stopped(1), "cpu stopped");
 
 	set_flag(0);
-	psw.addr = (unsigned long)test_local_ints;
-	smp_cpu_start(1, psw);
+	smp_cpu_start(1, PSW_WITH_CUR_MASK(test_local_ints));
 	wait_for_flag();
 	report_pass("local interrupts cleared");
 	report_prefix_pop();
@@ -548,7 +520,6 @@ static void test_reset(void)
 
 int main(void)
 {
-	struct psw psw;
 	report_prefix_push("smp");
 
 	if (smp_query_num_cpus() == 1) {
@@ -557,9 +528,7 @@ int main(void)
 	}
 
 	/* Setting up the cpu to give it a stack and lowcore */
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func;
-	smp_cpu_setup(1, psw);
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(test_func));
 	smp_cpu_stop(1);
 
 	test_start();
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 9f09f80e..33e6eec6 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -501,7 +501,6 @@ static void test_init(void)
 {
 	int rc;
 	uint64_t mem;
-	struct psw psw;
 
 	/* Donated storage needs to be over 2GB */
 	mem = (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
@@ -547,9 +546,7 @@ static void test_init(void)
 	       "storage below 2GB");
 	uvcb_init.stor_origin = mem;
 
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)cpu_loop;
-	smp_cpu_setup(1, psw);
+	smp_cpu_setup(1, PSW_WITH_CUR_MASK(cpu_loop));
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 1 && uvcb_init.header.rc == 0x102,
 	       "too many running cpus");
-- 
2.38.1

