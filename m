Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B407BF679
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjJJIvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjJJIvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:51:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB67A9
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:51:32 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8k2t6029578
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CTl8DNNTGZiI+7wsYVwnp0pnAMahQ58kmrxPgViAuoc=;
 b=i1U6nKIBwwNnh4UD/M/vkhuybRO8o4w1AfJpxKnYvm0ENBRBcACLyi6s+K4IRJzJwWEK
 qqEjJxSTO4CiM1zA1FedVSSEvcX3a5QQg+eOKjJPSByOhwJ9E3vQgwPgudr8OgiJf6uA
 UtawZqXZo5b+jDAWiDzd1UTdEzbOxELpHvOqkrFTaePzPzPSsbIXsT6YrxmAN5LP+e+F
 8DmxXPdn91uhn35CxCRnYfK6Hg4Psw7f4swAwnwr5Si4SSCTpHlC+Wxyt5UK1fIGS4Sk
 7FYc5Dii5laDQFJXCPPfEm+sg7pONY+Jp3rpSZVU0cpupDY7Bopi2GsNhMQGwF2jgQIT Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cug91s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:30 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8lU0n003314
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:23 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cug876-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:22 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6D39x001150;
        Tue, 10 Oct 2023 08:51:10 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkkvjpru2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:10 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8p6rh14418582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:51:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B85120040;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20DE62004F;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:51:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/7] s390x: ap: Add reset tests
Date:   Tue, 10 Oct 2023 08:49:34 +0000
Message-Id: <20231010084936.70773-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010084936.70773-1-frankja@linux.ibm.com>
References: <20231010084936.70773-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hXHEeRSjTXux-mH8ZODMD1-kljxN762H
X-Proofpoint-ORIG-GUID: TLVsPUcLbRUj7sBSHZiDby_MsoRQOKdy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

