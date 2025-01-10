Return-Path: <kvm+bounces-35041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A5EA08FA9
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:47:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EA2A3A20BA
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2285020A5FB;
	Fri, 10 Jan 2025 11:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sJFqk7KQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962C01ACEDF;
	Fri, 10 Jan 2025 11:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736509642; cv=none; b=LgQu2sUzHOBZFQgMhdk9LBbK160zQJXTdwruSaSX40W7AL/h5vJSu0LZbo/3GU9j0zhnWlkoM6VIOQynyTuwbq7MK40Oj1HPe9Tpuv2sotmhj0YcOFQwD3jpMmjhW685ynW4OravwA/lIKZpbZOeaaOBwHfJnJGIwyyl5u2rh7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736509642; c=relaxed/simple;
	bh=L3T0DOVw7M8dEdeuOninHFRgJFC+Lb+MVcZw77LEWps=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YosBPrues+zT+wORlXQvzzPbP67tQ1JUbEVnn7bavZUq6JKr7+F1GljY7OuYf2XtUvEeUPO/XRwCG6ZikvrqVQSKwgQS08VQ6b4+qK9BJ5CDyzgVkk1S+qkAMbFGriV0NvT7+Rfz7BQz/pm5SatZTBGVmyWMzaf7WTpgBqGf8MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sJFqk7KQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509NaeWH019012;
	Fri, 10 Jan 2025 11:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JPWKOP
	uIjUVrWzHaZ5UuC7gV61CKrjIBvdezkO1JYwQ=; b=sJFqk7KQOAn9DZxkcVswpM
	eu1ffPefrm+2FHQ+vE+y1VYJxev1MSkVCNW1AwdJJ0Evnwlq/h8VKP98yq6trE8j
	Mcd1Xk72J1zg8awb7b9A5yLAxPq0iDn4gWKBj4rj+0ycAwIcNLNLR/juAnNL8/RH
	8cgU0V7num0SkXnXWh9Uey1aExi5Hj1EY9UAsuQrCHdnUgzS6y6hH4Sxzf88biuQ
	uZppn8o/7Hqm41wjiEd5FDaLpElfHLuKKmdnGemLFeo0dcRNSh54KMNt0ZIM/SHM
	D5KP51/aj4i68BuonIitqgEjSVfcfxPhsSDX+nvAO6xCJqmEtFh3V70x/ByxuBGA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442r9atd0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 11:47:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50A9G4ef008869;
	Fri, 10 Jan 2025 11:47:11 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfq0a4um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 11:47:11 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50ABl7gj31785498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 11:47:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8402620040;
	Fri, 10 Jan 2025 11:47:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 520F82004B;
	Fri, 10 Jan 2025 11:47:07 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Jan 2025 11:47:07 +0000 (GMT)
Date: Fri, 10 Jan 2025 12:47:05 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [PATCH v1 02/13] KVM: s390: fake memslots for ucontrol VMs
Message-ID: <20250110124705.74db01be@p-imbrenda>
In-Reply-To: <12a4155f-9d09-4af9-8556-ba32f7f639e6@de.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-3-imbrenda@linux.ibm.com>
	<12a4155f-9d09-4af9-8556-ba32f7f639e6@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dFGNPt_vBTsBEvzEiaPhXe1217Dz3EIA
X-Proofpoint-ORIG-GUID: dFGNPt_vBTsBEvzEiaPhXe1217Dz3EIA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501100090

On Fri, 10 Jan 2025 10:31:38 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 08.01.25 um 19:14 schrieb Claudio Imbrenda:
> > Create fake memslots for ucontrol VMs. The fake memslots identity-map
> > userspace.
> > 
> > Now memslots will always be present, and ucontrol is not a special case
> > anymore.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/kvm/kvm-s390.c | 42 ++++++++++++++++++++++++++++++++++++----
> >   1 file changed, 38 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index ecbdd7d41230..797b8503c162 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -59,6 +59,7 @@
> >   #define LOCAL_IRQS 32
> >   #define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
> >   			   (KVM_MAX_VCPUS + LOCAL_IRQS))
> > +#define UCONTROL_SLOT_SIZE SZ_4T
> >   
> >   const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
> >   	KVM_GENERIC_VM_STATS(),
> > @@ -3326,6 +3327,23 @@ void kvm_arch_free_vm(struct kvm *kvm)
> >   	__kvm_arch_free_vm(kvm);
> >   }
> >   
> > +static void kvm_s390_ucontrol_ensure_memslot(struct kvm *kvm, unsigned long addr)
> > +{
> > +	struct kvm_userspace_memory_region2 region = {
> > +		.slot = addr / UCONTROL_SLOT_SIZE,
> > +		.memory_size = UCONTROL_SLOT_SIZE,
> > +		.guest_phys_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> > +		.userspace_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> > +	};
> > +	struct kvm_memory_slot *slot;
> > +
> > +	mutex_lock(&kvm->slots_lock);
> > +	slot = gfn_to_memslot(kvm, addr);
> > +	if (!slot)
> > +		__kvm_set_memory_region(kvm, &region);
> > +	mutex_unlock(&kvm->slots_lock);
> > +}
> > +  
> 
> Would simply having one slot from 0 to TASK_SIZE also work? This could avoid the
> construction of the fake slots during runtime.

unfortunately memslots are limited to 4TiB.
having bigger ones would require even more changes all across KVM (and
maybe qemu too)

> 
> >   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >   {
> >   	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
> > @@ -3430,6 +3448,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >   	if (type & KVM_VM_S390_UCONTROL) {
> >   		kvm->arch.gmap = NULL;
> >   		kvm->arch.mem_limit = KVM_S390_NO_MEM_LIMIT;
> > +		/* pre-initialize a bunch of memslots; the amount is arbitrary */
> > +		for (i = 0; i < 32; i++)
> > +			kvm_s390_ucontrol_ensure_memslot(kvm, i * UCONTROL_SLOT_SIZE);
> >   	} else {
> >   		if (sclp.hamax == U64_MAX)
> >   			kvm->arch.mem_limit = TASK_SIZE_MAX;
> > @@ -5704,6 +5725,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >   #ifdef CONFIG_KVM_S390_UCONTROL
> >   	case KVM_S390_UCAS_MAP: {
> >   		struct kvm_s390_ucas_mapping ucasmap;
> > +		unsigned long a;  
> 
> maybe addr?

yes

> 
> [...]
> 
> > @@ -5852,10 +5879,18 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >   				   struct kvm_memory_slot *new,
> >   				   enum kvm_mr_change change)
> >   {
> > -	gpa_t size;
> > +	gpa_t size = new->npages * PAGE_SIZE;
> >   
> > -	if (kvm_is_ucontrol(kvm))
> > -		return -EINVAL;  
> 
> Maybe add some comment here what and why we are checking those?

will do

> 
> > +	if (kvm_is_ucontrol(kvm)) {
> > +		if (change != KVM_MR_CREATE || new->flags)
> > +			return -EINVAL;
> > +		if (new->userspace_addr != new->base_gfn * PAGE_SIZE)
> > +			return -EINVAL;
> > +		if (!IS_ALIGNED(new->userspace_addr | size, UCONTROL_SLOT_SIZE))
> > +			return -EINVAL;
> > +		if (new->id != new->userspace_addr / UCONTROL_SLOT_SIZE)
> > +			return -EINVAL;
> > +	}
> >     


