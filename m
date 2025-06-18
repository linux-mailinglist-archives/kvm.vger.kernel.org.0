Return-Path: <kvm+bounces-49838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0523ADE9CE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C3C23A2625
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7922BD593;
	Wed, 18 Jun 2025 11:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vfgw9/C6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26CB2857C2
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750245576; cv=none; b=FLkvN1Bme8ha240eddSumBuMp0NApG2EFIPOFgbRdOl9QOz3I8tweptPdfKWzvr9FQqHplhgSVkYyjwB/e88vvi0Si1wq5RR/500BS221ZVKoWwntVJdg6i7yCxP59OK7Ww/GSitmkxvNMFvIDp7Nbq6/7sC0XphD9TavaoMQik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750245576; c=relaxed/simple;
	bh=0IR0hShk8Q07HeRf2EB9YY8oHP7FmeM1TUGCrKonk8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pl0lNnZncPe6KsyNkoUSR1GKOCehFD+G+1DSl9zZjpFt0QixDskH7V/XQ7u/FOnbfCLqcKa0rP2BK80CekFf814CuznVlMtxhD8/n9HPCUz8Fdz1yqc2jH9NBtBWYWSyMwyfzD4VFpP2V38l5kxKDwA3cNRbPAZ4ueK4zGBpB6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vfgw9/C6; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4a58ef58a38so191241cf.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750245573; x=1750850373; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3yB1ftohp1puOBlWTqxnoWPi1PWP/0mUFv6bOJNZ7+k=;
        b=vfgw9/C6vmRZlAfoMY8NlUBQG/J9y8iX3mOR4x0UreH/yv6pCKHTwd8hfH6zQuMVZQ
         TK/egNZ6PGFZqhKQiJCV7UUDRJX6cQRXZfbXWKi8FHnYBU7j9Ft5wEbuQuCsGmgB79iy
         moU37mxoT3nba97vX0lGKPkdCLb8Q6+lf+UK+aRz4j8iEqS1nkqr6LS2LKxX4c6gdqxP
         1L1dDiZznPqZTs7JexCW+yv8ftqOsagmJn7HctUYaQ/da+YBsMcZvho/l4ugbVXt71RS
         LykBpsz3WTaRsJuUPDI116URMc6CJhnCuuIOZKWiZnH8jbFi1uNPpcXTj5QC+TijIFrL
         i7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750245573; x=1750850373;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yB1ftohp1puOBlWTqxnoWPi1PWP/0mUFv6bOJNZ7+k=;
        b=b+wZH/zhLTtOxhm/2CDOGvnVSmj4mlD6Dlz4L2Pczv65TfeipOZmJZNupa7kf3y1Ze
         np3eHkqpuWZap2z0YFeERLT+NxMTtnuE+Io3GVa+lrvwtnXAieHz80+YmWIBTWPB3i/Q
         yvTLHnUVnaufjkiibh28Nc1ejZB+Af1ng8JT2NLWNR4QowBUsuazvbVz30GUfAFNonz9
         kZpf1vrbT1H98+fZYrvEvR/g1uGTDfANzwhgSEsQ90KbUqKH5c5w3VP+TSiuyDBHibSr
         qGI2LVr6iorZF9dW54QVppi6W0vQV6z0INBYEbCJORGWajQ3NZWaDUdnYrRJFAhm3zw+
         gukQ==
X-Gm-Message-State: AOJu0YxytNLH0vHm7FkChX94BWj2bZj0XLuez8QSk3o8rrj1GXclJl9w
	B9Mi3Lr0BEeo3Bdn09Id3whGl7WbAdiJ5bgzmLm5Ef2xVHI1kG8x1fyct+42InQvqaQi81lECIP
	e6Db/mTUwPs0MulKfU0k9XjkzJ2ACH8Dd/Z1t5nVo
X-Gm-Gg: ASbGncv9kNFroP045YOi4Eztpk2h0UgoJh5+eB8DzdrPudLs/9cwfyGr+QjWlT4PePA
	mbrUHEZdsOPuDcjaeY7dCQjWs9uEaCILYIMIOvMWRyYGkT8WpTHsGoMxVb9BFct/GAcsvbVNBfm
	LRTozLlsxJD9+B9HRWibVCPtnWHJGTwaJ8s8iaY++OAYLp4dSyQqDDHYBkFbvzpZHYbrdqeAOb
X-Google-Smtp-Source: AGHT+IFNy4x/3H7O7jyWejFSqWdeZ6Ea8TtC6MlOzFQs2yjUO8Bu733uFJzgyDcZGNez1Afb34GqB53gQluIqJezIxs=
X-Received: by 2002:a05:622a:1a14:b0:471:f34d:1d83 with SMTP id
 d75a77b69052e-4a73f3c22bemr16220471cf.7.1750245573048; Wed, 18 Jun 2025
 04:19:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com> <CA+EHjTyO1tP1uiVkoReZxvV6h2VwfX+1qxBT15JcP3+AXdB8fA@mail.gmail.com>
 <aFH0dCiljueHeCSp@google.com>
