Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E9B14F87B
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 16:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgBAP3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 10:29:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726921AbgBAP3I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 Feb 2020 10:29:08 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 011FHXew136739
        for <kvm@vger.kernel.org>; Sat, 1 Feb 2020 10:29:07 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xw7quxcma-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2020 10:29:06 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Sat, 1 Feb 2020 15:29:05 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 1 Feb 2020 15:29:02 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 011FT1bE57999386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 1 Feb 2020 15:29:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7543D5204F;
        Sat,  1 Feb 2020 15:29:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.30.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B0EA45204E;
        Sat,  1 Feb 2020 15:29:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 5/7] s390x: smp: Only use smp_cpu_setup once
Date:   Sat,  1 Feb 2020 10:28:49 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200201152851.82867-1-frankja@linux.ibm.com>
References: <20200201152851.82867-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020115-4275-0000-0000-0000039D0ED5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020115-4276-0000-0000-000038B1311D
Message-Id: <20200201152851.82867-6-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-01_03:2020-01-31,2020-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002010113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's stop and start instead of using setup to run a function on a
cpu.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 s390x/smp.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 93a9594..fa40753 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -53,7 +53,7 @@ static void test_start(void)
 	psw.addr = (unsigned long)test_func;
 
 	set_flag(0);
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 	wait_for_flag();
 	report(1, "start");
 }
@@ -109,6 +109,7 @@ static void test_store_status(void)
 	report(1, "status written");
 	free_pages(status, PAGE_SIZE * 2);
 	report_prefix_pop();
+	smp_cpu_stop(1);
 
 	report_prefix_pop();
 }
@@ -137,9 +138,8 @@ static void test_ecall(void)
 
 	report_prefix_push("ecall");
 	set_flag(0);
-	smp_cpu_destroy(1);
 
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 	wait_for_flag();
 	set_flag(0);
 	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
@@ -172,9 +172,8 @@ static void test_emcall(void)
 
 	report_prefix_push("emcall");
 	set_flag(0);
-	smp_cpu_destroy(1);
 
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 	wait_for_flag();
 	set_flag(0);
 	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
@@ -192,7 +191,7 @@ static void test_reset_initial(void)
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("reset initial");
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 
 	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
@@ -223,7 +222,7 @@ static void test_reset(void)
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("cpu reset");
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 
 	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
 	report(smp_cpu_stopped(1), "cpu stopped");
@@ -232,6 +231,7 @@ static void test_reset(void)
 
 int main(void)
 {
+	struct psw psw;
 	report_prefix_push("smp");
 
 	if (smp_query_num_cpus() == 1) {
@@ -239,6 +239,12 @@ int main(void)
 		goto done;
 	}
 
+	/* Setting up the cpu to give it a stack and lowcore */
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)cpu_loop;
+	smp_cpu_setup(1, psw);
+	smp_cpu_stop(1);
+
 	test_start();
 	test_stop();
 	test_stop_store_status();
@@ -247,6 +253,7 @@ int main(void)
 	test_emcall();
 	test_reset();
 	test_reset_initial();
+	smp_cpu_destroy(1);
 
 done:
 	report_prefix_pop();
-- 
2.20.1

