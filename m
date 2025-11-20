Return-Path: <kvm+bounces-63831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC7EC739D2
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:05:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 080A24E7D11
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 11:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4CD32F777;
	Thu, 20 Nov 2025 11:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LjhLs1KQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC43301719;
	Thu, 20 Nov 2025 11:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763636589; cv=none; b=OF04whESbTcXMQft46bP8YLpKT9+u4ERDYowvhAFwnraCT4cVcBA+964GQaGz7tTthyi+FTFrOwRpPbTtNJoOoJ732isvbsuo2OYLSyFR+Iq96l5MbXuAROZGHzEKj8nh0R6j1wAivbmtFf3iEnCKYhPEU3Vc41LYwqRwfLCM5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763636589; c=relaxed/simple;
	bh=6Ypco4Dos2O+Wm45cvQnHUqu30OQCMGqt8/0KIodbno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fL25VjNwuBmx4koDVcAEITIlTXyVUH8n0wQzM3ybukWfk04yTCnPlaqEmnum/QnhrfviqkkfZEpVM/yndnw9DP/WP+WkC7X2fHLscKaOqjomvVCTOXGj+PelTfXFqkPSHRdCe7Y+8tAcvxjh5z/xzqUC8ivrQpXNNnPbyMUj+dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LjhLs1KQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJLkqxd021518;
	Thu, 20 Nov 2025 11:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=uvgObM
	lHfwTk8sSxdw2XJe30OxCETzmffZtP8yfETrA=; b=LjhLs1KQPLdmQ8HC+gY+Y9
	9Uh8j+5TeDCJfeyXQecQewQtYYyRODb9UUXtgDHXGExpG6LG2zNAIDVhwDi1HBBt
	6DDieGTebGpZn46aNGFN4RjYYx008fpvEpj69RYCUFSK6xSY4luZZ0/iG1j1qFSH
	MRComfTT/DV3Uck9vvRni4RxQLI0J75nz7a7P6PU5H5aamRZpoLkxS393pvSiE7Q
	OYQVJi/lDNUw7tRGB0tI6Vn/1C5VMSNGmsdOgJoA7FBTvR42Gk9zQBO21tmxW7qb
	r6ruFlfwiM56GAgydM/zfMaRkEOC9fszmZ0brix+lxikk2Y90a5JIxgWhT84bScg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjwdyaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 11:02:56 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKARkaq006967;
	Thu, 20 Nov 2025 11:02:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af62jns86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 11:02:55 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKB2qS030015794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 11:02:52 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11C6F2004B;
	Thu, 20 Nov 2025 11:02:52 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F4B020040;
	Thu, 20 Nov 2025 11:02:50 +0000 (GMT)
Received: from [9.111.95.204] (unknown [9.111.95.204])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 11:02:49 +0000 (GMT)
Message-ID: <2087b6b4-34b4-4509-9cae-bfe719d99992@linux.ibm.com>
Date: Thu, 20 Nov 2025 12:02:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 10/11] KVM: s390: Add VSIE shadow configuration
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-10-9e53a3618c8c@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20251110-vsieie-v2-10-9e53a3618c8c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=691ef560 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=XD9FR2GFIzR7_RmDYLQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX7tOkxTLD53Ck
 4LRJ1Tnypd9O7ALvHPp9KbXvQ2JvNKqM/uFibGNshES7YpZa1tbUOP69391lrD5J3JS4J4UwXHB
 RWJX1y2Grx0TyveGp9BHXWYXAQrDcIP0gs0wYvn9M2qXN5YUVPom8A1XI/zIPXMg2KtwloSKWko
 EGaMJph2T6QJpS19436KM25otGbC2LisX84pL7WAJYTH71utnitpO5qTAqID6QbdqxzpFgTnviv
 zs9n/bGJ01i7P7SUbrEV86P9wxj55q9B9RSJyb1/qvpeWmkfZhmej5KZ6xTdjZFRL8Qyhq/Rc87
 chz9ehnBMYQzgedPGW+6YeMQS0WS+ok9hc3b3LOq+WRMpOzgoY23ymEROdF4gAE9SP6FJ8ILVct
 YX/FHHUibSU2q9Kw8SvQa6CIwpK+TA==
