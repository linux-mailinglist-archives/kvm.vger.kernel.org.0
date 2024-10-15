Return-Path: <kvm+bounces-28913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F64999F2F8
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD4E3B21F58
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECD31F9EBE;
	Tue, 15 Oct 2024 16:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ln4Nvwdw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D948D1F76A4;
	Tue, 15 Oct 2024 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010614; cv=none; b=ZsP1EFEtusUq4zsgu42JBD/TJvXtJ0oxxbVHHiNAJZ7zCHVIRYroeDfn7K8a/tY5aXGGIv7o7eHhO3yHWXmQEuVmVdpmccHg2OTRXKqrNuxMeZiwjXaFFAXJwoc6R5FGjrmFZx0ngeYRcs8gSF43MPEJC4xF6lrcUAM+6NpIDhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010614; c=relaxed/simple;
	bh=RduEoIU1ARqtEVM45IeWsmXgTlFn3jgCk19IW6wVi28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzawW5cQG/UA8dEdJhCtWYgyM3pJp494Pdh6T6LnwYPt86HwcoTefoVQGu3ljoDdK57jxSPga0h0Y5WGRi3nlNVz9R8A4k4cIvKx2+IIE68XQ2Gve7a0aPt7tXTz/70Yi8fNOfjA+qQ+JQ+G/BRQHBv0oi3Q9SJWa1FAONvuP1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ln4Nvwdw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FDJXxg007780;
	Tue, 15 Oct 2024 16:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bywVcVF2riD6xid7c
	0CPDJxkC3BTdenBYLP4Al5LcPQ=; b=Ln4NvwdwsWQEyMXks9Fwr9D/Sq/VB8BYa
	g6l/seJXPC2DqSg9ouxyGTIv2tqAUlAFyJGLgELU/lxl4ZYEVKHvZtZkC7vU728z
	z3ETZ4dwkM/xzwGrFXaPC1GQ4VMVqPXRJupp0+E1dOUhIx+Xz+3QdafSsXaOOgiN
	vRJ/IEIgYoqTNcQn/wucc6YayXnPj9VGfYjtXiCmo1uoeYdjvBntkPr6K8IhD+En
	TcE3rFNAHGQhSXTHiVzaHcmvsSIKa2ig6TOj4utq86pOyJDRN2NhZqTYsFTVkfjc
	oQd6gOG6nvCT3pDJfDeMeq3P9H2zo8kEDGhvWQ0quwpDqlq8CzNGA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429s68h424-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FDoZI3006714;
	Tue, 15 Oct 2024 16:43:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4283erw4bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhRGY49545570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D9BB20040;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36DE620043;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 03/11] s390/mm/gmap: Refactor gmap_fault() and add support for pfault
Date: Tue, 15 Oct 2024 18:43:18 +0200
Message-ID: <20241015164326.124987-4-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: GCnQJhRIBaJqnCV4V8nw9FXw21eE_aN6
X-Proofpoint-ORIG-GUID: GCnQJhRIBaJqnCV4V8nw9FXw21eE_aN6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=782 adultscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

When specifying FAULT_FLAG_RETRY_NOWAIT as flag for gmap_fault(), the
gmap fault will be processed only if it can be resolved quickly and
without sleeping. This will be needed for pfault.

