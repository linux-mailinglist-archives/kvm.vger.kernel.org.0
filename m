Return-Path: <kvm+bounces-47704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79693AC3DE9
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 12:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48084175A36
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 10:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444331F4706;
	Mon, 26 May 2025 10:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="arg5mIRZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3DB41C64;
	Mon, 26 May 2025 10:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748255772; cv=none; b=fVQeLUdHQ4bQ2Q+hhiaV4QV1vsLykuxSovJCkIdC3Dkv6BhIm2ajSW4aAc04RvBdjzUKsQJfOJBGRb+ZADel7GIkA4fFJ8Q2e8YUDYJ2VtGSQgT7IsJiyS/6ywLV3pcRhP11TWvcK4WZi6Z+c5g7FhuZUWV0vd62UpAqi3fXCeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748255772; c=relaxed/simple;
	bh=v2ot0JcQJgQ2MawloZld+SCZWxXEa00cSsDt2/xFgEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LV1BlPTPsre3cVlBPqYgEXZ+q+AwgIMMZsroJpSe+BkNQGez8rUr/UW+zguKSEkYceUUo00IpKJhQODh5i1Cm8trT2qDtWo6wdSNDL7cpSEXZSz6uVHCwjcO9D9acIrl5Cqz7bK+JSS8PVBAOu8d5SpgxsFQWwFp7U/JYLtti/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=arg5mIRZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54QA2PaN003346;
	Mon, 26 May 2025 10:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WqoxIf
	QWMfow3ZCWy7O0757ylIHWV6IVOxUQikGz9Ec=; b=arg5mIRZBDr/kDm+ncDq9r
	uMWXY2+bNwHUYgGD1hTVIPSjEkBYuzPc43sqrAhpoKE0oAWNaAj8ghf6GxZZ+b/0
	in+9Qf4ixx3kftr4ExmSIGTPc3SCMZWk2GFbSt9xcDY0BseJjQnDdrxXUe86HaH5
	eHNaeuBCrZsmbLE4lOQSrWthHR13EjCBwZCMMbRk7CO+6dJ64iu3kBnjARKNebGT
	UVnVmJTKPv3Ufvj+oI970NK+woPPCE7a3zSonLs6/80AqctEy0UVgpwL9kWi0ItA
	cyYu6cfjbooNPFKjNJzYzpHw0UB10VZ1ul9A7Dd/eouplI4aXyI2HazDPaO1Zi5w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u3hrs2dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 10:36:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54Q89C0i010570;
	Mon, 26 May 2025 10:36:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usepns2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 10:36:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54QAa3jk15925648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 10:36:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FFAB20043;
	Mon, 26 May 2025 10:36:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B08CE20040;
	Mon, 26 May 2025 10:36:02 +0000 (GMT)
Received: from [9.111.82.242] (unknown [9.111.82.242])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 May 2025 10:36:02 +0000 (GMT)
Message-ID: <609a3511-4dae-47b8-a6a6-45b8f3b989a8@linux.ibm.com>
Date: Mon, 26 May 2025 12:36:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] KVM: s390: Always allocate esca_block
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com>
 <20250522-rm-bsca-v3-2-51d169738fcf@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250522-rm-bsca-v3-2-51d169738fcf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AOOMbaiN c=1 sm=1 tr=0 ts=68344418 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=Nht_sg-W_4d_RaGhDA8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 7OfBPDgFMme-oQ1W_vOD5PVhYIbrckU4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDA4OSBTYWx0ZWRfXwOUVdFRdTFwm haewGcf/C2cnQQL4uDqa0y3F277AAlcbx5ieBbsjz7gxLDiQd7baoCip64O5h7A/IEhpSZy0Hsr Iz7SXQaShfB0Bg8s0YQvuEjkBYMzmBKI0BIwnUcB758fUH22f8ZTlXhFeZCB/jQRBw1rI50vo69
 0rX5T+Aue6zb6wDPq1nr3UcQX+v040p6pmgM5uobQ2H2fFUmRoABtTz4nkivWkr1rT7DUyEfPC2 /dG+rwz1kCUlnoZWpQ20ibIHZZ3HykXoJ4xBrnUH4Q/vbtO1417BC/ZTPN1fOJw+0ddxsbDsbFe V30uTVLupanL4C03HjfOUZoFrJTPWx+oLILlGiX7WSIegj3djXDUulzSVQA2N4wrg6w5UdOgvm9
 EQALPnzEV63MKWPOE+UKWNQaewkrHv2o/hINyp1jXrkU23tbN8FoXWPvg5XVSxbpRX5FXFDr
