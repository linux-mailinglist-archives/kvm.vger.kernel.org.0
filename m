Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8095B19C638
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 17:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389523AbgDBPos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 11:44:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389458AbgDBPor (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 11:44:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 032FX088088767
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 11:44:47 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3022r1jfdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 11:44:46 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 032FYfxl094256
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 11:44:46 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3022r1jfd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Apr 2020 11:44:46 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 032FZvkA008225;
        Thu, 2 Apr 2020 15:44:45 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 301x784exw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Apr 2020 15:44:45 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 032Fii7859572618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 15:44:44 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 095066A04D;
        Thu,  2 Apr 2020 15:44:44 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 738A56A047;
        Thu,  2 Apr 2020 15:44:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 15:44:43 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [kvm-unit-tests v3] s390x/smp: add minimal test for sigp sense running status
Date:   Thu,  2 Apr 2020 11:44:41 -0400
Message-Id: <20200402154441.13063-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_06:2020-04-02,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two minimal tests:
- our own CPU should be running when we check ourselves
- a CPU should at least have some times with a not running
indication. To speed things up we stop CPU1

Also rename smp_cpu_running to smp_sense_running_status.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 lib/s390x/smp.c |  2 +-
 lib/s390x/smp.h |  2 +-
 s390x/smp.c     | 15 +++++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

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
index 79cdc1f..4450aff 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -210,6 +210,20 @@ static void test_emcall(void)
 	report_prefix_pop();
 }
 
+static void test_sense_running(void)
+{
+	report_prefix_push("sense_running");
+	/* we are running */
+	report(smp_sense_running_status(0), "CPU0 sense claims running");
+	/* make sure CPU is stopped to speed up the not running case */
+	smp_cpu_stop(1);
+	/* Make sure to have at least one time with a not running indication */
+	while(smp_sense_running_status(1));
+	report(true, "CPU1 sense claims not running");
+	report_prefix_pop();
+}
+
+
 /* Used to dirty registers of cpu #1 before it is reset */
 static void test_func_initial(void)
 {
@@ -319,6 +333,7 @@ int main(void)
 	test_store_status();
 	test_ecall();
 	test_emcall();
+	test_sense_running();
 	test_reset();
 	test_reset_initial();
 	smp_cpu_destroy(1);
-- 
2.25.1

