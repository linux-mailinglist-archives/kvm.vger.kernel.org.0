Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C056F44BA
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbjEBNKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjEBNJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:09:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3612655AE;
        Tue,  2 May 2023 06:09:44 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342D8pTN018242;
        Tue, 2 May 2023 13:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=33YtdrKs9YjiCF3eXFJd5sVjCUC7Qew+md1A2eAteLc=;
 b=WLyJyS7TicNk6Ex8DZviBEgRrjUfZTA0SNkG+vLFBZVI/B9qtylhFkKt8uvruxmBmBOb
 3cip+oq+6+cTcsILYh6ELLbIbBncLHru7alwRGi+TzLCGA9jnbB0m/VaQ8SafUbrDhvr
 DYmj6L/til0Jgx/G5hmK6AfJ8pkF64fYzeGwCUIZ2O9ueG3DP7v95M89srd3xuZYfQ/O
 PkfHpZ+lQBXRfoM9g7GeADDaCoSBcArZVW+bxUzUqS9ofLV6DZFu46Wr/QNb/rh/RtwL
 W8oENUTjbSIOSg7dMxJd2SHyYjwGS7+0bqJyiHyhWsJV8QrvVIuw0UojPxagd/EOLLoq tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8bwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:42 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D9aVd026343;
        Tue, 2 May 2023 13:09:36 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8baa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:35 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3427ahQ0004301;
        Tue, 2 May 2023 13:09:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6sajc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9LI554722854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FB4A2004D;
        Tue,  2 May 2023 13:09:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76DE020040;
        Tue,  2 May 2023 13:09:20 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/9] s390x: uv-host: Beautify code
Date:   Tue,  2 May 2023 13:07:26 +0000
Message-Id: <20230502130732.147210-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fl01rQCWM9LWCFVBEfF1oT69Q6dYStmO
X-Proofpoint-ORIG-GUID: APwxQ_-dwITK90o8Upkq5n4YoqbWGekM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 34ca7148..1c04d8ef 100644
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

