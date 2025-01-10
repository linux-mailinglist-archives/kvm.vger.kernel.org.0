Return-Path: <kvm+bounces-35065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DEAE9A09813
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 18:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9459B188F057
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 17:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81732135A1;
	Fri, 10 Jan 2025 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TYiUcyBe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A9F212B1D;
	Fri, 10 Jan 2025 17:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736528569; cv=none; b=OzCZJXxPlxSnJrqOv91+R5T8Kof9v5mBB4Ne1wW6k12ZeXjePrpN7kcb39kcBKGC0PpmXs6cCV2caYeKEYrrdxEEUPTCYwZoloETCVMOPUajCEktC7yww1w1A5QKdm2TL/oSKVcuWHfv/1WVtpR2xZQhKuNecyljseiqqfhDkW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736528569; c=relaxed/simple;
	bh=xykyLnVivgwmAtQkwnTk23jJtOktNP/7SFS1+Tu4Kbs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7a4u7qFq2FkjjF2UXf+F0Yu+1s6gF0g4ee3BMicl2d3AmUdui04H2SLBdbkJp3BMS8bh9ppVD1+64TqfbCOKfZxw2ir/yf8SjaiZw+lzMRM57ogwUr+PZ37nYHIv2NHLkNBpEAs4cA6SYKJfjsWMTm9Mhm95tOhjWjzbGF4ykM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TYiUcyBe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AE706o026971;
	Fri, 10 Jan 2025 17:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JqQy/p
	e/yY2YPve1PWjOHi95eFItzB28h1x5LLkdOZI=; b=TYiUcyBezy9HT0awKGW+ES
	OKtryFcPwHKgXtunYJVlrj/Qzc78/837/OADS619ont/rjAbDhyGacbjTfHejahJ
	xdYAe72hnTZyQrx4xpimzseGH/d7sbk2IUr8MsznqZKu/R7IzpG3H4h19TKrdUCv
	z4OgoBlX3ykzmK+vpX/D5juddr0gN+PKxPMvnhXjpeOaH4HjScArilnJ9ko79rlI
	bzD4DYkD+fdAioURq0DVFY9t9D+DEWgm8bn0pSP6xQjG4MFtjmbrdtFuItATsJIR
	fGNH+L7yAs6wq7AtfRYFj3XwiSD13XmngS82BSg0sgJ630TBtWGF9n4xFKCj9c0w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4435150tw3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 17:02:32 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50AGwO18027201;
	Fri, 10 Jan 2025 17:02:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4435150tw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 17:02:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50ADjL5w008861;
	Fri, 10 Jan 2025 17:02:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfq0bbq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 17:02:31 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50AH2RUl54985054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 17:02:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A0EE20049;
	Fri, 10 Jan 2025 17:02:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5650920040;
	Fri, 10 Jan 2025 17:02:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Jan 2025 17:02:27 +0000 (GMT)
Date: Fri, 10 Jan 2025 18:02:25 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [PATCH v1 02/13] KVM: s390: fake memslots for ucontrol VMs
Message-ID: <20250110180225.06dfba3c@p-imbrenda>
In-Reply-To: <Z4FJNJ3UND8LSJZz@google.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-3-imbrenda@linux.ibm.com>
	<12a4155f-9d09-4af9-8556-ba32f7f639e6@de.ibm.com>
	<20250110124705.74db01be@p-imbrenda>
	<Z4FJNJ3UND8LSJZz@google.com>
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
X-Proofpoint-GUID: 7d1kcI2TuPT3rDQifcYeZHtcT2BixnHS
X-Proofpoint-ORIG-GUID: pSfp-ipChvTyoyffFxSx7F_g5ZXB6U-1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501100133

