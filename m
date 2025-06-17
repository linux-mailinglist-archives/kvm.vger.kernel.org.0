Return-Path: <kvm+bounces-49772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43498ADDF5E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A0F83A6DB2
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59AA295D85;
	Tue, 17 Jun 2025 23:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VzVkNMy/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5236E23C8B3
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 23:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750201465; cv=none; b=C45exs/Xa006FuqJ80lr9qWiuwHZ3fW3tv3it3YivLDtKC/9mPlOkjXe1DNkqRgrqKlpS4pjbbBC1CO8HWXqb6WH3fifLBRgjjGLR2n1d/Biu8EIbuUgb76+8d73MzUAex1GzbkKWZ8mqL9D++MQbjbV2QAKoJ3IrUMDNUH+vX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750201465; c=relaxed/simple;
	bh=DAUGI2b4KSnbBqTIHce0KoJzKX3wZvvFonPg4hEBRXo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GpF7CRtYysJCFa+1xYd+0r2xkqTmAygtT9J5XjluQECQRZdAsz34qOIFUWBhpnSqN7ZSuhzys9MtVDmdV+P7ko9zZiiUzrC+6KrxaB2SRDgdCF77DA5/SuVKEJTtgJJcVa0G8sSArw6gfFSgT7mhg58wEMIcOvpeYkuaAV+vi20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VzVkNMy/; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31c487e1cbso361111a12.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750201462; x=1750806262; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/tem/Oj65mDZW3F8dnqgKub+e0lAt/02xk0azpbrDCA=;
        b=VzVkNMy/u8zgGb7SrdeENcmnWHnSLLSzOnoVHtS1Dg/1FPV/YmiHW1S4YjRGf3Xknu
         sR6UyfDNojE2WXgZWU7DOA4V4WceJQBsdGA0nNO9OYGGs2C35nWpfq805hid0iiJDifE
         cUxSu2fS8h55bJVtq/BX/JiKYCf+LSw9fqMQW85on783Es2ZSu1/IUZ+zlXm83wv8Dj7
         /AZFpgwDWgZLpJaPrvPH8MPCv2iY3MuAQysH/Tiph8ui6QoEMPakPixtHDIJDWnbqdFd
         rBkIB5xGKu+Q1okGVQG6FZf0UjzgrQX+APftWoptHun5znH0MF+4MTuScTPFpamx00wC
         inkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750201462; x=1750806262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/tem/Oj65mDZW3F8dnqgKub+e0lAt/02xk0azpbrDCA=;
        b=UZa4j9AcKOHeIVC7+XG5MWDXVHwA6RNFuHakcqScTA5f5WRpvfO92+5uI0lUWqitzk
         qLLRrny37FMW8611OyAmaYPJXTciqIpKPz70bYpqFvIyGuuGydFEt91UJB6zO7E6SdYy
         zD/GbEk1nbyRbi4DCC+m2bI4R+hTNkHu7UrVJxzoyw7amnYR/aW84SulBIwD7NXFfgMz
         g9//Lt7DbB3BiR5coWhefaVmF+KRp8CDIQ/Yg52hkOrP0QUGRl8SmYVpSzY+cW1vYOnC
         dpSjG+tKiR4x3SpjtWYIW//9u22quGH/G/pEZSdxn2aFt99kNwsGHjgHZ8x383rPZp9c
         wznQ==
X-Gm-Message-State: AOJu0YzhBDfLZ1GtYcFLNEkaUW+03bAfDOQSKX12e6xGTJxzbVsb8cOQ
	519OkMHct3IrRm5DJUHwfkO+JtOogLm6UVgQelLB+ViUdWQgblufdxmy2cORvPdi7FAn0mYA75V
	vNBRuwg==
X-Google-Smtp-Source: AGHT+IGlHtTDVPsIhI+DnD6CJDKQTP45GiniTvR7AE4xYmzNu370nEenw4x78vw81rW/PEygPTFeV6quH6U=
X-Received: from pfxa17.prod.google.com ([2002:a05:6a00:1d11:b0:73e:665:360])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:b8b:b0:1f3:33c2:29c5
 with SMTP id adf61e73a8af0-21fbd559187mr23328797637.7.1750201462122; Tue, 17
 Jun 2025 16:04:22 -0700 (PDT)
