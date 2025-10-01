Return-Path: <kvm+bounces-59335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76388BB14B9
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F218D1882D72
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5249D28CF5F;
	Wed,  1 Oct 2025 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IGNUqYZV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11DA1D416E
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337314; cv=none; b=uqGAu8x2oDcP+gtogw68pHcC2ntF3xrqpdNZ7bxO/CSO/N8iifJ6StPCmyn+GzNTugvS3tbl89hBY+uDBDM7gt84+ATIxRJqaE8bUzzxOpTJ+H955aes4/+2www6kp6KuUuGYHOGZqGlgKiig6UueoQP0JhaQ/SgAMnqVmR7saE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337314; c=relaxed/simple;
	bh=cu70jR3G6wCv097RrQIR7eS0JwveKZNmgwljhW007Bo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jZsDK5fT6B0jseqJSUl8OSy63dW8jqUuxVQamwaaNAZl0EKqeyJNylyoiFZpuBUyMuazDpvoFb1EmRxjKvZ6hu8tJsVtjo5h5sIxM4wizbUmJ30KbBdtvbzBYhzr+xbbfHIH17OFVBQVRy8A3k2/ePJKRGsldNX9CTERpw1mmco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IGNUqYZV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so99915a91.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759337310; x=1759942110; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsETvYebxNjKcZGVO1bpJtLyrl/1L0m0GOVocGjgaWc=;
        b=IGNUqYZV1/W8E0j+XzqI/RL/t14Ad6fAcvym7xRUOrSgb+mHCYac+ExCdgaBH0Myo+
         ClmEWT7fgXDBC9uUIN+KT11YR7UrsEa9S9HhSssEMYVlS1nRfAHxw2qJbB2Nop8neLtW
         6YO7mfAgm/A/hUbWPoQEF6u+YHGd2VFU6S41nSSyZlWMPPne2fklPm3/UKPOCwhZpOFi
         0BiT+mmjYm5p5hzCLg26W7tdg3lAkJkd55KK2Ptj3+UKSvgOfptBdGvM3ZbsHp3brsid
         XEa+sjnPl/0cz+VonGLXaGETUxfGAOhlmVtAj1wLBerp8bq20/ZEkaLocZr9cl5A1kev
         Ra1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337310; x=1759942110;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PsETvYebxNjKcZGVO1bpJtLyrl/1L0m0GOVocGjgaWc=;
        b=t/KBA1qPRbRbBV/SbWFADuHG7mxFvBc408SwwvELt9V75ajOvwDVRs2azWbfePk6IE
         H8aL8NNM5N4fZBTOPONzaso+UMxGycJVk6P8qTul4R3u08MI3xO1vcS/4QbvGKYQ4gLY
         kpGiVBU79KvEVYuwvUxutG/bzhEGZugXem33K4SY3EAmfxrvfuFoZAQ1rxThBHMrOxkQ
         8/fwLEf1awpb7+jAdNVzaNmvmzZHvgZ7kwejwzIP1KPQ8y55ycqJ1ZjRiqMzipll1TU3
         NAmdLO7t9haN+Ko378nJVrBY1+s1arrevUlXeBoxL7k+uknnyIi/Utfj92AF+ln35AwW
         XeIw==
X-Gm-Message-State: AOJu0YziUfiX5xHDAWuwl6yR1vUSvOF2vc8IINeGIBT4fi1W11tqgG6T
	b3wHvgo0M9rPur5hKxLul3kgLxPszlP1Cnd6z5wgdk4txM+O5JjNQ9kqeEXKHiIdrLBizCCGJzI
	KPKWezQ==