On Fri, 10 Jan 2025 08:22:12 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Jan 10, 2025, Claudio Imbrenda wrote:
> > On Fri, 10 Jan 2025 10:31:38 +0100
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> > > Am 08.01.25 um 19:14 schrieb Claudio Imbrenda:  
> > > > +static void kvm_s390_ucontrol_ensure_memslot(struct kvm *kvm, unsigned long addr)
> > > > +{
> > > > +	struct kvm_userspace_memory_region2 region = {
> > > > +		.slot = addr / UCONTROL_SLOT_SIZE,
> > > > +		.memory_size = UCONTROL_SLOT_SIZE,
> > > > +		.guest_phys_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> > > > +		.userspace_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
> > > > +	};
> > > > +	struct kvm_memory_slot *slot;
> > > > +
> > > > +	mutex_lock(&kvm->slots_lock);
> > > > +	slot = gfn_to_memslot(kvm, addr);
> > > > +	if (!slot)
> > > > +		__kvm_set_memory_region(kvm, &region);  
> 
> The return value definitely should be checked, especially if the memory regions
> are not KVM-internal, i.e. if userspace is allowed to create memslots.
> 

will fix, unless we do what you propose below

> > > > +	mutex_unlock(&kvm->slots_lock);
> > > > +}
> > > > +    
> > > 
> > > Would simply having one slot from 0 to TASK_SIZE also work? This could avoid the
> > > construction of the fake slots during runtime.  
> > 
> > unfortunately memslots are limited to 4TiB.
> > having bigger ones would require even more changes all across KVM (and
> > maybe qemu too)  
> 
> AFAIK, that limitation exists purely because of dirty bitmaps.  IIUC, these "fake"
> memslots are not intended to be visible to userspace, or at the very least don't
> *need* to be visible to userspace.
> 
> Assuming that's true, they/it can/should be KVM-internal memslots, and those
> should never be dirty-logged.  x86 allocates metadata based on slot size, so in
> practice creating a mega-slot will never succeed on x86, but the only size
> limitation I see in s390 is on arch.mem_limit, but for ucontrol that's set to -1ull,
> i.e. is a non-issue.
> 
> I have a series (that I need to refresh) to provide a dedicated API for creating
> internal memslots, and to also enforce that flags == 0 for internal memslots,
> i.e. to enforce that dirty logging is never enabled (see Link below).  With that
> I mind, I can't think of any reason to disallow a 0 => TASK_SIZE memslot so long
> as it's KVM-defined.
> 
> Using a single memslot would hopefully allow s390 to unconditionally carve out a
> KVM-internal memslot, i.e. not have to condition the logic on the type of VM.  E.g.

yes, I would love that

the reason why I did not use internal memslots is that I would have
potentially needed *all* the memslots for ucontrol, and instead of
reserving, say, half of all memslots, I decided to have them
user-visible, which is hack I honestly don't like.

do you think you can refresh the series before the upcoming merge
window?

otherwise I should split this series in two, since page->index needs to
be removed asap.

> 
>   #define KVM_INTERNAL_MEM_SLOTS 1
> 
>   #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
> 
> And then I think just this?
> 
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 10 Jan 2025 08:05:09 -0800
> Subject: [PATCH] KVM: Do not restrict the size of KVM-internal memory regions
> 
> Exempt KVM-internal memslots from the KVM_MEM_MAX_NR_PAGES restriction, as
> the limit on the number of pages exists purely to play nice with dirty
> bitmap operations, which use 32-bit values to index the bitmaps, and dirty
> logging isn't supported for KVM-internal memslots.
> 
> Link: https://lore.kernel.org/all/20240802205003.353672-6-seanjc@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8a0d0d37fb17..3cea406c34db 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1972,7 +1972,15 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		return -EINVAL;
>  	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
>  		return -EINVAL;
> -	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
> +
> +	/*
> +	 * The size of userspace-defined memory regions is restricted in order
> +	 * to play nice with dirty bitmap operations, which are indexed with an
> +	 * "unsigned int".  KVM's internal memory regions don't support dirty
> +	 * logging, and so are exempt.
> +	 */
> +	if (id < KVM_USER_MEM_SLOTS &&
> +	    (mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
>  		return -EINVAL;
>  
>  	slots = __kvm_memslots(kvm, as_id);
> 
> base-commit: 1aadfba8419606d447d1961f25e2d312011ad45a


