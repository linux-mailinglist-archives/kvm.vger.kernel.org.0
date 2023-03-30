Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219586D03A7
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 13:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjC3LpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 07:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjC3Lou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 07:44:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830BCBDE1;
        Thu, 30 Mar 2023 04:44:23 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UB867T001481;
        Thu, 30 Mar 2023 11:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LLbnhRp6F0hHo/KnvBFzbY8SbWa+zOojgltwe8idKQY=;
 b=BrjfYi74JQ/v3o2i15sIU6pt3NoPZw1u/XgnTfUVGr3YjWbP7h/v9nqT0/NyONndufai
 nevfYGJSYg8o4xx2kz3C+YTLu0JVMQveKqO3bGp6+AJki4IAP4n1slDNrvd05TwiUYxw
 clQkOSIaQDfm/wLpmZF9k6j5jKksJRJ0g0uDiz7PpAIMpsnanRRKAt99fgyTQWe5qEdO
 L+9Ln35O9LAWlwRYAu97AQwVm3djZC74jLwiwh/cq1uMHccsvqrAHfi/qDrg1KRY6gJs
 DpTQGID6oP6V8eawQRHnNtLu1knWvhNqCHNMYqUHDP7xEj4Cacx0kYMuioGFkmgL8YFl 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp7jwufg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:48 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UBAeVR010402;
        Thu, 30 Mar 2023 11:43:47 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp7jwuew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:47 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32TMgwt1015876;
        Thu, 30 Mar 2023 11:43:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3phr7fvtqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UBhfZ722807060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 11:43:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4A2420043;
        Thu, 30 Mar 2023 11:43:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C7F020040;
        Thu, 30 Mar 2023 11:43:41 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 11:43:40 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 3/5] lib: s390x: ap: Add ap_setup
Date:   Thu, 30 Mar 2023 11:42:42 +0000
Message-Id: <20230330114244.35559-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330114244.35559-1-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QytCP7Yc3urW1ldyhx2XZZexcBfMSk6Z
X-Proofpoint-GUID: Zx_-YMuKWiaho-HaFavPdbtXVFaMT9Rv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_07,2023-03-30_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=899 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300095
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the next tests we need a valid queue which means we need to grab
the qci info and search the first set bit in the ap and aq masks.

Let's move from the ap_check function to a proper setup function that
also returns the first usable APQN. Later we can extend the setup to
build a list of all available APQNs but right now one APQN is plenty.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/s390x/ap.h |  5 ++++-
 s390x/ap.c     |  7 ++++++-
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index 374fa210..8d7f2992 100644
--- a/lib/s390x/ap.c
+++ b/lib/s390x/ap.c
@@ -13,9 +13,12 @@
 
 #include <libcflat.h>
 #include <interrupt.h>
+#include <bitops.h>
 #include <ap.h>
 #include <asm/time.h>
 
+static struct ap_config_info qci;
+
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct pqap_r2 *r2)
 {
@@ -77,7 +80,44 @@ int ap_pqap_qci(struct ap_config_info *info)
 	return cc;
 }
 
-bool ap_check(void)
+static int ap_get_apqn(uint8_t *ap, uint8_t *qn)
+{
+	unsigned long *ptr;
+	uint8_t bit;
+	int i;
+
+	ap_pqap_qci(&qci);
+	*ap = 0;
+	*qn = 0;
+
+	ptr = (unsigned long *)qci.apm;
+	for (i = 0; i < 4; i++) {
+		bit = fls(*ptr);
+		if (bit) {
+			*ap = i * 64 + 64 - bit;
+			break;
+		}
+	}
+	ptr = (unsigned long *)qci.aqm;
+	for (i = 0; i < 4; i++) {
+		bit = fls(*ptr);
+		if (bit) {
+			*qn = i * 64 + 64 - bit;
+			break;
+		}
+	}
+
+	if (!*ap || !*qn)
+		return -1;
+
+	/* fls returns 1 + bit number, so we need to remove 1 here */
+	*ap -= 1;
+	*qn -= 1;
+
+	return 0;
+}
+
+static bool ap_check(void)
 {
 	struct ap_queue_status r1 = {};
 	struct pqap_r2 r2 = {};
@@ -91,3 +131,15 @@ bool ap_check(void)
 
 	return true;
 }
+
+int ap_setup(uint8_t *ap, uint8_t *qn)
+{
+	if (!ap_check())
+		return AP_SETUP_NOINSTR;
+
+	/* Instructions available but no APQNs */
+	if (ap_get_apqn(ap, qn))
+		return AP_SETUP_NOAPQN;
+
+	return 0;
+}
diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
index 79fe6eb0..59595eba 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -79,7 +79,10 @@ struct pqap_r2 {
 } __attribute__((packed))  __attribute__((aligned(8)));
 _Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 size");
 
-bool ap_check(void);
+#define AP_SETUP_NOINSTR	-1
+#define AP_SETUP_NOAPQN		1
+
+int ap_setup(uint8_t *ap, uint8_t *qn);
 int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
 		 struct pqap_r2 *r2);
 int ap_pqap_qci(struct ap_config_info *info);
diff --git a/s390x/ap.c b/s390x/ap.c
index 82ddb6d2..20b4e76e 100644
--- a/s390x/ap.c
+++ b/s390x/ap.c
@@ -16,6 +16,9 @@
 #include <asm/time.h>
 #include <ap.h>
 
+static uint8_t apn;
+static uint8_t qn;
+
 /* For PQAP PGM checks where we need full control over the input */
 static void pqap(unsigned long grs[3])
 {
@@ -291,8 +294,10 @@ static void test_priv(void)
 
 int main(void)
 {
+	int setup_rc = ap_setup(&apn, &qn);
+
 	report_prefix_push("ap");
-	if (!ap_check()) {
+	if (setup_rc == AP_SETUP_NOINSTR) {
 		report_skip("AP instructions not available");
 		goto done;
 	}
-- 
2.34.1

