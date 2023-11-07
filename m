Return-Path: <kvm+bounces-1034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 867E07E4699
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:13:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 402DB281338
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 17:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45992347A6;
	Tue,  7 Nov 2023 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QBOyDFpV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6064A328D7
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:13:40 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8817F7;
	Tue,  7 Nov 2023 09:13:39 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7Gf3Mj003914;
	Tue, 7 Nov 2023 17:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1qF71lmF0W6H/MG0sbfRUZXUpcRhl6fbMizqjvYoFxM=;
 b=QBOyDFpVLMLoEriMZr0bM9ZnLIeB9D5G4x6rI8uPIGjCIFcGmiCn5YknCwwj+KiI/js4
 VN0ahqYruh/yOwwY1uQGPSkOj37MW+OtxFCEvRY2BWA6oxlunFufBGXy8UulHUB8DNa1
 eGgpu+gd7hqHzzHyR2dQ4aSKXO+dmgrXlRBgbiQbfLvNRubDwJJOPIi0kadTirS/jsUf
 8SwqilV8s0Viqm+RR2Jny/9cGduwGDEaGHw41KAOZ2I43DEGd4rI5BGxJMYSiTTmUUSJ
 WCt9kIk5r+HOG1FNIVWgTzeozaedpe4M7hnw09QYcMG1gN+UUyb6rw/yffGE5L2/QCA3 Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7rs7sy01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 17:13:38 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A7Gg5MP008246;
	Tue, 7 Nov 2023 17:13:38 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7rs7swue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 17:13:37 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7FjDQT025652;
	Tue, 7 Nov 2023 17:11:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u619nj7cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 17:11:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A7HBArp18154184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 17:11:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45B9A20040;
	Tue,  7 Nov 2023 17:11:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E04C220049;
	Tue,  7 Nov 2023 17:11:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Nov 2023 17:11:09 +0000 (GMT)
Date: Tue, 7 Nov 2023 17:44:08 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 4/4] KVM: s390: Minor refactor of base/ext facility
 lists
Message-ID: <20231107174408.701957a6@p-imbrenda>
In-Reply-To: <20231107123118.778364-5-nsg@linux.ibm.com>
References: <20231107123118.778364-1-nsg@linux.ibm.com>
	<20231107123118.778364-5-nsg@linux.ibm.com>
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
X-Proofpoint-GUID: 3g0aYZ11JUe0tqac_zjE8Na_jdxvwIvi
X-Proofpoint-ORIG-GUID: jjv6KdRHwa-W9L45Idvb3QPXMu_zZwwb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_08,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070142

On Tue,  7 Nov 2023 13:31:18 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Directly use the size of the arrays instead of going through the
> indirection of kvm_s390_fac_size().
> Don't use magic number for the number of entries in the non hypervisor
> managed facility bit mask list.
> Make the constraint of that number on kvm_s390_fac_base obvious.
> Get rid of implicit double anding of stfle_fac_list.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> 
> Notes:
>     I think it's nicer this way but it might be needless churn.
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
>  
>  	r = __kvm_s390_init();
>  	if (r)


