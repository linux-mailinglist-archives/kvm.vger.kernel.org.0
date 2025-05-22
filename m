Return-Path: <kvm+bounces-47368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F0B1AC0CA0
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B45D71BC30D0
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A850728C2B0;
	Thu, 22 May 2025 13:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ofmrkAc/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F8F28983A;
	Thu, 22 May 2025 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747920190; cv=none; b=bVuAbhWlh1hVHvHET0H1pl9fZrGdMn7X1dc1+d+mTmEgYSSWtW9TOBTMDOJmDGVZ/rc8oKAtvzXW94NHgljmpnyXupwAcxC2nIZUVRyG+1Vx90r2sAYCZ5Lzg/v/rPKJv5MYqGydO30iE+WX29etwe5xvif1kPEQnhzOpqcCIpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747920190; c=relaxed/simple;
	bh=EYnzR96PwCeBR3KKYudUJT+Aq7RXpH2C9hrMtaI4EQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi4bA05zMqTtzsh1ptXzgk97XrLjJkLSH6LzL0ATY0nFHO6PGNuDpi/8ctyd62zaJ2IYLzxjJ6YKQiAU/XU5+w4SbcB6qev7GMPyLVGX55DdRKa6qN9sqK614jgavajM9opd8OM/NTF4U3lOwwMJoq/q3JQeSq6wP/Ty8y622ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ofmrkAc/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6JVFw010297;
	Thu, 22 May 2025 13:23:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=f0jpWTRUglvKLJXPn
	0713SU1VgSFfOdem/Tcgr7u5wY=; b=ofmrkAc/o8xne5Bss8mCGwwrpTJT+W+LC
	rlxULu5Pe5zSoIlrWZvaVelwwZVv7p7Er2LmtkieDr7kbkQz9PYexH37DAQNaBzS
	JkpZ8/ix4RYei/5fo6YTtQ8fdkZjOsy9wvmxtBiqPqTKKiFUppdEL32ilFcnzcco
	JV84tAg7OMumVlSZnoPC6BECbzIjnBl8xEynAatrIkKlSlOVquV5gx9MwHbUJlXl
	yx2kJmbPlRZiGPeT62/JCu5a1AP6NcPkwqd1/c7Mi5xcRdi990js6mI4fYqa8c1J
	UJXgQ23z7WmczURKHVW6Ux9S6Wqp6SdLV8yAmA+vLfjx2xcyVceMw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sxhw9w6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:23:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54MDF5Bd015497;
	Thu, 22 May 2025 13:23:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnnhjyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:23:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MDN0fH16318908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:23:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99D3720043;
	Thu, 22 May 2025 13:23:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 414A02004E;
	Thu, 22 May 2025 13:23:00 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 13:23:00 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v3 1/4] s390: remove unneeded includes
Date: Thu, 22 May 2025 15:22:56 +0200
Message-ID: <20250522132259.167708-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250522132259.167708-1-imbrenda@linux.ibm.com>
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEzMyBTYWx0ZWRfX/O9p2jRADZPH NMc8R5t8ielqBddrDLF+mmr8H2h7ranVGaATTK00kSRkUqEXHvB2YjgEcFDIdrv7xMIpj28wN4+ C05Vca+eT+lSbM/NOM4denxVbAtSsapPw9GcoIqsAT8vomswtQ4Q+ygXoCBis4hOSIYfEFEV2ZE
 xC1vubS8s21knlUrrxAENrlWnjfyeTE3gOCZ06tL1LDVJyJX7EukN3kCg19nOOnx4cjuLtOhM88 zp7FdSn6tTANoVbL/8BYbnRkK0qEzV3niQI/CTMVU9CwVawVLzhwFUnJXFuYzk1YVyr5kAFaDou QR45tN96cC3LEFZYgWmjWCCzeI8bMLTq2NbiXFnMB1/Vm7WZt7/qFKOqFCnPDXdkiA+MITtEq8k
 5OyXO5pEgXUS/pQ/CHOCqzm2UVcx4rm22xA7f3iSKmXKS/sWXyOXc7XpSZYFuQoNFQDsmNbK
X-Proofpoint-GUID: G-eEn9EBuMzsQY3E6itn7h0t9CLADsnw
X-Authority-Analysis: v=2.4 cv=O685vA9W c=1 sm=1 tr=0 ts=682f2539 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=uOUJJYmQgii9-mSc-xUA:9
X-Proofpoint-ORIG-GUID: G-eEn9EBuMzsQY3E6itn7h0t9CLADsnw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=920
 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220133

Many files don't need to include asm/tlb.h or asm/gmap.h.
On the other hand, asm/tlb.h does need to include asm/gmap.h.

Remove all unneeded includes so that asm/tlb.h is not directly used by
s390 arch code anymore. Remove asm/gmap.h from a few other files as
well, so that now only KVM code, mm/gmap.c, and asm/tlb.h include it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/tlb.h | 1 +
 arch/s390/include/asm/uv.h  | 1 -
 arch/s390/kvm/intercept.c   | 1 +
 arch/s390/mm/fault.c        | 1 -
 arch/s390/mm/gmap.c         | 1 -
 arch/s390/mm/init.c         | 1 -
 arch/s390/mm/pgalloc.c      | 2 --
 arch/s390/mm/pgtable.c      | 1 -
 8 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index f20601995bb0..56d5f9e0eb2e 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -36,6 +36,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 
 #include <asm/tlbflush.h>
 #include <asm-generic/tlb.h>
+#include <asm/gmap.h>
 
 /*
  * Release the page cache reference for a pte removed by
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 46fb0ef6f984..eeb2db4783e6 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -16,7 +16,6 @@
 #include <linux/bug.h>
 #include <linux/sched.h>
 #include <asm/page.h>
-#include <asm/gmap.h>
 #include <asm/asm.h>
 
 #define UVC_CC_OK	0
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index a06a000f196c..b4834bd4d216 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -16,6 +16,7 @@
 #include <asm/irq.h>
 #include <asm/sysinfo.h>
 #include <asm/uv.h>
+#include <asm/gmap.h>
 
 #include "kvm-s390.h"
 #include "gaccess.h"
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index da84ff6770de..3829521450dd 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -40,7 +40,6 @@
 #include <asm/ptrace.h>
 #include <asm/fault.h>
 #include <asm/diag.h>
-#include <asm/gmap.h>
 #include <asm/irq.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index a94bd4870c65..4869555ff403 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -24,7 +24,6 @@
 #include <asm/machine.h>
 #include <asm/gmap.h>
 #include <asm/page.h>
-#include <asm/tlb.h>
 
 /*
  * The address is saved in a radix tree directly; NULL would be ambiguous,
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index afa085e8186c..074bf4fb4ce2 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -40,7 +40,6 @@
 #include <asm/kfence.h>
 #include <asm/dma.h>
 #include <asm/abs_lowcore.h>
-#include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/sclp.h>
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index e3a6f8ae156c..ddab36875370 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -12,8 +12,6 @@
 #include <asm/mmu_context.h>
 #include <asm/page-states.h>
 #include <asm/pgalloc.h>
-#include <asm/gmap.h>
-#include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
 unsigned long *crst_table_alloc(struct mm_struct *mm)
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 9901934284ec..7df70cd8f739 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -20,7 +20,6 @@
 #include <linux/ksm.h>
 #include <linux/mman.h>
 
-#include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/page-states.h>
-- 
2.49.0


