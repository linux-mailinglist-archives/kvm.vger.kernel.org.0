Return-Path: <kvm+bounces-28919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBEEE99F307
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C62F1C222F4
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F782101A4;
	Tue, 15 Oct 2024 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HvNnXjsJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E331F76B5;
	Tue, 15 Oct 2024 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010616; cv=none; b=qn0Xz/wOPxswtSN3x9Df2EJlH2+G4knqP191caorb/S+RCe8erh0WYZJA056oGTNPPXzXAPdKBI1OerJHBbgZiztt1edVTsry2ib59/m2cWVCSr+HkYKkvCa8hUR/JhgmZ5K8vULZiNPBEUHKjBBs7TTc00O3wygivKDFQpZbTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010616; c=relaxed/simple;
	bh=m5UAYB79TEfrioqAYLo0joh7a0Agaawt4tkZzvrD8QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrTcBvuBon4mWTDL8BpaMqN8uy2AyVDfyh+jWQwwfU5/PdDkdcTOAdWXBNKxtEHHuRzkxghB9/RsX8elkFyk5tJXzEOmGyQgttacly8ETdAbhXGiqijUmQ3kHZVTykhIbolzgU0vvnwRJo3lfCj+Kxor3wzl+pba9s7cVH96WFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HvNnXjsJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FDJZD2007796;
	Tue, 15 Oct 2024 16:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=W4h7KWWUJ1nq8iuU+
	j1U4vFtf2F9utqpqwfLBifPARA=; b=HvNnXjsJmmjwKw2I6TRGgW6vkHjtLT1/W
	7pIpZXBy8TdZ6rcr88cQaV0/CJJeNSesOqgXbn/E30Ei41vXtGLsPsP2GsWsYgp1
	yDnoP95uziu2mnSEguKUcqZL32Ks3aUCooYEQ1xdCkyPtFY4kWC1/cJH5VbhMSlG
	JHYDcA8dClO06jewQ70fd1hm0XjFtwaeapix0Owp/O4vPAvTdPf/QK/AfWlnq08c
	uikIM68UhrkURv9LVH9naxIJtTvHUIWpiGJT9MNuX4zLIAThnsl/iOBEE6eZU2Hr
	J4zg5q1C6q1fOVSw3p6p/CkwwWoG1mc3d/M8OubzjJDZbNlLC7VDQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429s68h429-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:32 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FFP7Lg005215;
	Tue, 15 Oct 2024 16:43:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285nj4mk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhS9I50069778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85A8620040;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EAA020043;
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
Subject: [PATCH v3 09/11] s390/mm: Simplify get_fault_type()
Date: Tue, 15 Oct 2024 18:43:24 +0200
Message-ID: <20241015164326.124987-10-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: 0ZzkNOr51_Qrin6GP7NUQDau07WJ4tF_
X-Proofpoint-ORIG-GUID: 0ZzkNOr51_Qrin6GP7NUQDau07WJ4tF_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=610 adultscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

From: Heiko Carstens <hca@linux.ibm.com>

With the gmap code gone get_fault_type() can be simplified:

- every fault with user_mode(regs) == true must be a fault in user address
  space

- every fault with user_mode(regs) == false is only a fault in user
  address space if the used address space is the secondary address space

- every other fault is within the kernel address space

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/mm/fault.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index e48910b0b816..6e96fc7905fc 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -68,17 +68,10 @@ static enum fault_type get_fault_type(struct pt_regs *regs)
 {
 	union teid teid = { .val = regs->int_parm_long };
 
-	if (likely(teid.as == PSW_BITS_AS_PRIMARY)) {
-		if (user_mode(regs))
-			return USER_FAULT;
-		return KERNEL_FAULT;
-	}
-	if (teid.as == PSW_BITS_AS_SECONDARY)
+	if (user_mode(regs))
 		return USER_FAULT;
-	/* Access register mode, not used in the kernel */
-	if (teid.as == PSW_BITS_AS_ACCREG)
+	if (teid.as == PSW_BITS_AS_SECONDARY)
 		return USER_FAULT;
-	/* Home space -> access via kernel ASCE */
 	return KERNEL_FAULT;
 }
 
-- 
2.47.0


