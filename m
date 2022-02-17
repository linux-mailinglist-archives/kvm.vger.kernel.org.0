Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A7C4BA30F
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241991AbiBQOgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:36:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiBQOfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:35:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B7C2B1A82
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:35:22 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HE4hYj019669
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+Me/4xcwyCa8P0pwx7Kk1otN55O1fwO5EyuRyYW7rTQ=;
 b=cdTzWRn43H7vqgNupYxnhtXZAJdpdPF2I+/bjpDtPRpJhg5iDoWXMAIoVn2b82wx298v
 Wg1OA1/Of5NRE2VUs+CAl7IkYyp5xFVrSQIL8Jj8moOYIb1Pv7BT2klVT87QtflErgP1
 r8KwmyXF/1cZdjvgJIKWPzha/Q8wiRPY34A8N166Hg7pnXzuYwTRa0aFSmRVv+UMe9k+
 5w40J4xLnjHDbg4N6OuK906Vy0BF7MbTm3TtzKMGs22LD/yCBCa7Ej30Gpb2phWU7E+S
 xSLYF5Wql1EhGIF/dveDTWluHC9sTfX5PnLdSTiyvYD2nz9rgXpkgKGVtHm7fhO88ICy yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9hdc0xm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:21 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HEL5kV027704
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:20 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9hdc0xk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:20 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEW3fh003073;
        Thu, 17 Feb 2022 14:35:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3e64ha94jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEZFpo44761408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:35:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67CE242052;
        Thu, 17 Feb 2022 14:35:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ECCC4204C;
        Thu, 17 Feb 2022 14:35:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:35:14 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Steffen Eiden <seiden@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 5/9] lib: s390x: smp: refactor smp functions to accept indexes
Date:   Thu, 17 Feb 2022 15:35:00 +0100
Message-Id: <20220217143504.232688-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217143504.232688-1-imbrenda@linux.ibm.com>
References: <20220217143504.232688-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m4UtfEbDQpa0B6LJPLfJ4fZzIET7kfO8
X-Proofpoint-ORIG-GUID: Vpk3WUPaAYfLGLEQ62ZWWj7CgXaJGbyf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor all the smp_* functions to accept CPU indexes instead of CPU
addresses.

Add SIGP wrappers to use indexes instead of addresses. Raw SIGP calls
using addresses are still possible. Some of the reworked functions
also use the new wrappers internally, for clarity, even though that
will cause unnecessary redundant checks on the validity of the CPU
index.

Add a few other useful functions to deal with CPU indexes.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/smp.h |  20 ++++---
 lib/s390x/smp.c | 148 ++++++++++++++++++++++++++++--------------------
 2 files changed, 99 insertions(+), 69 deletions(-)

diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index a2609f11..1e69a7de 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -37,15 +37,19 @@ struct cpu_status {
 
 int smp_query_num_cpus(void);
 struct cpu *smp_cpu_from_addr(uint16_t addr);
-bool smp_cpu_stopped(uint16_t addr);
-bool smp_sense_running_status(uint16_t addr);
-int smp_cpu_restart(uint16_t addr);
-int smp_cpu_start(uint16_t addr, struct psw psw);
-int smp_cpu_stop(uint16_t addr);
-int smp_cpu_stop_store_status(uint16_t addr);
-int smp_cpu_destroy(uint16_t addr);
-int smp_cpu_setup(uint16_t addr, struct psw psw);
+struct cpu *smp_cpu_from_idx(uint16_t idx);
+uint16_t smp_cpu_addr(uint16_t idx);
+bool smp_cpu_stopped(uint16_t idx);
+bool smp_sense_running_status(uint16_t idx);
+int smp_cpu_restart(uint16_t idx);
+int smp_cpu_start(uint16_t idx, struct psw psw);
+int smp_cpu_stop(uint16_t idx);
+int smp_cpu_stop_store_status(uint16_t idx);
+int smp_cpu_destroy(uint16_t idx);
+int smp_cpu_setup(uint16_t idx, struct psw psw);
 void smp_teardown(void);
 void smp_setup(void);
+int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status);
+int smp_sigp_retry(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status);
 
 #endif
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index eae742d2..46e1b022 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -29,11 +29,28 @@ static struct spinlock lock;
 
 extern void smp_cpu_setup_state(void);
 
+static void check_idx(uint16_t idx)
+{
+	assert(idx < smp_query_num_cpus());
+}
+
 int smp_query_num_cpus(void)
 {
 	return sclp_get_cpu_num();
 }
 