Date: Tue, 17 Jun 2025 16:04:20 -0700
In-Reply-To: <CA+EHjTyO1tP1uiVkoReZxvV6h2VwfX+1qxBT15JcP3+AXdB8fA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com> <CA+EHjTyO1tP1uiVkoReZxvV6h2VwfX+1qxBT15JcP3+AXdB8fA@mail.gmail.com>
Message-ID: <aFH0dCiljueHeCSp@google.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
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
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 16, 2025, Fuad Tabba wrote:
> > > This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> > > and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> > > flag at creation time.
> >
> > Why?  I can see that from the patch.
> 
> It's in the patch series, not this patch.

Eh, not really.  It doesn't even matter how "Why?" is interpreted, because nothing
in this series covers any of the reasonable interpretations to an acceptable
degree.

These are all the changelogs for generic changes

 : This patch enables support for shared memory in guest_memfd, including
 : mapping that memory from host userspace.
 : 
 : This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
 : and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
 : flag at creation time.

 : Add a new internal flag in the top half of memslot->flags to track when
 : a guest_memfd-backed slot supports shared memory, which is reserved for
 : internal use in KVM.
 : 
 : This avoids repeatedly checking the underlying guest_memfd file for
 : shared memory support, which requires taking a reference on the file.

the small bit of documentation

 +When the capability KVM_CAP_GMEM_SHARED_MEM is supported, the 'flags' field
 +supports GUEST_MEMFD_FLAG_SUPPORT_SHARED.  Setting this flag on guest_memfd
 +creation enables mmap() and faulting of guest_memfd memory to host userspace.
 +
 +When the KVM MMU performs a PFN lookup to service a guest fault and the backing
 +guest_memfd has the GUEST_MEMFD_FLAG_SUPPORT_SHARED set, then the fault will
 +always be consumed from guest_memfd, regardless of whether it is a shared or a
 +private fault.

and the cover letter

 : The purpose of this series is to allow mapping guest_memfd backed memory
 : at the host. This support enables VMMs like Firecracker to run guests
 : backed completely by guest_memfd [2]. Combined with Patrick's series for
 : direct map removal in guest_memfd [3], this would allow running VMs that
 : offer additional hardening against Spectre-like transient execution
 : attacks.
 : 
 : This series will also serve as a base for _restricted_ mmap() support
 : for guest_memfd backed memory at the host for CoCos that allow sharing
 : guest memory in-place with the host [4].

None of those get remotely close to explaining the use cases in sufficient
detail.

Now, it's entirely acceptable, and in this case probably highly preferred, to
link to the relevant use cases, e.g. as opposed to trying to regurgitate and
distill a huge pile of information.

But I want the _changelog_ to do the heavy lifting of capturing the most useful
links and providing context.  E.g. to find the the motiviation for using
guest_memfd to back non-CoCo VMs, I had to follow the [3] link to Patrick's
series, then walk backwards through the versions of _that_ series, and eventually
come across another link in Patrick's very first RFC:

 : This RFC series is a rough draft adding support for running
 : non-confidential compute VMs in guest_memfd, based on prior discussions
 : with Sean [1].

where [1] is the much more helpful:

  https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com

Now, _I_ am obviously aware of most/all of the use cases and motiviations, but
the changelog isn't just for people like me.  Far from it; the changelog is most
useful for people that are coming in with _zero_ knowledge and context.  Finding
the above link took me quite a bit of effort and digging (and to some extent, I
knew what I was looking for), whereas an explicit reference in the changelog
would (hopefully) take only the few seconds needed to read the blurb and click
the link.

My main argument for why you (and everyone else) should put significant effort
into changelogs (and comments and documentation!) is very simple: writing and
curating a good changelog (comment/documentation) is something the author does
*once*.  If the author skimps out on the changelog, then *every* reader is having
to do that same work *every* time they dig through this code.  We as a community
come out far, far ahead in terms of developer time and understanding by turning a
many-time cost into a one-time cost (and that's not even accounting for the fact
that the author's one-time cost will like be a _lot_ smaller).

There's obviously a balance to strike.  E.g. if the changelog has 50 links, that's
probably going to be counter-productive for most readers.  In this case, 5-7-ish
links with (very) brief contextual references is probably the sweet spot.

> Would it help if I rephrase it along the lines of:
> 
> This functionality isn't enabled until the introduction of the
> KVM_GMEM_SHARED_MEM Kconfig option, and enabled for a given instance
> by the GUEST_MEMFD_FLAG_SUPPORT_SHARED flag at creation time. Both of
> which are introduced in a subsequent patch.
> 
> > This changelog is way, way, waaay too light on details.  Sorry for jumping in at
> > the 11th hour, but we've spent what, 2 years working on this?
> 
> I'll expand this. Just to make sure that I include the right details,
> are you looking for implementation details, motivation, use cases?

Despite my lengthy response, none of the above?

Use cases are good fodder for Documentation and the cover letter, and for *brief*
references in the changelogs.  Implementation details generally don't need to be
explained in the changelog, modulo notable gotchas and edge cases that are worth
calling out.

I _am_ looking for the motivation, but I suspect it's not the motivation you have
in mind.  I'm not terribly concerned with why you want to implement this
functionality; that should be easy to glean from the Documentation and use case
links.

The motivation I'm looking for is why you're adding CONFIG_KVM_GMEM_SHARED_MEM
and GUEST_MEMFD_FLAG_SUPPORT_SHARED.

E.g. CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES was added because it gates large swaths
of code, uAPI, and a field we don't want to access "accidentally" (mem_attr_array),
and because CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES has a hard dependency on
CONFIG_KVM_GENERIC_MMU_NOTIFIER.

For CONFIG_KVM_GMEM_SHARED_MEM, I'm just not seeing the motiviation.   It gates
very little code (though that could be slightly changed by wrapping the mmap()
and fault logic guest_memfd.c), and literally every use is part of a broader
conditional.  I.e. it's effectively an optimization.

Ha!  And it's actively buggy.  Because this will allow shared gmem for DEFAULT_VM,

	#define kvm_arch_supports_gmem_shared_mem(kvm)			\
	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))

