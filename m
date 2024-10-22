Return-Path: <kvm+bounces-29398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4E59AA1D9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DE34281476
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CFE1A3BC0;
	Tue, 22 Oct 2024 12:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hcswGXHZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3561A0706;
	Tue, 22 Oct 2024 12:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598781; cv=none; b=olkbCYhKoECRgHtiJT8A8WTdholRaN1Agyvx5c0vQXJjWr6eXcHrFjUicNqFjxFO0ju9hNV2lSbaEG1dHGYkN//iROu1MpFMc4KDQ4KmCm7Y6HtALWOa5ZG/h7hn5BY+4QAM5RgUTWpUJXYSNCbVvrSmdCwpxt/pll+rO9uSUAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598781; c=relaxed/simple;
	bh=OD/CTOrwcg6OiHs7buhnlA46yO9ruiybpAnnQ2ioFXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZunYYFLHtH7QHp3X+3W3hVRwgbeS13vLMmgz8f6qzMAI4lq5YLb9Xi2fkLQmAsrHaCoXk3XlOO78uHT3CYSpuQvBjnynPeM6vROzgylVQnB+buS8IVstUSSrjULIfpiE3aJIDT5mSRBBTVQnKCkKdgCRbQ8UWDJRPBzTZE81Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hcswGXHZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HjYa006796;
	Tue, 22 Oct 2024 12:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=b1hrL5t3INOADSR8l
	YZwbXlFlIC3oQgm2SthebZwLds=; b=hcswGXHZWpEsGBiVwX1ZlSZ8JIgQBPZ5z
	l4qYVVskoVTmYnWRIl6N4nEuSaJ7RADZY5GPe1i3LKo0jHNfWMYAvLieiv6nk8ie
	fJQNHW1TAJ6kAKkj8Un42T+T7CCPoJTPAtjE/YOgF7oGdDr9X8ifbcuNmCuLA6D+
	lFgrnnBffCJSvlMRX/uq2naAtIR/QxZzVUdwanVGo55jNva6BxuyvfSgFFBHqmRF
	GVMG9ho50XGD2c6e0DYC/2nazPFkuq/oXmzNPbVv++lp5zgtVI6MRNTBuq0Bh3vx
	fg49MaBEV3gkcgyXWysSO5fe/YVhT6xdmlnYGSqVlykNm8hM8oZjw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5fcnqf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MBGvkj023927;
	Tue, 22 Oct 2024 12:06:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42cst12scw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC6Ckr55050594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84ED420040;
	Tue, 22 Oct 2024 12:06:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADA082004B;
	Tue, 22 Oct 2024 12:06:11 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:11 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 11/11] s390/mm: Convert to LOCK_MM_AND_FIND_VMA
Date: Tue, 22 Oct 2024 14:06:01 +0200
Message-ID: <20241022120601.167009-12-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: wvpmKYq1BQyazEQmuq0JDh8QT7Y17-eg
X-Proofpoint-GUID: wvpmKYq1BQyazEQmuq0JDh8QT7Y17-eg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 clxscore=1015 mlxlogscore=641 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

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


