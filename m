Return-Path: <kvm+bounces-5824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EE6826FDD
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 905BE1C20A5F
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E0146437;
	Mon,  8 Jan 2024 13:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cQW9tTos"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B0A4596E;
	Mon,  8 Jan 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408Cge4T018811;
	Mon, 8 Jan 2024 13:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=akrU+6VaQe2VywXn2XQALvQ9iELTfX0OeMWh7dFTqsw=;
 b=cQW9tTosEwKDTm7pOeprrlJcrr60HeZyykPtXxxDpzvFDo6HdCA5lnfKmBty2qjYsam6
 03ZsZkX4jpncVLg4ixf7kFA33vcx/QAFyYgb7t1XN/qMo6CrdCDWTYDl3kkYgV0fjhyV
 8/RXit7ggYtZq1km70uPywZCYkzb03PtrbWvKt16VvWFcFjKp36ekW4D3RhuOOcc/Yxf
 NFTywFHBUi/6AuF+UAbVlYAiocH9SbkVvcQI2SlVNRYGmB3QiHDQ6GXHxlTa4EdweT3w
 Au6IezXqf1aAxL3vxN4LUBFmMMKb5bdNui+YVLDDE5v9tEhTk/6uG3BOhI8mIFqDyMlA zg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vgh9u1frn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:51 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408D09un002716;
	Mon, 8 Jan 2024 13:29:51 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vgh9u1fr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:51 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408Ccuk0022877;
	Mon, 8 Jan 2024 13:29:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfj6n82v5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408DTk8H19399398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 13:29:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABE782004D;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 873472005A;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/5] lib: s390x: css: Dirty CC before css instructions
Date: Mon,  8 Jan 2024 13:29:20 +0000
Message-Id: <20240108132921.255769-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240108132921.255769-1-frankja@linux.ibm.com>
References: <20240108132921.255769-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 01tTxzFl0y6oLaPWZomNGWrraCmMzuPB
X-Proofpoint-GUID: tpa2-QurFvjBWvLGYWhGytnQ5DH1lDhE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_04,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=462 priorityscore=1501 phishscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401080115

Dirtying the CC allows us to find missing CC changes when css
instructions are emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h | 18 ++++++++++++++----
 s390x/mvpg.c    |  6 ++++--
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 0a19324b..47733d2d 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -6,6 +6,8 @@
  * Author: Pierre Morel <pmorel@linux.ibm.com>
  */
 
+#include <asm/arch_def.h>
+
 #ifndef _S390X_CSS_H_
 #define _S390X_CSS_H_
 
@@ -147,14 +149,16 @@ static inline int ssch(unsigned long schid, struct orb *addr)
 static inline int stsch(unsigned long schid, struct schib *addr)
 {
 	register unsigned long reg1 asm ("1") = schid;
+	uint64_t spm_cc = 1 << SPM_CC_SHIFT;
 	int cc;
 
 	asm volatile(
+		"	spm	%[spm_cc]\n"
 		"	stsch	0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc), "=m" (*addr)
-		: "d" (reg1), "a" (addr)
+		: "d" (reg1), "a" (addr), [spm_cc] "d" (spm_cc)
 		: "cc");
 	return cc;
 }
@@ -177,14 +181,16 @@ static inline int msch(unsigned long schid, struct schib *addr)
 static inline int tsch(unsigned long schid, struct irb *addr)
 {
 	register unsigned long reg1 asm ("1") = schid;
+	uint64_t spm_cc = 2 << SPM_CC_SHIFT;
 	int cc;
 
 	asm volatile(
+		"	spm	%[spm_cc]\n"
 		"	tsch	0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc), "=m" (*addr)
-		: "d" (reg1), "a" (addr)
+		: "d" (reg1), "a" (addr), [spm_cc] "d" (spm_cc)
 		: "cc");
 	return cc;
 }
@@ -252,28 +258,32 @@ static inline int rsch(unsigned long schid)
 static inline int rchp(unsigned long chpid)
 {
 	register unsigned long reg1 asm("1") = chpid;
+	uint64_t spm_cc = 1 << SPM_CC_SHIFT;
 	int cc;
 
 	asm volatile(
+		"	spm	%[spm_cc]\n"
 		"	rchp\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc)
-		: "d" (reg1)
+		: "d" (reg1), [spm_cc] "d" (spm_cc)
 		: "cc");
 	return cc;
 }
 
 static inline int stcrw(uint32_t *crw)
 {
+	uint64_t spm_cc = 1 << SPM_CC_SHIFT;
 	int cc;
 
 	asm volatile(
+		"	spm	%[spm_cc]\n"
 		"	stcrw	%[crw]\n"
 		"	ipm	%[cc]\n"
 		"	srl	%[cc],28"
 		: [cc] "=d" (cc)
-		: [crw] "Q" (*crw)
+		: [crw] "Q" (*crw), [spm_cc] "d" (spm_cc)
 		: "cc", "memory");
 	return cc;
 }
diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 296338d4..21e3ecc7 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -40,12 +40,14 @@ static uint8_t *fresh;
 static inline int mvpg(unsigned long r0, void *dest, void *src)
 {
 	register unsigned long reg0 asm ("0") = r0;
+	uint64_t spm_cc = 3 << SPM_CC_SHIFT;
 	int cc;
 
-	asm volatile("	mvpg    %1,%2\n"
+	asm volatile("	spm	%[spm_cc]\n"
+		     "	mvpg    %1,%2\n"
 		     "	ipm     %0\n"
 		     "	srl     %0,28"
-		: "=&d" (cc) : "a" (dest), "a" (src), "d" (reg0)
+		: "=&d" (cc) : "a" (dest), "a" (src), "d" (reg0), [spm_cc] "d" (spm_cc)
 		: "memory", "cc");
 	return cc;
 }
-- 
2.40.1


