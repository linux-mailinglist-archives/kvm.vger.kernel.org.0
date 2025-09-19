Return-Path: <kvm+bounces-58113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CB5B88005
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 08:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7F111C2170D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 06:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6923A26B77B;
	Fri, 19 Sep 2025 06:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mk/ZD93M"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C3628F5;
	Fri, 19 Sep 2025 06:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758263488; cv=none; b=lGbS95+jiVKr4OsevoDPFzCK0XRLR/cQBCbeKWJHMvVIwv5QE+yekkptqrfkyrEY/5UWJr0J0uDgkK7UaTnYq/QiYSxwNy6SvKWOuZI/skqE5HnmSkGG1jOV3yVItzsFAkCmU6xy2Q1nqokGNozKKTxfkVzSWla/06noUAeDPAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758263488; c=relaxed/simple;
	bh=4MhWJlP71VZCOVNN+lHvxaptjhimilXlKctIAYX3Byw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LeoNzhFFSvR7HzWIFOuFNUBAJdwJ3HMIVfEUaNsELhqJKMaCxCA6KOkdxDSOgisnZdsvRhxRwEQwbDm+0d7q97jpRIqusYdjkDOiADrf5E5h9r7/cYNo+3BF4WjZ3NZjh9QMU6temcgIXZh9sKYqRghRtY/MWDYisRNBQi1coUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mk/ZD93M; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58J3KlCx011575;
	Fri, 19 Sep 2025 06:31:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AKXTRU
	MWL+ox9rBx/hXoJNoCYAi39BF6mftgBjv8suY=; b=mk/ZD93Muag+UjLD7/ffZS
	3/OSHdlEixKtDxg/iE0cyOkIJCFgiBDaIfjhXRqvCJtAMWIO7cZhNGV0VDbNviv0
	4ays7a4m0fbTfLK5VkJ8IWgOaOrDymA+avDlUoTu6UqTFeIFbCGhJ57p9v7YvJwK
	XiLPV24xC/VBSbhFUebXwsOEnQqd3hKY95b6w2SPWjQsIjwfzoA78YSGBNIHovL0
	6o5WxXYt7UuiEW8C688Ty3YYJTx/AhjiI9J9cQmmBmHUXxzQa+y0N4M/pCJKWx/m
	MlakNlRQZnf1sAHkFsKgBf0wTVw5sZLWd7NpPrNRAuM1lnHuxWkGurnoVs5FdvQA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4np9s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 06:31:18 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58J6VIPR025809;
	Fri, 19 Sep 2025 06:31:18 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4np9rv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 06:31:18 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58J30QR8009395;
	Fri, 19 Sep 2025 06:31:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3t8dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 06:31:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58J6VEei37880162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 06:31:14 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2E0420043;
	Fri, 19 Sep 2025 06:31:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3138520040;
	Fri, 19 Sep 2025 06:31:13 +0000 (GMT)
Received: from [9.111.68.111] (unknown [9.111.68.111])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 19 Sep 2025 06:31:13 +0000 (GMT)
Message-ID: <d0c954dc-6961-4536-b103-d7fdf1afb313@linux.ibm.com>
Date: Fri, 19 Sep 2025 08:31:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] KVM: s390/vfio-ap: Use kvm_is_gpa_in_memslot()
 instead of open coded equivalent
To: Sean Christopherson <seanjc@google.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250919003303.1355064-1-seanjc@google.com>
 <20250919003303.1355064-2-seanjc@google.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250919003303.1355064-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68ccf8b7 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=1XWaLZrsAAAA:8
 a=WMn4R6eJaF8VgN3aVUEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: md5iwfiyFe2OTejpXCjJPdxQmjbfiyb-
