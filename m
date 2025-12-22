Return-Path: <kvm+bounces-66501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D156ACD6BE5
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A4EE83007653
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E43D346E78;
	Mon, 22 Dec 2025 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YAue7iuH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CF23469E0;
	Mon, 22 Dec 2025 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422275; cv=none; b=sBgYJAUg7Bx982k2W7Jlz65xk+dllYtiYJHUazyvu6iaCFTL70Zf6Jrr9v/JkYl8xcMr4RImX5agRXY3E1yngqxxtLDwZXF2Sz8BgHtWCOtQpuH29ZRXul2za8BGrbetUXsOTsdOnbm0Fy2nOqqqt56enxpRM6uCGOjvxpol0EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422275; c=relaxed/simple;
	bh=igISKK7+v8BlipLv7r4rS7c4NKEeh58owjmh9HI5ruM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeG6NBWMqr5adf6ArINxxcVCgdGT7IgoXUsggMdKXD+hEMn4ugrfcuAtDUUuvL6eCuLA1xC3a1Mn5VYQeYRIRgk1dSESrv8hJ6akDU9EqVrB6r1u70kR7FDlvmBhQYdQHd0A3/03Wo3jOkHRJ9E2kk9+lbXTd5dZ3ivyqf+wSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YAue7iuH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDStjJ028720;
	Mon, 22 Dec 2025 16:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gswWEi089zPf+dLFl
	41BgwM5CH+umFApMFEKUX6Stgg=; b=YAue7iuHd2NApRzpsF9GeEp6kJV/qK2BJ
	kp5WLs2rIiBWBf94c+OU7zunmD4211nyHh8cgYvDChKoxEnIl+6CQssWAxApIWju
	tMVLub59nFTPMa8aR4wqs4q8cC1qTfmwxJjOMU6m7dB1NsEg9srpGRlEwWC9C2FN
	N0qfCxJYuGRB5LwxdsZquQIsY1kTIxmjv7J2KAQgQdqaBovJjjcPLSxtlGs9+yTY
	j0d3ywxUPrSXw2kgyJ06AuqNw724Kl0Xndb0EWWsrRZcnFrsUQxAHMVMAPQdlM1g
	jwQHBjTlAzAbmdZSK+zFLg1wJ/lHASYX0E95zpuzoMKWo7UZKQo1A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kh496au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMG0M4b030263;
	Mon, 22 Dec 2025 16:51:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b66gxq97j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGp4VK28967388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:51:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EB3720040;
	Mon, 22 Dec 2025 16:51:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45E4A20043;
	Mon, 22 Dec 2025 16:51:03 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:51:03 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 22/28] KVM: s390: Stop using CONFIG_PGSTE
Date: Mon, 22 Dec 2025 17:50:27 +0100
Message-ID: <20251222165033.162329-23-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bulBxUai c=1 sm=1 tr=0 ts=694976fd cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=WeuG7GAIFJ3A7Xv3FmEA:9
X-Proofpoint-ORIG-GUID: jUZRJLJ6fAfsaQhkZVNegxeZN8jCPJvf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfXzI0NzAf9VT1Q
 Gbl/1r/Ogd4idXRhagL9ZRNvXPs/SnITzQsWVTjKA3VCfT7uxX/X8RyqcVMSuv9ZWrM3rgLr5Zq
 VfsB2jGi19BCjKe3dhPy8W0L9tK7m38rKH4ujB0uHnwsS3VPL114OrQtIfhRX/glVUSSrlzBv+J
 CaH+c6tz+s2Ij+Li+eLxR1LVjf/uUoLhIIO7rj6bId/6QIb5JUYe4b1xJJ8YlM9/UP7Dy4ik2vT
 APtkp8cODZg9nXn79wHkq8AQ/iwJ9JdH1nEErvg457vT3B36/34zEzeI5xTL8rYmKNq7zDO/KGy
 TGk9C56J4Ae6rV8OWu4KMrOBgxkfEdYb9T2pKmRGy6I2Pvo+TJ1knMV6tRvx1IT8tgtoIFWY753
 TFbyQSvkH2ZdW5uayRk849CIxzpBiF40RxpQfvjF/zie1Q5opwxQOw812hXCm88Aouw/B09bU1O
 BiHSuxcyswWrXAvC/Lg==
X-Proofpoint-GUID: jUZRJLJ6fAfsaQhkZVNegxeZN8jCPJvf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2512220154

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
index 04335f5e7f47..cd4d135c4503 100644
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
index e2e13778c36a..a52aa7a99b6b 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -403,7 +403,7 @@ void do_dat_exception(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_dat_exception);
 
-#if IS_ENABLED(CONFIG_PGSTE)
+#if IS_ENABLED(CONFIG_KVM)
 
 void do_secure_storage_access(struct pt_regs *regs)
 {
@@ -470,4 +470,4 @@ void do_secure_storage_access(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_secure_storage_access);
 
-#endif /* CONFIG_PGSTE */
+#endif /* CONFIG_KVM */
-- 
2.52.0


