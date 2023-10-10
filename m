Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291417BF67D
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjJJIvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjJJIvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:51:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34BFCA
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:51:21 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8k177020233
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LdSTOCRF/Y2mm7f4UJzdgFcO5CKZJDr3FoCQzhucFNA=;
 b=fTsEYFwIfUvvAmfimWjj9k32CxiLboTlr6yI/wZNHLwas6qJnRMGUZ1B2wNm61DU+ISr
 C4Ti8jYyysrXqcBRJ4FyK5vm+e2s1ei/U6Lfi/xZbZrrgHz8N0vVXAkEOjHxGkCuX1uk
 ayrAEA09ZCyysMsbHoh5AmWsZv5nkF/TZcHLrOPCGpnosUZErua1dY3fEW9hkdviam1p
 DAlB2oTux1fxNS+1/sgGLs9XEmWstlstIEPBYAiQscBlA73Rn6UpRjkYlwRH8KSRy3dj
 l0GR6Pb53bcUOI4X0zTP2kTOpgyX5K4SNITyLSCclirwVcUeqX61ZK2lDUQ3WNOnGKq4 sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3ct08b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:19 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8lKho024659
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:14 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3ct080f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:14 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6i0PK023094;
        Tue, 10 Oct 2023 08:51:09 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1enkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8p6mo17105600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:51:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F85A2004D;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5419320043;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 6/7] lib: s390x: ap: Add tapq test facility bit
Date:   Tue, 10 Oct 2023 08:49:35 +0000
Message-Id: <20231010084936.70773-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010084936.70773-1-frankja@linux.ibm.com>
References: <20231010084936.70773-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Y4RUb4D08YK1PDWpNQcuPtbK6rJRH3du
X-Proofpoint-GUID: raqMieL2CL6EHOrXkhIdA2Ssml6_zKO8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 phishscore=0
 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the t bit is one the first 32 bits of register 2 are populated on
a tapq. Those bits tell us in which mode the queu is and which
facilities it supports.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c |  5 +++--
 lib/s390x/ap.h |  2 +-
 s390x/ap.c     | 12 ++++++------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index c1acfda8..fbc33227 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -26,11 +26,12 @@ static uint8_t *array_queue;
 static struct ap_config_info qci;
 
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
-		 struct pqap_r2 *r2)
+		 struct pqap_r2 *r2, bool t)
 {
 	struct pqap_r0 r0 = {
 		.ap = ap,
 		.qn = qn,
+		.t = t,
 		.fc = PQAP_TEST_APQ
 	};
 	int cc;
@@ -169,7 +170,7 @@ static int pqap_reset_wait(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw
 	do {
 		/* Give it some time to process before the retry */
 		mdelay(20);
-		cc = ap_pqap_tapq(ap, qn, apqsw, &r2);
+		cc = ap_pqap_tapq(ap, qn, apqsw, &r2, false);
 	} while (apqsw->rc == AP_RC_RESET_IN_PROGRESS);
 
 	if (apqsw->rc)
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index e037a974..17f8016d 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -109,7 +109,7 @@ enum {
 
 int ap_setup(uint8_t **ap_array, uint8_t **qn_array, uint8_t *naps, uint8_t *nqns);
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
-		 struct pqap_r2 *r2);
+		 struct pqap_r2 *r2, bool t);
 int ap_pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
 int ap_pqap_reset_zeroize(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
 int ap_pqap_qci(struct ap_config_info *info);
diff --git a/s390x/ap.c b/s390x/ap.c
index 0ae2809e..05664df8 100644
--- a/s390x/ap.c
+++ b/s390x/ap.c
@@ -325,7 +325,7 @@ static void test_pqap_aqic(void)
 
 	do {
 		mdelay(20);
-		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2, false);
 	} while (cc == 0 && apqsw.irq_enabled == 0);
 	report(cc == 0 && apqsw.irq_enabled == 1, "enable IRQs tapq data");
 
@@ -338,7 +338,7 @@ static void test_pqap_aqic(void)
 
 	do {
 		mdelay(20);
-		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2, false);
 	} while (cc == 0 && apqsw.irq_enabled == 1);
 	report(cc == 0 && apqsw.irq_enabled == 0, "disable IRQs tapq data");
 
@@ -365,12 +365,12 @@ static void test_pqap_resets(void)
 
 	do {
 		mdelay(20);
-		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2, false);
 	} while (cc == 0 && apqsw.irq_enabled == 0);
 	report(apqsw.irq_enabled == 1, "IRQs enabled tapq data");
 
 	ap_pqap_reset(apn, qn, &apqsw);
-	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2, false);
 	assert(!cc);
 	report(apqsw.irq_enabled == 0, "IRQs have been disabled via reset");
 
@@ -385,12 +385,12 @@ static void test_pqap_resets(void)
 
 	do {
 		mdelay(20);
-		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2, false);
 	} while (cc == 0 && apqsw.irq_enabled == 0);
 	report(apqsw.irq_enabled == 1, "IRQs enabled tapq data");
 
 	ap_pqap_reset_zeroize(apn, qn, &apqsw);
-	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2, false);
 	assert(!cc);
 	report(apqsw.irq_enabled == 0, "IRQs have been disabled via reset");
 
-- 
2.34.1

