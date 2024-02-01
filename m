Return-Path: <kvm+bounces-7714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 487B7845A43
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D54A1C2368B
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 401D85F486;
	Thu,  1 Feb 2024 14:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Mk+uZFal"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CBA4D9F1;
	Thu,  1 Feb 2024 14:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706797539; cv=none; b=YMY4pnUkCKTWwmjaXcIi8KkLdFgB5FGNJQpIhjSjVYN27GXYtseCEDBNP2FVoR85y57cbwTHxnaNuFM0wQHFqPofnj+archisIu7FLcZAMINNqbzWDubpCvQXOxP1dAijwX7Q/qic31/0C2CeKO6AVbhrGRyErJUXkwoaLr4SUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706797539; c=relaxed/simple;
	bh=Wn9pFuE3Qg8Pi8CnWmEE/H8OG3swtWHVrKTQBAp5w9k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jAFhGOl7pUcQKhUGBkIlpX/kcTqguQMZENci4dwI5I7uphwJbl0DM0D7xT+fWYYXNKuHDKPg6pJG9MVO+BKt7X1HEB9omg3UKxIUIu7ClXV26d6yiv3vBqHW/Ca5d+YNhaxzWFGxCj7XZBMJ0YD4ZV2BIlpmrnRDHQfJlpkDPZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Mk+uZFal; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411EM7Er025731;
	Thu, 1 Feb 2024 14:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+N8pEDMUzBe2O9PWTts59SbPmmdTpt9+wARRKKpXVJA=;
 b=Mk+uZFaluZwBw63CJRRrbekJbecFcrFIEpwvM8HQQiH1jkZdoFobCx2Q5uDdlkhidWVa
 DWeldf1JnmVfGFaMz/CxpINPpI6ya0R4RSdmO8buu+kJPhiYvNSFzSRVQ4XqGMHp/OkM
 1EOaH4C8vl/9poR67DrE+PP3f1paMe4c4sPHsUTPoK4WLBkkJaRvROr3Zo0KSXcQG5RS
 LNpaP1OwDOsd3MJ/KGLQW/GQy2ez5e4FkCTnSI9yzf8OI0T3HLfQrH8hmDbKskKy5QGL
 34IwbmP1TlgGc/ixkid/jr8xT5GYNU22jgWbnfww5mAS8Tja8Wy3N+bp98DgkC0AtIPY jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0d0h890r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:36 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411EMPva026978;
	Thu, 1 Feb 2024 14:25:36 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0d0h8903-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:36 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411E9dqd007188;
	Thu, 1 Feb 2024 14:25:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwev2m7bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411EPW4r46400072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 14:25:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 801822004B;
	Thu,  1 Feb 2024 14:25:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 621FD2004D;
	Thu,  1 Feb 2024 14:25:32 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Feb 2024 14:25:32 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests RFC 2/2] lib: s390x: css: Name inline assembly arguments and clean them up
Date: Thu,  1 Feb 2024 14:23:56 +0000
Message-Id: <20240201142356.534783-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240201142356.534783-1-frankja@linux.ibm.com>
References: <20240201142356.534783-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kH63fXtOnUAw0tMZZp6fRgnwh2GkUDKa
X-Proofpoint-ORIG-GUID: WJ2-EtfGP4i2doPdduVSObCRy488lwsL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0 mlxlogscore=818
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402010114

Less need to count the operands makes the code easier to read.
For ssch and msch the second addr argument which was unused was removed.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h | 76 ++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 504b3f14..e4311124 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -135,11 +135,11 @@ static inline int ssch(unsigned long schid, struct orb *addr)
 	int cc;
 
 	asm volatile(
-		"	ssch	0(%2)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (cc)
-		: "d" (reg1), "a" (addr), "m" (*addr)
+		"	ssch	0(%[addr])\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc)
+		: "d" (reg1), [addr] "a" (addr)
 		: "cc", "memory");
 	return cc;
 }
@@ -152,11 +152,11 @@ static inline int stsch(unsigned long schid, struct schib *addr)
 
 	asm volatile(
 		"       tmll    %[bogus_cc],3\n"
-		"	stsch	0(%3)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc), "=m" (*addr)
-		: "d" (reg1), "a" (addr), [bogus_cc] "d" (bogus_cc)
+		"	stsch	0(%[addr])\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc), "=m" (*addr)
+		: "d" (reg1), [addr] "a" (addr), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
 }
@@ -167,11 +167,11 @@ static inline int msch(unsigned long schid, struct schib *addr)
 	int cc;
 
 	asm volatile(
-		"	msch	0(%3)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc)
-		: "d" (reg1), "m" (*addr), "a" (addr)
+		"	msch	0(%[addr])\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc)
+		: "d" (reg1), [addr] "a" (addr)
 		: "cc");
 	return cc;
 }
@@ -184,11 +184,11 @@ static inline int tsch(unsigned long schid, struct irb *addr)
 
 	asm volatile(
 		"       tmll    %[bogus_cc],3\n"
-		"	tsch	0(%3)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc), "=m" (*addr)
-		: "d" (reg1), "a" (addr), [bogus_cc] "d" (bogus_cc)
+		"	tsch	0(%[addr])\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc), "=m" (*addr)
+		: "d" (reg1), [addr] "a" (addr), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
 }
@@ -200,9 +200,9 @@ static inline int hsch(unsigned long schid)
 
 	asm volatile(
 		"	hsch\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc)
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc)
 		: "d" (reg1)
 		: "cc");
 	return cc;
@@ -215,9 +215,9 @@ static inline int xsch(unsigned long schid)
 
 	asm volatile(
 		"	xsch\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc)
+		"	ipm	%[cc]\n"
+		"	srl	%cc,28"
+		: [cc] "=d" (cc)
 		: "d" (reg1)
 		: "cc");
 	return cc;
@@ -230,9 +230,9 @@ static inline int csch(unsigned long schid)
 
 	asm volatile(
 		"	csch\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc)
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc)
 		: "d" (reg1)
 		: "cc");
 	return cc;
@@ -245,9 +245,9 @@ static inline int rsch(unsigned long schid)
 
 	asm volatile(
 		"	rsch\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc)
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc)
 		: "d" (reg1)
 		: "cc");
 	return cc;
@@ -262,9 +262,9 @@ static inline int rchp(unsigned long chpid)
 	asm volatile(
 		"       tmll    %[bogus_cc],3\n"
 		"	rchp\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc)
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc)
 		: "d" (reg1), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
@@ -369,9 +369,9 @@ static inline int _chsc(void *p)
 	int cc;
 
 	asm volatile(" .insn   rre,0xb25f0000,%2,0\n"
-		     " ipm     %0\n"
-		     " srl     %0,28\n"
-		     : "=d" (cc), "=m" (p)
+		     " ipm     %[cc]\n"
+		     " srl     %[cc],28\n"
+		     : [cc] "=d" (cc), "=m" (p)
 		     : "d" (p), "m" (p)
 		     : "cc");
 
-- 
2.40.1


