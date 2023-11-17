Return-Path: <kvm+bounces-1963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B157EF508
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:20:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 404BBB20B46
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C227374CD;
	Fri, 17 Nov 2023 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LJx1DMHP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEA9D5C;
	Fri, 17 Nov 2023 07:20:00 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFAvl4032662;
	Fri, 17 Nov 2023 15:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0lRkuHOuG8OsQo03zcyJ7F+nHQdpl1dXNR4OWZxMOek=;
 b=LJx1DMHPol1hhGzsAc6jhY8z298LV4QxqeagPlo5I7Mtf67JjZaZWpOADP31KU72iI+G
 /mDU6WjBq7pZnpcOe9GqYtjXXEBAXz7wFosaQM8kNeHyN+poDCNLsGIWRoY4CT5aD8n+
 /rAcyxZP2sDw8IfiEACwqKhTl/motOL+EEIgrmjrIQWn8hJGvkPc4QX4K3XX9/0hKlYS
 1hhOs2C27TtJIw3GMeLZphPYBrSET32jQgRkGg5mV9+jCEYyRrYIGAWJIGwrMejUi6hY
 CL1RbWjCrOgelDI6ZtM+8sS7ODVnTgAKtgoHQHPOx9nZRARluXXjIotQFW/Pcjny4c4d Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueaah8ynx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHFBNlN003052;
	Fri, 17 Nov 2023 15:19:59 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueaah8ymu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFGx0M005161;
	Fri, 17 Nov 2023 15:19:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uakxtf7vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHFJtJG28705296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 15:19:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C4C382004E;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84E5F2004B;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 3/7] lib: s390x: ap: Add proper ap setup code
Date: Fri, 17 Nov 2023 15:19:35 +0000
Message-Id: <20231117151939.971079-4-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: VvI-LHRcSaP2fCw8E736VPksoOT4y7ra
X-Proofpoint-GUID: wiRzuTOHUv7XtvkwColG1__ki9ofh8eN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_14,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311170114

For the next tests we need a valid queue which means we need to grab
the qci info and search the first set bit in the ap and aq masks.

Let's move from the stfle 12 check to proper setup code that also
returns arrays for the aps and qns.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/ap.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++---
 lib/s390x/ap.h | 17 +++++++++-
 s390x/ap.c     |  4 ++-
 3 files changed, 105 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
index 17a32d66..9ba5a037 100644
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
@@ -78,16 +86,90 @@ int ap_pqap_qci(struct ap_config_info *info)
 	return cc;
 }
 
-/* Will later be extended to a proper setup function */
-bool ap_setup(void)
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
index cda1e564..ac9e59d1 100644
--- a/lib/s390x/ap.h
+++ b/lib/s390x/ap.h
@@ -81,7 +81,22 @@ struct pqap_r2 {
 } __attribute__((packed))  __attribute__((aligned(8)));
 _Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 size");
 
-bool ap_setup(void);
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


