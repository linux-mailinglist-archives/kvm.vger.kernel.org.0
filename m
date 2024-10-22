Return-Path: <kvm+bounces-29394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDA09AA1CF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 843CDB22F57
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 675B31A0B12;
	Tue, 22 Oct 2024 12:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c4VO0Z6a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C165719F130;
	Tue, 22 Oct 2024 12:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598779; cv=none; b=qQJkpGOElHjBgv9UNEgkI36FSneDTRkI1Ow4LHjM3ZoU5WHeCbOqTmCHppO2q8WdjXyZb/QBSF7rV6968Fwbgl06/ocGtX+jPEwDl03KknmuASfhlXYUX78gtDDTabEw8bGdELUVL4GJLJ/qXzpKg8d7gfDxQapQi6pxhmZlvpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598779; c=relaxed/simple;
	bh=m5UAYB79TEfrioqAYLo0joh7a0Agaawt4tkZzvrD8QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHXZXmS4iw/4gLjIloN1txL0oSWfXB1l7/yIsx2yzycNa7uXdEpHps9tjSnb9PoQuEzuT83zJMv2PidqqPt2qAsVc2aadeqUh/xkPwjEsXIneLTqjyMCfVUk29Xm9nr2rrSWlO9OkXWHvOjfELg3k9wTuyKxMqAMr9Hnn21UhWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c4VO0Z6a; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M4KM7k004504;
	Tue, 22 Oct 2024 12:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=W4h7KWWUJ1nq8iuU+
	j1U4vFtf2F9utqpqwfLBifPARA=; b=c4VO0Z6akgUBdGmrAIldzAh7+XMctl0qv
	PnAY7/gtK5nrZFwk8gOcJvEhlMu8f2cqVbCEQaDuYfjARwbDvof4aFLarYFwStB8
	Z7wlSiCn5AXXSqGGtAP2WZYkhyHJn9tCHNOsxxZev48BWDqu6L1/rhpdP7iQMNzw
	FfHe2A+XvbKsWgTruj+sO2C388ClXS9ADDnBtwcMelr3sXOu+UIePgFIWmPKbKRw
	Er14/oRhfUHQMb0JsdolBoYNqe7y/GHwFKI0S0VQ1iPfx7cpntWiGC2KHWFnLGD9
	JCDtNlHKDWoSEmpYHx2Z9vWeRwPg51NZVwn7GB0bRqtvGD2dJ3I0w==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42e4xfhnrw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MAh8hq018590;
	Tue, 22 Oct 2024 12:06:14 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42csajaub1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:14 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC6Bgr57016716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E78F620040;
	Tue, 22 Oct 2024 12:06:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53A8720043;
	Tue, 22 Oct 2024 12:06:10 +0000 (GMT)
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
Subject: [PATCH v4 09/11] s390/mm: Simplify get_fault_type()
Date: Tue, 22 Oct 2024 14:05:59 +0200
Message-ID: <20241022120601.167009-10-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: _3a04Q7ounfNeSJUG-puTxH0MEWLHUZV
X-Proofpoint-ORIG-GUID: _3a04Q7ounfNeSJUG-puTxH0MEWLHUZV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=608 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410220074

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


