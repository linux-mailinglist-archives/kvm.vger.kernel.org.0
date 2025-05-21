Return-Path: <kvm+bounces-47270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28A19ABF78A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C2DF1884159
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 14:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD82318CBFB;
	Wed, 21 May 2025 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O38MpyA+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CE02A8C1
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836919; cv=none; b=kQl7katrP0Dm+SRaQi3MRmF7svHvLRjU9XczJGpD3NLvrLUlXaJ5LvJu1DA+yNihReVmMyMYpuXwKjxhjBD0AdKLdtwuqDKJrCF7L3i9viDfHutqKQSTArlwuwd284vEZFS5hPuKnlU5Mjt9r7mGdRel3OJ+nFCcxfk+4JOZcng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836919; c=relaxed/simple;
	bh=MlJ6JiIQHZbou2ldHjRqq8P3BAcmjth4LMv6Mrv59ZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L2rPRcj/tOD08vfFggHvsXiKqCXF7RwpYuoG0J59o4Zpd/6OIhiUBlAyMwogiUHPWS+HYMNol9C7JD0EfRsxt9Iv2ztAl+cFpRNvo51Y5TS84IQdhVn/kbTlwhrO0KRs34MPn2zwu/8C0Pq+wz2AvXpgrtm4TYCc5rcP4g18E1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O38MpyA+; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-47e9fea29easo1716901cf.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747836916; x=1748441716; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3WzAnMtwICC8te5utymAkjaArInvb4ahl245wyxmDhU=;
        b=O38MpyA+BINa19uuWprO/6SJmni8JCxZeUICjBJw0jwIABpcobuFYhUMI7ewud8Edb
         lzGveOUF4T/eykPKaJ+3fwwrhAYa4P8wWBjpqO8Jrb78N+WOe7thOS0jQpGXFR8SQq2o
         kSf0Y1eTOLh1Hfj2nhC8VKA0b8YUpOvsRivaHXMmNDbev6FXE8TbBRly39h5U0gupi6l
         fkBozPItx99QOygka9AKoTsVVQqNxh+m0vxzsOOUSA79ocliJeBcmaK78gnHI8/HumCn
         SRhAFEnqeANlDWBJJyph6F3wBxpsr6ZN5U7Jc066vB+q0g/vaTyw5zvvhw9nn92SUiMe
         at6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747836916; x=1748441716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3WzAnMtwICC8te5utymAkjaArInvb4ahl245wyxmDhU=;
        b=RySbZX4YpG9+vGu8PL12+6EBv3q+GogTr4tsEqrRgLviRXGcQLL0LwkNW5araa9Tts
         z/jRpud00MKVZbwA9uSkeHhKFehpHiPg3iaFfMkfBEZ/gkCo5CmOt5O43JWGMAG1HKIX
         hgbCidcl7n3xNQxKgQs5MEWnPRZKLLcpHmpFLsQGdsnu5qrWmV5lEKYLI8OX1Uq4WVr7
         Ek/iQXIonHvsTJdV4tklv+5DrNJwcrzWS4ge3QFmoHOn8vVwbdQOfBoGMnDo4DeUxz/I
         b26BRzOEmOUDwVTR3rpu1FNu8uV9ToF0bhpJgVcL+biX6eCRboNdTYNIXJ/Lmr/EO+6+
         TrBw==
X-Gm-Message-State: AOJu0YwEihl7Qb4dJZPkPeDRQX8IKWghqVr4szzzSgzFwvZf8qlqD4ly
	FOl4ixjbUUhO0+L3ST84fzWeLMt43z3SJXfCJzsRYw62H+bdnag5pM0aDvGGUmzNKeXiI3QDyBi
	o2Ay/IN0owvYo6jkwV1vQGSsZnjEBj2143gCdRmOX
X-Gm-Gg: ASbGncuxZmWlEiLwLMhmDoJ/r+wDwodUph2e6JYfPyCW2erUIei7RsMlv3AdSzzH/CA
	vQdR/xP41nGjljVR38CipcsnWHe5DYsKfNBzUdH6WhkzS6IlPZgr/MjYZv8I4t7d9bNiUavLA0x
	CxsHsulZl2ITauOfQgdIeLzcf2S0C1aOvwDrfZ8ismxv1nPuX3EILtKinu/28XlvB+tpixMVFu
