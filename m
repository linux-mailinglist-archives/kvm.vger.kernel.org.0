Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C31354E06
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbhDFHlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235408AbhDFHlJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:09 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367XWCb127191
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=aGuzAiyr/LBA8+BZbKu3X4j4AYBMPrecChu0VN0AH20=;
 b=WIEO7YD2ddWGaNayfwUDOIoENPbdXvre3/dlzlyW0Y7vI1kUskE/Db279NMAltTrFG8T
 wUrP1euBxxvAw6REdI/WbNdng1xbaHxtksPk+EhMXlx0UmwxvJSeyC2egnFmP2Ct30/4
 Uu/R7vLIc+EaEDaxniRy8kZzLuADoGPmw/p3AsaV1FHRGYmcvFPS5fc3N7GHhoTHDBGC
 k3ADhTNuUur5pMD3Igcem8xChzvcZ7wqK84BWosxD5pYnCeBIm6qoA4TZ7LEsRwqD4Yk
 2XYq01SF+JNcjgQAih07NU7a7WPt/POIGejBQ/FD4yzvRqw5ug6BXHxVvDMI3Yj3N3df 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5exarq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:01 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367ZCK4132851
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:01 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5exarpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:01 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367X6NE030906;
        Tue, 6 Apr 2021 07:40:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 37q2nm10t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:40:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367euWM47513876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B8D64C040;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3EC34C04E;
        Tue,  6 Apr 2021 07:40:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 03/16] s390x: css: simplify skipping tests on no device
Date:   Tue,  6 Apr 2021 09:40:40 +0200
Message-Id: <1617694853-6881-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ijXqJOTIjeltbevAphaMFb5tSGO8PuUI
X-Proofpoint-ORIG-GUID: eJFliOcR1GrHVufkLzwkycemIxIgA1F5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will have to test if a device is present for every tests
in the future.
Let's provide separate the first tests from the test loop and
skip the remaining tests if no device is present.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/s390x/css.c b/s390x/css.c
index c340c53..17a6e1d 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -41,11 +41,6 @@ static void test_enable(void)
 {
 	int cc;
 
-	if (!test_device_sid) {
-		report_skip("No device");
-		return;
-	}
-
 	cc = css_enable(test_device_sid, IO_SCH_ISC);
 
 	report(cc == 0, "Enable subchannel %08x", test_device_sid);
@@ -62,11 +57,6 @@ static void test_sense(void)
 	int ret;
 	int len;
 
-	if (!test_device_sid) {
-		report_skip("No device");
-		return;
-	}
-
 	ret = css_enable(test_device_sid, IO_SCH_ISC);
 	if (ret) {
 		report(0, "Could not enable the subchannel: %08x",
@@ -218,11 +208,6 @@ static void test_schm_fmt0(void)
 	struct measurement_block_format0 *mb0;
 	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
 
-	if (!test_device_sid) {
-		report_skip("No device");
-		return;
-	}
-
 	/* Allocate zeroed Measurement block */
 	mb0 = alloc_io_mem(shared_mb_size, 0);
 	if (!mb0) {
@@ -289,11 +274,6 @@ static void test_schm_fmt1(void)
 {
 	struct measurement_block_format1 *mb1;
 
-	if (!test_device_sid) {
-		report_skip("No device");
-		return;
-	}
-
 	if (!css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
 		report_skip("Extended measurement block not available");
 		return;
@@ -336,8 +316,6 @@ static struct {
 	void (*func)(void);
 } tests[] = {
 	/* The css_init test is needed to initialize the CSS Characteristics */
-	{ "initialize CSS (chsc)", css_init },
-	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
@@ -352,11 +330,25 @@ int main(int argc, char *argv[])
 
 	report_prefix_push("Channel Subsystem");
 	enable_io_isc(0x80 >> IO_SCH_ISC);
+
+	report_prefix_push("initialize CSS (chsc)");
+	css_init();
+	report_prefix_pop();
+
+	report_prefix_push("enumerate (stsch)");
+	test_enumerate();
+	report_prefix_pop();
+
+	if (!test_device_sid)
+		goto end;
+
 	for (i = 0; tests[i].name; i++) {
 		report_prefix_push(tests[i].name);
 		tests[i].func();
 		report_prefix_pop();
 	}
+
+end:
 	report_prefix_pop();
 
 	return report_summary();
-- 
2.17.1

