Return-Path: <kvm+bounces-47285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8DD7ABF923
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA13C4A0253
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2A51DC9B5;
	Wed, 21 May 2025 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+FCnITc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB6E1D63DF
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747841056; cv=none; b=DTFhy4hyRoAUs//3okIeX4BR13GuHdIWMkOqeVQdN1buSIPa7dn3kuBwG6b0tTejTQIxxX1t+EN/eeWqWV/I1T6c5hvNBmCq97Wu1b9dYzOzDyka6m6yQYIzCBIrCD5m2D1wIITMotbwMq7COoJqL1nikdeVKcnDqWTJCPLt76w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747841056; c=relaxed/simple;
	bh=7CodgDFGCpMBU+/Bg+diyCYhpTJXE+AvR7xj10i+qZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ok7/VYVp+kf10r4vjmyIx9uoXulV/FOitLtL9+vBuRsnmnEhlfPaJfdZEsRFB6uyBkbTNRGy357iq3yiNXQmd3plveL+kCjC5uOMaK/dpJIg4tWqCNKHc5q9z1Qv0TAQkPwKmBqrj30iMkU9YYeqiJrYjG/VtNhdMp0eXajXioc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H+FCnITc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747841053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8vqJcgtD0m0cV+LRe+RWGRd1MfJDepFj2iZqcJ0qHUQ=;
	b=H+FCnITc3xVOnmi69/DMoPRxRxdQSIliZq2zXs6HOoeIl0AvxTHtZwKod/4qtjdil/8pOx
	yr7mW0Et/HbKRmhU/VWdDdbVSRYyxPoBi52wtLUIpZepvgDCjVu6LvyBlDS86V8H/ZJPTN
	ns8vXlVu3KrTfGNApTvYnCCO1XsW6EY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-UvtWHzEXNYKO5H_cPhT3sQ-1; Wed, 21 May 2025 11:24:11 -0400
X-MC-Unique: UvtWHzEXNYKO5H_cPhT3sQ-1
X-Mimecast-MFC-AGG-ID: UvtWHzEXNYKO5H_cPhT3sQ_1747841051
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c5f3b94827so1114191485a.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747841051; x=1748445851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vqJcgtD0m0cV+LRe+RWGRd1MfJDepFj2iZqcJ0qHUQ=;
        b=txDbZjS34/VJ+/gCsM4hU3BcAmXOZysPLKoxBzEj6pEMOsVRZcfaXFvkP2HFVNF5fU
         1avqMbyTE52UjeirTsq3SN+E915xtJT2+W4u5/6e/5gg04YlhpIhztrKrRceLyblrjOt
         as7tnhEl8noyyt4tm9iF2MkdLy2ldT16IKyEpIB9oy3flEH20GWzK7HNSCJD7LYfNZAT
         QugTe8LtIBxRuZj8xaZaVM4SA7mWncbrfOZnIrGq26LhJs8bSy+I8Bol08qtFdcnpRgR
         8wBvIrkByQ+bZ82TedhMGEMvc4lzZgbSHhVhnaqfXMOfXeKd9XBn5/BZUiLgI7ovDNYi
         jM+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwg5Ga+ZNMMRf+IgIHUATl4jDYXbfu5nc196CjZNiIb3KIwFTHN196VWosriPdKWAZawE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwODspgnS68uqq2VAbf2ITLwLBJMLo4LZmL1Kea15ca/ACK6XPz
	3YHJfxepKKDOnNdL7TR18jXWx1MivGMHBCh+gMwYTjekPc182DL2tXBC3ZpcOCGrSeYxQDb2QRP
	oGu4DdWYJv/B81vzEK5Q1KONm1fD+jNzjtuKknjixrThKCV8isQDilA==
X-Gm-Gg: ASbGncvWaavAuxHCYO6rfb4R6tRZPcZNr4RTZpeqQMFZkYK6JvLNLAkXrVt+AWV0sFL
	OPW8XY78I6+NpjOhJNshX7vVF1HzET5kEF2HW2iDUgWK5EdBmUx56inIo6B6gVXjk28k1/bfmJ+
	IYj3HKdwNEGsbQdMUcNxUls/5tWEYQJ6jWVRQQhSl4ds6hOStZJDqWCva0iIBGr+8EfEnTvLXio
	BYMqy1NVccGRz7bue6pthgMhGOWJFoz2NwWiUU2h0UVZoxRYwzyS7cOdV4gH3K/0FVq2+6Hds4n
	WeY=
