Return-Path: <kvm+bounces-7856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC66B84728E
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:05:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F14881C25E93
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA3C1468EB;
	Fri,  2 Feb 2024 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RkjRuu+g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B9814463E;
	Fri,  2 Feb 2024 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706886302; cv=none; b=u9g9rMjCX4drRHFT6AvxW6AcW21xNz8pO9IU/E22dD8Q+1dFCw3brzxcfidR4wYZRYnINkRAcJ3fUqb6+S7R9ShheO3gKYABDR3OdWdPOXE1yaDtiNdgac9Q/xuJT3dkDGIFb/IEx41xLQWrSv4jh7zFZ9SSM2D+JnCEq2sjYeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706886302; c=relaxed/simple;
	bh=IiP1DapoCYTLX94TDLO8I003YHeSMNoiEAnvhhKzTPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o5tDNR3XkJP+94FNo5chzVabq2JjY/zjBPZMFp13wQJSsJuYmPtWTfozRFvZzpv+ojFMxkVFnJOxbUOBbPiC8bS9E9IxY9sTO0iU/fcQsUCvcpUeGy0BDFpFxY9UDspiQczlnZOevOAjJtSn4De9ORvUNm/9X8hhs+GsyKnEX34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RkjRuu+g; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 412EQAln026156;
	Fri, 2 Feb 2024 15:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f0FWtmWoIIp/Jg0gGG+86/YfdxPjxR8tjIohKEC++YQ=;
 b=RkjRuu+gQV6ke0YOc9SCJngtCkTU9Lh8qmOuBfm8xLcvdeMP2eh5M/jwmcWple/Cvp0w
 nTxNdhzAZe20qP9nFXOE/0EVDv5qOTHAu/1cSwbkGXNlzUBZjvoFBZB5G+ZpOtdYDKf+
 RrRZu2M01osZm8cDMSyLD13pPqvvaIwNZHIQh1uCk/13V99mkVzanfF+mtI/I5P/CQfI
 dDPPdPZnIPwc9bLnRXXNIcc6lWEDTbsKc5E0LtSWhJZOhoBaMkmoInhA51iKM9FNQJbs
 K822HZxa8HdYudYciYv+K1fKBhHvtWp5qP6CrjVFrCiIwlp/hX7SySyN1/M9xiLAzNlI sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w11xrh807-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 412EQSkW027851;
	Fri, 2 Feb 2024 15:04:59 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w11xrh7yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 412CAAsq002319;
	Fri, 2 Feb 2024 15:04:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwc5tv76s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:58 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 412F4tFD39256666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Feb 2024 15:04:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6178920040;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F75220049;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Feb 2024 15:04:55 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 5/7] s390x: ap: Add reset tests
Date: Fri,  2 Feb 2024 14:59:11 +0000
Message-Id: <20240202145913.34831-6-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: eHxIy8wRR5zrLFhgCFCEl71WWkTcIynU
X-Proofpoint-GUID: AnbvCq2efQUda3dsGuPpH5PhD_Ss1Z_y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-02_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402020109

Test if the IRQ enablement is turned off on a reset or zeroize PQAP.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 71 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/ap.h |  4 +++
 s390x/ap.c     | 81 ++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 154 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index 4e7d3d34..0f92739d 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -125,6 +125,77 @@ int ap_pqap_qci(struct ap_config_info *info)
 	return cc;
 }
 
