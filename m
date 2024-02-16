Return-Path: <kvm+bounces-8881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D774F8581FC
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15B891C227E7
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2A1130AFB;
	Fri, 16 Feb 2024 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tqQODDyt"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76503130AEC
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708098918; cv=none; b=Hy2xXFSEYU1m23Q+BMu384VrA/4WdKAyW+4zmZxRFW+SV2dOKbBN4TJDqOMI0wI1ldHCWt2FjJGJPonBQNUyR3m+elciIGaRgiLD/mOz87qb4x8K5glflTPmlsVDKYIVF2TFkJJMdza1O2jLw2eNgYNAn2fPBwj538N0G0n9sjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708098918; c=relaxed/simple;
	bh=5b8W3nEnUMUwwfHbxtV884iCIbzYuJ0nEY0ngrg0vNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jArZyI71XaRDsXXg6gM1zj7cupdSlO0+SogeIVQ7YcfwILkDIXF8MR+yvD/+LV6PCNtlxNsqvfRBQmeiotDMtHmem8uk40eHjy1XrECPpMU3MCTDBa4FYozjUYeHy6S2UAGSQBUMpPm0QYsihDa0jHtkm9o4wXl/KbedhsZnwQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tqQODDyt; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 16 Feb 2024 07:55:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708098914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w8YAoGqfmJKIcRMbhrEdkG/A+KOS0KiprpKxTNIMEYU=;
	b=tqQODDytNtRDwau2wS6TrvmDGzWxRRTu5Jto4rQ8ChCL5kVbCjIbJxAG3PNBz4RwKl8Zg4
	6IxzHm/QTMS4dHurguKAXHcshS4bFp8elptafu2SRdXPaG46GE3gHyOxN7U/MgKnWBixwS
	HLyUvcq8JmPGIgP+8pD1kHR+250eyyk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	Michael Krebs <mkrebs@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
Message-ID: <Zc-FXbxEfPNddiiL@linux.dev>
References: <20240215010004.1456078-1-seanjc@google.com>
 <20240215010004.1456078-3-seanjc@google.com>
 <Zc3JcNVhghB0Chlz@linux.dev>
 <Zc5c7Af-N71_RYq0@google.com>
 <Zc5wTHuphbg3peZ9@linux.dev>
 <Zc6DPEWcHh-TKCSD@google.com>
 <Zc6d6fwakreoVtN5@linux.dev>
 <Zc6rmksmgZ31fd-K@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc6rmksmgZ31fd-K@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 04:26:02PM -0800, Sean Christopherson wrote:
> On Thu, Feb 15, 2024, Oliver Upton wrote:
> > On Thu, Feb 15, 2024 at 01:33:48PM -0800, Sean Christopherson wrote:
> > 
> > [...]
> > 
> > > +/* TODO: Expand this madness to also support u8, u16, and u32 operands. */
> > > +#define vcpu_arch_put_guest(mem, val, rand) 						\
> > > +do {											\
> > > +	if (!is_forced_emulation_enabled || !(rand & 1)) {				\
> > > +		*mem = val;								\
> > > +	} else if (rand & 2) {								\
> > > +		__asm__ __volatile__(KVM_FEP "movq %1, %0"				\
> > > +				     : "+m" (*mem)					\
> > > +				     : "r" (val) : "memory");				\
> > > +	} else {									\
> > > +		uint64_t __old = READ_ONCE(*mem);					\
> > > +											\
> > > +		__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchgq %[new], %[ptr]"	\
> > > +				     : [ptr] "+m" (*mem), [old] "+a" (__old)		\
> > > +				     : [new]"r" (val) : "memory", "cc");		\
> > > +	}										\
> > > +} while (0)
> > > +
> > 
> > Last bit of bikeshedding then I'll go... Can you just use a C function
> > and #define it so you can still do ifdeffery to slam in a default
> > implementation?
> 
> Yes, but the macro shenanigans aren't to create a default, they're to set the
> stage for expanding to other sizes without having to do:
> 
>   vcpu_arch_put_guest{8,16,32,64}()
> 
> or if we like bytes instead of bits:
> 
>   vcpu_arch_put_guest{1,2,4,8}()
> 
> I'm not completely against that approach; it's not _that_ much copy+paste
> boilerplate, but it's enough that I think that macros would be a clear win,
> especially if we want to expand what instructions are used.

Oh, I see what you're after. Yeah, macro shenanigans are the only way
out then. Wasn't clear to me if the interface you wanted w/ the selftest
was a u64 write that you cracked into multiple writes behind the
scenes.

Thanks for entertaining my questions :)

-- 
Thanks,
Oliver

