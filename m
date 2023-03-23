Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D94E6C6572
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjCWKnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjCWKnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:43:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8733B21E
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:40:26 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N9HA6Z027998
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DZ2WKu/ZGtOVl08v8Cef4c6EUiWjemU5CgUJlq9DuoQ=;
 b=df6f7Eu3d9VaZJOkpHTcDkiswMpYoxF+k+pp4JrF+iRv1vBxMpWnib7T7lJMLlM1z6PK
 PdROdYialK8Ao+TAacYQjZi9MeIlBo5XGbbbUl2vm3Bm2aYqJ/5im1sLPdfC2/QKuOZP
 PCDWkBqKWWi2Vv1GE2oAjWeVJ9gq50u1W2d+En3s88sTBCWNdz1uOLSCslSOgI/+ZN9P
 ahFl2YFxOK9YQngtotKvW4bsMrtROrtR2WAKMjUCathQeXctzKwDRTaixI/NeOpbuI8w
 Y7lHp7WO6phImcOwFBiIlip0EWbF1xrUvCbDhCpv5H6OtlcWJEClCRIjSmzKh6VOlAPt xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pghqsnfdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:22 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NAUQAk001605
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:22 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pghqsnfc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32N89gxR022502;
        Thu, 23 Mar 2023 10:40:19 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6f80j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NAeFbr64815514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 10:40:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15FB320096;
        Thu, 23 Mar 2023 10:40:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 663E62008E;
        Thu, 23 Mar 2023 10:40:14 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 10:40:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, nrb@linux.ibm.com
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/8] s390x: uv-host: Fix UV init test memory allocation
Date:   Thu, 23 Mar 2023 10:39:06 +0000
Message-Id: <20230323103913.40720-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230323103913.40720-1-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YM7oDrgSJXRN7eo8PniGt_OZRc1MAU_N
X-Proofpoint-ORIG-GUID: -4KnSRdwsXaFDqNa-9eoEs3VsbTwWUiW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=880
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230080
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The init memory has to be above 2G and 1M aligned but we're currently
aligning on 2G which means the allocations need a lot of unused
memory.

Let's fix that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 33e6eec6..68de47e7 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -555,7 +555,7 @@ static void test_init(void)
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 0 && uvcb_init.header.rc == UVC_RC_EXECUTED, "successful");
 
-	mem = (uint64_t)memalign(1UL << 31, uvcb_qui.uv_base_stor_len);
+	mem = (uint64_t)memalign_pages_flags(HPAGE_SIZE, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 1 && uvcb_init.header.rc == 0x101, "double init");
 	free((void *)mem);
-- 
2.34.1

