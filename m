Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE5657CCDC
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiGUOHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiGUOHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E750D42AF1
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:16 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDVppW013272
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=d1aA7+wahOXoqyPy95It0jLCviNzB/rnMG5znQbo7kg=;
 b=sdE8r/sDbNWNsfIfpERY63v4/6iy+K00gCZ5rDC9W7hVv3UYWGcdH5zgzFjmJgBh8YXP
 g7IwB9dZA60iGmftch6rDUkoDiGkzD7+jsAewRTbUgjQWr+GrV5U8b48B7n58GRx+tkd
 r5l6TMO3WzXQsSTUTWZ8YZieq8MLJoVNm2a5TsU1HZnKK1KA/+90nPMuQWFdeSlCfnRJ
 mdAFKCmu9je27NK3aGRvUoszjTQmynUnzLsEd8lbfms9Duu+jci7DyswsvlDwG6GWFbj
 VXOhYbCJCmocnPubbAlcKeq4xYXIQP0FZsGS5qv40oDipCMPhnCkJ7GjuwM3KLQqcXAY LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7ry9453-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:16 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LE5fpA002853
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:12 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7ry93ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:12 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE755K011209;
        Thu, 21 Jul 2022 14:07:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3hbmkhsy9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE7FPZ32375262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 722FE4C040;
        Thu, 21 Jul 2022 14:07:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2792F4C050;
        Thu, 21 Jul 2022 14:07:02 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 02/12] s390x: lib: SOP facility query function
Date:   Thu, 21 Jul 2022 16:06:51 +0200
Message-Id: <20220721140701.146135-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4wdA3RnFJf9d3wEcrB2Llju0KQlgKVPv
X-Proofpoint-ORIG-GUID: vjYkZkEzRg5NDHWtPB0xYXBVxIkxMUUf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Add function returning which suppression-on-protection facility is
installed.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20220621143015.748290-3-scgl@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/facility.h | 21 +++++++++++++++++++++
 lib/s390x/sclp.h         |  4 ++++
 lib/s390x/sclp.c         |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index 49380203..a66fe56a 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -12,6 +12,7 @@
 #include <asm/facility.h>
 #include <asm/arch_def.h>
 #include <bitops.h>
+#include <sclp.h>
 
 #define NB_STFL_DOUBLEWORDS 32
 extern uint64_t stfl_doublewords[];
@@ -42,4 +43,24 @@ static inline void setup_facilities(void)
 		stfle(stfl_doublewords, NB_STFL_DOUBLEWORDS);
 }
 
+enum supp_on_prot_facility {
+	SOP_NONE,
+	SOP_BASIC,
+	SOP_ENHANCED_1,
+	SOP_ENHANCED_2,
+};
+
+static inline enum supp_on_prot_facility get_supp_on_prot_facility(void)
+{
+	if (sclp_facilities.has_esop) {
+		if (test_facility(131)) /* side-effect-access facility */
+			return SOP_ENHANCED_2;
+		else
+			return SOP_ENHANCED_1;
+	}
+	if (sclp_facilities.has_sop)
+		return SOP_BASIC;
+	return SOP_NONE;
+}
+
 #endif
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 3488f4d2..853529bf 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -123,7 +123,9 @@ struct sclp_facilities {
 	uint64_t has_cei : 1;
 
 	uint64_t has_diag318 : 1;
+	uint64_t has_sop : 1;
 	uint64_t has_gsls : 1;
+	uint64_t has_esop : 1;
 	uint64_t has_cmma : 1;
 	uint64_t has_64bscao : 1;
 	uint64_t has_esca : 1;
@@ -134,7 +136,9 @@ struct sclp_facilities {
 };
 
 /* bit number within a certain byte */
+#define SCLP_FEAT_80_BIT_SOP		2
 #define SCLP_FEAT_85_BIT_GSLS		0
+#define SCLP_FEAT_85_BIT_ESOP		6
 #define SCLP_FEAT_98_BIT_KSS		7
 #define SCLP_FEAT_116_BIT_64BSCAO	0
 #define SCLP_FEAT_116_BIT_CMMA		1
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index b8204c5f..e6017f64 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -152,7 +152,9 @@ void sclp_facilities_setup(void)
 	cpu = sclp_get_cpu_entries();
 	if (read_info->offset_cpu > 134)
 		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+	sclp_facilities.has_sop = sclp_feat_check(80, SCLP_FEAT_80_BIT_SOP);
 	sclp_facilities.has_gsls = sclp_feat_check(85, SCLP_FEAT_85_BIT_GSLS);
+	sclp_facilities.has_esop = sclp_feat_check(85, SCLP_FEAT_85_BIT_ESOP);
 	sclp_facilities.has_kss = sclp_feat_check(98, SCLP_FEAT_98_BIT_KSS);
 	sclp_facilities.has_cmma = sclp_feat_check(116, SCLP_FEAT_116_BIT_CMMA);
 	sclp_facilities.has_64bscao = sclp_feat_check(116, SCLP_FEAT_116_BIT_64BSCAO);
-- 
2.36.1

