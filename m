Return-Path: <kvm+bounces-8832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0EA857195
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76BA9B21438
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33453145B03;
	Thu, 15 Feb 2024 23:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XiALD7sx"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807E613A86F
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708039667; cv=none; b=OLXsdhPi49jyAsSrRBTm/intqNv3H1u/xcZY6VobkCirv64P5dqJHupKAnT4wK2U5BJyCRvUq5qnw/aHlsv4JvqiL5RrgZAW2iFkDLZhY1PT7vWfxQuRW+blPjdY4q4FikIG1SjxjJz6/8XE3qWHkv1Bl2Q4nf/ZnEygoHfumgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708039667; c=relaxed/simple;
	bh=QGvW1GfLe1IrocH8cjxvScOppkpzAMxwvT0mp2RfnA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRj1X69k0k+V8Z3WgMWZ077W4JlUmwT7RJpF7LmfimfTGIwjmepRu/d6CMmpkgy7kXbtWFEGeTj52hhOByT7+WQBQ3b/MnuAfbzREhMT7aDdz0OEKKtqegKGzPg8h8nDDIMQ1mA7AJWFF7XY1qQbdbTHoay165wY+xxKN/OHzeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XiALD7sx; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Feb 2024 15:27:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708039663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AlV1eNHM+AjtDcCkEHXltO12IW2g8LwsQ0NEmnjiFdk=;
	b=XiALD7sxsGftLsdc7KWUQouJ55zlSlwPV3nh7xxHsUP5Q1jaXwF0lqYZVT+l/9o200Z85b
	9awx/T9/ejwpvjK4DYXKZZZ6ETdZ8/O6lxRwHwBd6xcwhYw+VJb+SpqX61k1FMIO6g64Ac
	mEjnodWhDnjVWKr042Bg6pr5tSE6SpQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	Michael Krebs <mkrebs@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
Message-ID: <Zc6d6fwakreoVtN5@linux.dev>
References: <20240215010004.1456078-1-seanjc@google.com>
 <20240215010004.1456078-3-seanjc@google.com>
 <Zc3JcNVhghB0Chlz@linux.dev>
 <Zc5c7Af-N71_RYq0@google.com>
 <Zc5wTHuphbg3peZ9@linux.dev>
 <Zc6DPEWcHh-TKCSD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc6DPEWcHh-TKCSD@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 01:33:48PM -0800, Sean Christopherson wrote:

[...]

> +/* TODO: Expand this madness to also support u8, u16, and u32 operands. */
> +#define vcpu_arch_put_guest(mem, val, rand) 						\
> +do {											\
> +	if (!is_forced_emulation_enabled || !(rand & 1)) {				\
> +		*mem = val;								\
> +	} else if (rand & 2) {								\
> +		__asm__ __volatile__(KVM_FEP "movq %1, %0"				\
> +				     : "+m" (*mem)					\
> +				     : "r" (val) : "memory");				\
> +	} else {									\
> +		uint64_t __old = READ_ONCE(*mem);					\
> +											\
> +		__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchgq %[new], %[ptr]"	\
> +				     : [ptr] "+m" (*mem), [old] "+a" (__old)		\
> +				     : [new]"r" (val) : "memory", "cc");		\
> +	}										\
> +} while (0)
> +

Last bit of bikeshedding then I'll go... Can you just use a C function
and #define it so you can still do ifdeffery to slam in a default
implementation?

I hate macros :)

-- 
Thanks,
Oliver

