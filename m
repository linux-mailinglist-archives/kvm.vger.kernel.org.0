Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CBA74F1A5
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjGKOTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjGKOTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:19:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71149E69
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:18:35 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BE6K17019651;
        Tue, 11 Jul 2023 14:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=9wx2DhqGDTpXc2kmU8czI7vafJpYYo5eEIx6NJ1IrDk=;
 b=e1mK8nipEgL3KjjbjojCkLsvs0qqJ9uJK8ighC06WqDkwOC4wOvYO8FdzOeiW5LihquW
 JlhyZF0jbVpiHt6iWHRDrH5d098IkW0amzrys4g5IOEZYPHkfQwiWJlenq1JQAshZPmm
 siCFkfCV/kOefVUFnIzngukH8Iip99eJpT9o/xwRa+D8UXZ4lP0q88kDBJs5j6M91cXY
 BjmXywL/JJ6JUINEM34pVLkdrkEAOOyzDiCHB1TBPO7TapmBWv3VfQjQXAT4+cYFeWi+
 U5pLifOi+c7MhldFIABeY97YwPn93000/dMmn/rGcE46Wzoqq1YrAUfK3MrMrkE4GmyQ WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8aah8vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:17:25 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BDoX4n021503;
        Tue, 11 Jul 2023 14:16:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8aah8c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B8QxS0022234;
        Tue, 11 Jul 2023 14:16:23 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye59tu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGKlT28312048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D17D20043;
        Tue, 11 Jul 2023 14:16:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C44F120040;
        Tue, 11 Jul 2023 14:16:19 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:19 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 17/22] s390x: uv-host: Fence access checks when UV debug is enabled
Date:   Tue, 11 Jul 2023 16:15:50 +0200
Message-ID: <20230711141607.40742-18-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YRQ2S6LaaClcVVXFaOA8jf8rdqR8d-xQ
X-Proofpoint-ORIG-GUID: ALm3P457AbgD4L_mxS-SCmZVt4m5Iqnf
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The debug print directly accesses the UV header which will result in a
second accesses exception which will abort the test. Let's fence the
access tests instead.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230622075054.3190-8-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 65a9c6d..55b4644 100644
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
2.41.0

