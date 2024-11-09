Return-Path: <kvm+bounces-31343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E20B39C2AAF
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 07:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 110271C20DFD
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67997145B1D;
	Sat,  9 Nov 2024 06:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TVtC7ZBX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2045E142E9F;
	Sat,  9 Nov 2024 06:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731134019; cv=none; b=MIiQi9U7G8nh/lJOabRKRLtapF2sIc0Nf/JO6oi1S3izUe4hOWdFWhoWAs3lgCDctWyPwoJPS10jX+7P+myd0qorWnI2edPKXFdYadiOW4f4EW69qe8PjmUPvRTsGkvgs2476XyQrVPC5mvy5uyMa8qX2FbvxND3Vy5DmS+NgCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731134019; c=relaxed/simple;
	bh=Wv8e6zK7nnQ58UwpLH39ENunFbinswBhSKn6KcC05hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvFnduntCO0u7D/GzxWZlqqEqST6udvG/GJRWHqsOvfxk0KXn9PaZ45g6P3fOWLhYZ/frMEgfhlGpM5aq1HJXeMvx/pKqx5nQanMUWb2WoVuZ+hf0rzbY4i7b2aN35Q0y4j5xyc1m6zahV84g+07EsF/v4RaLQ3p1J0BWUwTbQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TVtC7ZBX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A96AEmA014431;
	Sat, 9 Nov 2024 06:33:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tZPX1N8QudpayLdFb
	xxGg89zZpw3fldD1pd09WNFmZs=; b=TVtC7ZBXHA4rriCgia1RdBWtKnm28Q4t5
	/WdRsxi3GeolsXQfDQSFCSHiNrY5n1gwfrh7mw9PxEiFSFrCwKWaMWbnGNp37/+x
	vtLrR8y4F47206vfpvwdemR3l5J5inGsKipELA2LKEYc4P6E/1LNaPM9nS2qAjk7
	kzBSkTv31vT2Nsca12Ah5c3z6K/k6eq1pLoy7SiK5ENaUEofeBiwq0+bdn3Lf4I6
	Nofine1Dmk9Bkxt8UeyzoaxCc/2BKXP+6meYVFsHFYo2pBf4i+yDPoQjrPDUpjJQ
	CQpSrZ8I3fbPr1cHgrO/89ZoLQEHNfrrWVD42XETtHIgNcH8GtRPA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42t27q82mj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:24 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4A96XOZ0025283;
	Sat, 9 Nov 2024 06:33:24 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42t27q82me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8J6ImE031474;
	Sat, 9 Nov 2024 06:33:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nydmum9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:22 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A96XJv052953592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 9 Nov 2024 06:33:19 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37E5020043;
	Sat,  9 Nov 2024 06:33:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F2B220040;
	Sat,  9 Nov 2024 06:33:16 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.124.214.93])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat,  9 Nov 2024 06:33:15 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen@kernel.org, maddy@linux.ibm.com, vaibhav@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Revert "KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1"
Date: Sat,  9 Nov 2024 12:02:55 +0530
Message-ID: <20241109063301.105289-2-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241109063301.105289-1-gautam@linux.ibm.com>
References: <20241109063301.105289-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nqh2LgZWOmgYcKf7JpuwP8dgmnPaeeBT
X-Proofpoint-ORIG-GUID: dmBmyCaQWZWbbmRF5G6NxR5hHZPo_Eei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=616
 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411090049

This reverts commit 7c3ded5735141ff4d049747c9f76672a8b737c49.

On PowerNV, when a nested guest tries to use a feature prohibited by
HFSCR, the nested hypervisor (L1) should get a H_FAC_UNAVAILABLE trap
so that L1 can emulate the feature. But with the change introduced by
commit 7c3ded573514 ("KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs
to L1") the L1 ends up getting a H_EMUL_ASSIST because of which, the L1
ends up injecting a SIGILL when L2 (nested guest) tries to use doorbells.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ad8dc4ccdaab..0a8f143e0a75 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2060,36 +2060,9 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		fallthrough; /* go to facility unavailable handler */
 #endif
 
-	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL: {
-		u64 cause = vcpu->arch.hfscr >> 56;
-
-		/*
-		 * Only pass HFU interrupts to the L1 if the facility is
-		 * permitted but disabled by the L1's HFSCR, otherwise
-		 * the interrupt does not make sense to the L1 so turn
-		 * it into a HEAI.
-		 */
-		if (!(vcpu->arch.hfscr_permitted & (1UL << cause)) ||
-				(vcpu->arch.nested_hfscr & (1UL << cause))) {
-			ppc_inst_t pinst;
-			vcpu->arch.trap = BOOK3S_INTERRUPT_H_EMUL_ASSIST;
-
-			/*
-			 * If the fetch failed, return to guest and
-			 * try executing it again.
-			 */
-			r = kvmppc_get_last_inst(vcpu, INST_GENERIC, &pinst);
-			vcpu->arch.emul_inst = ppc_inst_val(pinst);
-			if (r != EMULATE_DONE)
-				r = RESUME_GUEST;
-			else
-				r = RESUME_HOST;
-		} else {
-			r = RESUME_HOST;
-		}
-
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
+		r = RESUME_HOST;
 		break;
-	}
 
 	case BOOK3S_INTERRUPT_HV_RM_HARD:
 		vcpu->arch.trap = 0;
-- 
2.45.2


