Return-Path: <kvm+bounces-59394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F34E4BB2BD7
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 09:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83A1719C3B48
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 07:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351B72D1F4E;
	Thu,  2 Oct 2025 07:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x3xZkaje"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90331DD9AD
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 07:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759391346; cv=none; b=qBOwXR7XJ+dkBAM+WCoLL5zFvIajjIGOckMTfzCX5cR9IqR18IO2WlOj8Mno4Y5ouWaTzcXiqYmEZ4IR+089NDF8Ro3yOzTfvon8oUKWxgBYzY07psedPwInczS2q32kcEwY7VCQw+HdCAckqhS/ZcQKfhvc4nh4RoPKuxCrUOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759391346; c=relaxed/simple;
	bh=Y3/dmaL8PlTUGmtZQc6HGcv0c1HgbBDs64Fw+IreoUw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O8q3CJnSKY6NpiTxjNBjAPqIp1UTDT1NT5LYqehCM3G8N5SrRZutmac+5VYTiXZhB84dbBFTZx+Fmk5QbRpEk5UrQ6haI1n/rOiZH6fxs8ujq9Ep8eN4zNXTQKDU+vKbQdHuUNSagYYJx5nS61W/Ryj5tQhX1gJxZbqxPI+NyR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x3xZkaje; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ecab3865dso1069578a91.1
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 00:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759391344; x=1759996144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=go+hWBT9ITOWDP8uH4s0K8lsbawxN4U22H6W6XNbqbU=;
        b=x3xZkajejI5LCEoBanAAx4FuQdvI2xs7F2T+HnyUCtqxbJZuQU14i6VI2MEmJYGdqR
         IE2VlC35GRRWhcQBJn38vE8fil1ck44QqocWp/5AOg6OvuT2q2RDqOe7Qlj0Kr6GZ+PS
         fusd25XgF9X3wz7GJNLOmYH2nQTxH31Qbogst//uvgHrzeeHuQpV2e8bOUYtjQMZD4lH
         Pu5nme0Xi7d9VUc1mxoF9QGva0QFo1xY6HeiYBQ3+R53GzIkbrDSizIdxGATyPvF/D53
         PCRI9P/2VbL2CeKP04NV76hhEg0xQUopzFvEtmNjfDNmziVlm37143BaZU+k7B8O9qal
         5mSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759391344; x=1759996144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=go+hWBT9ITOWDP8uH4s0K8lsbawxN4U22H6W6XNbqbU=;
        b=kdzrM33DnuLuiatdcF0AQS8y3Gv+RyNrneo263jqysIVZhBYTNOBAuaPvbNHPfQtAk
         D64Tzo/6dHgksbUNbYo/VQ/mGMaZcgbwtH9lGZKFw8zGKmiu9+ZI2IcrWhCp6Qm0cf+K
         MvlE9aLy76Tc06h1SJCOXF+aIlil8rIuzpTw9ZukndCEZ/KZhSYU88KCF7D96jHfvHFm
         vU/KJygZJmjxfrbY1WoW+kG6XO/vDcr4OcFhcxBBab0t3E31sqF9JPLsWuTdtwqlLDdq
         gqNyyBib2F2QBuGl1a6vtCe/NQndCtpEkaDRChGMXSwjqei38pUmTgQhpFQn65NfMXNN
         OhBQ==
X-Gm-Message-State: AOJu0Yx0MP1UoNO4eQzyquAFAzY19u2BzUogw5GPVlvL4QZLkMsrq5H2
	nUh02GeVY0cCv6UhR6nu+uaWcS8BUtXDrmEJH+0F6dz8Rezw/108rCMgRHflwXZN9e48AQT+BFp
	53n4tHdG9Zhg87/PRNaLVwhwR4A==