X-Received: by 2002:a05:620a:2994:b0:7c5:3c0a:ab7e with SMTP id af79cd13be357-7cd46707c65mr2827172285a.5.1747841051357;
        Wed, 21 May 2025 08:24:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpKCsLZK8fldjDSKpxmr3xZ4LVd50UA3aAZSvoaTqmv4NchFdKg38lljbXixaCEhED3occeQ==
X-Received: by 2002:a05:620a:2994:b0:7c5:3c0a:ab7e with SMTP id af79cd13be357-7cd46707c65mr2827169685a.5.1747841050957;
        Wed, 21 May 2025 08:24:10 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd468cc782sm886213785a.101.2025.05.21.08.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 08:24:10 -0700 (PDT)
Date: Wed, 21 May 2025 11:24:07 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	James Houghton <jthoughton@google.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 0/6]  KVM: Dirty ring fixes and cleanups
Message-ID: <aC3wFwFwFbLlsIft@x1.local>
References: <20250516213540.2546077-1-seanjc@google.com>
 <aCzUIsn1ZF2lEOJ-@x1.local>
 <aC0NMJIeqlgvq0yL@google.com>
 <aC0VlENyfE9ewuTF@x1.local>
 <aC3oIjkivS2KqKZH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aC3oIjkivS2KqKZH@google.com>

On Wed, May 21, 2025 at 07:50:10AM -0700, Sean Christopherson wrote:
> On Tue, May 20, 2025, Peter Xu wrote:
> > On Tue, May 20, 2025 at 04:16:00PM -0700, Sean Christopherson wrote:
> > > On Tue, May 20, 2025, Peter Xu wrote:
> > > > On Fri, May 16, 2025 at 02:35:34PM -0700, Sean Christopherson wrote:
> > > > > Sean Christopherson (6):
> > > > >   KVM: Bound the number of dirty ring entries in a single reset at
> > > > >     INT_MAX
> > > > >   KVM: Bail from the dirty ring reset flow if a signal is pending
> > > > >   KVM: Conditionally reschedule when resetting the dirty ring
> > > > >   KVM: Check for empty mask of harvested dirty ring entries in caller
> > > > >   KVM: Use mask of harvested dirty ring entries to coalesce dirty ring
> > > > >     resets
> > > > >   KVM: Assert that slots_lock is held when resetting per-vCPU dirty
> > > > >     rings
> > > > 
> > > > For the last one, I'd think it's majorly because of the memslot accesses
> > > > (or CONFIG_LOCKDEP=y should yell already on resets?).  
> > > 
> > > No?  If KVM only needed to ensure stable memslot accesses, then SRCU would suffice.
> > > It sounds like holding slots_lock may have been a somewhat unintentional,  but the
> > > reason KVM can't switch to SRCU is that doing so would break ordering, not because
> > > slots_lock is needed to protect the memslot accesses.
> > 
> > Hmm.. isn't what you said exactly means a "yes"? :)
> > 
> > I mean, I would still expect lockdep to report this ioctl if without the
> > slots_lock, please correct me if it's not the case.
> 
> Yes, one of slots_lock or SRCU needs to be held.
> 
> > And if using RCU is not trivial (or not necessary either), so far the
> > slots_lock is still required to make sure the memslot accesses are legal?
> 
> I don't follow this part.  The intent of the comment is to document why slots_lock
> is required, which is exceptional because memslot access for readers are protected
> by kvm->srcu.

I always think it's fine to take slots_lock for readers too.  RCU can
definitely be better in most cases..