X-Proofpoint-GUID: 7OfBPDgFMme-oQ1W_vOD5PVhYIbrckU4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_05,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 phishscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505260089

On 5/22/25 11:31 AM, Christoph Schlameuss wrote:
> Instead of allocating a BSCA and upgrading it for PV or when adding the
> 65th cpu we can always use the ESCA.
> 
> The only downside of the change is that we will always allocate 4 pages
> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
> In return we can delete a bunch of checks and special handling depending
> on the SCA type as well as the whole BSCA to ESCA conversion.
> 
> As a fallback we can still run without SCA entries when the SIGP
> interpretation facility or ESCA are not available.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |   1 -
>   arch/s390/kvm/interrupt.c        |  71 +++++------------
>   arch/s390/kvm/kvm-s390.c         | 161 ++++++---------------------------------
>   arch/s390/kvm/kvm-s390.h         |   4 +-
>   4 files changed, 45 insertions(+), 192 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index f51bac835260f562eaf4bbfd373a24bfdbc43834..d03e354a63d9c931522c1a1607eba8685c24527f 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -631,7 +631,6 @@ struct kvm_s390_pv {
>   

[...]

>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
> -	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
> -	int i, rc;
> +	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
>   	char debug_name[16];
> -	static unsigned long sca_offset;
> +	int i, rc;
>   
>   	rc = -EINVAL;
>   #ifdef CONFIG_KVM_S390_UCONTROL
> @@ -3358,17 +3341,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	if (!sclp.has_64bscao)
>   		alloc_flags |= GFP_DMA;
>   	rwlock_init(&kvm->arch.sca_lock);
> -	/* start with basic SCA */
> -	kvm->arch.sca = (struct bsca_block *) get_zeroed_page(alloc_flags);
> -	if (!kvm->arch.sca)
> -		goto out_err;
>   	mutex_lock(&kvm_lock);
> -	sca_offset += 16;
> -	if (sca_offset + sizeof(struct bsca_block) > PAGE_SIZE)
> -		sca_offset = 0;
> -	kvm->arch.sca = (struct bsca_block *)
> -			((char *) kvm->arch.sca + sca_offset);
> +
> +	kvm->arch.sca = alloc_pages_exact(sizeof(*kvm->arch.sca), alloc_flags);

kvm->arch.sca is (void *) at the point of this patch, which makes this a 
very bad idea. Granted, you fix that up in the next patch but this is 
still wrong.

Any reason why you have patch #3 at all?
We could just squash it and avoid this problem?

>   	mutex_unlock(&kvm_lock);
> +	if (!kvm->arch.sca)
> +		goto out_err;
>   
>   	sprintf(debug_name, "kvm-%u", current->pid);
>   

[...]

>   /* needs disabled preemption to protect from TOD sync and vcpu_load/put */
> @@ -3919,7 +3808,7 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   		vcpu->arch.sie_block->eca |= ECA_IB;
>   	if (sclp.has_siif)
>   		vcpu->arch.sie_block->eca |= ECA_SII;
> -	if (sclp.has_sigpif)
> +	if (kvm_s390_use_sca_entries())
>   		vcpu->arch.sie_block->eca |= ECA_SIGPI;
>   	if (test_kvm_facility(vcpu->kvm, 129)) {
>   		vcpu->arch.sie_block->eca |= ECA_VX;
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 8d3bbb2dd8d27802bbde2a7bd1378033ad614b8e..2c8e177e4af8f2dab07fd42a904cefdea80f6855 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -531,7 +531,7 @@ int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu);
>   /* support for Basic/Extended SCA handling */
>   static inline union ipte_control *kvm_s390_get_ipte_control(struct kvm *kvm)
>   {
> -	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> +	struct esca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */

Remove the comment as well please

>   
>   	return &sca->ipte_control;
>   }
> @@ -542,7 +542,7 @@ static inline int kvm_s390_use_sca_entries(void)
>   	 * might use the entries. By not setting the entries and keeping them
>   	 * invalid, hardware will not access them but intercept.
>   	 */
> -	return sclp.has_sigpif;
> +	return sclp.has_sigpif && sclp.has_esca;
>   }
>   void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
>   				     struct mcck_volatile_info *mcck_info);
> 


