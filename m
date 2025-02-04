Return-Path: <kvm+bounces-37220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 130C7A26F00
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 11:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C188818875AA
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0C2720B1EF;
	Tue,  4 Feb 2025 10:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eoIHZIo8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AAE20A5DF;
	Tue,  4 Feb 2025 10:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738663467; cv=none; b=kRz+uRyvB2ynjxmH+duI1Q6/bqF0BD23Q/miSX0k0nL8VD6PTf9VQ1h4MrmiP1HlmGSmnRI8BCgZ0CRcRIxNCoZijbcrMhxFaqceBXaGmxMTvGpalkelPisrrA2qCXDYvYK0xV+DpES7nqNXY8hjo/C9ZzeU2hLVmnkcDogeVrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738663467; c=relaxed/simple;
	bh=pAD2v7iFBPcvtJWA4lxeW6rcj2wAhdg+3r56YWD7A+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JskgCxqPCbkMPlnR0OC5/6FR04qtkEKspfmbISKOi7Yrjk1JKvp8Dx9DEU4VIAaU+rMaNO8XUTSc7q1U+RH1l1TEGXoDtTztEC4kTXBI1ScPuQhGKX0rVuuwrdQrK1KW8DgXhk4rvXtM0Uxb/sPyKEC9Ba8jiTNLcvn266gjjb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eoIHZIo8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51418rIY023957;
	Tue, 4 Feb 2025 10:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=oSsLQ4Frez4nfaW9l/Yz0IurUPcJLUSH7RH8Gey9S
	/Q=; b=eoIHZIo8oVgeID1kI/8qyN2MiloBFcuN9LdWDFFjiiODB2J9bfh/u830V
	y/bO2Vs8exv6B4VToyrPbsWxUUkrtZBKQV8zTDDbRli8CbTcD6IkCx0OzU0xI7c2
	fQS3S//9iGj5X2w+LxFYTJhzuC4xgH31/+b01cudR6m4s63i6l5y0Wb1DLK1TNBJ
	KMTwIZ7cPU79gE12lTGVfxRKi4tgHOaOLIo0SROiApzGh8xDQVYoZNXFfJ0PAO8Y
	+GEaPmeigVSHlgOwzdEJ1lvIaB909inP60vSGoIto/CjLXzp+z1xSdhGbcPbCLfd
	t6aOt/lBmyT9T4l+kEK/Z1NNFhAGQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44k8y9j6c8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Feb 2025 10:04:24 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5147rgM4016271;
	Tue, 4 Feb 2025 10:04:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxsb3qb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Feb 2025 10:04:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 514A4KT633554970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Feb 2025 10:04:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EB28200BC;
	Tue,  4 Feb 2025 10:04:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51482200BA;
	Tue,  4 Feb 2025 10:04:20 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Feb 2025 10:04:20 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        hca@linux.ibm.com
Subject: [kvm-unit-tests PATCH] lib: s390x: css: Name inline assembly arguments and clean them up
Date: Tue,  4 Feb 2025 09:51:33 +0000
Message-ID: <20250204100339.28158-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hrjkH3R5kfYCOLtpYG10vHAloNw-nGMO
X-Proofpoint-ORIG-GUID: hrjkH3R5kfYCOLtpYG10vHAloNw-nGMO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=957 suspectscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502040080

Less need to count the operands makes the code easier to read.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---

This one has been gathering dust for a while.
rfc->v1: Moved to Q constraint (thanks Heiko)

---
 lib/s390x/css.h | 76 ++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 504b3f14..42c5830c 100644
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
+		"	ssch	%[addr]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc)
+		: "d" (reg1), [addr] "Q" (*addr)
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
+		"	stsch	%[addr]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc), [addr] "=Q" (*addr)
+		: "d" (reg1), [bogus_cc] "d" (bogus_cc)
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
+		"	msch	%[addr]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc)
+		: "d" (reg1), [addr] "Q" (*addr)
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
+		"	tsch	%[addr]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28"
+		: [cc] "=d" (cc), [addr] "=Q" (*addr)
+		: "d" (reg1), [bogus_cc] "d" (bogus_cc)
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
2.43.0


