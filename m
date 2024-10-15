Return-Path: <kvm+bounces-28923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0763D99F30C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AD8E1C224E2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0CE3227BB1;
	Tue, 15 Oct 2024 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IA4bjy6p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696041F76B6;
	Tue, 15 Oct 2024 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010617; cv=none; b=ANpeg4iLUrayVC3AQ4daFZTYd5xyge6nS78JxQEvhjCgYe0DzMXdO0HmwwOlmFaFsAlXxQNJTzSSzc9Q+Puiwu2tc39Tnmw1btncAbpX48GBI1FE8b/oFfwOM89NYl7FJOCcJTsJG0lyLxy55i6EBoboCAAPql89ISzJk6mTENc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010617; c=relaxed/simple;
	bh=Z9bRoxXyx3sAoKziQia3gv9KjvurarVGCYrbVX0wBQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f247pytElS3dIPj0pnt+vsiMzBxAm3A5YJMp7YVfEcCuwfHYnGETTaiim+nZcoVEPit4DQ/Q/6x06Vfx6cmeCenxvxS5TuZoQ4xlsSUuJPALgb7iIgd5UStgppnRP0mjGNqaIpS7SElTGw21xo6ClB8D643XRxNpNvTR/fw+Luo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IA4bjy6p; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FGIvUo012451;
	Tue, 15 Oct 2024 16:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=l22CTdoToSQBMRy+l
	NB4xu65L+oAkrXxrMTQl1t93Lo=; b=IA4bjy6pnmOZlhiVovaZd1G+1ySDlP9eO
	8rbbEht6DS4nvoNvfDeFRrUoQqd6ntKGLvyPIlSrQn+zoxP8xr9VKwINjRGnIY6U
	KIOgmkLFA0DXWX2oSOzc1auIopEPfqxsxNSAduQIjLskbE/UtTYvSREFnrWg1ceR
	yIteyoRvwZFlG5ZF89Oy3u5UgbNd2BrgL6YHnLk6jvzCF4JkbdiHV/vcLnqWkmDN
	XkP6ZrXkcVcxDmfl0ambNhnnUrK3NgwAqDjOJ25yDgR92vzpuwpQcD6orC1OcqrA
	bnnmq8QpjbyLZzJEaKgebJ7P+4PsqG7nmg/9fSPUU7OTehdNLCQnA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429utbr4c0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FDoqOs027444;
	Tue, 15 Oct 2024 16:43:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txn028-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhSaY50069780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B18EC20043;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8ACCF2004B;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 10/11] s390/mm: Get rid of fault type switch statements
Date: Tue, 15 Oct 2024 18:43:25 +0200
Message-ID: <20241015164326.124987-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015164326.124987-1-imbrenda@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4btRNoVUpFamlLieAt3rpuCttRKOy1ab
X-Proofpoint-ORIG-GUID: 4btRNoVUpFamlLieAt3rpuCttRKOy1ab
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=956
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

From: Heiko Carstens <hca@linux.ibm.com>

With GMAP_FAULT fault type gone, there are only KERNEL_FAULT and
USER_FAULT fault types left. Therefore there is no need for any fault
type switch statements left.

Rename get_fault_type() into is_kernel_fault() and let it return a
boolean value. Change all switch statements to if statements. This
removes quite a bit of code.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/mm/fault.c | 70 ++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 48 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 6e96fc7905fc..93ae097ef0e0 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -46,11 +46,6 @@
 #include <asm/uv.h>
 #include "../kernel/entry.h"
 
-enum fault_type {
-	KERNEL_FAULT,
-	USER_FAULT,
-};
-
 static DEFINE_STATIC_KEY_FALSE(have_store_indication);
 
 static int __init fault_init(void)
@@ -64,15 +59,15 @@ early_initcall(fault_init);
 /*
  * Find out which address space caused the exception.
  */
-static enum fault_type get_fault_type(struct pt_regs *regs)
+static bool is_kernel_fault(struct pt_regs *regs)
 {
 	union teid teid = { .val = regs->int_parm_long };
 
 	if (user_mode(regs))
-		return USER_FAULT;
+		return false;
 	if (teid.as == PSW_BITS_AS_SECONDARY)
-		return USER_FAULT;
-	return KERNEL_FAULT;
+		return false;
+	return true;
 }
 
 static unsigned long get_fault_address(struct pt_regs *regs)
