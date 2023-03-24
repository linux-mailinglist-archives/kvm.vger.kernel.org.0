Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB26C7DE5
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCXMSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjCXMSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F50D7D9B
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:22 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OASORB008950
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jEVAQg4C+gU2c7yuoeKlN8xRmLeoC7KO+b05P0EPh+s=;
 b=M+RIHzERl6AP0YMC2CY87MvoHU1H6R4eyu3OMj4oZdfc3hT7x52pVTvc42bghvJfHrji
 Rt6iXpEpameN1pD7vtcBTY8CGvqYSMzJPHfuBu3CePaDk0KGBKzdjI8OaliPWvZrTX8z
 YsCpgC0JMXu82B0Unpidj7TNRIqAvjLoHhsY+tWtqI5rnRXixFFmYf9yTrf7Vup/ER1l
 8Ufhv6McZi6HVlVkV8F5N2ZeMOIodp1WOa2oqS8z7yi8GrdQINenA2Wq9m80xZEv6x1P
 XNNh+398YyQ1q2v4QumWBoJGWZdVZ5qgUh5IZoRoXGtMtUjHEI46XVUJZHtsITUPuCDK tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph7s76b8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:21 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBI3tK023921
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph7s76b81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLLLYs025310;
        Fri, 24 Mar 2023 12:18:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pgxkrrtth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:19 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCIFXw30081680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:15 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 900B22004D;
        Fri, 24 Mar 2023 12:18:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E553E2004B;
        Fri, 24 Mar 2023 12:18:14 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 9/9] s390x: uv-host: Fence access checks when UV debug is enabled
Date:   Fri, 24 Mar 2023 12:17:24 +0000
Message-Id: <20230324121724.1627-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324121724.1627-1-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XvFjWBan-puaL4idEyFGqMq1_ip0EZ-O
X-Proofpoint-GUID: ZRqt-8mnez-r7RhTOoqg-LjJk5NJ4js-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The debug print directly accesses the UV header which will result in a
second accesses exception which will abort the test. Let's fence the
access tests instead.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 5ad1a116..bf683202 100644
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

