Return-Path: <kvm+bounces-37097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C4EA2547F
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31C2C3A3419
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2E91FC0FE;
	Mon,  3 Feb 2025 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="L0Hiqjne"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45A81E9905
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571803; cv=none; b=KfKfhrjKlKLb0SaQu14HL04WDkZcviS/I5ei4Tto0xMHhKBCMSrRJebXpc5jHG3knZu67Liws9ZmYDuA0HZQhOTr9mhpwcoP46DrxUAPRhOy2uZ0t3yQlXVmjiYrhX6neIIVDcoWuMVuS1HkUuNUJjQQYP+fgbpygcOA0yC56ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571803; c=relaxed/simple;
	bh=7+WUnlbRSofeOesk/qxJSNjQ278JVN/cIom+zd+gUMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOl8may3LsguLbWGrPlg6+3c1u3coJfNFaE78FdVET+sU25K3SogvWhJR3NTdal9sFQOieGZOXhcceSmWPRg0ltq+K9d4cqEAoXTCwh2FxIsqIHaaD3tGHJGjTOkrWuh2YeMtpswksB5ed/Fzl/OGn+PKeb6BhhJ7URH07z5tjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=L0Hiqjne; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51320iP2006199;
	Mon, 3 Feb 2025 08:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DbRdQ4X8TM2Ttacu3
	Zt9a3hk+MaMY48vyuhq5rsZdng=; b=L0Hiqjnek1ztsIRFQ61f5CIdFwhDaWRgz
	WQUbucqKmCwtMmTU42ri0oNuDZehMg77dgqHLiJCAx4bHeEnU40PJlBPB0YLKrzY
	I/w0ns60e10APf17kx0gq5/kfaDAs8xyXIfsWJLWmeerg3xlWm8/QBkvhR6KMWtJ
	mcXoiVCkM2fdMJjet3Z0Td6xoTp5/IQXSvkIe+TwVlNZav80LjxqYYMHk+wYhovV
	w798ZFT+2wJTPbeTeab7gzkt8ZfENn6/FCAoH2oKxBIZMvZmaEsbM5ROhFEwNCM3
	oH2uCjMvfo/CysReQvbkmWFiwrXVEuIrQxOif2Hd0G6T6wQi3fYgA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jmmy9cc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:29 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5137pb3I024492;
	Mon, 3 Feb 2025 08:36:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxmwe3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aOeb56623388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6D0220040;
	Mon,  3 Feb 2025 08:36:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 562B02004B;
	Mon,  3 Feb 2025 08:36:24 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:24 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 01/18] s390x: Split and rework cpacf query functions
Date: Mon,  3 Feb 2025 09:35:09 +0100
Message-ID: <20250203083606.22864-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zeFQ08hIPYnoiACM54_xPvoPIaWklzM0
X-Proofpoint-ORIG-GUID: zeFQ08hIPYnoiACM54_xPvoPIaWklzM0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502030068

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Cherry-pick 830999bd7e72 ("s390/cpacf: Split and rework cpacf query functions")
from the kernel:

    Rework the cpacf query functions to use the correct RRE
    or RRF instruction formats and set register fields within
    instructions correctly.

Fixes: a555dc6b16bf ("s390x: add cpacf.h from Linux")
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20240621102212.3311494-1-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/cpacf.h | 77 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 10 deletions(-)

diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
index 378cd5cf..ba53ec31 100644
--- a/lib/s390x/asm/cpacf.h
+++ b/lib/s390x/asm/cpacf.h
@@ -137,19 +137,76 @@
 
 typedef struct { unsigned char bytes[16]; } cpacf_mask_t;
 
-static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
+static __always_inline void __cpacf_query_rre(u32 opc, u8 r1, u8 r2,
+					      cpacf_mask_t *mask)
 {
-	register unsigned long r0 asm("0") = 0;	/* query function */
-	register unsigned long r1 asm("1") = (unsigned long) mask;
+	asm volatile(
+		"	la	%%r1,%[mask]\n"
+		"	xgr	%%r0,%%r0\n"
+		"	.insn	rre,%[opc] << 16,%[r1],%[r2]\n"
+		: [mask] "=R" (*mask)
+		: [opc] "i" (opc),
+		  [r1] "i" (r1), [r2] "i" (r2)
+		: "cc", "r0", "r1");
+}
 
+static __always_inline void __cpacf_query_rrf(u32 opc,
+					      u8 r1, u8 r2, u8 r3, u8 m4,
+					      cpacf_mask_t *mask)
+{
 	asm volatile(
-		"	spm 0\n" /* pckmo doesn't change the cc */
-		/* Parameter regs are ignored, but must be nonzero and unique */
-		"0:	.insn	rrf,%[opc] << 16,2,4,6,0\n"
-		"	brc	1,0b\n"	/* handle partial completion */
-		: "=m" (*mask)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (opcode)
-		: "cc");
+		"	la	%%r1,%[mask]\n"
+		"	xgr	%%r0,%%r0\n"
+		"	.insn	rrf,%[opc] << 16,%[r1],%[r2],%[r3],%[m4]\n"
+		: [mask] "=R" (*mask)
+		: [opc] "i" (opc), [r1] "i" (r1), [r2] "i" (r2),
+		  [r3] "i" (r3), [m4] "i" (m4)
+		: "cc", "r0", "r1");
+}
+
+static __always_inline void __cpacf_query(unsigned int opcode,
+					  cpacf_mask_t *mask)
+{
+	switch (opcode) {
+	case CPACF_KIMD:
+		__cpacf_query_rre(CPACF_KIMD, 0, 2, mask);
+		break;
+	case CPACF_KLMD:
+		__cpacf_query_rre(CPACF_KLMD, 0, 2, mask);
+		break;
+	case CPACF_KM:
+		__cpacf_query_rre(CPACF_KM, 2, 4, mask);
+		break;
+	case CPACF_KMA:
+		__cpacf_query_rrf(CPACF_KMA, 2, 4, 6, 0, mask);
+		break;
+	case CPACF_KMAC:
+		__cpacf_query_rre(CPACF_KMAC, 0, 2, mask);
+		break;
+	case CPACF_KMC:
+		__cpacf_query_rre(CPACF_KMC, 2, 4, mask);
+		break;
+	case CPACF_KMCTR:
+		__cpacf_query_rrf(CPACF_KMCTR, 2, 4, 6, 0, mask);
+		break;
+	case CPACF_KMF:
+		__cpacf_query_rre(CPACF_KMF, 2, 4, mask);
+		break;
+	case CPACF_KMO:
+		__cpacf_query_rre(CPACF_KMO, 2, 4, mask);
+		break;
+	case CPACF_PCC:
+		__cpacf_query_rre(CPACF_PCC, 0, 0, mask);
+		break;
+	case CPACF_PCKMO:
+		__cpacf_query_rre(CPACF_PCKMO, 0, 0, mask);
+		break;
+	case CPACF_PRNO:
+		__cpacf_query_rre(CPACF_PRNO, 2, 4, mask);
+		break;
+	default:
+		asm volatile(".error \"bad opcode\"");
+	}
 }
 
 static inline int __cpacf_check_opcode(unsigned int opcode)
-- 
2.47.1


