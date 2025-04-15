Return-Path: <kvm+bounces-43349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E604A8A011
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 15:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16D3C441AEE
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 13:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181DD1AD3F6;
	Tue, 15 Apr 2025 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DHACGsc6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E60194A44
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 13:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744725106; cv=none; b=TIgrOzqJjdC28fftULG6hV28Y+2a88230YcYl8MBhjZUdf6yCnz1+/1lFCdAkgEnjfAz0dFToylsQtFDdt7bBMcF1YLKfDHGhGqM+3N8KTumMGPnlqSDCJE6eHGSYaVQTL7eJAVucWwoQd77oEl3yYqhhtl1nSSH4jKudkl5Bek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744725106; c=relaxed/simple;
	bh=LP/9oRtpUe2h8OfLw7/nirLfuIAdCzLDkVKZQ/KtgIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZHfCGq8JzewuIQffrurFmAthPVIOLTxgPD9QRVuNi+DU1t2S5hMqVP5Cn68HzYy0HUFL6135R6LipPDDfRDo6tBDgICBqXy43F1FjhLzFYuj2+fkw+oE8JbQEQq/njDFcf6OWVclq357Fo0KyoI+fUT/JpmjyrjJH7N47OT57hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DHACGsc6; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-47666573242so439691cf.0
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 06:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744725103; x=1745329903; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2krD/FL4kAPkbUf20jwju49i4p5y6JZxMe+TikflV2I=;
        b=DHACGsc6t7m0aU7Se/sC3ToDlQaaPJC+3X4j6TtzEBUngYfrdpAAWwGLdXkDZ3xuoy
         TR3FRYe7XLgDAzBJmSLnf3TplMLbIKLKlmtDpOUv2z8Z1lg+d/uqRnOqxpgG8uW/Bkj4
         EkVkc23bZN7HIDsvbt1p6Cc4KT1RCHdOzZDLQajGy+eQpKwiuapYPpEh86jOmxfvcrrh
         7BD6bcNxcN7Z+pL0Lio1kKzjfYBtGZRLA8Oz/SC8Se9D6RM+Rz9KlfMGBblVNwZBPJlA
         ZAzmorHybW/jtwyAF9oesIv4ICPOI+zSW+iP3ivpR8VGSubrMS8s4xlf7CLEXdg9u3CK
         Mxug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744725103; x=1745329903;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2krD/FL4kAPkbUf20jwju49i4p5y6JZxMe+TikflV2I=;
        b=tvWrCwUOneywwTRML0gA8Ntd/HbQ3XrLlhz/PsdsxFa9NMj9mjv3ftLyY2o3ModRp4
         RQ/kxNrNd54HdVW8UjdSCPTulcSRWXaURlpvcdhqKKdCXAfV9E9iNckp8MdeGdLTKc+Y
         5tlI72KddFN7P6VfgAEjjDkJZ6he+iGBGUGTkveVyFSv+i7gxbcx68WfGsB0McuLq+eS
         lcE1vjRyaLrG1zGtHgC3LyA+/XpP3Q2dDT3TYkde4O03/nu5JKApuPJgZ7BEJEtOc2Wq
         KWp/V5T8KPzzQXtj4u80M5jmYDe4beOLLLw/G3P4FYIN6ordBpoEIvx/yU65z4YL+VmS
         Jymw==
X-Gm-Message-State: AOJu0YxJxacQD6NI3oQIBYMb0g58+bwqaCnDDocaPIEZoLZiigAvanqw
	n7WfFTpYpeSMGXh7F9fECxGdmfIystJkW0iHWV+7lXSJH1zrEwQJT0rk2/axryvGifhqoKGsgOU
	HyDoK2rLiMvFK2B56Bm0dzlkHBcshFjH64LkL
X-Gm-Gg: ASbGncvLODU6BHsrUtDBGJOr0nIhPch+3EXHCklj5frxt+MLZEFuoDycFN3Z1rZ6HMo
	37UquBr+N31qIK/XCJRjgCEo0bRpLvH87i8NIyWQYelKTIOH9+8Q8LipLxj4wmhDl04PD6PjvLP
	lIQKcYKSitiVrClYAC+8ueFAmaSsun8MrBQia49gjDAVSWBVUpQA==
X-Google-Smtp-Source: AGHT+IFA6OpbrhGV/+VCYom9qh0Ea+gMHW+k17zS5n0TQe4PsHbTdR3GAfcG6mdLxCddo/t0QnDz7jhYKdq546yAJoo=
X-Received: by 2002:ac8:7e91:0:b0:478:f8ac:8adf with SMTP id
 d75a77b69052e-47acac18fd5mr2766361cf.19.1744725102996; Tue, 15 Apr 2025
 06:51:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com> <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com> <CA+EHjTwjShH8vw-YsSmPk0yNY3akLFT3R9COtWLVgLozT_G7nA@mail.gmail.com>
 <103b8afc-96e3-4a04-b36c-9a8154296426@redhat.com>
