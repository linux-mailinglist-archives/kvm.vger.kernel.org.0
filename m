Return-Path: <kvm+bounces-26969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DEA9979FA2
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 12:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C7161C226CD
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 10:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DDA155335;
	Mon, 16 Sep 2024 10:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c2WOwjDi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D16F153BF7;
	Mon, 16 Sep 2024 10:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726483556; cv=none; b=RGl2sRJa7mm5gIZMorof4E01K6O12qhC66KRtmBL/PJw9xR0bcWE7oxo7dYA+1R3Th65p8862vuv1ZowuOObL1lq8onc5R3xFBlM3wDRE2l2QmI2rxx9fJTZWR8lFRjmed3UNAeK+Yk4hz6D8XTB8TbHf4ftmXSXl1OUl50T98g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726483556; c=relaxed/simple;
	bh=9Nx7nZ6kj2wvYw37c/3nnEOLi0deG0u1zRROLJguC2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6DY1zfRaKmClPrg34v6OWFRoMjYYxDwIbwvyB8jzzUoG72/h8emaRJIThPPbn/Devn5DXIjU2gBV8dLVhGuWac2HvbMzzcgwbW+2XRYJji1H0xlG+j4pSKfkDfg7Uqi+pJCxyzDRh4Be65y9mAQT3c5v4Y0uI5Vc3eE02gy5Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c2WOwjDi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48FNlh7P018672;
	Mon, 16 Sep 2024 10:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=dLfvO2tYX1Ajp
	Ox5Bh3jfQVFZYs6rdujxXx3MgaDB7g=; b=c2WOwjDisLUL8Z2KxN81to+9twUQl
	vpzjsW65r7xsWUZ3XoIm9w0k5N9qHN+dtkOnyaSihxw/HOyigvAob5t815z1Dj7B
	DrI7FJKDhZ4SUhVgFoofVfqnoWbaqBriSgk+ne8ATpFNsx2AubqtowR3h484C2jO
	l03C+lDkOdLRppJZYqDeMLgGvGSgy9XQU6qTfuNguBX1GFYRRSkbx2zKDYnBSMQz
	Ap6opKNnonwZgC+WwhBdj7CBj6LJpQKlCXmrnmPclxZQZTlOfq5O6njrfsQ6JSQ4
	fRoK4DflWpENeNuo+3AEeExlsm0ScVrd+YFb7hWDXK8br1MuQQKKGfvfQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vd99ut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:46 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48GAjkSF029362;
	Mon, 16 Sep 2024 10:45:46 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vd99uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48GAjOIE001905;
	Mon, 16 Sep 2024 10:45:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nmtuf0da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48GAjfce53936444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 10:45:41 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0C5B2004F;
	Mon, 16 Sep 2024 10:45:41 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4279F2004E;
	Mon, 16 Sep 2024 10:45:41 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.179.30.170])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Sep 2024 10:45:41 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Hariharan Mari <hari55@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>
Subject: [GIT PULL 1/8] KVM: s390: Fix SORTL and DFLTCC instruction format error in __insn32_query
Date: Mon, 16 Sep 2024 12:42:56 +0200
Message-ID: <20240916104458.66521-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916104458.66521-1-frankja@linux.ibm.com>
References: <20240916104458.66521-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: stxnXUQne-ZcLulhgtE6aW_kzDEA-Jg8
X-Proofpoint-GUID: hU1v4Oj-qX3Sh2xuBbGhzkSSuGvxi1B_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_06,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=857 priorityscore=1501 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409160065

From: Hariharan Mari <hari55@linux.ibm.com>

The __insn32_query() function incorrectly uses the RRF instruction format
for both the SORTL (RRE format) and DFLTCC (RRF format) instructions.
To fix this issue, add separate query functions for SORTL and DFLTCC that
use the appropriate instruction formats.

Additionally pass the query operand as a pointer to the entire array
of 32 elements to slightly optimize performance and readability.

Fixes: d668139718a9 ("KVM: s390: provide query function for instructions returning 32 byte")
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Signed-off-by: Hariharan Mari <hari55@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0fd96860fc45..bb7134faaebf 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -348,20 +348,29 @@ static inline int plo_test_bit(unsigned char nr)
 	return cc == 0;
 }
 
-static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
+static __always_inline void __sortl_query(u8 (*query)[32])
 {
 	asm volatile(
 		"	lghi	0,0\n"
-		"	lgr	1,%[query]\n"
+		"	la	1,%[query]\n"
 		/* Parameter registers are ignored */
-		"	.insn	rrf,%[opc] << 16,2,4,6,0\n"
+		"	.insn	rre,0xb9380000,2,4\n"
+		: [query] "=R" (*query)
 		:
-		: [query] "d" ((unsigned long)query), [opc] "i" (opcode)
-		: "cc", "memory", "0", "1");
+		: "cc", "0", "1");
 }
 
-#define INSN_SORTL 0xb938
-#define INSN_DFLTCC 0xb939
+static __always_inline void __dfltcc_query(u8 (*query)[32])
+{
+	asm volatile(
+		"	lghi	0,0\n"
+		"	la	1,%[query]\n"
+		/* Parameter registers are ignored */
+		"	.insn	rrf,0xb9390000,2,4,6,0\n"
+		: [query] "=R" (*query)
+		:
+		: "cc", "0", "1");
+}
 
 static void __init kvm_s390_cpu_feat_init(void)
 {
@@ -415,10 +424,10 @@ static void __init kvm_s390_cpu_feat_init(void)
 			      kvm_s390_available_subfunc.kdsa);
 
 	if (test_facility(150)) /* SORTL */
-		__insn32_query(INSN_SORTL, kvm_s390_available_subfunc.sortl);
+		__sortl_query(&kvm_s390_available_subfunc.sortl);
 
 	if (test_facility(151)) /* DFLTCC */
-		__insn32_query(INSN_DFLTCC, kvm_s390_available_subfunc.dfltcc);
+		__dfltcc_query(&kvm_s390_available_subfunc.dfltcc);
 
 	if (MACHINE_HAS_ESOP)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ESOP);
-- 
2.46.0


