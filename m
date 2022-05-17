Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4852A0E0
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345815AbiEQL4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbiEQL4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:56:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D638659B;
        Tue, 17 May 2022 04:56:16 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBK032009385;
        Tue, 17 May 2022 11:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IYMfG2hBnWKAecfsfCY24FeaFZr0/SNd8OolgTumZRc=;
 b=ZuSKiXWslto2vQJ100X3LoCPeHIFqSr6rEsTiM7pKyT9iZj96ziDCDj2DZI/TkwjK1dt
 vhMWa3DRwFO0wwfNYFW/T5d8XO/8zDTgQPAkO+mrsz87jEHdv9AIq3lcZN0gwuhYYGAL
 6OO/0W4B7NIaiLVNjL6dQdjQwJ1O/cf2kPuMAYhE06T+sYVizR9jv8vi/bpP/2cdf8Do
 kqeFSRhPnHwjSJThe73SSRSoE4tAMJBIiySkI5QAXzKor38+bKO3xS4zkoo7nYoLzloW
 BwTx4uE1yHMGbw+EuiAg6OZo8rkG4cPuE/cc9Dfd380L2VBVyEcnakYDtcqczrxivO/F Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4ar78q91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:15 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBir7o012250;
        Tue, 17 May 2022 11:56:15 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4ar78q8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBrWp7024034;
        Tue, 17 May 2022 11:56:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429c5t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBuAaI45351276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:56:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F31E3A4040;
        Tue, 17 May 2022 11:56:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6C4BA4053;
        Tue, 17 May 2022 11:56:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:56:09 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/4] s390x: Fix sclp facility bit numbers
Date:   Tue, 17 May 2022 13:56:04 +0200
Message-Id: <20220517115607.3252157-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220517115607.3252157-1-scgl@linux.ibm.com>
References: <20220517115607.3252157-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RuQU3iJApqmC0_jU4sLDTFpz5FAY9rKi
X-Proofpoint-GUID: dB8wPZYgdJZuMSvLi64hRF9Ei6VfqFkf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170069
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

