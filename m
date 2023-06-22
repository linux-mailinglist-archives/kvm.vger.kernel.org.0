Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8869739878
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 09:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjFVHwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 03:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjFVHwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 03:52:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFC91A1;
        Thu, 22 Jun 2023 00:52:13 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35M7lrA9029003;
        Thu, 22 Jun 2023 07:52:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lvTwVe2wHpTVaZEnd1+wNJuUavjgORUgmWHp3AMNI0k=;
 b=eNqIFUtuQCQeL+UHORlpB18aZuB/3i5qFIl6wnyFBZavY8JmO/0YVra1VW0KH/fQhvTU
 vGylcl54th5Q4NjauxTl4HMR/OEd8toeSplYuZ5euPWYsPwHJBBhICtLiOlqp5m5es1N
 SetjApv1xGgBLgP6gf9lciSSFLMbtIdB2nsTwA4k1BeimcrEBuztdGvSsaZQSdZM2gdi
 JXBhUI6Gnk/GRgCDoEsbDQ5+FmNX1YR+uVpbMkQJTI4WlinDiqf2xfJuRMRxb6INqX8d
 6EJGuJRUMBNB5fxzmJK1yuR6Pt1Iy+8ArIb8ri4wfeB+bly0XoIyJOy3oht+k+1VTTDg Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rcj7er24h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:12 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M7mFfB030853;
        Thu, 22 Jun 2023 07:52:11 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rcj7er246-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35M2N21k024250;
        Thu, 22 Jun 2023 07:52:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3r943e3asx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35M7q6FX50594250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 07:52:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F9F52004B;
        Thu, 22 Jun 2023 07:52:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC7B220040;
        Thu, 22 Jun 2023 07:52:05 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jun 2023 07:52:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 7/8] s390x: uv-host: Fence access checks when UV debug is enabled
Date:   Thu, 22 Jun 2023 07:50:53 +0000
Message-Id: <20230622075054.3190-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622075054.3190-1-frankja@linux.ibm.com>
References: <20230622075054.3190-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IIBWXk7YCVc1tbePDm5RRwdeBxFtQuK5
X-Proofpoint-ORIG-GUID: cIec92G_AuMr83E-OIPsiq0gTcbXAQSX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_04,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxscore=0 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 65a9c6d3..55b46446 100644
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

