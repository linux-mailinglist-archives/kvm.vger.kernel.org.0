Return-Path: <kvm+bounces-35061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 665A8A09662
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 16:49:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6381516A90E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A76211715;
	Fri, 10 Jan 2025 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cm/OBxSN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFDB2116E7;
	Fri, 10 Jan 2025 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736524164; cv=none; b=NXv03/EkTYUZGV9zpk8Au5esu3wqfSe6rXVBzQGuj1EFs4NwxZvxrsG4fN63LMZOWbQ44NKs6eJ9WhhjpHDcDdFzIYMiujcfjb8pYu29IkdQZGtpq1/EIuecWEwQXrxNnwcKkCHbRuk5ieOaJx/7x1kvAMyWa2yHYcE2sPXq2K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736524164; c=relaxed/simple;
	bh=6AesAjsPQe+Q6dZmCB7IAZ/dCQeMTOZDKZNyQY1XkyM=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=e0z6xZdmjjQNeq7dxzlpXwoiRpryFLDdCS9n7BlIuNm6KZadutU3J07HqXoaFlYUpGB6iFEdCwtAcCpqeEodFOmxqiFNG+glEIAVq++mOBl3tKWroiG+C/8laendE2ykjB+ANLWvaTXfCnTSsdl2mrVLkH315wtw7za0pyfBun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cm/OBxSN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50A3rpiF029127;
	Fri, 10 Jan 2025 15:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PXGEBz
	0M8UPoIymcBxudeB1arG/6HDODYwhhEf3NTKc=; b=cm/OBxSNWoDwLZAE5rh7C1
	Ziu/icum5xE1ADpICtJc5sKoff2q5Oy9IcV7pXpfrFYnRwl/2psgCP0hoyRzL6Nk
	0q5JhmyLEmqj64GPx6MkJPEFfabz4oydN17e6Nt2ZUgi2oSFxQc15BVQIFlHA92V
	0FVJd5N0P8ZLJoHk/51cQNBDYC2ph3tqKpdCSfQVDsXdvC99nx7qmK0CH1BDVsQr
	UVT7hCgL+AgtYSqN+ukfpjRjv17/5NKqeGsnsqq88S6sg9/eEz2XgSYd6ppt4B/H
	D/bUZjBiPyz4CCzY5gHTHJplhsdOHSZc+JiTvrNDpj5GTidAdYoyQ84x/pyhkDNQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442v1q2t1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 15:49:13 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50ADv2n6013698;
	Fri, 10 Jan 2025 15:49:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygapawa6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 15:49:11 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50AFn86N46334424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 15:49:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EED1B2004B;
	Fri, 10 Jan 2025 15:49:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C889A20040;
	Fri, 10 Jan 2025 15:49:07 +0000 (GMT)
Received: from darkmoore (unknown [9.179.31.54])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Jan 2025 15:49:07 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jan 2025 16:40:04 +0100
Message-Id: <D6YI8R3EGSM1.3NVP352YOB8KQ@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 02/13] KVM: s390: fake memslots for ucontrol VMs
X-Mailer: aerc 0.18.2
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
 <20250108181451.74383-3-imbrenda@linux.ibm.com>
In-Reply-To: <20250108181451.74383-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1sYvkqy9m-nvFKgqEyAHodscTxf5tp-S
X-Proofpoint-ORIG-GUID: 1sYvkqy9m-nvFKgqEyAHodscTxf5tp-S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501100122

