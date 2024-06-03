Return-Path: <kvm+bounces-18623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40EF08D80A9
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72E121C21C3B
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F183E84D34;
	Mon,  3 Jun 2024 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ERN+6KXx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEA977109;
	Mon,  3 Jun 2024 11:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717413271; cv=none; b=iznJ9l8DHiCJYN9wEEbPU5SPHc6F3AMGnUA1bIBimtQ72qLGPGSktE0H2qchcWEoEomV69LRmG2MIXqos3v5AFiFHwHtFrdA9VYM9itHSb7PkDDCsjmJaMOeiDxed8MVffU6QWoiHTW/80gzGsJmVLWE4wX06oZd1fO7tknLcr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717413271; c=relaxed/simple;
	bh=bFODH12hHt4ra0Lgx2QerhZko1YMpQke631INN2+Xis=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyzQuzP9VTTLcFqkIKdsJE/vRT1A3283JN9R0DxCIyxvt8NIdD3QO1tmXkivZpQWTiPNnQszt21uVv+P3oDenmrUk6uJQ7hfLsQRr0/7MfyEkAN17nllivInV7TZzjKJCtcyXAEeVksitNPEnr/cak7cCSR2mktf4DxLVXkJNvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ERN+6KXx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4539QC8O022252;
	Mon, 3 Jun 2024 11:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=vdD2kV2ciIb0bdEkPikaucEiFf7CKhySLdmRLgn4sA4=;
 b=ERN+6KXxsHFHByZhqpDv+3y4t6i6vu9CrVI5wBeeIhNmXXeZWnyA4PC58AcIwCIYU9nk
 QP3Hna3A/W/9hji0teuR/yrWW3OdzFT2AKqdk5xl2Foqc1iUHmwpX8E3iSAbOk4Deae8
 /cMp9sTc7HfBlsE+bArJ+rDMKbdYHJpjiuiVCSx6MYsJ33E8iBWcmFWXCIQY8eTUpt93
 Eq5kG3O2zpwnqoEz98KihdN5PJiwkoQQ9o52+rr4G+++0RjmDXtLgviKoVDcB39/pThU
 3UW08tp/cPL8EqgHMNVoaoGD4L1wFOt1GTxYznI17N/Hd/mfL0xFx21AijFZlKDyfXgt gw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yh9w8gff0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:17 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453BEHBO029255;
	Mon, 3 Jun 2024 11:14:17 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yh9w8gfev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:17 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4537twnJ026550;
	Mon, 3 Jun 2024 11:14:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yggp2q0fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453BEAVV20906474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 11:14:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF9562004E;
	Mon,  3 Jun 2024 11:14:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D906A2004B;
	Mon,  3 Jun 2024 11:14:08 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 11:14:08 +0000 (GMT)
Subject: [PATCH 1/6] KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2024 11:14:08 +0000
Message-ID: <171741324316.6631.12096363054516478201.stgit@linux.ibm.com>
In-Reply-To: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I1Iy_x7ZUjLQN5WvK5f79UIhS0FAfUTH
X-Proofpoint-GUID: U7vnU9bxyMciEwx4D-NZ-RkJCOgzNa9u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_07,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=637 phishscore=0 adultscore=0 clxscore=1015
 spamscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406030094

The kvmppc_set_one_reg_hv() wrongly get() the value
instead of set() for MMCR3. Fix the same.

Fixes: 5752fe0b811b ("KVM: PPC: Book3S HV: Save/restore new PMU registers")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index daaf7faf21a5..a4f34f94c86f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2540,7 +2540,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		vcpu->arch.mmcrs = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_MMCR3:
-		*val = get_reg_val(id, vcpu->arch.mmcr[3]);
+		kvmppc_set_mmcr_hv(vcpu, 3, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_PMC1 ... KVM_REG_PPC_PMC8:
 		i = id - KVM_REG_PPC_PMC1;



