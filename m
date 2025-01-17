Return-Path: <kvm+bounces-35863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C357A157EC
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E9CB188C5C1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816AB1DDA32;
	Fri, 17 Jan 2025 19:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sP6aFsB9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D511A9B28;
	Fri, 17 Jan 2025 19:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140994; cv=none; b=EFvd5ku+QVmcVVctj6yvTaZjmjpoYt4mV936xWPIgHiaayAeF/bHywJcFpPZYdHgdVf41+KV4HOE7HlXsSG3xcZ94wCKcDUBfWBcCqbeAhXfePHYuCfENuNwL/OQxTm74/QEvuyDk/d+Ub5QS3TgFP1yHSvZHGJZVvt/Wn6Viio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140994; c=relaxed/simple;
	bh=C3LBAEaQyhftaZZ4QmtTJMdXEviYfmRpN258j2fbFTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Agywht31Ud9bkvCX+E9+pRKnawcTTX+iDZRPcVgR9y/hEX8VcXdbr+O8x6qjOQjxMh7Ay6a4KRjh/K6SrmdWRTiJ2lBZGADUA6fZh1QL7vzQV8mq6K0d1Rqxgz5U2cLPxIwlUQxhJ9ISBCi7Ak3N/GQwQoWP9VgbDiC+Lr3wrKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sP6aFsB9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HCUxcR009188;
	Fri, 17 Jan 2025 19:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=yFXazzDOdwwN3qDBN
	KBjAHVUYLr6XEmNV8giq2+gydc=; b=sP6aFsB9d5edavFpflnPGxx5UWJLPSy15
	adQqmlNnUzdlXfMbAsOt1vKsz817/WSNqmlhIgIMWg24cawo5dBSbvCl0zEeTGIK
	QZNb3503eed1w0re96KSLGpgHkVMYDbcQKzmRm7Qy2ewbzzBFoK/0K0pvm8SiAsU
	0HawtJFBkoNQA5NlVQ1DA+sN5lua0/+uWl3+8NqbqjT/fZnTUJXWyEA0cCM5yOEf
	+Gb1gzqMQ+daz0O2VsMa7FvLmj8c+Z1EhjIyL4NGskiZK35A8ficn4uyciOIa0Bh
	bkWDXscGhUcNC75RtdikiR7VRSyzqMhfwq26SkxAlVJgFnUbBNM4w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8jcrwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:46 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ9kgX017767;
	Fri, 17 Jan 2025 19:09:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8jcrwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIQdnK007364;
	Fri, 17 Jan 2025 19:09:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443ynmbnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9emJ34734370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1DB520043;
	Fri, 17 Jan 2025 19:09:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D78120040;
	Fri, 17 Jan 2025 19:09:40 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:40 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 07/15] KVM: s390: get rid of gmap_fault()
Date: Fri, 17 Jan 2025 20:09:30 +0100
Message-ID: <20250117190938.93793-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250117190938.93793-1-imbrenda@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8B-fbQ3o0iymY-jc_cxrKDGtbm9entB2
X-Proofpoint-ORIG-GUID: 3LwGpbme_rtOP0UbS1pqA1EtFQ45MTot
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=740 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170149

All gmap page faults are already handled in kvm by the function
kvm_s390_handle_dat_fault(); only few users of gmap_fault remained, all
within kvm.

Convert those calls to use kvm_s390_handle_dat_fault() instead.

Remove gmap_fault() entirely since it has no more users.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
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
index 92ae003cd215..83a4b0edf239 100644
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


