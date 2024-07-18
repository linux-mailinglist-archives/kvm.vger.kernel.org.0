Return-Path: <kvm+bounces-21812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD8869346F9
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 05:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCF481C22E72
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 03:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9308E39FE5;
	Thu, 18 Jul 2024 03:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IWwzCIAI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433542AA6;
	Thu, 18 Jul 2024 03:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721274700; cv=none; b=klWhZigVL9Pw66SlbYxGGI/uw7ON0/e+wA9Ex0x8W0kloi8YIgpufWUo4YddoqXxKL2CziGVzoMrGvTy69242R3P0EYf5cVk9FaaEMJER8t/v+3eqY8vBYfn/YH71uGXHPwadvAvthl0a2LGHSi2UyPTw793G/i+whhJ/8c7q/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721274700; c=relaxed/simple;
	bh=X2VthKODx/NH7qSkxS3leRmp7ffXTvTIE336tbI0ExI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T62PsuPNdoR1lCv3iJ3IP6vLDjSw1Qti4gUobYI8JQu6lw64tBBXaNWX49CH2C7bahP8eSG1oxXYhFPF0m1zqeM9dxifXHJk3htyNGWZlgvOVCJ7DPAvO4XBjajKKFz/426bWCQT2MqqMgw0WIw2T6sIINXlo+3EcFB9CZ7AsLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IWwzCIAI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46I3QB0Z025697;
	Thu, 18 Jul 2024 03:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=8
	NbKhRYi5LieM0LCaj65EY/Do3XbJKVEjkqjluqRAvk=; b=IWwzCIAIjIXdJmAT+
	VoowT3XnbhO0XTTOVwEosK7VLf2W/KiNJ14T3qA8HsuMOFlmT2kH/UfXhfa1RhH9
	iy/SaSug1SPYGrtKTE2tPKfxOCw6ZO46rgTJTEpvtN7BWtgl3PQg9+zFZAVCq0f1
	LwhLQGWwzpDwMQx8Ttk3wQ/vse9l/H19RECkv4fYbgVUOJYhwCNYBhHLvUN2Isys
	6LarrILIc90P2EIGdT+/tkEPndUq6lTitblbU7up/hAdlkRdVvQj5SB97nMArmFu
	vLaAiBoKOyhx/OxTrFeYsRbL4mzXxULwIl4h8/ymNeyBxgxL4KBkhrpOmRSFjxrF
	7MOWA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40esuw05td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 03:51:22 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46I3pM9f031376;
	Thu, 18 Jul 2024 03:51:22 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40esuw05tb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 03:51:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46I16IjA000509;
	Thu, 18 Jul 2024 03:51:21 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40dwkk7muw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 03:51:21 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46I3pIIP3211898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 03:51:20 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 118A258062;
	Thu, 18 Jul 2024 03:51:18 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 141465803F;
	Thu, 18 Jul 2024 03:51:15 +0000 (GMT)
Received: from [9.204.206.229] (unknown [9.204.206.229])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Jul 2024 03:51:14 +0000 (GMT)
Message-ID: <d6edb26f-f19e-4296-8fea-07961ce24960@linux.ibm.com>
Date: Thu, 18 Jul 2024 09:21:13 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Refactor HFSCR emulation for KVM
 guests
To: Gautam Menghani <gautam@linux.ibm.com>, mpe@ellerman.id.au,
        npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20240716115206.70210-1-gautam@linux.ibm.com>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <20240716115206.70210-1-gautam@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l9RXJRyHS54SPijNIe1NeuLBWqfK12ms
X-Proofpoint-ORIG-GUID: wndIF21AupoinKr27uYuMGpXkcDVNJT3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-17_19,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407180020


On 7/16/24 5:22 PM, Gautam Menghani wrote:
> Refactor HFSCR emulation for KVM guests when they exit out with
> H_FAC_UNAVAIL to use a switch case instead of checking all "cause"
> values, since the "cause" values are mutually exclusive; and this is
> better expressed with a switch case.
>
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
> V1 -> V2:
> 1. Reword changelog to point out mutual exclusivity of HFSCR bits.
> 2. Reword commit message to match other commits in book3s_hv.c


Minor: I guess you mean "Reword the subject line"

Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>



>
>   arch/powerpc/kvm/book3s_hv.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index daaf7faf21a5..50797b0611a2 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1922,14 +1922,22 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
>   
>   		r = EMULATE_FAIL;
>   		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
> -			if (cause == FSCR_MSGP_LG)
> +			switch (cause) {
> +			case FSCR_MSGP_LG:
>   				r = kvmppc_emulate_doorbell_instr(vcpu);
> -			if (cause == FSCR_PM_LG)
> +				break;
> +			case FSCR_PM_LG:
>   				r = kvmppc_pmu_unavailable(vcpu);
> -			if (cause == FSCR_EBB_LG)
> +				break;
> +			case FSCR_EBB_LG:
>   				r = kvmppc_ebb_unavailable(vcpu);
> -			if (cause == FSCR_TM_LG)
> +				break;
> +			case FSCR_TM_LG:
>   				r = kvmppc_tm_unavailable(vcpu);
> +				break;
> +			default:
> +				break;
> +			}
>   		}
>   		if (r == EMULATE_FAIL) {
>   			kvmppc_core_queue_program(vcpu, SRR1_PROGILL |

