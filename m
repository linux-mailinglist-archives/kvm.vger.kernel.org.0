Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDC64A007C
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 19:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350712AbiA1SzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 13:55:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230165AbiA1Sy5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 13:54:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20SI8xHa016527
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NzJpwTyyUVzkIrcThbWkaOwDmw1HXIpz0tRGoXHg2Xw=;
 b=J+MPYK3PO4nyfd14CR+Bs1y4p5uIcjQRs/FcuvOkcIL736Dx7/CPLp73F3oQjthz5+RM
 tUynifLvnFL4O5E22ttgLwjfuA9z1jG6iShX1G8xxS4dtpyz+UF5EqvFBt7PZ/4fYEht
 JJlKeuf3NG50nkL1EWxLVx5Pp+5xy2zblDnC8jMWwWRIB+4PF//ZyKEwfY/jf20BqORq
 fvKZJj/t3TIbV7Zw8vObtXG95ji4vdhhusfs6iN9Vd7ohIJubyC4a8B3IbxmWHg1JH59
 DC5K3cKIfImccb8+xmDtT0aLulcPkghbSCX/NbYg87fH7AnUDmsyMAEh2Sfi+r1ZTbsI Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvmpthrkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20SISUU0012200
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvmpthrju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:57 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20SIqB7Y006899;
        Fri, 28 Jan 2022 18:54:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9ja45q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20SIspfO20382028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 18:54:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAD95A4064;
        Fri, 28 Jan 2022 18:54:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 481D1A406B;
        Fri, 28 Jan 2022 18:54:51 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.7.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 18:54:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 3/5] s390x: smp: avoid hardcoded CPU addresses
Date:   Fri, 28 Jan 2022 19:54:47 +0100
Message-Id: <20220128185449.64936-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128185449.64936-1-imbrenda@linux.ibm.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xS_9zS0amJNAJxElZy0PqZfh2wLVLpap
X-Proofpoint-GUID: BT_I8FRLoPeQhPOJggbE4Tte1hgy-imX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_06,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced functions to work with CPU indexes, instead of
using hardcoded values. This makes the test more portable.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 83 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 39 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 1bbe4c31..da668ca6 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -18,6 +18,7 @@
 #include <smp.h>
 #include <alloc_page.h>
 
+static uint16_t cpu0, cpu1;
 static int testflag = 0;
 
 static void wait_for_flag(void)
@@ -45,7 +46,7 @@ static void test_start(void)
 	psw.addr = (unsigned long)test_func;
 
 	set_flag(0);
-	smp_cpu_start(1, psw);
+	smp_cpu_start(cpu1, psw);
 	wait_for_flag();
 	report_pass("start");
 }
