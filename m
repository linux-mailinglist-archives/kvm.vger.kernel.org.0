Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52E04BA316
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbiBQOfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:35:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241933AbiBQOfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:35:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578BE2B1A8E
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:35:22 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HEGaRt023473
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D0kLpwppa585ALDXUGSt2aReOSPp4bJ8eiaWAl5R0Mk=;
 b=fgh+PZh2KTBVxcOi5j40BMfFNOoK0Za09BFGPXYY/qk4BfWUJaI03u6qt6wbnaStpu6f
 PCnS4CLBOkVCbNry05uyNwN7fCtEa6whSTnX4p8EiFVh6dDfW99Q9c7HTbLxyuBG4ov2
 C6wVhggra8WR2zQdVyVkidHiB4huOqn1G/CooicEVCS1VyY/qVmZMGRN2uCP9bp+NB0J
 rhNxJuSFRRvSveI3ME3B5xhJbC58CiR35n6EC4uL0i+0dzDJrxBb+0Oi+sTDNr1wW/GI
 gdojYoeXIA1K8v1vdyIg/v681BnBszUfAlGaG9xY8VPVAf72GiNE/eh4NHptzxEmj3/g Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9r00gev6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:21 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HEHJJd025451
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9r00geu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEXIGU022246;
        Thu, 17 Feb 2022 14:35:19 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3e64hah58e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEZGFI45351324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:35:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6DD74204B;
        Thu, 17 Feb 2022 14:35:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8592D4204C;
        Thu, 17 Feb 2022 14:35:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:35:15 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 6/9] s390x: smp: use CPU indexes instead of addresses
Date:   Thu, 17 Feb 2022 15:35:01 +0100
Message-Id: <20220217143504.232688-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217143504.232688-1-imbrenda@linux.ibm.com>
References: <20220217143504.232688-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ML1CxLd4YlITojv8GYhxZlyrO3cnHGae
X-Proofpoint-ORIG-GUID: hqAcyEoFmOhNtRxJK4F2LPG2WIoHulai
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Adapt the test to the new semantics of the smp_* functions, and use CPU
indexes instead of addresses.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/smp.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 1bbe4c31..068ac74d 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -56,7 +56,7 @@ static void test_start(void)
  */
 static void test_restart(void)
 {
-	struct cpu *cpu = smp_cpu_from_addr(1);
+	struct cpu *cpu = smp_cpu_from_idx(1);
 	struct lowcore *lc = cpu->lowcore;
 
 	lc->restart_new_psw.mask = extract_psw_mask();
@@ -92,7 +92,7 @@ static void test_stop(void)
 
 static void test_stop_store_status(void)
 {
-	struct cpu *cpu = smp_cpu_from_addr(1);
+	struct cpu *cpu = smp_cpu_from_idx(1);
 	struct lowcore *lc = (void *)0x0;
 
 	report_prefix_push("stop store status");
@@ -129,7 +129,7 @@ static void test_store_status(void)
 
 	report_prefix_push("running");
 	smp_cpu_restart(1);
-	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
+	smp_sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
 	report(r == SIGP_STATUS_INCORRECT_STATE, "incorrect state");
 	report(!memcmp(status, (void *)status + PAGE_SIZE, PAGE_SIZE),
 	       "status not written");
@@ -138,7 +138,7 @@ static void test_store_status(void)
 	memset(status, 0, PAGE_SIZE);
 	report_prefix_push("stopped");
 	smp_cpu_stop(1);
-	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
+	smp_sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 	while (!status->prefix) { mb(); }
 	report_pass("status written");
 	free_pages(status);
@@ -176,7 +176,7 @@ static void test_ecall(void)
 	smp_cpu_start(1, psw);
 	wait_for_flag();
 	set_flag(0);
-	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
+	smp_sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
 	wait_for_flag();
 	smp_cpu_stop(1);
 	report_prefix_pop();
@@ -210,7 +210,7 @@ static void test_emcall(void)
 	smp_cpu_start(1, psw);
 	wait_for_flag();
 	set_flag(0);
-	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	smp_sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
 	wait_for_flag();
 	smp_cpu_stop(1);
 	report_prefix_pop();
@@ -253,8 +253,8 @@ static void test_reset_initial(void)
 	smp_cpu_start(1, psw);
 	wait_for_flag();
 
-	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
-	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
+	smp_sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
+	smp_sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 
 	report_prefix_push("clear");
 	report(!status->psw.mask && !status->psw.addr, "psw");
@@ -299,11 +299,11 @@ static void test_reset(void)
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("cpu reset");
-	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
-	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
+	smp_sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	smp_sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
 	smp_cpu_start(1, psw);
 
-	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
+	smp_sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
 	report(smp_cpu_stopped(1), "cpu stopped");
 
 	set_flag(0);
-- 
2.34.1

