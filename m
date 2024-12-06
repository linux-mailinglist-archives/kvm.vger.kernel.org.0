Return-Path: <kvm+bounces-33183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 303079E6263
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 01:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 681311885255
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 00:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131A41EEF9;
	Fri,  6 Dec 2024 00:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dxA2HNTa"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326E643ABD
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 00:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733445972; cv=none; b=G6u3hBPMkxS1X863S6wdBLFIoDrvfpj2oWt2WHE986SxuKJ4u4GssROPzeUBkuXr3MEVyuQx18UBuulChcI3mvPntP86tZne1ufAu6YuqmG433NmE2dJVLo/Rpj7YH0MbnxiHATyWYAHpCJ4UPTep5p+dFJ9QIhuz0SOZZ2+MbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733445972; c=relaxed/simple;
	bh=0RGUP8aR1u8PiGNTSUiShD+hyc50bnVjQxicQOqIotY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ik4RdKhF6OIurf3DmVTq86UpVEYZd9eidVMesf4ncbyT4I2zARjWOc5JL6wQGtSnaS7o06CfdD7thJo8od0CaSmW1tS2w0wvC80qD24ZADHPZeOk0xubSkGtng+u8OgIRSTFCuZGEYylpaX1XtePvfsTjldqnx7ObX042V40dso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dxA2HNTa; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 5 Dec 2024 16:45:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733445956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N5nG2prdL1skIINqaX1bovIzolBU3gInNcwFgxO/rw0=;
	b=dxA2HNTaXIewdfp4tSj8/enaHs9W6w1oqZ9zhUaPD0pq2L6Zt4apsXKgnU3vsW+EkIvvdd
	QLfsh+b4yQewYZzepTteXQnOvUg8uOCIolm/2gpdPxVlqK4G2Si6meatvyPBj6Zp2FodFX
	j92vIX2Ujdc82NL3ZWqMpqXGhDFoa2o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
Message-ID: <Z1JJOfnuKQ9LCHq-@linux.dev>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <20241204191349.1730936-7-jthoughton@google.com>
 <Z1Dgr_TnaFQT04Pi@linux.dev>
 <CADrL8HWC7HhYmEBWa+5KeWmyD+iT1zPBJUAUtNyrhH7ZpLXJNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrL8HWC7HhYmEBWa+5KeWmyD+iT1zPBJUAUtNyrhH7ZpLXJNQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 05, 2024 at 03:31:05PM -0800, James Houghton wrote:
> > > @@ -2062,6 +2069,20 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> > >                                  enum kvm_mr_change change)
> > >  {
> > >       bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> > > +     u32 changed_flags = (new ? new->flags : 0) ^ (old ? old->flags : 0);
> > > +
> > > +     /*
> > > +      * If KVM_MEM_USERFAULT changed, drop all the stage-2 mappings so that
> > > +      * we can (1) respect userfault-ness or (2) create block mappings.
> > > +      */
> > > +     if ((changed_flags & KVM_MEM_USERFAULT) && change == KVM_MR_FLAGS_ONLY)
> > > +             kvm_arch_flush_shadow_memslot(kvm, old);
> >
> > I'd strongly prefer that we make (2) a userspace problem and don't
> > eagerly invalidate stage-2 mappings on the USERFAULT -> !USERFAULT
> > change.
> >
> > Having implied user-visible behaviors on ioctls is never good, and for
> > systems without FEAT_S2FWB you might be better off avoiding the unmap in
> > the first place.
> >
> > So, if userspace decides there's a benefit to invalidating the stage-2
> > MMU, it can just delete + recreate the memslot.
> 
> Ok I think that's reasonable. So for USERFAULT -> !USERFAULT, I'll
> just follow the precedent set by dirty logging. For x86 today, we
> collapse the mappings, and for arm64 we do not.
> 
> Is arm64 ever going to support collapsing back to huge mappings after
> dirty logging is disabled?

Patches on list is always a good place to start :)

What I'd expect on FEAT_S2FWB hardware is that invalidating the whole
stage-2 and faulting back in block entries would give the best
experience.

Only in the case of !FWB would a literal table -> block collapse be
beneficial, as the MMU could potentially elide CMOs when remapping. But
that assumes you're starting with a fully-mapped table and there are no
holes that are "out of sync" with the guest.

-- 
Thanks,
Oliver

