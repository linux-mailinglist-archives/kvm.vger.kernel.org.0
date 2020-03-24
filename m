Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95053190743
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 09:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgCXINV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 04:13:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727231AbgCXINQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 04:13:16 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O84B2B022323
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:15 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yxw7d1q07-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:15 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 24 Mar 2020 08:13:11 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 08:13:10 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02O8DAxX13042102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 08:13:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAD5EA405B;
        Tue, 24 Mar 2020 08:13:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF72EA4054;
        Tue, 24 Mar 2020 08:13:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 08:13:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com
Subject: [kvm-unit-tests PATCH 08/10] s390x: smp: Wait for sigp completion
Date:   Tue, 24 Mar 2020 04:12:49 -0400
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324081251.28810-1-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032408-0016-0000-0000-000002F6B850
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032408-0017-0000-0000-0000335A5507
Message-Id: <20200324081251.28810-9-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_01:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=1 bulkscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240039
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sigp orders are not necessarily finished when the processor finished
the sigp instruction. We need to poll if the order has been finished
before we continue.

For (re)start and stop we already use sigp sense running and sigp
sense loops. But we still lack completion checks for stop and store
status, as well as the cpu resets.

Let's add them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/smp.c | 8 ++++++++
 lib/s390x/smp.h | 1 +
 s390x/smp.c     | 4 ++++
 3 files changed, 13 insertions(+)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 6ef0335954fd4832..2555bf4f5e73d762 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -154,6 +154,14 @@ int smp_cpu_start(uint16_t addr, struct psw psw)
 	return rc;
 }
 
+void smp_cpu_wait_for_completion(uint16_t addr)
+{
+	uint32_t status;
+
+	/* Loops when cc == 2, i.e. when the cpu is busy with a sigp order */
+	sigp_retry(1, SIGP_SENSE, 0, &status);
+}
+
 int smp_cpu_destroy(uint16_t addr)
 {
 	struct cpu *cpu;
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index ce63a89880c045f3..a8b98c0fcf2b451c 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -45,6 +45,7 @@ int smp_cpu_restart(uint16_t addr);
 int smp_cpu_start(uint16_t addr, struct psw psw);
 int smp_cpu_stop(uint16_t addr);
 int smp_cpu_stop_store_status(uint16_t addr);
+void smp_cpu_wait_for_completion(uint16_t addr);
 int smp_cpu_destroy(uint16_t addr);
 int smp_cpu_setup(uint16_t addr, struct psw psw);
 void smp_teardown(void);
diff --git a/s390x/smp.c b/s390x/smp.c
index 74622113a2c4ad92..48321f4e346dc71d 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -75,6 +75,7 @@ static void test_stop_store_status(void)
 	lc->prefix_sa = 0;
 	lc->grs_sa[15] = 0;
 	smp_cpu_stop_store_status(1);
+	smp_cpu_wait_for_completion(1);
 	mb();
 	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
 	report(lc->grs_sa[15], "stack");
@@ -85,6 +86,7 @@ static void test_stop_store_status(void)
 	lc->prefix_sa = 0;
 	lc->grs_sa[15] = 0;
 	smp_cpu_stop_store_status(1);
+	smp_cpu_wait_for_completion(1);
 	mb();
 	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
 	report(lc->grs_sa[15], "stack");
@@ -215,6 +217,7 @@ static void test_reset_initial(void)
 	wait_for_flag();
 
 	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
+	smp_cpu_wait_for_completion(1);
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 
 	report_prefix_push("clear");
@@ -264,6 +267,7 @@ static void test_reset(void)
 	smp_cpu_start(1, psw);
 
 	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
+	smp_cpu_wait_for_completion(1);
 	report(smp_cpu_stopped(1), "cpu stopped");
 
 	set_flag(0);
-- 
2.25.1