+static int pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		      bool zeroize)
+{
+	uint64_t bogus_cc = 2;
+	struct pqap_r0 r0 = {};
+	int cc;
+
+	/*
+	 * Reset/zeroize AP Queue
+	 *
+	 * Resets/zeroizes a queue and disables IRQs
+	 *
+	 * Inputs: GR0
+	 * Outputs: GR1 (APQSW)
+	 * Asynchronous
+	 */
+	r0.ap = ap;
+	r0.qn = qn;
+	r0.fc = zeroize ? PQAP_ZEROIZE_APQ : PQAP_RESET_APQ;
+	asm volatile(
+		"       tmll	%[bogus_cc],3\n"
+		"	lgr	0,%[r0]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	stg	1, %[apqsw]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [apqsw] "=&T" (*apqsw), [cc] "=&d" (cc)
+		: [r0] "d" (r0), [bogus_cc] "d" (bogus_cc)
+		: "memory");
+
+	return cc;
+}
+
+static int pqap_reset_wait(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+			   bool zeroize)
+{
+	struct pqap_r2 r2 = {};
+	int cc;
+
+	cc = pqap_reset(ap, qn, apqsw, zeroize);
+
+	/* On a cc == 3 / error we don't need to wait */
+	if (cc)
+		return cc;
+
+	/*
+	 * TAPQ returns AP_RC_RESET_IN_PROGRESS if a reset is being
+	 * processed
+	 */
+	do {
+		/* Give it some time to process before the retry */
+		mdelay(20);
+		cc = ap_pqap_tapq(ap, qn, apqsw, &r2);
+	} while (apqsw->rc == AP_RC_RESET_IN_PROGRESS);
+
+	if (apqsw->rc)
+		printf("Wait for reset failed on ap %d queue %d with tapq rc %d.",
+			ap, qn, apqsw->rc);
+	return cc;
+}
+
+int ap_pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw)
+{
+	return pqap_reset_wait(ap, qn, apqsw, false);
+}
+
+int ap_pqap_reset_zeroize(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw)
+{
+	return pqap_reset_wait(ap, qn, apqsw, true);
+}
+
 static int get_entry(uint8_t *ptr, int i, size_t len)
 {
 	/* Skip over the last entry */
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index 15394d56..dbdb55c4 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -14,6 +14,8 @@
 #ifndef _S390X_AP_H_
 #define _S390X_AP_H_
 
+#define AP_RC_RESET_IN_PROGRESS	0x02
+
 enum PQAP_FC {
 	PQAP_TEST_APQ,
 	PQAP_RESET_APQ,
@@ -108,6 +110,8 @@ enum {
 int ap_setup(uint8_t **ap_array, uint8_t **qn_array, uint8_t *naps, uint8_t *nqns);
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct pqap_r2 *r2);
+int ap_pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
+int ap_pqap_reset_zeroize(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
 int ap_pqap_qci(struct ap_config_info *info);
 int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct ap_qirq_ctrl aqic, unsigned long addr);
diff --git a/s390x/ap.c b/s390x/ap.c
index 6f95a716..38be03eb 100644
--- a/s390x/ap.c
+++ b/s390x/ap.c
@@ -13,6 +13,7 @@
 #include <bitops.h>
 #include <alloc_page.h>
 #include <malloc_io.h>
+#include <uv.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/time.h>
@@ -346,6 +347,80 @@ static void test_pqap_aqic(void)
 	free_io_mem(not_ind_byte, PAGE_SIZE);
 }
 
+static void test_pqap_resets(void)
+{
+	uint8_t *not_ind_byte = alloc_io_mem(sizeof(*not_ind_byte), 0);
+	struct ap_queue_status apqsw = {};
+	struct ap_qirq_ctrl aqic = {};
+	struct pqap_r2 r2 = {};
+
+	int cc;
+
+	report_prefix_push("rapq");
+
+	/* Enable IRQs which the resets will disable */
+	aqic.ir = 1;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)not_ind_byte);
+	report(cc == 0 && apqsw.rc == 0, "enable IRQs for reset tests");
+
+	do {
+		mdelay(20);
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	} while (cc == 0 && apqsw.irq_enabled == 0);
+	report(apqsw.irq_enabled == 1, "IRQs enabled tapq data");
+
+	ap_pqap_reset(apn, qn, &apqsw);
+	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	assert(!cc);
+	report(apqsw.irq_enabled == 0, "IRQs have been disabled via reset");
+
+	report_prefix_pop();
+
+	report_prefix_push("zapq");
+
+	/* Enable IRQs which the resets will disable */
+	aqic.ir = 1;
+	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)not_ind_byte);
+	report(cc == 0 && apqsw.rc == 0, "enable IRQs for reset tests");
+
+	do {
+		mdelay(20);
+		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	} while (cc == 0 && apqsw.irq_enabled == 0);
+	report(apqsw.irq_enabled == 1, "IRQs enabled tapq data");
+
+	ap_pqap_reset_zeroize(apn, qn, &apqsw);
+	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
+	assert(!cc);
+	report(apqsw.irq_enabled == 0, "IRQs have been disabled via reset");
+
+	report_prefix_pop();
+	/*
+	 * This is a wrinkle in the architecture for PV guests.
+	 *
+	 * The notification byte is pinned shared for PV guests.
+	 * RAPQ, ZAPQ and AQIC can all disable IRQs but there's no
+	 * intercept for resets triggered by a PV guests. Hence the
+	 * host keeps the notification byte page pinned UNTIL IRQs are
+	 * disabled via AQIC.
+	 *
+	 * Firmware will not generate an intercept if the IRQs have
+	 * already been disabled via a reset. Therefore we need to
+	 * enable AND disable to achieve a disable.
+	 */
+	if (uv_os_is_guest()) {
+		aqic.ir = 1;
+		cc = ap_pqap_aqic(apn, qn, &apqsw, aqic,
+				  (uintptr_t)not_ind_byte);
+		assert(cc == 0 && apqsw.rc == 0);
+		aqic.ir = 0;
+		cc = ap_pqap_aqic(apn, qn, &apqsw, aqic,
+				  (uintptr_t)not_ind_byte);
+		assert(cc == 0 && apqsw.rc == 0);
+	}
+	free_io_mem(not_ind_byte, sizeof(*not_ind_byte));
+}
+
 int main(void)
 {
 	uint8_t num_ap, num_qn;
@@ -372,10 +447,12 @@ int main(void)
 	apn = apns[0];
 	qn = qns[0];
 	report_prefix_push("pqap");
-	if (test_facility(65))
+	if (test_facility(65)) {
 		test_pqap_aqic();
-	else
+		test_pqap_resets();
+	} else {
 		report_skip("no AQIC and reset tests without IRQ support");
+	}
 	report_prefix_pop();
 
 done:
-- 
2.40.1