> The fact that slots_lock also protects memslots is notable only
> because it makes acquiring kvm->srcu superfluous.  But grabbing kvm->srcu is still
> safe/legal/ok:
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 1ba02a06378c..6bf4f9e2f291 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -121,18 +121,26 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>         u64 cur_offset, next_offset;
>         unsigned long mask = 0;
>         struct kvm_dirty_gfn *entry;
> +       int idx;
>  
>         /*
>          * Ensure concurrent calls to KVM_RESET_DIRTY_RINGS are serialized,
>          * e.g. so that KVM fully resets all entries processed by a given call
> -        * before returning to userspace.  Holding slots_lock also protects
> -        * the various memslot accesses.
> +        * before returning to userspace.
>          */
>         lockdep_assert_held(&kvm->slots_lock);
>  
> +       /*
> +        * Holding slots_lock also protects the various memslot accesses, but
> +        * acquiring kvm->srcu for read here is still safe, just unnecessary.
> +        */
> +       idx = srcu_read_lock(&kvm->srcu);
> +
>         while (likely((*nr_entries_reset) < INT_MAX)) {
> -               if (signal_pending(current))
> +               if (signal_pending(current)) {
> +                       srcu_read_unlock(&kvm->srcu, idx);
>                         return -EINTR;
> +               }
>  
>                 entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>  
> @@ -205,6 +213,8 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>         if (mask)
>                 kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>  
> +       srcu_read_unlock(&kvm->srcu, idx);
> +
>         /*
>          * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
>          * by the VCPU thread next time when it enters the guest.
> --
> 
> And unless there are other behaviors that are protected by slots_lock (which is
> entirely possible), serializing the processing of each ring could be done via a

Yes, I am not the original author, but when I was working on it I don't
remember anything relying on that.  However still it's possible it can
serialize some operations under the hood (which will be true side effect of
using this lock..).

> dedicated (for example only, the dedicated mutex could/should be per-vCPU, not
> global).
> 
> This diff in particular shows why I ordered and phrased the comment the way I
> did.  The blurb about protecting memslot accesses is purely a friendly reminder
> to readers.  The sole reason for an assert and comment is to call out the need
> for ordering.
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 1ba02a06378c..92ac82b535fe 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -102,6 +102,8 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>         return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
>  }
>  
> +static DEFINE_MUTEX(per_ring_lock);
> +
>  int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>                          int *nr_entries_reset)
>  {
> @@ -121,18 +123,22 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>         u64 cur_offset, next_offset;
>         unsigned long mask = 0;
>         struct kvm_dirty_gfn *entry;
> +       int idx;
>  
>         /*
>          * Ensure concurrent calls to KVM_RESET_DIRTY_RINGS are serialized,
>          * e.g. so that KVM fully resets all entries processed by a given call
> -        * before returning to userspace.  Holding slots_lock also protects
> -        * the various memslot accesses.
> +        * before returning to userspace.
>          */
> -       lockdep_assert_held(&kvm->slots_lock);
> +       guard(mutex)(&per_ring_lock);
> +
> +       idx = srcu_read_lock(&kvm->srcu);
>  
>         while (likely((*nr_entries_reset) < INT_MAX)) {
> -               if (signal_pending(current))
> +               if (signal_pending(current)) {
> +                       srcu_read_unlock(&kvm->srcu, idx);
>                         return -EINTR;
> +               }
>  
>                 entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>  
> @@ -205,6 +211,8 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>         if (mask)
>                 kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>  
> +       srcu_read_unlock(&kvm->srcu, idx);
> +
>         /*
>          * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
>          * by the VCPU thread next time when it enters the guest.
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 571688507204..45729a6f6451 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4908,16 +4908,12 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
>         if (!kvm->dirty_ring_size)
>                 return -EINVAL;
>  
> -       mutex_lock(&kvm->slots_lock);
> -
>         kvm_for_each_vcpu(i, vcpu, kvm) {
>                 r = kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring, &cleared);
>                 if (r)
>                         break;
>         }
>  
> -       mutex_unlock(&kvm->slots_lock);
> -
>         if (cleared)
>                 kvm_flush_remote_tlbs(kvm);
> --
> 

I think we almost agree on each other, and I don't see anything
controversial.

It's just that for this path using srcu may have slight risk of breaking
what used to be serialized as you said.  Said that, I'd be surprised if
so.. even if aarch64 is normally even trickier and it now also supports the
rings.  So it's just that it seems unnecessary yet to switch to srcu,
because we don't expect any concurrent writters anyway.

So totally no strong opinion on how the comment should be laid out in the
last patch - please feel free to ignore my request.  But I hope I stated
the fact, that in the current code base the slots_lock is required to
access memslots safely when rcu isn't around..

Thanks,

-- 
Peter Xu


