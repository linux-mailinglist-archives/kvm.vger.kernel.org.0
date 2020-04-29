Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659CD1BE137
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 16:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgD2Off (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 10:35:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47288 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727108AbgD2Ofe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 10:35:34 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TEVwjc003204;
        Wed, 29 Apr 2020 10:35:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhfhje9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 10:35:33 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03TEWG8d004638;
        Wed, 29 Apr 2020 10:35:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhfhjd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 10:35:33 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TEUUwA019022;
        Wed, 29 Apr 2020 14:35:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu70n4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 14:35:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TEZSEK58916868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:35:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B00274C046;
        Wed, 29 Apr 2020 14:35:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02B344C044;
        Wed, 29 Apr 2020 14:35:28 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 14:35:27 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com
Subject: [PATCH v3 04/10] s390x: smp: Test local interrupts after cpu reset
Date:   Wed, 29 Apr 2020 10:35:12 -0400
Message-Id: <20200429143518.1360468-5-frankja@linux.ibm.com>
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

Local interrupts (external and emergency call) should be cleared after
any cpu reset.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 s390x/smp.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 4c50183..5e2e517 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -245,6 +245,19 @@ static void test_reset_initial(void)
 	report_prefix_pop();
 }
 
+static void test_local_ints(void)
+{
+	unsigned long mask;
+
+	/* Open masks for ecall and emcall */
+	ctl_set_bit(0, 13);
+	ctl_set_bit(0, 14);
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_EXT;
+	load_psw_mask(mask);
+	set_flag(1);
+}
+
 static void test_reset(void)
 {
 	struct psw psw;
@@ -253,10 +266,18 @@ static void test_reset(void)
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("cpu reset");
+	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
 	smp_cpu_start(1, psw);
 
 	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
 	report(smp_cpu_stopped(1), "cpu stopped");
+
+	set_flag(0);
+	psw.addr = (unsigned long)test_local_ints;
+	smp_cpu_start(1, psw);
+	wait_for_flag();
+	report(true, "local interrupts cleared");
 	report_prefix_pop();
 }
 
-- 
2.25.1