X-Proofpoint-ORIG-GUID: DXgSIvc5M_qRAWhURQ1HdkyzBqz_Qyoc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX/BVrxPcE3PG2
 qtrYAMokM4pZJJN97Ey//DXDj5ryel8jNsk3kaQAMcY4cvdBVgSqsLzhhuKOhCo6a9s1QjEHT8Z
 LxUZ+NcKDumMSiUjjlnyFpqwglBskTojSluoYSHV3BHtvAzX/1bBW0oyU4JmfjPGoKqLqS6VWWe
 +iPOybn8095kSdqUIUCner1Hq9z6pvyS4nzDuIl+c5gGG62dJGyIgONiorxk2gZozbrEhkKZAEt
 dHVmV0RMF0kKOBKBx9RVyBjTRSjo+bYvNF196+lQPmbLsxKFSPhy+Gu4VcAiFJdliAk09Z2aZ2h
 FWf/tXahLW+IMOrIMTIgckz3ZPcFw+rtayAovz0F3Hn/b/Z743nzTUr+zRpaMtSCXVM2xljoTvV
 UkqgHXkD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_03,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

Am 19.09.25 um 02:32 schrieb Sean Christopherson:
> Use kvm_is_gpa_in_memslot() to check the validity of the notification
> indicator byte address instead of open coding equivalent logic in the VFIO
> AP driver.
> 
> Opportunistically use a dedicated wrapper that exists and is exported
> expressly for the VFIO AP module.  kvm_is_gpa_in_memslot() is generally
> unsuitable for use outside of KVM; other drivers typically shouldn't rely
> on KVM's memslots, and using the API requires kvm->srcu (or slots_lock) to
> be held for the entire duration of the usage, e.g. to avoid TOCTOU bugs.
> handle_pqap() is a bit of a special case, as it's explicitly invoked from
> KVM with kvm->srcu already held, and the VFIO AP driver is in many ways an
> extension of KVM that happens to live in a separate module.
> 
> Providing a dedicated API for the VFIO AP driver will allow restricting
> the vast majority of generic KVM's exports to KVM submodules (e.g. to x86's
> kvm-{amd,intel}.ko vendor mdoules).
> 
> No functional change intended.
> 
> Acked-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   arch/s390/include/asm/kvm_host.h  | 2 ++
>   arch/s390/kvm/priv.c              | 8 ++++++++
>   drivers/s390/crypto/vfio_ap_ops.c | 2 +-
>   3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index f870d09515cc..ee25eeda12fd 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -722,6 +722,8 @@ extern int kvm_s390_enter_exit_sie(struct kvm_s390_sie_block *scb,
>   extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
>   extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
>   
> +bool kvm_s390_is_gpa_in_memslot(struct kvm *kvm, gpa_t gpa);
> +
>   static inline void kvm_arch_free_memslot(struct kvm *kvm,
>   					 struct kvm_memory_slot *slot) {}
>   static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 9253c70897a8..9a71b6e00948 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -605,6 +605,14 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
>   	}
>   }
>   
> +#if IS_ENABLED(CONFIG_VFIO_AP)
> +bool kvm_s390_is_gpa_in_memslot(struct kvm *kvm, gpa_t gpa)
> +{
> +	return kvm_is_gpa_in_memslot(kvm, gpa);
> +}
> +EXPORT_SYMBOL_FOR_MODULES(kvm_s390_is_gpa_in_memslot, "vfio_ap");
> +#endif
> +
>   /*
>    * handle_pqap: Handling pqap interception
>    * @vcpu: the vcpu having issue the pqap instruction
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 766557547f83..eb5ff49f6fe7 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -354,7 +354,7 @@ static int vfio_ap_validate_nib(struct kvm_vcpu *vcpu, dma_addr_t *nib)
>   
>   	if (!*nib)
>   		return -EINVAL;
> -	if (kvm_is_error_hva(gfn_to_hva(vcpu->kvm, *nib >> PAGE_SHIFT)))
> +	if (!kvm_s390_is_gpa_in_memslot(vcpu->kvm, *nib))
>   		return -EINVAL;
>   
>   	return 0;


