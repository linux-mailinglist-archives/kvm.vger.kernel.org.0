Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5FD19073C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 09:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCXINM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 04:13:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727150AbgCXINL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 04:13:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O82Vxh072287
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:10 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywf2gp8gn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:09 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 24 Mar 2020 08:13:08 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 08:13:05 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02O8C3MY21365174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 08:12:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCFBFA405C;
        Tue, 24 Mar 2020 08:13:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE937A405B;
        Tue, 24 Mar 2020 08:13:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 08:13:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com
Subject: [kvm-unit-tests PATCH 04/10] s390x: smp: Test local interrupts after cpu reset
Date:   Tue, 24 Mar 2020 04:12:45 -0400
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324081251.28810-1-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032408-0028-0000-0000-000003EA6E30
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032408-0029-0000-0000-000024AFD6F4
Message-Id: <20200324081251.28810-5-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_01:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=1 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=889 clxscore=1015 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240039
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Local interrupts (external and emergency call) should be cleared after
any cpu reset.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 8a6cd1d8b17d76c6..a8e3dd7aac0c788c 100644
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

