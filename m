Return-Path: <kvm+bounces-6721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 478BD838859
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 08:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A61D7B246B3
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 07:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F1A55E73;
	Tue, 23 Jan 2024 07:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sZDQqx5I"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDCA55E5E;
	Tue, 23 Jan 2024 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705996504; cv=none; b=u9rkwv5NFsoLTEoGZwd9O1U++faPxoCWV9q9iC8rK9+Hw1lpl0X3dj1vPO/X207ts/DQw/BX3KcymcYkHdvZW+v5UXQfCNDkJ/5/q7eeBKeJDqAGXbBn7XwCFpPOTK9KG2nhubr/vTRy5kzAY6J60J+6ebOlooaoRRqzlMt1LyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705996504; c=relaxed/simple;
	bh=rG4IlkvUI98zN+9rP6/dFnbsvmYEZGuK7Zu5Ohzy8Hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtwa1se1qj9pIwVgyVpDBkgSe765XW44BnT5vKks+KNKAJ9vWCcAtTLOk+poibXZ/pVnust+nIJGvc/UkbX/EWF8w5ggxX+xgVw8A1Wol80zqmvNddpL8LrcL3LaECRzv8ZG9iEYe3elZhSljNaZdvWgvSdk5szMJk/AjSt7RTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sZDQqx5I; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40N6LJfO019564;
	Tue, 23 Jan 2024 07:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=ny7R+kElPrm261ozh2Fn0CGVqgiQor3Hw3T/bLpZKzw=;
 b=sZDQqx5IsNuEyj1XzrNPIMcjCPqW8/42kckY6tThr98FgOTQsO5WxouxdloHa/L6O8LH
 TtiYnrLLJUIg9a4Xb3cj95CRJiouQFNX5b+ePQV8O83mERwuKUkUY7YsRZk4IjpO2HD0
 hWYqyPm1hqdD/5j54KBajz2KWX02NbDuHo3wA973aCIj7I3JhoL26CuoCv/5FHOfl2+Q
 MjrX8YItAjBhHNh9rVrhlW97aO6CNaKjChi/S12fSf7AJYWk+2clFjExxXtVTmW3S7SH
 57Dnj1jgZWsfH9UOl04vDA8YcNou/Hsj+0gaDBHpsUtgEI/R82b4g4YH3VRmnxrbbWw5 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vt7aub94k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jan 2024 07:54:49 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40N7M1U3028447;
	Tue, 23 Jan 2024 07:54:49 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vt7aub944-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jan 2024 07:54:48 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40N6wmba025253;
	Tue, 23 Jan 2024 07:54:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vrtqk5evf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jan 2024 07:54:48 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40N7sjcB63832410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 07:54:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C53D20040;
	Tue, 23 Jan 2024 07:54:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F28920049;
	Tue, 23 Jan 2024 07:54:40 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.43.74.138])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 23 Jan 2024 07:54:40 +0000 (GMT)
Date: Tue, 23 Jan 2024 13:24:36 +0530
From: Gautam Menghani <Gautam.Menghani@linux.ibm.com>
To: Amit Machhiwal <amachhiw@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Amit Machhiwal <amit.machhiwal@ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due to
 empty 'arch_compat'
Message-ID: <ml6sjj7wxq2jah4skqbsrujwfytga7ignd56sgz6z6g3zcnysk@in7tt3hwjvxw>
References: <20240118095653.2588129-1-amachhiw@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118095653.2588129-1-amachhiw@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qYoXp4ZVQhYlQLgKQZkNuyYOQnQScGkJ
X-Proofpoint-GUID: 0Er9RsKa2iXAgt7hgYAq1EIEBGKEdHc5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_02,2024-01-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1011 adultscore=0 mlxscore=0 mlxlogscore=858 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230056

On Thu, Jan 18, 2024 at 03:26:53PM +0530, Amit Machhiwal wrote:
> Currently, rebooting a pseries nested qemu-kvm guest (L2) results in
> below error as L1 qemu sends PVR value 'arch_compat' == 0 via
> ppc_set_compat ioctl. This triggers a condition failure in
> kvmppc_set_arch_compat() resulting in an EINVAL.
> 
> qemu-system-ppc64: Unable to set CPU compatibility mode in KVM: Invalid
> 
> This patch updates kvmppc_set_arch_compat() to use the host PVR value if
> 'compat_pvr' == 0 indicating that qemu doesn't want to enforce any
> specific PVR compat mode.
> 
> Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c          |  2 +-
>  arch/powerpc/kvm/book3s_hv_nestedv2.c | 12 ++++++++++--
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 1ed6ec140701..9573d7f4764a 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -439,7 +439,7 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
>  	if (guest_pcr_bit > host_pcr_bit)
>  		return -EINVAL;
>  
> -	if (kvmhv_on_pseries() && kvmhv_is_nestedv2()) {
> +	if (kvmhv_on_pseries() && kvmhv_is_nestedv2() && arch_compat) {
>  		if (!(cap & nested_capabilities))
>  			return -EINVAL;
>  	}
> diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> index fd3c4f2d9480..069a1fcfd782 100644
> --- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
> +++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> @@ -138,6 +138,7 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
>  	vector128 v;
>  	int rc, i;
>  	u16 iden;
> +	u32 arch_compat = 0;
>  
>  	vcpu = gsm->data;
>  
> @@ -347,8 +348,15 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
>  			break;
>  		}
>  		case KVMPPC_GSID_LOGICAL_PVR:
> -			rc = kvmppc_gse_put_u32(gsb, iden,
> -						vcpu->arch.vcore->arch_compat);
> +			if (!vcpu->arch.vcore->arch_compat) {
> +				if (cpu_has_feature(CPU_FTR_ARCH_31))
> +					arch_compat = PVR_ARCH_31;
> +				else if (cpu_has_feature(CPU_FTR_ARCH_300))
> +					arch_compat = PVR_ARCH_300;
> +			} else {
> +				arch_compat = vcpu->arch.vcore->arch_compat;
> +			}
> +			rc = kvmppc_gse_put_u32(gsb, iden, arch_compat);
>  			break;
>  		}
>  
> -- 
> 2.43.0
> 

I tested this patch on pseries Power 10  machine with KVM support : 
Without this patch, with the latest mainline as host,the kvm guest on 
pseries/powervm fails to reboot and with this patch, reboot works fine.

Tested-by: Gautam Menghani <gautam@linux.ibm.com>

