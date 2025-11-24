Return-Path: <kvm+bounces-64401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 291BEC8161F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 06373347AEF
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23727313E0D;
	Mon, 24 Nov 2025 15:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vx9KEDft"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19975313E09
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 15:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998543; cv=none; b=p+Th0icyJqgVCwEMcL2WH6+MHYj0TSso0iSzXNRo7aERCTWipMygZJ2mZqpiLQ61BaTVVd7LOR+tIY8O6wTtlisU3SIF7mew6cVkcRDD9api+Z7cxlV2seIHlfAuqUw0mj5WadJbw1F8eOcLS9YtU6w7LC0LnNEf19s3Y8UpDms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998543; c=relaxed/simple;
	bh=al4eSjw/jI9il5wEglA56a9A0jFC0QJmmy+5kJAx530=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQz8uvFe/12QtR1uGnFIQQere1Lh1WVL0zGLojA6IZZKvLmzcDbL5NciFIbVeZz256MRtwpU1T3b/SNSCNiWQBXI8M/674/5fO6oYqSaxegj34AnBjtFJ2hUL8x3u6CuwO5KQPHGYt69xbxXCKqleKxI0F6/4rkQzjGll1AM/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vx9KEDft; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 24 Nov 2025 15:35:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763998525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IWNL+oSvfsRrb2gPobgyncDEgpV54naej9ZTd6hjTNc=;
	b=Vx9KEDfteQ8ItS14HJbc0klt8KcEx3zfKgzq5eK0jAEEYLYx5ECRwv4ZDDNSUMRwQHlUks
	rIBw2zx+N5l2RaXvQKKxJJgRUcLg23qRv3cylUgxnVxPQ6wwhf5u2k+qPuhhOLziLoVX6Q
	dbfT2R7eKXrOdCR9nMJP7AeS01EBliE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ken Hofsass <hofsass@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: Add CR3 to guest debug info
Message-ID: <klvglwa5uxl3xfsmrgvbz7f36nchj57h4jszleabrggayztf53@o3t5g2pau6o2>
References: <20251121193204.952988-1-yosry.ahmed@linux.dev>
 <20251121193204.952988-2-yosry.ahmed@linux.dev>
 <aSDTNDUPyu6LwvhW@google.com>
 <ycaddg27z4z6xsclzklheriy2cr63v6senv7qxh37kvpb7envs@br7durjgj2ux>
 <aSRvguLx26AQB25W@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSRvguLx26AQB25W@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 24, 2025 at 06:45:22AM -0800, Sean Christopherson wrote:
> On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> > On Fri, Nov 21, 2025 at 01:01:40PM -0800, Sean Christopherson wrote:
> > > On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> > > KVM already provides kvm_run.kvm_valid_regs to let userspace grab register state
> > > on exit to userspace.  If userspace is debugging, why not simply save all regs on
> > > exit?
> > > 
> > > If the answer is "because it slows down all other exits", then I would much rather
> > > give userspace the ability to conditionally save registers based on the exit reason,
> > > e.g. something like this (completely untested, no CAP, etc.)
> > 
> > I like this approach conceptually, but I think it's an overkill for this
> > use case tbh. Especially the memory usage, that's 1K per vCPU for the
> > bitmap. I know it can be smaller, but probably not small either because
> > it will be a problem if we run out of bits.
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index 52f6000ab020..452805c1337b 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -494,8 +494,12 @@ struct kvm_run {
> > >                 struct kvm_sync_regs regs;
> > >                 char padding[SYNC_REGS_SIZE_BYTES];
> > >         } s;
> > > +
> > > +       __u64 kvm_save_regs_on_exit[16];
> 
> Heh, check your math.  It's 1024 bits, 128 bytes.  Reserving space for 1024 exits
> is likely extreme overkill given that KVM is sitting at 40 exits after ~18 years,
> so as you say we could cut that down significantly depending on how willing we are
> to risk having to add kvm_save_regs_on_exit2 in the future.

Oh well, I am gonna try and blame this one on Friday afternoon :D

