Return-Path: <kvm+bounces-1969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2992A7EF50E
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:20:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8931C20AE3
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AADDA3DB93;
	Fri, 17 Nov 2023 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NuJVq5oc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16407D5F;
	Fri, 17 Nov 2023 07:20:02 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFAxqV032757;
	Fri, 17 Nov 2023 15:20:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CTl8DNNTGZiI+7wsYVwnp0pnAMahQ58kmrxPgViAuoc=;
 b=NuJVq5oc90j+7QkWke700A38KC6OF8Hx+7SPEz81rHxQkh15BB+cmquJtiCv4hrldTaj
 wrs4tfy1dpAsBrhRzrurWF9viSZ+7QkcL5xTqVr2b8HcfNB9qb6LIP1HeRwY9AFutt7c
 G3WsQtxyPQHSHnmKGaZuOFA2BbSV8niHOayog8BpzERE4+8Hdac9fK6ip3jet4k50MMs
 oYnzc41EEK782rp+utT2oT4JWfRhO3h1Ys6fGuFiUGeZ/xegGW6enC55WYT5RQHs2WQz
 gew2iNTUVhcBN5yMKG4vHV5nCSn92OK8F0Iua3yHp0h5w4BW0RMzViWinaQLthLplGWX kA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueaah8yqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:20:01 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHFBJJl002315;
	Fri, 17 Nov 2023 15:20:00 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueaah8ynw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:20:00 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHD41xG023035;
	Fri, 17 Nov 2023 15:19:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uapn26cu0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHFJuAh262728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 15:19:56 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 665C320040;
	Fri, 17 Nov 2023 15:19:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 275D32004D;
	Fri, 17 Nov 2023 15:19:56 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 15:19:56 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 5/7] s390x: ap: Add reset tests
Date: Fri, 17 Nov 2023 15:19:37 +0000
Message-Id: <20231117151939.971079-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231117151939.971079-1-frankja@linux.ibm.com>
References: <20231117151939.971079-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sq5NOB5Vf1V8MIPycKz-N2WWeE-9Lx23
X-Proofpoint-GUID: ISZj7PeS0EHMa2ibFsDx5k57MoXrqZ84
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_14,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311170114

Test if the IRQ enablement is turned off on a reset or zeroize PQAP.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 69 ++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/ap.h |  4 +++
 s390x/ap.c     | 81 ++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index 23338c2d..c1acfda8 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -119,6 +119,75 @@ int ap_pqap_qci(struct ap_config_info *info)
 	return cc;
 }
 
+static int pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
+		      bool zeroize)
+{
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
+		"	lgr	0,%[r0]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		"	stg	1, %[apqsw]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [apqsw] "=&T" (*apqsw), [cc] "=&d" (cc)
+		: [r0] "d" (r0)
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
index 7a91881d..e037a974 100644
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
index 8ea2b52e..0ae2809e 100644
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
2.34.1


