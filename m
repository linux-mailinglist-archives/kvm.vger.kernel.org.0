Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE59819BFC8
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 13:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387985AbgDBLC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 07:02:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387722AbgDBLC5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 07:02:57 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 032B2TLT057832
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 07:02:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 301yfhsg06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 07:02:56 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 032B2ZWq058545
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 07:02:55 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 301yfhsfyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Apr 2020 07:02:55 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 032B0raH003840;
        Thu, 2 Apr 2020 11:02:54 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 301x77tbqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Apr 2020 11:02:54 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 032B2qiM14287446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 11:02:52 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7619C6A057;
        Thu,  2 Apr 2020 11:02:52 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE23B6A051;
        Thu,  2 Apr 2020 11:02:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 11:02:51 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [kvm-unit-tests v2] s390x/smp: add minimal test for sigp sense running status
Date:   Thu,  2 Apr 2020 07:02:50 -0400
Message-Id: <20200402110250.63677-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_01:2020-03-31,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=983 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

make sure that sigp sense running status returns a sane value for
stopped CPUs. To avoid potential races with the stop being processed we
wait until sense running status is first 0.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 lib/s390x/smp.c |  2 +-
 lib/s390x/smp.h |  2 +-
 s390x/smp.c     | 13 +++++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 5ed8b7b..492cb05 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -58,7 +58,7 @@ bool smp_cpu_stopped(uint16_t addr)
 	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
 }
 
-bool smp_cpu_running(uint16_t addr)
+bool smp_sense_running_status(uint16_t addr)
 {
 	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
 		return true;
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index a8b98c0..639ec92 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -40,7 +40,7 @@ struct cpu_status {
 int smp_query_num_cpus(void);
 struct cpu *smp_cpu_from_addr(uint16_t addr);
 bool smp_cpu_stopped(uint16_t addr);
-bool smp_cpu_running(uint16_t addr);
+bool smp_sense_running_status(uint16_t addr);
 int smp_cpu_restart(uint16_t addr);
 int smp_cpu_start(uint16_t addr, struct psw psw);
 int smp_cpu_stop(uint16_t addr);
diff --git a/s390x/smp.c b/s390x/smp.c
index 79cdc1f..b4b1ff2 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -210,6 +210,18 @@ static void test_emcall(void)
 	report_prefix_pop();
 }
 
+static void test_sense_running(void)
+{
+	report_prefix_push("sense_running");
+	/* make sure CPU is stopped */
+	smp_cpu_stop(1);
+	/* wait for stop to succeed. */
+	while(smp_sense_running_status(1));
+	report(!smp_sense_running_status(1), "CPU1 sense claims not running");
+	report_prefix_pop();
+}
+
+
 /* Used to dirty registers of cpu #1 before it is reset */
 static void test_func_initial(void)
 {
@@ -319,6 +331,7 @@ int main(void)
 	test_store_status();
 	test_ecall();
 	test_emcall();
+	test_sense_running();
 	test_reset();
 	test_reset_initial();
 	smp_cpu_destroy(1);
-- 
2.25.1

