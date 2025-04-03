Return-Path: <kvm+bounces-42590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D30D5A7A5BA
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 16:55:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A67673A51DF
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC1E2505A6;
	Thu,  3 Apr 2025 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SfcD3s2E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E551F7569
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743691881; cv=none; b=OKcDkE/oQo4D1wnUqp65cNMEw5SQ9FbyH8W9eYGQy6WWZ6yq+a/fQtTQ0TrQG0EOqu5MwN2EAXW+XyGOhNDnWdgSB+cHc5Zw7v3YHLG8dOuDViPsniotqlQIsNkvSZ7/1TMrhBActSfNF5iJ1d6vi7DsQJYa/71pw/HvCefdWPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743691881; c=relaxed/simple;
	bh=qAwLou4Y/45MbJ+30oZTx+YiENjCyam+2wdnrLN5cao=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eir8xnWH4fhdk46sy4xMsDucdj7MEUZwU2WyVu45Hz3UE5Kf018ZJ/LiyNalOHgaTVhGhqdZ7DSwGY9QDC44dpiKJ2b5TFmeFrTs4tpCnAivo2DXT4TvPXIzPPyyd3k/qUtZUlZk45mXA3KkutxSTqeJ7ZGD/VXkhzDK69tZBRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SfcD3s2E; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-739731a2c25so716630b3a.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 07:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743691878; x=1744296678; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j0DsqAwVuYx2JlbaG0XtUhFv119f/MD4c6JOjjoA75o=;
        b=SfcD3s2ECO0U9YlkNV5P6LnRynzuYhn8+swSEJG247eqwZZsxovv7rYuHKguj8bHh+
         swr9fvfX+Gm4cO9GWJu+jOJYtKIzyS/A3LYfnlCYFyVVA9ipc81wrxUQr6AmtFPZkFd2
         7KP52PuU+bjLKMxwg9Vs27i78tZBHVEEGZWY6sJxZYklBAzyxsoxJecYip/Mz/gIGfx+
         aS7UPUaoyRIcHyr8KLLAx+ZZ5vvRmbH8MhHpt74+Wa0JHvS5kqmiQ3rv1gnZwy9IfyUq
         xErZYDVk0/VvLCwdsbck5xDGGdYGcU51hIUmXMHyIPhQPp+DlFUjjrDm40cb06pAP+4B
         XPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743691878; x=1744296678;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j0DsqAwVuYx2JlbaG0XtUhFv119f/MD4c6JOjjoA75o=;
        b=KgoTZunIU9NV0SCEAafseK/9AMVIeXujwIeNL7LWS3vblB/EB5pX2IgkvziBNFxBdp
         eT4UgdJlg9+OwXqYNx3xhk77EJSQTdVylsqTas0j7mRxXT8h22GZ4U05Wz+vJU12RwGz
         cIMoiQmju+xKKEZEsIGWGBBtm/qxKtjYbaSombeX4bxN4mZ36rbAXhtgkz1EgYcGR+eV
         weeVhwghDm4c0bB8afQkITat3oDmfWhZl4VAhjYDGOnRRMA0jc/2R9wGsZXQHJwmwO7H
         F+pRjji34tGiAwT4RWGg72mjmf9GWP8DBX+uNgANAy7PmBKDf1c4EksqxF2829SCgaPJ
         j1nA==
X-Forwarded-Encrypted: i=1; AJvYcCW8guipIWw+KdS3BbGsBAQjB+Gl9eoJFNBzf0FB53KFHkODozmRg1O8JyoXfHFjMatA+ug=@vger.kernel.org
X-Gm-Message-State: AOJu0YztHkt28nPq9BnyxPZjCKPXcyYlZcHGxyS+rWXrzj9u2YeIKq6A
	Rg/1VH3O9bv5A7o7Ovs2mwix4Z2PZJIwBn3THS/AKmEjVf8e1AJP/cLedw9lLtMIFSkPug5vs74
	vuw==
