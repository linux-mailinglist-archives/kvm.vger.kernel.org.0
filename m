Return-Path: <kvm+bounces-47174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7D3ABE2AB
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 20:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5006A7B7954
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1924D28466B;
	Tue, 20 May 2025 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZWVA1fem"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C4E28315C;
	Tue, 20 May 2025 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747765616; cv=none; b=lrZhPQLc4hk8hNeJmHcjmWOmc8FiSCsTVzrJ11KnsFnsmpmVMHm+yB6lnHywas6pwq95zCEcnRdV9R97e9kTbdExBg7P6JVTx++omVfSm87NJx5uJZE15jS53lmSFo20EpwkmrFOlIXbvx+sTHD0DYDeYgBKNJSnO5GB4nzwLRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747765616; c=relaxed/simple;
	bh=0qqqPE9xnugy+HKbrUpX3u1km+F4o6c19MmrBY7D9bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSNl7CzqN+Yfn9VF4aaZMu6jkai/Js+YS7M2uuu2LX0lAX2kIkNK+ICsB40/wVTQxKPZDodhCgT2My3b7+v0yudOcHqYNmqgjBZPEk+32m2NbtD+tuHRE//5IFutoFbWwRTPVvqb+5aV0gbbxv52eWYkuah434UsDV1GzWg5Yxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZWVA1fem; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KH6ts5018087;
	Tue, 20 May 2025 18:26:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=U47iHLeCCBH8D7ypN
	hYU+XbgoBkrOGAZQxp6TQV0bHI=; b=ZWVA1femm3EGhQxC46s0TGeGWz84K5Q6n
	ZWiVKSUPrdstqDsmcxRVeU3Af8pcqQfkqqvc2rGIQnTJwv2AVtXim/5AyX/W3mSG
	uqeyy6VnSK4sge37HjhVkAPgYsADDzvWaof0fy6g2l0LHDGB+toBwNaYppSPhFx1
	ftwfJlrNSfHX1uo0NKGMypMqvCpp9/QQ74b4QbTfPX7SApCDOYjYFT2M+DpgIW26
	kTHL192hVZPMPPgPoguABJyl9vXBdJMapisfEX2j/hoJ7WuDbYLsUGcdfX6AG3jW
	t9PPmbvFOjXG+7h6m807blZUTem7yO9xLhlz5eu6S0lpdg5ZqFy/g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rwus0c32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KGnpPU024710;
	Tue, 20 May 2025 18:26:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkr0dav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KIQesr16056602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 18:26:40 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A09862004B;
	Tue, 20 May 2025 18:26:40 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35F302004E;
	Tue, 20 May 2025 18:26:40 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 18:26:40 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v2 2/5] KVM: s390: remove unneeded srcu lock
Date: Tue, 20 May 2025 20:26:36 +0200
Message-ID: <20250520182639.80013-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520182639.80013-1-imbrenda@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Va/3PEp9 c=1 sm=1 tr=0 ts=682cc966 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=-g0RikXFz7zMAnJmuvsA:9
X-Proofpoint-GUID: 7h3B5V7Jb0CLBNNFLTMCs3H_T-wx95jo
X-Proofpoint-ORIG-GUID: 7h3B5V7Jb0CLBNNFLTMCs3H_T-wx95jo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDE1MCBTYWx0ZWRfXxk7Iq5jpT34J VRbiNh79Un0s8p5T3QXvx1gs8Frv5NqkC/EIa524fvS3Or5QN4GMJIvJOHNBemGqunom3Ao9BVn cPwYQXg/Y+ZHBhCxqhtfZcYCTZkQWc7V+26CLgKKLDwpGxlFjlpZAC3cGqn7XkCwYx29JZcj2UV
 TuZecWGgbajM9F9TVhqCODOmWe21NesYM4GCr5NFgxPj/5AJ74s6IX4fDEUzii7/E/bxez7nvA6 1XSPu3zX/Rsm4RPKO7dpFk7bf70Ub7LGwJYX/yQ0u2EsbWSkg9svY7sBXfVZTfchSgvcebK8OEZ EB7pjmY5Dbu/kjAf/gW7BmLSygSikSjGWHvH20hOT3/ZMAmeG40Mh1zJHwzcWGqnGDSBZXzZeIi
 Ji2xMPewagj9W7EL5mkckLgBzl6p7YJHOYMERZLxSn3041h3cwLsd8GMRi2SUQc/gRDgimE9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_08,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=770 clxscore=1015
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 priorityscore=1501
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505200150

All paths leading to handle_essa() already hold the kvm->srcu.
Remove unneeded srcu locking from handle_essa().
Add lockdep assertion to make sure we will always be holding kvm->srcu
when entering handle_essa().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 1a49b89706f8..9253c70897a8 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -1248,6 +1248,8 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 
 static int handle_essa(struct kvm_vcpu *vcpu)
 {
+	lockdep_assert_held(&vcpu->kvm->srcu);
+
 	/* entries expected to be 1FF */
 	int entries = (vcpu->arch.sie_block->cbrlo & ~PAGE_MASK) >> 3;
 	unsigned long *cbrlo;
@@ -1297,12 +1299,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 		/* Retry the ESSA instruction */
 		kvm_s390_retry_instr(vcpu);
 	} else {
-		int srcu_idx;
-
 		mmap_read_lock(vcpu->kvm->mm);
-		srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		i = __do_essa(vcpu, orc);
-		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
 		mmap_read_unlock(vcpu->kvm->mm);
 		if (i < 0)
 			return i;
-- 
2.49.0


