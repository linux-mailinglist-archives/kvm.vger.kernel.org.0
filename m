Return-Path: <kvm+bounces-28914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FBF99F2FB
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B7BC1C223C7
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10E21F9EDA;
	Tue, 15 Oct 2024 16:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NaQV5n5L"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419C31F76A7;
	Tue, 15 Oct 2024 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010614; cv=none; b=i0cdiDfkI/OWdKCOzNzByIksRYzM1zihNt3cA7YJn9nHFynGWSZ2O0xbK35bWuc218vGBLX6aNjahQBlvvLnBYjhLvPbiGSBJsJR2dtAa7K27RWMwdE406pbwBAflF0oUqV7a+MGFdgxkm2B92+/TYmlyGNbXq+SVj6ho3EXxjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010614; c=relaxed/simple;
	bh=Y5FMepZoxGiJrpODOM+3gyu4NwjOwdk0gHSXaMccSD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3ILuzsooD28XqCikxJcYz6LdwmbAGvGOd07VULc5qCNkKWcgUPo3Q3SJmtjRV/4X9R7/HoiTR9gxjaHNcbFS3ivfqOJnOXVL02YKd8CUfISA2qRa/fSs9z5DHsalJdynuzbdabGao0LMrXqVNL4xJ1RQVXlDS8AS0n01I+j+0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NaQV5n5L; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FGJKV3013131;
	Tue, 15 Oct 2024 16:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QyY9neWltee04QluT
	O2GfGfyxlN0Z79eG6W6IJi/hzg=; b=NaQV5n5LAZ02Gj/UE7x6gSAZWstwqV/4M
	x2s0dka6P95zYr7p4LUJMF581LiUZpe7Gf/x4mvUtelVVaGz9o2i54i2xEh7zI26
	VLYBFwclzBxGHOdDsm4S05u2uL7Gt2xNFEbp5mEj4ncYL+ZP1h33j8efE9ThdKcK
	DtYuLzDTjjqFwe0FEA56igV/5EP4OTz3It1XinZAKZR+KeIfFWLFxCrOLZo+lUf5
	E9G2pFp2FpCPAd+6Spx+3M5IW4/jLvH5CNRhkB9tyrZgObYXTRIZuCYCeGPvxwpg
	wqipFWwfO+a7UFp2eHWq7//0pptV3DMnBm6bAsNWK83FVC2nc70nQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429utbr4bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FETmgR002343;
	Tue, 15 Oct 2024 16:43:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emmxaw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhRV049545572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8944B20043;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62D452004B;
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
Subject: [PATCH v3 04/11] s390/mm/gmap: Fix __gmap_fault() return code
Date: Tue, 15 Oct 2024 18:43:19 +0200
Message-ID: <20241015164326.124987-5-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: 6KGM_ShUI_rpT1Nt2Dbmnp8f0fq4cdyD
X-Proofpoint-ORIG-GUID: 6KGM_ShUI_rpT1Nt2Dbmnp8f0fq4cdyD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=896
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

Errors in fixup_user_fault() were masked and -EFAULT was returned for
any error, including out of memory.

Fix this by returning the correct error code. This means that in many
cases the error code will be propagated all the way to userspace.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index f51ad948ba53..a8746f71c679 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -718,13 +718,12 @@ static int __gmap_fault(struct gmap *gmap, unsigned long gaddr, unsigned int fau
 	if (IS_ERR_VALUE(vmaddr))
 		return vmaddr;
 
-	if (fault_flags & FAULT_FLAG_RETRY_NOWAIT) {
+	if (fault_flags & FAULT_FLAG_RETRY_NOWAIT)
 		rc = fixup_user_fault_nowait(gmap->mm, vmaddr, fault_flags, &unlocked);
-		if (rc)
-			return rc;
-	} else if (fixup_user_fault(gmap->mm, vmaddr, fault_flags, &unlocked)) {
-		return -EFAULT;
-	}
+	else
+		rc = fixup_user_fault(gmap->mm, vmaddr, fault_flags, &unlocked);
+	if (rc)
+		return rc;
 	/*
 	 * In the case that fixup_user_fault unlocked the mmap_lock during
 	 * fault-in, redo __gmap_translate() to avoid racing with a
-- 
2.47.0


