Return-Path: <kvm+bounces-47171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB0DABE2A3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 20:27:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A0863BF78A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB5C280A55;
	Tue, 20 May 2025 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PzJmmwId"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700BB270570;
	Tue, 20 May 2025 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747765610; cv=none; b=P+BU424B411yEP4rWInGCV/0x/Di2jd4CMliJjkZOWtWiJ8hvGgK+40C3SmA98EX0buhAh56rqBkuoxta/LfQd5ikIi4v585IApqxWv1QieaF4s6C8k7pnPUzlfpmIPRow7+5MZYvvkiIAosRUR2cwqhe+kDCTJF3jvTrGN25wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747765610; c=relaxed/simple;
	bh=EYnzR96PwCeBR3KKYudUJT+Aq7RXpH2C9hrMtaI4EQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjQx267EYME/AyhMLs68fPmQTRYyMYvwEjSmlMoSjQ/+ZbIrPt4ZSgj9nXQlFIWesG2aRiv9Qg0FfCYTeWj214hA3YXQFX0m1rDa8kjBMzZp5dWXSpQEoK5/86sqjRpBr48om4zYkwkeWQnONgDZKNnzJe7L1bD5pkRgQml7coI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PzJmmwId; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KHPlPT013199;
	Tue, 20 May 2025 18:26:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=f0jpWTRUglvKLJXPn
	0713SU1VgSFfOdem/Tcgr7u5wY=; b=PzJmmwIdJqRIjrudyODTYky4MdwWSgL5+
	O4j2sHLhYoot1j2qdyEvI9S50zJ2EBkSgJxySIQzT7lbT9Y/4f3e3XTyMYEfrtS2
	yrSCTrtqPmCVac9TMKc6JFLQuMZ8iSnLExjwejwV9q9lNiEpmrZuKC0vNmla+uDV
	CGCacXCk8OqR0Gm7sNy/w974Nq5kss1RFgYRuR4cI+TynV0z4SnTmx9wwm0Op9hw
	KdzE2KwSymquQTLbsTZsfxHj1c0GI2eWktOA8s4DU9geOBAVpkBM4AwAaW76vsJL
	I3RUeuIbB/EjWbAbMBx7QW0S5F2cXI84SBZRE7SqBVkz/xB8gv4kQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rx47g944-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KGrolk015480;
	Tue, 20 May 2025 18:26:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnn8d2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:43 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KIQeBD16056600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 18:26:40 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28F592004B;
	Tue, 20 May 2025 18:26:40 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B38492004D;
	Tue, 20 May 2025 18:26:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 18:26:39 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v2 1/5] s390: remove unneeded includes
Date: Tue, 20 May 2025 20:26:35 +0200
Message-ID: <20250520182639.80013-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520182639.80013-1-imbrenda@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDE1MCBTYWx0ZWRfX+2dgwKkrJkh/ PmCzxsff4ffTyeonJK2Zfw4hhrVOOjcdQTzZ3wux0zK3j2vEJ5Ktzlbjof28S9fRWHk7oXwIR7S ZkmSmJQ7OfebrXcLga+4xtqJszFGaMBO4l4mR3CdOGtHhgbeW1N7CSEl1X1u79ogIo8ZLTfX8wT
 wVur2+44zR7svsketj5g7+4ZJmLzTXL3oVbObhpHX3VSZoDsGyoNAxIf3sAAmhf72LRLO8xXnvO FrP6QMPvGNbU+moakFliJvH1AyEBjz3swH+RxBIVvl4QvMfd5YY5dxh3hiHlkKUPdrAvABxWl4Y foJXdzp6AzgKI1w41hjdgiTSDaLtliO10QD5ebAznsXcGwNbWudD+ST5ujhctZC5gFeP/nZX5Ha
 DuXeOTeVtoJeYMDlY4gK7UXZcGA2XtfNsvzeOtMPT5HvGPsSw0AytQBf5gpjmoUSK0xZSP+y
X-Proofpoint-ORIG-GUID: xus8qlNTSQ0EVxgn9L9MTzsZjtpswsTm
X-Proofpoint-GUID: xus8qlNTSQ0EVxgn9L9MTzsZjtpswsTm
X-Authority-Analysis: v=2.4 cv=YqMPR5YX c=1 sm=1 tr=0 ts=682cc964 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=uOUJJYmQgii9-mSc-xUA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_08,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=895 spamscore=0 phishscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505200150

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