Refactor gmap_fault() to improve readability.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 119 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 100 insertions(+), 19 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index eb0b51a36be0..f51ad948ba53 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -637,44 +637,125 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 }
 
 /**
- * gmap_fault - resolve a fault on a guest address
+ * fixup_user_fault_nowait - manually resolve a user page fault without waiting
+ * @mm:		mm_struct of target mm
+ * @address:	user address
+ * @fault_flags:flags to pass down to handle_mm_fault()
+ * @unlocked:	did we unlock the mmap_lock while retrying
+ *
+ * This function behaves similarly to fixup_user_fault(), but it guarantees
+ * that the fault will be resolved without waiting. The function might drop
+ * and re-acquire the mm lock, in which case @unlocked will be set to true.
+ *
+ * The guarantee is that the fault is handled without waiting, but the
+ * function itself might sleep, due to the lock.
+ *
+ * Context: Needs to be called with mm->mmap_lock held in read mode, and will
+ * return with the lock held in read mode; @unlocked will indicate whether
+ * the lock has been dropped and re-acquired. This is the same behaviour as
+ * fixup_user_fault().
+ *
+ * Return: 0 on success, -EAGAIN if the fault cannot be resolved without
+ * waiting, -EFAULT if the fault cannot be resolved, -ENOMEM if out of
+ * memory.
+ */
+static int fixup_user_fault_nowait(struct mm_struct *mm, unsigned long address,
+				   unsigned int fault_flags, bool *unlocked)
+{
+	struct vm_area_struct *vma;
+	unsigned int test_flags;
+	vm_fault_t fault;
+	int rc;
+
+	fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
+	test_flags = fault_flags & FAULT_FLAG_WRITE ? VM_WRITE : VM_READ;
+
+	vma = find_vma(mm, address);
+	if (unlikely(!vma || address < vma->vm_start))
+		return -EFAULT;
+	if (unlikely(!(vma->vm_flags & test_flags)))
+		return -EFAULT;
+
+	fault = handle_mm_fault(vma, address, fault_flags, NULL);
+	/* the mm lock has been dropped, take it again */
+	if (fault & VM_FAULT_COMPLETED) {
+		*unlocked = true;
+		mmap_read_lock(mm);
+		return 0;
+	}
+	/* the mm lock has not been dropped */
+	if (fault & VM_FAULT_ERROR) {
+		rc = vm_fault_to_errno(fault, 0);
+		BUG_ON(!rc);
+		return rc;
+	}
+	/* the mm lock has not been dropped because of FAULT_FLAG_RETRY_NOWAIT */
+	if (fault & VM_FAULT_RETRY)
+		return -EAGAIN;
+	/* nothing needed to be done and the mm lock has not been dropped */
+	return 0;
+}
+
+/**
+ * __gmap_fault - resolve a fault on a guest address
  * @gmap: pointer to guest mapping meta data structure
  * @gaddr: guest address
  * @fault_flags: flags to pass down to handle_mm_fault()
  *
- * Returns 0 on success, -ENOMEM for out of memory conditions, and -EFAULT
- * if the vm address is already mapped to a different guest segment.
+ * Context: Needs to be called with mm->mmap_lock held in read mode. Might
+ * drop and re-acquire the lock. Will always return with the lock held.
  */
-int gmap_fault(struct gmap *gmap, unsigned long gaddr,
-	       unsigned int fault_flags)
+static int __gmap_fault(struct gmap *gmap, unsigned long gaddr, unsigned int fault_flags)
 {
 	unsigned long vmaddr;
-	int rc;
 	bool unlocked;
-
-	mmap_read_lock(gmap->mm);
+	int rc = 0;
 
 retry:
 	unlocked = false;
+
 	vmaddr = __gmap_translate(gmap, gaddr);
-	if (IS_ERR_VALUE(vmaddr)) {
-		rc = vmaddr;
-		goto out_up;
-	}
-	if (fixup_user_fault(gmap->mm, vmaddr, fault_flags,
-			     &unlocked)) {
-		rc = -EFAULT;
-		goto out_up;
+	if (IS_ERR_VALUE(vmaddr))
+		return vmaddr;
+
+	if (fault_flags & FAULT_FLAG_RETRY_NOWAIT) {
+		rc = fixup_user_fault_nowait(gmap->mm, vmaddr, fault_flags, &unlocked);
+		if (rc)
+			return rc;
+	} else if (fixup_user_fault(gmap->mm, vmaddr, fault_flags, &unlocked)) {
+		return -EFAULT;
 	}
 	/*
 	 * In the case that fixup_user_fault unlocked the mmap_lock during
-	 * faultin redo __gmap_translate to not race with a map/unmap_segment.
+	 * fault-in, redo __gmap_translate() to avoid racing with a
+	 * map/unmap_segment.
+	 * In particular, __gmap_translate(), fixup_user_fault{,_nowait}(),
+	 * and __gmap_link() must all be called atomically in one go; if the
+	 * lock had been dropped in between, a retry is needed.
 	 */
 	if (unlocked)
 		goto retry;
 
-	rc = __gmap_link(gmap, gaddr, vmaddr);
-out_up:
+	return __gmap_link(gmap, gaddr, vmaddr);
+}
+
+/**
+ * gmap_fault - resolve a fault on a guest address
+ * @gmap: pointer to guest mapping meta data structure
+ * @gaddr: guest address
+ * @fault_flags: flags to pass down to handle_mm_fault()
+ *
+ * Returns 0 on success, -ENOMEM for out of memory conditions, -EFAULT if the
+ * vm address is already mapped to a different guest segment, and -EAGAIN if
+ * FAULT_FLAG_RETRY_NOWAIT was specified and the fault could not be processed
+ * immediately.
+ */
+int gmap_fault(struct gmap *gmap, unsigned long gaddr, unsigned int fault_flags)
+{
+	int rc;
+
+	mmap_read_lock(gmap->mm);
+	rc = __gmap_fault(gmap, gaddr, fault_flags);
 	mmap_read_unlock(gmap->mm);
 	return rc;
 }
-- 
2.47.0


