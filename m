Return-Path: <kvm+bounces-8885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8778858359
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EF9A285812
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 17:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA406130E3A;
	Fri, 16 Feb 2024 17:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JFhP09vz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCA7219ED
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708103015; cv=none; b=LO8dcxUYOAwR4eiQbPIC3XCJie60L2rNMIUGISHgGmXLIQYJf1w8+3bSKeDN6a6DMnpUe7EhH/gYJJfBCjOzNiVDwiWHxN9aOxn2HPSGMuQAhc/lrmP5KvLXH5haA2dVFOkcOQshYqxMiK3nBGgAlP6iEShiKwucBBkaixL9T98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708103015; c=relaxed/simple;
	bh=x+OyUheZkOLmrmxRXV2DwJisBsuE5dlS0nGw3qHzNmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hRnJHaCQIaudr49azIonyheOTvEdXoREj3n67JQDsW6WU7t5HK/5HRNcVzAEUN9elt5VdP5EEMIOzvMedir0+35A0ozVTAY3AiKLzON3C8BAg82Lz3OWtqHvIlXvj4RxLcaz0fSCDD6LOtwALClMAxuo+DrQ8fqx0SA3tH9191E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JFhP09vz; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc05887ee9so1593179276.1
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 09:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708103013; x=1708707813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jSjwEV6mZP9dDWBaOFoNSK/PtiDDO4b/rWPQcC9pvsg=;
        b=JFhP09vzd8Ur/NChpd8ZrTmHN7LSXQyyGUDRWoXCv3UwIU/X8jYeyykWqKJMTLV7M2
         DJyR4U481v9BB7G++dF4fFfhueGJrwYUtQbrg9q2KBvuT1fraKzxwywW7GDlYYvQxKzD
         31T1Zbj0uMwLRMvLBhuzRsYgygaoGtgM5u6rBFCuKxlfhmMOzFO1bM0TLc4MxcUWLMtR
         CUv1jvPz6GASn6ROREA2xaBnErmRsjFRn+Xw7NG5VFA3iMjh93PboTHS3X0Ib54YDoxq
         NAkxzqFXFZTUdgY3g/jL0M2oz+1dLf6LRdHNbtdT7ROPsiOwBVzaFRa+kXgIWK9CEV+j
         cMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708103013; x=1708707813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jSjwEV6mZP9dDWBaOFoNSK/PtiDDO4b/rWPQcC9pvsg=;
        b=rbJY4jGPZ+Hl7dr9OAQfksWTu25gcK0XB9p3xmHZ7HhiSdj46imTFjg1Sgnj+WzOXz
         5vxgpM8AgePLZX13BEzRRkaKDvlZATGsm0RXa3Zc0SEFnVPi00Z0fmLUZecmMh5wWjOv
         CBT0hmC0ZSZ0jqrb99I9UOWTgoSQDRu5lNNhEBal3VOyl293shKl8YtjC7yqm5rAXr17
         QAAti5BfrqEbMrWCyOeHYsifXPLwYWT/GEPnxb9NYeqReu6zFIe0Okx8BEnAdFOD+4NO
         U5+aGdzPyjJ1eve7u7GOAl9fkq/1xh9d9KsXlhQk1F6IkxQDDQ/lkSUCQsZrCdYM9hHL
         JRHw==
X-Forwarded-Encrypted: i=1; AJvYcCV0j3RAiEiPWx41P1vAG59OZEp08Z9ijqixLEqG+CNYRIOhzKVQWLq4ZKBou25DAG4JcEi5BdBCGELkwLTl5jT//w1S
X-Gm-Message-State: AOJu0YxI5BANjzUgm3/wLlojviU5mUUvuLKTwszacn44RjW3Cfr6nImP
	2ebF5xQaBQTLgdK0Mvl2Cc+dBwTNCHvVS5ISFBopGSXcywpwSb3SNWxx+MkJYHbAdc6wQ1hAF1L
	QjQ==
X-Google-Smtp-Source: AGHT+IHp1ru1ym1MOeIsh/L/7YFwB33JnFl5QGD7UpvfqU3NoR29oVAhAcaA5dbK4aF5jKPPzeQH1neroQg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c3:b0:dc6:ebd4:cca2 with SMTP id
 w3-20020a05690210c300b00dc6ebd4cca2mr197453ybu.11.1708103013199; Fri, 16 Feb
 2024 09:03:33 -0800 (PST)
Date: Fri, 16 Feb 2024 09:03:31 -0800
In-Reply-To: <Zc-FXbxEfPNddiiL@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com> <20240215010004.1456078-3-seanjc@google.com>
 <Zc3JcNVhghB0Chlz@linux.dev> <Zc5c7Af-N71_RYq0@google.com>
 <Zc5wTHuphbg3peZ9@linux.dev> <Zc6DPEWcHh-TKCSD@google.com>
 <Zc6d6fwakreoVtN5@linux.dev> <Zc6rmksmgZ31fd-K@google.com> <Zc-FXbxEfPNddiiL@linux.dev>
