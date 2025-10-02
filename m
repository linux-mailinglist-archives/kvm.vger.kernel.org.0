Return-Path: <kvm+bounces-59379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 335DEBB2298
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 02:42:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4B8E3C809B
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 00:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EED672628;
	Thu,  2 Oct 2025 00:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ld5pgPXA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C2128FD
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 00:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759365762; cv=none; b=jj1TR4mySyOFK2R1qCgiUsdX+b5DJ55fWxOtUzr2Ha7CKlHpMMWPt3JhWi/XINJvgMXnQYHk0rmHQ6AVObQlibjoV7ldZinzSlpKzgI2b6ZsoH+E9nZqbEIzeLM+EEMkfVH1XrcfUeU5RphdE1sS/pOQTSIVFzkyj/0RyyPwUqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759365762; c=relaxed/simple;
	bh=X15PQgHkJVKwkb88PX3aDM2MIy3nCGxR8WbDTZfxuT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j2+Kcly7JNGi+rqW0HPmyN6N4TXkM85/VbN2vNCEO4n6pRNJA1U5sYCqX+KVX7/0rEaSN0tijO5EzpvcGkFNbKNHlp/V+8RCAh+XkLJTn+UrMdbQARLR5wH7yvuAfrz37BFczHMvS/7tc5+ZTnAwNaKnvv+DospXTf1kbaELWlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ld5pgPXA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so416354a91.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 17:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759365760; x=1759970560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vINZJTC9nZWgB4cyQg89PRYIAJ8j/OCjZLjXorvYxPs=;
        b=Ld5pgPXASWb0egYq1uML5N3rBalK4THySe8fkb8cgjDusdn3V00h+wkzi8ylau343X
         WkWSOwLqvM6CIu0xyyWYl6MQM2zanUxltIytHxNWImdB179Kk2lcQOGYvRDtUCIjth5a
         JlznDkG+muykNkjYvaeSfkCVD69RAA2xQqPtIlQaLf7Xe/Ke1ukV2ddtYXqa9fLo1W79
         RnWeP9N+bG13VftHfScDdKieBEVKe5MpaMiFfRyT1vV83aoFKJs5n4VVNnk9DssgiZg7
         eRkk81oC0QNh95wAJoADAntiqz/S5VEsS5jgLKsxSNjGssQu7fbDQwS8We2kvwc8L5gH
         RYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759365760; x=1759970560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vINZJTC9nZWgB4cyQg89PRYIAJ8j/OCjZLjXorvYxPs=;
        b=UQ1P0exyZS2UtFzShL5vqmcLGcr4koDMeylKYv/fJGweFLNwSL0oI293TmXnXvsExJ
         nfO6eY0dxRgH1pDm36u9i0sJKZQMz603/qPELNcxCxo8CRL2tKjGcc4ycMy8HCK5+IEU
         SY0+TTpLRPKyxOOI6b5HgHLHNzz7eJ/EdL5VHcGuRBEigz8GEiOoF5+ZzwvG4VfXvtJF
         /VpM/J96LMCu6pBwOeeq3Yn00iVpIE+1jLg8PYFCI+2NsZe/d3hAo0rZ+vO5adKuP1AB
         p4yCUpgcRfF8KN5AFZteIdbnU84UvlkOeHKvmI0Mqfid/fF0YowuXPHzBgX6CewZiDes
         h3yg==
X-Gm-Message-State: AOJu0YzX17Y9uhXE12twOInW2bYxLqWK4zHMGuTl8L/wCPD9tnwd9Z/3
	3Od6mNK2AIXRmXsnW3eSdv8YLs4MTYq/qhEIukFbtbnPW/7PNY7ocdkIovwRzburhPYSSAxmkc5
	GI8cgBQ==
