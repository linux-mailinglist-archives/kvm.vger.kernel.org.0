Return-Path: <kvm+bounces-23436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 468E29498C4
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 22:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7603E1C216DB
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F3D83CC7;
	Tue,  6 Aug 2024 20:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CuFNLft5"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D438DD8
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 20:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722974632; cv=none; b=pR/TOhje8QX7/b+Ibd2npGCabvmUmuKJ3x5Upa9tp5zNZ/vkvjD/AoXh68uU5GRugSISiqM/zpBCryBZf4oJmQrSHMLYUjpOmAzWadeEBISU4w30rJQsrWpAYiXoS6Mrty0kqcbhTnHCw8hDICDkytOx4EbpYqzgsocJQeGJbaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722974632; c=relaxed/simple;
	bh=5JTq8YS5QWYXrg0uLxd8i5GzhLs7KHIdzBUqT5B/xrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hyCIFmFTJ8YtqHRwL8fuXraOiaHNScP+D3F3a0smvl8wmhIfVOiK+m1oW3roL1kW/zLIeSbQZ7NYwHz4vyv/XmPFMaoDeyps/VaK33LG5ofH5WMb4aba2PRC3gm0cuhKtWrlEgrrWl1V13u2sDfEHjFCRCG02HQPKR5Smkk2M2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CuFNLft5; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 6 Aug 2024 13:03:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722974629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5+7hogum1V+TSYXSc7hIGw4Be9PCmDdgUzuXDb59gik=;
	b=CuFNLft53XVmCA2NaaoA3GCApKAnkuM8x31SsUeSiedf4WROhufxff6+8DNQzRnsk2dekw
	mrKhLsvzfoow/EEAc2Mxr4jL48Ov4w0/PpRJ0RJxHeHJ3/P1KV9a3wUnssqUXJB4jUT0UA
	SGm7Wh0+t9poVhigvN4SIY27LWK+Gt4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	jthoughton@google.com, rananta@google.com
Subject: Re: [PATCH 3/3] KVM: arm64: Do a KVM_EXIT_MEMORY_FAULT when stage-2
 fault handler EFAULTs
Message-ID: <ZrKBn8I-mBJh_U8b@linux.dev>
References: <20240802224031.154064-1-amoorthy@google.com>
 <20240802224031.154064-4-amoorthy@google.com>
 <ZrFZ_ANIIbFdzmIn@linux.dev>
 <CAF7b7mps9-HdBv52BDbAMceGuT+FRiRtpdwpK=psfW1Msvip+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mps9-HdBv52BDbAMceGuT+FRiRtpdwpK=psfW1Msvip+Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 06, 2024 at 11:44:39AM -0700, Anish Moorthy wrote:
> On Mon, Aug 5, 2024 at 4:02 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Fri, Aug 02, 2024 at 10:40:31PM +0000, Anish Moorthy wrote:
> > > Right now userspace just gets a bare EFAULT when the stage-2 fault
> > > handler fails to fault in the relevant page. Set up a memory fault exit
> > > when this happens, which at the very least eases debugging and might
> > > also let userspace decide on/take some specific action other than
> > > crashing the VM.
> >
> > There are several other 'bare' EFAULTs remaining (unexpected fault
> > context, failed vma_lookup(), nested PTW), so the patch doesn't exactly
> > match the shortlog.
> >
> > Is there a reason why those are unaddressed? In any case, it doesn't
> > hurt to be unambiguous in the shortlog if we're only focused on this single
> > error condition, e.g.
> >
> >   KVM: arm64: Do a memory fault exit if __gfn_to_pfn_memslot() fails
> 
> Ah, right- forgot to address this before I sent it out.
> 
> Basically: those cases you mention (besides MTE, where it seems simple
> enough to add an annotation) happen before vma_pagesize is calculated,

If the motivation is to add additional information for debugging
unexpected KVM/VMM behavior then this really ought to be addressed. You
could fall back to PAGE_SIZE, or better yet just don't report a size
whatsoever (size = 0) if it cannot be reliably determined.

Userspace probably only cares about logging @flags and @gpa before
killing the VM.

-- 
Thanks,
Oliver

