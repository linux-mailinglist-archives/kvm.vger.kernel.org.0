Return-Path: <kvm+bounces-18625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AD338D80B0
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A173BB2584B
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DB184D27;
	Mon,  3 Jun 2024 11:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cUdyOBoe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556384A23;
	Mon,  3 Jun 2024 11:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717413295; cv=none; b=JB7yN447QyvWG2svxlSgaBTMORobZYHXdjdLF/v8HBWCKI5+mr39imgIcCGhB2MiZ/2txQ2zrNNI/16YLxXX2vYr2YL42wrVOawWulheATQo3NlgN2IwTBfp598lZ04UIioZCnG67EW6D9kPezSSbAwlpxrkls9+ufVpJ0iHSfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717413295; c=relaxed/simple;
	bh=pQBQkAKzkT+Buefo99O+RrWXH4YfiysO6oObtbXrS20=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CdAguxKsuYLdoi/hRuIyp7QHfHfbjGqdl0gkgTTYl1lkLCT1uOe9Zyeo6N9lIpcFcB61nGUgIn4aTrdJzjwQa4JU8LeoAogVglcxz6rMPxSIZBSUgVVFExChE7x5FrYrPUmAprFKi4blv5NZWAIEwpS+2KnzUvVlhvucO8DbIbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cUdyOBoe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453BBCsS020633;
	Mon, 3 Jun 2024 11:14:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=FLo9ijcfDE9qph2G96Ru6rXYR6O6qbOufXPAJVeiFdQ=;
 b=cUdyOBoe2JFxYmiH+fNrNGygJNXdgS9XDYJj6ELWQ7V04oCiKumy5veK+BCIaDanjrBl
 mbIrJr4Lfa+sCjBO4XDYcEROw6UVvUiTkPblJRcLULFMd2zRANQGrX2sCV/+bTd5eTXK
 PTD4gD1yuOcu8Ak/CAvmHFuTik+w5hoIJnh5NPg+SAP5svIy0rPhzFT3KL6Q9B6yGuYc
 5VDxGxq7dprPcCE59lq5j2P3ms42V58S9CgyS5ONmAT3FhnFoEuFrDvLsaDsZCSmNHEs
 H4hW2Y2+508YZ0h7iBy/l/WbUzRiqp9LMSzJqVhObPIJFSVB1NHpCbwf2Y23g+5l+4f3 JA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhadh0bb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:40 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453BEep6027458;
	Mon, 3 Jun 2024 11:14:40 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhadh0bb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:40 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4538XHl2008501;
	Mon, 3 Jun 2024 11:14:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec0fndp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453BEXOr46399828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 11:14:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B30CC20063;
	Mon,  3 Jun 2024 11:14:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC3F32004E;
	Mon,  3 Jun 2024 11:14:31 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 11:14:31 +0000 (GMT)
Subject: [PATCH 3/6] KVM: PPC: Book3S HV nestedv2: Keep nested guest DEXCR in
 sync
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2024 11:14:31 +0000
Message-ID: <171741326679.6631.5332298610543769487.stgit@linux.ibm.com>
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
X-Proofpoint-GUID: OQjbPXLNv_X-59ZS1fr02P3KAhwHSyVm
X-Proofpoint-ORIG-GUID: h1XlCMRvDjI1MKkjK_LIQx5ML529FP1O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_07,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=833 lowpriorityscore=0 phishscore=0
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406030094

The nestedv2 APIs has the guest state element defined for DEXCR
for the save-restore with L0. However, its ignored in the code.

The patch takes care of this for the DEXCR GSID.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_host.h   |    1 +
 arch/powerpc/kvm/book3s_hv.h          |    1 +
 arch/powerpc/kvm/book3s_hv_nestedv2.c |    6 ++++++
 3 files changed, 8 insertions(+)

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
diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
index 1091f7a83b25..d207a6d936ff 100644
--- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
+++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
@@ -193,6 +193,9 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
 		case KVMPPC_GSID_DAWRX1:
 			rc = kvmppc_gse_put_u32(gsb, iden, vcpu->arch.dawrx1);
 			break;
+		case KVMPPC_GSID_DEXCR:
+			rc = kvmppc_gse_put_u64(gsb, iden, vcpu->arch.dexcr);
+			break;
 		case KVMPPC_GSID_CIABR:
 			rc = kvmppc_gse_put_u64(gsb, iden, vcpu->arch.ciabr);
 			break;
@@ -441,6 +444,9 @@ static int gs_msg_ops_vcpu_refresh_info(struct kvmppc_gs_msg *gsm,
 		case KVMPPC_GSID_DAWRX1:
 			vcpu->arch.dawrx1 = kvmppc_gse_get_u32(gse);
 			break;
+		case KVMPPC_GSID_DEXCR:
+			vcpu->arch.dexcr = kvmppc_gse_get_u64(gse);
+			break;
 		case KVMPPC_GSID_CIABR:
 			vcpu->arch.ciabr = kvmppc_gse_get_u64(gse);
 			break;



