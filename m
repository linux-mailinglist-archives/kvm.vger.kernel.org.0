Return-Path: <kvm+bounces-29396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7C09AA1D5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80B7F1F23F25
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637541A2860;
	Tue, 22 Oct 2024 12:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UYsiTxLM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9683D19D07B;
	Tue, 22 Oct 2024 12:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598780; cv=none; b=mMUfbHRxCEwBDn3e8MJ53X4O7MLenS0vu/yVYFgdS0bN8jEhWANf1pdDdjVOJRdv70QZ8SgaBpYhxC1thFAy5NLySVlP+kB/N519xtx3BSc8/+GtihoHckN1tDYPUDuKRSvJ9lwux4TKP/omtjtW4MjFRkGcjB7Q0E0qwWI5Gw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598780; c=relaxed/simple;
	bh=Z9bRoxXyx3sAoKziQia3gv9KjvurarVGCYrbVX0wBQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebpPIK1k1piUM3EcT6u9gNJ/OjCWqIA9IT3ni9ilRqZc1UK/saqlHiLUjj8bbms9EIDes6ZrkObOiPGc1NnffmSsPRvPFIdQcz0WLwNR5tLOmveb3tLivhdQbWu9BvjvMG+LdM0GLXExhembQmGmMSAW7F/yhw9GCgx7VAJYiWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UYsiTxLM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HOAN029787;
	Tue, 22 Oct 2024 12:06:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=l22CTdoToSQBMRy+l
	NB4xu65L+oAkrXxrMTQl1t93Lo=; b=UYsiTxLMWDjA1dCUphbu5xxXd1aWXJnKP
	cDTqShEnY5KfDL8HD6TxPbItMFMNvgGIaSiXOo01C7GEVBHj0Qxuk37k8ZaOTv8A
	dq8g1cXP+OuatH5w383pPv4fcE9BGJTwIwmv0J85H7oilon1smSKkGT1ahbbEhux
	0xLykn0GL2kYdve5gVL9lt30V9mnleRXFZHQC6I6SdOLtUN8zd18Ud80BThwYaLc
	ZKr2rPehpjuOiODKZAhl2ol1kOhcKqv9iUAmp/FTkG2T6SXYAVAjaeTpsIUxPfw6
	tvInsNiImPHxmoeVXK78Ik61fI7xfpSJGLUOZnnVcX3lZmT5ndEKw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5eudryd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:16 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MA0Vni029398;
	Tue, 22 Oct 2024 12:06:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42crkk2yb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC6BQL57016718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A64320040;
	Tue, 22 Oct 2024 12:06:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 068F520043;
	Tue, 22 Oct 2024 12:06:11 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:10 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 10/11] s390/mm: Get rid of fault type switch statements
Date: Tue, 22 Oct 2024 14:06:00 +0200
Message-ID: <20241022120601.167009-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241022120601.167009-1-imbrenda@linux.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NHv-J2qTubhjXDWE5kH0p6in6RV6xCW3
X-Proofpoint-ORIG-GUID: NHv-J2qTubhjXDWE5kH0p6in6RV6xCW3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxlogscore=953 mlxscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

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


