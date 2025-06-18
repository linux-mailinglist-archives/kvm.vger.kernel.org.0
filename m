Return-Path: <kvm+bounces-49917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D376ADF9AC
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBFA219E0080
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F29280025;
	Wed, 18 Jun 2025 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fJj+vEfc"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91D61C2324
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 23:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750288466; cv=none; b=M9XZMfkpnXiG3LPLMZthKi1eyLvhW9iH/ZsCJnpyNM6prNMPWuS6ZcBUAa07E31XrDVYzYXM207AJ/PsGXqLvgAawWImKdz8KW+5rwaqWSMQsScEHjSafiwcXTgdbMhIoD8bBlBlLyxJwjoCDYLomvKeNdJWcnOOwXSBmidp83s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750288466; c=relaxed/simple;
	bh=i1l/wHmMl5v9/5hDL69xn16QG5060/zhsjh31N+rMMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHz0mTkGiYRhYHsPOF+bhNjRVyZaXrjystE7mBItF2s2TyL7VchRCjakDd8t15WnOJWh36hCpp4JtkZUaKWsQ/5YFQdPtV3Q6PySB7XPzA+Le+b5ig7MTcxWw6WwJzAlPMTL8TXFR4GBj+Zo2LtHRBV79P3e+cQ9/Z8RI6FCifk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fJj+vEfc; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Jun 2025 16:14:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750288461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aVP3DiB3HvKNlxTLG6+nr+sih4i6SPT2KS137bqEj/Y=;
	b=fJj+vEfcdZsyWbaYG30vNEKCtdWDHf3g/Ygtj0VNq6V4fzpOclefHU3KyXH2CvANdlmjNK
	KXUHjfjWAYGVPuitRWmnlr44c7tykStb3daT7iXyVWr7i8HlcdTbOqEYIaSPjBClT5iSGs
	GXLmADF9YQYmQOiFGcADjtlYqs4zKUs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 03/15] KVM: arm64: x86: Require "struct
 kvm_page_fault" for memory fault exits
Message-ID: <aFNIPXoEb5iCjt_L@linux.dev>
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-4-jthoughton@google.com>
 <aFMaxi5LDr4HHbMR@linux.dev>
 <aFMl6DOcKfH6ampb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFMl6DOcKfH6ampb@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 18, 2025 at 01:47:36PM -0700, Sean Christopherson wrote:
> On Wed, Jun 18, 2025, Oliver Upton wrote:
> > On Wed, Jun 18, 2025 at 04:24:12AM +0000, James Houghton wrote:
> > > +#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
> > > +
> > > +#define KVM_ASSERT_TYPE_IS(type_t, x)					\
> > > +do {									\
> > > +	type_t __maybe_unused tmp;					\
> > > +									\
> > > +	BUILD_BUG_ON(!__types_ok(tmp, x) || !__typecheck(tmp, x));	\
> > > +} while (0)
> > > +
> > >  static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> > > -						 gpa_t gpa, gpa_t size,
> > > -						 bool is_write, bool is_exec,
> > > -						 bool is_private)
> > > +						 struct kvm_page_fault *fault)
> > >  {
> > > +	KVM_ASSERT_TYPE_IS(gfn_t, fault->gfn);
> > > +	KVM_ASSERT_TYPE_IS(bool, fault->exec);
> > > +	KVM_ASSERT_TYPE_IS(bool, fault->write);
> > > +	KVM_ASSERT_TYPE_IS(bool, fault->is_private);
> > > +	KVM_ASSERT_TYPE_IS(struct kvm_memory_slot *, fault->slot);
> > > +
> > >  	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> > > -	vcpu->run->memory_fault.gpa = gpa;
> > > -	vcpu->run->memory_fault.size = size;
> > > +	vcpu->run->memory_fault.gpa = fault->gfn << PAGE_SHIFT;
> > > +	vcpu->run->memory_fault.size = PAGE_SIZE;
> > >  
> > >  	/* RWX flags are not (yet) defined or communicated to userspace. */
> > >  	vcpu->run->memory_fault.flags = 0;
> > > -	if (is_private)
> > > +	if (fault->is_private)
> > >  		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
> > >  }
> > > +#endif
> > 
> > This *is not* the right direction of travel for arm64. Stage-2 aborts /
> > EPT violations / etc. are extremely architecture-specific events.
> 
> Yes and no.  100% agreed there are arch/vendor specific aspects of stage-2 faults,
> but there are most definitely commonalites as well.

