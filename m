Return-Path: <kvm+bounces-30325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8909E9B9533
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:23:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E105283439
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6531CC8AF;
	Fri,  1 Nov 2024 16:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lZKBzO/N"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123D81A76D2
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 16:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730478164; cv=none; b=l45xc6e7VxWsmK5Vb8bop8KayGqCyxsMb7R39OfmubNEjdAbd7iz3fToI8CgUT5LL37nq8GMELl538HST+sxcBECtzXE0UTlgxFlXK4KPFsiCYC0jaSq9hk0f3hrlX5mL8EGzzV++N+OVZBPEMHWFwqe3A7QDVYAabteRLwXTJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730478164; c=relaxed/simple;
	bh=ToEoY8y5UeAertZfIJABhwA7CpheQxwWzqqoTdcGFu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nw666fn+c6K21mGWTK7NsTHwHFzth4uKYNoymbYHNjPywG+siMwRmvI/9pxOLEa4dEsve3lwDe/fSkTY33+kQ5ysR2piKlrFxkjx3ErIgB65QbT9JX4pMx9hLpMOwO+/KpGW3T/UAReMSRef7ifGEn3tViEwvH4kP6d21s9XBc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lZKBzO/N; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 1 Nov 2024 09:22:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730478160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1evd5lGbHCuOT8tfPmadcUQqa04tuGgPb+HSVtJmF8k=;
	b=lZKBzO/N0DQ5XxKAtQkk86AjV5mYav4byhccRQ4eBvOGkAaxRH67vY48wf6QsY3GcRJOQc
	Jcc90LHPWM7riQBmj5VKnWMXM9M0Jd1tad4KG4IqFHlBItdwH/wCsGkCn5RbmsKe15w2bz
	xwxx3Z3KDUlP1gGnQMEpFuUjx4hu94M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Jones <ajones@ventanamicro.com>,
	James Houghton <jthoughton@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
Message-ID: <ZyUARgGV4G6DOrRL@linux.dev>
References: <20241009154953.1073471-1-seanjc@google.com>
 <20241009154953.1073471-4-seanjc@google.com>
 <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk>
 <ZyTpwwm0s89iU9Pk@google.com>
 <ZyT2CB6zodtbWEI9@linux.dev>
 <ZyT61FF0-g8gKZfc@google.com>
 <ZyT9rSnLcDWkWoL_@linux.dev>
 <ZyT-6iCNlA1VSAV3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyT-6iCNlA1VSAV3@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 01, 2024 at 09:16:42AM -0700, Sean Christopherson wrote:
> On Fri, Nov 01, 2024, Oliver Upton wrote:
> > On Fri, Nov 01, 2024 at 08:59:16AM -0700, Sean Christopherson wrote:
> > > > Can you instead just push out a topic branch and let the affected
> > > > maintainers deal with it? This is the usual way we handle conflicts
> > > > between trees...
> > > 
> > > That'd work too, but as you note below, doing that now throws a wrench in things
> > > because essentially all arch maintainers would need merge that topic branch,
> > > otherwise linux-next would end up in the same state.
> > 
> > TBH, I'm quite happy with that. Recent history has not been particularly
> > convinincing to me that folks are actually testing arm64, let alone
> > compiling for it when applying selftests patches.
> 
> FWIW, I did compile all patches on all KVM architectures, including selftests.
> But my base obviously didn't include the kvm-arm64 branch :-/

Oh, that rip wasn't aimed at you, commit 76f972c2cfdf ("KVM: selftests: Fix build
on architectures other than x86_64") just came to mind.

> One thing I'll add to my workflow would be to do a local merge (and smoke test)
> of linux-next into kvm-x86 next before pushing it out.  This isn't the only snafu
> this cycle where such a sanity check would have saved me and others a bit of pain.

Eh, shit happens, that's what -next is for :)

The only point I wanted to make was that it is perfectly fine by me to
spread the workload w/ a topic branch if things blow up sometime after
your changes show up in -next.

-- 
Thanks,
Oliver

