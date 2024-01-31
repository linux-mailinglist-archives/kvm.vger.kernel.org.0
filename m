Return-Path: <kvm+bounces-7536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD24F84382D
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 08:45:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 565611F275F8
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 07:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5F75810C;
	Wed, 31 Jan 2024 07:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Naam4uWY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE555FB90;
	Wed, 31 Jan 2024 07:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706687101; cv=none; b=eC1Cj2ZHtExb886CNKxvh0im+a52JcyuoPX/ESISL0RXUvFDed0vo3yPd+GExNI8WxoJcUlgr4saFrjCmgkB5p4B5/u7yPDVWlscsDtsPXJ8f/a1/2wOzrfLLJJhFkoRZetTY6S+g2beQOrSWdU+evNmdwAo0vZu+ShOACgWF38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706687101; c=relaxed/simple;
	bh=lPkZc41+EqSA4oRDkOG9zD4xHnVZTIvgE/pVaIfK+V8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IzGoNF2vDuTBr5eXjEm3++QZHCdCi0RDK47wpd3haMHTKEPkozpV4qHsbjv+BZrmI435tKH3vILA74SHMjuddJ6vaVmM7shyADqxGILKz8l9G6iGhRw4M6VcxDcRWc8RU0XdxUpsSpI5L/hvbUeu/Tmpg8VmwWnLUrBxHUNM/BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Naam4uWY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40V7OUq1016510;
	Wed, 31 Jan 2024 07:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=62GkKZDkIZgZRa8YKhzPvS/DSiK8NJ7qDFLJB3Fsdo4=;
 b=Naam4uWYikCclYVPTYxpPPs+3wkNHqkqkSBhsDUptiCHyUlBhAGn+YnCD6vQKdLgKeDE
 Iu6TZofe8H0/tlhkJeglC3xsRbcVAIvea0eSiOEs1R0MzGGXjHf5yllPsMop0aAJyjP1
 M/5oJ2hqJnH7GrhQtwY3GgDDLSFUoZXN8OonZ2ogt2N8oRSU04jdqTGzECJG6aO+xZy7
 TZm4pMRPYw1soRVdu4C4nn4zNiK0ONpSLFGECTb44utCUpHM91+63i3iDPJkOhiMAya0
 EbAFgfSDbzjiZPgflkm4eNvMTE7sS4oNDOHGI0aQPgBDK3jDqNt0+GjwUwyn1yfDRYII TA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyhhtgxc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:57 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40V78frj030352;
	Wed, 31 Jan 2024 07:44:57 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyhhtgxbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:57 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40V5gvcA010833;
	Wed, 31 Jan 2024 07:44:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwd5nv0eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40V7iruX45023806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 07:44:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E42F20040;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E7E52004B;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/5] lib: s390x: css: Dirty CC before css instructions
Date: Wed, 31 Jan 2024 07:44:25 +0000
Message-Id: <20240131074427.70871-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240131074427.70871-1-frankja@linux.ibm.com>
References: <20240131074427.70871-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y_5DKETqarA85ScbQfPnYjPGMPfsVxdd
X-Proofpoint-ORIG-GUID: jYlJkkGnICm3rCdkSf9pM_jnhuNalvZ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_02,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=510
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310057

Dirtying the CC allows us to find missing CC changes when css
instructions are emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 0a19324b..504b3f14 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -147,14 +147,16 @@ static inline int ssch(unsigned long schid, struct orb *addr)
 static inline int stsch(unsigned long schid, struct schib *addr)
 {
 	register unsigned long reg1 asm ("1") = schid;
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	asm volatile(
+		"       tmll    %[bogus_cc],3\n"
 		"	stsch	0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc), "=m" (*addr)
-		: "d" (reg1), "a" (addr)
+		: "d" (reg1), "a" (addr), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
 }
@@ -177,14 +179,16 @@ static inline int msch(unsigned long schid, struct schib *addr)
 static inline int tsch(unsigned long schid, struct irb *addr)
 {
 	register unsigned long reg1 asm ("1") = schid;
+	uint64_t bogus_cc = 2;
 	int cc;
 
 	asm volatile(
+		"       tmll    %[bogus_cc],3\n"
 		"	tsch	0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc), "=m" (*addr)
-		: "d" (reg1), "a" (addr)
+		: "d" (reg1), "a" (addr), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
 }
@@ -252,28 +256,32 @@ static inline int rsch(unsigned long schid)
 static inline int rchp(unsigned long chpid)
 {
 	register unsigned long reg1 asm("1") = chpid;
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	asm volatile(
+		"       tmll    %[bogus_cc],3\n"
 		"	rchp\n"
 		"	ipm	%0\n"
 		"	srl	%0,28"
 		: "=d" (cc)
-		: "d" (reg1)
+		: "d" (reg1), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	return cc;
 }
 
 static inline int stcrw(uint32_t *crw)
 {
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	asm volatile(
+		"       tmll    %[bogus_cc],3\n"
 		"	stcrw	%[crw]\n"
 		"	ipm	%[cc]\n"
 		"	srl	%[cc],28"
 		: [cc] "=d" (cc)
-		: [crw] "Q" (*crw)
+		: [crw] "Q" (*crw), [bogus_cc] "d" (bogus_cc)
 		: "cc", "memory");
 	return cc;
 }
-- 
2.40.1


