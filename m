Return-Path: <kvm+bounces-18904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB938FCF6B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAD531F20D67
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36C3197A99;
	Wed,  5 Jun 2024 13:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bmm2P7su"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDEC18F2DB;
	Wed,  5 Jun 2024 13:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717592858; cv=none; b=KZMTdqg93RZzdKGOeY9e9U6QX1kTBRYNP4zU/6NG3N7PJJ6GorBlD6LWkrAP9Nep3HDMCNNjpkmnc2rZqeYaAnC/wEbtf3nSnKD43ilGdGsRirOU07ecy+yQsc99mYSenABf3pmOH1cAR72oNkOHK6ZHtr2vJz/mFDMWHT1BrV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717592858; c=relaxed/simple;
	bh=bGjUOtkRtXTt3BqzlogmvzKNQc5qwH4ibWuW1B+thsM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HYiIMGMAvMVSuiMTDQWmnfNr8ofp3+RqIxe3QuLcJLTylYaWzgD/LikcrKXz97BasBaiEdI1d0AR+WOaccjP2f+AH1KXV4ehRtEyZVcVanBuMZV21Uo8/MOJGMbNewXn4Kqqmv2F1XOjnG0uY8mMGPeUr74LndSgX3GZ6lbIlE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bmm2P7su; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455BPuHt030611;
	Wed, 5 Jun 2024 13:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=A5J5bZW4BjB3ZXe4CujwfLf8tIwsn9920kLDIbw8Rbc=;
 b=bmm2P7suK9W8melA/zJX0qtNopl1jn2DvtbwVAVib4p5mhvABF/sFJGxuTnjOyMNA+LL
 0efOqo3dZ270WXfklbqeGsgcdzO4lgs66MlMC4tMthfLmx0QPsQlL/CMPUPG9GRACrqc
 IojlTKnK98gX/rfARsFTrovnBhXu0FESBJ38BsnZ/3AVY8+04mKRUcVW8TVUoAR46OUX
 ieY2xFo/N0N1S62r/vcmop701AL10myIoRMPov5AbqHqYXuff+fPGz+SBMpXU3AeSRwg
 MgdkLtCTQxOUz0hs0cPHDh97Zk7Uv3wiGNmVYEx/TZ2VPlKa24lqYY2BHZbSf8GdjYxV ug== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjns38epy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:07:25 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455D7PU3023393;
	Wed, 5 Jun 2024 13:07:25 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjns38epr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:07:25 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455CYD4d008479;
	Wed, 5 Jun 2024 13:07:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec0ve8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:07:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455D7ITT51708310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 13:07:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89DC020043;
	Wed,  5 Jun 2024 13:07:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 752D420040;
	Wed,  5 Jun 2024 13:07:16 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 13:07:16 +0000 (GMT)
Subject: [PATCH v2 5/8] KVM: PPC: Book3S HV: Add one-reg interface for
 HASHKEYR register
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Jun 2024 13:07:15 +0000
Message-ID: <171759283170.1480.12904332463112769129.stgit@linux.ibm.com>
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
X-Proofpoint-GUID: Jqgrxh-IyGd-YLngvEAUm9H2ZZUUujr2
X-Proofpoint-ORIG-GUID: N0hpz9VkpdGrovlkSMgzJ_6CFcIoZN5V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=664 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050099

The patch adds a one-reg register identifier which can be used to
read and set the virtual HASHKEYR for the guest during enter/exit
with KVM_REG_PPC_HASHKEYR. The specific SPR KVM API documentation
too updated.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 Documentation/virt/kvm/api.rst      |    1 +
 arch/powerpc/include/asm/kvm_host.h |    1 +
 arch/powerpc/include/uapi/asm/kvm.h |    1 +
 arch/powerpc/kvm/book3s_hv.c        |    6 ++++++
 arch/powerpc/kvm/book3s_hv.h        |    1 +
 5 files changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 81077c654281..0c22cb4196d8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2439,6 +2439,7 @@ registers, find a list below:
   PPC     KVM_REG_PPC_PSSCR               64
   PPC     KVM_REG_PPC_DEC_EXPIRY          64
   PPC     KVM_REG_PPC_PTCR                64
+  PPC     KVM_REG_PPC_HASHKEYR            64
   PPC     KVM_REG_PPC_DAWR1               64
   PPC     KVM_REG_PPC_DAWRX1              64
   PPC     KVM_REG_PPC_DEXCR               64
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1e2fdcbecffd..a0cd9dbf534f 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -600,6 +600,7 @@ struct kvm_vcpu_arch {
 	ulong dawr1;
 	ulong dawrx1;
 	ulong dexcr;
+	ulong hashkeyr;
 	ulong ciabr;
 	ulong cfar;
 	ulong ppr;
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index fcb947f65667..23a0af739c78 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -646,6 +646,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
 #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
 #define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
+#define KVM_REG_PPC_HASHKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc7)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1294c6839d37..ccc9564c5a31 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2352,6 +2352,9 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 	case KVM_REG_PPC_DEXCR:
 		*val = get_reg_val(id, kvmppc_get_dexcr_hv(vcpu));
 		break;
+	case KVM_REG_PPC_HASHKEYR:
+		*val = get_reg_val(id, kvmppc_get_hashkeyr_hv(vcpu));
+		break;
 	case KVM_REG_PPC_CIABR:
 		*val = get_reg_val(id, kvmppc_get_ciabr_hv(vcpu));
 		break;
@@ -2598,6 +2601,9 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 	case KVM_REG_PPC_DEXCR:
 		kvmppc_set_dexcr_hv(vcpu, set_reg_val(id, *val));
 		break;
+	case KVM_REG_PPC_HASHKEYR:
+		kvmppc_set_hashkeyr_hv(vcpu, set_reg_val(id, *val));
+		break;
 	case KVM_REG_PPC_CIABR:
 		kvmppc_set_ciabr_hv(vcpu, set_reg_val(id, *val));
 		/* Don't allow setting breakpoints in hypervisor code */
diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
index 7b0fd282fe95..c073fdfa7dc4 100644
--- a/arch/powerpc/kvm/book3s_hv.h
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -117,6 +117,7 @@ KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawr1, 64, KVMPPC_GSID_DAWR1)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx0, 64, KVMPPC_GSID_DAWRX0)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx1, 64, KVMPPC_GSID_DAWRX1)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dexcr, 64, KVMPPC_GSID_DEXCR)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(hashkeyr, 64, KVMPPC_GSID_HASHKEYR)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ciabr, 64, KVMPPC_GSID_CIABR)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(wort, 64, KVMPPC_GSID_WORT)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ppr, 64, KVMPPC_GSID_PPR)



