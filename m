Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E8F1B57D2
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgDWJKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:10:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgDWJKa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 05:10:30 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03N96l8Y131407
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 05:10:29 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrc5j1mj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 05:10:29 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 23 Apr 2020 10:09:39 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Apr 2020 10:09:35 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03N9AN8E12124530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 09:10:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C9F54C052;
        Thu, 23 Apr 2020 09:10:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5233E4C044;
        Thu, 23 Apr 2020 09:10:22 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Apr 2020 09:10:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com
Subject: [PATCH v2 04/10] s390x: smp: Test local interrupts after cpu reset
Date:   Thu, 23 Apr 2020 05:10:07 -0400
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423091013.11587-1-frankja@linux.ibm.com>
References: <20200423091013.11587-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042309-0016-0000-0000-00000309C535
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042309-0017-0000-0000-0000336DE5C5
Message-Id: <20200423091013.11587-5-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_06:2020-04-22,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=883 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 phishscore=0 mlxscore=0 suspectscore=1
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Local interrupts (external and emergency call) should be cleared after
any cpu reset.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 s390x/smp.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 8a6cd1d..a8e3dd7 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -243,6 +243,20 @@ static void test_reset_initial(void)
 	report_prefix_pop();
 }
 
+static void test_local_ints(void)
+{
+	unsigned long mask;
+
+	expect_ext_int();
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
@@ -251,10 +265,18 @@ static void test_reset(void)
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

