Return-Path: <kvm+bounces-36986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E5DA23D10
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9A0816AE15
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08F21F37B0;
	Fri, 31 Jan 2025 11:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VUo/d6sy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36F81C32FE;
	Fri, 31 Jan 2025 11:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322733; cv=none; b=ogo71B0yhzReCiuAs5Jo5mwnIlCoiVb3kQy3EBO+z7oViAu7vP1p1rlKwnraB5HDrsBVckgZpu4d3d4wy4/JA0fVY4l25BJhXy4BtT11YJWxroIf4dUyCksNTvPHQQn6x0eqoHMZ1xvBz5AHJVWAwAhg7JqylsSavTlM8kNi7ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322733; c=relaxed/simple;
	bh=YS5r1/0twAAERL8ngIAxSqp6YM8y5Wy8/pbxtA9g+1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQbIP5ynWKTv013LvWp70cMGajfVUrNrBhz7LEShbvqvNGxlFt21MoZhUTQjPY/Q8CPhGsq0jMiWUyQYKTM+0rz9Rr7Ifj0siFVGAK61OwsSofSLPIYn8zSh5x6vlpgS3If7QwJUCIRIf8maC0FnGUCUrBySBInxUcczuzjrMac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VUo/d6sy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2OQiL021959;
	Fri, 31 Jan 2025 11:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nXyahyElqM3iBNlWc
	TVjg8Z6CHgT6G5t1NBhq1glBpU=; b=VUo/d6syEG5lcHbeNV5EKOuoqUfDUlH2H
	SZfgpmyp/eM8cvhKwh5Fp0ebt3QvxLkKwE7/OPhOYzv1RJADao/MRT6ZzfvtUn+G
	mA81LV1RnAbVxaWOoftJStbco57HiJTqJ1YIE9AM4AMrvT/1SDMLsbdZqbeCi8Zc
	6vrfSNLcxN7AgpVGOd83GUE4ahwMdqKO35XIz639Jq7Ws/lnGytTbxRe6ZId0EDC
	egJyXrM/z5X/n9s93jlBng+0AoY+mjgeYuysnaDRUhW0FDNUGOvf1pYjAxEs4mRk
	5MuPhBSKDK00ixfCRopQGSpG6jzCh7zbnBKAB3EUcd7LY/OeF5UDg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gnby9x0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8MOq2017346;
	Fri, 31 Jan 2025 11:25:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gfaxb8km-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPOfU44761594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFDD22012F;
	Fri, 31 Jan 2025 11:25:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83E792012E;
	Fri, 31 Jan 2025 11:25:24 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:24 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 11/20] KVM: s390: get rid of gmap_fault()
Date: Fri, 31 Jan 2025 12:25:01 +0100
Message-ID: <20250131112510.48531-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MxVPmKE5YmH_uM17kvTaW9F4fVdGffmD
X-Proofpoint-GUID: MxVPmKE5YmH_uM17kvTaW9F4fVdGffmD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=732 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

All gmap page faults are already handled in kvm by the function
kvm_s390_handle_dat_fault(); only few users of gmap_fault remained, all
within kvm.

Convert those calls to use kvm_s390_handle_dat_fault() instead.

Remove gmap_fault() entirely since it has no more users.

Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-8-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-8-imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |   1 -
 arch/s390/kvm/intercept.c    |   4 +-
 arch/s390/mm/gmap.c          | 124 -----------------------------------
 3 files changed, 2 insertions(+), 127 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 3e66f53fe3cc..d4572729269f 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -113,7 +113,6 @@ int gmap_unmap_segment(struct gmap *gmap, unsigned long to, unsigned long len);
 unsigned long __gmap_translate(struct gmap *, unsigned long gaddr);
 unsigned long gmap_translate(struct gmap *, unsigned long gaddr);
 int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr);
-int gmap_fault(struct gmap *, unsigned long gaddr, unsigned int fault_flags);
 void gmap_discard(struct gmap *, unsigned long from, unsigned long to);
 void __gmap_zap(struct gmap *, unsigned long gaddr);
 void gmap_unlink(struct mm_struct *, unsigned long *table, unsigned long vmaddr);
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index acf10aefd08f..610dd44a948b 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -368,7 +368,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg2, &srcaddr, GACC_FETCH, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = gmap_fault(vcpu->arch.gmap, srcaddr, 0);
+	rc = kvm_s390_handle_dat_fault(vcpu, srcaddr, 0);
 	if (rc != 0)
 		return rc;
 
@@ -377,7 +377,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg1, &dstaddr, GACC_STORE, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = gmap_fault(vcpu->arch.gmap, dstaddr, FAULT_FLAG_WRITE);
+	rc = kvm_s390_handle_dat_fault(vcpu, dstaddr, FOLL_WRITE);
 	if (rc != 0)
 		return rc;
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index bfaba7733306..e124fca14737 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -607,130 +607,6 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 }
 EXPORT_SYMBOL(__gmap_link);
 
