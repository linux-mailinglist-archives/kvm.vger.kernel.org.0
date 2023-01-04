Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CE265DBC5
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 19:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbjADSAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 13:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbjADSAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 13:00:00 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3211EC5;
        Wed,  4 Jan 2023 10:00:00 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304GhYJT007825;
        Wed, 4 Jan 2023 17:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=sc47u3Z+RbHwcenEQCYadPXvc7mLDEKgKoTJEM1TTjU=;
 b=qDUq7fiHxOLLYtPOMjv7vKxAVlE33oNhT5NvURmK76pVKHIl0onp2WDpO+lXmh5MHG7D
 Yam4lbHdjiTbWYc6CATTigpFzmVbZpzgXKIoqBdmo4WufrAex0jQtk/FRKxQL2fHl0dn
 jBG4QPFZDeEm6c/9uyfDX9oadD/WpmToOWwkR9We8e/TaTlkOheIGupCczzSx+GveiWg
 IVm8OAxjonozDf6nGizrDC9EezIQJeYD6U2OovOm5jTn2aQ6EhQXPsnp4QUGfn4XmcUb
 8VL93P44Dq4HNZ+c9W/xAkBiDf6to81vYn4LDvf+dL037V3jUwZB6z6H8YNSjDmDgOhN AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwd7n1puq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 17:59:59 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 304GhfUP007960;
        Wed, 4 Jan 2023 17:59:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwd7n1pu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 17:59:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30486XiR001864;
        Wed, 4 Jan 2023 17:59:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mtcbfdp0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 17:59:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 304HxrKQ16449980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 17:59:53 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2225920043;
        Wed,  4 Jan 2023 17:59:53 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9CF520040;
        Wed,  4 Jan 2023 17:59:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  4 Jan 2023 17:59:52 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: Fix integer literal in skey.c
Date:   Wed,  4 Jan 2023 18:59:50 +0100
Message-Id: <20230104175950.731988-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y_PO-LvEtO166hlBLKtE5qEleju2D26P
X-Proofpoint-ORIG-GUID: 40mwZw9aLX5ZnWdy-oNRAYDtZ5xO_m48
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code is a 64bit number of which the upper 48 bits must be 0.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/skey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/skey.c b/s390x/skey.c
index 1167e4d3..7c7a8090 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -320,7 +320,7 @@ static void test_diag_308(void)
 		"lr	%[response],%%r3\n"
 		: [response] "=d" (response)
 		: [ipib] "d" (ipib),
-		  [code] "d" (5)
+		  [code] "d" (5L)
 		: "%r2", "%r3"
 	);
 	report(response == 0x402, "no exception on fetch, response: invalid IPIB");

base-commit: 73d9d850f1c2c9f0df321967e67acda0d2c305ea
-- 
2.36.1

