Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3FB51BFBE
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 14:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377697AbiEEMus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 08:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbiEEMup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 08:50:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9D64B874;
        Thu,  5 May 2022 05:47:06 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245CUEMZ024893;
        Thu, 5 May 2022 12:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SKXRTMt1x4e2INCCED82LImTmULmQXdinkTbOAi/nSk=;
 b=hOFIW/u3j3DS7owaBXU716uIWeEpwRkmmrxmtGa4UsaFjyDPy2kuf7133Kn9rWO9xStF
 FBDFwAWE5Rjm8mEzwvUjzi1+5YbLv912Nltk1v2KbzY6vSh4HyNKVSvTalbYlVlyeiEs
 C3zxYIR7mRYu6/zoIpA8ClitGnkKXvb6yObFK9ZTGQruBgEOhfoywdnbhRKUhAYkEwdL
 dgTWKnBG+mg6uLpSJKdEkxFvGYsgt3pEJ+xk581QlryO9AjBNzegptKoUwARkR5FUA09
 wjiac6EQBEZbcCmI97ssFYAHfnRWStanvOz9+rcOxiprxFzh4vdj09mjmIC6tH4yMzEX 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fven509ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:47:05 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 245CZTMK012495;
        Thu, 5 May 2022 12:47:04 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fven509r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:47:04 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245CiB8l027356;
        Thu, 5 May 2022 12:47:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3fttcj33ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:47:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245CksIo26476820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 12:46:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3346342045;
        Thu,  5 May 2022 12:46:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D531A42041;
        Thu,  5 May 2022 12:46:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 12:46:58 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/3] s390x: Fix sclp facility bit numbers
Date:   Thu,  5 May 2022 14:46:54 +0200
Message-Id: <20220505124656.1954092-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220505124656.1954092-1-scgl@linux.ibm.com>
References: <20220505124656.1954092-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xVAC7ExXh606VheaKCNzV0p0l0o8QJKf
X-Proofpoint-GUID: fcbG-mmOKIySIE2x2Mc88vE2NzKKXzpH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_05,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sclp_feat_check takes care of adjusting the bit numbering such that they
can be defined as they are in the documentation.

Fixes: 4dd649c8 ("lib: s390x: sclp: Extend feature probing")
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/sclp.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index fead007a..4ce2209f 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -134,13 +134,15 @@ struct sclp_facilities {
 };
 
 /* bit number within a certain byte */
-#define SCLP_FEAT_85_BIT_GSLS		7
-#define SCLP_FEAT_98_BIT_KSS		0
-#define SCLP_FEAT_116_BIT_64BSCAO	7
-#define SCLP_FEAT_116_BIT_CMMA		6
-#define SCLP_FEAT_116_BIT_ESCA		3
-#define SCLP_FEAT_117_BIT_PFMFI		6
-#define SCLP_FEAT_117_BIT_IBS		5
+#define SCLP_FEAT_80_BIT_SOP		2
+#define SCLP_FEAT_85_BIT_GSLS		0
+#define SCLP_FEAT_85_BIT_ESOP		6
+#define SCLP_FEAT_98_BIT_KSS		7
+#define SCLP_FEAT_116_BIT_64BSCAO	0
+#define SCLP_FEAT_116_BIT_CMMA		1
+#define SCLP_FEAT_116_BIT_ESCA		4
+#define SCLP_FEAT_117_BIT_PFMFI		1
+#define SCLP_FEAT_117_BIT_IBS		2
 
 typedef struct ReadInfo {
 	SCCBHeader h;
-- 
2.33.1

