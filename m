Return-Path: <kvm+bounces-49926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA36ADFAA5
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 03:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 751283BEFE9
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478E218DB20;
	Thu, 19 Jun 2025 01:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MlSrfA+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC049625
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 01:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750296182; cv=none; b=gn2lp286Mlw20mI7lGG4nwD+VtruDM3fAsy9BCSxe6UntXQ/QHtLPgN9nX62cZNURRaPKx7r8RNo8TzQzx22tnkdSLMd8H0vQjx1uP/b8PTBNQoo1sJ4c7RVNcLFlCmsJ/YpLinKO+zm2Ud+JcqNVe5K5WctgNMps9eJEp9rQUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750296182; c=relaxed/simple;
	bh=1mgzvpG6sKakGwAjQUMT8gPBm4sFDWDBckjO/agSuXk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=spFMiHQ4W/rjxnDci0Y5WwTzw7VOB91PRIiJ/cS4Jlwjb7+K5qo1gss+SaHro/T2J5kaug0yAWRpwTUrj37ol9dMbOxxk0nM/u1jnBB0kF81jU4qmrzybwKKL/mLdE3wnhKT16fzWelX3BG3Gd9E8GNv4GoC97AUxGgE6HLLku8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MlSrfA+S; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso185333a91.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 18:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750296180; x=1750900980; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8IB1pXwG+o7bC4LkvgA8w7LAYlqk0B9GUuwyv4RmtU4=;
        b=MlSrfA+SMZ0LIBGoAZtoy0l0wkTNUm1mpvyWT5Jw+yqnYOqX5SUDIz164UhfBMWSVP
         rjE0sK/w4PqkRVOKt2ScmCDJH9FxIQVJoLfKwl5Rc26ewR40ddo8Yah+iWk8fhra9qgc
         oMa+FrrOG3x9WAS3FQTmRGFKbKLHVCs9KyoWLHW7IKU8jFZNx9rb7fSouDHVZcQaG8eV
         w4BsloAoRi3BF7fWeGuZ93d5uMBEvxs9cRmBzXb/HK8TZwDL7sA6bao/Zvor4FlH92XZ
         hjNvLXboVcF2gLighZJc1Rrq6cB+hEt4qs5GeWTt9vU/TlIqOqZ4/9Z64kdKIkpAHk5J
         qArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750296180; x=1750900980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8IB1pXwG+o7bC4LkvgA8w7LAYlqk0B9GUuwyv4RmtU4=;
        b=I5OP4iciQdJwipmHIzi4/4SLeiigFjQ1aIKC5ybtjF6LijHC9rPVXrC3n7mPgvpDVi
         2qxzxJRcx3Nb4deZLtL3edw2cyfYnJNh2ASLtIMmgKHpt2n+PSPGLNB0jL8GxpPy0lHl
         Jme9UkDF4Qd51Qr9COSPdtKF136X6JmuUaraGnjrgyLE5xT2O3IIyy+QqcIIuusnRllt
         OuL0utvYiFjIDMhP39oA5a+fdyJrzQsI2l0SAlQmtiFw3N9kH/eSJVCDAMdmGBGbMGfw
         SWgr9Xnvciffp6c/yX5iCPtoE4MmDzoD/rWkg0ClTkD+3V5wJtnfPMGZZJJYQ3DUthG1
         RgVg==
X-Forwarded-Encrypted: i=1; AJvYcCUtTI39j17buNYHXEYetX7z/7QhLs5JRX8zexYR6353eEPU2BNMd2DxecwWeMs8WlzTwJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIekHSGjNggNRE/sGECNrytuVWJgK+ND2aJrSOFW8pNrxLvsUt
	uwID6eWEadk019ZDKNKXd/jHvHecL78eCkYzHYGc1eNN3pw75r/10/Wy99IJ1PTLqWZRibWzCa9
	RQ73aKw==
X-Google-Smtp-Source: AGHT+IGdcvQAVVSk4fM09uW8oDEjJdJY7dpl9V3Y4AvXuJ+N0Avyh7SwiUaAWue2o5CoAmxFjj275F4p3uY=
X-Received: from pjbsz14.prod.google.com ([2002:a17:90b:2d4e:b0:313:1c10:3595])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:254e:b0:311:e8cc:4256
 with SMTP id 98e67ed59e1d1-313f1d644b8mr24662451a91.22.1750296180025; Wed, 18
 Jun 2025 18:23:00 -0700 (PDT)
Date: Wed, 18 Jun 2025 18:22:58 -0700
In-Reply-To: <aFNIPXoEb5iCjt_L@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-4-jthoughton@google.com> <aFMaxi5LDr4HHbMR@linux.dev>
 <aFMl6DOcKfH6ampb@google.com> <aFNIPXoEb5iCjt_L@linux.dev>
