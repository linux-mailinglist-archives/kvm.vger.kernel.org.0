Return-Path: <kvm+bounces-20233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 377BF91224D
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A292D1F28237
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31EFA171E53;
	Fri, 21 Jun 2024 10:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kDTT6JVg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4974171095;
	Fri, 21 Jun 2024 10:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718965346; cv=none; b=rR0zrK9Xnvh7+YnuAp/fjTrMM2QcTT6SdmNyZVFD6SNuTWwp+yMqSzew1+51GE48dTVm+jTK6kXsMQChBy3FlZbQ5NvhJdNg3FK0kI/BPRWpIofMvqt4kr0bAShRErEZVAkFr5JQrEM8MP0jmlUqTEiFxaqWznfyFMon1gNEFxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718965346; c=relaxed/simple;
	bh=TIQPrXwtPrBb2xR+E8JUyrOCQGo5HL53+xppydYYS0o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bK/Xt9Axy9jYf+zBkmcyQY5OU/PrMd3fvIkFJYEawBFe4nqRgqVd/G37MG8gdJcuNYEOHb3EVev1gqwZQWlaqZFVJao1ZQ+HRB9dXh7AJiV26poCVoxHNfNkWpzssiqCgsG7Dil94Rhy7SNrCn+Ues87e4Q2ti4vfLqkoANeWe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kDTT6JVg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45L9SUPd029793;
	Fri, 21 Jun 2024 10:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=qAgKdlvJiaR93zpf9odqulM7vQ
	NS3bQ6TLmE6TFY8UI=; b=kDTT6JVgKxz2+PD3MkAFRHqyZnXqkUG5l+cj536mh2
	D3P7LEc/8y+R/mzPkyoI8AFArgeKW0pIHzDf/99iPmHvLA0m9O3vFZo3tv2/mpEj
	fDoHxpvNY/bX2REdz9kRcJvNOAWs/Mmj3mLceqH300mE1A5rL+6Dc/jtjjXEnJYN
	2Ha5qcucTO+LgAuLohf9pXKtA+ugT46za0gAeg6VIj/Bmx2fErs77i96f9qfj10F
	nGJv1DatGT2hh8j5kzI7YGNV2W8GtsD7mDfBB1Q6xiljss4Uu8qwNNRPfC1bU898
	eMUAGe+hRIDQPOKGA71EPd6lYnKPk0+VvNu2IjKB2wPA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yw6wtr4s9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 10:22:22 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45LAMMk4017705;
	Fri, 21 Jun 2024 10:22:22 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yw6wtr4s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 10:22:22 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45L9FiuX019922;
	Fri, 21 Jun 2024 10:22:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yvrqupm3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 10:22:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45LAMF0n51380504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 10:22:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80C4320259;
	Fri, 21 Jun 2024 10:22:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59A2E20258;
	Fri, 21 Jun 2024 10:22:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Jun 2024 10:22:15 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v1] s390x: Split and rework cpacf query functions
Date: Fri, 21 Jun 2024 12:22:12 +0200
Message-Id: <20240621102212.3311494-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8PP-rodhGDz1f2NwTFx4yEJuoexzman0
X-Proofpoint-ORIG-GUID: Esh4FnuQATZ__trmmMY__oj19CZJl2UH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_04,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406210073

Cherry-pick 830999bd7e72 ("s390/cpacf: Split and rework cpacf query functions")
from the kernel:

    Rework the cpacf query functions to use the correct RRE
    or RRF instruction formats and set register fields within
    instructions correctly.

Fixes: a555dc6b16bf ("s390x: add cpacf.h from Linux")
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
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

base-commit: 66fdb0333237161fb9644b4a41a200af5b8d20e9
-- 
2.44.0


