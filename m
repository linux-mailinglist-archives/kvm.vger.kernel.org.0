Return-Path: <kvm+bounces-18902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E79738FD029
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A6D7B242B2
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5CB197521;
	Wed,  5 Jun 2024 13:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i0QwmtSk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272CC14BF99;
	Wed,  5 Jun 2024 13:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717592810; cv=none; b=bb2GvrDFrpLbDQihKdIPPsaGsFPs00stA6KGdwW3DSZjqZc7m9FMofd+eBei2M66BdMrbLniiDS0KZscWEW2mMxkdPQ8RZvD7RlCwgBWmVDBpGKQedwf7eV9mdFakKIz91rT6zIPFK0a6NBBYeT+75sJN0P+W7Th/wYqlOmF220=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717592810; c=relaxed/simple;
	bh=gh570KNSCoGTloofXXJgP8M/IG5ml6UIGK3blzJH8Ec=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wl9euKx3JrS+SbqnytXZK1kenaPVijL/ZIk/i0kUx49cCsydTazJrkSea3zX0BJsWr2UQXFg4Itp/v8NEKs4f27j9h554LDSi1m2ytKU5EB8qXMrtGqHRBSFZnq5HEZzxHxgP2LmjxRoJnUtfUrMKM2c8Wkqt03uLYq8cPzFdgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i0QwmtSk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455CdOEe007319;
	Wed, 5 Jun 2024 13:06:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=q5FvJzhb5nLV1oH9/w5ayFd7+TAjNgxMSRPcWAmJp+w=;
 b=i0QwmtSkYkGB5Np+kW+I/e4JB+5xHf2JkJX/SnAlI0a7US53rzu9Zdx9keUkMz28B2gV
 tHgLUtvGimefXxquPcGiq4iJfxCpnNuwQHp9UdPc/amjNR4hxfRH/bSH8Tbv9vmBzdYp
 bwpkkT8RmY4aXObdS+mMXXosaUlVqaQ538UyG5h+2kl8ZiV1mrt7KMuYEMUX/u7c5pBX
 lxv/YMr0BTuYzee7ZoWW7JDAFDTCIB0TWLQLKErA/G8l9tM171FeRshfzrivwrphxeWx
 8pYDiP4Lu880zntKpFOyB3KmkQLaapaQSz7igF/d9tkkIIHaViCQKn21dYhjOpvjGTI1 Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjr6rr2hc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:06:37 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455D32tu013027;
	Wed, 5 Jun 2024 13:06:37 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjr6rr2h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:06:37 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4559mbLA031142;
	Wed, 5 Jun 2024 13:06:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypm7wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:06:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455D6U7O43843926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 13:06:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2FDC20040;
	Wed,  5 Jun 2024 13:06:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B177320043;
	Wed,  5 Jun 2024 13:06:28 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 13:06:28 +0000 (GMT)
Subject: [PATCH v2 2/8] KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Jun 2024 13:06:28 +0000
Message-ID: <171759278410.1480.16404209606556979576.stgit@linux.ibm.com>
In-Reply-To: <171759276071.1480.9356137231993600304.stgit@linux.ibm.com>
References: <171759276071.1480.9356137231993600304.stgit@linux.ibm.com>
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
X-Proofpoint-GUID: ib8xQCiLpwIpmCuNewKVB8bvPbFNUqQ-
X-Proofpoint-ORIG-GUID: jhkd-epoNR96V4rinoQHznG5uACL4Pqg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 impostorscore=0 mlxlogscore=619 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050099

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



