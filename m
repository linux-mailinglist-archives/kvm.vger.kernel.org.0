Return-Path: <kvm+bounces-20618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB38B91AEB2
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 20:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5464D1F2283D
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 18:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B970D19AD97;
	Thu, 27 Jun 2024 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G8sQakLF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAC3199E96;
	Thu, 27 Jun 2024 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719511451; cv=none; b=rGET6d20J8KqdSMolz8hR0pJvadk6vA6PGghHqQ5BQM6gCLqufBZaY5j8asZ/P6TEIjVTHCC0j2VnmIGD+YFAew3kl0GoanscHm4Qn9vczuI7qi2YtKkSRsJoS6DdBgSP2BZ8OergLzA67njQk3mUvF7cpof64XtyQWM49V2vWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719511451; c=relaxed/simple;
	bh=1Y/eF8/ht1NP0XMMZPREsWWze4s24nQPevlLzGwfI8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+SCmyuoFJGzEoeSnmPQkEVqbjr3TEBhsgV6RZLCQfkROS3DJ/9bCWpMEqNtASkQAgFeIsBJMG24dxiw6fzEz4TdmUqUl2J8XyMWDnjlWGZt4hkprYGMcOLqxRRyNF5e8gH5jtNucQnRD9aWqRCPGRyC7FbK2G6h7Ei7/GIXNWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G8sQakLF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45RGSejR013309;
	Thu, 27 Jun 2024 18:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=HNHlnif/jrbsv
	f6Wbg+hxJ4VwzQZ27plZqQtYFJoUVs=; b=G8sQakLFWEmTJSBvyEhBNCh74TgGw
	4FD9Xhxq6n6jFUhenUl+j4s2rNEjsZ9PyjG60KyMmpUX5bcReJJHk6xrq1isRIbW
	fo2KkRnQr/rrLdi3uGWiLw6TaDHaPAULN9VXMfYbCZVhlO9ZDZf7Ws6sCCUbR6K6
	tC6LoRzF9uzIPqThK/GvOpggNLbrnbVpHHFq0tJa4nanxEFp2jj7bai0CS3elfaB
	2t5kZFGHDaWAyun+qz+mBQGu6o7s3xnxICn23W9e5etByM4XIVdz6dzOjjBVexkO
	eW9U1qHDnCBx0le4NbMQFK1382S89r6XOE4Yw9qTz1vS6/iz7dL9Er4iQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401bmng7yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:03:59 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45RHxjQw020462;
	Thu, 27 Jun 2024 18:03:59 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401bmng7yh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:03:59 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45RH1Ht6000388;
	Thu, 27 Jun 2024 18:03:58 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxbn3kpd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:03:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45RI3rOl39780820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 18:03:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E91BB20040;
	Thu, 27 Jun 2024 18:03:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1124220043;
	Thu, 27 Jun 2024 18:03:51 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.107.18])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Jun 2024 18:03:50 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] Revert "KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1"
Date: Thu, 27 Jun 2024 23:33:35 +0530
Message-ID: <20240627180342.110238-2-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627180342.110238-1-gautam@linux.ibm.com>
References: <20240627180342.110238-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: itJqNvGUj0aejhYpca5DTjtWn8moGkaf
X-Proofpoint-ORIG-GUID: ReuSF8Zpt_luHAx5WfL7f4EjKRbKkOln
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_14,2024-06-27_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 mlxlogscore=654 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406270134

This reverts commit 7c3ded5735141ff4d049747c9f76672a8b737c49.

On PowerNV, when a nested guest tries to use a feature prohibited by
HFSCR, the nested hypervisor (L1) should get a H_FAC_UNAVAILABLE trap
and then L1 can emulate the feature. But with the change introduced by
commit 7c3ded573514 ("KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1")
the L1 ends up getting a H_EMUL_ASSIST because of which, the L1 ends up
injecting a SIGILL when L2 (nested guest) tries to use doorbells.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index daaf7faf21a5..cea28ac05923 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2052,36 +2052,9 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
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
2.45.1


