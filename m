Return-Path: <kvm+bounces-8848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE26C857276
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 01:26:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88C9F281986
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021674437;
	Fri, 16 Feb 2024 00:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8AwCKcm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C150138F
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 00:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708043166; cv=none; b=IIJ9J0PHjAY7lQSYdRQAFBetHY2Ygs0HPN0m9mVbhh3QA7FVLcY9r1hhmxYwsfiRjJdsh8smuG7BrKr3TvrzM1KWO733XRdusEVDb6FT5TA3VlHHm4siTeWJnFBZF62R4qTknXe42Xy7sKNbVUAZPBc2Yy9Wi350KJUgn56cimA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708043166; c=relaxed/simple;
	bh=fJ5zoMZkCZXY/8D1JS0Siys+6fkFsartYZuMZcsT9/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MzMZMx5RzAdVU0NsGAy1ktkbbSEJDVDTPdIQfJUv54ExIVJ+atlE1LbDUqzY0MRW8uWS2QRWjp2SwUpvQA3O6IF+0eBZclhuttbGqJyolCJbkTOaHLz2KOkxsib2SWNd6qSQ5d1ZxgHow6sNYsCCqdTitXpzuwJnQeocPaX5VOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8AwCKcm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1db596ffd50so20679535ad.1
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 16:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708043164; x=1708647964; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1wMKCbOl3BdeBvCzqWlNlP+DPN47Ns+GARI7q0YKBYg=;
        b=N8AwCKcmMmJrs0ae8k6t7/eOjb/42F1ZaV0yA2dzInKmMPaUxu8viJOx3fQnV6xYr5
         RgTvzLB+VJ2vqQWK3tg2aR5PH67tPwrVrC07Db5lGl2xk5RbeT5oxpxTYkjnR/aFnI6E
         tQK1PEVUmwWZVsacFouWpxqdvqT5K39u1F2Ov8zsyyZJFi/yx8BP0Guf/TJuwKubHthv
         ycYaz+ICEob1AfWBKEQtsz+N+aJ9nteU/4YqAKc2Px78UPWcxroJobXz/gKoHLjJEU/4
         ePXijLn46Rsvg6lLBWN7lWp0rehHRi1w/YcYq5LxnUA0/xXnGXuNk6ZeJherDj/KTfpr
         Z/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708043164; x=1708647964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1wMKCbOl3BdeBvCzqWlNlP+DPN47Ns+GARI7q0YKBYg=;
        b=Yw5eAds1cvccMFF4k1yBsrUCa1iG99NsOw7FxM4mBd+9Mw/jBKNMk/8HntYyTG6vWE
         zup1+5xuHu5SOi0+xePCPdtY6Wfy6K6UME/U7IaFfhRCNTImfaEi6IOckqb8UGBjGJY9
         RIl+ydts+UwZ4QxVc7q6sYZNnApiVGRbo02AyhXwxcjwowlj4b9lCuc237uhfu45vyh/
         9EMkIFKxn0kW6pne9BVmngGjOBSCntVi8cAjFBDuEI8CGNKFc2OpPKCmc2mSLHME9fLS
         tPcKdl59KLEZrdpJQpqfV75ll7hZ4yLUvbnp5pRyrQP326lOD/A2d77kIWdrDZY+8P+x
         fXiA==
X-Forwarded-Encrypted: i=1; AJvYcCUWt8dlKzvgo01cj2ihjL1ChVCIVIupXQnM37MC1MFWu5VMa2JEdptxVAoaYTKoAN4ZIuDLH0/ljcKNw6qx6Ca5NTcd
X-Gm-Message-State: AOJu0YyeHmLohHQgFQ3XjwP5x0hY3+teUX7GNFBTZ98WzAxIl8MdvugY
	T8VzFdFc3qPQjZbzjTLPXb5L8W4LJ5IQ8BJcoH2CAUbJUNdGIGVY1/DsX7qtJTNViSlcYIdsQA8
	ZXg==
