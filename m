Return-Path: <kvm+bounces-3039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D57680013E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC0C3B21149
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F038617F3;
	Fri,  1 Dec 2023 01:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M85+qU07"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF7BA0
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:51:30 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-db49589f622so65616276.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395489; x=1702000289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=byu1akO/sublqF94hO2zFUsUyjhsuxmNz1CACi7ldr8=;
        b=M85+qU07mok2nKpVVS14I5/AtqsAHKxCiAisoAz/blADIlHI2KJuZnWlksqI7T0OFR
         ue9p2JozxL6HfwbULIlUlYsDubgFWhrX8jlx8uSltjobn6e39yR/XbvjHPj7jWbirtsM
         FLMHB3l4AttMtV/2aD7eTyT7e6K/jhyYxwlyJgMRYDYFlyJ+2oWIp9t2w97ErpOh276B
         vj7KmggnSosFdcDI5GdnBt+R7yjQ62Y0GyUDamDfG3FCcUNT4pIdQUbAvhadQDVyqt+d
         HhEhhTj3GpHJOgQNYBcIa6yWrXGzq6emei+G1BbWPvFAZKbrZbYn8FHahVUPCdEjQuZs
         dgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395489; x=1702000289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=byu1akO/sublqF94hO2zFUsUyjhsuxmNz1CACi7ldr8=;
        b=USuVEYu/Kzx298ihcuzaNuw/ThVJlQEyYgrnDlifXsbUyaHtyBVTIhHBKaTsWOzcvG
         yLYasy6tikVa+qAPjMN7r+J5qFZ82k3j+DJxDfsx2VKvuCP/UfTcvgoUivO53BWJajeU
         nc5XWZPz0fn2QlV0FL+hy9KaFhGwYiG1/a8ieFvIURaSHdf0xFJrWFwmWHOQUe6CSYxI
         gt7pdJjvqhzrETrW0hX2JJOd8iKOa5I4pusn32teVvI+wZbe1Ensk+8P5PKBTOy31KiE
         ID44PnGP8EiEdKCdT9k0YRoyEoaw3ptm5P9P0EUnBOqyST5VxVy2fgX05X+uUFZaezYg
         xFHQ==
X-Gm-Message-State: AOJu0YwLOxcUsaKEMFOXvz1TrP82gUg0qwiLNdf4cHWi//2eDluUWm+S
	Zh9etUNYQsNenCAPHmbFLat7ZPDIPOI=
X-Google-Smtp-Source: AGHT+IERDrWBX6TL3KZ0VNw9gIs+ZJ0GRBsdo7UlxzR2o5bgEIH2X0Ca3LMD/CAttsegjSycqbhTNmr0dtM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a3e6:0:b0:db4:5d34:fa5 with SMTP id
 e93-20020a25a3e6000000b00db45d340fa5mr754053ybi.0.1701395489584; Thu, 30 Nov
 2023 17:51:29 -0800 (PST)
Date: Thu, 30 Nov 2023 17:51:28 -0800
In-Reply-To: <3ad69657ba8e1b19d150db574193619cf0cb34df.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-4-seanjc@google.com>
 <3ad69657ba8e1b19d150db574193619cf0cb34df.camel@redhat.com>
Message-ID: <ZWk8IMZamuemfwXG@google.com>
Subject: Re: [PATCH 3/9] KVM: x86: Initialize guest cpu_caps based on guest CPUID
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Nov 19, 2023, Maxim Levitsky wrote:
> On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> > +/*
> > + * This isn't truly "unsafe", but all callers except kvm_cpu_after_set_cpuid()
> > + * should use __cpuid_entry_get_reg(), which provides compile-time validation
> > + * of the input.
> > + */
> > +static u32 cpuid_get_reg_unsafe(struct kvm_cpuid_entry2 *entry, u32 reg)
> > +{
> > +	switch (reg) {
> > +	case CPUID_EAX:
> > +		return entry->eax;
> > +	case CPUID_EBX:
> > +		return entry->ebx;
> > +	case CPUID_ECX:
> > +		return entry->ecx;
> > +	case CPUID_EDX:
> > +		return entry->edx;
> > +	default:
> > +		WARN_ON_ONCE(1);
> > +		return 0;
> > +	}
> > +}

...

