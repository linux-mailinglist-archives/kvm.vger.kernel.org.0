Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F5211B425
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 16:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388746AbfLKPqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 10:46:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388744AbfLKPqT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 10:46:19 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBFhQVt043095
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:46:17 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wsqc2fdgw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:46:17 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 11 Dec 2019 15:46:16 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Dec 2019 15:46:14 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBFkDdh22347780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 15:46:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A09D4C044;
        Wed, 11 Dec 2019 15:46:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 430754C052;
        Wed, 11 Dec 2019 15:46:13 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 15:46:13 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 9/9] s390x: css: ping pong
Date:   Wed, 11 Dec 2019 16:46:10 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121115-4275-0000-0000-0000038DFFD7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121115-4276-0000-0000-000038A1B655
Message-Id: <1576079170-7244-10-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_04:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=1 clxscore=1015 mlxscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110132
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To test a write command with the SSCH instruction we need a QEMU device,
with control unit type 0xC0CA. The PONG device is such a device.

This type of device responds to PONG_WRITE requests by incrementing an
integer, stored as a string at offset 0 of the CCW data.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 7b9bdb1..a09cdff 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -26,6 +26,9 @@
 
 #define CSS_TEST_INT_PARAM	0xcafec0ca
 #define PONG_CU_TYPE		0xc0ca
+/* Channel Commands for PONG device */
+#define PONG_WRITE	0x21 /* Write */
+#define PONG_READ	0x22 /* Read buffer */
 
 struct lowcore *lowcore = (void *)0x0;
 
@@ -302,6 +305,48 @@ unreg_cb:
 	unregister_io_int_func(irq_io);
 }
 
+static void test_ping(void)
+{
+	int success, result;
+	int cnt = 0, max = 4;
+
+	if (senseid.cu_type != PONG_CU) {
+		report_skip("No PONG, no ping-pong");
+		return;
+	}
+
+	result = register_io_int_func(irq_io);
+	if (result) {
+		report(0, "Could not register IRQ handler");
+		return;
+	}
+
+	while (cnt++ < max) {
+		snprintf(buffer, BUF_SZ, "%08x\n", cnt);
+		success = start_subchannel(PONG_WRITE, buffer, 8);
+		if (!success) {
+			report(0, "start_subchannel failed");
+			goto unreg_cb;
+		}
+		delay(100);
+		success = start_subchannel(PONG_READ, buffer, 8);
+		if (!success) {
+			report(0, "start_subchannel failed");
+			goto unreg_cb;
+		}
+		result = atol(buffer);
+		if (result != (cnt + 1)) {
+			report(0, "Bad answer from pong: %08x - %08x",
+			       cnt, result);
+			goto unreg_cb;
+		}
+	}
+	report(1, "ping-pong count 0x%08x", cnt);
+
+unreg_cb:
+	unregister_io_int_func(irq_io);
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -309,6 +354,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "ping-pong (ssch/tsch)", test_ping },
 	{ NULL, NULL }
 };
 
-- 
2.17.0

