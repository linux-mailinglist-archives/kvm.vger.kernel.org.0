Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8802A1BE13E
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 16:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgD2Ofi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 10:35:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727119AbgD2Ofh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 10:35:37 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TEVwFV003209;
        Wed, 29 Apr 2020 10:35:37 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhfhjg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 10:35:37 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03TEWBHQ004427;
        Wed, 29 Apr 2020 10:35:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhfhjes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 10:35:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TEUWY9009583;
        Wed, 29 Apr 2020 14:35:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5rks7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 14:35:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TEZWbC2294024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:35:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25A394C059;
        Wed, 29 Apr 2020 14:35:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 763464C052;
        Wed, 29 Apr 2020 14:35:31 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 14:35:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com
Subject: [PATCH v3 08/10] s390x: smp: Wait for sigp completion
Date:   Wed, 29 Apr 2020 10:35:16 -0400
Message-Id: <20200429143518.1360468-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200429143518.1360468-1-frankja@linux.ibm.com>
References: <20200429143518.1360468-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_05:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290117
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

KVM currently needs a workaround for the stop and store status test,
since KVM's SIGP Sense implementation doesn't honor pending SIGPs at
it should. Hopefully we can fix that in the future.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/smp.c |  9 +++++++++
 lib/s390x/smp.h |  1 +
 s390x/smp.c     | 12 ++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 6ef0335..8628a3d 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -49,6 +49,14 @@ struct cpu *smp_cpu_from_addr(uint16_t addr)
 	return NULL;
 }
 
+void smp_cpu_wait_for_completion(uint16_t addr)
+{
+	uint32_t status;
+
+	/* Loops when cc == 2, i.e. when the cpu is busy with a sigp order */
+	sigp_retry(1, SIGP_SENSE, 0, &status);
+}
+
 bool smp_cpu_stopped(uint16_t addr)
 {
 	uint32_t status;
@@ -100,6 +108,7 @@ int smp_cpu_stop_store_status(uint16_t addr)
 
 	spin_lock(&lock);
 	rc = smp_cpu_stop_nolock(addr, true);
+	smp_cpu_wait_for_completion(addr);
 	spin_unlock(&lock);
 	return rc;
 }
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index ce63a89..a8b98c0 100644
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
index c7ff0ee..bad2131 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -75,7 +75,12 @@ static void test_stop_store_status(void)
 	lc->prefix_sa = 0;
 	lc->grs_sa[15] = 0;
 	smp_cpu_stop_store_status(1);
-	mb();
+	/*
+	 * This loop is workaround for KVM not reporting cc 2 for SIGP
+	 * sense if a stop and store status is pending.
+	 */
+	while (!lc->prefix_sa)
+		mb();
 	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
 	report(lc->grs_sa[15], "stack");
 	report(smp_cpu_stopped(1), "cpu stopped");
@@ -85,7 +90,8 @@ static void test_stop_store_status(void)
 	lc->prefix_sa = 0;
 	lc->grs_sa[15] = 0;
 	smp_cpu_stop_store_status(1);
-	mb();
+	while (!lc->prefix_sa)
+		mb();
 	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
 	report(lc->grs_sa[15], "stack");
 	report_prefix_pop();
@@ -215,6 +221,7 @@ static void test_reset_initial(void)
 	wait_for_flag();
 
 	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
+	smp_cpu_wait_for_completion(1);
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 
 	report_prefix_push("clear");
@@ -265,6 +272,7 @@ static void test_reset(void)
 	smp_cpu_start(1, psw);
 
 	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
+	smp_cpu_wait_for_completion(1);
 	report(smp_cpu_stopped(1), "cpu stopped");
 
 	set_flag(0);
-- 
2.25.1