> >  static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  {
> >  	struct kvm_lapic *apic = vcpu->arch.apic;
> >  	struct kvm_cpuid_entry2 *best;
> >  	bool allow_gbpages;
> > +	int i;
> >  
> > -	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
> > +	BUILD_BUG_ON(ARRAY_SIZE(reverse_cpuid) != NR_KVM_CPU_CAPS);
> > +
> > +	/*
> > +	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
> > +	 * honor userspace's definition for features that don't require KVM or
> > +	 * hardware management/support (or that KVM simply doesn't care about).
> > +	 */
> > +	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
> > +		const struct cpuid_reg cpuid = reverse_cpuid[i];
> > +
> > +		best = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
> > +		if (best)
> > +			vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(best, cpuid.reg);
> 
> Why not just use __cpuid_entry_get_reg? 
> 
> cpuid.reg comes from read/only 'reverse_cpuid' anyway, and in fact
> it seems that all callers of __cpuid_entry_get_reg, take the reg value from
> x86_feature_cpuid() which also takes it from 'reverse_cpuid'.
> 
> So if the compiler is smart enough to not complain in these cases, I don't
> see why this case is different.

It's because the input isn't a compile-time constant, and so the BUILD_BUG() in
the default path will fire.  All of the compile-time assertions in reverse_cpuid.h
rely on the feature being a constant value, which allows the compiler to optimize
away the dead paths, i.e. turn __cpuid_entry_get_reg()'s switch statement into
simple pointer arithmetic and thus omit the BUILD_BUG() code.

> Also why not to initialize guest_caps = host_caps & userspace_cpuid?
>
> If this was the default we won't need any guest_cpu_cap_restrict and such,
> instead it will just work.

Hrm, I definitely like the idea.  Unfortunately, unless we do an audit of all
~120 uses of guest_cpuid_has(), restricting those based on kvm_cpu_caps might
break userspace.

Aside from purging the governed feature nomenclature, the main goal of this series
provide a way to do fast lookups of all known guest CPUID bits without needing to
opt-in on a feature-by-feature basis, including for features that are fully
controlled by userspace.

It's definitely doable, but I'm not all that confident that the end result would
be a net positive, e.g. I believe we would need to special case things like the
feature bits that gate MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD.  MOVBE and RDPID
are other features that come to mind, where KVM emulates the feature in software
but it won't be set in kvm_cpu_caps.

Oof, and MONITOR and MWAIT too, as KVM deliberately doesn't advertise those to
userspace.

So yeah, I'm not opposed to trying that route at some point, but I really don't
want to do that in this series as the risk of subtly breaking something is super
high.

> Special code will only be needed in few more complex cases, like forced exposed
> of a feature to a guest due to a virtualization hole.
> 
> 
> > +		else
> > +			vcpu->arch.cpu_caps[i] = 0;
> > +	}
> >  
> >  	/*
> >  	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
> > @@ -342,8 +380,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	 */
> >  	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
> >  				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
> > -	if (allow_gbpages)
> > -		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
> > +	guest_cpu_cap_change(vcpu, X86_FEATURE_GBPAGES, allow_gbpages);
> 
> IMHO the original code was more readable, now I need to look up the
> 'guest_cpu_cap_change()' to understand what is going on.

The change is "necessary".  The issue is that with the caps 0-initialied, the
!allow_gbpages could simply do nothing.  Now, KVM needs to explicitly clear the
flag, i.e. would need to do:

	if (allow_gbpages)
		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
	else
		guest_cpu_cap_clear(vcpu, X86_FEATURE_GBPAGES);

I don't much love the name either, but it pairs with cpuid_entry_change() and I
want to keep the kvm_cpu_cap, cpuid_entry, and guest_cpu_cap APIs in sync as far
as the APIs go.  The only reason kvm_cpu_cap_change() doesn't exist is because
there aren't any flows that need to toggle a bit.

> >  static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 8a99a73b6ee5..5827328e30f1 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4315,14 +4315,14 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
> >  	 * the guest read/write access to the host's XSS.
> >  	 */
> > -	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> > -	    boot_cpu_has(X86_FEATURE_XSAVES) &&
> > -	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> > -		guest_cpu_cap_set(vcpu, X86_FEATURE_XSAVES);
> > +	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
> > +			     boot_cpu_has(X86_FEATURE_XSAVE) &&
> > +			     boot_cpu_has(X86_FEATURE_XSAVES) &&
> > +			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
> 
> In theory this change does change behavior, now the X86_FEATURE_XSAVE will
> be set iff the condition is true, but before it was set *if* the condition was true.

No, before it was set if and only if the condition was true, because in that case
caps were 0-initialized, i.e. this was/is the only way for XSAVE to be set.

> > -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_NRIPS);
> > -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
> > -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LBRV);
> > +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_NRIPS);
> > +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_TSCRATEMSR);
> > +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_LBRV);
> 
> One of the main reasons I don't like governed features is this manual list.

To be fair, the manual lists predate the governed features.

> I want to reach the point that one won't need to add anything manually,
> unless there is a good reason to do so, and there are only a few exceptions
> when the guest cap is set, while the host's isn't.

Yeah, agreed.

