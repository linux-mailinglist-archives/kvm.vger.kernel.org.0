Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBAFE135DF2
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbgAIQQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:16:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18134 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387528AbgAIQQe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 11:16:34 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009G9n9h012408
        for <kvm@vger.kernel.org>; Thu, 9 Jan 2020 11:16:33 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xdx6k4gus-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:16:32 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Thu, 9 Jan 2020 16:16:30 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 Jan 2020 16:16:28 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 009GFc0e50004460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jan 2020 16:15:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D43A4C04E;
        Thu,  9 Jan 2020 16:16:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31DA94C04A;
        Thu,  9 Jan 2020 16:16:26 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jan 2020 16:16:26 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 3/4] s390x: lib: add SPX and STPX instruction wrapper
Date:   Thu,  9 Jan 2020 17:16:24 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109161625.154894-1-imbrenda@linux.ibm.com>
References: <20200109161625.154894-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20010916-0012-0000-0000-0000037BF8C2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010916-0013-0000-0000-000021B81AA8
Message-Id: <20200109161625.154894-4-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_03:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 suspectscore=1 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=772 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001090138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
use it instead of using inline assembly everywhere.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 10 ++++++++++
 s390x/intercept.c        | 33 +++++++++++++--------------------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 1a5e3c6..465fe0f 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -284,4 +284,14 @@ static inline int servc(uint32_t command, unsigned long sccb)
 	return cc;
 }
 
+static inline void spx(uint32_t *new_prefix)
+{
+	asm volatile("spx %0" : : "Q" (*new_prefix) : "memory");
+}
+
+static inline void stpx(uint32_t *current_prefix)
+{
+	asm volatile("stpx %0" : "=Q" (*current_prefix));
+}
+
 #endif
diff --git a/s390x/intercept.c b/s390x/intercept.c
index 3696e33..3b53633 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -26,27 +26,24 @@ static void test_stpx(void)
 	uint32_t new_prefix = (uint32_t)(intptr_t)pagebuf;
 
 	/* Can we successfully change the prefix? */
-	asm volatile (
-		" stpx	%0\n"
-		" spx	%2\n"
-		" stpx	%1\n"
-		" spx	%0\n"
-		: "+Q"(old_prefix), "+Q"(tst_prefix)
-		: "Q"(new_prefix));
+	stpx(&old_prefix);
+	spx(&new_prefix);
+	stpx(&tst_prefix);
+	spx(&old_prefix);
 	report(old_prefix == 0 && tst_prefix == new_prefix, "store prefix");
 
 	expect_pgm_int();
 	low_prot_enable();
-	asm volatile(" stpx 0(%0) " : : "r"(8));
+	stpx((void *)8L);
 	low_prot_disable();
 	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
 
 	expect_pgm_int();
-	asm volatile(" stpx 0(%0) " : : "r"(1));
+	stpx((void *)1L);
 	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 
 	expect_pgm_int();
-	asm volatile(" stpx 0(%0) " : : "r"(-8L));
+	stpx((void *)-8L);
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 }
 
@@ -63,22 +60,18 @@ static void test_spx(void)
 	 * some facility bits there ... at least some of them should be
 	 * set in our buffer afterwards.
 	 */
-	asm volatile (
-		" stpx	%0\n"
-		" spx	%1\n"
-		" stfl	0\n"
-		" spx	%0\n"
-		: "+Q"(old_prefix)
-		: "Q"(new_prefix)
-		: "memory");
+	stpx(&old_prefix);
+	spx(&new_prefix);
+	asm volatile (" stfl 0" : : : "memory");
+	spx(&old_prefix);
 	report(pagebuf[GEN_LC_STFL] != 0, "stfl to new prefix");
 
 	expect_pgm_int();
-	asm volatile(" spx 0(%0) " : : "r"(1));
+	spx((void *)1L);
 	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 
 	expect_pgm_int();
-	asm volatile(" spx 0(%0) " : : "r"(-8L));
+	spx((void *)-8L);
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 }
 
-- 
2.24.1

