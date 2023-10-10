Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BDA7BF67F
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjJJIvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjJJIvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:51:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6527A9
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:51:34 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8k03D029396
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pCXKqhroo1R74007BzXirT9D10PJ63HJpGA2GrsKIJs=;
 b=GLai0QSXnaKr1CBgZlMSIiuQ2g4chdfXHkLqkTCkmm5zcQGwp7SeRHk3M6vJrDc2J2kl
 5N+RmJeQycbrKSQojcobHo/KRZ80ics4ySb+H2vnWY0g6bkcYXEuVGBomRnSyLxuxWEV
 4IBAM2vgk0glc1ZywB4uMdaZLuxXGnG5kFdaO7YK343jV30ZjwY7bPXvmJvmRC8QV/64
 28LwiovuxnagsE9seo4yjUtI0WhCBqB5utpXCKVJ4h7UgabkwE+wmSsNJoELObh7nQFe
 +Txj5VSphUAHbd4CaXWjHDHwVrOLGx/1vOvYZbtyWI1l5gCxulruGwAeYtWXOsC4SOMK Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cug8t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:32 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8k1I6029454
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:17 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3cug82u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:17 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A5xSwr000653;
        Tue, 10 Oct 2023 08:51:10 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkk5kf01m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8p5xX6554118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:51:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D95D320040;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE3602004F;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/7] lib: s390x: ap: Add ap_setup
Date:   Tue, 10 Oct 2023 08:49:32 +0000
Message-Id: <20231010084936.70773-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010084936.70773-1-frankja@linux.ibm.com>
References: <20231010084936.70773-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NzL0QB53UTM5ANkZ2H6uQT0RaL-eVMzv
X-Proofpoint-ORIG-GUID: 6YYKBBLwHVrkJmn_LZ-NRr3ZMUka5qGs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=894 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the next tests we need a valid queue which means we need to grab
the qci info and search the first set bit in the ap and aq masks.

Let's move from the ap_check function to a proper setup function that
also returns arrays for the aps and qns.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++--
 lib/s390x/ap.h | 17 +++++++++-
 s390x/ap.c     |  4 ++-
 3 files changed, 105 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index 4af3cdee..9ba5a037 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -13,10 +13,18 @@
 
 #include <libcflat.h>
 #include <interrupt.h>
+#include <alloc.h>
+#include <bitops.h>
 #include <ap.h>
 #include <asm/time.h>
 #include <asm/facility.h>
 
+static uint8_t num_ap;
+static uint8_t num_queue;
+static uint8_t *array_ap;
+static uint8_t *array_queue;
+static struct ap_config_info qci;
+
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct pqap_r2 *r2)
 {
@@ -78,15 +86,90 @@ int ap_pqap_qci(struct ap_config_info *info)
 	return cc;
 }
 
-bool ap_check(void)
+static int get_entry(uint8_t *ptr, int i, size_t len)
 {
+	/* Skip over the last entry */
+	if (i)
+		i++;
+
+	for (; i < 8 * len; i++) {
+		/* Do we even need to check the byte? */
+		if (!ptr[i / 8]) {
+			i += 7;
+			continue;
+		}
+
+		/* Check the bit in big-endian order */
+		if (ptr[i / 8] & BIT(7 - (i % 8)))
+			return i;
+	}
+	return -1;
+}
+
+static void setup_info(void)
+{
+	int i, entry = 0;
+
+	ap_pqap_qci(&qci);
+
+	for (i = 0; i < AP_ARRAY_MAX_NUM; i++) {
+		entry = get_entry((uint8_t *)qci.apm, entry, sizeof(qci.apm));
+		if (entry == -1)
+			break;
+
+		if (!num_ap) {
+			/*
+			 * We have at least one AP, time to
+			 * allocate the queue arrays
+			 */
+			array_ap = malloc(AP_ARRAY_MAX_NUM);
+			array_queue = malloc(AP_ARRAY_MAX_NUM);
+		}
+		array_ap[num_ap] = entry;
+		num_ap += 1;
+	}
+
+	/* Without an AP we don't even need to look at the queues */
+	if (!num_ap)
+		return;
+
+	entry = 0;
+	for (i = 0; i < AP_ARRAY_MAX_NUM; i++) {
+		entry = get_entry((uint8_t *)qci.aqm, entry, sizeof(qci.aqm));
+		if (entry == -1)
+			return;
+
+		array_queue[num_queue] = entry;
+		num_queue += 1;
+	}
+
+}
+
+int ap_setup(uint8_t **ap_array, uint8_t **qn_array, uint8_t *naps, uint8_t *nqns)
+{
+	assert(!num_ap);
+
 	/*
 	 * Base AP support has no STFLE or SCLP feature bit but the
 	 * PQAP QCI support is indicated via stfle bit 12. As this
 	 * library relies on QCI we bail out if it's not available.
 	 */
 	if (!test_facility(12))
-		return false;
+		return AP_SETUP_NOINSTR;
 
-	return true;
+	/* Setup ap and queue arrays */
+	setup_info();
+
+	if (!num_ap)
+		return AP_SETUP_NOAPQN;
+
+	/* Only provide the data if the caller actually needs it. */
+	if (ap_array && qn_array && naps && nqns) {
+		*ap_array = array_ap;
+		*qn_array = array_queue;
+		*naps = num_ap;
+		*nqns = num_queue;
+	}
+
+	return AP_SETUP_READY;
 }
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index 411591f2..ac9e59d1 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -81,7 +81,22 @@ struct pqap_r2 {
 } __attribute__((packed))  __attribute__((aligned(8)));
 _Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 size");
 
-bool ap_check(void);
+/*
+ * Maximum number of APQNs that we keep track of.
+ *
+ * This value is already way larger than the number of APQNs a AP test
+ * is probably going to use.
+ */
+#define AP_ARRAY_MAX_NUM	16
+
+/* Return values of ap_setup() */
+enum {
+	AP_SETUP_NOINSTR,	/* AP instructions not available */
+	AP_SETUP_NOAPQN,	/* Instructions available but no APQNs */
+	AP_SETUP_READY		/* Full setup complete, at least one APQN */
+};
+
+int ap_setup(uint8_t **ap_array, uint8_t **qn_array, uint8_t *naps, uint8_t *nqns);
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct pqap_r2 *r2);
 int ap_pqap_qci(struct ap_config_info *info);
diff --git a/s390x/ap.c b/s390x/ap.c
index 94f08783..32feb8db 100644
--- a/s390x/ap.c
+++ b/s390x/ap.c
@@ -292,8 +292,10 @@ static void test_priv(void)
 
 int main(void)
 {
+	int setup_rc = ap_setup(NULL, NULL, NULL, NULL);
+
 	report_prefix_push("ap");
-	if (!ap_check()) {
+	if (setup_rc == AP_SETUP_NOINSTR) {
 		report_skip("AP instructions not available");
 		goto done;
 	}
-- 
2.34.1

