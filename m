Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593F86C7DE2
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjCXMSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjCXMSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F907ED3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:18 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OCCLJw030250
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rV/2eSJftsn23PM0WdTfxetG6ZYWtJV6gIM/d64cLCM=;
 b=n+D+EGVAmSgdGVRKc+aGbcefZ5FhfzGriIvcT6xfe+/a4mfZ5HSWBPm5j96C0IPmIu1P
 Yi6YjFtxddTh60fD+tjtFK+ODzwImUjuCqJmiiZYbCUqCD259X5uulJLOqWQR1bfwLEq
 aNdhW2esYG7WaPvGFZnAMPfS2R6/YhOwqRDK84O8wJ6vfLmFKyxSWFJ0vms5iDXfGdGS
 r8LlJIUOdWzf74GCu6CvcKqDd20jpUeR3V7/AyNkEqfAbUSw+MzjV6IEnChfq8D8sYZs
 4ZMWl8obnZL4LtNUV1qS3M/Qv95WaQfrMayZBoCWq5Mbttiy96pSxxiqlkM4aOFHlNjv ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phbnf852e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:17 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OCDvOP009136
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:17 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phbnf851p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:17 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NM7ANE000464;
        Fri, 24 Mar 2023 12:18:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3pgy9cgng5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCIB8549545660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:11 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 687392004D;
        Fri, 24 Mar 2023 12:18:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDFB42004B;
        Fri, 24 Mar 2023 12:18:10 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/9] s390x: uv-host: Beautify code
Date:   Fri, 24 Mar 2023 12:17:19 +0000
Message-Id: <20230324121724.1627-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324121724.1627-1-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yCc_LCQfCPqEGnU3ybXwL5jRL1RL9rKR
X-Proofpoint-GUID: RrTD9yXeHIB_CMicSdVlqrZfuMdPoevG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
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
index 91e88a1f..32cbe03f 100644
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

