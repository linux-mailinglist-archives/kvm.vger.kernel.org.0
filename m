Return-Path: <kvm+bounces-45526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD54BAAB2B5
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E6F37A2704
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC280278756;
	Tue,  6 May 2025 00:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UKoPz4Ma"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C22A2D8DD9
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 22:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485836; cv=none; b=An9uKA4XeGUEAFvDbwgFg8LzFkgWzt/P6u6gy+hKjAHQQ5x26LQ4Qf+1QcPxTAF2HKvO40+9RGaNNqaodt7Bl5qv4NRD8F4hHcjBTE/jiWGD37VR6P6RRvumxLaQGbg+qeEq/GS9vXPaTSj82XIRJ9EMk4Igi+lxBKzCCOB6Plg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485836; c=relaxed/simple;
	bh=5FAB2DrVgNkneWnFduFOBeIupq6k+CYl8Di4tn7ESHg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DhJwM2Y5CHNp/fURULqAfMrUOBgdlvEe548zc2Rd6b945bdh0JX7gijaV5Cl15R1gvF/YGzKwpdTLSU8FB1J4BFjrHpjbqR6VkP9Ab4mK+bUgUFnZNpfyhRZ00Vi50UH53UrsNGC61qwVX5PPrv6RTY5QpwzmfKpLN5orP8BFH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UKoPz4Ma; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so5070958a12.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 15:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746485833; x=1747090633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0BvGs6Zljio1m1AEARRCFv5fDztVSWreYYxAG+gby+0=;
        b=UKoPz4MaZg5VT5nMtftN23nsYvaMAAOnyKfFgPpgockUvGVUNLS74I2F4IhHt5oQND
         t2GvhfPI18ID33+HzsPEf5h1SgRcZu3pCU5ToLr9DuD/VjWDClG8u/hzqqeylv2rm6f5
         SNT2+Rc38ceJyh2WI2UbPiWpUF4PA8xUd8hTrsVxseEMlJYtjPDyZ6dNLoOp6D8N5yXJ
         GVni4bGZzhxvMnjZcBfp69v3sTQsHH4SDvrzw4Q8lbrI+Rtq2fyyJZ1MjRA8/KnBNvl8
         r9F/RPmOpUT2KFFuOQvr7lcGoN7OxmcdJYyhBjRKvxiddMSj8onWSGfti6TJZoZkCKnR
         Udtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746485833; x=1747090633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0BvGs6Zljio1m1AEARRCFv5fDztVSWreYYxAG+gby+0=;
        b=sfd873lKUhUlYCbBvYqN0KnG8pYRnY9Sxx3hBYJLean0ae1S1wBjiy200BUwW8Yiyh
         9IVUxlJywUiPiUXZNJX97yrhB69vH6evhBm+0cijwt3CH14kXigagDafaSjpkRGYKqIT
         +hLSlmo4MWkG0s2ut+I6wJvE+WOjtIWTdrjUr7DIOMrIChSaC1jtYMjUHp+sjUV33b3x
         2nQR5RzdczS6I4wv6TFIIUeMZyDHfcnx+j68KHhDvmKZE7dXNHcDxXGKPLsATD2CLOkR
         j7RwVMeRDX7sL/en148R60qxgyAHY/X3q6mlgWb7v2jb7Uu3lA7tt9MDOQNvJcWPYff3
         vp0A==
X-Forwarded-Encrypted: i=1; AJvYcCV83QJ/ptRsAazw3EKB8CFM43UizIAuKYmw0sC84ULvyQ/Ml1IYfzctVGpd0ImN9ToIhbk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo5AOCbT78QPAVVXw14+FRuqE//tZX2ct2IWlP6fXdOg4Q2jwz
	NnExkwz7+G2FVZ3xxQFo1quWkzepJGt/0tdEY3k0L2QbYAcsdUNbtU+DsZFYDnhRbpzdA46AH7s
	3kQ==
X-Google-Smtp-Source: AGHT+IGr7ZwivQiQOxhRvxPnJjHbjFHUYcVKGtfq9EuMJ1XumzNpx+xuBru0RIy3XMb3f8Vooa9e9l/QbF0=
X-Received: from plbz12.prod.google.com ([2002:a17:902:ee0c:b0:22e:345d:be56])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2408:b0:223:37ec:63d5
 with SMTP id d9443c01a7336-22e32ba8292mr19044325ad.28.1746485833625; Mon, 05
 May 2025 15:57:13 -0700 (PDT)
