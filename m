Return-Path: <kvm+bounces-10310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4787686B9FC
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 22:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC2161F292ED
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 21:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4847003B;
	Wed, 28 Feb 2024 21:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M6EvXq+T"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE5D70024
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 21:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709156065; cv=none; b=Uh7WMhiYEl9BuaHiLOIslICUPYK85YHISQKMonN3iIpIJzUw1TdaUp6L1+m5ol8D+PG3PLXlyTBRnI28VwDagqYJdpcPaq5PEohW8/jWC8u7o/ycfZAY6voEbTSIcvCge95JwGbgJOWBfy1wPCK0IXEVQQwPZgdUALq4yyTfRhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709156065; c=relaxed/simple;
	bh=u0glWb8PLZEnaQBoKnM6UxMr33w9SryGXNiNoDypwRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1mBAcwkL6d/RkmyT41WxYDeOZXsoog4Eck/wabYoVlfkCa876Hp/gNwn/nfkPuVK4zvNjg3ApaRkDauXiIxRSp3xjEOzrpgO+/bzhk6fKmf1HncSJrHmMFfFtLLaT6nLnkN+ZgEv5LD7DzTSC5RiBQ2dNMFSwzoPsF+D6MXvfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M6EvXq+T; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 21:34:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709156062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AKLLQheTiIIqIx7nrNpRjfoLsYpiraWTUJCmTz11PY4=;
	b=M6EvXq+T0VEep82dPWCLF5UU1Mk68qeW9WjAWox6J2ZxmeZVw5VJPXHbiO644f5C4oiye6
	e4rNb2cxMAA3ZmcBJrSfcecv1RFdTph9FrllNN6g6qRPKX+3Ztggkx1tzTz3dmmFIGm3EA
	bTeDVZMZsZ1WwjF3dEyk+W+WpSXgYFI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Mark Brown <broonie@kernel.org>, Thomas Huth <thuth@redhat.com>,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Marc Zyngier <maz@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>, rananta@google.com
Subject: Re: [PATCH v3 3/8] KVM: selftests: Move setting a vCPU's entry point
 to a dedicated API
Message-ID: <Zd-m2WHdQUtPeZOG@linux.dev>
References: <20240208204844.119326-1-thuth@redhat.com>
 <20240208204844.119326-4-thuth@redhat.com>
 <501ac94d-11ab-4765-a25d-75013c021be6@sirena.org.uk>
 <Zd-JjBNCpFG5iDul@google.com>
 <Zd-jdAtI_C_d_fp4@google.com>
 <Zd-lzwQb0APsBFjM@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd-lzwQb0APsBFjM@linux.dev>
X-Migadu-Flow: FLOW_OUT

I really should fix the CC list _before_ drafting a reply...

On Wed, Feb 28, 2024 at 09:29:56PM +0000, Oliver Upton wrote:
> +cc Raghavendra

See below :)

> Hey,
> 
> On Wed, Feb 28, 2024 at 01:19:48PM -0800, Sean Christopherson wrote:
> > but due to a different issue that is fixed in the kvm-arm tree[*], but not in mine,
> > I built without -Werror and didn't see the new warn in the sea of GUEST_PRINTF
> > warnings.
> > 
> > Ugh, and I still can't enable -Werror, because there are unused functions in
> > aarch64/vpmu_counter_access.c
> > 
> >   aarch64/vpmu_counter_access.c:96:20: error: unused function 'enable_counter' [-Werror,-Wunused-function]
> >   static inline void enable_counter(int idx)
> >                    ^
> >   aarch64/vpmu_counter_access.c:104:20: error: unused function 'disable_counter' [-Werror,-Wunused-function]
> >   static inline void disable_counter(int idx)
> >                    ^
> >   2 errors generated.
> >   make: *** [Makefile:278: /usr/local/google/home/seanjc/go/src/kernel.org/nox/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.o] Error 1
> >   make: *** Waiting for unfinished jobs....
> > 
> >   Commit 49f31cff9c533d264659356b90445023b04e10fb failed to build with 'make-clang make-arm make -j128'.
> > 
> > Oliver/Marc, any thoughts on how you want to fix the unused function warnings?
> > As evidenced by this goof, being able to compile with -Werror is super helpful.
> 
> Are these the only remaining warnings we have in the arm64 selftests
> build?
> 
> Faster than me paging this test back in: Raghu, are we missing any test
> cases upstream that these helpers were intended for? If no, mind sending
> a patch to get rid of them?
> 
> > And another question: is there any reason to not force -Werror for selftests?
> 
> Nothing comes to mind. We need to bite the bullet and make the switch.
> There might be breakage, but we can certainly handle that.
> 
> -- 
> Thanks,
> Oliver

-- 
Thanks,
Oliver

