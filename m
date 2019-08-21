Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8874E97791
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 12:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfHUKsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 06:48:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727063AbfHUKsj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Aug 2019 06:48:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LAmW5K135820
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 06:48:37 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uh2hbw9ka-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 06:48:35 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 21 Aug 2019 11:48:21 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 11:48:18 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7LAmHtT49742064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 10:48:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFA69AE059;
        Wed, 21 Aug 2019 10:48:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD742AE051;
        Wed, 21 Aug 2019 10:48:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.179])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Aug 2019 10:48:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/4] s390x: Move stsi to library
Date:   Wed, 21 Aug 2019 12:47:35 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821104736.1470-1-frankja@linux.ibm.com>
References: <20190821104736.1470-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082110-0012-0000-0000-000003411153
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082110-0013-0000-0000-0000217B3878
Message-Id: <20190821104736.1470-4-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=978 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's needed in multiple tests now.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
 s390x/skey.c             | 18 ------------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 4bbb428..5f8f45e 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -240,4 +240,20 @@ static inline void enter_pstate(void)
 	load_psw_mask(mask);
 }
 
+static inline int stsi(void *addr, int fc, int sel1, int sel2)
+{
+	register int r0 asm("0") = (fc << 28) | sel1;
+	register int r1 asm("1") = sel2;
+	int cc;
+
+	asm volatile(
+		"stsi	0(%3)\n"
+		"ipm	%[cc]\n"
+		"srl	%[cc],28\n"
+		: "+d" (r0), [cc] "=d" (cc)
+		: "d" (r1), "a" (addr)
+		: "cc", "memory");
+	return cc;
+}
+
 #endif
diff --git a/s390x/skey.c b/s390x/skey.c
index b1e11af..fd4fcc7 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -70,24 +70,6 @@ static void test_set(void)
 	       skey.str.acc == ret.str.acc && skey.str.fp == ret.str.fp);
 }
 
-static inline int stsi(void *addr, int fc, int sel1, int sel2)
-{
-	register int r0 asm("0") = (fc << 28) | sel1;
-	register int r1 asm("1") = sel2;
-	int rc = 0;
-
-	asm volatile(
-		"	stsi	0(%3)\n"
-		"	jz	0f\n"
-		"	lhi	%1,-1\n"
-		"0:\n"
-		: "+d" (r0), "+d" (rc)
-		: "d" (r1), "a" (addr)
-		: "cc", "memory");
-
-	return rc;
-}
-
 /* Returns true if we are running under z/VM 6.x */
 static bool check_for_zvm6(void)
 {
-- 
2.17.0

