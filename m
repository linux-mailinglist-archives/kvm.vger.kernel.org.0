Return-Path: <kvm+bounces-62201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CF2C3C529
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAB0F1B265A0
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D923355058;
	Thu,  6 Nov 2025 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eGT8CcJG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592F83502BF;
	Thu,  6 Nov 2025 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445496; cv=none; b=h4SK7ofj47U72NicPmsbsv7vYK2Diw2HtNV46Ix5eUDBFv75a2um92lOwkVNunuYoMKrqCkiL8ahywYDVT9MOStkb0it523ScDd6d5VTCPREHF5VmRkewzepv3Z77lNJUwh6OllzWPaxnitkgM0Kvww0jvRUgIN0dAxmLqBZIhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445496; c=relaxed/simple;
	bh=MTi3IMyfIpH5uIGLzl2kIQglEVhAZyvpO8iu7WfFTdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Otl4U2oUtLeQV7EdP3MDpbvyptFDgbU1p4ksEcgxkIex50GyiUN0Dn5+FETohOslwIZlzBYv3uT7gO6S5j1r7xbsVf3mqBeJj9CJadX/LEWGQ/jashtgdg1a18wf1GLFcGykfQNuc32Yi8Nep2W4lANS82qgzmnx3pwdNsGPn/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eGT8CcJG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A68dBp8007688;
	Thu, 6 Nov 2025 16:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IgXJeX/MUhkT2bSJ0
	qN70lRMIyaIhhGLJ1UmfRz5X8M=; b=eGT8CcJG8/2xtCsXuQM24Gk9S9LkI2G/b
	6FooFUhp9vDkEw9vz8kuwQc/agzPxQmF8nxWu+mbSLOgzlc3pZjLKZndXMArYFlG
	/rVrSmQth6bceRtsZSCMX/Fp6zZilSNxXzGYgt5A+Lsy8dZ559JlaYoQjsnU4n40
	+fTzBZL3e0mFhvV3kDbN5F3oawuuGJ6+Cr8lolCjI8U/pmo0dr6+nNVFWq71Lf8j
	JobhzNg/8VPzCn+T6rloTke/fYr3O0kmjYP2dk2ymFb4NXmXe//3T9jCkJlbF03u
	PZIwyZtF83EoQ5m0fFIIy/OA8fek3qhipFl9nrePbb7ctU5AbZF2A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59xc84n8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6F5dII018757;
	Thu, 6 Nov 2025 16:11:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5whnpapb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBQAv43712894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E55520043;
	Thu,  6 Nov 2025 16:11:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCB772004B;
	Thu,  6 Nov 2025 16:11:25 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:25 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 17/23] KVM: s390: Stop using CONFIG_PGSTE
Date: Thu,  6 Nov 2025 17:11:11 +0100
Message-ID: <20251106161117.350395-18-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX9aQ0m8poHYa+
 2oaG0eJXtAH5CU0O2sV+RjjvT7U8yalzK10LiW+b0/qwCrBQB6ciS+WMqtaYqoyvBVUhnPLLWXj
 /k7bk0oLGoTnnlDEKnpqAGq6pKpL13VvyFKQuHQzBx+ZMDFV8uf87FFXcuJs1jlyFhDQJE3ZNoP
 UvGMJbhEeHLY95eF3FoPUipBurNMHLZxTFi25L+GGRTRKawdrTm0a1PYnhlVM/PbkZEbi4nmY7O
 TrtyZJAohQNBtT4FyOOpsh95uq8Rxq0w/QJ6AqGHI89XyzmofjM/Y5MkLLgDJQy3F/59pcVXXQR
 LVglqwhVARVYkEpBXIyze5lJ+Dy67/tFaNmit9Cc8zpjHtVqhm6WXl7BLO9IRClvbYVjz2Id/qy
 kG8X1U8SjHds96TopSaYCTNGcwj20g==
X-Proofpoint-GUID: DTCe-NXFIlOC5_6nv-XPR2-KM_U1iec2
X-Authority-Analysis: v=2.4 cv=OdCVzxTY c=1 sm=1 tr=0 ts=690cc8b3 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=WeuG7GAIFJ3A7Xv3FmEA:9
X-Proofpoint-ORIG-GUID: DTCe-NXFIlOC5_6nv-XPR2-KM_U1iec2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

Switch to using IS_ENABLED(CONFIG_KVM) instead of CONFIG_PGSTE, since
the latter will be removed soon.

Many CONFIG_PGSTE are left behind, because they will be removed
completely in upcoming patches. The ones replaced here are mostly the
ones that will stay.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/mmu_context.h | 2 +-
 arch/s390/include/asm/pgtable.h     | 4 ++--
 arch/s390/mm/fault.c                | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index d9b8501bc93d..48e548c01daa 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -29,7 +29,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	atomic_set(&mm->context.protected_count, 0);
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
-#ifdef CONFIG_PGSTE
+#if IS_ENABLED(CONFIG_KVM)
 	mm->context.has_pgste = 0;
 	mm->context.uses_skeys = 0;
 	mm->context.uses_cmm = 0;
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b9887ea6c045..8b8fc0e2d907 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -577,7 +577,7 @@ static inline int mm_has_pgste(struct mm_struct *mm)
 
 static inline int mm_is_protected(struct mm_struct *mm)
 {
-#ifdef CONFIG_PGSTE
+#if IS_ENABLED(CONFIG_KVM)
 	if (unlikely(atomic_read(&mm->context.protected_count)))
 		return 1;
 #endif
@@ -632,7 +632,7 @@ static inline pud_t set_pud_bit(pud_t pud, pgprot_t prot)
 #define mm_forbids_zeropage mm_forbids_zeropage
 static inline int mm_forbids_zeropage(struct mm_struct *mm)
 {
-#ifdef CONFIG_PGSTE
+#if IS_ENABLED(CONFIG_KVM)
 	if (!mm->context.allow_cow_sharing)
 		return 1;
 #endif
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index e1ad05bfd28a..683afd496190 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -398,7 +398,7 @@ void do_dat_exception(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_dat_exception);
 
-#if IS_ENABLED(CONFIG_PGSTE)
+#if IS_ENABLED(CONFIG_KVM)
 
 void do_secure_storage_access(struct pt_regs *regs)
 {
@@ -465,4 +465,4 @@ void do_secure_storage_access(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_secure_storage_access);
 
-#endif /* CONFIG_PGSTE */
+#endif /* CONFIG_KVM */
-- 
2.51.1


