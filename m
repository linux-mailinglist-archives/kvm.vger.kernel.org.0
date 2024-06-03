Return-Path: <kvm+bounces-18624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 642B48D80AD
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95D3E1C21C0C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7698C824B7;
	Mon,  3 Jun 2024 11:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tp6xU6Qn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BFE84A40;
	Mon,  3 Jun 2024 11:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717413281; cv=none; b=B8IUYnAcpbSe3tiyc8WD/8S9ZlgGE0AsRqcP4xptK+vz9PavW+Y5doTOuyAqYYTQafhxi/f9kl6VlXF+mYcwILlisEOTGkVOtrHv3847nVyfZuX5BIZ8FsUlD/D5lGinxRNoN9qG2rOdbYYPWlbpsLxEhqJYv1syI74PGkY1OV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717413281; c=relaxed/simple;
	bh=gh570KNSCoGTloofXXJgP8M/IG5ml6UIGK3blzJH8Ec=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DMCiwcbTbDEUB6i61zgkhI+icPdiUZKy1tcVTr2gMDRikgw36yPPTNrnbCTFutS2p0yF1RfdLkQHjNJx3oR04F3l2qfno3kG5kL7n52UBTNql9ULd/9OsQTOVLWECJzuJVyjZSoNmPE8TObjYkkyrPjLJuYgBkk9MnWBJByvN3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Tp6xU6Qn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453Ao2Jr012437;
	Mon, 3 Jun 2024 11:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=q5FvJzhb5nLV1oH9/w5ayFd7+TAjNgxMSRPcWAmJp+w=;
 b=Tp6xU6QnL/MWktHPU93Ge4D5J16sOmXK4lVNH3nDL62TS9Ml8Iy//EksnzZtW1Sytgrp
 2j/U3nHd5SFFzMyGq0ymi0W5ICQBWkEjZLfcTgrSXLm3AAuG8Vgapkh5kAD3Jq6A3Fod
 OGU4Rwhgv/9WdiCzUzPBsI4Tc603el3o/0ICdgv/t3e4v2+qnI+lqWTKKtN3+i6iUNMl
 43k2F1Wfqwn/qngR86awjHb77kr3RryPCrY01Z3nIqkniXYa8Gbf9ScKZ4RdJ5WozFc5
 G3/vSbiENpoumNGjStqPwZ1LasfI2w4joVMfiMNCERaGXdU2QXr9k6W8mPI3EPxE4FUp 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhc0yg4ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:29 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453BESV1029986;
	Mon, 3 Jun 2024 11:14:28 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhc0yg4at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:28 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4538ewda008479;
	Mon, 3 Jun 2024 11:14:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec0fncp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453BELpO56820128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 11:14:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96CC22004B;
	Mon,  3 Jun 2024 11:14:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E52C2004F;
	Mon,  3 Jun 2024 11:14:19 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 11:14:19 +0000 (GMT)
Subject: [PATCH 2/6] KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2024 11:14:18 +0000
Message-ID: <171741325608.6631.15015853676135060467.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: -ocXsgruZ9h7C1bKm5gSJuRhVrh5RNX2
X-Proofpoint-GUID: IlD5_8AP2ZCl8-ECo0PvIZsM9bEoLvVT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_07,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=620 clxscore=1015 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406030094

The kvmppc_get_one_reg_hv() for SDAR is wrongly getting the SIAR
instead of SDAR, possibly a paste error emanating from the previous
refactoring.

Patch fixes the wrong get_one_reg() for the same.

Fixes: ebc88ea7a6ad ("KVM: PPC: Book3S HV: Use accessors for VCPU registers")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a4f34f94c86f..b576781d58d5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2305,7 +2305,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, kvmppc_get_siar_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SDAR:
-		*val = get_reg_val(id, kvmppc_get_siar_hv(vcpu));
+		*val = get_reg_val(id, kvmppc_get_sdar_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SIER:
 		*val = get_reg_val(id, kvmppc_get_sier_hv(vcpu, 0));



