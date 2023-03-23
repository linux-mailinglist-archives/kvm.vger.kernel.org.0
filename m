Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1716C6575
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCWKnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjCWKn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:43:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38293B3C5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:40:26 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NAEJBM024860
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dbD4RfrtcBN5iu5DvE3DWaW2qw7Uu4kEAYEwFGjoj4U=;
 b=hgbU15bvQqdNIM0u0X94HTajVsHFwaunnpIAEe8eZcJ26WWgSatZq4t+btolVekU0dFT
 ebOaRC63PIDzOHBGwzJrc9c9Xp1eSPXnAVxQD4WWxCtHAALiijA7wp/CDguJHE1gUdxA
 gde7PcJTJmoLzxVem+UYUZDhPPbWlZurpbxxDLYi0nhjYzCBKmMj9INCnuBCM9LyZJv9
 wwlXtfj7iiwOCQ56e6OsbtTtRHoP4E6Rn7vVzHdZL/u+av/ND+WVQOv83oYjnguz14UI
 mqU8FSepCLwPZMWbUZxNisY13M7YGzE9d/OlExsrVIvBACeRSs7V3Cci73fRqVfhoIPn 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmu78mdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:23 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NAGQPF031643
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:23 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmu78mck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NAFJXK017094;
        Thu, 23 Mar 2023 10:40:21 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6f6k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NAeHAv16581334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 10:40:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B83D20040;
        Thu, 23 Mar 2023 10:40:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7D1420063;
        Thu, 23 Mar 2023 10:40:16 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 10:40:16 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, nrb@linux.ibm.com
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/8] s390x: uv-host: Beautify code
Date:   Thu, 23 Mar 2023 10:39:09 +0000
Message-Id: <20230323103913.40720-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230323103913.40720-1-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pAfKZEQZTF7FV3HypI1kfRntSlox3WqE
X-Proofpoint-GUID: 5YhjKizspWnciLNt8Dfv_4wju_EKXDAR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303230080
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixup top comment and add missing space.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index e38a9913..0f550415 100644
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
@@ -33,7 +33,7 @@ static struct uv_cb_csc uvcb_csc;
 
 extern int diag308_load_reset(u64 code);
 
-struct cmd_list{
+struct cmd_list {
 	const char *name;
 	uint16_t cmd;
 	uint16_t len;
-- 
2.34.1

