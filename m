Return-Path: <kvm+bounces-28921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF9899F30A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B92E1C222A9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7889722739E;
	Tue, 15 Oct 2024 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZytbZPv4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65C51F76D1;
	Tue, 15 Oct 2024 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010616; cv=none; b=AQ6auebO/ut1oj9XuEW1r/FyDBjCbYMNqOARMfYdbagrss8Fe2ZRZtkIYKSXdxtQfgm0Xqu2az8G1NBOvnf5t12DH8Jz5U+RTWdzHuVfeCCfUtjRfn0XTJtpy4JJvHUNpZ1duUGckh3+tidXgXbfH63zHhQ993JXZSo/OBIG7WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010616; c=relaxed/simple;
	bh=OD/CTOrwcg6OiHs7buhnlA46yO9ruiybpAnnQ2ioFXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gamNBTTcBoKjIAmoXzOu6NO2u24X6mQT12/saMGjSzOpdkrBqJP8ygxFUDXCiEXWIv7wgcQJCdk1PdCCf83mJAW3diRIYkNTkL3Jj4asg5CBLYDcDivphgD26sYzIxpksdP+M9Bee7E59NEjxHL+SITlc0Hw2SdISFTD4rhJotw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZytbZPv4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FFoWDb031605;
	Tue, 15 Oct 2024 16:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=b1hrL5t3INOADSR8l
	YZwbXlFlIC3oQgm2SthebZwLds=; b=ZytbZPv4e3P1bzMOue/sbbzVsbqPyTIrJ
	ZzWDvHW9Z7VNzYfy+az5kh5PvwZVVrOKujAzxBWHB4iZP33ibMJv+vVv2YKzdTfW
	c4yGTP42d+L1cY5FF9MwvXFdDqXCuUWahUY1ix/Zo1JqK4A6d6rUI7RHd0GenP3x
	hAkzLrEQCFig3JfwutXa5eGNNF1KPc4zjadXlNZXu35wVfTIgN2oqmJ2NId1PbFI
	1w2Hd1o4DomMYmkZAdZkwF0ZL9vDZcj9sBPoucmpsiuRFd5gG6ZYZMdxiDh3xHxp
	GClhUJqyWetYgCtCaMnnRRUNFJFXlLH37VcGWbrraO3x0kN+B9bZg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429ucwg8m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FEmnAp007025;
	Tue, 15 Oct 2024 16:43:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xk4tre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhSqp50069782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDC952004B;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B70A320040;
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
Subject: [PATCH v3 11/11] s390/mm: Convert to LOCK_MM_AND_FIND_VMA
Date: Tue, 15 Oct 2024 18:43:26 +0200
Message-ID: <20241015164326.124987-12-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: mIwXe_1YdEff2xHHUJkxrOJMh3WJJF-U
X-Proofpoint-GUID: mIwXe_1YdEff2xHHUJkxrOJMh3WJJF-U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=641 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

From: Heiko Carstens <hca@linux.ibm.com>

With the gmap code gone s390 can be easily converted to
LOCK_MM_AND_FIND_VMA like it has been done for most other
architectures.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
---
 arch/s390/Kconfig    |  1 +
 arch/s390/mm/fault.c | 13 ++-----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index d339fe4fdedf..8109446f7b24 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -224,6 +224,7 @@ config S390
 	select HAVE_VIRT_CPU_ACCOUNTING_IDLE
 	select IOMMU_HELPER		if PCI
 	select IOMMU_SUPPORT		if PCI
+	select LOCK_MM_AND_FIND_VMA
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_GATHER_NO_GATHER
 	select MMU_GATHER_RCU_TABLE_FREE
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 93ae097ef0e0..8bd2b8d64273 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -308,18 +308,10 @@ static void do_exception(struct pt_regs *regs, int access)
 		return;
 	}
 lock_mmap:
-	mmap_read_lock(mm);
 retry:
-	vma = find_vma(mm, address);
+	vma = lock_mm_and_find_vma(mm, address, regs);
 	if (!vma)
-		return handle_fault_error(regs, SEGV_MAPERR);
-	if (unlikely(vma->vm_start > address)) {
-		if (!(vma->vm_flags & VM_GROWSDOWN))
-			return handle_fault_error(regs, SEGV_MAPERR);
-		vma = expand_stack(mm, address);
-		if (!vma)
-			return handle_fault_error_nolock(regs, SEGV_MAPERR);
-	}
+		return handle_fault_error_nolock(regs, SEGV_MAPERR);
 	if (unlikely(!(vma->vm_flags & access)))
 		return handle_fault_error(regs, SEGV_ACCERR);
 	fault = handle_mm_fault(vma, address, flags, regs);
@@ -337,7 +329,6 @@ static void do_exception(struct pt_regs *regs, int access)
 	}
 	if (fault & VM_FAULT_RETRY) {
 		flags |= FAULT_FLAG_TRIED;
-		mmap_read_lock(mm);
 		goto retry;
 	}
 	mmap_read_unlock(mm);
-- 
2.47.0


