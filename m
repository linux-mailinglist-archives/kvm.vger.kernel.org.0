Return-Path: <kvm+bounces-46521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B47AB71A2
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02C2C1B66502
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291A127E7D9;
	Wed, 14 May 2025 16:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ETqXOEPx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2E927B501;
	Wed, 14 May 2025 16:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240746; cv=none; b=YE3Iz844NwLs16NLHNOQA6RUsWLV3jEgB5jQKzANlsYHLNynPeLmmR1Puoy5L65j5GWeUJ5FFRIImfQ2AxJ5GFAfsJ0kxOsRhqPTmHC57OXExgsIPrBOQugr5crDuEpVw37ynV7QSJdSiGjC1a1NhuQ9NtpVoObq7jrfRyjmj2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240746; c=relaxed/simple;
	bh=v5oJ6LelhKm1BMisOq88FXrXEk7LLz1XOmZv5UdWLkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrXMW0wuvrTOc+aoXlqJbLYn21XfKZ6FpI6UZ6VErSBCEL1lylappDX8Ou7acKrqaEk0fKsbcyPaEnSJi/KaC4385GT+tevvw2zxmZweppEGlC8PT0iTq2kDee5YQU6wkPZX7g5jwnLbTi8DQc6BX0VhogTgLH4cj9jFj4t66GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ETqXOEPx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EFrJl8024793;
	Wed, 14 May 2025 16:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WGmFhySZ+qQk6Nvva
	nCfjh0KpSa7FtwQiRvlOxz6uEc=; b=ETqXOEPx07G55VETYnoHdWhu4DFg/Esyt
	49i8sIl+9oSk1FKGXGWdZdfpntsSZLCRTKyymkzLmNJiYobx3U/QElbT+2RWk4IC
	q0Xlp4JsI4AtpMHc+FXoe7FVgmEjIwlME8f7wfO6qGfzo1/vZteN8FXcSRomeo2C
	UWpqjuK/vBOicly8xcAGTgW6I+TbEiq3tzgMA7IDptuweJgty0vVusyJY33ueTFJ
	sWxHxQjWk5oTR0oDj8uYPT6R/DsDKJdsncyMRsXyFkidKoRPe9dh8KrXNgbvUn/k
	Yp38Wfxjg2S2tHmsYFLE2YGaUNijBPiO7vXwdUJh+3ii16oBR9rOg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mbs6nf0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:39:01 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EGaBfb021797;
	Wed, 14 May 2025 16:39:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfpn9y4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:39:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EGcuHM52560364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:38:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE6AD20043;
	Wed, 14 May 2025 16:38:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F56E2004B;
	Wed, 14 May 2025 16:38:56 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 16:38:56 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v1 1/5] s390: remove unneeded includes
Date: Wed, 14 May 2025 18:38:51 +0200
Message-ID: <20250514163855.124471-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250514163855.124471-1-imbrenda@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0OSBTYWx0ZWRfXzHHD2sr7LjA0 X6co1Iyx+iH3ldUXAhC5wDxvEpsIpIezmwBuoAIvuK9akRY8p8AXywpKvX29J+7SWB3Rxg+J19T apHzDQLr9CZCZdIHJfqhn8hUQhpKL4XOk1afQgcIp1lCS+ZYbzJtY2f/rM/aXZrilp/3+3TGS7x
 2QAueor9FUR9KF4r0A0oRdjqlsutNUUjmyMEbBhhV+PFhA65rjUvrmjDiP4qJfk3A+boVyMtoFh fdjpEqpKroXKYGTRaSIf/LY3r/4aJ3o8o7XAFn/fpVcv3lTZ7lbrtnUpiOGkqhTP7ZJ0hFc164F LM8zAaUdzy04tArCjayPwqJmjmP7sqAS1z6z6t3atrenTVQCCcS2O0zs604pLc7l7psHGEjmXvW
 bz+SwgPRctR+I3xiTALt25TbBQ5rMOWDWfGB+u+NtSNX5E2hF0MG1x/P0FGaqvFDSIgBcgNN
X-Proofpoint-ORIG-GUID: X6lkkZRtUxm0xMKPq0UDGKVt39QUySv4
X-Authority-Analysis: v=2.4 cv=d5f1yQjE c=1 sm=1 tr=0 ts=6824c725 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=uOUJJYmQgii9-mSc-xUA:9
X-Proofpoint-GUID: X6lkkZRtUxm0xMKPq0UDGKVt39QUySv4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=892 impostorscore=0 adultscore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140149

Many files don't need to include asm/tlb.h or asm/gmap.h.
On the other hand, asm/tlb.h does need to include asm/gmap.h.

Remove all unneeded includes so that asm/tlb.h is not directly used by
s390 arch code anymore. Remove asm/gmap.h from a few other files as
well, so that now only KVM code, mm/gmap.c, and asm/tlb.h include it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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


