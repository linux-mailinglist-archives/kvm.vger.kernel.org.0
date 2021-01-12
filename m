Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE302F3186
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbhALNWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:22:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733056AbhALNWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 08:22:02 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CD58ov063841;
        Tue, 12 Jan 2021 08:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I5DBPI8+i1zVFTn1s3zgO+6a9Pz5GfCH27yR9otAvbo=;
 b=bYMSpN4QtCmuaYKpN3VztvTyRev7H3aew18sNl71TQIIGpdFFhdcrg3jyYhcLZwrHzsv
 VK+dRrR7F1fnXuJ0b7UPAqmPvlRfWN1TIS56eUNlkQYrPI1py3MbkEH+4xY7sOnMazjn
 0Z+88aNPLbKGr+yeYYXjfU1V/mBomXtUdJZNxVbcjQL23urilAgHppHAf7jevFMNIvwn
 Xf9sFBjv+Z8s1rDk5w50T2AhFyR7SJRKOM3Fk/SOhDebIzEVkuPzQvELHR2aZVzzIJZJ
 HoMA2qZikfktd5OQmYA6gdgoUht5Z6XkKE5+xY0Ztn7du1sqNr8THtqw6dHVeh3Ras9f 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361bvhsm89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:21 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CD5gsW066139;
        Tue, 12 Jan 2021 08:21:21 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361bvhsm7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:21 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CDHJWZ016229;
        Tue, 12 Jan 2021 13:21:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 35y4489vdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:21:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CDLFZh37421528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 13:21:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C90A94C040;
        Tue, 12 Jan 2021 13:21:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D54E4C052;
        Tue, 12 Jan 2021 13:21:15 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 13:21:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 7/9] s390x: Add diag318 intercept test
Date:   Tue, 12 Jan 2021 08:20:52 -0500
Message-Id: <20210112132054.49756-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112132054.49756-1-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not much to test except for the privilege and specification
exceptions.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sclp.c  |  1 +
 lib/s390x/sclp.h  |  6 +++++-
 s390x/intercept.c | 19 +++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 06819a6..7a9b2c5 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -138,6 +138,7 @@ void sclp_facilities_setup(void)
 	assert(read_info);
 
 	cpu = sclp_get_cpu_entries();
+	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
 	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
 		/*
 		 * The logic for only reading the facilities from the
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

