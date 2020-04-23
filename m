Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA841B57D9
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgDWJKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:10:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10342 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726643AbgDWJKd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 05:10:33 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03N93CeW063111
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 05:10:32 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrj6j8vh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 05:10:32 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 23 Apr 2020 10:09:42 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Apr 2020 10:09:39 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03N9ARFQ38207642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 09:10:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 499064C052;
        Thu, 23 Apr 2020 09:10:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A1BD4C04E;
        Thu, 23 Apr 2020 09:10:26 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Apr 2020 09:10:26 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com
Subject: [PATCH v2 09/10] s390x: smp: Add restart when running test
Date:   Thu, 23 Apr 2020 05:10:12 -0400
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423091013.11587-1-frankja@linux.ibm.com>
References: <20200423091013.11587-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042309-0016-0000-0000-00000309C537
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042309-0017-0000-0000-0000336DE5C9
Message-Id: <20200423091013.11587-10-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_06:2020-04-22,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make sure we can restart a cpu that is already running.
Restarting it if it is stopped is implicitely tested by the the other
restart calls in the smp test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 s390x/smp.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 48321f4..35ca9c7 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -52,6 +52,34 @@ static void test_start(void)
 	report(1, "start");
 }
 
+/*
+ * Does only test restart when the target is running.
+ * The other tests do restarts when stopped multiple times already.
+ */
+static void test_restart(void)
+{
+	struct cpu *cpu = smp_cpu_from_addr(1);
+	struct lowcore *lc = cpu->lowcore;
+
+	lc->restart_new_psw.mask = extract_psw_mask();
+	lc->restart_new_psw.addr = (unsigned long)test_func;
+
+	/* Make sure cpu is running */
+	smp_cpu_stop(0);
+	set_flag(0);
+	smp_cpu_restart(1);
+	wait_for_flag();
+
+	/*
+	 * Wait until cpu 1 has set the flag because it executed the
+	 * restart function.
+	 */
+	set_flag(0);
+	smp_cpu_restart(1);
+	wait_for_flag();
+	report(1, "restart while running");
+}
+
 static void test_stop(void)
 {
 	smp_cpu_stop(1);
@@ -295,6 +323,7 @@ int main(void)
 	smp_cpu_stop(1);
 
 	test_start();
+	test_restart();
 	test_stop();
 	test_stop_store_status();
 	test_store_status();
-- 
2.25.1