Message-ID: <aFNmci0s1_P845XZ@google.com>
Subject: Re: [PATCH v3 03/15] KVM: arm64: x86: Require "struct kvm_page_fault"
 for memory fault exits
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 18, 2025, Oliver Upton wrote:
> On Wed, Jun 18, 2025 at 01:47:36PM -0700, Sean Christopherson wrote:
> > On Wed, Jun 18, 2025, Oliver Upton wrote:
> > > What I would like to see on arm64 is that for every "KVM_EXIT_MEMORY_FAULT"
> > > we provide as much syndrome information as possible. That could imply
> > > some combination of a sanitised view of ESR_EL2 and, where it is
> > > unambiguous, common fault flags that have shared definitions with x86.
> > 
> > Me confused, this is what the above does?  "struct kvm_page_fault" is arch
> > specific, e.g. x86 has a whole pile of stuff in there beyond gfn, exec, write,
> > is_private, and slot.
> 
> Right, but now I need to remember that some of the hardware syndrome
> (exec, write) is handled in the arch-neutral code and the rest belongs
> to the arch.

Yeah, can't argue there.

> > The approach is non-standard, but I think my justification/reasoning for having
> > the structure be arch-defined still holds:
> > 
> >  : Rather than define a common kvm_page_fault and kvm_arch_page_fault child,
> >  : simply assert that the handful of required fields are provided by the
> >  : arch-defined structure.  Unlike vCPU and VMs, the number of common fields
> >  : is expected to be small, and letting arch code fully define the structure
> >  : allows for maximum flexibility with respect to const, layout, etc.
> > 
> > If we could use anonymous struct field, i.e. could embed a kvm_arch_page_fault
> > without having to bounce through an "arch" field, I would vote for the approach.
> > Sadly, AFAIK, we can't yet use those in the kernel.
> 
> The general impression is that this is an unnecessary amount of complexity
> for doing something trivial (computing flags).

It looks pretty though!

> > Nothing prevents arm64 (or any arch) from wrapping kvm_prepare_memory_fault_exit()
> > and/or taking action after it's invoked.  That's not an accident; the "prepare
> > exit" helpers (x86 has a few more) were specifically designed to not be used as
> > the "return" to userspace.  E.g. this one returns "void" instead of -EFAULT
> > specifically so that the callers isn't "required" to ignore the return if the
> > caller wants to populate (or change, but hopefully that's never the case) fields
> > after calling kvm_prepare_memory_fault_exit), and so that arch can return an
> > entirely different error code, e.g. -EHWPOISON when appropriate.
> 
> IMO, this does not achieve the desired layering / ownership of memory
> fault triage. This would be better organized as the arch code computing
> all of the flags relating to the hardware syndrome (even boring ones
> like RWX) 

Just to make sure I'm not misinterpreting things, by "computing all of the flags",
you mean computing KVM_MEMORY_EXIT_FLAG_xxx flags that are derived from hardware
state, correct?

> and arch-neutral code potentially lending a hand with the software bits.
>
> With this I either need to genericize the horrors of the Arm
> architecture in the common thing or keep track of what parts of the
> hardware flags are owned by arch v. non-arch. SW v. HW fault context is
> a cleaner split, IMO.

The problem I'm struggling with is where to draw the line.  If we leave hardware
state to arch code, then we're not left with much.  Hmm, but it really is just
the gfn/gpa that's needed in common code to avoid true ugliness.  The size is
technically arch specific, but the reported size is effectively a placeholder,
i.e. it's always PAGE_SIZE, and probably always will be PAGE_SIZE, but we wanted
to give ourselves an out if necessary.

Would you be ok having common code fill gpa and size?  If so, then we can do this:

--
void kvm_arch_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
					struct kvm_page_fault *fault);

static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
						 struct kvm_page_fault *fault)
{
	KVM_ASSERT_TYPE_IS(gfn_t, fault->gfn);

	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
	vcpu->run->memory_fault.gpa = fault->gfn << PAGE_SHIFT;
	vcpu->run->memory_fault.size = PAGE_SIZE;

	vcpu->run->memory_fault.flags = 0;
	kvm_arch_prepare_memory_fault_exit(vcpu, fault);
}
--

where arm64's arch hook is empty, and x86's is:

--
static inline void kvm_arch_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
						      struct kvm_page_fault *fault)
{
	if (fault->is_private)
		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
}
--

It's not perfect, but it should be much easier to describe the contract, and
common code can still pass around a kvm_page_fault structure instead of a horde
of booleans.