Date: Mon, 5 May 2025 15:57:12 -0700
In-Reply-To: <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com> <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com> <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
Message-ID: <aBlCSGB86cp3B3zn@google.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, David Hildenbrand wrote:
> On 03.05.25 00:00, Ackerley Tng wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > 
> > > On Fri, May 02, 2025, David Hildenbrand wrote:
> > > > On 30.04.25 20:58, Ackerley Tng wrote:
> > > > > > -	if (is_private)
> > > > > > +	if (is_gmem)
> > > > > >    		return max_level;
> > > > > 
> > > > > I think this renaming isn't quite accurate.
> > > > 
> > > > After our discussion yesterday, does that still hold true?
> > > 
> > > No.
> > > 
> > > > > IIUC in __kvm_mmu_max_mapping_level(), we skip considering
> > > > > host_pfn_mapping_level() if the gfn is private because private memory
> > > > > will not be mapped to userspace, so there's no need to query userspace
> > > > > page tables in host_pfn_mapping_level().
> > > > 
> > > > I think the reason was that: for private we won't be walking the user space
> > > > pages tables.
> > > > 
> > > > Once guest_memfd is also responsible for the shared part, why should this
> > > > here still be private-only, and why should we consider querying a user space
> > > > mapping that might not even exist?
> > > 
> > > +1, one of the big selling points for guest_memfd beyond CoCo is that it provides
> > > guest-first memory.  It is very explicitly an intended feature that the guest
> > > mappings KVM creates can be a superset of the host userspace mappings.  E.g. the
> > > guest can use larger page sizes, have RW while the host has RO, etc.
> > 
> > Do you mean that __kvm_mmu_max_mapping_level() should, in addition to
> > the parameter renaming from is_private to is_gmem, do something like
> > 
> > if (is_gmem)
> > 	return kvm_gmem_get_max_mapping_level(slot, gfn);

No, kvm_gmem_get_pfn() already provides the maximum allowed order, we "just" need
to update that to constrain the max order based on shared vs. private.  E.g. from
the original guest_memfd hugepage support[*] (which never landed), to take care
of the pgoff not being properly aligned to the memslot.

+	/*
+	 * The folio can be mapped with a hugepage if and only if the folio is
+	 * fully contained by the range the memslot is bound to.  Note, the
+	 * caller is responsible for handling gfn alignment, this only deals
+	 * with the file binding.
+	 */
+	huge_index = ALIGN(index, 1ull << *max_order);
+	if (huge_index < ALIGN(slot->gmem.pgoff, 1ull << *max_order) ||
+	    huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages)
 		*max_order = 0;

[*] https://lore.kernel.org/all/20231027182217.3615211-18-seanjc@google.com

> I assume you mean, not looking at lpage_info at all?
> 
> I have limited understanding what lpage_info is or what it does. I believe
> all it adds is a mechanism to *disable* large page mappings.

Correct.  It's a bit of a catch-all that's used by a variety of KVM x86 features
to disable hugepages.

> We want to disable large pages if (using 2M region as example)
> 
> (a) Mixed memory attributes. If a PFN falls into a 2M region, and parts
>     of that region are shared vs. private (mixed memory attributes ->
>     KVM_LPAGE_MIXED_FLAG)
> 
>  -> With gmem-shared we could have mixed memory attributes, not a PFN
>     fracturing. (PFNs don't depend on memory attributes)
> 
> (b) page track: intercepting (mostly write) access to GFNs

It's also used to handle misaligned memslots (or sizes), e.g. if a 1GiB memory
region spanse 1GiB+4KiB => 2GiB+4KiB, KVM will disallow 1GiB hugepages, and 2MiB
hugepages for the head and tails.  Or if the host virtual address isn't aligned
with the guest physical address (see above for guest_memfd's role when there is
no hva).

> So, I wonder if we still have to take care of lpage_info, at least for
> handling (b) correctly [I assume so].

Ya, we do.

> Regarding (a) I am not sure: once memory attributes are handled by gmem in
> the gmem-shared case. IIRC, with AMD SEV we might still have to honor it? But
> gmem itself could handle that.
> 
> What we could definitely do here for now is:
> 
> if (is_gmem)
> 	/* gmem only supports 4k pages for now. */
> 	return PG_LEVEL_4K;
> 
> And not worry about lpage_infor for the time being, until we actually do
> support larger pages.

I don't want to completely punt on this, because if it gets messy, then I want
to know now and have a solution in hand, not find out N months from now.

That said, I don't expect it to be difficult.  What we could punt on is
performance of the lookups, which is the real reason KVM maintains the rather
expensive disallow_lpage array.

And that said, memslots can only bind to one guest_memfd instance, so I don't
immediately see any reason why the guest_memfd ioctl() couldn't process the
slots that are bound to it.  I.e. why not update KVM_LPAGE_MIXED_FLAG from the
guest_memfd ioctl() instead of from KVM_SET_MEMORY_ATTRIBUTES?

