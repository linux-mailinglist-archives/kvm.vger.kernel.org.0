Return-Path: <kvm+bounces-59375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2AEFBB1FC2
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 00:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1D751887559
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 22:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF61311964;
	Wed,  1 Oct 2025 22:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YxWQSvbt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD5E2868B0
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 22:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759357473; cv=none; b=eVMnG6ooOUEgyn9Bx3K4Tn3pm2pcGI3qlPdJQJaDXFMt9KhZAG17pRZeUlZuEDB/dMuFuhHczgBy70j28eeka8AmAUcQ3d2DKkNM1JOqDbKqgovKacXmJPQjTVGnybMFhWEKlMbmNyWwSSGWrL7eDCUVeW0f4arEGf4/HD8WY9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759357473; c=relaxed/simple;
	bh=hVce6S5I84XFHeiZCM/nN0xHXZReUryCXvdykFdkIpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qhgPzXYM3AEYH/gLihTDXdK/38h0ILziw9VCL0b+Lc8n1JqBNd1dgcBaE37GBzT7Wdfv+vjIEQ2sORGjgvXq6QcBCXf0iFZC6dvVbE06ILw4EgcX1Ok1ZrISW9GYLbSLXh2c+U5oQbYAhU2X7nhasMVNcghSegbEr0G7+5fXB0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YxWQSvbt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-27ee214108cso6568845ad.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 15:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759357471; x=1759962271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=73Hf7u2rrI0J4qCeXbvR8EaJjdYBMjTbk+N0QgWUrbs=;
        b=YxWQSvbtjLcKhDBGP2PjwQxy4GYYfZGPcoGiNjPNvVi0//Iq32fjnYWCKykim7C1BQ
         p/6J+nQFyc4UCsZs5KTXiytGbEDsT/U523tvza65mAS9HR4pAw2kkLvsjxM0/y+I2tjc
         7Y97qUoiZi51oihoMyg3+nv+1eq4pA3tpZniDMK6b7QJcOeOknJCuq80Ir65GADjrAzI
         QNyWqj7N9r9BUBSHaUCm1VgMyqdZjJ1a/ZO7GdP9jappyekHecy52/KSq9zaOHchu6Lh
         rNTz04JWhsIs0YydzdAkCIWlaYSQOAvvJx6dzyCW3EZJKGRkt5jduJR9pp9CH15fJscL
         Wg3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759357471; x=1759962271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73Hf7u2rrI0J4qCeXbvR8EaJjdYBMjTbk+N0QgWUrbs=;
        b=cNYxOxNxdBB0UxTlpEoiduYfMhBHe/C8aPcepIG1XTecPFPmENPHiQYmPgt5vActCd
         ywwjpNXakvzFPNdAS7UioLCh0KjDT4EgypKfanCPWjrnkoq6fFII5/ESmrDUPMccIiJr
         cZu5sN8Yam8bS84Hhb3tAxnrPmn8rQKHse+idaXo51Ya6rQ6Q89/kEXZCLcwz+gAHn9R
         D6N0uqPwpn4qBAH1TCzGpKcgoysLpXMD3G3cmu8rZiLvLHtik2SBcx/S1i62hTpIGJBU
         wXpeXUpD6/JUd9/CSUDSA06UvptnpFIufehHd83KmqSKr8rB+/NmkYpiVu7O8awHHltP
         FwSw==
X-Gm-Message-State: AOJu0Yy9YGvl0LO+GU9fM3lmrhQCnL6NzSfIL7E36VbgpAsDpohZE+TX
	4HqFF2aQtTA0Swki+TAR+UMtABLtkL5ur5m77kqm2j4ug9m2fHXPvMHdW7gXkIpHhfxHRJdEZsh
	dMVuMdA8gM3EM7T4uR2H/29a8zw==
X-Google-Smtp-Source: AGHT+IGCpXl0I0+nSwagJsU1QGY2RcUpV5Mo6AawwSsWOc7zuSI5WI9xzUiHIJcaQ2A4ihXmA+srPzrIYwXmyTHPkg==
X-Received: from plbma13.prod.google.com ([2002:a17:903:94d:b0:268:1af:fcff])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:70c1:b0:269:9a7a:9a43 with SMTP id d9443c01a7336-28e7f167915mr42552505ad.10.1759357471377;
 Wed, 01 Oct 2025 15:24:31 -0700 (PDT)
