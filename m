Return-Path: <kvm+bounces-47866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A451AC665D
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33BD94E20F6
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3707E2798EA;
	Wed, 28 May 2025 09:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IPk3PmP/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2F427932B;
	Wed, 28 May 2025 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748426119; cv=none; b=OmwFkc55EJfzV/tIEuKQlj0LjboRU8TUaS6NOMUd5nMwcYbBeiZMWHmKcLs8qKU1sosuZWBvXY9CA9K4HTMI+YTWG8w02iP+l1J5anzo8WkhP9YuNtHd0ouaVO49xSOK/sigPpz/aV3gqrLFhYkcyZ4gzWiUtrzz5EkcrBkIjCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748426119; c=relaxed/simple;
	bh=PRCnL8WgpuqQESSocaZd0VvV0Rpn66eBwNGP90uDevE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHEk8EauxMTLYb5wxTN38dJ50qGi12GFYpzmTfxaouMMO9lGMjNfg2DyiGYeKHkD4d/gwtOrhNgRvqd1E5JwvTDYT8QjE/OHKbTgf+Yv9+iJX1hLc5THHXdsmPCSZmeoY3QqCucHTySsO7WpSvEp17FXdy/j/89GCYc5lavdtHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IPk3PmP/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S45xpi012384;
	Wed, 28 May 2025 09:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=f0EkbI+JTUvluLo/f
	zHmqTzfYD56MIaFBBtnL8OTGXA=; b=IPk3PmP/OHx52FRp0wKrPqbVxFgIPJeg2
	CzHuL/oXvCR2Aw1X49S4LJKdxt9OG/QF3EvUynemwCdCmHjolCTQ/yN0ilA9LO9B
	4u3OlILXbJmGQLEkhknjzyuaPDBdXegZjImazMpDPdWaLzb+ZVFWmewgdvnqJ1E8
	mUEjLI1ZiiP+AKq8i+wekKR7tMc250rs/e/ITiL5ho3Y6ixpeJ+0BFsY+ltCFvLq
	mQgtR67UxHv8oZZR92h6soK83iND0l9anUjIdPchvYBrmqd86REok0b9YWyWigT7
	qGJpGnfT+vQCWmCUaDU9qdW0877qPgWC+QWwB+Ceb0UldQ2CjIBeg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wgsgc2uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:55:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S6c0m1015850;
	Wed, 28 May 2025 09:55:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46uu536m70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:55:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9tApt42533302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:55:10 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68CAA2004B;
	Wed, 28 May 2025 09:55:10 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A943220043;
	Wed, 28 May 2025 09:55:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 09:55:09 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v5 2/4] KVM: s390: Remove unneeded srcu lock
Date: Wed, 28 May 2025 11:55:00 +0200
Message-ID: <20250528095502.226213-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250528095502.226213-1-imbrenda@linux.ibm.com>
References: <20250528095502.226213-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OIIn3TaB c=1 sm=1 tr=0 ts=6836dd83 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=-g0RikXFz7zMAnJmuvsA:9
X-Proofpoint-GUID: h13K_zD8G2gSbVxjBv37Gt9RwCBjf0rg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA4MiBTYWx0ZWRfX3d1Pf17qIWHF KdeRODGzXpsL5shoqJFKIy5amA0o0sU2bezKkBiFa9QWgqRWFPJRL0kpC4CRhfeNfac1q6JQWTh PnWsbwKbE1lcNUTQHfT+bkmavF3HwOwI+VPhpsV6TXHpgfcEUm2P4wRKGnKiAKByuLy5wvfttv0
 clgt86tdwYM2YvzYF0kqnKSbm5+Y1PbfUFL5XTr6Cm00WLPVrpcWs4GVle0O/KBFxH4Jvj5EcLl /Uyb3C/StRZZRXnYMlMLjB82We0swx3HMDf1lsuuDerQeGiW7fGGn+JArnlg6zK3Nti6nzzr+NI PNbNIvTUe6FddQ72o0D5YPQu9H0iXDsvjFZGCPIQ17QjncTQCDzZgaCytM+eKl8hGuIAfhp4nUa
 FpVyYz4yr4ZFCF5Pi5Ur2HXDmEMWfp2sdQCMuEOabMCkbYsrOzP9Jj5+CfetxOFzLgbvyz5X
X-Proofpoint-ORIG-GUID: h13K_zD8G2gSbVxjBv37Gt9RwCBjf0rg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_05,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 mlxlogscore=802 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280082

All paths leading to handle_essa() already hold the kvm->srcu.
Remove unneeded srcu locking from handle_essa().
Add lockdep assertion to make sure we will always be holding kvm->srcu
when entering handle_essa().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
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


