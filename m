Return-Path: <kvm+bounces-47896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE14AC6DC3
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 18:18:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5948D1C00EA4
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E62F28CF69;
	Wed, 28 May 2025 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SyYPh6eo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FE4283C8E;
	Wed, 28 May 2025 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748449016; cv=none; b=UPhTFSVqIiy54sPo1bBVV4TR4xTxnXbZcgiCu1APXRfCOPdMA7js/bV/vVAsIOzEm3/fsLZjVjAposqGWlxiq+TuZpemwFRNAGxMARhzFj/hy4j+R/VeCGFAglBIJZnM3cdC1T9mmQ6Qge+hoFtpbNx9nSoCZJKofMIV3XfYQaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748449016; c=relaxed/simple;
	bh=13jI8XJL5//1M1FevxPzq4MT8mBF/9l7Hyc5vWPgzIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5SF9nqTYXgb50B2rkwe12Zo3GbNOwXWqCpjsfDkBwKPTOwh/jtW7stFFCcj762wfbxbUviT3ausMFpt9PjribmVal82TNB3yY31aKMvVldz4Ii0u4Ha8frp3KzP6DA1rODx2ic6c8TiXZTXy3kaZZdho9EsiXOGc0w/YGbQdV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SyYPh6eo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SE9Nki017397;
	Wed, 28 May 2025 16:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=RuzY9hy21XMYoBN4v
	PBLzEFxFJb3lDQt3o/HkBZcpEs=; b=SyYPh6eoYaXswUgC4bSzTRmZ8Xccw3WkX
	CiJr+YlS9OQsleuGL4q9MnLQZ4EvDQn/81VRGjDBqWcE/pJ6d2VXi49fzNey0pu/
	0ZTh8JCXaejI51Uq5P0QbQ+4WCr2go5LKtVx68H718YmxlrYjOs7uVvQw2vN3it6
	a4KUcazVID8dfo/LFzVcNDxa7VnaWJ7YwywGdHzezbmvGpE18T5dLD1IRj3J7UKL
	8rx0baL/lc+TrTWSFYA5ddAVR4/uxpjPSYBMdH/H0srCPdZLLt8ZaTNM4OwESNOT
	YN7Lu6VGHx01fF3xeOls4qWdezlfu0SuJBpOEc/rp7wIbTUQHQ4Vw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40ggpmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SF2wEj016178;
	Wed, 28 May 2025 16:16:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46uru0rcvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:51 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SGGlkW48038346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 16:16:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36A1D20040;
	Wed, 28 May 2025 16:16:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D373D20049;
	Wed, 28 May 2025 16:16:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 16:16:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 5/7] KVM: s390: Remove unneeded srcu lock
Date: Wed, 28 May 2025 18:16:34 +0200
Message-ID: <20250528161636.280717-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250528161636.280717-1-imbrenda@linux.ibm.com>
References: <20250528161636.280717-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=avmyCTZV c=1 sm=1 tr=0 ts=683736f4 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=-g0RikXFz7zMAnJmuvsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEzOSBTYWx0ZWRfX3k5UaTInyQzC T3dt+JrrFFmGKL8zfVZfX1d/oo84cTGdQoGF8x+KJoI4o7AjcKmqyocqKjKtmLZXqV0pPeJn3G2 JHcQbi50+FutwIqhPQtuepopU3KH8jLLZB+IIjoUxaVklOtQ1mw43M/9/n0+IwrcTq1viix6tfC
 JoTN2OG3sSsdzqgbE6Ev9c1GB/9zD/ADEPY10s8+wnK0SS4BWvBFzAO+MyLER5IglAR+CTKHkeA /qgUEVn9urX+nc80lp/l6GvP2/meSSQEJU4k0tqBEzrlsCW6YbyGEyvTfHLYOML21CpvNTBF0PH bXOxPWdF/oeM5jq4uphkISVJHLKC0lZq0FzUNdFBqwAKcT7vRMoKfBGIP0taL67FZx3DAyWhtFZ
 yaiN7nC9eTA7XgctqzI+W6m/PhsOFrfNMSQlmCwkUbR8qqYorcO5PaW+DoLVLEIBnFQJkDqw
X-Proofpoint-GUID: RRQKge4S7PepgvLufO6aWHw7MyAJF3N3
X-Proofpoint-ORIG-GUID: RRQKge4S7PepgvLufO6aWHw7MyAJF3N3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_08,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=823 mlxscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280139

All paths leading to handle_essa() already hold the kvm->srcu.
Remove unneeded srcu locking from handle_essa().
Add lockdep assertion to make sure we will always be holding kvm->srcu
when entering handle_essa().

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Link: https://lore.kernel.org/r/20250528095502.226213-3-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250528095502.226213-3-imbrenda@linux.ibm.com>
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