Date: Wed, 01 Oct 2025 22:24:30 +0000
In-Reply-To: <aN1bXOg3x0ZdTI1D@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <diqzbjmrt000.fsf@google.com> <aN1bXOg3x0ZdTI1D@google.com>
Message-ID: <diqz1pnmtg4h.fsf@google.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Oct 01, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > On Wed, May 14, 2025, Ackerley Tng wrote:
>> >> +enum shareability {
>> >> +	SHAREABILITY_GUEST = 1,	/* Only the guest can map (fault) folios in this range. */
>> >> +	SHAREABILITY_ALL = 2,	/* Both guest and host can fault folios in this range. */
>> >> +};
>> >
>> > Rather than define new values and new KVM uAPI, I think we should instead simply
>> > support KVM_SET_MEMORY_ATTRIBUTES.  We'll probably need a new CAP, as I'm not sure
>> > supporting KVM_CHECK_EXTENSION+KVM_CAP_MEMORY_ATTRIBUTES on a gmem fd would be a
>> > good idea (e.g. trying to do KVM_CAP_GUEST_MEMFD_FLAGS on a gmem fd doesn't work
>> > because the whole point is to get flags _before_ creating the gmem instance).  But
>> > adding e.g. KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is easy enough.
>> >
>> 
>> I've read this a few times and I'm a bit confused, so just making sure:
>> you are suggesting that we reuse the KVM_SET_MEMORY_ATTRIBUTES ioctl as
>> a guest_memfd (not a VM) ioctl and still store private/shared state
>> within guest_memfd, right?
>
> Yep.  Something like:
>
> static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
> {
> 	struct gmem_file *f = file->private_data;
> 	struct inode *inode = file_inode(file);
> 	struct kvm_memory_attributes attrs;
> 	pgoff_t err_index;
> 	int r;
>
> 	if (copy_from_user(&attrs, argp, sizeof(attrs)))
> 		return -EFAULT;
>
> 	if (attrs.flags)
> 		return -EINVAL;
> 	if (attrs.attributes & ~kvm_gmem_supported_mem_attributes(f))
> 		return -EINVAL;
> 	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
> 		return -EINVAL;
> 	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.offset))
> 		return -EINVAL;
>
> 	if (attrs.offset > inode->i_size ||
> 	    attrs.offset + attrs.size > inode->i_size)
> 		return -EINVAL;
>
> 	r = __kvm_gmem_set_attributes(inode, &attrs, &err_index);
> 	if (r) {
> 		attrs.offset = err_index << PAGE_SHIFT;
> 		if (copy_to_user(argp, &attrs, sizeof(attrs)))
> 			return -EFAULT;
>
> 		return r;
> 	}
>
> 	return 0;
> }
>
> static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
> 			   unsigned long arg)
> {
> 	switch (ioctl) {
> 	case KVM_SET_MEMORY_ATTRIBUTES:
> 		return kvm_gmem_set_attributes(file, (void __user *)arg);
> 	default:
> 		return -ENOTTY;
> 	}
> }
>
>> I think fundamentally the introduction of the guest_memfd ioctls was
>> motivated by how private/shared state is a property of memory and not a
>> property of the VM. (IIRC you were the one to most succinctly phrase it
>> this way on one of the guest_memfd biweeklies.) So I hope you don't mean
>> to revert to doing conversions through a VM ioctl.
>
> I do not.  Ah shoot.  I responded to my (much earlier) mail on this to clarify
> exactly this point, but I botched the Cc and threading, and it didn't make it's
> way to you.
>
> https://lore.kernel.org/all/aNxxJodpbHceb3rF@google.com
>

Phew. Good to have this clarified.

>> 
>> [...snip...]
>> 
>> I'd prefer not to have the module param choose between the use of
>> mem_attr_array and guest_memfd conversion in case we need both
>> mem_attr_array to support other stuff in future while supporting
>> conversions.
>
> Luckily, we don't actually need to make a decision on this, because PRIVATE is
> the only attribute that exists.  Which is partly why I want to go with a module
> param.  We can make the behavior very definitive without significant risk of
> causing ABI hell.
>

Then maybe I'm misunderstanding the static_call() thing you were
describing. Is it like, at KVM module initialization time,

    if module_param == disable_tracking:
        .__kvm_get_memory_attributes = read_attributes_from_guest_memfd
    else
        .__kvm_get_memory_attributes = read_attributes_from_mem_attr_array

With that, I can't have both CoCo private/shared state tracked in
guest_memfd and RWX (as an example, could be any future attribute)
tracked in mem_attr_array on the same VM.
    
