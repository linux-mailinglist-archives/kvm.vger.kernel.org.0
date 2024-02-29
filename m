Return-Path: <kvm+bounces-10483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 980ED86C86C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 12:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAB8A1C20D2C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01AF57C6CF;
	Thu, 29 Feb 2024 11:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iuZEuTxf"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866F27CF10
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 11:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207299; cv=none; b=HON4ACpZicnxYEnTX7J32bv1oHSX3B8QWAEA2kmH6iVPvlDy/U/oFpw3vqSFZmbTLOs3xFjdWc4UqmjE/hzoBf1mrTctiW5DS/pRO3lySK+Gu7+oW/XLnW56j35MZv4pxZO9EWjRIZxaaYu7NjlcjpwtAWYxb2pYXp7eeaSWKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207299; c=relaxed/simple;
	bh=gdx3CTDU1d7MVGKxQ2r2ptMLcvbYeBD5eLJJRVWcF2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3di4iCpLNE5OlWhxISHA8dvyY0JMxzPZcKjntpmlAk1hRTZAjoSVtPPI1zOEY/zhRlsKggCLJwP+Q8XQBSSmqCSr4flAUGry9gObAw1xMYW4nDtPfxcRHPPkn1Gw/zfwqjjWRt+TBDhHBiFCbnRjvD36VkXoz+iVVG829VsEQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iuZEuTxf; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 29 Feb 2024 12:48:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709207294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3fynTQbCj+0+8gxWXP+vb+6EeWzkaGPfZJFyS35W4s4=;
	b=iuZEuTxfseoZp4UQoXwPwaJ0a3iWv9B5ZmYjolE1PWpkuPgM0k2tb4r+KsGxNXibCaqSMX
	28xc8TdmgZEjmtE7rA6HjPrfkc5ixF9DXIXKhREpQkx1Bsj671uDxFM1mVEkY7E3EFscsy
	mT5j0z0J3eZ3dlXLE5t1Tns+yX/3RBw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, thuth@redhat.com, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, lvivier@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 03/13] treewide: lib/stack: Fix backtrace
Message-ID: <20240229-b470bcfe6538d0fea44ab3e3@orel>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
 <20240228150416.248948-18-andrew.jones@linux.dev>
 <CZH8V1T0Z3QN.1ZVFAXR4B96BZ@wheely>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CZH8V1T0Z3QN.1ZVFAXR4B96BZ@wheely>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 29, 2024 at 01:31:52PM +1000, Nicholas Piggin wrote:
> On Thu Feb 29, 2024 at 1:04 AM AEST, Andrew Jones wrote:
...
> > diff --git a/lib/stack.h b/lib/stack.h
> > index 10fc2f793354..6edc84344b51 100644
> > --- a/lib/stack.h
> > +++ b/lib/stack.h
> > @@ -11,17 +11,27 @@
> >  #include <asm/stack.h>
> >  
> >  #ifdef HAVE_ARCH_BACKTRACE_FRAME
> > -extern int backtrace_frame(const void *frame, const void **return_addrs,
> > -			   int max_depth);
> > +extern int arch_backtrace_frame(const void *frame, const void **return_addrs,
> > +				int max_depth, bool current_frame);
> > +
> > +static inline int backtrace_frame(const void *frame, const void **return_addrs,
> > +				  int max_depth)
> > +{
> > +	return arch_backtrace_frame(frame, return_addrs, max_depth, false);
> > +}
> > +
> > +static inline int backtrace(const void **return_addrs, int max_depth)
> > +{
> > +	return arch_backtrace_frame(NULL, return_addrs, max_depth, true);
> > +}
> >  #else
> > -static inline int
> > -backtrace_frame(const void *frame __unused, const void **return_addrs __unused,
> > -		int max_depth __unused)
> > +extern int backtrace(const void **return_addrs, int max_depth);
> > +
> > +static inline int backtrace_frame(const void *frame, const void **return_addrs,
> > +				  int max_depth)
> >  {
> >  	return 0;
> >  }
> >  #endif
> >  
> > -extern int backtrace(const void **return_addrs, int max_depth);
> > -
> >  #endif
> 
> Is there a reason to add the inline wrappers rather than just externs
> and drop the arch_ prefix?

Only reason is to avoid duplicating the functions in each arch, but
since they're oneliners which won't likely change, then we could
duplicate them instead, if preferred, but I'm not sure what the
benefit of that over the static inlines would be.

> 
> Do we want to just generally have all arch specific functions have an
> arch_ prefix? Fine by me.

We've been slowly doing that over in 'KVM selftests', which has improved
readability, so slowly adopting it here too in kvm-unit-tests would be
nice.

> 
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
> 
> I'm fine to rebase the powerpc patch on top of this if it goes in first.
> Thanks for the heads up.
> 

Thanks,
drew

