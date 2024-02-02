Return-Path: <kvm+bounces-7859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BB0847290
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:05:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D7911F2C24B
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5AC1468FB;
	Fri,  2 Feb 2024 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TlaThN+h"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5093314460C;
	Fri,  2 Feb 2024 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706886302; cv=none; b=nc2C88/YSvER1xflZXX5nHbOmcayiAOBnfw18jLcisx828pP2t1Sa/ywTKyx8gFhGYTXQ5EIqARO9WFg8ppX9mnMoLwvB3ySzl35L/oXvzdTLM7PgtFH5qR/NJ6zmJZ2WfNQP/fTDHHoJVIlfy8LIZdSjAr+5jz2zVUDwTLmP0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706886302; c=relaxed/simple;
	bh=5DykbETaFC8/kXeuRlJdARzFuxa9jHVckC26OSsoB1g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mvd1ddIsWEF5FAYKr+5a1Psj0bq9OGc7Lt0hrgB5Kf3NMT6cQ88tyeHzGGS+D8Vz9SGSqb6vmT2HTXvwZvUZgO0Daeq9O0dBK+qmoE0vIyxwpC2nTRX9NDVopc9XxsnVl9dptdpsd2gmLdf30CJ19myzIVdpR1Leg8SsueYOzLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TlaThN+h; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 412ESufP031624;
	Fri, 2 Feb 2024 15:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G+LQT30CZNgtSLOdDA0EJOZIFJnT7ca3g4mM8ucJEu4=;
 b=TlaThN+h2UNKzplTz6ARxNFwLgFpb960ySYN4Vwbcry2UTP6fYUHK5y7YS+mfj+9Efku
 GVySyAUnoZp/K0MhvmdmZWKXFTSLTp5UiHsF4dxgIcoAuVdCDr8DkNO0Q75zV4sz7Oxt
 557YCd2NT4oMEnPoU8Xx2v4DagkDiPsK7f4hKGOaJ980b7PlsCfMdHLyCAu+8nLZEGFX
 +sY8S26OF62606l+EpUwiydIAQ4LICdDzOgDz0LpVEXYWtrQr94b3pdHsB+78xAuhbOi
 I6eECWKUUNDsvQAohWVE9uEHe2hW9nPOUFHYlKTtrK2f5oPWCJ08Dx9sFLgKnmLirNN3 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w126h8v4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 412EtDiI030218;
	Fri, 2 Feb 2024 15:04:59 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w126h8v42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 412E7SAx011266;
	Fri, 2 Feb 2024 15:04:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwecm3nrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:58 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 412F4toG39256668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Feb 2024 15:04:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A5AA20040;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 689C12004B;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 6/7] lib: s390x: ap: Add tapq test facility bit
Date: Fri,  2 Feb 2024 14:59:12 +0000
Message-Id: <20240202145913.34831-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240202145913.34831-1-frankja@linux.ibm.com>
References: <20240202145913.34831-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UIX90UWWKwA_bF8mJ_khizgpaPTfjxm6
X-Proofpoint-ORIG-GUID: kXfGID948-HF8jlQuVwW_YG5th6n64GG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-02_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402020109

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
index 0f92739d..64705a56 100644
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
 	uint64_t bogus_cc = 2;
@@ -177,7 +178,7 @@ static int pqap_reset_wait(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw
 	do {
 		/* Give it some time to process before the retry */
 		mdelay(20);
-		cc = ap_pqap_tapq(ap, qn, apqsw, &r2);
+		cc = ap_pqap_tapq(ap, qn, apqsw, &r2, false);
 	} while (apqsw->rc == AP_RC_RESET_IN_PROGRESS);
 
 	if (apqsw->rc)
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index dbdb55c4..eecb39be 100644
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
index 38be03eb..0f2d03c2 100644
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
2.40.1