but only if CONFIG_KVM_SW_PROTECTED_VM is selected.  That makes no sense.  And
that changelog is also sorely lacking.  It covers the what, but that's quite
useless, because I can very easily see the what from the code.  By covering the
"why" in the changelog, (hopefully) you would have come to the same conclusion
that selecting KVM_GMEM_SHARED_MEM iff KVM_SW_PROTECTED_VM is enabled doesn't
make any sense (because you wouldn't have been able to write a sane justification).

Or, if it somehow does make sense, i.e. if I'm missing something, then that
absolutely needs to in the changelog!

 : Define the architecture-specific macro to enable shared memory support
 : in guest_memfd for ordinary, i.e., non-CoCo, VM types, specifically
 : KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
 : 
 : Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
 : enabled.


As for GUEST_MEMFD_FLAG_SUPPORT_SHARED, after digging through the code, I _think_
the reason we need a flag is so that KVM knows to completely ignore the HVA in
the memslot.  (a) explaining that (again, for future readers) would be super
helpful, and (b) if there is other motiviation for a per-guest_memfd opt-in, then
_that_ is also very interesting.

And for (a), bonus points if you explain why it's a GUEST_MEMFD flag, e.g. as
opposed to a per-VM capability or per-memslot flag.  (Though this may be self-
evident to any readers that understand any of this, so definitely optional).

> > So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
> > KVM_MEMSLOT_GUEST_MEMFD_ONLY.  That will make code like this:
> >
> >         if (kvm_slot_has_gmem(slot) &&
> >             (kvm_gmem_memslot_supports_shared(slot) ||
> >              kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> >                 return kvm_gmem_max_mapping_level(slot, gfn, max_level);
> >         }
> >
> > much more intutive:
> >
> >         if (kvm_is_memslot_gmem_only(slot) ||
> >             kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE))
> >                 return kvm_gmem_max_mapping_level(slot, gfn, max_level);
> >
> > And then have kvm_gmem_mapping_order() do:
> >
> >         WARN_ON_ONCE(!kvm_slot_has_gmem(slot));
> >         return 0;
> 
> I have no preference really. To me this was intuitive, but I guess I
> have been staring at this way too long.

I agree that SHARED is intuitive for the pKVM use case (and probably all CoCo use
cases).  My objection with the name is that it's misleading/confusing for non-CoCo
VMs (at least for me), and that using SHARED could unnecessarily paint us into a
corner.

Specifically, if there are ever use cases where guest memory is shared between
entities *without* mapping guest memory into host userspace, then we'll be a bit
hosed.  Though as is tradition in KVM, I suppose we could just call it
GUEST_MEMFD_FLAG_SUPPORT_SHARED2 ;-)

Regarding CoCo vs. non-CoCo intuition, it's easy enough to discern that
GUEST_MEMFD_FLAG_MAPPABLE is required to do in-place sharing with host userspace.

But IMO it's not easy to glean that GUEST_MEMFD_FLAG_SUPPORT_SHARED is a
effectively a hard requirement for non-CoCo x86 VMs purely because because many
flows in KVM x86 will fail miserable if KVM can't access guest memory via uaccess,
i.e. if guest memory isn't mapped by host userspace.  In other words, it's as much
about working within KVM's existing design (and not losing support for a wide
swath of features) as it is about "sharing" guest memory with host userspace.

