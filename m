Return-Path: <kvm+bounces-36023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE28FA16F37
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:28:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 737891889421
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74841E766E;
	Mon, 20 Jan 2025 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MXWY67to"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8495C1E570B;
	Mon, 20 Jan 2025 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737386892; cv=none; b=FpMJb9xeXzuq+RvwSCavQ0P0VIgjBmN3Of63TIiWxPmwIxC+MPTBi++JuNWSUf1nGn5vHtqVTqpPJvRtuZDQZlMr0KjFeV8BhFBcqOACAXfqI5k+L+6fgi/hRnLcMLxRr7i45lIlPz9AefrCmYQvvYtL8onN9RwnYzppdQ2HGVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737386892; c=relaxed/simple;
	bh=BbOJDXfGK8WnM7im3y0FoU/9ZBp+QTcHIe3gTd6fL0Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=F6Z94QhCUPJaZzVJ7kebiL9Shp8pWOUCaEz33qTe64RLZHKFFkYk2/KaTkYFhls+fwjZP+hHk0JGmCjPaTGqaDEyJqD5c+y9E2tlA0DAbxCkEnVWd3i6bLPSFnR5UMSU8fWEVTVbePvSVAYoxkV32vr7Yo1ro9eB5++OemRgvRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MXWY67to; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50KDB6wu030366;
	Mon, 20 Jan 2025 15:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=V8SAF9
	PGrIt2wYYPm6xOiCPBbmR7rP3TfwEaly/4vWc=; b=MXWY67toLjj4bgPUomrs8O
	gQ7o7FR7QnCUvNOvi4ItF4OsiUBnvszKe7HSLjrUmGNMg2veHHhzU0ybf4b3bx0J
	QySruElZ3bRSvNM/I4x1E4uF+qT99RxSm6hxPrptsFUx0fVjjH8Jz7OpTn54xDxG
	OQcR1B4AyKUwhb4EVeS4Wtfn438MUGLC0v9ImXf31M8O9NZmSiplX6+BhvnKgIHy
	gsyFZPFXHXxgxZ63dECJ8+0UzCq+rCQeylApaWa105UFjWpzFVC/8XhsFqDHovG5
	17vfCjx1IZKjDR9rM4jNmvK09XrhHXG79HONtlDyF/j4pD08j1V49zP38Cdsrlzw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449cj93f7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:28:04 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50KFEodH026957;
	Mon, 20 Jan 2025 15:28:03 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449cj93f74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:28:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50KDPSHl020994;
	Mon, 20 Jan 2025 15:28:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb16jv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:28:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KFRwOJ33292782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 15:27:58 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0E5A2004E;
	Mon, 20 Jan 2025 15:27:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F28F20043;
	Mon, 20 Jan 2025 15:27:58 +0000 (GMT)
Received: from darkmoore (unknown [9.171.4.105])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jan 2025 15:27:58 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Jan 2025 16:27:53 +0100
Message-Id: <D7708V1QEO56.SR3N3BFBL4XF@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 03/15] KVM: s390: fake memslot for ucontrol VMs
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-4-imbrenda@linux.ibm.com>
In-Reply-To: <20250117190938.93793-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _iq1MVtRpqmeZokgTTpAKxUBPvaSs2t2
X-Proofpoint-GUID: n2nd44uD4qvVZCyjEnoAPck9lIbERibT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_03,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200125

On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> Create a fake memslot for ucontrol VMs. The fake memslot identity-maps
> userspace.
>
> Now memslots will always be present, and ucontrol is not a special case
> anymore.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

LGTM assuming the triggered warning about the slot_lock can be resolved in
another patch.
Tested in G1 and G2 using the ucontrol selftests.

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  Documentation/virt/kvm/api.rst   |  2 +-
>  arch/s390/include/asm/kvm_host.h |  2 ++
>  arch/s390/kvm/kvm-s390.c         | 15 ++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  2 ++
>  4 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index f15b61317aad..cc98115a96d7 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1419,7 +1419,7 @@ fetch) is injected in the guest.
>  S390:
>  ^^^^^
> =20
> -Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
> +Returns -EINVAL or -EEXIST if the VM has the KVM_VM_S390_UCONTROL flag s=
et.
>  Returns -EINVAL if called on a protected VM.
> =20
>  4.36 KVM_SET_TSS_ADDR
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 97c7c8127543..9df37361bc64 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -30,6 +30,8 @@
>  #define KVM_S390_ESCA_CPU_SLOTS 248
>  #define KVM_MAX_VCPUS 255
> =20
> +#define KVM_INTERNAL_MEM_SLOTS 1
> +
>  /*
>   * These seem to be used for allocating ->chip in the routing table, whi=
ch we
>   * don't use. 1 is as small as we can get to reduce the needed memory. I=
f we
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ecbdd7d41230..58cc7f7444e5 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3428,8 +3428,18 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lon=
g type)
>  	VM_EVENT(kvm, 3, "vm created with type %lu", type);
> =20
>  	if (type & KVM_VM_S390_UCONTROL) {
> +		struct kvm_userspace_memory_region2 fake_memslot =3D {
> +			.slot =3D KVM_S390_UCONTROL_MEMSLOT,
> +			.guest_phys_addr =3D 0,
> +			.userspace_addr =3D 0,
> +			.memory_size =3D ALIGN_DOWN(TASK_SIZE, _SEGMENT_SIZE),
> +			.flags =3D 0,
> +		};
> +
>  		kvm->arch.gmap =3D NULL;
>  		kvm->arch.mem_limit =3D KVM_S390_NO_MEM_LIMIT;
> +		/* one flat fake memslot covering the whole address-space */
> +		KVM_BUG_ON(kvm_set_internal_memslot(kvm, &fake_memslot), kvm);

In the current state of kvm_set_internal_memslot this does not acquire the
slot_lock and issues a warning. I did bring this up on Seans patch introduc=
ing
the method. So I assume at this point this here is fine.

>  	} else {
>  		if (sclp.hamax =3D=3D U64_MAX)
>  			kvm->arch.mem_limit =3D TASK_SIZE_MAX;
> @@ -5854,7 +5864,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  {
>  	gpa_t size;
> =20
> -	if (kvm_is_ucontrol(kvm))
> +	if (kvm_is_ucontrol(kvm) && new->id < KVM_USER_MEM_SLOTS)
>  		return -EINVAL;
> =20
>  	/* When we are protected, we should not change the memory slots */
> @@ -5906,6 +5916,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  {
>  	int rc =3D 0;
> =20
> +	if (kvm_is_ucontrol(kvm))
> +		return;
> +
>  	switch (change) {
>  	case KVM_MR_DELETE:
>  		rc =3D gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 597d7a71deeb..30736ac16f84 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -20,6 +20,8 @@
>  #include <asm/processor.h>
>  #include <asm/sclp.h>
> =20
> +#define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
> +
>  static inline void kvm_s390_fpu_store(struct kvm_run *run)
>  {
>  	fpu_stfpc(&run->s.regs.fpc);