-/**
- * fixup_user_fault_nowait - manually resolve a user page fault without waiting
- * @mm:		mm_struct of target mm
- * @address:	user address
- * @fault_flags:flags to pass down to handle_mm_fault()
- * @unlocked:	did we unlock the mmap_lock while retrying
- *
- * This function behaves similarly to fixup_user_fault(), but it guarantees
- * that the fault will be resolved without waiting. The function might drop
- * and re-acquire the mm lock, in which case @unlocked will be set to true.
- *
- * The guarantee is that the fault is handled without waiting, but the
- * function itself might sleep, due to the lock.
- *
- * Context: Needs to be called with mm->mmap_lock held in read mode, and will
- * return with the lock held in read mode; @unlocked will indicate whether
- * the lock has been dropped and re-acquired. This is the same behaviour as
- * fixup_user_fault().
- *
- * Return: 0 on success, -EAGAIN if the fault cannot be resolved without
- * waiting, -EFAULT if the fault cannot be resolved, -ENOMEM if out of
- * memory.
- */
-static int fixup_user_fault_nowait(struct mm_struct *mm, unsigned long address,
-				   unsigned int fault_flags, bool *unlocked)
-{
-	struct vm_area_struct *vma;
-	unsigned int test_flags;
-	vm_fault_t fault;
-	int rc;
-
-	fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
-	test_flags = fault_flags & FAULT_FLAG_WRITE ? VM_WRITE : VM_READ;
-
-	vma = find_vma(mm, address);
-	if (unlikely(!vma || address < vma->vm_start))
-		return -EFAULT;
-	if (unlikely(!(vma->vm_flags & test_flags)))
-		return -EFAULT;
-
-	fault = handle_mm_fault(vma, address, fault_flags, NULL);
-	/* the mm lock has been dropped, take it again */
-	if (fault & VM_FAULT_COMPLETED) {
-		*unlocked = true;
-		mmap_read_lock(mm);
-		return 0;
-	}
-	/* the mm lock has not been dropped */
-	if (fault & VM_FAULT_ERROR) {
-		rc = vm_fault_to_errno(fault, 0);
-		BUG_ON(!rc);
-		return rc;
-	}
-	/* the mm lock has not been dropped because of FAULT_FLAG_RETRY_NOWAIT */
-	if (fault & VM_FAULT_RETRY)
-		return -EAGAIN;
-	/* nothing needed to be done and the mm lock has not been dropped */
-	return 0;
-}
-
-/**
- * __gmap_fault - resolve a fault on a guest address
- * @gmap: pointer to guest mapping meta data structure
- * @gaddr: guest address
- * @fault_flags: flags to pass down to handle_mm_fault()
- *
- * Context: Needs to be called with mm->mmap_lock held in read mode. Might
- * drop and re-acquire the lock. Will always return with the lock held.
- */
-static int __gmap_fault(struct gmap *gmap, unsigned long gaddr, unsigned int fault_flags)
-{
-	unsigned long vmaddr;
-	bool unlocked;
-	int rc = 0;
-
-retry:
-	unlocked = false;
-
-	vmaddr = __gmap_translate(gmap, gaddr);
-	if (IS_ERR_VALUE(vmaddr))
-		return vmaddr;
-
-	if (fault_flags & FAULT_FLAG_RETRY_NOWAIT)
-		rc = fixup_user_fault_nowait(gmap->mm, vmaddr, fault_flags, &unlocked);
-	else
-		rc = fixup_user_fault(gmap->mm, vmaddr, fault_flags, &unlocked);
-	if (rc)
-		return rc;
-	/*
-	 * In the case that fixup_user_fault unlocked the mmap_lock during
-	 * fault-in, redo __gmap_translate() to avoid racing with a
-	 * map/unmap_segment.
-	 * In particular, __gmap_translate(), fixup_user_fault{,_nowait}(),
-	 * and __gmap_link() must all be called atomically in one go; if the
-	 * lock had been dropped in between, a retry is needed.
-	 */
-	if (unlocked)
-		goto retry;
-
-	return __gmap_link(gmap, gaddr, vmaddr);
-}
-
-/**
- * gmap_fault - resolve a fault on a guest address
- * @gmap: pointer to guest mapping meta data structure
- * @gaddr: guest address
- * @fault_flags: flags to pass down to handle_mm_fault()
- *
- * Returns 0 on success, -ENOMEM for out of memory conditions, -EFAULT if the
- * vm address is already mapped to a different guest segment, and -EAGAIN if
- * FAULT_FLAG_RETRY_NOWAIT was specified and the fault could not be processed
- * immediately.
- */
-int gmap_fault(struct gmap *gmap, unsigned long gaddr, unsigned int fault_flags)
-{
-	int rc;
-
-	mmap_read_lock(gmap->mm);
-	rc = __gmap_fault(gmap, gaddr, fault_flags);
-	mmap_read_unlock(gmap->mm);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(gmap_fault);
-
 /*
  * this function is assumed to be called with mmap_lock held
  */
-- 
2.48.1


