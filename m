Return-Path: <kvm+bounces-59396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60356BB3455
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11CFF561F1B
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE4F2FDC58;
	Thu,  2 Oct 2025 08:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lnI/760H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6442FDC35
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759393502; cv=none; b=rtObn1dakVuzhe8jxQBkmNff6/k9ECuBo8MGDjnYRl39HXIjiQfy08Kov5aUsdu8GQInNjaBdeo5acaADeI5k0ztXzm7yuUEvi2RiDJppuUJT3mFawNg6A4aSecF6vqsXEjhiJpyZctEGvd/yJfUxPxST66V6wn9VKxcp6JlOXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759393502; c=relaxed/simple;
	bh=S/kwA28Lk+ulDWGp/uZec8y56Ccih6PIxf5yluym6gQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rwubqS47/Fh83RvQw0hEF8zDxXWSXkbAJzDDNP4fT7AnDlGL7dK0jhq9FdJGlRQK+HZC359PckQskhMjMEezBVklEPvVSSAaClUj9zNKL04aADVJ5PDFnC/1PLOG7fnQ6+zgJtz8aerfkalrhKjAwu8DrYm9EUIu1dHA2r4+mmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lnI/760H; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b609c0f6522so1048732a12.3
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759393500; x=1759998300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+K3cnMgnzCi3Evq8zFItEAGdg31DclXki1g4pqp6jmg=;
        b=lnI/760HB92kTbBLhxNV/Vpzpo0G27MmIVC8QEUPTjwSW8qRIvCTJlOqnHIX+Ho3yO
         IRuUFYLuffNVm4x2rno+LQljd6ucY6MGPBoS9glMlloMsIVt0EbbOYSVRyNEgiyZj35d
         V3foL7ZPq8OgBsYbS+vlBG18/qaE0cYx3ajfyFmDBVFLDreeoXN4POzqNwcjckaqbMxS
         D4xN7UP73YXkpaSbvE6o53DYZaGYIKTmF2Kv8R/xuR7hJ8Iv7ylWHdGoxrR0H9sAOEso
         7eDJtv00rItGFDr1qEiv2Ds5HyHDjfDVgdoLvx4RDoMryt7zhUkIh0tInPsT21A893MD
         tcng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759393500; x=1759998300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+K3cnMgnzCi3Evq8zFItEAGdg31DclXki1g4pqp6jmg=;
        b=OmSRAONh2LRZTlPJREol374A7OnyK/gA+dlWSIb9xFFOHG7qu+XJl3npX9HgP08kh+
         2Pd68bxyq34rpE8onUVAJQowpIphpQYGsOU7Ouf9jJpTr7vJygxajF8GzbnCYtwaYFCa
         EDlmei4MXviCVLSwgc8Oh0Q0Az+l1QyPwYTAKikdlNULPLeI1cNpdiOn1lH+1aPPNYtX
         dhWiYu66fO8+voQQJZYtfLBn55lhZSORRhsmefl4ZgW/5VLk7CGPkaVm3dtPEaRRuBLd
         lAKLiKAyFHGz33pIYPZ6tNshCg9pm47/6I/d8+PkU0S20/uX5Q4esDLiCUr0SQuk5ygN
         5bjw==
X-Gm-Message-State: AOJu0YymD3wnQJllygbYOivQQ9YDBvQbmWZPjRpszRilFapr+E1p7RDS
	ezBazOZHnpsyM4Gz255+QNlcyDHIKbwAVtJnMHb3MwP4V+mdpwzWjTiVeyfEYg9XZ4JE37L6zHB
	wGiHfDMtST1AGJyQwRy7fD/vUEQ==
X-Google-Smtp-Source: AGHT+IF9LU6KTVZBG9fl3G8lqDjWmT+w1gbjiBmN1hetqklTAi8pEFMawdu7ASaowOIRLhKPdwA6wfjuGhq4lCYpQA==
X-Received: from plbma13.prod.google.com ([2002:a17:903:94d:b0:268:1af:fcff])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:124a:b0:25c:38be:748f with SMTP id d9443c01a7336-28e7f162cc9mr78771205ad.9.1759393500197;
 Thu, 02 Oct 2025 01:25:00 -0700 (PDT)
Date: Thu, 02 Oct 2025 08:24:59 +0000
In-Reply-To: <68ddb87b16415_28f5c229470@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <diqzbjmrt000.fsf@google.com> <68ddb87b16415_28f5c229470@iweiny-mobl.notmuch>
Message-ID: <diqzv7kxsobo.fsf@google.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Ackerley Tng <ackerleytng@google.com>
To: Ira Weiny <ira.weiny@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Ira Weiny <ira.weiny@intel.com> writes:

> Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>
> [snip]
>
>> 
>> > Internally, that let's us do some fun things in KVM.  E.g. if we make the "disable
>> > legacy per-VM memory attributes" a read-only module param, then we can wire up a
>> > static_call() for kvm_get_memory_attributes() and then kvm_mem_is_private() will
>> > Just Work.
>> >
>> >   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>> >   {
>> > 	return static_call(__kvm_get_memory_attributes)(kvm, gfn);
>> >   }
>> >
>> >   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>> >   {
>> > 	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>> >   }
>> >
>> > That might trigger some additional surgery if/when we want to support RWX
>> > protections on a per-VM basis _and_ a per-gmem basic, but I suspect such churn
>> > would pale in comparison to the overall support needed for RWX protections.
>> >
>> 
>> RWX protections are more of a VM-level property, if I understood the use
>> case correctly that some gfn ranges are to be marked non-executable by
>> userspace. Setting RWX within guest_memfd would be kind of awkward since
>> userspace must first translate GFN to offset, then set it using the
>> offset within guest_memfd. Hence I think it's okay to have RWX stuff go
>> through the regular KVM_SET_MEMORY_ATTRIBUTES *VM* ioctl and have it
>> tracked in mem_attr_array.
>> 
>> I'd prefer not to have the module param choose between the use of
>> mem_attr_array and guest_memfd conversion in case we need both
>> mem_attr_array to support other stuff in future while supporting
>> conversions.
>
> I'm getting pretty confused on how userspace is going to know which ioctl
> to use VM vs gmem.
>

It is confusing, yes!

> I was starting to question if going through the VM ioctl should actually
> change the guest_memfd flags (shareability).
>

At one of the guest_memfd biweeklies, we came to the conclusion that we
should have a per-VM KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING, which will
disable the use of just KVM_MEMORY_ATTRIBUTE_PRIVATE for the
KVM_SET_MEMORY_ATTRIBUTES ioctl, and
KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING is the only way to enable
conversions for a guest_memfd with mmap() support.

IOW, KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING makes userspace choose
either

+ Using guest_memfd for private memory and some other memory
  (e.g. anonymous memory) for shared memory (aka legacy dual backing)
    + And using KVM_SET_MEMORY_ATTRIBUTES VM ioctl for conversions
    + And using mem_attr_array to track shared/private status

+ Using guest_memfd for both private and shared memory (aka single backing)
    + And using the guest_memfd ioctl for conversions
    + And using guest_memfd shareability to track shared/private status
    
Since userspace has to choose one of the above, there's no point in the
VM ioctl affecting shareability.

Sean's suggestion of a module param moves this choice from VM-level to
KVM/host-level.

> In a prototype I'm playing with shareability has become a bit field which
> I think aligns with the idea of expanding the memory attributes.

I guess this is tangentially related and could do with some profiling,
but we should be careful about adding too many states in the maple tree.

Conversion iterates over offset ranges in the maple tree, and iteration
is faster if there are fewer nodes in the maple tree.

If we just have two states (shared/private) in the maple tree, each node
is either all private or all shared.

If we have more states, private ranges might get fragmented based on the
orthogonal bits, e.g. RWX, which could then impact conversion
performance.

> But I've
> had some issues with the TDX tests in trying to decipher when to call
> vm_set_memory_attributes() vs guest_memfd_convert_private().
>

Hope the above explanation helps!

+ Legacy dual backing: vm_set_memory_attributes()
+ Single backing: guest_memfd_convert_private()

I don't think this will change much even with the module param, since
userspace will still need to know whether to pass in a vm fd or a
guest_memfd fd.

Or maybe vm_set_memory_attributes() can take a vm fd, then query module
params and then figure out if it should pass vm or guest_mefd fds?

>> 
>> [...snip...]
>> 
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
> I don't think using the filemap_invalidate_lock() is going to work well
> here.  I've had some hangs on it in my testing and experiments.  I think
> it is better to specifically lock the state tracking itself.  I believe
> Michael mentioned this as well in a previous thread.

Definitely took the big hammer lock for a start and might be optimizable.

Considerations so far: when a conversion is happening, these have to be
locked out:

+ Conversions from competing threads
+ Allocations in kvm_gmem_fault_user_mapping(), because whether an
  offset can be faulted depends on the outcome of conversion
+ Allocations (fallocate() or kvm_gmem_get_pfn()) and truncations,
  because conversions (for now) involves removing a folio from the
  filemap, restructuring, then restoring to the filemap, and
    + Allocations should reuse a folio that was already in the filemap
    + Truncations remove a folio, and should not skip removal of a folio
      because it was taken out just for conversion
+ memory failure handling, where we don't remove folios from the
  filemap, but we might restructure, to split huge folios to just unmap
  pages with failed memory

I think essentially because conversion involves restructuring, and
restructuring involves filemap operations and other filemap operations
have to wait, conversion also takes the filemap_invalidate_lock() that
filemap operations use.

>
> Ira
>
> [snip]

