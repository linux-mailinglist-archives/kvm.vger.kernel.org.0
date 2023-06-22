Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997D373987B
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 09:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjFVHwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 03:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjFVHwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 03:52:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD53FC;
        Thu, 22 Jun 2023 00:52:10 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35M7q1Oa017968;
        Thu, 22 Jun 2023 07:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=X1qR2eWIK+m53tLp/rYbcWmu74do4JLgRFnHrGB3qpo=;
 b=MIgq0hCj93bO5yqLG1ITesJDukkKjc2l/5XeUqbLIodaVby+vrmvsq5yklf/+f1ZXc4G
 /4k7w3noFPTLHdmnRDHm27cXAvZS1upjiMmUceIaqJOlOYubqIl+/mWdVxkZVpoS83h8
 Ynb81yOpc5kYTzJYdi2WKViDS5t5GWcGdBpFPU7gXh6g7nyh8cES2pHwoSbvgmbW0cNu
 KPAqN7e9Z2//gRocr1zMVpcacKoze79oqGDIIgINzOg/jsfWY4JplDUhvMmcsONRJSDp
 x4vWJ3LMSa6I0mfMCbGuBAIGI18Aq2RHkhz3VF74lztzvalcqrJx3S6P3OVAx0zDrbAo gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rcj9q0036-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:09 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M7q95W019675;
        Thu, 22 Jun 2023 07:52:09 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rcj9q002q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:09 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35M3sjmt014842;
        Thu, 22 Jun 2023 07:52:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3r94f5age3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35M7q2bG53477818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 07:52:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA9C420040;
        Thu, 22 Jun 2023 07:52:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D78B12004B;
        Thu, 22 Jun 2023 07:52:01 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jun 2023 07:52:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 3/8] s390x: uv-host: Beautify code
Date:   Thu, 22 Jun 2023 07:50:49 +0000
Message-Id: <20230622075054.3190-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622075054.3190-1-frankja@linux.ibm.com>
References: <20230622075054.3190-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tyRkwvMS0s-oAn7BS6qUvGw0T8zOzK8G
X-Proofpoint-ORIG-GUID: AAg9VVrCg5gKimunCBt3JNBJzG97dF6u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_04,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Fixup top comment and add missing space.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index ee8e44d1..08ef266a 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Guest Ultravisor Call tests
+ * Host Ultravisor Call tests
  *
  * Copyright (c) 2021 IBM Corp
  *
@@ -34,7 +34,7 @@ static struct uv_cb_csc uvcb_csc;
 
 extern int diag308_load_reset(u64 code);
 
-struct cmd_list{
+struct cmd_list {
 	const char *name;
 	uint16_t cmd;
 	uint16_t len;
-- 
2.34.1

