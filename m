Return-Path: <kvm+bounces-33393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC36E9EAAD5
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:40:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CA4B188B0FE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 08:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3991230D0D;
	Tue, 10 Dec 2024 08:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tAsoiRmh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749231B6CE5;
	Tue, 10 Dec 2024 08:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733819998; cv=none; b=aYIC6V7Isf5Q84YfaCp0Gcjp0gQpdoF3mHGki4+h/Fcn8RtoIsW062y5ezERXGRsKN7ybyefVQ6kwQutML9Ef3AR6JQJ3iQCQ0wPTk2aEfQwT8lCC4wCfY+9e6/GKaUDoy+7TY8pWIbA5XK1xcvv+F7YpvL1i/zGZ3oMX9T8kxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733819998; c=relaxed/simple;
	bh=1U90tkSlgCM2c0ntCjd0/PeGDQGi1IHybKfQQgSA9aY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lOV5OakbUtfnuPKtIEBsUu8bEVnCNQ9sZFURPGPPAgV5VApQ/tqBySn9grbpCObQL+FhNarHTD7mPdmGcmtwdTOemABKzGMEBmhv83ERaczRNUSqzSbUDD9gmn+AnTEDSCfPnhCMl7CUc5rpD9PTz2Y3iPmHVZPW95cWPbfNSx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tAsoiRmh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA7NBqW015473;
	Tue, 10 Dec 2024 08:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=qUdpemlOHZ1Ug0Ns/x2SUT080FHnIeZFUe0Dk7C6Q
	xM=; b=tAsoiRmh3r9FM34afzHlucmu1W9p20zkUFJPUjrWTSpgdYvQvgXytrqqe
	aVOn1VfpbEqYBWBXW/J7pkSnDCuyFn4VHc2bsMX7x2NV4GqJpIvv7gPqpOxwmLE+
	kWGR9BNCUU2/DtzsXiLrsDppKSZpLRTQ1rbkHSathbxdQ0pOI8tXJLrYof6RVTIL
	N/eO4lg+ra6bvZ4bPziy/6fmfPCZA2xcgwD8p04yb5jD7dYbnsLa/IuP6+2wTxfi
	q8Qr3QxeK5lZ1fxDrJHFWO0cqylgyaCoXEPkjmZpGbP1jwaF1gIQvSRgS/T7uP/B
	n3i1J7U7LCB7osDIiRwPgxqx1E+Ng==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ccsjd1e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 08:39:55 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA6WZcA032760;
	Tue, 10 Dec 2024 08:39:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d0psb00h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 08:39:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BA8dm2u31261214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 08:39:48 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA89C20043;
	Tue, 10 Dec 2024 08:39:48 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7231320040;
	Tue, 10 Dec 2024 08:39:48 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.179.15.147])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 08:39:48 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v1 1/1] KVM: s390: VSIE: fix virtual/physical address in unpin_scb()
Date: Tue, 10 Dec 2024 09:39:48 +0100
Message-ID: <20241210083948.23963-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hSLyTAwSBb-AbiSM_-ub1Jf8i0HXQKnF
X-Proofpoint-ORIG-GUID: hSLyTAwSBb-AbiSM_-ub1Jf8i0HXQKnF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=868
 mlxscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412100065

In commit 77b533411595 ("KVM: s390: VSIE: sort out virtual/physical
address in pin_guest_page"), only pin_scb() has been updated. This
means that in unpin_scb() a virtual address was still used directly as
physical address without conversion. The resulting physical address is
obviously wrong and most of the time also invalid.

Since commit d0ef8d9fbebe ("KVM: s390: Use kvm_release_page_dirty() to
unpin "struct page" memory"), unpin_guest_page() will directly use
kvm_release_page_dirty(), instead of kvm_release_pfn_dirty(), which has
since been removed.

One of the checks that were performed by kvm_release_pfn_dirty() was to
verify whether the page was valid at all, and silently return
successfully without doing anything if the page was invalid.

When kvm_release_pfn_dirty() was still used, the invalid page was thus
silently ignored. Now the check is gone and the result is an Oops.
This also means that when running with a V!=R kernel, the page was not
released, causing a leak.

The solution is simply to add the missing virt_to_phys().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 77b533411595 ("KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page")
---
 arch/s390/kvm/vsie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 150b9387860a..a687695d8f68 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -854,7 +854,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 static void unpin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 		      gpa_t gpa)
 {
-	hpa_t hpa = (hpa_t) vsie_page->scb_o;
+	hpa_t hpa = virt_to_phys(vsie_page->scb_o);
 
 	if (hpa)
 		unpin_guest_page(vcpu->kvm, gpa, hpa);
-- 
2.47.1