> It's entirely possible I'm completely wrong and we'll end up with per-VM RWX
> protections and no other per-gmem memory attributes, but as above, unwinding or
> adjusting the module param will be a drop in the bucket compared to the effort
> needed to add whatever support comes along.
>

Is a module param a weaker userspace contract such that the definition
for module params can be more flexibly adjusted?

>> > The kvm_memory_attributes structure is compatible, all that's needed AFAICT is a
>> > union to clarify it's a pgoff instead of an address when used for guest_memfd.
>> >
>> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> > index 52f6000ab020..e0d8255ac8d2 100644
>> > --- a/include/uapi/linux/kvm.h
>> > +++ b/include/uapi/linux/kvm.h
>> > @@ -1590,7 +1590,10 @@ struct kvm_stats_desc {
>> >  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
>> >  
>> >  struct kvm_memory_attributes {
>> > -       __u64 address;
>> > +       union {
>> > +               __u64 address;
>> > +               __u64 offset;
>> > +       };
>> >         __u64 size;
>> >         __u64 attributes;
>> >         __u64 flags;
>> >
>> 
>> struct kvm_memory_attributes doesn't have room for reporting the offset
>> at which conversion failed (error_offset in the new struct). How do we
>> handle this? Do we reuse the flags field, or do we not report
>> error_offset?
>
> Write back at address/offset

I think it might be surprising to the userspace program, when it wants
to check the offset that it had requested and found that it changed due
to an error, or upon decoding the error, be unable to find the original
offset it had requested. Like,

    printf("Error during conversion from offset=%lx with size=%lx, at
           error_offset=%lx", attr.offset, attr.size, attr.error_offset)

would be nicer than 

    original_offset = attr.offset
    printf("Error during conversion from offset=%lx with size=%lx, at
           error_offset=%lx", original_offset, attr.size, attr.error_offset)
           
> (and update size too, which I probably forgot to do).

Why does size need to be updated? I think u64 for size is great, and
size is better than nr_pages since nr_pages differs on different
platforms based on PAGE_SIZE and also nr_pages introduces the question
of "was it hugetlb, or a native page size?".

> Ugh, but it's defined _IOW.  I forget if that matters in practice (IIRC, it's not
> enforced anywhere, i.e. purely informational for userspace).
>

I didn't notice this IOW vs IORW part, but if it starts getting
enforced/specified [1] or auto-documented we'd be in trouble.

At this point, maybe it's better to just have a different ioctl number
and struct definition. I feel that it would be easier for a user to
associate/separate

+ KVM_SET_MEMORY_ATTRIBUTES
    + Is VM ioctl
    + Is a write-only ioctl
    + Is for setting memory attributes at a VM level
    + Use struct kvm_memory_attributes for this
+ KVM_GUEST_MEMFD_SET_MEMORY_ATTRIBUTES (name TBD)
    + Is guest_memfd ioctl
    + Is a read/write ioctl
    + Is for setting memory attributes only for this guest_memfd
    + Use struct guest_memfd_memory_attributes for this
    + Also decode errors from this struct

[1] https://lore.kernel.org/all/20250825181434.3340805-1-sashal@kernel.org/

>> >>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >>  				    pgoff_t index, struct folio *folio)
>> >>  {
>> >> @@ -333,7 +404,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>> >>  
>> >>  	filemap_invalidate_lock_shared(inode->i_mapping);
>> >>  
>> >> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>> >> +	folio = kvm_gmem_get_shared_folio(inode, vmf->pgoff);
>> >
>> > I am fairly certain there's a TOCTOU bug here.  AFAICT, nothing prevents the
>> > underlying memory from being converted from shared=>private after checking that
>> > the page is SHARED.
>> >
>> 
>> Conversions take the filemap_invalidate_lock() too, along with
>> allocations, truncations.
>> 
>> Because the filemap_invalidate_lock() might be reused for other
>> fs-specific operations, I didn't do the mt_set_external_lock() thing to
>> lock at a low level to avoid nested locking or special maple tree code
>> to avoid taking the lock on other paths.
>
> mt_set_external_lock() is a nop.  It exists purely for lockdep assertions.  Per
> the comment for MT_FLAGS_LOCK_EXTERN, "mt_lock is not used", LOCK_EXTERN simply
> tells maple tree to not use/take mt_lock.   I.e. it doesn't say "take this lock
> instead", it says "I'll handle locking".

Thanks for pointing this out!

Conversions (and others) taking the filemap_invalidate_lock() probably
fixes the TOCTOU bug, right?

