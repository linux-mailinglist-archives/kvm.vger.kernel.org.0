Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECCA52F3AD
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 21:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353186AbiETTJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 15:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353181AbiETTI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 15:08:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DF8197F71;
        Fri, 20 May 2022 12:08:59 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHTE5R025679;
        Fri, 20 May 2022 19:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mRub4IWEXFD4hNE21cse1PB3hfdM86BVch8hDdJ4phM=;
 b=GsYG0YjHiawLaFCSomexU1xcJ2oPnzaG8OfLgbDiX+/jsb++Bpl96a5RNrrP7NuFnGvf
 NO623vn8YWvvdeCDnuGQDznPrPyxFs66NoBuszcdXXAD/W5qUTWlPQgjx1YlVinaRowq
 Eq4tupmuOGyD4PU9wuBPZLIKhZdw6loocZ1SG4YizsnKFXHCnBsC5Fblr1wcv/J7hMBP
 J9oEkMVsRDqHgXjSFei6ofMyoK0ybkuiXZOGjHzUhP/FqhS6SvYTocBY8VrK+WRWtj0d
 6L6AIzvI397hHkJlRcNGzaCN70Il9tGDznKD6CXCoRIITV4t666AyucEJhCckixX7+Zs JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6fe49n1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:58 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24KIpaMI029972;
        Fri, 20 May 2022 19:08:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6fe49n0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24KIqsd9018160;
        Fri, 20 May 2022 19:08:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjh8ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24KJ8CcO34210146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 19:08:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 722B1AE056;
        Fri, 20 May 2022 19:08:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39CFEAE051;
        Fri, 20 May 2022 19:08:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 May 2022 19:08:52 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/3] s390x: lib: SOP facility query function
Date:   Fri, 20 May 2022 21:08:49 +0200
Message-Id: <20220520190850.3445768-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220520190850.3445768-1-scgl@linux.ibm.com>
References: <20220520190850.3445768-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 83xbipFSM5kfZ8iev-gAFf90lrBzPAyw
X-Proofpoint-ORIG-GUID: JZWvXVh7OC6zZrgKZbr1GoTzdne8D6ut
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add function returning which suppression-on-protection facility is
installed.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
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
2.33.1

