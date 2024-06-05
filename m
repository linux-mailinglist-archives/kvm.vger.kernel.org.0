Return-Path: <kvm+bounces-18905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7948FCF6D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9FEC286C60
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BD419885E;
	Wed,  5 Jun 2024 13:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MtLs25xQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE5C18F2DB;
	Wed,  5 Jun 2024 13:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717592871; cv=none; b=d5nEFVJYSNlYtglWveDod4vJu9tFdH855rwHBjgCqP6+zXNRauo7ajy6n0pBXHiRwKAcaLrRwzp5N4X+mKZjy6XRa3ZvQwe6pMQsqM2UavBCV+yS6NMkl8VPaWBPeNrI02u5IIGIWREMR7JDH8/FC2b1z/QnQEbtJlmFrVuvSbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717592871; c=relaxed/simple;
	bh=kg589HsNXVwnn73Dkl3YjEFG3YeS6v4bJz5uPV7E16Q=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAEOAlZdPVa23fzZ8+yaDKilUveXFGuW6eOvxdUARmV8FC7HDZdILnjrotTEEliP/6YQ5g/D66mrq8ZXmwFQKTgv/6a97jyBT2o3uNCyVXintPNFq7l7ShjzjqVx3+NEXtBvs/tfWDlrgSZ2Y+/JUS6WdO3Og6NecVggTDwsw+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MtLs25xQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455CqBtM020138;
	Wed, 5 Jun 2024 13:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=Og7hgkUMK5aGoTYz1mgIVVup+Jp3jE3tNxDdWnrvsZ8=;
 b=MtLs25xQv1+T5FhrUKG1QAtXkgOnFZ4noWqYSWOYD3wWERx1s0msoaG5ieJCsBNf8Cz+
 lYYTrqYVeePcsv1JGjE0weIc36Bfn1pVeEv78UHDFvitkTW9VzokNoO4W4ZzAr227Wgh
 etJ8LZsyfJ2vmGoWks9Pg17ZkKy6wyleFmagPjQvjQPns6cl8IZ3DikbSMZ5PS98+kR8
 gUtqmhVxTDlWFjgEvQiqpZrGnVIvx36M1vh1CWLDtK4RlzPIhYsNFM3mnLtHy76IASl5
 8AilFcsnclRPGwLO2F6GWOxq9F777069a6YmDNezM5QKmTjWbaBd+T2H1Xe88ymX4f/V 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrda81y4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:07:38 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455D7biI015061;
	Wed, 5 Jun 2024 13:07:37 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrda81xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:07:37 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4559keKW026899;
	Wed, 5 Jun 2024 13:07:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygffn440w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:07:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455D7UWM46137738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 13:07:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 406372004B;
	Wed,  5 Jun 2024 13:07:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 503E72004E;
	Wed,  5 Jun 2024 13:07:28 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 13:07:28 +0000 (GMT)
Subject: [PATCH v2 6/8] KVM: PPC: Book3S HV nestedv2: Keep nested guest
 HASHKEYR in sync
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Jun 2024 13:07:27 +0000
Message-ID: <171759284380.1480.15665015792935543933.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: NiS5zZF4TJNzBxO5jFG0fFBcTsmJWnM1
X-Proofpoint-GUID: jQ7PGeKoWEb3bR3rWL_2Zgk7ECyTxpDE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=899 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050099

The nestedv2 APIs has the guest state element defined for HASHKEYR for
the save-restore with L0. However, its ignored in the code.

The patch takes care of this for the HASHKEYR GSID.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nestedv2.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
index d207a6d936ff..bbff933f2ccc 100644
--- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
+++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
@@ -196,6 +196,9 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
 		case KVMPPC_GSID_DEXCR:
 			rc = kvmppc_gse_put_u64(gsb, iden, vcpu->arch.dexcr);
 			break;
+		case KVMPPC_GSID_HASHKEYR:
+			rc = kvmppc_gse_put_u64(gsb, iden, vcpu->arch.hashkeyr);
+			break;
 		case KVMPPC_GSID_CIABR:
 			rc = kvmppc_gse_put_u64(gsb, iden, vcpu->arch.ciabr);
 			break;
@@ -447,6 +450,9 @@ static int gs_msg_ops_vcpu_refresh_info(struct kvmppc_gs_msg *gsm,
 		case KVMPPC_GSID_DEXCR:
 			vcpu->arch.dexcr = kvmppc_gse_get_u64(gse);
 			break;
+		case KVMPPC_GSID_HASHKEYR:
+			vcpu->arch.hashkeyr = kvmppc_gse_get_u64(gse);
+			break;
 		case KVMPPC_GSID_CIABR:
 			vcpu->arch.ciabr = kvmppc_gse_get_u64(gse);
 			break;



