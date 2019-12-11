Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEAD11B42B
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 16:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388767AbfLKPqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 10:46:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388405AbfLKPqU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 10:46:20 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBFhNXB119312
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:46:19 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wsm2fqpdg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:46:19 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 11 Dec 2019 15:46:17 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Dec 2019 15:46:13 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBFkDjt39387168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 15:46:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9BAE4C044;
        Wed, 11 Dec 2019 15:46:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2AE94C050;
        Wed, 11 Dec 2019 15:46:12 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 15:46:12 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 7/9] s390x: css: msch, enable test
Date:   Wed, 11 Dec 2019 16:46:08 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121115-0016-0000-0000-000002D3DDE0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121115-0017-0000-0000-00003335FDDA
Message-Id: <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_04:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=986
 clxscore=1015 bulkscore=0 mlxscore=0 impostorscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110132
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A second step when testing the channel subsystem is to prepare a channel
for use.
This includes:
- Get the current SubCHannel Information Block (SCHIB) using STSCH
- Update it in memory to set the ENABLE bit
- Tell the CSS that the SCHIB has been modified using MSCH
- Get the SCHIB from the CSS again to verify that the subchannel is
  enabled.

This tests the success of the MSCH instruction by enabling a channel.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index dfab35f..b8824ad 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -19,12 +19,24 @@
 #include <asm/time.h>
 
 #include <css.h>
+#include <asm/time.h>
 
 #define SID_ONE		0x00010000
 
 static struct schib schib;
 static int test_device_sid;
 
+static inline void delay(unsigned long ms)
+{
+	unsigned long startclk;
+
+	startclk = get_clock_ms();
+	for (;;) {
+		if (get_clock_ms() - startclk > ms)
+			break;
+	}
+}
+
 static void test_enumerate(void)
 {
 	struct pmcw *pmcw = &schib.pmcw;
@@ -64,11 +76,64 @@ out:
 	report(1, "Devices, tested: %d, I/O type: %d", scn, scn_found);
 }
 
+static void test_enable(void)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+		int count = 0;
+	int cc;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(test_device_sid, &schib);
+	if (cc) {
+		report(0, "stsch cc=%d", cc);
+		return;
+	}
+
+	/* Update the SCHIB to enable the channel */
+	pmcw->flags |= PMCW_ENABLE;
+
+	/* Tell the CSS we want to modify the subchannel */
+	cc = msch(test_device_sid, &schib);
+	if (cc) {
+		/*
+		 * If the subchannel is status pending or
+		 * if a function is in progress,
+		 * we consider both cases as errors.
+		 */
+		report(0, "msch cc=%d", cc);
+		return;
+	}
+
+	/*
+	 * Read the SCHIB again to verify the enablement
+	 * insert a little delay and try 5 times.
+	 */
+	do {
+		cc = stsch(test_device_sid, &schib);
+		if (cc) {
+			report(0, "stsch cc=%d", cc);
+			return;
+		}
+		delay(10);
+	} while (!(pmcw->flags & PMCW_ENABLE) && count++ < 5);
+
+	if (!(pmcw->flags & PMCW_ENABLE)) {
+		report(0, "Enable failed. pmcw: %x", pmcw->flags);
+		return;
+	}
+	report(1, "Tested");
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
 } tests[] = {
 	{ "enumerate (stsch)", test_enumerate },
+	{ "enable (msch)", test_enable },
 	{ NULL, NULL }
 };
 
-- 
2.17.0

