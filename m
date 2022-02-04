Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD584A99B5
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 14:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348080AbiBDNJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 08:09:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245574AbiBDNJF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 08:09:05 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214BO23I006592
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jS/F51NfnRLW5sTIWoaNtv2/LnQFx3oTKOAZDLA1lck=;
 b=NvI0Rcs3qqkKKgi2a3fPZf5V4enqCEOHeQATpmFDs/4azL31s+HO3bDIW0PoRahy+K1u
 cBhAAnDzRKwoWwcfGQOay32n5nrFWRf2l8pY506iO1Te1fSKAUZoHY6OeYFX6fPc2mwf
 0Hif9IVtwUNichIZ51xw8HKDO1O7AIwN3wzPjn8YIgkld64y0+E4bxwsIjnMc7z9SC20
 +cD7SOhn6fB3slk6AaB0rlFa7uNtEdg48fWIbH8foYV7Yq0awTMovEXE8wclBU4T5YaR
 TkKQRjAFxpP9ZQcB5yiNC3Z6PnxAWbzy5CMBmvj85TeF1lV/Iq4RZasCiMA1cH4xfHyX DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx0n24k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:09:05 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214CTLIY000794
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx0n241-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214D7LCj018234;
        Fri, 4 Feb 2022 13:09:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3e0r0u50u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214D8wlS41484716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 13:08:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85CDE4C063;
        Fri,  4 Feb 2022 13:08:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20B0B4C040;
        Fri,  4 Feb 2022 13:08:58 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 13:08:58 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/6] s390x: smp: use CPU indexes instead of addresses
Date:   Fri,  4 Feb 2022 14:08:52 +0100
Message-Id: <20220204130855.39520-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204130855.39520-1-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IebGomkrKCNX086_auhc9slMSEzVqWdk
X-Proofpoint-ORIG-GUID: o56k_xkgAhl_xIqaIscG3zMWMDfyKaj6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_04,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adapt the test to the new semantics of the smp_* functions, and use CPU
indexes instead of addresses.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

