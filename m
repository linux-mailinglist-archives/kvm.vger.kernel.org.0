Return-Path: <kvm+bounces-59448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3975BB5A33
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 01:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B612F1AE421E
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 23:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B38D2C0F8F;
	Thu,  2 Oct 2025 23:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXCy0j1t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74B526A0A7
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 23:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759449079; cv=none; b=n+YQ6NNrNPgt3PBGP59GviGNctLLIDyA5jXAAQqSm2VuCcPrlDZmgorB6j4yQxgyFklehSQMgSPDlhOVg3sRHV/s1aB5bZHcFVSi2YA7yg28XkcN06rNp4sHh3gDJRjwRCw7m84cVnDBQ+us0Y6Ehc+hj4dRFKs0m6DRMPSUrSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759449079; c=relaxed/simple;
	bh=4S0zhWFtG3eZj9J0/xePjP4M0Bwd2/giZoqCZTW1jUc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PL6HumJuRiHA4hFdGOH2GPCvl1z+RSDAd4RWiNvtQjxvu5Ni8cBJ2z24LKGEEurHAHmqak9nBKk9dcC5rcLrzE0amsPHzopp4ZhdhB3teK/FbmU4CFNyAZ5nSgikvUv+45E0618ig2uuEHQc8vwE0BDY+RFFKA1I6tMDD5V3svo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uXCy0j1t; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7811a602576so2210710b3a.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 16:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759449077; x=1760053877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lV6kU18ljJ0dxk3XSSzUGg8U1vG+s7/1h2PQkgl2qAE=;
        b=uXCy0j1tIIKwhV3Eo3fNIox1EETN/lmIIaFzkBNeilMMfnqmRQ+CLJqLr2SsdM5C8A
         Qe0COYk5QH30QqpUoH1DuEEsttXRO0owEOidfGvlOSMRtepH/uqOuNRsyypvI3DPwmwn
         z113EcsUt7t02BWkvyw/LG9psu5mtTkwhGOx0xlTwwY3JyYETVHQtrQ8zd3UqRs/GYrM
         vjB4FLuvxPGBx3G+3caQA1dNYUvjuGzRAbb8YNLyQcDECTYZaqy4BsYYH8QOd7B7Xfvs
         WQIDJbQmw7RZ0wlT9VFLqpWsHWlnyOTmXQMKLbW+quXuk/1wXVUqtHcsJqFZ22oPc9Oq
         kpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759449077; x=1760053877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lV6kU18ljJ0dxk3XSSzUGg8U1vG+s7/1h2PQkgl2qAE=;
        b=ELsF7BEpbkQXCp0VYIDpD/Bq//OvwMSCF8k6A04bphpoz4u1p4RNKlMAgcFdDIt5KS
         UuHMiCZbdHMNN501zd1vZ0r3yaM4Gtv8QbxJZ9CdPsZof3eUOdNaVwJM6NHMS6CLjEzC
         xbibrUdaHy+56YH4kSv0Yp6HBPfGeHcmDV0Daoq1UVsXS58rynv5XX4yd2AcqKj6l7+l
         m1gTxN1QMNNInFyOJXNU3EvY9Z4EdBiEpeAEQJ/mKGZP/xQvFGGHBPkZL3ppWAcSpi9f
         noWyB/A0i4I51tqZRQUPRvJ1lAtvRtIbWzhS94SVHlRslBNdvM1MvAOfG5qbelXHdiGF
         sTVg==
X-Gm-Message-State: AOJu0YzvRGQ2+r3lkimQ2bAp38quJQ4gF0zLANlFxBpswOwvvskHEmJp
	PxyoRb/ZZTBa1NRw/p/OKtJLDkhJrtGR+W11uMXuqAhWnm4z50B0J2gbEjeseEqVlMQHHlcfbOz
	bWmvKWQ==
