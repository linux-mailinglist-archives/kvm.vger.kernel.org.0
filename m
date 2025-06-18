Return-Path: <kvm+bounces-49905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CEAADF810
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 22:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8A3B18990FE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 20:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4648321CC7F;
	Wed, 18 Jun 2025 20:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FmgemDcN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E415E21146B
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 20:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750279660; cv=none; b=QaDGPu2r8oWCwCaEb/2cJKNG0Fk5bMEWVsNdb6tMYtnDL+hVKBEexIoejn4iMFzphNRqyFG7Jq+ZKAMWfhHaepv6S1otxM7SV6wh+iKQ3MOyEMakstYDrk4eNUDQ6K6zd25y+ZuTZ2+WnxlKwJsJXDdgxfAxIW8w17OUWnjGJlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750279660; c=relaxed/simple;
	bh=MSg8wk9eVlKwpP07atFTFTL1LzBt6yhgrDLcbqqKcT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FI8KWGViOCVCVGFUlrusibVey8rhb6hCMY1cC13GcioO8RYq4lyUtGaRFC9SaY0GzoCR07jGN4EFyOdTyXJq1acpHGdukp0cw5ddJP+iDukUS7cYElHSuFJazpC7u5sB+qNM3eeAVW3EzqBcy+L7kb7m/fuwVaheRY5kxA21sNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FmgemDcN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747adea6ddbso45715b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 13:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750279658; x=1750884458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5t8P7O8Q2d0gJsfuLHKOR+WvGfRlegvudtjyvE+c7E=;
        b=FmgemDcNyXLWwf6F3uku7QRKifvsFNKZMU8fo6tjzAXkWhG1Wi/vBkee2OY/DLVrGL
         FprIuXhyfTMdwaVZfb9CF4VoebPI8huMLx6MadbvWihcqu2N+dAvrar3IOKcSOT3Lr8F
         /FQkyn2vFvnzw4/F/SOmoNhsl3fb3Xkry6f3o1/Lxp6SyOiQnMEsFiLzwaXPvDcxZ57A
         lZw5ikqhfDwAVWE7OPZ2mt/oKnB/fbMQxYeTYRVny0MY2+tkKrrE5TFsD8BnQ+57Udqp
         fLG6y878pd06wVl5oQhbDp9y4+hsnhjt6i31p5XmXY3hrIQ4od19TWQ4W5rl5Ipzk3Cq
         C6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750279658; x=1750884458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5t8P7O8Q2d0gJsfuLHKOR+WvGfRlegvudtjyvE+c7E=;
        b=RxO3keEaUlKua8VgKiiyYk5Co5RdM5Cj3WmHxa2LWaiE4tTrfNfA5e6TBbA7Ov8zs2
         dYDSevA2f/EU8FyDlluMDwuaqTDduzc8K9yncdNiSorFeWoZScdZsouIjNadhMHNQ3AY
         kGv+IJ5ztMwRtapvtl0UR/tLfINFYLJN/A8Xl4QZCAxPru9xzKJaB1aauS/lTIH5zsZd
         MXYFxFdeYzkXBR3KnfTk/aFEsq/fJ1if8MSd25eufCU8FN2ncyVUWoGkDe0FsNQ1frvu
         DQksLUfY6D+rH2A8XjueM1E53b69iPS+jgUGygSk3mFzFiE0GX/tDKtXKM53ZLn1FWHS
         /4MQ==
X-Forwarded-Encrypted: i=1; AJvYcCXB1gMDFiH8MHGQCoSX6FcjboZ8Drn4s2yeyXDgYW3Y2eDrzUvRKWKI8bOUDgSdCe8aohM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjAmfn7JQ+sorx5XK5mL27ZgFso/GcDpwxzScl1rzDyW6fm2If
	9jZT+9xNp0V4Dp+DHln9xDr3RkbJV1LHGutRfIEfU1akc53UsyOtQulPjT0g8Srn167qmIj46vP
	sXpsgBw==