In-Reply-To: <aFH0dCiljueHeCSp@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 18 Jun 2025 12:18:56 +0100
X-Gm-Features: Ac12FXyrCl-9Ny_0GAYMawsmQYg45XzzzDC9iXSf2yVZ9jCNzySkxZQL73EK2vM
Message-ID: <CA+EHjTwzkAHNZt4rQBgVRmADuY=kVSgXnssuCFT1AhBPc7Ce6w@mail.gmail.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Wed, 18 Jun 2025 at 00:04, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 16, 2025, Fuad Tabba wrote:
> > > > This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> > > > and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> > > > flag at creation time.
> > >
> > > Why?  I can see that from the patch.
> >
> > It's in the patch series, not this patch.
>
> Eh, not really.  It doesn't even matter how "Why?" is interpreted, because nothing
> in this series covers any of the reasonable interpretations to an acceptable
> degree.
>
> These are all the changelogs for generic changes
>
>  : This patch enables support for shared memory in guest_memfd, including
>  : mapping that memory from host userspace.
>  :
>  : This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
>  : and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
>  : flag at creation time.
>
>  : Add a new internal flag in the top half of memslot->flags to track when
>  : a guest_memfd-backed slot supports shared memory, which is reserved for
>  : internal use in KVM.
>  :
>  : This avoids repeatedly checking the underlying guest_memfd file for
>  : shared memory support, which requires taking a reference on the file.
>
> the small bit of documentation
>
>  +When the capability KVM_CAP_GMEM_SHARED_MEM is supported, the 'flags' field
>  +supports GUEST_MEMFD_FLAG_SUPPORT_SHARED.  Setting this flag on guest_memfd
>  +creation enables mmap() and faulting of guest_memfd memory to host userspace.
>  +
>  +When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>  +guest_memfd has the GUEST_MEMFD_FLAG_SUPPORT_SHARED set, then the fault will
>  +always be consumed from guest_memfd, regardless of whether it is a shared or a
>  +private fault.
>
> and the cover letter
>
>  : The purpose of this series is to allow mapping guest_memfd backed memory
>  : at the host. This support enables VMMs like Firecracker to run guests
>  : backed completely by guest_memfd [2]. Combined with Patrick's series for
>  : direct map removal in guest_memfd [3], this would allow running VMs that
>  : offer additional hardening against Spectre-like transient execution
>  : attacks.
>  :
>  : This series will also serve as a base for _restricted_ mmap() support
>  : for guest_memfd backed memory at the host for CoCos that allow sharing
>  : guest memory in-place with the host [4].
>
> None of those get remotely close to explaining the use cases in sufficient
> detail.
>
> Now, it's entirely acceptable, and in this case probably highly preferred, to
> link to the relevant use cases, e.g. as opposed to trying to regurgitate and
> distill a huge pile of information.
>
> But I want the _changelog_ to do the heavy lifting of capturing the most useful
> links and providing context.  E.g. to find the the motiviation for using
> guest_memfd to back non-CoCo VMs, I had to follow the [3] link to Patrick's
> series, then walk backwards through the versions of _that_ series, and eventually
> come across another link in Patrick's very first RFC:
>
>  : This RFC series is a rough draft adding support for running
>  : non-confidential compute VMs in guest_memfd, based on prior discussions
>  : with Sean [1].
>
> where [1] is the much more helpful:
>
>   https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
>
> Now, _I_ am obviously aware of most/all of the use cases and motiviations, but
> the changelog isn't just for people like me.  Far from it; the changelog is most
> useful for people that are coming in with _zero_ knowledge and context.  Finding
> the above link took me quite a bit of effort and digging (and to some extent, I
> knew what I was looking for), whereas an explicit reference in the changelog
> would (hopefully) take only the few seconds needed to read the blurb and click
> the link.
>
> My main argument for why you (and everyone else) should put significant effort
> into changelogs (and comments and documentation!) is very simple: writing and
> curating a good changelog (comment/documentation) is something the author does
> *once*.  If the author skimps out on the changelog, then *every* reader is having
> to do that same work *every* time they dig through this code.  We as a community
> come out far, far ahead in terms of developer time and understanding by turning a
> many-time cost into a one-time cost (and that's not even accounting for the fact
> that the author's one-time cost will like be a _lot_ smaller).
>
> There's obviously a balance to strike.  E.g. if the changelog has 50 links, that's
> probably going to be counter-productive for most readers.  In this case, 5-7-ish
> links with (very) brief contextual references is probably the sweet spot.
>
> > Would it help if I rephrase it along the lines of:
> >
> > This functionality isn't enabled until the introduction of the
> > KVM_GMEM_SHARED_MEM Kconfig option, and enabled for a given instance
> > by the GUEST_MEMFD_FLAG_SUPPORT_SHARED flag at creation time. Both of
> > which are introduced in a subsequent patch.
> >
> > > This changelog is way, way, waaay too light on details.  Sorry for jumping in at
> > > the 11th hour, but we've spent what, 2 years working on this?
> >
> > I'll expand this. Just to make sure that I include the right details,
> > are you looking for implementation details, motivation, use cases?
>
> Despite my lengthy response, none of the above?
>
> Use cases are good fodder for Documentation and the cover letter, and for *brief*
> references in the changelogs.  Implementation details generally don't need to be
> explained in the changelog, modulo notable gotchas and edge cases that are worth
> calling out.
>
> I _am_ looking for the motivation, but I suspect it's not the motivation you have
> in mind.  I'm not terribly concerned with why you want to implement this
> functionality; that should be easy to glean from the Documentation and use case
> links.
>
> The motivation I'm looking for is why you're adding CONFIG_KVM_GMEM_SHARED_MEM
> and GUEST_MEMFD_FLAG_SUPPORT_SHARED.
>
> E.g. CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES was added because it gates large swaths
> of code, uAPI, and a field we don't want to access "accidentally" (mem_attr_array),
> and because CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES has a hard dependency on
> CONFIG_KVM_GENERIC_MMU_NOTIFIER.
>
> For CONFIG_KVM_GMEM_SHARED_MEM, I'm just not seeing the motiviation.   It gates
> very little code (though that could be slightly changed by wrapping the mmap()
> and fault logic guest_memfd.c), and literally every use is part of a broader
> conditional.  I.e. it's effectively an optimization.
>
> Ha!  And it's actively buggy.  Because this will allow shared gmem for DEFAULT_VM,
>
>         #define kvm_arch_supports_gmem_shared_mem(kvm)                  \
>         (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
>          ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
>           (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>
> but only if CONFIG_KVM_SW_PROTECTED_VM is selected.  That makes no sense.  And
> that changelog is also sorely lacking.  It covers the what, but that's quite
> useless, because I can very easily see the what from the code.  By covering the
> "why" in the changelog, (hopefully) you would have come to the same conclusion
> that selecting KVM_GMEM_SHARED_MEM iff KVM_SW_PROTECTED_VM is enabled doesn't
> make any sense (because you wouldn't have been able to write a sane justification).
>
> Or, if it somehow does make sense, i.e. if I'm missing something, then that
> absolutely needs to in the changelog!
>
>  : Define the architecture-specific macro to enable shared memory support
>  : in guest_memfd for ordinary, i.e., non-CoCo, VM types, specifically
>  : KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
>  :
>  : Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
>  : enabled.
>
>
> As for GUEST_MEMFD_FLAG_SUPPORT_SHARED, after digging through the code, I _think_
> the reason we need a flag is so that KVM knows to completely ignore the HVA in
> the memslot.  (a) explaining that (again, for future readers) would be super
> helpful, and (b) if there is other motiviation for a per-guest_memfd opt-in, then
> _that_ is also very interesting.
>
> And for (a), bonus points if you explain why it's a GUEST_MEMFD flag, e.g. as
> opposed to a per-VM capability or per-memslot flag.  (Though this may be self-
> evident to any readers that understand any of this, so definitely optional).

I think I see where you're going. I'll try to improve the changelogs
when I respin.

> > > So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
> > > KVM_MEMSLOT_GUEST_MEMFD_ONLY.  That will make code like this:
> > >
> > >         if (kvm_slot_has_gmem(slot) &&
> > >             (kvm_gmem_memslot_supports_shared(slot) ||
> > >              kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> > >                 return kvm_gmem_max_mapping_level(slot, gfn, max_level);
> > >         }
> > >
> > > much more intutive:
> > >
> > >         if (kvm_is_memslot_gmem_only(slot) ||
> > >             kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE))
> > >                 return kvm_gmem_max_mapping_level(slot, gfn, max_level);
> > >
> > > And then have kvm_gmem_mapping_order() do:
> > >
> > >         WARN_ON_ONCE(!kvm_slot_has_gmem(slot));
> > >         return 0;
> >
> > I have no preference really. To me this was intuitive, but I guess I
> > have been staring at this way too long.
>
> I agree that SHARED is intuitive for the pKVM use case (and probably all CoCo use
> cases).  My objection with the name is that it's misleading/confusing for non-CoCo
> VMs (at least for me), and that using SHARED could unnecessarily paint us into a
> corner.
>
> Specifically, if there are ever use cases where guest memory is shared between
> entities *without* mapping guest memory into host userspace, then we'll be a bit
> hosed.  Though as is tradition in KVM, I suppose we could just call it
> GUEST_MEMFD_FLAG_SUPPORT_SHARED2 ;-)
>
> Regarding CoCo vs. non-CoCo intuition, it's easy enough to discern that
> GUEST_MEMFD_FLAG_MAPPABLE is required to do in-place sharing with host userspace.
>
> But IMO it's not easy to glean that GUEST_MEMFD_FLAG_SUPPORT_SHARED is a
> effectively a hard requirement for non-CoCo x86 VMs purely because because many
> flows in KVM x86 will fail miserable if KVM can't access guest memory via uaccess,
> i.e. if guest memory isn't mapped by host userspace.  In other words, it's as much
> about working within KVM's existing design (and not losing support for a wide
> swath of features) as it is about "sharing" guest memory with host userspace.

I'll defer answering that to the next email...

/fuad

