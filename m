Return-Path: <kvm+bounces-11492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2297C877A6E
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 05:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96FED2811D3
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 04:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6408479EA;
	Mon, 11 Mar 2024 04:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xjSynVdN"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F8F7489
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 04:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710132376; cv=none; b=LEYSsiXFaP8lNS8JYn+QH33z1vwQG62bQspZIeP5DHdI4634UPyQ7HDVG9vFujI4ACZGR584I07rp4Bc/4gYqBoPWAiIa/8JfkwTZvpKhzk60oYD/eLVAknzGpayeURgtku6Eo5jVTtGK51iSIKxGblk0k9h9b0zGfiA1j3F+i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710132376; c=relaxed/simple;
	bh=6WEne4vUYZq83YyT/OQw+xVqJU3MNsmo78pEfliD4Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Celimo3gx6Dt6qmCSc3kxB5hxPatpWH0oM6Er5zziIuxjJ8jOQFYGXHTCQwZaw59L1OR02TrosPrmn8yO9xxBiXjBMA9t5o2dlPar0+wZPp9rVhxPDubyD74sbIfuWFlxKnOi5KABLaUcSNu3KPbN9EBzYuk0UYSw+G22eHD6PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xjSynVdN; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 10 Mar 2024 21:45:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710132371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9VnTRU7AsSppUKCYO15d3mQIz3e/9XiOyvGpM4FjF8g=;
	b=xjSynVdNr7QjBAIsjGT5dMdXePJFXDbcmiLRtfq0AIU4a3dM4fvlQSMYoUmN+55tH4PNkn
	b1DbNNSVoVU/plHy3ZD6151OkCio0f2OVnG0W+fZy1VoOegQl7uD5icdHo4kbH3LcHpvNg
	311XDWrhDoTQNWJnb1SMJIkeWVZ6lvg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Anish Moorthy <amoorthy@google.com>, maz@kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	robert.hoo.linux@gmail.com, jthoughton@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
Message-ID: <Ze6Md/RF8Lbg38Rf@thinky-boi>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com>
 <ZeuxaHlZzI4qnnFq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeuxaHlZzI4qnnFq@google.com>
X-Migadu-Flow: FLOW_OUT

Hey,

Thanks Sean for bringing this up on the list, didn't have time for a lot
of upstream stuffs :)

On Fri, Mar 08, 2024 at 04:46:32PM -0800, David Matlack wrote:
> On 2024-03-08 02:07 PM, Sean Christopherson wrote:
> > On Thu, Feb 15, 2024, Anish Moorthy wrote:
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index 9f5d45c49e36..bf7bc21d56ac 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -1353,6 +1353,7 @@ yet and must be cleared on entry.
> > >    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> > >    #define KVM_MEM_READONLY	(1UL << 1)
> > >    #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> > > +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
> > 
> > David M.,
> > 
> > Before this gets queued anywhere, a few questions related to the generic KVM
> > userfault stuff you're working on:
> > 
> >   1. Do you anticipate reusing KVM_MEM_EXIT_ON_MISSING to communicate that a vCPU
> >      should exit to userspace, even for guest_memfd?  Or are you envisioning the
> >      "data invalid" gfn attribute as being a superset?
> > 
> >      We danced very close to this topic in the PUCK call, but I don't _think_ we
> >      ever explicitly talked about whether or not KVM_MEM_EXIT_ON_MISSING would
> >      effectively be obsoleted by a KVM_SET_MEMORY_ATTRIBUTES-based "invalid data"
> >      flag.
> > 
> >      I was originally thinking that KVM_MEM_EXIT_ON_MISSING would be re-used,
> >      but after re-watching parts of the PUCK recording, e.g. about decoupling
> >      KVM from userspace page tables, I suspect past me was wrong.
> 
> No I don't anticipate reusing KVM_MEM_EXIT_ON_MISSING.
> 
> The plan is to introduce a new gfn attribute and exit to userspace based
> on that. I do forsee having an on/off switch for the new attribute, but
> it wouldn't make sense to reuse KVM_MEM_EXIT_ON_MISSING for that.

With that in mind, unless someone else has a usecase for the
KVM_MEM_EXIT_ON_MISSING behavior my *strong* preference is that we not
take this bit of the series upstream. The "memory fault" UAPI should
still be useful when the KVM userfault stuff comes along.

Anish, apologies, you must have whiplash from all the bikeshedding,
nitpicking, and other fun you've been put through on this series. Thanks
for being patient.

> > 
> >   2. What is your best guess as to when KVM userfault patches will be available,
> >      even if only in RFC form?
> 
> We're aiming for the end of April for RFC with KVM/ARM support.

Just to make sure everyone is read in on what this entails -- is this
the implementation that only worries about vCPUs touching non-present
memory, leaving the question of other UAPIs that consume guest memory
(e.g. GIC/ITS table save/restore) up for further discussion?

-- 
Thanks,
Oliver

