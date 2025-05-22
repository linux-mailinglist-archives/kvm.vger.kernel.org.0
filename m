Return-Path: <kvm+bounces-47367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22CA6AC0C9D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92C421BC511B
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FE728C027;
	Thu, 22 May 2025 13:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GzHBeOIh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F4028BA90;
	Thu, 22 May 2025 13:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747920190; cv=none; b=t2KL3DzL+sfHA2AoPJyisljMyaZOGUCQ5vd+/aldW20VeEb7j0788+gBHRQbf4wTFHYTPngcVC8jfE2PPPHdDhEqffUPxbzjXfTkmuITccg0q0Xa4mDAj1F5GQFFhdV5RsU6hy/yJNNeyS7eOl7iRr8bUMZEZA7TMbwxWu2XyyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747920190; c=relaxed/simple;
	bh=0qqqPE9xnugy+HKbrUpX3u1km+F4o6c19MmrBY7D9bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkGmn9Or3jyjqAlc8k8Ckq46c6DKd4EgwkiFK3+6B1SaijYRLjyCyqKaTCN9HFK+cCLhjklLhACy5/jaPNJHtTu9jreesWVr3JEiVeZV+vybMGjDUHEVaeRw82xa0vWpZezmC5FFwydQec/HORgeHSJIqmG36sqNC/6Po449+CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GzHBeOIh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M8pZKg002955;
	Thu, 22 May 2025 13:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=U47iHLeCCBH8D7ypN
	hYU+XbgoBkrOGAZQxp6TQV0bHI=; b=GzHBeOIhnscpj5bPjvYT4VaM3G6L4YC3m
	vNK/cwjlWAYeNY05vQpweKstIcaffOEW/UgprqrkE7/kMa7jM/C5o1ZsCGVGIHyg
	D3ct4riAdp2MGqdBhtTL50ymO02Y8EYSD+V/rTzpHpY8mQm2ZxXhk2BTR3NdUgra
	N8No1ItT6FzxNm4bt7PJd3Im+nRZkdM9kiFbEOKNh2qU4SVCjl1FV9+c2FR4oM4u
	Vc8BIbgTmBp2j0vC5LNSQbXyL0XX0OjQ78f6rA0Cft43azgLt583J+XbU37X9qRJ
	IVPJ47+nPNgzNWuulex8juDRsEVn41IjZbk1CWV+wv4SFkAvZpqJg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t0sjh6ku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:23:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9al3w015506;
	Thu, 22 May 2025 13:23:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnnhjyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:23:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MDN1jp42074562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:23:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D6D62004D;
	Thu, 22 May 2025 13:23:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A3A3C2004B;
	Thu, 22 May 2025 13:23:00 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 13:23:00 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v3 2/4] KVM: s390: remove unneeded srcu lock
Date: Thu, 22 May 2025 15:22:57 +0200
Message-ID: <20250522132259.167708-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250522132259.167708-1-imbrenda@linux.ibm.com>
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEzMyBTYWx0ZWRfX4ytbLFeZjgK+ Ncs++e9nFGGS+KGPckJDiGbmT+ZYvEHTAvk5lx+vpk49Hx121tsIR1D0SdkVeADVebAFJorvXSV K2geW4HCur+64KjdgWEnPW9NloZzr6CNLPUkz/KhuJ79HwdrYu70YZVW3LBuEk0RfcoPkKVfZAT
 leHzpQzYCx6nuZUQ+yDwYgZkfKBjU3spWsaerDbLkyfLLR6q/XrApAlAQwpnKfCSI2DAL67ci2x Mcv3IiEtQYOeGyvuCc23GfAGy1dyFauOi9yuWa5k7BuWkFRJp2tbQrw8xOoU3+4p9hH2IryKuAZ X4/zP3GGVlv7T2+R3aIf1RuE/q2LSMk7SLMEuzxU/rMn6j/hPeWCyscggKVwHbr58rcQdzwr408
 boBA79Ha+pQ3WC579BgX2stbrfeW8sNx5PLB8j4ttjFtq0nuTlRlB0Ic6gNrEVXTcNB6h/NO
X-Proofpoint-GUID: Gbh2uI7HZhfy3ML-C07Wqd4_JD8aDPJX
X-Proofpoint-ORIG-GUID: Gbh2uI7HZhfy3ML-C07Wqd4_JD8aDPJX
X-Authority-Analysis: v=2.4 cv=HcAUTjE8 c=1 sm=1 tr=0 ts=682f2539 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=-g0RikXFz7zMAnJmuvsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=770 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220133

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


