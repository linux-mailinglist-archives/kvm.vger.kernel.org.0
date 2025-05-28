Return-Path: <kvm+bounces-47867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3142AC665F
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AFFF1BC3618
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E6D279903;
	Wed, 28 May 2025 09:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="J1aPkCBf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC35E279331;
	Wed, 28 May 2025 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748426119; cv=none; b=DtHNlcUFiadMCLn1qloALrE/UyGfiRhtbhUevJl+umgkhZtdxbNDCqe0gu0zXQCUjMzAQpdHBvRBLrpJDhMLbYJ9gZ7/GrCNb+Tlgf5CS5fKd8yYMFnN0dpkOJe4/XQ9VVZjJPcAwfsexjx5nfJS8e9oHiHm6ZcRwLp7kfsvi3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748426119; c=relaxed/simple;
	bh=tArMraglxvVR9KrotQEW33m7Zz0WJJ8VpupjZF07330=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbYxb0k3yHF7NPIrZDJe20cH6GaDfzCYs98e46S3EXbHjWB8IzomkDmUaT6BkjHEDxsXZxQkui4MaiIcdqQ/sTtl5eiDh0kbitbMOPE70Q2ifCbuLb+W6qvlOPc+Gyrs9zOZiYbVAhGx3JhYbN6jZwiQ9i7TC8RxV36N7xkm+vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=J1aPkCBf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S5ZI4a007511;
	Wed, 28 May 2025 09:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=oY8PYJbucqHEHEszC
	WunNeVawt4iWY4/uQ4jvDFdkiQ=; b=J1aPkCBfZj/T/YclIelHPb+L/FEsus3uI
	6TxTYWgh4xRPVBeEKimveMKLBIIc0+n+i8LLWpkWJe6yL+YI5lDiwIN5v8cnT4mH
	8WnFVkZEZrqK0fNudldvPzsvDd79OTvvgVq8KxCFi2x0VGzCQwNFae+Xfhsx7mJd
	Lu/kMxeRHwa+cY5osLpcdAN4ZiTTrTqBtvXlk71V0oPlrkDdr5DkUivLexy9HGuS
	FkxaOrHTXQYhuQvzA72lZMhmea8k8raUx06cK4/3iV93dXzsTrb8daLwD385r+5g
	tvFIIHCJzCiX1T3QdNg7VtyfTiynTiVCxxN8t3X0NO/sRbNE74kBA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wvfb13vp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:55:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S6cBVp026432;
	Wed, 28 May 2025 09:55:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usxmxvnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:55:13 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9t95x13566262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:55:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 942792004E;
	Wed, 28 May 2025 09:55:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D749820043;
	Wed, 28 May 2025 09:55:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 09:55:08 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v5 1/4] s390: Remove unneeded includes
Date: Wed, 28 May 2025 11:54:59 +0200
Message-ID: <20250528095502.226213-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250528095502.226213-1-imbrenda@linux.ibm.com>
References: <20250528095502.226213-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA4MiBTYWx0ZWRfX/M2avtk+06Mb dMcF6ex9wj7WrOzMFraXPRiHaFwbNv1a0fDWAIbxYAD5+Pjgs987FB+Tha9YK5KWwCVgkJ2Ch4+ /ow44yK/mUlF94tzBmPoVVuJpLpQGs+fVKlzx1Z0AkJu2eKBYEBESj0k99ItJ9RGW/3A5aj72Ia
 dGWtcL56JGZbIsHxGZVOfnOnCaknMJVCa9UyC6hmwoDAhHElonU14U8BeiWjXOXkIvAuj6s3QwH XEWCiOa7YCI2LXaRs2jVJvXLsFGvzXHGo4R5QlaCegwAB2k6yxODDJLqyJn35BVpVqE1v/rqcP6 1ks0Ut2bVcEs0T6wd189H1/SR45D7Eg7izVA8MMfIJ1EW8a2efEue14lxw8DRlLS6y/dAko4t2q
 rD1Cdu0Tx5d708HBexz0OWjDAF357sxb2bE8msbbzeuulAUJDVt4+RgyiGJtRtCZp9FRAWRT
X-Proofpoint-ORIG-GUID: XrL39kSBKUTELK1IwRoytPnGua0I0LPw
X-Authority-Analysis: v=2.4 cv=bt5MBFai c=1 sm=1 tr=0 ts=6836dd82 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=uOUJJYmQgii9-mSc-xUA:9
X-Proofpoint-GUID: XrL39kSBKUTELK1IwRoytPnGua0I0LPw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_05,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=950
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280082

Many files don't need to include asm/tlb.h or asm/gmap.h.
On the other hand, asm/tlb.h does need to include asm/gmap.h.

Remove all unneeded includes so that asm/tlb.h is not directly used by
s390 arch code anymore. Remove asm/gmap.h from a few other files as
well, so that now only KVM code, mm/gmap.c, and asm/tlb.h include it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
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


