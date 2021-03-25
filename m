Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610A8348D2B
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhCYJjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:39:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33656 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230027AbhCYJjP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:39:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P9YWU3170279
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=LXK1Ch4+n4MVLy2WjHfkqHhqm2qzla2HNEBZVif90zY=;
 b=BTTQjMW+uvT4JLaKSybr6ioKwjD5kHBA7R+px9BAVZO1K2z5kwz5itWKlnWOiRLozyPZ
 yg1dwgPKO8CPcpdRDY8+r068oWSBNOYP8ztj086DU+wX5nyj5rlve2/r3GQhdPAyVaTV
 coLC51UasuSgGHwoc6ebfJ3cXi69isibdEPiTZma8/XUosRkWktkT+qVbarHDxR4wcFh
 /Fuj1fuOy/u4/VZ8GpZSyAdN/4syfECq5lhlStnYUWkbGXFVblIBU9v2r3yc8jf/gCCt
 6ysaZ2CkyT1FJSaH6SXbVGCQ4WBY3iitbqrbVyLkmzD0/6kv4nbOoZ9B4lvnd86GEzF2 ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gq159w75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12P9a8Ad175508
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gq159w6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 05:39:15 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12P9RVPS019569;
        Thu, 25 Mar 2021 09:39:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 37d9bptr3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:39:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12P9d98W38011294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:39:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9C1411C064;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9971D11C058;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping tests on no device
Date:   Thu, 25 Mar 2021 10:39:02 +0100
Message-Id: <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will lhave to test if a device is present for every tests
in the future.
Let's provide a macro to check if the device is present and
to skip the tests if it is not.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/s390x/css.c b/s390x/css.c
index c340c53..16723f6 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -27,6 +27,13 @@ static int test_device_sid;
 static struct senseid *senseid;
 struct ccw1 *ccw;
 
+#define NODEV_SKIP(dev) do {						\
+				if (!(dev)) {				\
+					report_skip("No device");	\
+					return;				\
+				}					\
+			} while (0)
+
 static void test_enumerate(void)
 {
 	test_device_sid = css_enumerate();
@@ -41,10 +48,7 @@ static void test_enable(void)
 {
 	int cc;
 
-	if (!test_device_sid) {
-		report_skip("No device");
-		return;
-	}
+	NODEV_SKIP(test_device_sid);
 
 	cc = css_enable(test_device_sid, IO_SCH_ISC);
 
@@ -62,10 +66,7 @@ static void test_sense(void)
 	int ret;
 	int len;
 
-	if (!test_device_sid) {
-		report_skip("No device");
-		return;
-	}
+	NODEV_SKIP(test_device_sid);
 
 	ret = css_enable(test_device_sid, IO_SCH_ISC);
 	if (ret) {
@@ -218,10 +219,7 @@ static void test_schm_fmt0(void)
 	struct measurement_block_format0 *mb0;
 	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
 
-	if (!test_device_sid) {
-		report_skip("No device");
-		return;
-	}
+	NODEV_SKIP(test_device_sid);
 
 	/* Allocate zeroed Measurement block */
 	mb0 = alloc_io_mem(shared_mb_size, 0);
@@ -289,10 +287,7 @@ static void test_schm_fmt1(void)
 {
 	struct measurement_block_format1 *mb1;
 
-	if (!test_device_sid) {
-		report_skip("No device");
-		return;
-	}
+	NODEV_SKIP(test_device_sid);
 
 	if (!css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
 		report_skip("Extended measurement block not available");
-- 
2.17.1

