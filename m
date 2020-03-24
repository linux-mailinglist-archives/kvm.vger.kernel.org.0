Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E3190742
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 09:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgCXINT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 04:13:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727256AbgCXINS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 04:13:18 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O83iSS092057
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:17 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywet39cqa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:17 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 24 Mar 2020 08:13:14 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 08:13:12 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02O8DC9o56819888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 08:13:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2826CA4054;
        Tue, 24 Mar 2020 08:13:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36195A405F;
        Tue, 24 Mar 2020 08:13:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 08:13:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com
Subject: [kvm-unit-tests PATCH 09/10] s390x: smp: Add restart when running test
Date:   Tue, 24 Mar 2020 04:12:50 -0400
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324081251.28810-1-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032408-0012-0000-0000-00000396B38A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032408-0013-0000-0000-000021D3A6BE
Message-Id: <20200324081251.28810-10-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_02:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 clxscore=1015 phishscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=1
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240042
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make sure we can restart a cpu that is already running.
Restarting it if it is stopped is implicitely tested by the the other
restart calls in the smp test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 48321f4e346dc71d..79cdc1f6a4b0b491 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -52,6 +52,24 @@ static void test_start(void)
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
+	set_flag(0);
+	smp_cpu_restart(1);
+	wait_for_flag();
+	report(1, "restart while running");
+}
+
 static void test_stop(void)
 {
 	smp_cpu_stop(1);
@@ -295,6 +313,7 @@ int main(void)
 	smp_cpu_stop(1);
 
 	test_start();
+	test_restart();
 	test_stop();
 	test_stop_store_status();
 	test_store_status();
-- 
2.25.1