X-Google-Smtp-Source: AGHT+IHBUWpSfoqz6bNDbuRLm77zG7hkwgs6l+b7AyUGmi0F2ScwQi1v6ouRO4Ao1sSxMXa6nEVCtvgk8Kc=
X-Received: from pfkm7.prod.google.com ([2002:a05:6a00:807:b0:776:1344:ca77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1796:b0:781:2177:1c9b
 with SMTP id d2e1a72fcca58-78c98cb9f4fmr2014775b3a.17.1759449076867; Thu, 02
 Oct 2025 16:51:16 -0700 (PDT)
Date: Thu, 2 Oct 2025 16:51:15 -0700
In-Reply-To: <diqzy0ptspzl.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <diqzbjmrt000.fsf@google.com>
 <aN1bXOg3x0ZdTI1D@google.com> <diqz1pnmtg4h.fsf@google.com>
 <aN3KfrWERpXsj3ld@google.com> <diqzy0ptspzl.fsf@google.com>
Message-ID: <aN8P87AXlxlEDdpP@google.com>
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

On Thu, Oct 02, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Oct 01, 2025, Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> >> I'd prefer not to have the module param choose between the use of
> >> >> mem_attr_array and guest_memfd conversion in case we need both
> >> >> mem_attr_array to support other stuff in future while supporting
> >> >> conversions.
> >> >
> >> > Luckily, we don't actually need to make a decision on this, because PRIVATE is
> >> > the only attribute that exists.  Which is partly why I want to go with a module
> >> > param.  We can make the behavior very definitive without significant risk of
> >> > causing ABI hell.
> >> >
> >> 
> >> Then maybe I'm misunderstanding the static_call() thing you were
> >> describing. Is it like, at KVM module initialization time,
> >> 
> >>     if module_param == disable_tracking:
> >>         .__kvm_get_memory_attributes = read_attributes_from_guest_memfd
> >>     else
> >>         .__kvm_get_memory_attributes = read_attributes_from_mem_attr_array
> >> 
> >> With that, I can't have both CoCo private/shared state tracked in
> >> guest_memfd and RWX (as an example, could be any future attribute)
> >> tracked in mem_attr_array on the same VM.
> >
> > More or less.
> >
> 
> Hm okay. So introducing the module param will only allow the use of one
> of the following?
> 
> + KVM_SET_MEMORY_ATTRIBUTES (vm ioctl)
> + KVM_SET_MEMORY_ATTRIBUTES2 (guest_memfd ioctl)
> 
> Then I guess using a module param which is a weaker userspace contract
> allows us to later enable both vm and guest_memfd ioctl if the need
> arises?

In theory.  More importantly from my perspective, making the knob global instead
of per-VM simplifies the implementation.

> >> + KVM_SET_MEMORY_ATTRIBUTES
> >>     + Is VM ioctl
> >>     + Is a write-only ioctl
> >>     + Is for setting memory attributes at a VM level
> >>     + Use struct kvm_memory_attributes for this
> >> + KVM_GUEST_MEMFD_SET_MEMORY_ATTRIBUTES (name TBD)
> >>     + Is guest_memfd ioctl
> >>     + Is a read/write ioctl
> >>     + Is for setting memory attributes only for this guest_memfd
> >>     + Use struct guest_memfd_memory_attributes for this
> >>     + Also decode errors from this struct
> >
> >       + Has extra padding for future expansion (because why not)
> >
> > If we really truly need a new ioctl, I'd probably prefer KVM_SET_MEMORY_ATTRIBUTES2.
> > Yeah, it's silly, but I don't think baking GUEST_MEMFD into the names buys us
> > anything.  Then we can use KVM_SET_MEMORY_ATTRIBUTES2 on a VM if the need ever
> > arises.
> >
> 
> I'm for having a new ioctl number and new struct, which are you leaning
> towards?
> 
> As for the naming, I think it's confusing to have something similar, and
> Ira mentioned it being confusing in the other email too.

It might sound confusing, but I don't think the _code_ will be confusing.  If it's
a module param, it's guaranteed to be global for any VMM.  Then the conversion code
can be a simple redirect, e.g. I would expect/hope the QEMU change to be something
like:

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f89568bfa3..5253cf7275 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1421,6 +1421,10 @@ static int kvm_set_memory_attributes(hwaddr start, uint64_t size, uint64_t attr)
     int r;
 
     assert((attr & kvm_supported_memory_attributes) == attr);
+
+    if (kvm_use_gmem_attributes)
+        return kvm_get_gmem_fd(start, size, attr);
+
     attrs.attributes = attr;
     attrs.address = start;
     attrs.size = size;

> At the same time, I accept that it's useful if the same struct were to be
> used for a new iteration of the KVM_SET_MEMORY_ATTRIBUTES VM ioctl in future.
> No strong preference either way on naming.
> 
> Trying to understand the difference between unwind on failure vs
> all-or-nothing:
> 
> > Alternative #1 is to try and unwind on failure, but that gets complex, and it
> > simply can't be done for some CoCo VMs.  E.g. a private=>shared conversion for
> > TDX is descrutive.
> >
> 
> Unwind on failure is:
> 
> 1. Store current state
> 2. Convert
> 3. Restore current state on conversion failure

Not quite, the above is missing key steps that cause problems: invalidation and
memory allocation.

 1. Zap stage-1 mappings
 2. Check if range can be converted
 3. Zap stage-2 mappings
 4. Store state for target range

For TDX, #3 is the point of no return.  That means #4 must not fail, because at
the very least invididual page conversions need to be atomic.

> > Alternative #2 is to make the updates atomic and all-or-nothing, which is what
> > we did for per-VM attributes.  That's doable, but it'd either be much more
> > complex than telling userspace to retry, or we'd have to lose the maple tree
> > optimizations (which is effectively what we did for per-VM attributes).
> >
> 
> All-or-nothing:
> 
> 1. Do everything to make sure conversion doesn't fail, bail early if it
>    fails
> 2. Convert (always successful)
> 
> Is that it?

No, because #1 is non-trivial.  The wrinkle is that, without doing an initial
pass through mtree, it's impossible to know how many new entries will be needed
(which you already know).  It's a solvable problem,  e.g. in this RFC, it's kinda
sorta handled by allocating temporary structures to track the mtree metadata, but
that's the type of complexity I want to avoid.

> Zapping private pages from the stage 2 page tables for TDX can't be
> recovered without help from the guest (I think that's what you're
> talking about too), 

Ya.

> although technically I think this zapping step could be delayed right till the end.

Hmm.  If we fully committed to blocking all "gets" via the filemap lock, then
yes, I think it could be delayed until the end?  Tempting.   But as you note
below, I'd prefer to give ourselves an out from an ABI perspective.

> Maple tree allocations for conversion could fail, 

Ya, in my local version I handle that by pre-allocating.

	mas_for_each(&mas, entry, end - 1) {
		MA_STATE(m2, &gi->attributes, 0, 0);

		if (attrs->attributes == xa_to_value(entry))
			continue;

		r = kvm_gmem_mas_preallocate(&m2, attrs->attributes, start, end);
		if (r) {
			*err_index = m2.index;
			goto out;
		}

		unmap_mapping_pages(mapping, start, nr_pages, false);

		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages, err_index)) {
			mas_destroy(&m2);
			r = -EAGAIN;
			goto out;
		}

		kvm_gmem_invalidate_begin(inode, start, end);

		mas_store_prealloc(&m2, xa_mk_value(attrs->attributes));

		kvm_gmem_invalidate_end(inode, start, end);
	}

> and allocations are a bit more complicated since we try to compact ranges
> with the same shared/private status into one same maple tree node. Still
> technically possible, maybe by updating a copy of the maple tree first, then
> swapping the current maple tree out atomically.

Heh, more complexity I'd prefer to avoid.

> With HugeTLB, undoing HVO needs pages to be allocated, will need more
> digging into the details to determine if preallocation could work.

It has to work, otherwise we're hosed.  Though it should be noted that "preallocate"
here just means before kvm_gmem_invalidate_begin().  Everything up to that point
can fail.

The other option in all of this is to add an API to _block_ stage-2 mappings, in
TDX terminology.  In TDX, BLOCK marks leaf S-EPT entries !PRESENT, but preserves
all the metadata.  So if we're too scared to do an after-the-fact invalidation,
and we need to support failure after kvm_gmem_invalidate_begin(), we could rework
the TDX backend to support e.g. kvm_gmem_invalidate_abort().  On begin(), KVM 
would BLOCK mappings; on abort(), restore; on end() fully remove.

> I'd still prefer having the option to return an error so that we don't
> paint ourselves into a corner.

Yep, my thoughts exactly.