X-Google-Smtp-Source: AGHT+IGBr4qCftsTq3OAdviGUAHI0gcCXTOIGwo+JZyoAatrlnRvcGgpHO7iZYgCThGSrh/QsBRJMeiJnXM=
X-Received: from pjn13.prod.google.com ([2002:a17:90b:570d:b0:335:2897:47c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0a:b0:32e:3552:8c79
 with SMTP id 98e67ed59e1d1-339a6f52413mr5336697a91.29.1759337310187; Wed, 01
 Oct 2025 09:48:30 -0700 (PDT)
Date: Wed, 1 Oct 2025 09:48:28 -0700
In-Reply-To: <diqzbjmrt000.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <diqzbjmrt000.fsf@google.com>
Message-ID: <aN1bXOg3x0ZdTI1D@google.com>
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
> > On Wed, May 14, 2025, Ackerley Tng wrote:
> >> +enum shareability {
> >> +	SHAREABILITY_GUEST = 1,	/* Only the guest can map (fault) folios in this range. */
> >> +	SHAREABILITY_ALL = 2,	/* Both guest and host can fault folios in this range. */
> >> +};
> >
> > Rather than define new values and new KVM uAPI, I think we should instead simply
> > support KVM_SET_MEMORY_ATTRIBUTES.  We'll probably need a new CAP, as I'm not sure
> > supporting KVM_CHECK_EXTENSION+KVM_CAP_MEMORY_ATTRIBUTES on a gmem fd would be a
> > good idea (e.g. trying to do KVM_CAP_GUEST_MEMFD_FLAGS on a gmem fd doesn't work
> > because the whole point is to get flags _before_ creating the gmem instance).  But
> > adding e.g. KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is easy enough.
> >
> 
> I've read this a few times and I'm a bit confused, so just making sure:
> you are suggesting that we reuse the KVM_SET_MEMORY_ATTRIBUTES ioctl as
> a guest_memfd (not a VM) ioctl and still store private/shared state
> within guest_memfd, right?

Yep.  Something like:

static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
{
	struct gmem_file *f = file->private_data;
	struct inode *inode = file_inode(file);
	struct kvm_memory_attributes attrs;
	pgoff_t err_index;
	int r;

	if (copy_from_user(&attrs, argp, sizeof(attrs)))
		return -EFAULT;

	if (attrs.flags)
		return -EINVAL;
	if (attrs.attributes & ~kvm_gmem_supported_mem_attributes(f))
		return -EINVAL;
	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
		return -EINVAL;
	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.offset))
		return -EINVAL;

	if (attrs.offset > inode->i_size ||
	    attrs.offset + attrs.size > inode->i_size)
		return -EINVAL;

	r = __kvm_gmem_set_attributes(inode, &attrs, &err_index);
	if (r) {
		attrs.offset = err_index << PAGE_SHIFT;
		if (copy_to_user(argp, &attrs, sizeof(attrs)))
			return -EFAULT;

		return r;
	}

	return 0;
}

static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
			   unsigned long arg)
{
	switch (ioctl) {
	case KVM_SET_MEMORY_ATTRIBUTES:
		return kvm_gmem_set_attributes(file, (void __user *)arg);
	default:
		return -ENOTTY;
	}
}

> I think fundamentally the introduction of the guest_memfd ioctls was
> motivated by how private/shared state is a property of memory and not a
> property of the VM. (IIRC you were the one to most succinctly phrase it
> this way on one of the guest_memfd biweeklies.) So I hope you don't mean
> to revert to doing conversions through a VM ioctl.

I do not.  Ah shoot.  I responded to my (much earlier) mail on this to clarify
exactly this point, but I botched the Cc and threading, and it didn't make it's
way to you.

https://lore.kernel.org/all/aNxxJodpbHceb3rF@google.com

> > But for specifying PRIVATE vs. SHARED, I don't see any reason to define new uAPI.
> > I also don't want an entirely new set of terms in KVM to describe the same things.
> > PRIVATE and SHARED are far from perfect, but they're better than https://xkcd.com/927.
> > And if we ever want to let userspace restrict RWX protections in gmem, we'll have
> > a ready-made way to do so.  
> >
> 
> Would like to understand more about RWX protections: is the use case to
> let userspace specify that certain ranges of guest memory are to be
> mapped into stage 2 page tables without executable permissions?

Yep.  Or execute-only.  Or read-only.  The primary use case I'm aware of is for
supporting things VBS (Hyper-V's virtualization based security) and HEKI[1] (which
is effectively the same thing as VBS, and is indeed being dropped in favor of
simply piggybacking the VBS guest<=>host ABI).