@@ -167,17 +162,12 @@ static void dump_fault_info(struct pt_regs *regs)
 		break;
 	}
 	pr_cont("mode while using ");
-	switch (get_fault_type(regs)) {
-	case USER_FAULT:
-		asce = get_lowcore()->user_asce.val;
-		pr_cont("user ");
-		break;
-	case KERNEL_FAULT:
+	if (is_kernel_fault(regs)) {
 		asce = get_lowcore()->kernel_asce.val;
 		pr_cont("kernel ");
-		break;
-	default:
-		unreachable();
+	} else {
+		asce = get_lowcore()->user_asce.val;
+		pr_cont("user ");
 	}
 	pr_cont("ASCE.\n");
 	dump_pagetable(asce, get_fault_address(regs));
@@ -212,7 +202,6 @@ static void do_sigsegv(struct pt_regs *regs, int si_code)
 
 static void handle_fault_error_nolock(struct pt_regs *regs, int si_code)
 {
-	enum fault_type fault_type;
 	unsigned long address;
 	bool is_write;
 
@@ -223,17 +212,15 @@ static void handle_fault_error_nolock(struct pt_regs *regs, int si_code)
 	}
 	if (fixup_exception(regs))
 		return;
-	fault_type = get_fault_type(regs);
-	if (fault_type == KERNEL_FAULT) {
+	if (is_kernel_fault(regs)) {
 		address = get_fault_address(regs);
 		is_write = fault_is_write(regs);
 		if (kfence_handle_page_fault(address, is_write, regs))
 			return;
-	}
-	if (fault_type == KERNEL_FAULT)
 		pr_alert("Unable to handle kernel pointer dereference in virtual kernel address space\n");
-	else
+	} else {
 		pr_alert("Unable to handle kernel paging request in virtual user address space\n");
+	}
 	dump_fault_info(regs);
 	die(regs, "Oops");
 }
@@ -267,7 +254,6 @@ static void do_exception(struct pt_regs *regs, int access)
 	struct vm_area_struct *vma;
 	unsigned long address;
 	struct mm_struct *mm;
-	enum fault_type type;
 	unsigned int flags;
 	vm_fault_t fault;
 	bool is_write;
@@ -282,15 +268,8 @@ static void do_exception(struct pt_regs *regs, int access)
 	mm = current->mm;
 	address = get_fault_address(regs);
 	is_write = fault_is_write(regs);
-	type = get_fault_type(regs);
-	switch (type) {
-	case KERNEL_FAULT:
+	if (is_kernel_fault(regs) || faulthandler_disabled() || !mm)
 		return handle_fault_error_nolock(regs, 0);
-	case USER_FAULT:
-		if (faulthandler_disabled() || !mm)
-			return handle_fault_error_nolock(regs, 0);
-		break;
-	}
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
@@ -460,8 +439,15 @@ void do_secure_storage_access(struct pt_regs *regs)
 		 */
 		panic("Unexpected PGM 0x3d with TEID bit 61=0");
 	}
-	switch (get_fault_type(regs)) {
-	case USER_FAULT:
+	if (is_kernel_fault(regs)) {
+		folio = phys_to_folio(addr);
+		if (unlikely(!folio_try_get(folio)))
+			return;
+		rc = arch_make_folio_accessible(folio);
+		folio_put(folio);
+		if (rc)
+			BUG();
+	} else {
 		mm = current->mm;
 		mmap_read_lock(mm);
 		vma = find_vma(mm, addr);
@@ -470,7 +456,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 		folio = folio_walk_start(&fw, vma, addr, 0);
 		if (!folio) {
 			mmap_read_unlock(mm);
-			break;
+			return;
 		}
 		/* arch_make_folio_accessible() needs a raised refcount. */
 		folio_get(folio);
@@ -480,18 +466,6 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			send_sig(SIGSEGV, current, 0);
 		mmap_read_unlock(mm);
-		break;
-	case KERNEL_FAULT:
-		folio = phys_to_folio(addr);
-		if (unlikely(!folio_try_get(folio)))
-			break;
-		rc = arch_make_folio_accessible(folio);
-		folio_put(folio);
-		if (rc)
-			BUG();
-		break;
-	default:
-		unreachable();
 	}
 }
 NOKPROBE_SYMBOL(do_secure_storage_access);
-- 
2.47.0


