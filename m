Return-Path: <kvm+bounces-525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0307B7E0881
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 19:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51A61281ECE
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1280F9EB;
	Fri,  3 Nov 2023 18:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IUN9Eqqg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E9A23CC
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 18:53:32 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911C5BD;
	Fri,  3 Nov 2023 11:53:31 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3IRPDa025490;
	Fri, 3 Nov 2023 18:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YF9MYguJwXRU4XWH9VeutjuL/m1o4JCo48rxpHFmiEM=;
 b=IUN9EqqgfEk2Z1bwS/uC5Slh+iOFT1NgWTt8UdLlX9yvgqGrXFs/MdDOEtR54SFTcbnh
 zvlnL91e8tHSShyiWyXs1JwxNL9bziHM/iW6SpO/uBhjp1QSv864jsdrSwqrCaeOlxm6
 yOyo+aXmGMZV+Qi70egCzjjYxwB+bLELjgERSoVaPwfZmjU+WRj1OWgbnE2sRtYj6qeI
 SCJrOcp9712YR+aGBKtBpFCCErsYPIFYBou5CkcXxScu5qPpJmRNsNXBe7pSe/po5jWr
 86wb0f8KPSIxOu6bMOYbU4GS0wymdEYhJenj0Ru95k8Y9w9KKs2wkHirhU1ThJgQN/5p oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u565f0qdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 18:53:31 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3Idna5026837;
	Fri, 3 Nov 2023 18:53:30 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u565f0qcj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 18:53:30 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3HTeUT007674;
	Fri, 3 Nov 2023 18:53:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1dmp7yph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 18:53:28 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3IrNEd10748572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 18:53:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE0DD20043;
	Fri,  3 Nov 2023 18:53:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A33B420040;
	Fri,  3 Nov 2023 18:53:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 18:53:22 +0000 (GMT)
Date: Fri, 3 Nov 2023 19:32:54 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck
 <cornelia.huck@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Michael
 Mueller <mimu@linux.vnet.ibm.com>,
        David Hildenbrand
 <dahi@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] KVM: s390: Minor refactor of base/ext facility
 lists
Message-ID: <20231103193254.7deef2e5@p-imbrenda>
In-Reply-To: <20231103173008.630217-5-nsg@linux.ibm.com>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
	<20231103173008.630217-5-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BMkJfee206Ia7hkgGk55NNtkOtVqheiN
X-Proofpoint-ORIG-GUID: Xg3YtXlXCOnnVD3TPpju3Dsp2FbKukC9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_18,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030159

On Fri,  3 Nov 2023 18:30:08 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Directly use the size of the arrays instead of going through the
> indirection of kvm_s390_fac_size().
> Don't use magic number for the number of entries in the non hypervisor
> managed facility bit mask list.
> Make the constraint of that number on kvm_s390_fac_base obvious.
> Get rid of implicit double anding of stfle_fac_list.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
> 
> 
> I found it confusing before and think it's nicer this way but
> it might be needless churn.

some things are probably overkill

> 
> 
>  arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++-----------------------
>  1 file changed, 19 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b3f17e014cab..e00ab2f38c89 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -217,33 +217,25 @@ static int async_destroy = 1;
>  module_param(async_destroy, int, 0444);
>  MODULE_PARM_DESC(async_destroy, "Asynchronous destroy for protected guests");
>  
> -/*
> - * For now we handle at most 16 double words as this is what the s390 base
> - * kernel handles and stores in the prefix page. If we ever need to go beyond
> - * this, this requires changes to code, but the external uapi can stay.
> - */
> -#define SIZE_INTERNAL 16
> -
> +#define HMFAI_DWORDS 16
>  /*
>   * Base feature mask that defines default mask for facilities. Consists of the
>   * defines in FACILITIES_KVM and the non-hypervisor managed bits.
>   */
> -static unsigned long kvm_s390_fac_base[SIZE_INTERNAL] = { FACILITIES_KVM };
> +static unsigned long kvm_s390_fac_base[HMFAI_DWORDS] = { FACILITIES_KVM };
> +static_assert(ARRAY_SIZE(((long[]){ FACILITIES_KVM })) <= HMFAI_DWORDS);
> +static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= S390_ARCH_FAC_MASK_SIZE_U64);
> +static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= S390_ARCH_FAC_LIST_SIZE_U64);
> +static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= ARRAY_SIZE(stfle_fac_list));
> +
>  /*
>   * Extended feature mask. Consists of the defines in FACILITIES_KVM_CPUMODEL
>   * and defines the facilities that can be enabled via a cpu model.
>   */
> -static unsigned long kvm_s390_fac_ext[SIZE_INTERNAL] = { FACILITIES_KVM_CPUMODEL };
> -
> -static unsigned long kvm_s390_fac_size(void)
> -{
> -	BUILD_BUG_ON(SIZE_INTERNAL > S390_ARCH_FAC_MASK_SIZE_U64);
> -	BUILD_BUG_ON(SIZE_INTERNAL > S390_ARCH_FAC_LIST_SIZE_U64);
> -	BUILD_BUG_ON(SIZE_INTERNAL * sizeof(unsigned long) >
> -		sizeof(stfle_fac_list));
> -
> -	return SIZE_INTERNAL;
> -}
> +static const unsigned long kvm_s390_fac_ext[] = { FACILITIES_KVM_CPUMODEL };

this was sized to [SIZE_INTERNAL], now it doesn't have a fixed size. is
this intentional?

> +static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= S390_ARCH_FAC_MASK_SIZE_U64);
> +static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= S390_ARCH_FAC_LIST_SIZE_U64);
> +static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= ARRAY_SIZE(stfle_fac_list));
>  
>  /* available cpu features supported by kvm */
>  static DECLARE_BITMAP(kvm_s390_available_cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
> @@ -3341,13 +3333,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.sie_page2->kvm = kvm;
>  	kvm->arch.model.fac_list = kvm->arch.sie_page2->fac_list;
>  
> -	for (i = 0; i < kvm_s390_fac_size(); i++) {
> +	for (i = 0; i < ARRAY_SIZE(kvm_s390_fac_base); i++) {
>  		kvm->arch.model.fac_mask[i] = stfle_fac_list[i] &
> -					      (kvm_s390_fac_base[i] |
> -					       kvm_s390_fac_ext[i]);
> +					      kvm_s390_fac_base[i];
>  		kvm->arch.model.fac_list[i] = stfle_fac_list[i] &
>  					      kvm_s390_fac_base[i];
>  	}
> +	for (i = 0; i < ARRAY_SIZE(kvm_s390_fac_ext); i++) {
> +		kvm->arch.model.fac_mask[i] |= stfle_fac_list[i] &
> +					       kvm_s390_fac_ext[i];
> +	}

I like it better when it's all in one place, instead of having two loops

>  	kvm->arch.model.subfuncs = kvm_s390_available_subfunc;
>  
>  	/* we are always in czam mode - even on pre z14 machines */
> @@ -5859,9 +5854,8 @@ static int __init kvm_s390_init(void)
>  		return -EINVAL;
>  	}
>  
> -	for (i = 0; i < 16; i++)
> -		kvm_s390_fac_base[i] |=
> -			stfle_fac_list[i] & nonhyp_mask(i);
> +	for (i = 0; i < HMFAI_DWORDS; i++)
> +		kvm_s390_fac_base[i] |= nonhyp_mask(i);

where did the stfle_fac_list[i] go?

>  
>  	r = __kvm_s390_init();
>  	if (r)