+int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
+{
+	check_idx(idx);
+	return sigp(cpus[idx].addr, order, parm, status);
+}
+
+int smp_sigp_retry(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
+{
+	check_idx(idx);
+	return sigp_retry(cpus[idx].addr, order, parm, status);
+}
+
 struct cpu *smp_cpu_from_addr(uint16_t addr)
 {
 	int i, num = smp_query_num_cpus();
@@ -45,174 +62,183 @@ struct cpu *smp_cpu_from_addr(uint16_t addr)
 	return NULL;
 }
 
-bool smp_cpu_stopped(uint16_t addr)
+struct cpu *smp_cpu_from_idx(uint16_t idx)
+{
+	check_idx(idx);
+	return &cpus[idx];
+}
+
+uint16_t smp_cpu_addr(uint16_t idx)
+{
+	check_idx(idx);
+	return cpus[idx].addr;
+}
+
+bool smp_cpu_stopped(uint16_t idx)
 {
 	uint32_t status;
 
-	if (sigp(addr, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
+	if (smp_sigp(idx, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
 		return false;
 	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
 }
 
-bool smp_sense_running_status(uint16_t addr)
+bool smp_sense_running_status(uint16_t idx)
 {
-	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
+	if (smp_sigp(idx, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
 		return true;
 	/* Status stored condition code is equivalent to cpu not running. */
 	return false;
 }
 
-static int smp_cpu_stop_nolock(uint16_t addr, bool store)
+static int smp_cpu_stop_nolock(uint16_t idx, bool store)
 {
-	struct cpu *cpu;
 	uint8_t order = store ? SIGP_STOP_AND_STORE_STATUS : SIGP_STOP;
 
-	cpu = smp_cpu_from_addr(addr);
-	if (!cpu || addr == cpus[0].addr)
+	/* refuse to work on the boot CPU */
+	if (idx == 0)
 		return -1;
 
-	if (sigp_retry(addr, order, 0, NULL))
+	if (smp_sigp_retry(idx, order, 0, NULL))
 		return -1;
 
-	while (!smp_cpu_stopped(addr))
+	while (!smp_cpu_stopped(idx))
 		mb();
-	cpu->active = false;
+	/* idx has been already checked by the smp_* functions called above */
+	cpus[idx].active = false;
 	return 0;
 }
 
-int smp_cpu_stop(uint16_t addr)
+int smp_cpu_stop(uint16_t idx)
 {
 	int rc;
 
 	spin_lock(&lock);
-	rc = smp_cpu_stop_nolock(addr, false);
+	rc = smp_cpu_stop_nolock(idx, false);
 	spin_unlock(&lock);
 	return rc;
 }
 
-int smp_cpu_stop_store_status(uint16_t addr)
+int smp_cpu_stop_store_status(uint16_t idx)
 {
 	int rc;
 
 	spin_lock(&lock);
-	rc = smp_cpu_stop_nolock(addr, true);
+	rc = smp_cpu_stop_nolock(idx, true);
 	spin_unlock(&lock);
 	return rc;
 }
 
-static int smp_cpu_restart_nolock(uint16_t addr, struct psw *psw)
+static int smp_cpu_restart_nolock(uint16_t idx, struct psw *psw)
 {
 	int rc;
-	struct cpu *cpu = smp_cpu_from_addr(addr);
 
-	if (!cpu)
-		return -1;
+	check_idx(idx);
 	if (psw) {
-		cpu->lowcore->restart_new_psw.mask = psw->mask;
-		cpu->lowcore->restart_new_psw.addr = psw->addr;
+		cpus[idx].lowcore->restart_new_psw.mask = psw->mask;
+		cpus[idx].lowcore->restart_new_psw.addr = psw->addr;
 	}
 	/*
 	 * Stop the cpu, so we don't have a race between a running cpu
 	 * and the restart in the test that checks if the cpu is
 	 * running after the restart.
 	 */
-	smp_cpu_stop_nolock(addr, false);
-	rc = sigp(addr, SIGP_RESTART, 0, NULL);
+	smp_cpu_stop_nolock(idx, false);
+	rc = smp_sigp(idx, SIGP_RESTART, 0, NULL);
 	if (rc)
 		return rc;
 	/*
 	 * The order has been accepted, but the actual restart may not
 	 * have been performed yet, so wait until the cpu is running.
 	 */
-	while (smp_cpu_stopped(addr))
+	while (smp_cpu_stopped(idx))
 		mb();
-	cpu->active = true;
+	cpus[idx].active = true;
 	return 0;
 }
 
-int smp_cpu_restart(uint16_t addr)
+int smp_cpu_restart(uint16_t idx)
 {
 	int rc;
 
 	spin_lock(&lock);
-	rc = smp_cpu_restart_nolock(addr, NULL);
+	rc = smp_cpu_restart_nolock(idx, NULL);
 	spin_unlock(&lock);
 	return rc;
 }
 
-int smp_cpu_start(uint16_t addr, struct psw psw)
+int smp_cpu_start(uint16_t idx, struct psw psw)
 {
 	int rc;
 
 	spin_lock(&lock);
-	rc = smp_cpu_restart_nolock(addr, &psw);
+	rc = smp_cpu_restart_nolock(idx, &psw);
 	spin_unlock(&lock);
 	return rc;
 }
 
-int smp_cpu_destroy(uint16_t addr)
+int smp_cpu_destroy(uint16_t idx)
 {
-	struct cpu *cpu;
 	int rc;
 
 	spin_lock(&lock);
-	rc = smp_cpu_stop_nolock(addr, false);
+	rc = smp_cpu_stop_nolock(idx, false);
 	if (!rc) {
-		cpu = smp_cpu_from_addr(addr);
-		free_pages(cpu->lowcore);
-		free_pages(cpu->stack);
-		cpu->lowcore = (void *)-1UL;
-		cpu->stack = (void *)-1UL;
+		free_pages(cpus[idx].lowcore);
+		free_pages(cpus[idx].stack);
+		cpus[idx].lowcore = (void *)-1UL;
+		cpus[idx].stack = (void *)-1UL;
 	}
 	spin_unlock(&lock);
 	return rc;
 }
 
-int smp_cpu_setup(uint16_t addr, struct psw psw)
+static int smp_cpu_setup_nolock(uint16_t idx, struct psw psw)
 {
 	struct lowcore *lc;
-	struct cpu *cpu;
-	int rc = -1;
-
-	spin_lock(&lock);
-
-	if (!cpus)
-		goto out;
 
-	cpu = smp_cpu_from_addr(addr);
-
-	if (!cpu || cpu->active)
-		goto out;
+	if (cpus[idx].active)
+		return -1;
 
-	sigp_retry(cpu->addr, SIGP_INITIAL_CPU_RESET, 0, NULL);
+	smp_sigp_retry(idx, SIGP_INITIAL_CPU_RESET, 0, NULL);
 
 	lc = alloc_pages_flags(1, AREA_DMA31);
-	cpu->lowcore = lc;
-	memset(lc, 0, PAGE_SIZE * 2);
-	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
+	cpus[idx].lowcore = lc;
+	smp_sigp_retry(idx, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
 
 	/* Copy all exception psws. */
 	memcpy(lc, cpus[0].lowcore, 512);
 
 	/* Setup stack */
-	cpu->stack = (uint64_t *)alloc_pages(2);
+	cpus[idx].stack = (uint64_t *)alloc_pages(2);
 
 	/* Start without DAT and any other mask bits. */
-	cpu->lowcore->sw_int_psw.mask = psw.mask;
-	cpu->lowcore->sw_int_psw.addr = psw.addr;
-	cpu->lowcore->sw_int_grs[14] = psw.addr;
-	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack + (PAGE_SIZE * 4);
+	lc->sw_int_psw.mask = psw.mask;
+	lc->sw_int_psw.addr = psw.addr;
+	lc->sw_int_grs[14] = psw.addr;
+	lc->sw_int_grs[15] = (uint64_t)cpus[idx].stack + (PAGE_SIZE * 4);
 	lc->restart_new_psw.mask = PSW_MASK_64;
 	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
 	lc->sw_int_crs[0] = BIT_ULL(CTL0_AFP);
 
 	/* Start processing */
-	smp_cpu_restart_nolock(addr, NULL);
+	smp_cpu_restart_nolock(idx, NULL);
 	/* Wait until the cpu has finished setup and started the provided psw */
 	while (lc->restart_new_psw.addr != psw.addr)
 		mb();
-	rc = 0;
-out:
+
+	return 0;
+}
+
+int smp_cpu_setup(uint16_t idx, struct psw psw)
+{
+	int rc = -1;
+
+	spin_lock(&lock);
+	if (cpus) {
+		check_idx(idx);
+		rc = smp_cpu_setup_nolock(idx, psw);
+	}
 	spin_unlock(&lock);
 	return rc;
 }
-- 
2.34.1