X-Google-Smtp-Source: AGHT+IFsMlePwDY6qmxFMx2/AM9b76jDzDiB1mAOtEb6xvvscl9w6SK2u5TQJ/MjXtylS7QVbS8ovVI8RZ8=
X-Received: from pfbgh9.prod.google.com ([2002:a05:6a00:6389:b0:747:b682:5cc0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b8b:b0:736:5e28:cfba
 with SMTP id d2e1a72fcca58-7489cfc3944mr25334965b3a.18.1750279658241; Wed, 18
 Jun 2025 13:47:38 -0700 (PDT)
Date: Wed, 18 Jun 2025 13:47:36 -0700
In-Reply-To: <aFMaxi5LDr4HHbMR@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-4-jthoughton@google.com> <aFMaxi5LDr4HHbMR@linux.dev>
Message-ID: <aFMl6DOcKfH6ampb@google.com>
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
> On Wed, Jun 18, 2025 at 04:24:12AM +0000, James Houghton wrote:
> > +#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
> > +
> > +#define KVM_ASSERT_TYPE_IS(type_t, x)					\
> > +do {									\
> > +	type_t __maybe_unused tmp;					\
> > +									\
> > +	BUILD_BUG_ON(!__types_ok(tmp, x) || !__typecheck(tmp, x));	\
> > +} while (0)
> > +
> >  static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> > -						 gpa_t gpa, gpa_t size,
> > -						 bool is_write, bool is_exec,
> > -						 bool is_private)
> > +						 struct kvm_page_fault *fault)
> >  {
> > +	KVM_ASSERT_TYPE_IS(gfn_t, fault->gfn);
> > +	KVM_ASSERT_TYPE_IS(bool, fault->exec);
> > +	KVM_ASSERT_TYPE_IS(bool, fault->write);
> > +	KVM_ASSERT_TYPE_IS(bool, fault->is_private);
> > +	KVM_ASSERT_TYPE_IS(struct kvm_memory_slot *, fault->slot);
> > +
> >  	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> > -	vcpu->run->memory_fault.gpa = gpa;
> > -	vcpu->run->memory_fault.size = size;
> > +	vcpu->run->memory_fault.gpa = fault->gfn << PAGE_SHIFT;
> > +	vcpu->run->memory_fault.size = PAGE_SIZE;
> >  
> >  	/* RWX flags are not (yet) defined or communicated to userspace. */
> >  	vcpu->run->memory_fault.flags = 0;
> > -	if (is_private)
> > +	if (fault->is_private)
> >  		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
> >  }
> > +#endif
> 
> This *is not* the right direction of travel for arm64. Stage-2 aborts /
> EPT violations / etc. are extremely architecture-specific events.

Yes and no.  100% agreed there are arch/vendor specific aspects of stage-2 faults,
but there are most definitely commonalites as well.

> What I would like to see on arm64 is that for every "KVM_EXIT_MEMORY_FAULT"
> we provide as much syndrome information as possible. That could imply
> some combination of a sanitised view of ESR_EL2 and, where it is
> unambiguous, common fault flags that have shared definitions with x86.

Me confused, this is what the above does?  "struct kvm_page_fault" is arch
specific, e.g. x86 has a whole pile of stuff in there beyond gfn, exec, write,
is_private, and slot.

The approach is non-standard, but I think my justification/reasoning for having
the structure be arch-defined still holds:

 : Rather than define a common kvm_page_fault and kvm_arch_page_fault child,
 : simply assert that the handful of required fields are provided by the
 : arch-defined structure.  Unlike vCPU and VMs, the number of common fields
 : is expected to be small, and letting arch code fully define the structure
 : allows for maximum flexibility with respect to const, layout, etc.

If we could use anonymous struct field, i.e. could embed a kvm_arch_page_fault
without having to bounce through an "arch" field, I would vote for the approach.
Sadly, AFAIK, we can't yet use those in the kernel.

> This could incur some minor code duplication, but even then we can share
> helpers for the software bits (like userfault).

Again, that is what is proposed here.

> FEAT_MTE_PERM is a very good example for this. There exists a "Tag"
> permission at stage-2 which is unrelated to any of the 'normal'
> read/write permissions. There's also the MostlyReadOnly permission from
> FEAT_THE which grants write permission to a specific set of instructions.
> 
> I don't want to paper over these nuances and will happily maintain an
> arm64-specific flavor of "kvm_prepare_memory_fault_exit()"

Nothing prevents arm64 (or any arch) from wrapping kvm_prepare_memory_fault_exit()
and/or taking action after it's invoked.  That's not an accident; the "prepare
exit" helpers (x86 has a few more) were specifically designed to not be used as
the "return" to userspace.  E.g. this one returns "void" instead of -EFAULT
specifically so that the callers isn't "required" to ignore the return if the
caller wants to populate (or change, but hopefully that's never the case) fields
after calling kvm_prepare_memory_fault_exit), and so that arch can return an
entirely different error code, e.g. -EHWPOISON when appropriate.

And it's not just kvm_prepare_memory_fault_exit() that I want to use kvm_page_fault;
kvm_faultin_pfn() is another case where having a common "struct kvm_page_fault"
would clean up some ugly/annoying boilerplate.