In-Reply-To: <103b8afc-96e3-4a04-b36c-9a8154296426@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 15 Apr 2025 14:51:06 +0100
X-Gm-Features: ATxdqUF2fjyijejaIC1kw37vfGIKBpDqMF-_fucpkmSEaVbZaviAZd-hhsiO6bk
Message-ID: <CA+EHjTxuAE1N3NOngNGfZYxPb1AJPmrUR5vhHpv353YUjEgfRg@mail.gmail.com>
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
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
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Mon, 14 Apr 2025 at 20:42, David Hildenbrand <david@redhat.com> wrote:
>
> On 14.04.25 18:03, Fuad Tabba wrote:
> > Hi David,
> >
> > On Mon, 14 Apr 2025 at 12:51, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 18.03.25 17:18, Fuad Tabba wrote:
> >>> For VMs that allow sharing guest_memfd backed memory in-place,
> >>> handle that memory the same as "private" guest_memfd memory. This
> >>> means that faulting that memory in the host or in the guest will
> >>> go through the guest_memfd subsystem.
> >>>
> >>> Note that the word "private" in the name of the function
> >>> kvm_mem_is_private() doesn't necessarily indicate that the memory
> >>> isn't shared, but is due to the history and evolution of
> >>> guest_memfd and the various names it has received. In effect,
> >>> this function is used to multiplex between the path of a normal
> >>> page fault and the path of a guest_memfd backed page fault.
> >>>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    include/linux/kvm_host.h | 3 ++-
> >>>    1 file changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >>> index 601bbcaa5e41..3d5595a71a2a 100644
> >>> --- a/include/linux/kvm_host.h
> >>> +++ b/include/linux/kvm_host.h
> >>> @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>    #else
> >>>    static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>    {
> >>> -     return false;
> >>> +     return kvm_arch_gmem_supports_shared_mem(kvm) &&
> >>> +            kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
> >>>    }
> >>>    #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> >>>
> >>
> >> I've been thinking long about this, and was wondering if we should instead
> >> clean up the code to decouple the "private" from gmem handling first.
> >>
> >> I know, this was already discussed a couple of times, but faking that
> >> shared memory is private looks odd.
> >
> > I agree. I've been wanting to do that as part of a separate series,
> > since renaming discussions sometimes tend to take a disproportionate
> > amount of time.But the confusion the current naming (and overloading
> > of terms) is causing is probably worse.
>
> Exactly my thoughts. The cleanup diff I was able to come up with is not
> too crazy, so it feels feasible to just include the cleanups as a
> preparation for mmap() where we introduce the concept of shared memory
> in guest_memfd.
>
> >
> >>
> >> I played with the code to star cleaning this up. I ended up with the following
> >> gmem-terminology  cleanup patches (not even compile tested)
> >>
> >> KVM: rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
> >> KVM: rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
> >> KVM: rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
> >> KVM: x86: rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
> >> KVM: rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
> >> KVM: x86: generalize private fault lookups to "gmem" fault lookups
> >>
> >> https://github.com/davidhildenbrand/linux/tree/gmem_shared_prep
> >>
> >> On top of that, I was wondering if we could look into doing something like
> >> the following. It would also allow for pulling pages out of gmem for
> >> existing SW-protected VMs once they enable shared memory for GMEM IIUC.
> >>
> >>
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index 08eebd24a0e18..6f878cab0f466 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -4495,11 +4495,6 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
> >>    {
> >>           int max_order, r;
> >>
> >> -       if (!kvm_slot_has_gmem(fault->slot)) {
> >> -               kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> >> -               return -EFAULT;
> >> -       }
> >> -
> >>           r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
> >>                                &fault->refcounted_page, &max_order);
> >>           if (r) {
> >> @@ -4518,8 +4513,19 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
> >>                                    struct kvm_page_fault *fault)
> >>    {
> >>           unsigned int foll = fault->write ? FOLL_WRITE : 0;
> >> +       bool use_gmem = false;
> >> +
> >> +       if (fault->is_private) {
> >> +               if (!kvm_slot_has_gmem(fault->slot)) {
> >> +                       kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> >> +                       return -EFAULT;
> >> +               }
> >> +               use_gmem = true;
> >> +       } else if (kvm_slot_has_gmem_with_shared(fault->slot)) {
> >> +               use_gmem = true;
> >> +       }
> >>
> >> -       if (fault->is_private)
> >> +       if (use_gmem)
> >>                   return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
> >>
> >>           foll |= FOLL_NOWAIT;
> >>
> >>
> >> That is, we'd not claim that things are private when they are not, but instead
> >> teach the code about shared memory coming from gmem.
> >>
> >> There might be some more missing, just throwing it out there if I am completely off.
> >
> > For me these changes seem to be reasonable all in all. I might want to
> > suggest a couple of modifications, but I guess the bigger question is
> > what the KVM maintainers and guest_memfd's main contributors think.
>
> I'm afraid we won't get a reply before we officially send it ...
>
> >
> > Also, how do you suggest we go about this? Send out a separate series
> > first, before continuing with the mapping series? Or have it all as
> > one big series? It could be something to add to the agenda for
> > Thursday.
>
> ... and ideally it would be part of this series. After all, this series
> shrunk a bit :)

True, although Ackerley is working hard on adding more things on top
(mainly selftests though) :) That said, having multiple series
floating around was clearly not the way to go. So yes, this will be
part of this series.

> Feel free to use my commits when helpful: they are still missing
> descriptions and probably have other issues. Feel free to turn my SOB
> into a Co-developed-by+SOB and make yourself the author.
>
> Alternatively, let me know and I can polish them up and we can discuss
> what you have in mind (either here or elsewhere).
>
> I'd suggest we go full-steam on this series to finally get it over the
> finish line :)

Sure. I can take it over from here and bug you whenever I have any questions :)

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

