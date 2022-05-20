Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB4252F3B0
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 21:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353190AbiETTJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 15:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353179AbiETTI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 15:08:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B17E197F69;
        Fri, 20 May 2022 12:08:58 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIw1Nj015061;
        Fri, 20 May 2022 19:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IYMfG2hBnWKAecfsfCY24FeaFZr0/SNd8OolgTumZRc=;
 b=rPWhXByw8gkDh8hF5RZQsO2i630fVadbgncjLMVLMS4jBsMdqpD4lqqkPtqFvINpVobp
 ygOgq5d4tKaOY4RB4FsEtzz11C+XH1vEdbKe6Bct37xITt477Y8C+KohLHkFGH8h+R4u
 5JmVx0nOaBZB3BOQr4CFC+LFAZQMvTXsoNSfi/3Sxg0ulR0qChlSIa+kVsqzjg2gn/Mp
 Vz0deUeX+czPWZpKvsAYBMHkCgyb0fXHdYW5HIsZCwF5sgN4iwNvPUtbayCab3+UPpqy
 t/XWzaRUvh2oODKEZ1UdCCwRJ9+llsvmIhgJgVEjOUTBqKkQ+LhJaqFaXnXeFQ6Jtnoe iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6gqwg79x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:58 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24KJ06mB024981;
        Fri, 20 May 2022 19:08:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6gqwg799-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24KIrSeE024556;
        Fri, 20 May 2022 19:08:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428yhdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24KJ8BUV34210142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 19:08:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F78EAE04D;
        Fri, 20 May 2022 19:08:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0EFDAE057;
        Fri, 20 May 2022 19:08:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 May 2022 19:08:51 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/3] s390x: Fix sclp facility bit numbers
Date:   Fri, 20 May 2022 21:08:48 +0200
Message-Id: <20220520190850.3445768-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220520190850.3445768-1-scgl@linux.ibm.com>
References: <20220520190850.3445768-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UPRrs6-7RsToqQFujpGspSGMy5xns1k7
X-Proofpoint-GUID: 7lKocxip5V4zYk3YQAx_NeJlqvgNy7Ko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sclp_feat_check takes care of adjusting the bit numbering such that they
can be defined as they are in the documentation.

Fixes: 4dd649c8 ("lib: s390x: sclp: Extend feature probing")
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index e48a5a3d..3488f4d2 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -134,13 +134,13 @@ struct sclp_facilities {
 };
 
 /* bit number within a certain byte */
-#define SCLP_FEAT_85_BIT_GSLS		7
-#define SCLP_FEAT_98_BIT_KSS		0
-#define SCLP_FEAT_116_BIT_64BSCAO	7
-#define SCLP_FEAT_116_BIT_CMMA		6
-#define SCLP_FEAT_116_BIT_ESCA		3
-#define SCLP_FEAT_117_BIT_PFMFI		6
-#define SCLP_FEAT_117_BIT_IBS		5
+#define SCLP_FEAT_85_BIT_GSLS		0
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

