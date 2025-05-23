Return-Path: <kvm+bounces-47583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CFDAAC2360
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 15:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDA293B32DC
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 123CA199949;
	Fri, 23 May 2025 13:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s+cmdiBy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBC917A2F8;
	Fri, 23 May 2025 13:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748005439; cv=none; b=pvVqpNsR39+QdaYBshgEscgP2Ywpz/RulCKKBheY32W8NywNPwSkiqFsvt6A6jkOPjDmpvdA5Vns/TjBlwR6KXgnIlfmvXbgR0Y4UI2GHFPdHJIrHclPB7Oyf91ksg+AMN4rQKoqaaFZctM2gYet1e1qR1FaULHy6k5uGEKJecM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748005439; c=relaxed/simple;
	bh=5eioYwWNTZVAE9/fbKQNVzj1OIUNMyMx8SJ4jpcDeMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrtIpSwumJ+CUjtlySTQBY7dQb6PhKRPh6Ud+k+02xoYFyJgNPkvdMEcYu03bMF/1KI4j+J2bsFc2+bGOCn8EwGkwhX2huQ4CtSHbWjkR1w2bIF1pQaUhEHtM2I22TGY1PvP3Yua90B1p8uP4lGBsgVbKPM/th7zBwvYPvCRI2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s+cmdiBy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NAMA24024640;
	Fri, 23 May 2025 13:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=kHfAywIMEUzmWgd2W
	hNZm/QxbvLR0rWKXDx3c9n9f+A=; b=s+cmdiBysTPoQ1rFpPgYMYEb0uX8uZIG2
	TxXDyeQf28NZBeW4T14qIzWIzTy3tBNF8np6JFfiE6G/jE5LsapeYr1prLcckyt8
	0tM1uyaM8UZtneN9KT60jsZo73nnmg8ZzUu9DRzxK8rPfgySYqK8JDBGDMJ6J3+J
	WyHsW7KTVmLQ//aDsA4JJkTkG9ba3xDbEZAWYPpX36IHAYv8CoE7SCvSFRUB0dzh
	GN0cfRY/ZnZQdelnVLZ9WygW6vvV9uI7huGSK8PB8VyYUjJkyOO5N5X1m0rO+5sj
	rckgnbbIosEusANd1OEMaz8wQxx0H4E0MCDWsCdY4OumcBiwaYRUg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sxhwftqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 13:03:54 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NARXg1032087;
	Fri, 23 May 2025 13:03:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmpm3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 13:03:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54ND3nqD45351192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 13:03:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B484E2004B;
	Fri, 23 May 2025 13:03:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 523B32004D;
	Fri, 23 May 2025 13:03:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 13:03:49 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v4 1/4] s390: remove unneeded includes
Date: Fri, 23 May 2025 15:03:45 +0200
Message-ID: <20250523130348.247446-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523130348.247446-1-imbrenda@linux.ibm.com>
References: <20250523130348.247446-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDExNSBTYWx0ZWRfX8si4OMUuYGG2 jdjIWpsbHsiNZd9P+0fv/xEncS1pwiMwQXBO7dLFovNr45l9WmLHk/Q+TghqvyQaDB8BOgCGwG9 MeoXFqcIWZ0G5h1oXtluEMwBKg4bx1KTRddHiS7ZwEcmqN/yHI/+oRWt2vGXuVzYL+iNsL7RiBZ
 8XoFByyeopEkPEymJNmDUTclPoxjnIGmZEHqCwHjku1fZHYqpULF70Nbakof9d6nYIaJ6khYuZ1 /cZzKlBYDD2ZhpRyj3L/yKOc1o/J7OTTztyKKrcrz2eTHUSHdTWqjzrbqLVBGQIQK8Rt52Qc//A J0M0edp5NlyBN138QY072MEplTiTsOy15qPZxaYYC4Zr95wIThehE0oxiuMCgQuXgi9uU1B5Wgd
 WOe0wyJleLdrRZmbIh72WK/7kz25/EWj75EXvnQbaX3fTuJXaVwUc6ZPbN5ebJ3PMQBPt473
X-Proofpoint-GUID: efJ0o_R_N0FEdzxXcAh-2lQ7YFpa0FxU
X-Authority-Analysis: v=2.4 cv=O685vA9W c=1 sm=1 tr=0 ts=6830723a cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=uOUJJYmQgii9-mSc-xUA:9
X-Proofpoint-ORIG-GUID: efJ0o_R_N0FEdzxXcAh-2lQ7YFpa0FxU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_03,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=920
 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230115

Many files don't need to include asm/tlb.h or asm/gmap.h.
On the other hand, asm/tlb.h does need to include asm/gmap.h.

Remove all unneeded includes so that asm/tlb.h is not directly used by
s390 arch code anymore. Remove asm/gmap.h from a few other files as
well, so that now only KVM code, mm/gmap.c, and asm/tlb.h include it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
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