And I agree those commonalities should be expressed with the same flags
where possible.

> > What I would like to see on arm64 is that for every "KVM_EXIT_MEMORY_FAULT"
> > we provide as much syndrome information as possible. That could imply
> > some combination of a sanitised view of ESR_EL2 and, where it is
> > unambiguous, common fault flags that have shared definitions with x86.
> 
> Me confused, this is what the above does?  "struct kvm_page_fault" is arch
> specific, e.g. x86 has a whole pile of stuff in there beyond gfn, exec, write,
> is_private, and slot.

Right, but now I need to remember that some of the hardware syndrome
(exec, write) is handled in the arch-neutral code and the rest belongs
to the arch.

> The approach is non-standard, but I think my justification/reasoning for having
> the structure be arch-defined still holds:
> 
>  : Rather than define a common kvm_page_fault and kvm_arch_page_fault child,
>  : simply assert that the handful of required fields are provided by the
>  : arch-defined structure.  Unlike vCPU and VMs, the number of common fields
>  : is expected to be small, and letting arch code fully define the structure
>  : allows for maximum flexibility with respect to const, layout, etc.
> 
> If we could use anonymous struct field, i.e. could embed a kvm_arch_page_fault
> without having to bounce through an "arch" field, I would vote for the approach.
> Sadly, AFAIK, we can't yet use those in the kernel.

The general impression is that this is an unnecessary amount of
complexity for doing something trivial (computing flags).

> > This could incur some minor code duplication, but even then we can share
> > helpers for the software bits (like userfault).
> 
> Again, that is what is proposed here.
> 
> > FEAT_MTE_PERM is a very good example for this. There exists a "Tag"
> > permission at stage-2 which is unrelated to any of the 'normal'
> > read/write permissions. There's also the MostlyReadOnly permission from
> > FEAT_THE which grants write permission to a specific set of instructions.
> > 
> > I don't want to paper over these nuances and will happily maintain an
> > arm64-specific flavor of "kvm_prepare_memory_fault_exit()"
> 
> Nothing prevents arm64 (or any arch) from wrapping kvm_prepare_memory_fault_exit()
> and/or taking action after it's invoked.  That's not an accident; the "prepare
> exit" helpers (x86 has a few more) were specifically designed to not be used as
> the "return" to userspace.  E.g. this one returns "void" instead of -EFAULT
> specifically so that the callers isn't "required" to ignore the return if the
> caller wants to populate (or change, but hopefully that's never the case) fields
> after calling kvm_prepare_memory_fault_exit), and so that arch can return an
> entirely different error code, e.g. -EHWPOISON when appropriate.

IMO, this does not achieve the desired layering / ownership of memory
fault triage. This would be better organized as the arch code computing
all of the flags relating to the hardware syndrome (even boring ones
like RWX) and arch-neutral code potentially lending a hand with the
software bits.

With this I either need to genericize the horrors of the Arm
architecture in the common thing or keep track of what parts of the
hardware flags are owned by arch v. non-arch. SW v. HW fault context is
a cleaner split, IMO.

> And it's not just kvm_prepare_memory_fault_exit() that I want to use kvm_page_fault;
> kvm_faultin_pfn() is another case where having a common "struct kvm_page_fault"
> would clean up some ugly/annoying boilerplate.

That might be a better starting point for unifying these things, esp.
since kvm_faultin_pfn() doesn't have UAPI implications hiding behind it
and is already using common parameters.

Thanks,
Oliver

