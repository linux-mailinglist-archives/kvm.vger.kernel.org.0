Return-Path: <kvm+bounces-35016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 940CDA08C4A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:36:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB15E3AB1E5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D158209F41;
	Fri, 10 Jan 2025 09:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BUIOLZAS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CE01FECB1;
	Fri, 10 Jan 2025 09:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736501509; cv=none; b=py4kF7rh8zpuDh+hpcwLy9ggjIO7piSgImr8xaAAm2rUZ1+QYqT+PYbC0NhSxXS4o9ZR/J7m/8M2Qodb2rKrsmL7eLZUBDU6388lHIiyt9Jj8+M4L6aovB75XRx6i9ur5h+qVPq0RpKf7vEPgW4BvguUrnBEOHw0xLHg7Thle4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736501509; c=relaxed/simple;
	bh=+AKJ7bwZPX9PATvLdR8UUSmv27I69GujTzb6vofQ9BM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WXVKWaQdW81oSUxBtrEavTszMcB57N8iNsIcgERA2czzyEK3PWDGXQDFUncDY8TnCJrGUjRJzyB5ybCuf+WlBVJ/c2GzkJYhvqrSOaHs26XvHJBMHe6g5v/fsAcF51h10zq2PIDKnujeqcG3LtTAiuUhFWBAdGIUCZeuABQ1d24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BUIOLZAS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509NbGCq020162;
	Fri, 10 Jan 2025 09:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NxVQgF
	s6Cmcf8TSrL9rtQsF1NZnDvNe9eo2Tmk0A/F4=; b=BUIOLZASi75vuxgZTDURKF
	ZjavLY6jkFrGWFmpRYkpbG0LPr3Qc29oWXZQYAhpuh9IyJlBIN5EybH24yR4i9ya
	FWFLnnKEgDbj4P6Ta2nComs87XcB0VzK7Xbx9uUGxcvfVHQPzzSlz85bHQ8BIeLr
	Rx3+E/1Y0IsMSgqktGDN1Sy8uGlH8CN5TDPYMObMF29S5yaRdRMZjtIFS8P+5s4w
	fG+EnPh7MHDi92Vfn1J2HBpoaWeycwStdPXj/9CBnrk04DlvYTvvamicrkpGH0tM
	Eu/5U3K2MXpUTtDx/m43p188ceW9iBc0e1XKXwQA+eQC6T+6jnPgRmvgHqSQLcvg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442r9asv0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 09:31:42 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50A8kgUU003619;
	Fri, 10 Jan 2025 09:31:42 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yfathrd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 09:31:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50A9VcLU55312648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 09:31:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71B002004D;
	Fri, 10 Jan 2025 09:31:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49B442004B;
	Fri, 10 Jan 2025 09:31:38 +0000 (GMT)
Received: from [9.152.224.86] (unknown [9.152.224.86])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Jan 2025 09:31:38 +0000 (GMT)
Message-ID: <12a4155f-9d09-4af9-8556-ba32f7f639e6@de.ibm.com>
Date: Fri, 10 Jan 2025 10:31:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/13] KVM: s390: fake memslots for ucontrol VMs
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
 <20250108181451.74383-3-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250108181451.74383-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a4t1mUzLoDHDlYsvAaqSbuOAfy8jPZZw
X-Proofpoint-ORIG-GUID: a4t1mUzLoDHDlYsvAaqSbuOAfy8jPZZw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501100078



Am 08.01.25 um 19:14 schrieb Claudio Imbrenda:
> Create fake memslots for ucontrol VMs. The fake memslots identity-map
> userspace.
> 
> Now memslots will always be present, and ucontrol is not a special case
> anymore.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 42 ++++++++++++++++++++++++++++++++++++----
>   1 file changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ecbdd7d41230..797b8503c162 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -59,6 +59,7 @@
>   #define LOCAL_IRQS 32
>   #define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
>   			   (KVM_MAX_VCPUS + LOCAL_IRQS))
> +#define UCONTROL_SLOT_SIZE SZ_4T
>   
>   const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>   	KVM_GENERIC_VM_STATS(),
> @@ -3326,6 +3327,23 @@ void kvm_arch_free_vm(struct kvm *kvm)
>   	__kvm_arch_free_vm(kvm);
>   }
>   
> +static void kvm_s390_ucontrol_ensure_memslot(struct kvm *kvm, unsigned long addr)
> +{
> +	struct kvm_userspace_memory_region2 region = {
> +		.slot = addr / UCONTROL_SLOT_SIZE,
> +		.memory_size = UCONTROL_SLOT_SIZE,
> +		.guest_phys_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> +		.userspace_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> +	};
> +	struct kvm_memory_slot *slot;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	slot = gfn_to_memslot(kvm, addr);
> +	if (!slot)
> +		__kvm_set_memory_region(kvm, &region);
> +	mutex_unlock(&kvm->slots_lock);
> +}
> +

Would simply having one slot from 0 to TASK_SIZE also work? This could avoid the
construction of the fake slots during runtime.

>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
>   	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
> @@ -3430,6 +3448,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	if (type & KVM_VM_S390_UCONTROL) {
>   		kvm->arch.gmap = NULL;
>   		kvm->arch.mem_limit = KVM_S390_NO_MEM_LIMIT;
> +		/* pre-initialize a bunch of memslots; the amount is arbitrary */
> +		for (i = 0; i < 32; i++)
> +			kvm_s390_ucontrol_ensure_memslot(kvm, i * UCONTROL_SLOT_SIZE);
>   	} else {
>   		if (sclp.hamax == U64_MAX)
>   			kvm->arch.mem_limit = TASK_SIZE_MAX;
> @@ -5704,6 +5725,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   #ifdef CONFIG_KVM_S390_UCONTROL
>   	case KVM_S390_UCAS_MAP: {
>   		struct kvm_s390_ucas_mapping ucasmap;
> +		unsigned long a;

maybe addr?

[...]

> @@ -5852,10 +5879,18 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   				   struct kvm_memory_slot *new,
>   				   enum kvm_mr_change change)
>   {
> -	gpa_t size;
> +	gpa_t size = new->npages * PAGE_SIZE;
>   
> -	if (kvm_is_ucontrol(kvm))
> -		return -EINVAL;

Maybe add some comment here what and why we are checking those?

> +	if (kvm_is_ucontrol(kvm)) {
> +		if (change != KVM_MR_CREATE || new->flags)
> +			return -EINVAL;
> +		if (new->userspace_addr != new->base_gfn * PAGE_SIZE)
> +			return -EINVAL;
> +		if (!IS_ALIGNED(new->userspace_addr | size, UCONTROL_SLOT_SIZE))
> +			return -EINVAL;
> +		if (new->id != new->userspace_addr / UCONTROL_SLOT_SIZE)
> +			return -EINVAL;
> +	}
>   

