Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569EF54316D
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbiFHNdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240150AbiFHNdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:33:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB70A6359;
        Wed,  8 Jun 2022 06:33:11 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258DDXeF014446;
        Wed, 8 Jun 2022 13:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IYMfG2hBnWKAecfsfCY24FeaFZr0/SNd8OolgTumZRc=;
 b=LqKtOtYhDmTRY2hpDU6nh4MwFQgIe2az/LXyzO7agiLeDNlRJzPLpkfpw9h+uFJhd5Uk
 mC08dWChXx1rOWwieU1EuDUPY6HIeLG+EGRXrWfd1r9FXOy9vA/jhVv6/ghiPQyje1SD
 8pjiyFexdhQe7CT19BzUFcm1Lz8w5Tktq3L2HAzbUdLM5AU0mhPWnv4M48icdE3hjYMd
 /JyzYVK+Z30Xu5q9VPg5qq3szR7Q/3V/WVz0yw7U35IYFD7eXBv0NuQ5wLFMydYBdMqV
 lIzz60eZYd4xxZRRHfyR9ExPBkVCR5hBWn57lSD33lJ0+9SKisnQ4gikYnMicoa0DZt9 eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjvf68ev5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:33:11 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258DP4GP029010;
        Wed, 8 Jun 2022 13:33:10 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjvf68eu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:33:10 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258DKOBd014993;
        Wed, 8 Jun 2022 13:33:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3gfy19c62n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:33:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258DX53921627140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 13:33:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4337211C04C;
        Wed,  8 Jun 2022 13:33:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F29DC11C054;
        Wed,  8 Jun 2022 13:33:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 13:33:04 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/3] s390x: Fix sclp facility bit numbers
Date:   Wed,  8 Jun 2022 15:33:01 +0200
Message-Id: <20220608133303.1532166-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608133303.1532166-1-scgl@linux.ibm.com>
References: <20220608133303.1532166-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jsZdNVql8VbcxBpRlndAgFJGWgbZA7OV
X-Proofpoint-ORIG-GUID: uZ7_N3pGzcQV7-yh2mN6gPyw09NpeS0W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080058
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