X-Google-Smtp-Source: AGHT+IFbOguSE7ziCxSGMFAgR4r0H/koNUOPNzdkm5U8rQvN7qKaB1KuYgNKpVTHPLhsI92ZrDZL9/VIY8yAAC8xLg==
X-Received: from pjuu7.prod.google.com ([2002:a17:90b:5867:b0:32e:c154:c2f6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d06:b0:32d:17ce:49d5 with SMTP id 98e67ed59e1d1-339a6f06af6mr7405966a91.23.1759391343848;
 Thu, 02 Oct 2025 00:49:03 -0700 (PDT)
Date: Thu, 02 Oct 2025 07:49:02 +0000
In-Reply-To: <aN3KfrWERpXsj3ld@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <diqzbjmrt000.fsf@google.com>
 <aN1bXOg3x0ZdTI1D@google.com> <diqz1pnmtg4h.fsf@google.com> <aN3KfrWERpXsj3ld@google.com>
Message-ID: <diqzy0ptspzl.fsf@google.com>
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
>> >> I'd prefer not to have the module param choose between the use of
>> >> mem_attr_array and guest_memfd conversion in case we need both
>> >> mem_attr_array to support other stuff in future while supporting
>> >> conversions.
>> >
>> > Luckily, we don't actually need to make a decision on this, because PRIVATE is
>> > the only attribute that exists.  Which is partly why I want to go with a module
>> > param.  We can make the behavior very definitive without significant risk of
>> > causing ABI hell.
>> >
>> 
>> Then maybe I'm misunderstanding the static_call() thing you were
>> describing. Is it like, at KVM module initialization time,
>> 
>>     if module_param == disable_tracking:
>>         .__kvm_get_memory_attributes = read_attributes_from_guest_memfd
>>     else
>>         .__kvm_get_memory_attributes = read_attributes_from_mem_attr_array
>> 
>> With that, I can't have both CoCo private/shared state tracked in
>> guest_memfd and RWX (as an example, could be any future attribute)
>> tracked in mem_attr_array on the same VM.
>
> More or less.
>

Hm okay. So introducing the module param will only allow the use of one
of the following?

+ KVM_SET_MEMORY_ATTRIBUTES (vm ioctl)
+ KVM_SET_MEMORY_ATTRIBUTES2 (guest_memfd ioctl)

Then I guess using a module param which is a weaker userspace contract
allows us to later enable both vm and guest_memfd ioctl if the need
arises?

>> > It's entirely possible I'm completely wrong and we'll end up with per-VM RWX
>> > protections and no other per-gmem memory attributes, but as above, unwinding or
>> > adjusting the module param will be a drop in the bucket compared to the effort
>> > needed to add whatever support comes along.
>> >
>> 
>> Is a module param a weaker userspace contract such that the definition
>> for module params can be more flexibly adjusted?
>
> Yes, much weaker.
>

I have a new tool in my toolbox now :)

>> >> > The kvm_memory_attributes structure is compatible, all that's needed AFAICT is a
>> >> > union to clarify it's a pgoff instead of an address when used for guest_memfd.
>> >> >
>> >> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> >> > index 52f6000ab020..e0d8255ac8d2 100644
>> >> > --- a/include/uapi/linux/kvm.h
>> >> > +++ b/include/uapi/linux/kvm.h
>> >> > @@ -1590,7 +1590,10 @@ struct kvm_stats_desc {
>> >> >  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
>> >> >  
>> >> >  struct kvm_memory_attributes {
>> >> > -       __u64 address;
>> >> > +       union {
>> >> > +               __u64 address;
>> >> > +               __u64 offset;
>> >> > +       };
>> >> >         __u64 size;
>> >> >         __u64 attributes;
>> >> >         __u64 flags;
>> >> >
>> >> 
>> >> struct kvm_memory_attributes doesn't have room for reporting the offset
>> >> at which conversion failed (error_offset in the new struct). How do we
>> >> handle this? Do we reuse the flags field, or do we not report
>> >> error_offset?
>> >
>> > Write back at address/offset
>> 
>> I think it might be surprising to the userspace program, when it wants
>> to check the offset that it had requested and found that it changed due
>> to an error, or upon decoding the error, be unable to find the original
>> offset it had requested.
>
> It's a somewhat common pattern in the kernel.  Updating the offset+size is most
> often used with -EAGAIN to say "got this far, try the syscall again from this
> point".
>

TIL, thanks!

>> Like,
>> 
>>     printf("Error during conversion from offset=%lx with size=%lx, at
>>            error_offset=%lx", attr.offset, attr.size, attr.error_offset)
>> 
>> would be nicer than 
>> 
>>     original_offset = attr.offset
>>     printf("Error during conversion from offset=%lx with size=%lx, at
>>            error_offset=%lx", original_offset, attr.size, attr.error_offset)
>>            
>> > (and update size too, which I probably forgot to do).
>> 
>> Why does size need to be updated? I think u64 for size is great, and
>> size is better than nr_pages since nr_pages differs on different
>> platforms based on PAGE_SIZE and also nr_pages introduces the question
>> of "was it hugetlb, or a native page size?".
>
> I meant update the number of bytes remaining when updating the offset so that
> userspace can redo the ioctl without having to update parameters.
>
>> > Ugh, but it's defined _IOW.  I forget if that matters in practice (IIRC, it's not
>> > enforced anywhere, i.e. purely informational for userspace).
>> >
>> 
>> I didn't notice this IOW vs IORW part, but if it starts getting
>> enforced/specified [1] or auto-documented we'd be in trouble.
>
> IOW vs IORW is alread specified in the ioctl.  More below.
>
>> At this point, maybe it's better to just have a different ioctl number
>> and struct definition. I feel that it would be easier for a user to
>> associate/separate
>
> Amusingly, we'd only need a different name along with the IORW thing.  A full
> ioctl number is comproised of the "directory" (KVM), the number, the size of the
> payload, and how the payload is accessed.
>
> #define _IOC(dir,type,nr,size) \
> 	(((dir)  << _IOC_DIRSHIFT) | \
> 	 ((type) << _IOC_TYPESHIFT) | \
> 	 ((nr)   << _IOC_NRSHIFT) | \
> 	 ((size) << _IOC_SIZESHIFT))
>
> So this:
>
>   #define KVM_SET_MEMORY_ATTRIBUTES	_IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
>   #define KVM_SET_MEMORY_ATTRIBUTES2	_IOWR(KVMIO, 0xd2, struct kvm_memory_attributes2)
>
> actually generates two different values, and so is two different ioctls from a
> code perspective.
>
> The "size" of the payload is nice to have as it allows userspace to assert that
> it's passing the right structure, e.g. this static assert from KVM selftests:
>
> #define kvm_do_ioctl(fd, cmd, arg)						\
> ({										\
> 	kvm_static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) == _IOC_SIZE(cmd));	\
> 	ioctl(fd, cmd, arg);							\
> })
>
>> + KVM_SET_MEMORY_ATTRIBUTES
>>     + Is VM ioctl
>>     + Is a write-only ioctl
>>     + Is for setting memory attributes at a VM level
>>     + Use struct kvm_memory_attributes for this
>> + KVM_GUEST_MEMFD_SET_MEMORY_ATTRIBUTES (name TBD)
>>     + Is guest_memfd ioctl
>>     + Is a read/write ioctl
>>     + Is for setting memory attributes only for this guest_memfd
>>     + Use struct guest_memfd_memory_attributes for this
>>     + Also decode errors from this struct
>
>       + Has extra padding for future expansion (because why not)
>
> If we really truly need a new ioctl, I'd probably prefer KVM_SET_MEMORY_ATTRIBUTES2.
> Yeah, it's silly, but I don't think baking GUEST_MEMFD into the names buys us
> anything.  Then we can use KVM_SET_MEMORY_ATTRIBUTES2 on a VM if the need ever
> arises.
>

I'm for having a new ioctl number and new struct, which are you leaning
towards?

As for the naming, I think it's confusing to have something similar, and
Ira mentioned it being confusing in the other email too. At the same
time, I accept that it's useful if the same struct were to be used for a
new iteration of the KVM_SET_MEMORY_ATTRIBUTES VM ioctl in future. No
strong preference either way on naming.


Trying to understand the difference between unwind on failure vs
all-or-nothing:

> Alternative #1 is to try and unwind on failure, but that gets complex, and it
> simply can't be done for some CoCo VMs.  E.g. a private=>shared conversion for
> TDX is descrutive.
>

Unwind on failure is:

1. Store current state
2. Convert
3. Restore current state on conversion failure

> Alternative #2 is to make the updates atomic and all-or-nothing, which is what
> we did for per-VM attributes.  That's doable, but it'd either be much more
> complex than telling userspace to retry, or we'd have to lose the maple tree
> optimizations (which is effectively what we did for per-VM attributes).
>

All-or-nothing:

1. Do everything to make sure conversion doesn't fail, bail early if it
   fails
2. Convert (always successful)

Is that it?


Zapping private pages from the stage 2 page tables for TDX can't be
recovered without help from the guest (I think that's what you're
talking about too), although technically I think this zapping step could
be delayed right till the end.

Maple tree allocations for conversion could fail, and allocations are a
bit more complicated since we try to compact ranges with the same
shared/private status into one same maple tree node. Still technically
possible, maybe by updating a copy of the maple tree first, then
swapping the current maple tree out atomically.

With HugeTLB, undoing HVO needs pages to be allocated, will need more
digging into the details to determine if preallocation could work.

I'd still prefer having the option to return an error so that we don't
paint ourselves into a corner.

>> [1] https://lore.kernel.org/all/20250825181434.3340805-1-sashal@kernel.org/
>> 
>> 
>> [...snip...]
>> 

