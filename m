Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340ED6C6577
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjCWKn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjCWKn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:43:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C0159F4
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:40:28 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N9oNnS026483
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BqwhAQtD8u7fdukYUz6qnkSPf+czkiCxB6OsRDwqtkU=;
 b=PoGNp9g/d/JMzGRMvFH7Yjr6K75/lhWLEyd/y1tUyoaunxat8v1mLpyeN8YKtkNzg70x
 F6H1ffcZBASO/9RPvHL8CBMUvYSA6skEeRmOKrUVuLeuEHuMYnOPfLnGgKLvaOgHuYGT
 dhCeMhdzrJR/lj7Eql5whD2ve/3FzJKIVZuFBDDSdbWS7eLzIk1k3lg2il3ezkiRFvUV
 LbnsxKWFgHCSUE3zXAyGHqsCpnCmpMN3AsEpFfC7xTxOEqmNRuHtEXLAy90wf6SqxPWn
 OrJr2k5zEM+Q89O3hMjrjChb3QNhpvfoZPjSlXfgmlwp9cIYBmv3zLkkrB88Z7GBQeKy gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmg6h60t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:26 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NAQN9q009490
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmg6h60e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32N8aKEl015024;
        Thu, 23 Mar 2023 10:40:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pd4jff7nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NAeKpI14680784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 10:40:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93CA72004B;
        Thu, 23 Mar 2023 10:40:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F05C720043;
        Thu, 23 Mar 2023 10:40:19 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 10:40:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, nrb@linux.ibm.com
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 8/8] s390x: uv-host: Fence access checks when UV debug is enabled
Date:   Thu, 23 Mar 2023 10:39:13 +0000
Message-Id: <20230323103913.40720-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230323103913.40720-1-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p42JaA6WmrbTAh0ZXzswzka31cdgrIt5
X-Proofpoint-ORIG-GUID: ob3tDpE3qk5yePHQLBWRboOzI322ASdZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230080
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The debug print directly accesses the UV header which will result in a
second accesses exception which will abort the test. Let's fence the
access tests instead.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index b23d51c9..1f73034f 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -164,6 +164,15 @@ static void test_access(void)
 
 	report_prefix_push("access");
 
+	/*
+	 * If debug is enabled info from the uv header is printed
+	 * which would lead to a second exception and a test abort.
+	 */
+	if (UVC_ERR_DEBUG) {
+		report_skip("Debug doesn't work with access tests");
+		goto out;
+	}
+
 	report_prefix_push("non-crossing");
 	protect_page(uvcb, PAGE_ENTRY_I);
 	for (i = 0; cmds[i].name; i++) {
@@ -196,6 +205,7 @@ static void test_access(void)
 	uvcb += 1;
 	unprotect_page(uvcb, PAGE_ENTRY_I);
 
+out:
 	free_pages(pages);
 	report_prefix_pop();
 }
-- 
2.34.1

