Return-Path: <kvm+bounces-7855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B43C84728D
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F7D61C25D02
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4710B1468E6;
	Fri,  2 Feb 2024 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GANkYRDd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD24144636;
	Fri,  2 Feb 2024 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706886302; cv=none; b=oil6/swI1ED+Cd4pzWnR1SzrOq8QYhuHrYOfTYPtKWxfxLKgobpBfNe9vYRpVloVLCJZHvuFBJNxXR3vHM5JmZ1ubA8iXedZ7wzmWeIaxmTlYjIQ58GVPevUcw4yj2buHgEN4K3rJxc4Th9Mhuu2++2y+BH2OuobLm+Bhj9UXlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706886302; c=relaxed/simple;
	bh=7ZsC+e0vsm/1YAntHM0K/eR5e8WTd5p7YdVzQHYQcFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s3fObgkMcfrhLlAuTZUQSWhuweb4m5SjNlvm1lapZJZxnlf7yKFQUKGwH7POeT0r+etNXIXFqCs9PPjJsgD3l6zh4/GEzHP/i0/k6wVHBDIcook9ACCc6cmLm/YCLssWPJxVaw6Gk2qOo0E4aL45ZnUe06l9reUq+cBpMXd0+hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GANkYRDd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 412EQ6IB025828;
	Fri, 2 Feb 2024 15:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PJii8eqAgh7vyiuiy/+5zpmkAQQ4wcReDrFT5R7mCs8=;
 b=GANkYRDdb2Tqg0qbGlq8mwMLKNBh1sB9aDbOf8RZoYefCC08fOK6BkIFB4q/OktcqTpV
 Sb9kNf6shQ6LjS0p/srZuqk8QFDBZ8PGsgBuZVy7lrP1CeRNDWsXJ2NcLSNWDVA1wFvk
 X+5sXh0ARQ17eJwrDCSB+NSE8CxXvLHvcsHw3H5Cl/aarB1A9yzsFFf9EPUEisO5q3PS
 qAQdoRkOoyMXzuhH9V6fQtCmAvG4hvTXiJJaJM1pEJo3w58FWZGLrOQw5EMb/pgM3Zum
 6E4JmMaWrGZ719tLiWtXUHJBf6Vcezs3/Dl59k3cFJ68IFdW2Z+LVONxafWnJviQAyOV Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w11xrh80c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 412EsFn1020426;
	Fri, 2 Feb 2024 15:04:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w11xrh7yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:59 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 412DAB5N008086;
	Fri, 2 Feb 2024 15:04:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwdnmku0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:58 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 412F4tpx39256660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Feb 2024 15:04:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E316420049;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B15A32004D;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 3/7] lib: s390x: ap: Add proper ap setup code
Date: Fri,  2 Feb 2024 14:59:09 +0000
Message-Id: <20240202145913.34831-4-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: NjsVL2pp4DYDCq6c3vzgtcPoBGHO31on
X-Proofpoint-GUID: P8c4-KXgEHCPAdgXztj8gzQXmg5KIO6n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-02_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402020109

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
index 9560ff64..c85172a8 100644
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
@@ -82,16 +90,90 @@ int ap_pqap_qci(struct ap_config_info *info)
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
index b806513f..8feca43a 100644
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
index b3cee37a..5c458e7e 100644
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
2.40.1


