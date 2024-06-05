Return-Path: <kvm+bounces-18909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 751768FCF85
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE0581F245F8
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7887B193081;
	Wed,  5 Jun 2024 13:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JX5nIzzx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD2819D882;
	Wed,  5 Jun 2024 13:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717593281; cv=none; b=T01My87usW90LUr0mvY0bWr+VepGJjuQ5bn3hlvQa1QRpg3PmeA+9ZHU8XxnhST6cI5/JTyI1HtU+L3h6ylJlnsIGCLnpzrjKsOHlEYRuZggJgleBKTueuniufqx5VdOq6sWdrVZXHXM0r2F2VUfidFj8SEUuWAwB7EL4/hCxEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717593281; c=relaxed/simple;
	bh=5pdMw9c8CM5TOI103CE+TSpoykEhfXjwqMN8A21B6a4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oWkGPS3guTXw+6jGJOlc7poh3ek/ginZPqqSA9QJuQ9ErJnqSfP6ga6mePel3mjBy2X5adxQLcSr120TSZ3cJl7wKxHmdNZGUJJcU6wSd2Ry4xfXV3qCxDd5enGQmaxDWiQke4e47QKSIRGV+xUKWLz4ioYpNupnhvs0OH3euTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JX5nIzzx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455CvKUE032704;
	Wed, 5 Jun 2024 13:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=Xga+hzafZul/I4cN9R3CYrFOSDKXjPSht/bEB2nEBOE=;
 b=JX5nIzzxuaqksWll/roMxk+eS4fzUPPGCWLkO2BAtlEwElCqMhrKJwUQRiQbPZ6XPid+
 hNRZoEY0BF1gv+A0WIEu8i7nRMzr/VputdSHrJJU3KTuw4Nm3qIqk5RDGBbanF68JAII
 i9JazUU52yiH1f87FQrHEUo1XRagEcDhhrProA4jBSM6MVEHlA1oIqQU7IPqp913LFMN
 0XEu4jk7MBZrhv7f5mi8j06svuHb6ZopBo3wsqq/gLp3VdhH1vuCN9YHYQCCXKDzBgzt
 DCFjl5qLimPCQoPWNidShB4OzHWcrjvQodozgrkZWK/UHTdu1qJZvCu8GbuiEQNiBMwC 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrfn81pd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:14:29 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455DET4f030325;
	Wed, 5 Jun 2024 13:14:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrfn81p7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:14:29 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455B68HB022835;
	Wed, 5 Jun 2024 13:06:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ygg6mbxte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:06:50 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455D6jsS13107690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 13:06:47 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55B922004E;
	Wed,  5 Jun 2024 13:06:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6118F2004B;
	Wed,  5 Jun 2024 13:06:43 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 13:06:43 +0000 (GMT)
Subject: [PATCH v2 3/8] KVM: PPC: Book3S HV: Add one-reg interface for DEXCR
 register
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Jun 2024 13:06:42 +0000
Message-ID: <171759279613.1480.12873911783530175699.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: v-NVf2zAtbNeLeCUt5Oh3yizY-m3foJM
X-Proofpoint-GUID: sXHXdPE-CxedLgFxffR8h3aa_-EjiWgT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=655
 mlxscore=0 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050100

The patch adds a one-reg register identifier which can be used to
read and set the DEXCR for the guest during enter/exit with
KVM_REG_PPC_DEXCR. The specific SPR KVM API documentation
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
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 8abac532146e..1e2fdcbecffd 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -599,6 +599,7 @@ struct kvm_vcpu_arch {
 	ulong dawrx0;
 	ulong dawr1;
 	ulong dawrx1;
+	ulong dexcr;
 	ulong ciabr;
 	ulong cfar;
 	ulong ppr;
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
diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
index 47b2c815641e..7b0fd282fe95 100644
--- a/arch/powerpc/kvm/book3s_hv.h
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -116,6 +116,7 @@ KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawr0, 64, KVMPPC_GSID_DAWR0)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawr1, 64, KVMPPC_GSID_DAWR1)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx0, 64, KVMPPC_GSID_DAWRX0)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx1, 64, KVMPPC_GSID_DAWRX1)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dexcr, 64, KVMPPC_GSID_DEXCR)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ciabr, 64, KVMPPC_GSID_CIABR)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(wort, 64, KVMPPC_GSID_WORT)
 KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ppr, 64, KVMPPC_GSID_PPR)



