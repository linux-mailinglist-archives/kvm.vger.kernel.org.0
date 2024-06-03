Return-Path: <kvm+bounces-18626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6008D80B3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C62AB2816A2
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53700A21;
	Mon,  3 Jun 2024 11:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y9N3vVSk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95EC2031D;
	Mon,  3 Jun 2024 11:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717413306; cv=none; b=sqKOy4Bbqil8JbMhn0l8BhWMKNhC0ld1ZG2AqcOyDEb8gEkJNIhYUS7z3hcIFZVlECtcNwRKxaVt6cZSfRkJXl6WX72/b00fcRWydOr8Jpu/ZLUPNh/lN4PPrOvPvpOcx9Zo1Qxl07aUygfl9DAHm/l3EBcFUGyJSHatKUQuiOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717413306; c=relaxed/simple;
	bh=ZFXR8m14kYvbVIl2KlyvnbiiBMx8mQpyawYBOo9d/aE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G2Ayni545ZCgOO4KMzzggkoi7nInD0Bia9q2emkCFuQA580O4an4AFPJPB0kw/lrhZAT1aXtI/bn0x3eIhksBGSfvPVGeHyZFLmRgO8byII2sRCwdUBRv16X4v35p3/dvXTtoDs5Ye+GsCAE6fBeaVccojuXq1AA7tRy+FLKfDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y9N3vVSk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453APoTq003631;
	Mon, 3 Jun 2024 11:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=OMYFUIm6w8L9hrflseDvr2e7ZieoDUoZJEftnc/pLfg=;
 b=Y9N3vVSk1iEPnn99N3F+v37zOGhApIKBCQGru8PJ+NERwHR/5nBs6LZLbI9wXDoLcztg
 JFqH7Utg3GvL7T26eTfmoy7Y35XYw0Q5F/09XcaQxdzcMm5coNJ4829iAF6ZSRF9yFrr
 Jc0guPDuSgd7QYmysMZ0gByIkH8iQiEw5dmB8127WURpCAArrc9gVEnYgPrRcyC4mHcz
 Wt+ZqWgN99LmGodYhpe41XSZgU+esFf/1jDw+3h43EUBD5rhRM19k80fc15iElvj9R7/
 CDQC+/tHBRkCTa2MrbxwX0scJS80DOZm2Uooz8Q0eVqmyTuGdRFQTeJzbd60uBd1lvRJ ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhadh0bbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:54 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453BErbr027863;
	Mon, 3 Jun 2024 11:14:53 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhadh0bbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:53 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45399DTO031147;
	Mon, 3 Jun 2024 11:14:53 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeyp7fce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453BElP534603754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 11:14:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4069F20067;
	Mon,  3 Jun 2024 11:14:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 308F42004E;
	Mon,  3 Jun 2024 11:14:45 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 11:14:45 +0000 (GMT)
Subject: [PATCH 4/6] KVM: PPC: Book3S HV: Add one-reg interface for DEXCR
 register
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2024 11:14:44 +0000
Message-ID: <171741327891.6631.10339033341166150910.stgit@linux.ibm.com>
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
X-Proofpoint-GUID: 879TKBnXgQhaFYIU84f2SOq75_EMCTg_
X-Proofpoint-ORIG-GUID: qxq_pOFfdTbTw6Aa2193Vw_aayTuzrgk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_07,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=655 lowpriorityscore=0 phishscore=0
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406030094

The patch adds a one-reg register identifier which can be used to
read and set the DEXCR for the guest during enter/exit with
KVM_REG_PPC_DEXCR. The specific SPR KVM API documentation
too updated.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst            |    1 +
 arch/powerpc/include/uapi/asm/kvm.h       |    1 +
 arch/powerpc/kvm/book3s_hv.c              |    6 ++++++
 tools/arch/powerpc/include/uapi/asm/kvm.h |    1 +
 4 files changed, 9 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a71d91978d9e..81077c654281 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2441,6 +2441,7 @@ registers, find a list below:
   PPC     KVM_REG_PPC_PTCR                64
   PPC     KVM_REG_PPC_DAWR1               64
   PPC     KVM_REG_PPC_DAWRX1              64
+  PPC     KVM_REG_PPC_DEXCR               64
   PPC     KVM_REG_PPC_TM_GPR0             64
   ...
   PPC     KVM_REG_PPC_TM_GPR31            64
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index 1691297a766a..fcb947f65667 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -645,6 +645,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
 #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
 #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
+#define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b576781d58d5..1294c6839d37 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2349,6 +2349,9 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 	case KVM_REG_PPC_DAWRX1:
 		*val = get_reg_val(id, kvmppc_get_dawrx1_hv(vcpu));
 		break;
+	case KVM_REG_PPC_DEXCR:
+		*val = get_reg_val(id, kvmppc_get_dexcr_hv(vcpu));
+		break;
 	case KVM_REG_PPC_CIABR:
 		*val = get_reg_val(id, kvmppc_get_ciabr_hv(vcpu));
 		break;
@@ -2592,6 +2595,9 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 	case KVM_REG_PPC_DAWRX1:
 		kvmppc_set_dawrx1_hv(vcpu, set_reg_val(id, *val) & ~DAWRX_HYP);
 		break;
+	case KVM_REG_PPC_DEXCR:
+		kvmppc_set_dexcr_hv(vcpu, set_reg_val(id, *val));
+		break;
 	case KVM_REG_PPC_CIABR:
 		kvmppc_set_ciabr_hv(vcpu, set_reg_val(id, *val));
 		/* Don't allow setting breakpoints in hypervisor code */
diff --git a/tools/arch/powerpc/include/uapi/asm/kvm.h b/tools/arch/powerpc/include/uapi/asm/kvm.h
index 1691297a766a..fcb947f65667 100644
--- a/tools/arch/powerpc/include/uapi/asm/kvm.h
+++ b/tools/arch/powerpc/include/uapi/asm/kvm.h
@@ -645,6 +645,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
 #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
 #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
+#define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs



