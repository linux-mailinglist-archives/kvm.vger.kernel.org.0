Return-Path: <kvm+bounces-29392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 401949AA1C8
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:08:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F03752834F3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C997155352;
	Tue, 22 Oct 2024 12:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XP/LAhZo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317E619DF75;
	Tue, 22 Oct 2024 12:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598778; cv=none; b=AeluqNlGXMjxS1nwWUewjSpV8+bIt+FYgX2usP99TXENmwU64gsBrKEgDJRdGoGa+Ih5yIlQ3fMXPwEuWEdhK0a2FDEkCMtEYLwNe+Q2yyRvxSpxoiTmBcORSBDCza4pTZ/gaVKMulB1hsQz9w+HTgTiREsRaDXOBQPEVPh7nws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598778; c=relaxed/simple;
	bh=h5/6DKrykAbE8bJds/TWcnfzEes4D2GTN90XTpLRS1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbW9iTgoeW+hbkuXlyj5wZej/95Cqg0xGIzr5TsOBbjGOauKB1OeDxGzwNqadnBusF7C9CWX0vVmnkG2mqBR8Kd0/W1mlDn/WRcL3ApUBQJ2pX6BV2uEXHR1kvUqqLlxOfZDoadxx3GN5/ObuyVmo/eTNvOe3eokUX7Qlzsl4SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XP/LAhZo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HJ8I009463;
	Tue, 22 Oct 2024 12:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Ywjmb3nwir9sPobCY
	Agfz2dnTAU7iFKkWNpN84UE7X8=; b=XP/LAhZoHYK2N2Kl5yrTE1qap2gdE0VQj
	Y8rl1UaY73DG8lkMrqzisBi3/WCr3UX2ykGGpGDSfxoIffY5kvrAp8GXtE0is2FJ
	oijoqcDyTacdeQXIT4rxPBy+Pa02GST54Z5nbe2zNTKY2NCBA1QDDMLA1uRX0Vn+
	xs8TACDScJlyLM+4AmBGXX7U70Tkei5Cjq+eKIZShsTbx6P0XTRYqjY/b3feUwE0
	UldOuxV+QKtZGTWnnZfai4IHDr/SxsKCWWqq9JTui1PJfBPypCGJJQt55W+4mV9d
	O0Sl4zjVJqCVoPoMVzXBeeQhNNlVysN9Eu7vMbCfens2eNcEeVjQw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5hmeevn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MA1qZr029300;
	Tue, 22 Oct 2024 12:06:10 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42crkk2yau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:10 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC66dr55247192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF6B72004F;
	Tue, 22 Oct 2024 12:06:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEC1D20043;
	Tue, 22 Oct 2024 12:06:05 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:05 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 03/11] s390/mm/gmap: Refactor gmap_fault() and add support for pfault
Date: Tue, 22 Oct 2024 14:05:53 +0200
Message-ID: <20241022120601.167009-4-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: EZy342TeQYjhJBiYh6LuP9pQ4VpPumpQ
X-Proofpoint-GUID: EZy342TeQYjhJBiYh6LuP9pQ4VpPumpQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=805 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

When specifying FAULT_FLAG_RETRY_NOWAIT as flag for gmap_fault(), the
gmap fault will be processed only if it can be resolved quickly and
without sleeping. This will be needed for pfault.

Refactor gmap_fault() to improve readability.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
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