VBS allows the kernel to deprivilege itself, and hoist a small amount of code
into a more privilege "thing".  In KVM, the separate privilege domains will be
called "planes"[2].  For RWX protections, the more privileged plane would have
full RWX access to all of guest memory, while the deprivilege kernel will have
select chunks of memory mapped RO (e.g. kernel page tables, GDT, IDT, etc., or
potentially not at all (see Credential Guard).

I don't know if tracking per-plane RWX state in guest_memfd would be a good idea,
but it costs practically nothing to keep the possibility open.

[1] https://lore.kernel.org/all/20231113022326.24388-1-mic@digikod.net
[2] https://lore.kernel.org/all/20250401161106.790710-1-pbonzini@redhat.com

> Is there a further use case to let the guest specify that userspace must
> not mmap() some ranges as executable?
> 
> For guest_memfd the userspace mapping permissions are already defined
> by userspace and so unless guest_memfd must enforce something on behalf
> of the guest, there shouldn't be anything more that guest_memfd should
> track with respect to RWX permissions.

But not all userspaces are created equal.  E.g. if a VM is sharing memory with
another entity, it might want to restrict that sharing to be read-only.  I don't
know that memory attributes would be the best way to express such rules, just
saying that fully relying on mmap() has limitations.

> > Internally, that let's us do some fun things in KVM.  E.g. if we make the "disable
> > legacy per-VM memory attributes" a read-only module param, then we can wire up a
> > static_call() for kvm_get_memory_attributes() and then kvm_mem_is_private() will
> > Just Work.
> >
> >   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> >   {
> > 	return static_call(__kvm_get_memory_attributes)(kvm, gfn);
> >   }
> >
> >   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >   {
> > 	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> >   }
> >
> > That might trigger some additional surgery if/when we want to support RWX
> > protections on a per-VM basis _and_ a per-gmem basic, but I suspect such churn
> > would pale in comparison to the overall support needed for RWX protections.
> >
> 
> RWX protections are more of a VM-level property, if I understood the use
> case correctly that some gfn ranges are to be marked non-executable by
> userspace. Setting RWX within guest_memfd would be kind of awkward since
> userspace must first translate GFN to offset, then set it using the
> offset within guest_memfd. Hence I think it's okay to have RWX stuff go
> through the regular KVM_SET_MEMORY_ATTRIBUTES *VM* ioctl and have it
> tracked in mem_attr_array.

Maybe.  It will depend on how the use cases shake out.  E.g. before the planes
idea came along, the proposal for supporting different privilege levels was to
represent each privilege level with its own "struct kvm", at which point tracking
RWX protections per-VM (struct kvm) made sense.

But with planes, that's no longer true.  E.g. we'd need RWX flags for plane0
and separate RWX flags for plane1 regardless of whether they're tracked in
struct kvm or in the gmem instance.

To be clear, I don't have an opinion one way or the other, because what we'll
end up with is quite unclear.  All I was calling out is that reusing
KVM_SET_MEMORY_ATTRIBUTES provides a lot of the plumbing, _if_ we want to define
RWX protections on a gmem instance.

> I'd prefer not to have the module param choose between the use of
> mem_attr_array and guest_memfd conversion in case we need both
> mem_attr_array to support other stuff in future while supporting
> conversions.

Luckily, we don't actually need to make a decision on this, because PRIVATE is
the only attribute that exists.  Which is partly why I want to go with a module
param.  We can make the behavior very definitive without significant risk of
causing ABI hell.

It's entirely possible I'm completely wrong and we'll end up with per-VM RWX
protections and no other per-gmem memory attributes, but as above, unwinding or
adjusting the module param will be a drop in the bucket compared to the effort
needed to add whatever support comes along.

> > The kvm_memory_attributes structure is compatible, all that's needed AFAICT is a
> > union to clarify it's a pgoff instead of an address when used for guest_memfd.
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 52f6000ab020..e0d8255ac8d2 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1590,7 +1590,10 @@ struct kvm_stats_desc {
> >  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
> >  
> >  struct kvm_memory_attributes {
> > -       __u64 address;
> > +       union {
> > +               __u64 address;
> > +               __u64 offset;
> > +       };
> >         __u64 size;
> >         __u64 attributes;
> >         __u64 flags;
> >
> 
> struct kvm_memory_attributes doesn't have room for reporting the offset
> at which conversion failed (error_offset in the new struct). How do we
> handle this? Do we reuse the flags field, or do we not report
> error_offset?

Write back at address/offset (and update size too, which I probably forgot to do).
Ugh, but it's defined _IOW.  I forget if that matters in practice (IIRC, it's not
enforced anywhere, i.e. purely informational for userspace).

> >>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>  				    pgoff_t index, struct folio *folio)
> >>  {
> >> @@ -333,7 +404,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> >>  
> >>  	filemap_invalidate_lock_shared(inode->i_mapping);
> >>  
> >> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> >> +	folio = kvm_gmem_get_shared_folio(inode, vmf->pgoff);
> >
> > I am fairly certain there's a TOCTOU bug here.  AFAICT, nothing prevents the
> > underlying memory from being converted from shared=>private after checking that
> > the page is SHARED.
> >
> 
> Conversions take the filemap_invalidate_lock() too, along with
> allocations, truncations.
> 
> Because the filemap_invalidate_lock() might be reused for other
> fs-specific operations, I didn't do the mt_set_external_lock() thing to
> lock at a low level to avoid nested locking or special maple tree code
> to avoid taking the lock on other paths.

mt_set_external_lock() is a nop.  It exists purely for lockdep assertions.  Per
the comment for MT_FLAGS_LOCK_EXTERN, "mt_lock is not used", LOCK_EXTERN simply
tells maple tree to not use/take mt_lock.   I.e. it doesn't say "take this lock
instead", it says "I'll handle locking".