On Wed Jan 8, 2025 at 7:14 PM CET, Claudio Imbrenda wrote:
> Create fake memslots for ucontrol VMs. The fake memslots identity-map
> userspace.
>
> Now memslots will always be present, and ucontrol is not a special case
> anymore.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 42 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 4 deletions(-)
>
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ecbdd7d41230..797b8503c162 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -59,6 +59,7 @@
>  #define LOCAL_IRQS 32
>  #define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
>  			   (KVM_MAX_VCPUS + LOCAL_IRQS))
> +#define UCONTROL_SLOT_SIZE SZ_4T
> =20
>  const struct _kvm_stats_desc kvm_vm_stats_desc[] =3D {
>  	KVM_GENERIC_VM_STATS(),
> @@ -3326,6 +3327,23 @@ void kvm_arch_free_vm(struct kvm *kvm)
>  	__kvm_arch_free_vm(kvm);
>  }
> =20
> +static void kvm_s390_ucontrol_ensure_memslot(struct kvm *kvm, unsigned l=
ong addr)
> +{
> +	struct kvm_userspace_memory_region2 region =3D {
> +		.slot =3D addr / UCONTROL_SLOT_SIZE,
> +		.memory_size =3D UCONTROL_SLOT_SIZE,
> +		.guest_phys_addr =3D ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> +		.userspace_addr =3D ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> +	};
> +	struct kvm_memory_slot *slot;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	slot =3D gfn_to_memslot(kvm, addr);
> +	if (!slot)
> +		__kvm_set_memory_region(kvm, &region);

This will call into kvm_arch_commit_memory_region() where
kvm->arch.gmap will still be NULL!

> +	mutex_unlock(&kvm->slots_lock);
> +}
> +
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>  	gfp_t alloc_flags =3D GFP_KERNEL_ACCOUNT;
> @@ -3430,6 +3448,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
>  	if (type & KVM_VM_S390_UCONTROL) {
>  		kvm->arch.gmap =3D NULL;
>  		kvm->arch.mem_limit =3D KVM_S390_NO_MEM_LIMIT;
> +		/* pre-initialize a bunch of memslots; the amount is arbitrary */
> +		for (i =3D 0; i < 32; i++)
> +			kvm_s390_ucontrol_ensure_memslot(kvm, i * UCONTROL_SLOT_SIZE);
>  	} else {
>  		if (sclp.hamax =3D=3D U64_MAX)
>  			kvm->arch.mem_limit =3D TASK_SIZE_MAX;
> @@ -5704,6 +5725,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  #ifdef CONFIG_KVM_S390_UCONTROL
>  	case KVM_S390_UCAS_MAP: {
>  		struct kvm_s390_ucas_mapping ucasmap;
> +		unsigned long a;
> =20
>  		if (copy_from_user(&ucasmap, argp, sizeof(ucasmap))) {
>  			r =3D -EFAULT;
> @@ -5715,6 +5737,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  			break;
>  		}
> =20
> +		a =3D ALIGN_DOWN(ucasmap.user_addr, UCONTROL_SLOT_SIZE);
> +		while (a < ucasmap.user_addr + ucasmap.length) {
> +			kvm_s390_ucontrol_ensure_memslot(vcpu->kvm, a);
> +			a +=3D UCONTROL_SLOT_SIZE;
> +		}
>  		r =3D gmap_map_segment(vcpu->arch.gmap, ucasmap.user_addr,
>  				     ucasmap.vcpu_addr, ucasmap.length);
>  		break;
> @@ -5852,10 +5879,18 @@ int kvm_arch_prepare_memory_region(struct kvm *kv=
m,
>  				   struct kvm_memory_slot *new,
>  				   enum kvm_mr_change change)
>  {
> -	gpa_t size;
> +	gpa_t size =3D new->npages * PAGE_SIZE;
> =20
> -	if (kvm_is_ucontrol(kvm))
> -		return -EINVAL;
> +	if (kvm_is_ucontrol(kvm)) {
> +		if (change !=3D KVM_MR_CREATE || new->flags)
> +			return -EINVAL;
> +		if (new->userspace_addr !=3D new->base_gfn * PAGE_SIZE)
> +			return -EINVAL;
> +		if (!IS_ALIGNED(new->userspace_addr | size, UCONTROL_SLOT_SIZE))
> +			return -EINVAL;
> +		if (new->id !=3D new->userspace_addr / UCONTROL_SLOT_SIZE)
> +			return -EINVAL;
> +	}
> =20
>  	/* When we are protected, we should not change the memory slots */
>  	if (kvm_s390_pv_get_handle(kvm))
> @@ -5872,7 +5907,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  		if (new->userspace_addr & 0xffffful)
>  			return -EINVAL;
> =20
> -		size =3D new->npages * PAGE_SIZE;
>  		if (size & 0xffffful)
>  			return -EINVAL;
> =20