X-Google-Smtp-Source: AGHT+IHoSZkKiGXCyrNz5rnlYg519w6ZS4TwYwBc53oulAbHVsuUB3NVS1fQkS/tQ5r3xuGxS+0gJGHXmyI=
X-Received: from pjyp4.prod.google.com ([2002:a17:90a:e704:b0:32b:65c6:661a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7d0:b0:330:6d2f:1b5d
 with SMTP id 98e67ed59e1d1-339a6f5b61amr6344256a91.26.1759365759828; Wed, 01
 Oct 2025 17:42:39 -0700 (PDT)
Date: Wed, 1 Oct 2025 17:42:38 -0700
In-Reply-To: <diqz1pnmtg4h.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <diqzbjmrt000.fsf@google.com>
 <aN1bXOg3x0ZdTI1D@google.com> <diqz1pnmtg4h.fsf@google.com>
Message-ID: <aN3KfrWERpXsj3ld@google.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 01, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> >> I'd prefer not to have the module param choose between the use of
> >> mem_attr_array and guest_memfd conversion in case we need both
> >> mem_attr_array to support other stuff in future while supporting
> >> conversions.
> >
> > Luckily, we don't actually need to make a decision on this, because PRIVATE is
> > the only attribute that exists.  Which is partly why I want to go with a module
> > param.  We can make the behavior very definitive without significant risk of
> > causing ABI hell.
> >
> 
> Then maybe I'm misunderstanding the static_call() thing you were
> describing. Is it like, at KVM module initialization time,
> 
>     if module_param == disable_tracking:
>         .__kvm_get_memory_attributes = read_attributes_from_guest_memfd
>     else
>         .__kvm_get_memory_attributes = read_attributes_from_mem_attr_array
> 
> With that, I can't have both CoCo private/shared state tracked in
> guest_memfd and RWX (as an example, could be any future attribute)
> tracked in mem_attr_array on the same VM.

More or less.

> > It's entirely possible I'm completely wrong and we'll end up with per-VM RWX
> > protections and no other per-gmem memory attributes, but as above, unwinding or
> > adjusting the module param will be a drop in the bucket compared to the effort
> > needed to add whatever support comes along.
> >
> 
> Is a module param a weaker userspace contract such that the definition
> for module params can be more flexibly adjusted?

Yes, much weaker.

> >> > The kvm_memory_attributes structure is compatible, all that's needed AFAICT is a
> >> > union to clarify it's a pgoff instead of an address when used for guest_memfd.
> >> >
> >> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >> > index 52f6000ab020..e0d8255ac8d2 100644
> >> > --- a/include/uapi/linux/kvm.h
> >> > +++ b/include/uapi/linux/kvm.h
> >> > @@ -1590,7 +1590,10 @@ struct kvm_stats_desc {
> >> >  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
> >> >  
> >> >  struct kvm_memory_attributes {
> >> > -       __u64 address;
> >> > +       union {
> >> > +               __u64 address;
> >> > +               __u64 offset;
> >> > +       };
> >> >         __u64 size;
> >> >         __u64 attributes;
> >> >         __u64 flags;
> >> >
> >> 
> >> struct kvm_memory_attributes doesn't have room for reporting the offset
> >> at which conversion failed (error_offset in the new struct). How do we
> >> handle this? Do we reuse the flags field, or do we not report
> >> error_offset?
> >
> > Write back at address/offset
> 
> I think it might be surprising to the userspace program, when it wants
> to check the offset that it had requested and found that it changed due
> to an error, or upon decoding the error, be unable to find the original
> offset it had requested.

It's a somewhat common pattern in the kernel.  Updating the offset+size is most
often used with -EAGAIN to say "got this far, try the syscall again from this
point".

> Like,
> 
>     printf("Error during conversion from offset=%lx with size=%lx, at
>            error_offset=%lx", attr.offset, attr.size, attr.error_offset)
> 
> would be nicer than 
> 
>     original_offset = attr.offset
>     printf("Error during conversion from offset=%lx with size=%lx, at
>            error_offset=%lx", original_offset, attr.size, attr.error_offset)
>            
> > (and update size too, which I probably forgot to do).
> 
> Why does size need to be updated? I think u64 for size is great, and
> size is better than nr_pages since nr_pages differs on different
> platforms based on PAGE_SIZE and also nr_pages introduces the question
> of "was it hugetlb, or a native page size?".

I meant update the number of bytes remaining when updating the offset so that
userspace can redo the ioctl without having to update parameters.

> > Ugh, but it's defined _IOW.  I forget if that matters in practice (IIRC, it's not
> > enforced anywhere, i.e. purely informational for userspace).
> >
> 
> I didn't notice this IOW vs IORW part, but if it starts getting
> enforced/specified [1] or auto-documented we'd be in trouble.

IOW vs IORW is alread specified in the ioctl.  More below.

> At this point, maybe it's better to just have a different ioctl number
> and struct definition. I feel that it would be easier for a user to
> associate/separate

Amusingly, we'd only need a different name along with the IORW thing.  A full
ioctl number is comproised of the "directory" (KVM), the number, the size of the
payload, and how the payload is accessed.

#define _IOC(dir,type,nr,size) \
	(((dir)  << _IOC_DIRSHIFT) | \
	 ((type) << _IOC_TYPESHIFT) | \
	 ((nr)   << _IOC_NRSHIFT) | \
	 ((size) << _IOC_SIZESHIFT))

So this:

  #define KVM_SET_MEMORY_ATTRIBUTES	_IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
  #define KVM_SET_MEMORY_ATTRIBUTES2	_IOWR(KVMIO, 0xd2, struct kvm_memory_attributes2)

actually generates two different values, and so is two different ioctls from a
code perspective.

The "size" of the payload is nice to have as it allows userspace to assert that
it's passing the right structure, e.g. this static assert from KVM selftests:

#define kvm_do_ioctl(fd, cmd, arg)						\
({										\
	kvm_static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) == _IOC_SIZE(cmd));	\
	ioctl(fd, cmd, arg);							\
})

> + KVM_SET_MEMORY_ATTRIBUTES
>     + Is VM ioctl
>     + Is a write-only ioctl
>     + Is for setting memory attributes at a VM level
>     + Use struct kvm_memory_attributes for this
> + KVM_GUEST_MEMFD_SET_MEMORY_ATTRIBUTES (name TBD)
>     + Is guest_memfd ioctl
>     + Is a read/write ioctl
>     + Is for setting memory attributes only for this guest_memfd
>     + Use struct guest_memfd_memory_attributes for this
>     + Also decode errors from this struct

      + Has extra padding for future expansion (because why not)

If we really truly need a new ioctl, I'd probably prefer KVM_SET_MEMORY_ATTRIBUTES2.
Yeah, it's silly, but I don't think baking GUEST_MEMFD into the names buys us
anything.  Then we can use KVM_SET_MEMORY_ATTRIBUTES2 on a VM if the need ever
arises.

Alternative #1 is to try and unwind on failure, but that gets complex, and it
simply can't be done for some CoCo VMs.  E.g. a private=>shared conversion for
TDX is descrutive.

Alternative #2 is to make the updates atomic and all-or-nothing, which is what
we did for per-VM attributes.  That's doable, but it'd either be much more
complex than telling userspace to retry, or we'd have to lose the maple tree
optimizations (which is effectively what we did for per-VM attributes).

> [1] https://lore.kernel.org/all/20250825181434.3340805-1-sashal@kernel.org/
> 
> >> >>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >> >>  				    pgoff_t index, struct folio *folio)
> >> >>  {
> >> >> @@ -333,7 +404,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> >> >>  
> >> >>  	filemap_invalidate_lock_shared(inode->i_mapping);
> >> >>  
> >> >> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> >> >> +	folio = kvm_gmem_get_shared_folio(inode, vmf->pgoff);
> >> >
> >> > I am fairly certain there's a TOCTOU bug here.  AFAICT, nothing prevents the
> >> > underlying memory from being converted from shared=>private after checking that
> >> > the page is SHARED.
> >> >
> >> 
> >> Conversions take the filemap_invalidate_lock() too, along with
> >> allocations, truncations.
> >> 
> >> Because the filemap_invalidate_lock() might be reused for other
> >> fs-specific operations, I didn't do the mt_set_external_lock() thing to
> >> lock at a low level to avoid nested locking or special maple tree code
> >> to avoid taking the lock on other paths.
> >
> > mt_set_external_lock() is a nop.  It exists purely for lockdep assertions.  Per
> > the comment for MT_FLAGS_LOCK_EXTERN, "mt_lock is not used", LOCK_EXTERN simply
> > tells maple tree to not use/take mt_lock.   I.e. it doesn't say "take this lock
> > instead", it says "I'll handle locking".
> 
> Thanks for pointing this out!
> 
> Conversions (and others) taking the filemap_invalidate_lock() probably
> fixes the TOCTOU bug, right?

Yes, grabbing a reference to the folio under lock and thus elevating its refcount
should prevent conversions to private from that point forward, until the PTE is
zapped and the folio is released:

	filemap_invalidate_lock_shared(inode->i_mapping);
	if (kvm_gmem_is_shared_mem(inode, vmf->pgoff))
		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
	else
		folio = ERR_PTR(-EACCES);
	filemap_invalidate_unlock_shared(inode->i_mapping);

