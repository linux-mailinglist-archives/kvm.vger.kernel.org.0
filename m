Return-Path: <kvm+bounces-10845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B35871230
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:02:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0127C281CE2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 01:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93ABDEEC4;
	Tue,  5 Mar 2024 01:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mwrsa//Q"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105388BEC
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 01:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600513; cv=none; b=KLvI+7RNK19oTxKcLZsVjhbkgG46YIZm8l3z1Vv5H2Q9Zt6xc6KarZYLjgrnfW6jhpq+tQdcv9s+R2YVUM88dY68AUx/4nkb/xnLWhIPzNAP1tR9ibv6FXaO4x5+6UsjA36zOM4lUha5+keqXBJC+PwH92u5ArR49AL0Z9zxDaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600513; c=relaxed/simple;
	bh=BwPSZlt7NYNE4oqpthrBP3Pq0CvLDk53hLZltcU3Pqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZlOsSMx8/G0Z4I0OWXUkGx6SUjmowz7oJyqVO4hyiFp2CrXWrvHwl6vueZzgtnpn/mLTkElQVGI4it10vPu37nmnYRM3n/3ApDxzJyRZjHq627Nen8pOx8Y7jX7kIORok51P5dS3PlZ5szi8MsNLOlTZMzhrurAyFjPIH6Nf18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mwrsa//Q; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 5 Mar 2024 01:01:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709600508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JtsWbQ9wjONc3H0VXJlmWvFBcN642D74YneUxe2uTig=;
	b=mwrsa//QZkjTewCtK+S311ucLPc4G/6akOxyzNFwUhvJcjZjgDFjOq+GbOG42BHUlt5JXr
	kmeqWobMVwQcOgYL8mwPk9rD5/w2F628JYlJnGvcUITof0O3dSWF19VvuO7QdLgol94zad
	sbJPomi0xx3lIHuqm2y/MB0V9UztKQ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, maz@kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	robert.hoo.linux@gmail.com, jthoughton@google.com,
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com,
	nadav.amit@gmail.com, isaku.yamahata@gmail.com,
	kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
 and annotate fault in the stage-2 fault handler
Message-ID: <ZeZu9D3Ic_1O5CIO@linux.dev>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-9-amoorthy@google.com>
 <ZeYoSSYtDxKma-gg@linux.dev>
 <ZeYqt86yVmCu5lKP@linux.dev>
 <ZeYv86atkVpVMa2S@google.com>
 <ZeY3P8Za5Q6pkkQV@linux.dev>
 <ZeZP4xOMk7LUnNt2@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeZP4xOMk7LUnNt2@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 04, 2024 at 02:49:07PM -0800, Sean Christopherson wrote:

[...]

> The presense of MTE stuff shouldn't affect the fundamental access information,

  "When FEAT_MTE is implemented, for a synchronous Data Abort on an
  instruction that directly accesses Allocation Tags, ISV is 0."

If there is no instruction syndrome, there's insufficient fault context
to determine if the guest was doing a read or a write.

> e.g. if the guest was attempting to write, then KVM should set KVM_MEMORY_EXIT_FLAG_WRITE
> irrespective of whether or not MTE is in play.

When the MMU generates such an abort, it *is not* read, write, or execute.
It is a NoTagAccess fault. There is no sane way to describe this in
terms of RWX.

> The one thing we may want to squeak in before 6.8 is released is a placeholder
> in memory_fault, though I don't think that's strictly necessary since the union
> as a whole is padded to 256 bytes.  I suppose userspace could allocate based on
> sizeof(kvm_run.memory_fault), but that's a bit of a stretch.

Strictly speaking, that isn't ABI any more, but compile-time brittleness
to header changes. IOW, old userspace could still run on new kernel b/c
it compiled against the old structure size and only knows about the
fields present at that time.

> > > E.g. on the x86 side, KVM intentionally sets reserved bits in SPTEs for
> > > "caching" emulated MMIO accesses, and the resulting fault captures the
> > > "reserved bits set" information in register state.  But that's purely an
> > > (optional) imlementation detail of KVM that should never be exposed to
> > > userspace.
> > 
> > MMIO accesses would show up elsewhere though, right?
> 
> Yes, but I don't see how that's relevant.  Maybe I'm just misunderstanding what
> you're saying/asking.

If "reserved" EPT violations found their way to userspace via the
"memory fault" exit structure then that'd likely be due to a KVM bug.
The only expected flows in the near term are this and CoCo crap.

> > Either way, I have no issues whatsoever if the direction for x86 is to
> > provide abstracted fault information.
> 
> I don't understand how ARM can get away with NOT providing a layer of abstraction.
> Copying fault state verbatim to userspace will bleed KVM implementation details
> into userspace,

The memslot flag already bleeds KVM implementation detail into userspace
to a degree. The event we're trying to let userspace handle is at the
intersection of a specific hardware/software state.

> Abstracting gory hardware details from userspace is one of the main roles of the
> kernel.

Where it can be accomplished without a loss (or misrepresentation) of
information, agreed. But KVM UAPI is so architecture-specific that it
seems arbitrary to draw the line here.

> A concrete example of hardware throwing a wrench in things is AMD's upcoming
> "encrypted" flag (in the stage-2 page fault error code), which is set by SNP-capable
> CPUs for *any* VM that supports guest-controlled encrypted memory.  If KVM reported
> the page fault error code directly to userspace, then running the same VM on
> different hardware generations, e.g. after live migration, would generate different
> error codes.
>  
> Are we talking past each other?  I'm genuinely confused by the pushback on
> capturing RWX information.  Yes, the RWX info may be insufficient in some cases,
> but its existence doesn't preclude KVM from providing more information as needed.

My pushback isn't exactly on RWX (even though I noted the MTE quirk
above). What I'm poking at here is the general infrastructure for
reflecting faults into userspace, which is aggressively becoming more
relevant.

-- 
Thanks,
Oliver