X-Google-Smtp-Source: AGHT+IEn5V+JWD+UauK6mQDftJkyNEx0zMO+Q169cK9p3MaBFwYpfUCXSSLf4XNPPuvJL0iGrFy2j+E3JL/Lqw/qYdw=
X-Received: by 2002:ac8:5344:0:b0:494:b641:4851 with SMTP id
 d75a77b69052e-49601267af3mr13541891cf.27.1747836915564; Wed, 21 May 2025
 07:15:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-15-tabba@google.com>
 <2084504e-2a11-404a-bbe8-930384106f53@redhat.com> <CA+EHjTyz4M4wGCTBzFwHLB_0LUJHq6J135f=DVOhGKQE4thrtQ@mail.gmail.com>
 <d5983511-6de3-42cb-9c2f-4a0377ea5e2d@redhat.com> <CA+EHjTxhirJDCR4hdTt4-FJ+vo9986PE-CGwikN8zN_1H1q5jQ@mail.gmail.com>
 <f6005b96-d408-450c-ad80-6241e35c6d26@redhat.com> <CA+EHjTzaE_vGPsB20eJ99fG4_gck9Gb7iaVQ3ie5YUnNe5wHgw@mail.gmail.com>
 <5da72da7-b82c-4d70-ac86-3710a046b836@redhat.com> <CA+EHjTwmgZ3i2oaBcnhr1HjLtFeycJM49utO5VhtsOH6E9WcXQ@mail.gmail.com>
 <dd15ec6c-264a-4b2a-baaf-7945be09475a@redhat.com>