@@ -56,16 +57,16 @@ static void test_start(void)
  */
 static void test_restart(void)
 {
-	struct cpu *cpu = smp_cpu_from_addr(1);
+	struct cpu *cpu = smp_cpu_from_idx(1);
 	struct lowcore *lc = cpu->lowcore;
 
 	lc->restart_new_psw.mask = extract_psw_mask();
 	lc->restart_new_psw.addr = (unsigned long)test_func;
 
 	/* Make sure cpu is running */
-	smp_cpu_stop(0);
+	smp_cpu_stop(cpu0);
 	set_flag(0);
-	smp_cpu_restart(1);
+	smp_cpu_restart(cpu1);
 	wait_for_flag();
 
 	/*
@@ -73,44 +74,44 @@ static void test_restart(void)
 	 * restart function.
 	 */
 	set_flag(0);
-	smp_cpu_restart(1);
+	smp_cpu_restart(cpu1);
 	wait_for_flag();
 	report_pass("restart while running");
 }
 
 static void test_stop(void)
 {
-	smp_cpu_stop(1);
+	smp_cpu_stop(cpu1);
 	/*
 	 * The smp library waits for the CPU to shut down, but let's
 	 * also do it here, so we don't rely on the library
 	 * implementation
 	 */
-	while (!smp_cpu_stopped(1)) {}
+	while (!smp_cpu_stopped(cpu1)) {}
 	report_pass("stop");
 }
 
 static void test_stop_store_status(void)
 {
-	struct cpu *cpu = smp_cpu_from_addr(1);
+	struct cpu *cpu = smp_cpu_from_idx(1);
 	struct lowcore *lc = (void *)0x0;
 
 	report_prefix_push("stop store status");
 	report_prefix_push("running");
-	smp_cpu_restart(1);
+	smp_cpu_restart(cpu1);
 	lc->prefix_sa = 0;
 	lc->grs_sa[15] = 0;
-	smp_cpu_stop_store_status(1);
+	smp_cpu_stop_store_status(cpu1);
 	mb();
 	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
 	report(lc->grs_sa[15], "stack");
-	report(smp_cpu_stopped(1), "cpu stopped");
+	report(smp_cpu_stopped(cpu1), "cpu stopped");
 	report_prefix_pop();
 
 	report_prefix_push("stopped");
 	lc->prefix_sa = 0;
 	lc->grs_sa[15] = 0;
-	smp_cpu_stop_store_status(1);
+	smp_cpu_stop_store_status(cpu1);
 	mb();
 	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
 	report(lc->grs_sa[15], "stack");
@@ -128,8 +129,8 @@ static void test_store_status(void)
 	memset(status, 0, PAGE_SIZE * 2);
 
 	report_prefix_push("running");
-	smp_cpu_restart(1);
-	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
+	smp_cpu_restart(cpu1);
+	sigp(cpu1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
 	report(r == SIGP_STATUS_INCORRECT_STATE, "incorrect state");
 	report(!memcmp(status, (void *)status + PAGE_SIZE, PAGE_SIZE),
 	       "status not written");
@@ -137,13 +138,13 @@ static void test_store_status(void)
 
 	memset(status, 0, PAGE_SIZE);
 	report_prefix_push("stopped");
-	smp_cpu_stop(1);
-	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
+	smp_cpu_stop(cpu1);
+	sigp(cpu1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 	while (!status->prefix) { mb(); }
 	report_pass("status written");
 	free_pages(status);
 	report_prefix_pop();
-	smp_cpu_stop(1);
+	smp_cpu_stop(cpu1);
 
 	report_prefix_pop();
 }
@@ -173,12 +174,12 @@ static void test_ecall(void)
 	report_prefix_push("ecall");
 	set_flag(0);
 
-	smp_cpu_start(1, psw);
+	smp_cpu_start(cpu1, psw);
 	wait_for_flag();
 	set_flag(0);
-	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
+	sigp(cpu1, SIGP_EXTERNAL_CALL, 0, NULL);
 	wait_for_flag();
-	smp_cpu_stop(1);
+	smp_cpu_stop(cpu1);
 	report_prefix_pop();
 }
 
@@ -207,12 +208,12 @@ static void test_emcall(void)
 	report_prefix_push("emcall");
 	set_flag(0);
 
-	smp_cpu_start(1, psw);
+	smp_cpu_start(cpu1, psw);
 	wait_for_flag();
 	set_flag(0);
-	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	sigp(cpu1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
 	wait_for_flag();
-	smp_cpu_stop(1);
+	smp_cpu_stop(cpu1);
 	report_prefix_pop();
 }
 
@@ -220,11 +221,11 @@ static void test_sense_running(void)
 {
 	report_prefix_push("sense_running");
 	/* we (CPU0) are running */
-	report(smp_sense_running_status(0), "CPU0 sense claims running");
+	report(smp_sense_running_status(cpu0), "CPU0 sense claims running");
 	/* stop the target CPU (CPU1) to speed up the not running case */
-	smp_cpu_stop(1);
+	smp_cpu_stop(cpu1);
 	/* Make sure to have at least one time with a not running indication */
-	while(smp_sense_running_status(1));
+	while(smp_sense_running_status(cpu1));
 	report_pass("CPU1 sense claims not running");
 	report_prefix_pop();
 }
@@ -250,11 +251,11 @@ static void test_reset_initial(void)
 
 	report_prefix_push("reset initial");
 	set_flag(0);
-	smp_cpu_start(1, psw);
+	smp_cpu_start(cpu1, psw);
 	wait_for_flag();
 
-	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
-	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
+	sigp_retry(cpu1, SIGP_INITIAL_CPU_RESET, 0, NULL);
+	sigp(cpu1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 
 	report_prefix_push("clear");
 	report(!status->psw.mask && !status->psw.addr, "psw");
@@ -273,7 +274,7 @@ static void test_reset_initial(void)
 	report(status->crs[14] == 0xC2000000UL, "cr14 == 0xC2000000");
 	report_prefix_pop();
 
-	report(smp_cpu_stopped(1), "cpu stopped");
+	report(smp_cpu_stopped(cpu1), "cpu stopped");
 	free_pages(status);
 	report_prefix_pop();
 }
@@ -299,16 +300,16 @@ static void test_reset(void)
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("cpu reset");
-	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
-	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
-	smp_cpu_start(1, psw);
+	sigp(cpu1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	sigp(cpu1, SIGP_EXTERNAL_CALL, 0, NULL);
+	smp_cpu_start(cpu1, psw);
 
-	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
-	report(smp_cpu_stopped(1), "cpu stopped");
+	sigp_retry(cpu1, SIGP_CPU_RESET, 0, NULL);
+	report(smp_cpu_stopped(cpu1), "cpu stopped");
 
 	set_flag(0);
 	psw.addr = (unsigned long)test_local_ints;
-	smp_cpu_start(1, psw);
+	smp_cpu_start(cpu1, psw);
 	wait_for_flag();
 	report_pass("local interrupts cleared");
 	report_prefix_pop();
@@ -324,11 +325,15 @@ int main(void)
 		goto done;
 	}
 
+	/* the boot CPU is guaranteed to have index 0 */
+	cpu0 = stap();
+	cpu1 = smp_cpu_addr_from_idx(1);
+
 	/* Setting up the cpu to give it a stack and lowcore */
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)test_func;
-	smp_cpu_setup(1, psw);
-	smp_cpu_stop(1);
+	smp_cpu_setup(cpu1, psw);
+	smp_cpu_stop(cpu1);
 
 	test_start();
 	test_restart();
@@ -340,7 +345,7 @@ int main(void)
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-	smp_cpu_destroy(1);
+	smp_cpu_destroy(cpu1);
 
 done:
 	report_prefix_pop();
-- 
2.34.1

