Return-Path: <kvm+bounces-64369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EAEAFC80544
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 06DC04E6BDE
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E98307489;
	Mon, 24 Nov 2025 11:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RI2TjERN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885343054F7;
	Mon, 24 Nov 2025 11:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985396; cv=none; b=Ke4hyMwiH8XrHSOdyLaiJrpC2sVn7HB5qWfXe9EAIh+/JoRTAqNErpg8Tp7euy/wj4lW40sG9c19DywVY+2X3O8XFwSFejaI2zcNqNowYwBzR0wkrOnZjO9QrxZYLZjvbmEfwCgzwA7vLGFhX8dlVeKwGZogQGiqs1wZWMsI/Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985396; c=relaxed/simple;
	bh=gDd+ju82f/6QL4NVbuYQTLPj68kvejVxzOtVImmcLJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPhuLpXPwDaETWD7S89lssC8zFXETapU5mOV2xnB16+S7Ggc1H3VKJNVHjWmiL6x7EZkcNP5WCrxEZMPB0k/P6M+o1TxPlqFlicw+jF7hQb6+V2p34EK0LatFImuW5IRjexI3nbRpasdQF1P1i67UQIYAyLfcRdP2Xl0hnjDKxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RI2TjERN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ANJqUTZ006734;
	Mon, 24 Nov 2025 11:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=XWjRLxEiNnrndkhSi
	lvqCpJUgLPdel7vWAFKkrY4Tgc=; b=RI2TjERNb4IyV5d6Ow3HPwPbz6jg3S7TY
	WG0tWyYd/XBEo6KFJHzXGGeJOzFc3IkA0EsP6x7iDfoC5d1Bbaja+F5OMuAh+NRB
	B3tg8bWT316/btvIpY8HTPFMdKTaxkkMBYQd1behabfhApHpTV+aPS7QOqIaaukN
	Yo8Rms5Uq1dE5ci55Q/rzoL4SdxgiU6sO0r8Xdl0jShJBMsSl7hAbgoc2nVYfSVR
	eG3ZmG850liCqc4c9qhLWn9jQqLAbibnye/wI1lsqLIJAST7IBUR1Zm2csOkF9Fa
	P3Qgdp3hzCnnuJoo46PgJhP0WAq09n6StZO09f59Y9FUbvwE9FcgQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kpqns7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO8XYM0025083;
	Mon, 24 Nov 2025 11:56:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akt715e7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBuSmW22085902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E273D20043;
	Mon, 24 Nov 2025 11:56:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D76D20040;
	Mon, 24 Nov 2025 11:56:26 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:26 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 17/23] KVM: s390: Stop using CONFIG_PGSTE
Date: Mon, 24 Nov 2025 12:55:48 +0100
Message-ID: <20251124115554.27049-18-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124115554.27049-1-imbrenda@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfXzI+s4N+c+ZFu
 oN+x/ffcV1NZb8/hTHEEsh3VOoR/Q3W7Kmx7Qrka1JPtzJIbMCdB7+VagrwiBYmQfwLVCntRRVn
 PzkwNHbPJho5EsZY/jWm8O93hZSRvTJpgCaAwpZ3xhHuZQ4g9eSegXq2OnvtCxsLLKpo/s0Ae3f
 Qyv4DtEntgcJP6FBAGXN0fQgKgKeFomu/iDikAOgl5pXmzI8jf7scEiC6xwucm4FvhpQcDSVYjI
 n801eQfu/47I1r0NonTCR1b6rindCG+1bYMgQg7VPNVdJ+t7RfyDqeLOxce8O34xuTpGw4m3J6P
 E7OtVEDNPlIfuQ9bZvOsOn0U8YCa3i5ItcEBId2h2lyyxx1lbYHKnlaahcvMg0o22VNlujrHXV3
 spY/+qEptfSJcD20gpKQ3bzwhmHnIA==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=692447ef cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=WeuG7GAIFJ3A7Xv3FmEA:9
X-Proofpoint-GUID: zfaNaNIrAmzMscPK8X86IpQjIoiWW5DN
X-Proofpoint-ORIG-GUID: zfaNaNIrAmzMscPK8X86IpQjIoiWW5DN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

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
index 3ddc62fcf6dd..7ccad785e4fe 100644
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


