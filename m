Return-Path: <kvm+bounces-36906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2B6A22AC8
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00404188893C
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0331B6D0B;
	Thu, 30 Jan 2025 09:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZBM3nWq4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394A21B85FD;
	Thu, 30 Jan 2025 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230691; cv=none; b=qQzOrcHFlk2gBQNmHoO/N5iUV+vr8V3OUzcvfyOdc3mpj3Zzdkr3z6kAin3K9uIVXes4nORDMs6x3YzvHfKgIg3mkZNYT/j/v0THcAGabqBnhnifZnwI0FHsj2lEsu6ov/RecLaoHGACjkCc+TBtCeQL+qJBlcvgPBLnI2cHGX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230691; c=relaxed/simple;
	bh=WHf/GfVwGbpSthBAMPEa+QdYHtEebQt2tiHgzN0wHQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTido/E7LUzTW3SBxvTcLdAXO6xNiQ7WUeOBOE28dDuKOf5/cfYtwr6JhJN+qUpLR7j4o1ROe938pb86PYGprZRzKZdWOCyQ9dCXqLUWNI/pECowrKjhyMpdnbiG0f9rgS8XD9PKnISLbWppav+v+gWy2+re+S0i0C7g1ekvHYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZBM3nWq4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U7X8oh030947;
	Thu, 30 Jan 2025 09:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qVJy8wNMqLFLjIiiw
	JPupQgpBcVbCX93K+STC4IxBKg=; b=ZBM3nWq4MOSpjhDqlrmitqzEIG19FNBnY
	ty1L2YqxwmI4D2RR7kmwxOPuHTqsgkhka8aDxGnHDOkioMtVJf9pR5+SdlA1xOAt
	4p9XsJnzRVV953RWUDX5AsemDdlO0Pzw7pLg5PkKLlqsy662iSVutuOytEndPqlH
	tC6P2YK3wBmziR1OZ5IpPBbmg7J1JWFuTepLSNH9aSHubcRf4wCwzY9mNOlMXJ5y
	ZjaFIEHEqau4SJgewweQcN5cbBirGHjh2JmZtCbcmXb0iV3UnVtqnC5Vou7yBdGy
	wNmZebEvImGGIMiuuI80H4EV+HpZsYRz3G04SVBpGeE3dXFn2MWJw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44g54nrjd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U9mmkm022264;
	Thu, 30 Jan 2025 09:51:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dcgjw7dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pKeC16974200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F0672013E;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B78920145;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 05/20] KVM: Do not restrict the size of KVM-internal memory regions
Date: Thu, 30 Jan 2025 10:50:58 +0100
Message-ID: <20250130095113.166876-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130095113.166876-1-imbrenda@linux.ibm.com>
References: <20250130095113.166876-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C9qoRnc-N77yT48MHfcd1tJtRwfZRj7f
X-Proofpoint-ORIG-GUID: C9qoRnc-N77yT48MHfcd1tJtRwfZRj7f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=951 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501300073

From: Sean Christopherson <seanjc@google.com>

Exempt KVM-internal memslots from the KVM_MEM_MAX_NR_PAGES restriction, as
the limit on the number of pages exists purely to play nice with dirty
bitmap operations, which use 32-bit values to index the bitmaps, and dirty
logging isn't supported for KVM-internal memslots.

Link: https://lore.kernel.org/all/20240802205003.353672-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250123144627.312456-2-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-2-imbrenda@linux.ibm.com>
---
 virt/kvm/kvm_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index faf10671eed2..3f04cd5e3a8c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1971,7 +1971,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
-	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
+
+	/*
+	 * The size of userspace-defined memory regions is restricted in order
+	 * to play nice with dirty bitmap operations, which are indexed with an
+	 * "unsigned int".  KVM's internal memory regions don't support dirty
+	 * logging, and so are exempt.
+	 */
+	if (id < KVM_USER_MEM_SLOTS &&
+	    (mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
-- 
2.48.1