X-Google-Smtp-Source: AGHT+IHIfp2PQ0wir4voLq3Rtr5JW7agosUIXmr9O6oujdKyzhKg8JPLhWkNwiyUIpcw5c9imGXaxi3lq9Q=
X-Received: from pfdr14.prod.google.com ([2002:aa7:8b8e:0:b0:736:451f:b9f4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:888d:0:b0:736:6ecd:8e32
 with SMTP id d2e1a72fcca58-739da128974mr2769958b3a.21.1743691878251; Thu, 03
 Apr 2025 07:51:18 -0700 (PDT)
Date: Thu, 3 Apr 2025 07:51:16 -0700
In-Reply-To: <CA+EHjTwEFm1=pS6hBJ++zujkHCDQtCq548OKZirobPbzCzTqSA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-4-tabba@google.com> <diqz1puanquh.fsf@ackerleytng-ctop.c.googlers.com>
 <Z-3OtjCJYyMXuUX7@google.com> <CA+EHjTwEFm1=pS6hBJ++zujkHCDQtCq548OKZirobPbzCzTqSA@mail.gmail.com>
Message-ID: <Z-6gZGSbOvfrTPjV@google.com>
Subject: Re: [PATCH v7 3/7] KVM: guest_memfd: Track folio sharing within a
 struct kvm_gmem_private
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 03, 2025, Fuad Tabba wrote:
> On Thu, 3 Apr 2025 at 00:56, Sean Christopherson <seanjc@google.com> wrote:
> > On Wed, Apr 02, 2025, Ackerley Tng wrote:
> > > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > > index ac6b8853699d..cde16ed3b230 100644
> > > > --- a/virt/kvm/guest_memfd.c
> > > > +++ b/virt/kvm/guest_memfd.c
> > > > @@ -17,6 +17,18 @@ struct kvm_gmem {
> > > >     struct list_head entry;
> > > >  };
> > > >
> > > > +struct kvm_gmem_inode_private {
> > > > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > > > +   struct xarray shared_offsets;
> > > > +   rwlock_t offsets_lock;
> > >
> > > This lock doesn't work, either that or this lock can't be held while
> > > faulting, because holding this lock means we can't sleep, and we need to
> > > sleep to allocate.
> >
> > rwlock_t is a variant of a spinlock, which can't be held when sleeping.
> >
> > What exactly does offsets_lock protect, and what are the rules for holding it?
> > At a glance, it's flawed.  Something needs to prevent KVM from installing a mapping
> > for a private gfn that is being converted to shared.  KVM doesn't hold references
> > to PFNs while they're mapped into the guest, and kvm_gmem_get_pfn() doesn't check
> > shared_offsets let alone take offsets_lock.
> 
> You're right about the rwlock_t. The goal of the offsets_lock is to
> protect the shared offsets -- i.e., it's just meant to protect the
> SHARED/PRIVATE status of a folio, not more, hence why it's not checked
> in kvm_gmem_get_pfn(). It used to be protected by the
> filemap_invalidate_lock, but the problem is that it would be called
> from an interrupt context.
> 
> However, this is wrong, as you've pointed out. The purpose of locking
> is to ensure  that no two conversions of the same folio happen at the
> same time. An alternative I had written up is to rely on having
> exclusive access to the folio to ensure that, since this is tied to
> the folio. That could be either by acquiring the folio lock, or
> ensuring that the folio doesn't have any outstanding references,
> indicating that we have exclusive access to it. This would avoid the
> whole locking issue.
> 
> > ... Something needs to prevent KVM from installing a mapping
> > for a private gfn that is being converted to shared.  ...
> 
> > guest_memfd currently handles races between kvm_gmem_fault() and PUNCH_HOLE via
> > kvm_gmem_invalidate_{begin,end}().  I don't see any equivalent functionality in
> > the shared/private conversion code.
> 
> For in-place sharing, KVM can install a mapping for a SHARED gfn. What
> it cannot do is install a mapping for a transient (i.e., NONE) gfn. We
> don't rely on kvm_gmem_get_pfn() for that, but on the individual KVM
> mmu fault handlers, but that said...

Consumption of shared/private physical pages _must_ be enforced by guest_memfd.
The private vs. shared state in the MMU handlers is that VM's view of the world
and desired state.  The guest_memfd inode is the single source of true for the
state of the _physical_ page.

E.g. on TDX, if KVM installs a private SPTE for a PFN that is in actuality shared,
there will be machine checks and the host will likely crash.

> > I would much, much prefer one large series that shows the full picture than a
> > mish mash of partial series that I can't actually review, even if the big series
> > is 100+ patches (hopefully not).
> 
> Dropping the RFC from the second series was not intentional, the first
> series is the one where I intended to drop the RFC. I apologize for
> that.  Especially since I obviously don't know how to handle modules
> and wanted some input on how to do that :)

In this case, the rules for modules are pretty simple.  Code in mm/ can't call
into KVM.  Either avoid callbacks entirely, or implement via a layer of
indirection, e.g. function pointer or ops table, so that KVM can provide its
implementation at runtime.

