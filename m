Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B121137637
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 19:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgAJSlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 13:41:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62668 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728457AbgAJSk7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 13:40:59 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00AIbI3E029844
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 13:40:58 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xe0smm474-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 13:40:58 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 10 Jan 2020 18:40:56 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 Jan 2020 18:40:53 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00AIeqKT53477568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 18:40:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 597DEAE051;
        Fri, 10 Jan 2020 18:40:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DCD5AE04D;
        Fri, 10 Jan 2020 18:40:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jan 2020 18:40:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v7 3/4] s390x: lib: add SPX and STPX instruction wrapper
Date:   Fri, 10 Jan 2020 19:40:49 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110184050.191506-1-imbrenda@linux.ibm.com>
References: <20200110184050.191506-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011018-0028-0000-0000-000003D00C5C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011018-0029-0000-0000-00002494259B
Message-Id: <20200110184050.191506-4-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 adultscore=0 mlxlogscore=981 impostorscore=0
 spamscore=0 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001100150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
use it instead of using inline assembly.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 13 +++++++++++++
 s390x/intercept.c        | 23 ++++++++---------------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 1a5e3c6..15a4d49 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -284,4 +284,17 @@ static inline int servc(uint32_t command, unsigned long sccb)
 	return cc;
 }
 
+static inline void set_prefix(uint32_t new_prefix)
+{
+	asm volatile("	spx %0" : : "Q" (new_prefix) : "memory");
+}
+
+static inline uint32_t get_prefix(void)
+{
+	uint32_t current_prefix;
+
+	asm volatile("	stpx %0" : "=Q" (current_prefix));
+	return current_prefix;
+}
+
 #endif
diff --git a/s390x/intercept.c b/s390x/intercept.c
index 3696e33..cd96121 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -26,13 +26,10 @@ static void test_stpx(void)
 	uint32_t new_prefix = (uint32_t)(intptr_t)pagebuf;
 
 	/* Can we successfully change the prefix? */
-	asm volatile (
-		" stpx	%0\n"
-		" spx	%2\n"
-		" stpx	%1\n"
-		" spx	%0\n"
-		: "+Q"(old_prefix), "+Q"(tst_prefix)
-		: "Q"(new_prefix));
+	old_prefix = get_prefix();
+	set_prefix(new_prefix);
+	tst_prefix = get_prefix();
+	set_prefix(old_prefix);
 	report(old_prefix == 0 && tst_prefix == new_prefix, "store prefix");
 
 	expect_pgm_int();
@@ -63,14 +60,10 @@ static void test_spx(void)
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
+	old_prefix = get_prefix();
+	set_prefix(new_prefix);
+	asm volatile("	stfl 0" : : : "memory");
+	set_prefix(old_prefix);
 	report(pagebuf[GEN_LC_STFL] != 0, "stfl to new prefix");
 
 	expect_pgm_int();
-- 
2.24.1