In-Reply-To: <dd15ec6c-264a-4b2a-baaf-7945be09475a@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 May 2025 15:14:39 +0100
X-Gm-Features: AX0GCFv2FNWFMwS3kSPiKr0dVnY2fcYTXMVpdcfakJ_Ca04MIfPa37C-aPPjPqA
Message-ID: <CA+EHjTyWjjPuHrNsi4FqXpCK-zNvrsN0pFOwKnfVqxuRX+WJdQ@mail.gmail.com>
Subject: Re: [PATCH v9 14/17] KVM: arm64: Enable mapping guest_memfd in arm64
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 May 2025 at 14:45, David Hildenbrand <david@redhat.com> wrote:
>
> On 21.05.25 15:32, Fuad Tabba wrote:
> > Hi David,
> >
> > On Wed, 21 May 2025 at 14:22, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 21.05.25 15:15, Fuad Tabba wrote:
> >>> Hi David,
> >>>
> >>> On Wed, 21 May 2025 at 13:44, David Hildenbrand <david@redhat.com> wrote:
> >>>>
> >>>> On 21.05.25 12:29, Fuad Tabba wrote:
> >>>>> On Wed, 21 May 2025 at 11:26, David Hildenbrand <david@redhat.com> wrote:
> >>>>>>
> >>>>>> On 21.05.25 12:12, Fuad Tabba wrote:
> >>>>>>> Hi David,
> >>>>>>>
> >>>>>>> On Wed, 21 May 2025 at 09:05, David Hildenbrand <david@redhat.com> wrote:
> >>>>>>>>
> >>>>>>>> On 13.05.25 18:34, Fuad Tabba wrote:
> >>>>>>>>> Enable mapping guest_memfd in arm64. For now, it applies to all
> >>>>>>>>> VMs in arm64 that use guest_memfd. In the future, new VM types
> >>>>>>>>> can restrict this via kvm_arch_gmem_supports_shared_mem().
> >>>>>>>>>
> >>>>>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>>>>>>>> ---
> >>>>>>>>>       arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> >>>>>>>>>       arch/arm64/kvm/Kconfig            |  1 +
> >>>>>>>>>       2 files changed, 11 insertions(+)
> >>>>>>>>>
> >>>>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>>>>>>>> index 08ba91e6fb03..2514779f5131 100644
> >>>>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
> >>>>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>>>>>>>> @@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
> >>>>>>>>>           return true;
> >>>>>>>>>       }
> >>>>>>>>>
> >>>>>>>>> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> >>>>>>>>> +{
> >>>>>>>>> +     return IS_ENABLED(CONFIG_KVM_GMEM);
> >>>>>>>>> +}
> >>>>>>>>> +
> >>>>>>>>> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> >>>>>>>>> +{
> >>>>>>>>> +     return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
> >>>>>>>>> +}
> >>>>>>>>> +
> >>>>>>>>>       #endif /* __ARM64_KVM_HOST_H__ */
> >>>>>>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> >>>>>>>>> index 096e45acadb2..8c1e1964b46a 100644
> >>>>>>>>> --- a/arch/arm64/kvm/Kconfig
> >>>>>>>>> +++ b/arch/arm64/kvm/Kconfig
> >>>>>>>>> @@ -38,6 +38,7 @@ menuconfig KVM
> >>>>>>>>>           select HAVE_KVM_VCPU_RUN_PID_CHANGE
> >>>>>>>>>           select SCHED_INFO
> >>>>>>>>>           select GUEST_PERF_EVENTS if PERF_EVENTS
> >>>>>>>>> +     select KVM_GMEM_SHARED_MEM
> >>>>>>>>>           help
> >>>>>>>>>             Support hosting virtualized guest machines.
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> Do we have to reject somewhere if we are given a guest_memfd that was
> >>>>>>>> *not* created using the SHARED flag? Or will existing checks already
> >>>>>>>> reject that?
> >>>>>>>
> >>>>>>> We don't reject, but I don't think we need to. A user can create a
> >>>>>>> guest_memfd that's private in arm64, it would just be useless.
> >>>>>>
> >>>>>> But the arm64 fault routine would not be able to handle that properly, no?
> >>>>>
> >>>>> Actually it would. The function user_mem_abort() doesn't care whether
> >>>>> it's private or shared. It would fault it into the guest correctly
> >>>>> regardless.
> >>>>
> >>>>
> >>>> I think what I meant is that: if it's !shared (private only), shared
> >>>> accesses (IOW all access without CoCo) should be taken from the user
> >>>> space mapping.
> >>>>
> >>>> But user_mem_abort() would blindly go to kvm_gmem_get_pfn() because
> >>>> "is_gmem = kvm_slot_has_gmem(memslot) = true".
> >>>
> >>> Yes, since it is a gmem-backed slot.
> >>>
> >>>> In other words, arm64 would have to *ignore* guest_memfd that does not
> >>>> support shared?
> >>>>
> >>>> That's why I was wondering whether we should just immediately refuse
> >>>> such guest_memfds.
> >>>
> >>> My thinking is that if a user deliberately creates a
> >>> guest_memfd-backed slot without designating it as being sharable, then
> >>> either they would find out when they try to map that memory to the
> >>> host userspace (mapping it would fail), or it could be that they
> >>> deliberately want to set up a VM with memslots that not mappable at
> >>> all by the host.
> >>
> >> Hm. But that would meant that we interpret "private" memory as a concept
> >> that is not understood by the VM. Because the VM does not know what
> >> "private" memory is ...
> >>
> >>> Perhaps to add some layer of security (although a
> >>> very flimsy one, since it's not a confidential guest).
> >>
> >> Exactly my point. If you don't want to mmap it then ... don't mmap it :)
> >>
> >>>
> >>> I'm happy to a check to prevent this. The question is, how to do it
> >>> exactly (I assume it would be in kvm_gmem_create())? Would it be
> >>> arch-specific, i.e., prevent arm64 from creating non-shared
> >>> guest_memfd backed memslots? Or do it by VM type? Even if we do it by
> >>> VM-type it would need to be arch-specific, since we allow private
> >>> guest_memfd slots for the default VM in x86, but we wouldn't for
> >>> arm64.
> >>>
> >>> We could add another function, along the lines of
> >>> kvm_arch_supports_gmem_only_shared_mem(), but considering that it
> >>> actually works, and (arguably) would behave as intended, I'm not sure
> >>> if it's worth the complexity.
> >>>
> >>> What do you think?
> >>
> >> My thinking was to either block this at slot creation time or at
> >> guest_memfd creation time. And we should probably block that for other
> >> VM types as well that do not support private memory?
> >>
> >> I mean, creating guest_memfd for private memory when there is no concept
> >> of private memory for the VM is ... weird, no? :)
> >
> > Actually, I could add this as an arch-specific check in
> > arch/arm64/kvm/mmu.c:kvm_arch_prepare_memory_region(). That way, core
> > KVM/guest_memfd code doesn't need to handle this arm64-specific behavior.
> >
> > Does that sound good?
>
> Yes, but only do so if you agree.

Ack :)

/fuad

> --
> Cheers,
>
> David / dhildenb
>

