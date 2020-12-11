Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370C22D734F
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 11:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405088AbgLKKDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 05:03:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394107AbgLKKCV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 05:02:21 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BB9h8HU068393;
        Fri, 11 Dec 2020 05:01:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bly1Z9PzCWg2ROug99pEOVdwpULkDHl1OqHKJmC47MA=;
 b=S5J9kAhwVIWXmmutemdFEF46AVuYG0bzwaWnotG7GjFhCHTxqSptpQrkWmQB7d1pd0fB
 LgBwjEa6lPkP1e/z5Dzfv+l8UM8Q24CCOpxxglRQoMkUujfCGfkzNoAU1jjXGMOUH3az
 3emp1VvHLKox3rY5g8lUgte71xpyPPnH6CIkO2DqsOKcw+XQu8UDjJCmXvhZ+gtmzmDl
 1fQWtAksFZwBwSCp7bBFT4sTQ91I615rc7ZmmNH+9tF0XXocKYk5iw81AfY3MsZX6eXb
 rH9ipNOvD9mnhi+k5ubledTQdJRj6/d1DHiTRIeHwiowS3VeEfZlpXllJgZtirgoSU/i CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6ck0f4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:01:41 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BB9hOHj068772;
        Fri, 11 Dec 2020 05:01:40 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6ck0f37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:01:40 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BB9rZ3G022857;
        Fri, 11 Dec 2020 10:01:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u86unp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 10:01:38 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBA1Z7t48234852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 10:01:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B412A4053;
        Fri, 11 Dec 2020 10:01:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95A34A4059;
        Fri, 11 Dec 2020 10:01:34 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 10:01:34 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 7/8] s390x: Add diag318 intercept test
Date:   Fri, 11 Dec 2020 05:00:38 -0500
Message-Id: <20201211100039.63597-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211100039.63597-1-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=1 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not much to test except for the privilege and specification
exceptions.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/sclp.c  |  2 ++
 lib/s390x/sclp.h  |  6 +++++-
 s390x/intercept.c | 19 +++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index cf6ea7c..0001993 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -138,6 +138,8 @@ void sclp_facilities_setup(void)
 
 	assert(read_info);
 
+	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+
 	cpu = (void *)read_info + read_info->offset_cpu;
 	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
 		if (cpu->address == cpu0_addr) {
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 6c86037..58f8e54 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -105,7 +105,8 @@ extern struct sclp_facilities sclp_facilities;
 
 struct sclp_facilities {
 	uint64_t has_sief2 : 1;
-	uint64_t : 63;
+	uint64_t has_diag318 : 1;
+	uint64_t : 62;
 };
 
 typedef struct ReadInfo {
@@ -130,6 +131,9 @@ typedef struct ReadInfo {
     uint16_t highest_cpu;
     uint8_t  _reserved5[124 - 122];     /* 122-123 */
     uint32_t hmfai;
+    uint8_t reserved7[134 - 128];
+    uint8_t byte_134_diag318 : 1;
+    uint8_t : 7;
     struct CPUEntry entries[0];
 } __attribute__((packed)) ReadInfo;
 
diff --git a/s390x/intercept.c b/s390x/intercept.c
index cde2f5f..86e57e1 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -8,6 +8,7 @@
  *  Thomas Huth <thuth@redhat.com>
  */
 #include <libcflat.h>
+#include <sclp.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
@@ -152,6 +153,23 @@ static void test_testblock(void)
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 }
 
+static void test_diag318(void)
+{
+	expect_pgm_int();
+	enter_pstate();
+	asm volatile("diag %0,0,0x318\n" : : "d" (0x42));
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+
+	if (!sclp_facilities.has_diag318)
+		expect_pgm_int();
+
+	asm volatile("diag %0,0,0x318\n" : : "d" (0x42));
+
+	if (!sclp_facilities.has_diag318)
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+}
+
 struct {
 	const char *name;
 	void (*func)(void);
@@ -162,6 +180,7 @@ struct {
 	{ "stap", test_stap, false },
 	{ "stidp", test_stidp, false },
 	{ "testblock", test_testblock, false },
+	{ "diag318", test_diag318, false },
 	{ NULL, NULL, false }
 };
 
-- 
2.25.1