X-Google-Smtp-Source: AGHT+IF1wnzs5jF21J5B464C+886MNRYzOW3aE5hJoot+nFK6zK5ooBd/8Sr/Qs7BuziPqthlUgZc2rYvJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2e0f:b0:298:9767:a0cb with SMTP id
 sl15-20020a17090b2e0f00b002989767a0cbmr52656pjb.2.1708043164115; Thu, 15 Feb
 2024 16:26:04 -0800 (PST)
Date: Thu, 15 Feb 2024 16:26:02 -0800
In-Reply-To: <Zc6d6fwakreoVtN5@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com> <20240215010004.1456078-3-seanjc@google.com>
 <Zc3JcNVhghB0Chlz@linux.dev> <Zc5c7Af-N71_RYq0@google.com>
 <Zc5wTHuphbg3peZ9@linux.dev> <Zc6DPEWcHh-TKCSD@google.com> <Zc6d6fwakreoVtN5@linux.dev>
Message-ID: <Zc6rmksmgZ31fd-K@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Oliver Upton wrote:
> On Thu, Feb 15, 2024 at 01:33:48PM -0800, Sean Christopherson wrote:
> 
> [...]
> 
> > +/* TODO: Expand this madness to also support u8, u16, and u32 operands. */
> > +#define vcpu_arch_put_guest(mem, val, rand) 						\
> > +do {											\
> > +	if (!is_forced_emulation_enabled || !(rand & 1)) {				\
> > +		*mem = val;								\
> > +	} else if (rand & 2) {								\
> > +		__asm__ __volatile__(KVM_FEP "movq %1, %0"				\
> > +				     : "+m" (*mem)					\
> > +				     : "r" (val) : "memory");				\
> > +	} else {									\
> > +		uint64_t __old = READ_ONCE(*mem);					\
> > +											\
> > +		__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchgq %[new], %[ptr]"	\
> > +				     : [ptr] "+m" (*mem), [old] "+a" (__old)		\
> > +				     : [new]"r" (val) : "memory", "cc");		\
> > +	}										\
> > +} while (0)
> > +
> 
> Last bit of bikeshedding then I'll go... Can you just use a C function
> and #define it so you can still do ifdeffery to slam in a default
> implementation?

Yes, but the macro shenanigans aren't to create a default, they're to set the
stage for expanding to other sizes without having to do:

  vcpu_arch_put_guest{8,16,32,64}()

or if we like bytes instead of bits:

  vcpu_arch_put_guest{1,2,4,8}()

I'm not completely against that approach; it's not _that_ much copy+paste
boilerplate, but it's enough that I think that macros would be a clear win,
especially if we want to expand what instructions are used.

<me fiddles around>

Actually, I take that back, I am against that approach :-)

I was expecting to have to do some switch() explosion to get the CMPXCHG stuff
working, but I'm pretty sure the mess that is the kernel's unsafe_try_cmpxchg_user()
and __put_user_size() is is almost entirely due to needing to support 32-bit kernels,
or maybe some need to strictly control the asm constraints.

For selftests, AFAICT the below Just Works on gcc and clang for legal sizes.  And
as a bonus, we can sanity check that the pointer and value are of the same size.
Which we definitely should do, otherwise the compiler has a nasty habit of using
the size of the value of the right hand side for the asm blobs, e.g. this

	vcpu_arch_put_guest((u8 *)addr, (u32)val, rand);

generates 32-bit accesses.  Oof.

#define vcpu_arch_put_guest(mem, val, rand) 					\
do {										\
	kvm_static_assert(sizeof(*mem) == sizeof(val));				\
	if (!is_forced_emulation_enabled || !(rand & 1)) {			\
		*mem = val;							\
	} else if (rand & 2) {							\
		__asm__ __volatile__(KVM_FEP "mov %1, %0"			\
				     : "+m" (*mem)				\
				     : "r" (val) : "memory");			\
	} else {								\
		uint64_t __old = READ_ONCE(*mem);				\
										\
		__asm__ __volatile__(LOCK_PREFIX "cmpxchg %[new], %[ptr]"	\
				     : [ptr] "+m" (*mem), [old] "+a" (__old)	\
				     : [new]"r" (val) : "memory", "cc");	\
	}									\
} while (0)


