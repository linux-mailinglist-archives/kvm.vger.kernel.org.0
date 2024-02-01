Return-Path: <kvm+bounces-7715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CE3845A45
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:26:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D378B1F2314B
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EA15F462;
	Thu,  1 Feb 2024 14:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l9skmdkb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A3E5D48E;
	Thu,  1 Feb 2024 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706797560; cv=none; b=SVPg/kK3sHMk6o8o1oFNVNd7TIAMldinV3SSWbjmQ0FGs0+NgHjE2vJsAgohIrdmIsxMnHthupR/udJq3xjBbOvdUymYxZxw5DTDl/tWDTddUYhQMF05TEzcatL0KUvXYHwjWByRq74MN4NC0/NR0dO9krF0w5HNk+ycPyc6kU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706797560; c=relaxed/simple;
	bh=HWEoif+3848NORc8D2Na4kmhQeD6lXqHTcJoFhESIYk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D2mGR4E/ufX9ERMGJ5n3LRwquXC0Xx0gDPm3auWJQIHooA3aL9MlJ/M95SFZY9ViGu8bpP+RlI6BcvPhBIRU1+j/qj2DDn901RGAQYNQNp4hXU5VUkbpjd15uGKGl37VBoy0J+g6PFIbp+vSgkRbeZxRzd8gijpGtzQeKKuZqnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l9skmdkb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411CttGr023606;
	Thu, 1 Feb 2024 14:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=miuoRQ+f+vhZfz08X7GrTt3NdD233RhDdMrakboO8OE=;
 b=l9skmdkbQBFQkQfLM2t1Q/tRfcJbCxBa7/XxX3DXBX/F2Em5AeW92T1QlZ8BGZ+y8+3g
 T9RSroGj98OyN4VTsE//gs15nrTjk530XIKKzuCuo73yYAsKG8bCQsY+NAH4N1+GBpMF
 IlKaXgU0p7V2rOW/fc3F70gnBBWT/3/u5AyN5wt5NpErbjq4BgA1gLOG+gj7jSQzdc59
 77XY26AktedzbvBxhE5EvmQatoVqMIRyyceHYodIRV5/lVwpX4JA88Akb1nG5heuWlma
 1GBeTlgQnwf8bXVBrHbnk6aDEjidca4NTn0BIY3JrMmzRKHcs5F8OCfKYV2NAGEIFchQ aw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0bfbjyqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:57 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411EPr13028267;
	Thu, 1 Feb 2024 14:25:53 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0bfbjy7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:53 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411C09Je017793;
	Thu, 1 Feb 2024 14:25:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwcj04svh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411EPWDU44826916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 14:25:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DB5320040;
	Thu,  1 Feb 2024 14:25:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 367A42004E;
	Thu,  1 Feb 2024 14:25:32 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Feb 2024 14:25:32 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests RFC 1/2] lib: s390x: sigp: Name inline assembly arguments
Date: Thu,  1 Feb 2024 14:23:55 +0000
Message-Id: <20240201142356.534783-2-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: tqWk0kigppIqsiSkonAeMHtOdv_2Jo3w
X-Proofpoint-ORIG-GUID: ZaH1l_94SaLNaTNrI_akVV6ATaxgQTs8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=789 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2402010114

Less need to count the operands makes the code easier to read.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/sigp.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index 4eae95d0..c9af2c49 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -54,11 +54,11 @@ static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
 
 	asm volatile(
 		"	tmll	%[bogus_cc],3\n"
-		"	sigp	%1,%2,0(%3)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (cc), "+d" (reg1)
-		: "d" (addr), "a" (order), [bogus_cc] "d" (bogus_cc)
+		"	sigp	%[reg1],%[addr],0(%[order])\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc), [reg1] "+d" (reg1)
+		: [addr] "d" (addr), [order] "a" (order), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	if (status)
 		*status = reg1;
-- 
2.40.1


