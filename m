Return-Path: <kvm+bounces-51763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4598AFCC60
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C623B162E86
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 13:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8471A2DE718;
	Tue,  8 Jul 2025 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ej6ZND6c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com [209.85.160.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB232AF07
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751982270; cv=none; b=Guu1dFv7bMuU7LGX0fCgBnVQzhPhCYPr8Rnar/HWzilsNH0K9yiCi+bM6XBR0Ar12X86h65BiEaOrqit6Wj8BYHRhUrViFkWLS8A2BrN5jQXhEDMDkRUbjLnhrTW2g13jwBecB5AmDwqyIreJpvBXGeENs36qnaj7xFSkA6KgjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751982270; c=relaxed/simple;
	bh=lT4bc9A4Lsn0nqUVzgXK7Wed3GJo0r97SeIaG5Tr1VE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b8iLoAxnAuUi7qEF7tuv9ew+72bJNJwp/PK74UgQfyAauP4RN5vihUcNxJKgPsqARerj655XAOKXXHDCmq7OTSrcO0IEPeOGXH0NrLQBfWfAh/VqzLl9VajUgTowgL9f4skUK8Wo6clTLNtqyUr56slqx0oFg9dx6AJbKz6OM+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ej6ZND6c; arc=none smtp.client-ip=209.85.160.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-qt1-f201.google.com with SMTP id d75a77b69052e-4a442d07c5fso92449301cf.3
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 06:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751982268; x=1752587068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uhhghHOWkTnR0hLVF1kHakjup/7Sho01+bx/DM99C1g=;
        b=Ej6ZND6cR0rpli2RYQJDtHo4+rY27U2PkXSIkHstRtDUUjcLV35nI0eQbN0zs+rsAZ
         Zftzw8OenQNV+WTVLnFKYll+OpbB3T5hD54IbZK6cX6akkfksgRw4yuPnALTsjDcoQnD
         JXx9oDvfY3gclQWgJCWwCIyoZfTQO/cNXxoQxvtR7W3OpR71JtQIfzDJ1gABry+aHyaL
         tncbvFAlEudhCvSF5RDcq9z5SASWjc9SXc/9kfDSaWwika+nuY/PlGZt0IwsGKkP6DAJ
         uSUDcrpIfsv8VPYon/U7ZJfuDZugce9EQMOWV6xEGCdoXHH97hChYH/0t4jGUCT1Q1yz
         q+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751982268; x=1752587068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uhhghHOWkTnR0hLVF1kHakjup/7Sho01+bx/DM99C1g=;
        b=d8/+4SeAhBIfAGQKoO7nogXi7SrTlOIa7VbkAmvhA2UQF5f/nNwAqq7JPNNz+hutU4
         qpR/w4DFKitDA/RDGDCklcgF9/nf3e749uE4/x5Md5DiR3Tt64ATZSdujcwKZ/AkYqMB
         ih3zT/vBrMI8VYAIck+RBmOFORzUfbaZ8fJnvLNhRGXztMyyhN7UL/+x+9lY1K5GZvS/
         WpkmU6PpstaxaUluTQ26rVyc8TWXMwMzklNQ+bsr+GB/OrD27VE1XopReYehoz/UicXH
         cyTDL9DcwmnIKRDPIz7QdzP+ce8JiVZQQG956zjqy5jz7P/XrsZHaj1DiBEfFPyc+aKy
         Fnyw==
X-Forwarded-Encrypted: i=1; AJvYcCU/9/wQpaFvtZ9hAWKq09OHr6o3lt8zv+Bi0frQzpFtqii5JI1MnGQ1OQVzT0NeWqLKx/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL6CzIFAV1cOK1FBOymza4gpgo67J4v7bZZmeGkeJ5FK+Lupxc
	uCa1w35LE/J+T3oHIOnI72kz6ItkVnLOg8yRDCfnwZiTzwwZ1cmv1pQY3AjxxJGog3GwhRUNaam
	yAWPZiDFXdinNDi4GB2TIpWhDXQ==
X-Google-Smtp-Source: AGHT+IG8mP9gY5/bBz/PPDZ950yjoWSdMml7V++iKYK1MlN+GfOj+Ia3LLbhfTBv0RJYHh5T/kuJRSivcI5DQlUR2Q==
X-Received: from pjvf5.prod.google.com ([2002:a17:90a:da85:b0:311:a879:981f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ec2:b0:311:fde5:c4be with SMTP id 98e67ed59e1d1-31aac544158mr19610623a91.35.1751982256358;
 Tue, 08 Jul 2025 06:44:16 -0700 (PDT)
Date: Tue, 08 Jul 2025 06:44:14 -0700
In-Reply-To: <aGxgywrqiPAV7ruh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aEyhHgwQXW4zbx-k@google.com> <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com> <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
 <diqzv7odjnln.fsf@ackerleytng-ctop.c.googlers.com> <CA+EHjTwqOwO2zVd4zTYF7w7reTWMNjmCV6XnKux2JtPwYCAoZQ@mail.gmail.com>
 <434ab5a3-fedb-4c9e-8034-8f616b7e5e52@amd.com> <923b1c02-407a-4689-a047-dd94e885b103@redhat.com>
 <diqz34bg575i.fsf@ackerleytng-ctop.c.googlers.com> <0cdc7890-aade-4fa5-ad72-24cde6c7bce9@redhat.com>
 <aGxgywrqiPAV7ruh@google.com>
Message-ID: <diqzqzyqyez5.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, David Hildenbrand <david@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
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

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jul 01, 2025, David Hildenbrand wrote:
>> > > > I support this approach.
>> > > 
>> > > Agreed. Let's get this in with the changes requested by Sean applied.
>> > > 
>> > > How to use GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM with
>> > > legacy mem attributes (-> all memory in guest_memfd private) could be
>> > > added later on top, once really required.
>> > > 
>> > > As discussed, CoCo VMs that want to support GUEST_MEMFD_FLAG_MMAP will
>> > > have to disable legacy mem attributes using a new capability in stage-2.
>> > > 
>> > 
>> > I rewatched the guest_memfd meeting on 2025-06-12.  We do want to
>> > support the use case where userspace wants to have mmap (e.g. to set
>> > mempolicy) but does not want to allow faulting into the host.
>> > 
>> > On 2025-06-12, the conclusion was that the problem will be solved once
>> > guest_memfd supports shareability, and that's because userspace can set
>> > shareability to GUEST, so the memory can't be faulted into the host.
>> > 
>> > On 2025-06-26, Sean said we want to let userspace have an extra layer of
>> > protection so that memory cannot be faulted in to the host, ever. IOW,
>> > we want to let userspace say that even if there is a stray
>> > private-to-shared conversion, *don't* allow faulting memory into the
>> > host.
>
> Eh, my comments were more along the lines of "it would be nice if we could have
> such protections", not a "we must support this".  And I suspect that making the
> behavior all-or-nothing for a given guest_memfd wouldn't be very useful, i.e.
> that userspace would probably want to be able to prevent accessing a specific
> chunk of the gmem instance.
>
> Actually, we can probably get that via mseal(), maybe even for free today?  E.g.
> mmap() w/ PROT_NONE, mbind(), and then mseal().
>
> So yeah, I think we do nothing for now.
>
>> > The difference is the "extra layer of protection", which should remain
>> > in effect even if there are (stray/unexpected) private-to-shared
>> > conversions to guest_memfd or to KVM. Here's a direct link to the point
>> > in the video where Sean brought this up [1]. I'm really hoping I didn't
>> > misinterpret this!
>> > 
>> > Let me look ahead a little, since this involves use cases already
>> > brought up though I'm not sure how real they are. I just want to make
>> > sure that in a few patch series' time, we don't end up needing userspace
>> > to use a complex bunch of CAPs and FLAGs.
>> > 
>> > In this series (mmap support, V12, patch 10/18) [2], to allow
>> > KVM_X86_DEFAULT_VMs to use guest_memfd, I added a `fault_from_gmem()`
>> > helper, which is defined as follows (before the renaming Sean requested):
>> > 
>> > +static inline bool fault_from_gmem(struct kvm_page_fault *fault)
>> > +{
>> > +	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
>> > +}
>> > 
>> > The above is changeable, of course :). The intention is that if the
>> > fault is private, fault from guest_memfd. If GUEST_MEMFD_FLAG_MMAP is
>> > set (KVM_MEMSLOT_GMEM_ONLY will be set on the memslot), fault from
>> > guest_memfd.
>> > 
>> > If we defer handling GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM
>> > with legacy mem attributes to the future, this helper will probably
>> > become
>> > 
>> > -static inline bool fault_from_gmem(struct kvm_page_fault *fault)
>> > +static inline bool fault_from_gmem(struct kvm *kvm, struct kvm_page_fault *fault)
>> > +{
>> > -	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
>> > +	return fault->is_private || (kvm_gmem_memslot_supports_shared(fault->slot) &&
>> > +	                             !kvm_arch_disable_legacy_private_tracking(kvm));
>> > +}
>> > 
>> > And on memslot binding we check
>> > 
>> > if kvm_arch_disable_legacy_private_tracking(kvm)
>
> I would invert the KVM-internal arch hook, and only have KVM x86's capability refer
> to the private memory attribute as legacy (because it simply doesn't exist for
> any thing else).
>
>> > and not GUEST_MEMFD_FLAG_MMAP
>> > 	return -EINVAL;
>> > 
>> > 1. Is that what yall meant?
>
> I was thinking:
>
> 	if (kvm_arch_has_private_memory_attribute(kvm) ==
> 	    kvm_gmem_mmap(...))
> 		return -EINVAL;
>
> I.e. in addition to requiring mmap() when KVM doesn't track private/sahred via
> memory attributes, also disallow mmap() when private/shared is tracked via memory
> attributes.
>
>> My understanding:
>> 
>> CoCo VMs will initially (stage-1) only support !GUEST_MEMFD_FLAG_MMAP.
>> 
>> With stage-2, CoCo VMs will support GUEST_MEMFD_FLAG_MMAP only with
>> kvm_arch_disable_legacy_private_tracking().
>
> Yep, and everything except x86 will unconditionally return true for
> kvm_arch_disable_legacy_private_tracking() (or false if it's inverted as above).
>
>> Non-CoCo VMs will only support GUEST_MEMFD_FLAG_MMAP. (no concept of
>> private)
>> 
>> > 
>> > 2. Does this kind of not satisfy the "extra layer of protection"
>> >     requirement (if it is a requirement)?
>
> It's not a requirement.
>
>> >     A legacy CoCo VM using guest_memfd only for private memory (shared
>> >     memory from say, shmem) and needing to set mempolicy would
>> >     * Set GUEST_MEMFD_FLAG_MMAP
>
> I think we should keep it simple as above, and not support mmap() (and therefore
> mbind()) with legacy CoCo VMs.  Given the double allocation flaws with the legacy
> approach, supporting mbind() seems like putting a bandaid on a doomed idea.
>
>> >     * Leave KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaulted to false
>> >     but still be able to send conversion ioctls directly to guest_memfd,
>> >     and then be able to fault guest_memfd memory into the host.
>> 
>> In that configuration, I would expect that all memory in guest_memfd is
>> private and remains private.
>> 
>> guest_memfd without memory attributes cannot support in-place conversion.
>> 
>> How to achieve that might be interesting: the capability will affect
>> guest_memfd behavior?
>> 
>> > 
>> > 3. Now for a use case I've heard of (feel free to tell me this will
>> >     never be supported or "we'll deal with it if it comes"): On a
>> >     non-CoCo VM, we want to use guest_memfd but not use mmap (and the
>> >     initial VM image will be written using write() syscall or something
>> >     else).
>> > 
>> >     * Set GUEST_MEMFD_FLAG_MMAP to false
>> >     * Leave KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaulted to false
>> >       (it's a non-CoCo VM, weird to do anything to do with private
>> >       tracking)
>> > 
>> >     And now we're stuck because fault_from_gmem() will return false all
>> >     the time and we can't use memory from guest_memfd.
>
> Nah, don't support this scenario.  Or rather, use mseal() as above.  If someone
> comes along with a concrete, strong use case for backing non-CoCo VMs and using
> mseal() to wall off guest memory doesn't suffice, then they can have the honor
> of justifying why KVM needs to take on more complexity.  :-)
>
>> I think I discussed that with Sean: we would have GUEST_MEMFD_FLAG_WRITE
>> that will imply everything that GUEST_MEMFD_FLAG_MMAP would imply, except
>> the actual mmap() support.
>
> Ya, for the write() access or whatever.  But there are bigger problems beyond
> populating the memory, e.g. a non-CoCo VM won't support private memory, so without
> many more changes to redirect KVM to gmem when faulting in guest memory, KVM won't
> be able to map any memory into the guest.

Thanks for clarifying everything above :). Next respin (with Fuad's
help) coming soon!

