Return-Path: <kvm+bounces-62190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0653BC3C591
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16BF06221A2
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A0734E759;
	Thu,  6 Nov 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RsnrYP8s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8221630275E;
	Thu,  6 Nov 2025 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445488; cv=none; b=fPB/0qLP/uXiqFJPC6BFChx4Z3fJ+D+SL6ZM+1Yz6POCA883VLe+uCNL6QM8CvBx3t/MzgIVvjndDdkRvyjVi/MVBZPhu/FZXbVjBLoLG/QZh3/F3hjh0yLol1GTomH3PMLFgglHB2drvYYDoDHUCPLwDDTJ9TtCcBade99WJ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445488; c=relaxed/simple;
	bh=O0EsD1gtDqsNUpD5KJ8RrZzqfi0ETeDn23cSDysRepc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKfTRvufkp7euuiN5ggDTikaQ3G91B+y32Nlc0dbe6KslXrFB5B1qCluWsBGMRXKb43SobZkC7tY7Mn6IuvjzJis0n9tMApqb4tlcXxfEF1m8m1mlccwlCh/Dkjh8yV2OgkWytLGh7AcdQ3ftkBjyZ08JiPJvVMZpTksw9ZqDro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RsnrYP8s; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A67MjcH030753;
	Thu, 6 Nov 2025 16:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=JJ5oJp/7b3c6VXTqa
	LGQwXDgqVHNhPtq4NNCeUt6dhk=; b=RsnrYP8sBWm9WB7vP/LQCZCML9OI3ZzKJ
	qH+R4+ahgDK18VLQRgMhqbDxJfb01hy2qdjGQLmMKAJMlrlWE4pdRQX2fa0vrSvb
	y9ELy7zZXAWRThcmDOQTtVpQhUPo0NSzt63pePgd7eK8Pbf5xSPUFFJs9Iz2bog0
	HE27gjIvadjI8dUzWC6qCz0c/1FZ7ebF5pL9SbSPxYCV+eYJJ50QqeQm0kn5xWji
	vDEBrVtAVkSNbYZ+d6SjRAgHCRMVhvoYFREpYe/XEQEv0lFAxkJBlX/06sgkoa0o
	40zr+a+xVFS7zaWCwSQk7VnYW20wa79YXQI5s8D3+qmkYi+UCreAw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vur6v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:23 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6CqSnT012872;
	Thu, 6 Nov 2025 16:11:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5y8262ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBJxr43712854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6153920040;
	Thu,  6 Nov 2025 16:11:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F03C62004B;
	Thu,  6 Nov 2025 16:11:18 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:18 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 03/23] s390: Move sske_frame() to a header
Date: Thu,  6 Nov 2025 17:10:57 +0100
Message-ID: <20251106161117.350395-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106161117.350395-1-imbrenda@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qsxgQQP-68XNs3sBXNPQ2MUbMaClw2IX
X-Proofpoint-GUID: qsxgQQP-68XNs3sBXNPQ2MUbMaClw2IX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX5kqqkPt4wNMW
 qQky0LUlTPoMHwwY2QcT1QyST5Fi4isKLgD1PhtmrnYxgeLGNbLSQqOFDq1/sYZVSWkRBxoFoXg
 j5ThNDGV6AytS7ZgqvCsKbT33AENqV0ZbnSNnRJ/tM51d1nxodNx/t0dGWbXoiacg/nysY8ylzx
 mdFAssVko6Vrhn8NAu3ThAK/Tjk2lZOL4efXFNZj/hkB11YJP3KJkSDpQ6UEpcRlmTiufVL/RO/
 dB4n5kqWTFxRLbMyC8TpEPfl3EbOFWgKm8/GNjihLU4RPxsiXk6afmQVFuSJA+HqhiwfNBOxGRI
 BULlNaNJ4fV7FweEs4PNi+m8pLyEuGjhelQ/zHvmJfpXKbcGVYnF+P94CQlB39ROcJtDTkNXA/s
 fuNN6AupC7nVnihKotqCa2F9ytEhrA==
X-Authority-Analysis: v=2.4 cv=U6qfzOru c=1 sm=1 tr=0 ts=690cc8ab cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=-u9FmCOoZJUNk1x3bJoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511010021

Move the sske_frame() function to asm/pgtable.h, so it can be used in
other modules too.

Opportunistically convert the .insn opcode specification to the
appropriate mnemonic.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 7 +++++++
 arch/s390/mm/pageattr.c         | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index c1a7a92f0575..b9887ea6c045 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1148,6 +1148,13 @@ static inline pte_t pte_mkhuge(pte_t pte)
 }
 #endif
 
+static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
+{
+	asm volatile("sske %[skey],%[addr],1"
+		     : [addr] "+a" (addr) : [skey] "d" (skey));
+	return addr;
+}
+
 #define IPTE_GLOBAL	0
 #define	IPTE_LOCAL	1
 
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 348e759840e7..ceeb04136cec 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -16,13 +16,6 @@
 #include <asm/asm.h>
 #include <asm/set_memory.h>
 
-static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
-{
-	asm volatile(".insn rrf,0xb22b0000,%[skey],%[addr],1,0"
-		     : [addr] "+a" (addr) : [skey] "d" (skey));
-	return addr;
-}
-
 void __storage_key_init_range(unsigned long start, unsigned long end)
 {
 	unsigned long boundary, size;
-- 
2.51.1


