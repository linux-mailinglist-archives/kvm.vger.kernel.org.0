Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECA93EA415
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 13:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhHLLxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 07:53:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235563AbhHLLxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 07:53:43 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CBerWu114499
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 07:53:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=13DS8SulLLtvEvmWYmwz/8s0cf3EtTWHPcwHC36YRKI=;
 b=XaST1Vdk7sHa+QfuisBSkMMa4DJ6NV+/zHBlc2ZOSZ3YJF6uT3aqVsVmIDxkPXgwZxMv
 Dg3BwGrX1WVh1KpwgZ7hjsYuSRxyOu1JywPwZpN3+e6ndLcay2eZyFQF9wLG+ZGLUHLN
 q7cuBROB7MNcW8fpeFdsV9cbKlH3qDVihMH+rc483jsXoaHjgbcjfrVwffzjllmoILXG
 tsNg0t83IqO4E1hl9G3QAftQMUB2izFMzAxBsOxTxLz/nDCSR94eGpuUIYWG0YXbaIFl
 V5A9rZmZWvw8kgf4n1KRXuDYSUX6VRa5IVk0zX2lGE5TrrPKoOJ21BWA4S4v4k1B+6vz iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad1r0am2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 07:53:17 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17CBgg0T123999
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 07:53:17 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad1r0am24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 07:53:17 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17CBm7MI014570;
        Thu, 12 Aug 2021 11:53:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3a9ht90hnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 11:53:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17CBnwPP49414478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 11:49:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 962164C074;
        Thu, 12 Aug 2021 11:53:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45B384C076;
        Thu, 12 Aug 2021 11:53:11 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.85.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 11:53:11 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/1] s390x: css: check the CSS is working with any ISC
Date:   Thu, 12 Aug 2021 13:53:09 +0200
Message-Id: <1628769189-10699-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628769189-10699-1-git-send-email-pmorel@linux.ibm.com>
References: <1628769189-10699-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z4bjF4fI3vaNz_kWFw16r-lhhghIvAM8
X-Proofpoint-ORIG-GUID: ZZ7I_UOO-L5XjU47MDn-WOGi2nLUPZtF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_04:2021-08-12,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108120075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the previous version we did only check that one ISC dedicated by
Linux for I/O is working fine.

However, there is no reason to prefer one ISC to another ISC, we are
free to take anyone.

Let's check all possible ISC to verify that QEMU/KVM is really ISC
independent.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/s390x/css.c b/s390x/css.c
index c340c539..aa005309 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -22,6 +22,7 @@
 
 #define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
 static unsigned long cu_type = DEFAULT_CU_TYPE;
+static int io_isc;
 
 static int test_device_sid;
 static struct senseid *senseid;
@@ -46,7 +47,7 @@ static void test_enable(void)
 		return;
 	}
 
-	cc = css_enable(test_device_sid, IO_SCH_ISC);
+	cc = css_enable(test_device_sid, io_isc);
 
 	report(cc == 0, "Enable subchannel %08x", test_device_sid);
 }
@@ -67,7 +68,7 @@ static void test_sense(void)
 		return;
 	}
 
-	ret = css_enable(test_device_sid, IO_SCH_ISC);
+	ret = css_enable(test_device_sid, io_isc);
 	if (ret) {
 		report(0, "Could not enable the subchannel: %08x",
 		       test_device_sid);
@@ -142,7 +143,6 @@ static void sense_id(void)
 
 static void css_init(void)
 {
-	assert(register_io_int_func(css_irq_io) == 0);
 	lowcore_ptr->io_int_param = 0;
 
 	report(get_chsc_scsc(), "Store Channel Characteristics");
@@ -351,11 +351,20 @@ int main(int argc, char *argv[])
 	int i;
 
 	report_prefix_push("Channel Subsystem");
-	enable_io_isc(0x80 >> IO_SCH_ISC);
-	for (i = 0; tests[i].name; i++) {
-		report_prefix_push(tests[i].name);
-		tests[i].func();
-		report_prefix_pop();
+
+	for (io_isc = 0; io_isc < 8; io_isc++) {
+		report_info("ISC: %d\n", io_isc);
+
+		enable_io_isc(0x80 >> io_isc);
+		assert(register_io_int_func(css_irq_io) == 0);
+
+		for (i = 0; tests[i].name; i++) {
+			report_prefix_push(tests[i].name);
+			tests[i].func();
+			report_prefix_pop();
+		}
+
+		unregister_io_int_func(css_irq_io);
 	}
 	report_prefix_pop();
 
-- 
2.25.1

