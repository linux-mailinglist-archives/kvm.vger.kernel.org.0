Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E4B750C45
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjGLPUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjGLPUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:20:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815281BE8
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:19:39 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CFFboJ003291;
        Wed, 12 Jul 2023 15:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ar0UAISEcS2HS8mJl31kFz0iNPU9QRYzuV7ZWS4uJiA=;
 b=p6bKmxxmXyF0YSlmr4GLA+KJ1V3rHp1vh62RpP4nP+zvdjKhH3r0IPPiSAknlC/veKnR
 TLI6FLAHUbvbRToVs9fjOpwz0E2S+QXpEnnfFHoU7q7afUxM4Qfo9REE7of1WSMB1BZO
 qsb6kgpunytpmmu+Fy2lrKAESG9rgdsGHG9tfglu/2UjgVS1+DTB8FahS3pt2Ca7xm/6
 SoFs5RF8XzaOKApzU66bPm+FpR83qof+EeTzGDfrQmYAA/aHgV9J3tSPndo1L7bX0EFB
 k6wiLmos9rF/HmP17DwVRHPSWx06EDxxxLpGlEMcbqzOet2rc1OUPWe377X+uQuzhz0o +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsxnj87ta-25
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 15:18:50 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CEmJ3g000620;
        Wed, 12 Jul 2023 15:12:42 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsx858yh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 15:12:42 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36CCfDk1032007;
        Wed, 12 Jul 2023 15:06:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3rpy2e9yan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 15:06:48 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CF6k2l46072098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 15:06:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CF622004B;
        Wed, 12 Jul 2023 15:06:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA5F120043;
        Wed, 12 Jul 2023 15:06:45 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jul 2023 15:06:45 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, andrew.jones@linux.dev, pbonzini@redhat.com,
        renmm6@chinaunicom.cn
Subject: [kvm-unit-tests PATCH v1 1/1] run_tests: fix verbose
Date:   Wed, 12 Jul 2023 17:06:45 +0200
Message-ID: <20230712150645.76746-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N88VJ5eAWmCnZnps0P1pq5gvgVmdxyIU
X-Proofpoint-GUID: oeBvtvd5HflFBghhydGxR1Fq8lLZuUwi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_10,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1011 mlxlogscore=849 lowpriorityscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120136
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "v" and "verbose" options in getopt grew an extra :, which breaks it.

$ ./run_tests.sh -v
getopt: option requires an argument -- v
$ ./run_tests.sh --verbose
getopt: option --verbose requires an argument

Remove the unnecessary :

Fixes: 15e441c4 ("run_tests: add list tests name option on command line")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 run_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index baf8e461..abb0ab77 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -44,7 +44,7 @@ fi
 
 only_tests=""
 list_tests=""
-args=$(getopt -u -o ag:htj:v:l -l all,group:,help,tap13,parallel:,verbose:,list -- $*)
+args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list -- $*)
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
-- 
2.41.0