X-Proofpoint-GUID: _O7NC9J12CxsETds7IDta9I4tySF3Jpc
X-Proofpoint-ORIG-GUID: _O7NC9J12CxsETds7IDta9I4tySF3Jpc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On 11/10/25 18:16, Christoph Schlameuss wrote:
> Introduce two new module parameters allowing to keep more shadow
> structures
> 
> * vsie_shadow_scb_max
>    Override the maximum number of VSIE control blocks / vsie_pages to
>    shadow in guest-1. KVM will use the maximum of the current number of
>    vCPUs and a maximum of 256 or this value if it is lower.
>    This is the number of guest-3 control blocks / CPUs to keep shadowed
>    to minimize the repeated shadowing effort.

KVM will either use this value or the number of current VCPUs. Either 
way the number will be capped to 256.

> 
> * vsie_shadow_sca_max
>    Override the maximum number of VSIE system control areas to
>    shadow in guest-1. KVM will use a minimum of the current number of
>    vCPUs and a maximum of 256 or this value if it is lower.
>    This is the number of guest-3 system control areas / VMs to keep
>    shadowed to minimize repeated shadowing effort.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Except for the current implementation with arrays, nothing is limiting 
us from going over 256 in the future by changing the code. I'm not sure 
if I ever want to see such an environment in practice though.

>   arch/s390/kvm/vsie.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index b69ef763b55296875522f2e63169446b5e2d5053..cd114df5e119bd289d14037d1f1c5bfe148cf5c7 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -98,9 +98,19 @@ struct vsie_sca {
>   	struct vsie_page	*pages[KVM_S390_MAX_VSIE_VCPUS];
>   };
>   
> +/* maximum vsie shadow scb */
> +unsigned int vsie_shadow_scb_max;

Don't we need to initialize the variables or mark them static so they are 0?

> +module_param(vsie_shadow_scb_max, uint, 0644);
> +MODULE_PARM_DESC(vsie_shadow_scb_max, "Maximum number of VSIE shadow control blocks to keep. Values smaller number vcpus uses number of vcpus; maximum 256");
> +
> +/* maximum vsie shadow sca */
> +unsigned int vsie_shadow_sca_max;
> +module_param(vsie_shadow_sca_max, uint, 0644);
> +MODULE_PARM_DESC(vsie_shadow_sca_max, "Maximum number of VSIE shadow system control areas to keep. Values smaller number of vcpus uses number of vcpus; 0 to disable sca shadowing; maximum 256");
> +
>   static inline bool use_vsie_sigpif(struct kvm *kvm)
>   {
> -	return kvm->arch.use_vsie_sigpif;
> +	return kvm->arch.use_vsie_sigpif && vsie_shadow_sca_max;

This functions as the enablement of vsie_sigpif?
Is there a reason why we don't want this enabled per default?

>   }
>   
>   static inline bool use_vsie_sigpif_for(struct kvm *kvm, struct vsie_page *vsie_page)
> @@ -907,7 +917,8 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vs
>   	 * We want at least #online_vcpus shadows, so every VCPU can execute the
>   	 * VSIE in parallel. (Worst case all single core VMs.)
>   	 */
> -	max_sca = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
> +	max_sca = MIN(MAX(atomic_read(&kvm->online_vcpus), vsie_shadow_sca_max),
> +		      KVM_S390_MAX_VSIE_VCPUS);
>   	if (kvm->arch.vsie.sca_count < max_sca) {
>   		BUILD_BUG_ON(sizeof(struct vsie_sca) > PAGE_SIZE);
>   		sca_new = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -1782,7 +1793,8 @@ static struct vsie_page *get_vsie_page(struct kvm_vcpu *vcpu, unsigned long addr
>   		put_vsie_page(vsie_page);
>   	}
>   
> -	max_vsie_page = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
> +	max_vsie_page = MIN(MAX(atomic_read(&kvm->online_vcpus), vsie_shadow_scb_max),
> +			    KVM_S390_MAX_VSIE_VCPUS);
>   
>   	/* allocate new vsie_page - we will likely need it */
>   	if (addr || kvm->arch.vsie.page_count < max_vsie_page) {
> 


