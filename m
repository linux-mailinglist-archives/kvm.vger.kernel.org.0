Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFDF553482
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 16:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351689AbiFUOah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 10:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351613AbiFUOa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 10:30:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ABC2458D;
        Tue, 21 Jun 2022 07:30:26 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LDgCIc005640;
        Tue, 21 Jun 2022 14:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0Q5UYIwF5ly0b7pyqcge96hyM5xJ2K9S9RsNxhjgg5k=;
 b=WftSWmjtXunOXlnvjl8N/Lm4LI2Y7Otp/Wz5Bof0uSMWPfUdsAICFDoCdRgtXBkxDter
 buIlTLmB+O0Z7q/9xTWcrb8rnSRMIY2sH03HcTfEuCsP7LVq412ddqHxliHCTZZULx71
 JizxUYwyCcPbj4nuUQjJl1kpVrmAcj6pQNF6pD1Ys0jEQ5Br/P7qKyDdFUPshoDNtj82
 D7qcK4bqHKrHFshJdgHrzywywD1HduTPjV/XBmhzohoTY2SaXMs7dX4nOr9DRGYRipfE
 jpszdaRieLoGAPTm7QitCjHq6fEmiO1IUQdOk5AFs19m49x7tk6gI6ipwDk2WGDpnX2l EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3guf3qswhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:25 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LDgqNs011996;
        Tue, 21 Jun 2022 14:30:25 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3guf3qswg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:25 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LELS6W007042;
        Tue, 21 Jun 2022 14:30:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3gs6b8kaab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LEUI5t17105176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 14:30:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50A1F4C04E;
        Tue, 21 Jun 2022 14:30:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0531E4C04A;
        Tue, 21 Jun 2022 14:30:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 14:30:17 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 2/3] s390x: lib: SOP facility query function
Date:   Tue, 21 Jun 2022 16:30:14 +0200
Message-Id: <20220621143015.748290-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220621143015.748290-1-scgl@linux.ibm.com>
References: <20220621143015.748290-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AljV_VhJESCELE-TwRyWV1pg34Ycdj4c
X-Proofpoint-GUID: 6aSiBgSO9nz9yZpyl990jHnSZ-QfaeQ1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_06,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210062
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
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