Message-ID: <Zc-VY7yS5aDxMIp6@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 16, 2024, Oliver Upton wrote:
> On Thu, Feb 15, 2024 at 04:26:02PM -0800, Sean Christopherson wrote:
> > On Thu, Feb 15, 2024, Oliver Upton wrote:
> > > On Thu, Feb 15, 2024 at 01:33:48PM -0800, Sean Christopherson wrote:
> > > 
> > > [...]
> > > 
> > > > +/* TODO: Expand this madness to also support u8, u16, and u32 operands. */
> > > > +#define vcpu_arch_put_guest(mem, val, rand) 						\
> > > > +do {											\
> > > > +	if (!is_forced_emulation_enabled || !(rand & 1)) {				\
> > > > +		*mem = val;								\
> > > > +	} else if (rand & 2) {								\
> > > > +		__asm__ __volatile__(KVM_FEP "movq %1, %0"				\
> > > > +				     : "+m" (*mem)					\
> > > > +				     : "r" (val) : "memory");				\
> > > > +	} else {									\
> > > > +		uint64_t __old = READ_ONCE(*mem);					\
> > > > +											\
> > > > +		__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchgq %[new], %[ptr]"	\
> > > > +				     : [ptr] "+m" (*mem), [old] "+a" (__old)		\
> > > > +				     : [new]"r" (val) : "memory", "cc");		\
> > > > +	}										\
> > > > +} while (0)
> > > > +
> > > 
> > > Last bit of bikeshedding then I'll go... Can you just use a C function
> > > and #define it so you can still do ifdeffery to slam in a default
> > > implementation?
> > 
> > Yes, but the macro shenanigans aren't to create a default, they're to set the
> > stage for expanding to other sizes without having to do:
> > 
> >   vcpu_arch_put_guest{8,16,32,64}()
> > 
> > or if we like bytes instead of bits:
> > 
> >   vcpu_arch_put_guest{1,2,4,8}()
> > 
> > I'm not completely against that approach; it's not _that_ much copy+paste
> > boilerplate, but it's enough that I think that macros would be a clear win,
> > especially if we want to expand what instructions are used.
> 
> Oh, I see what you're after. Yeah, macro shenanigans are the only way
> out then. Wasn't clear to me if the interface you wanted w/ the selftest
> was a u64 write that you cracked into multiple writes behind the
> scenes.

I don't want to split u64 into multiple writes, as that would really violate the
principle of least surprise.  Even the RMW of the CMPXCHG is pushing things.

What I want is to provide an API that can be used by tests to generate guest writes
for the native/common sizes.  E.g. so that xen_shinfo_test can write 8-bit fields
using the APIs (don't ask me how long it took me to find a decent example that
wasn't using a 64-bit value :-) ).

	struct vcpu_info {
		uint8_t evtchn_upcall_pending;
		uint8_t evtchn_upcall_mask;
		unsigned long evtchn_pending_sel;
		struct arch_vcpu_info arch;
		struct pvclock_vcpu_time_info time;
	}; /* 64 bytes (x86) */

	vcpu_arch_put_guest(vi->evtchn_upcall_pending, 0);
	vcpu_arch_put_guest(vi->evtchn_pending_sel, 0);

And of course fleshing that out poked a bunch of holes in my plan, so after a
bit of scope screep...

---
#define vcpu_arch_put_guest(mem, __val) 						\
do {											\
	const typeof(mem) val = (__val);						\
											\
	if (!is_forced_emulation_enabled || guest_random_bool(&guest_rng)) {		\
		(mem) = val;								\
	} else if (guest_random_bool(&guest_rng)) {					\
		__asm__ __volatile__(KVM_FEP "mov %1, %0"				\
				     : "+m" (mem)					\
				     : "r" (val) : "memory");				\
	} else {									\
		uint64_t __old = READ_ONCE(mem);					\
											\
		__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchg %[new], %[ptr]"	\
				     : [ptr] "+m" (mem), [old] "+a" (__old)		\
				     : [new]"r" (val) : "memory", "cc");		\
	}										\
} while (0)
---

Where guest_rng is a global pRNG instance

	struct guest_random_state {
		uint32_t seed;
	};

	extern uint32_t guest_random_seed;
	extern struct guest_random_state guest_rng;

that's configured with a completely random seed by default, but can be overriden
by tests for determinism, e.g. in dirty_log_perf_test

  void __attribute((constructor)) kvm_selftest_init(void)
  {
	/* Tell stdout not to buffer its content. */
	setbuf(stdout, NULL);

	guest_random_seed = random();

	kvm_selftest_arch_init();
  }

and automatically configured for each VM.

	pr_info("Random seed: 0x%x\n", guest_random_seed);
	guest_rng = new_guest_random_state(guest_random_seed);
	sync_global_to_guest(vm, guest_rng);

	kvm_arch_vm_post_create(vm);

Long term, I want to get to the point where the library code supports specifying
a seed for every test, i.e. so that every test that uses the pRNG can be as
deterministic as possible.  But that's definitely a future problem :-)

