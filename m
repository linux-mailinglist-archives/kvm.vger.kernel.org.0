Return-Path: <kvm+bounces-21137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A62392AC1B
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 00:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAF701F228AC
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 22:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F81D150990;
	Mon,  8 Jul 2024 22:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pBE8gWBf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA58EBA46
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 22:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720477861; cv=none; b=EGxCIseh+L6OZccZS6kGEhpPYDN30rjm1PQRBimZXmn5N2StmB0ROuc4prEwqETt9CcFxNmc3CqeeeU7C2DUqGT5EHOPnN0RO+fyMJ+iS8Qmv/ijyfoWY0i+tpxFQ88XoCmWJOlro1WedklErWCsbtjyEGG00hIc0n8rXaW4BlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720477861; c=relaxed/simple;
	bh=DxjFH2LzZhZ8hr43nYQ/YVK+kwb9tNIvqThsgQH5ic4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kdOkkySqwO4bQes5YL61gwp+FI6l5KJYAXPVjT7ryvWCXeZrALP1ClC6vI6g7QiPOxgb5A7NEqHrfZxvYYV3CHU0Ux28fCOnarcmJrJS6R6Tipc7lz0MHUjvztYYTobcpLNPgLAKlZutwXSalVtMDY237qM1EVUnRDTt3G4jOvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pBE8gWBf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c1a9e8d3b0so4192519a91.0
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 15:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720477859; x=1721082659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOryehqZgXhKzfmyM95QSSUzBz/WwHvTtSuB+5Cszfg=;
        b=pBE8gWBfXT4sWvHfq7LzB0hYSH7A7kSewTHPLx4NtqULVYwEw21wt1TyekwJw3B9wf
         Qm3l4DysWAC1vnJHoQkpjZHBvM7kvAffmPMsJ/6u2kPq8lSTNi6PLkVPeb+pKrlBqsJn
         XYgnQoHD2MCYol3Ox3PgutU4bFWBEKfBndbwWFVRKd9Ba+SkaafvjJGINKXG2a3w2uG9
         7m+hJ2tz3XSeWOHwso/gOUqYULigqBZYwD8uG+M+9Ix6V6KHAmjto6ZA2cF7HaOO3XfE
         Y2D9gXyL+Q3Qor705zQBFDwyiWEbvLSq9+k/CABRs3/jypRyLv/ZlL7fQVh6O9yCitXf
         gGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720477859; x=1721082659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOryehqZgXhKzfmyM95QSSUzBz/WwHvTtSuB+5Cszfg=;
        b=A+0UabzznOAYvhGlljeToAZ+vkl8OSTd3f+eWM0udq744WJpwAdMzE4CN9POFKRd8P
         h/QA50VAerQyQjToIQSp63jGBkfK2MwYqKWh3W1mH76Hb5URb97Bc9W0U6cZ1mA2FIDs
         r22aRl6hLeLeiGAuMnaBthw3oDrsKVhpUjNHNINhC1VpljRLzz7Q+Vxpodz8doO6wTed
         Wtuba9v5a0N3iID2qylJawZq01hCf8xYH2s40ALjfXtzAa+JDDCbOviY+T+kmmDWJR+0
         ImeFMRxz7MWZnkTxHJE5PMuvJB8pYEdlY/kJHanwyboCmUu7hFWjKcXQNNF5xzJpxCV6
         O9pQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8F21D4ybcwulZ5K+5jtN+jCcStxaVPXmMhbSnZBtM4EvA+Jk0L9le0a+Yatc3PAFeMBm5wjISnJgHwelPEZ9QeVJK
X-Gm-Message-State: AOJu0YySlD6M3UdiVh9lWLTkkNFRC8QXGHlEdGu0tOG7tuaepIv4Z9Ro
	ebXzivur9fJcu7frgV2+gCJTxD9XV0ukKNOunPyqXYlr6LpWEZhGeXhu0itku9QUbWcZdH/cIWH
	9+Q==
X-Google-Smtp-Source: AGHT+IFAx9k6pwvDeFOFaAqWDu2AAJ+nznsxuC8v6PQ+pdxu4kNuK/fLrVvTDpomnhqbDnInY7xFrdM7jMk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e610:b0:2c9:6903:a427 with SMTP id
 98e67ed59e1d1-2ca35be7eb9mr44941a91.1.1720477859108; Mon, 08 Jul 2024
 15:30:59 -0700 (PDT)
Date: Mon, 8 Jul 2024 15:30:57 -0700
In-Reply-To: <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-27-seanjc@google.com>
 <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
Message-ID: <ZoxooTvO5vIEnS5V@google.com>
Subject: Re: [PATCH v2 26/49] KVM: x86: Add a macro to init CPUID features
 that KVM emulates in software
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > Now that kvm_cpu_cap_init() is a macro with its own scope, add EMUL_F() to
> > OR-in features that KVM emulates in software, i.e. that don't depend on
> > the feature being available in hardware.  The contained scope
> > of kvm_cpu_cap_init() allows using a local variable to track the set of
> > emulated leaves, which in addition to avoiding confusing and/or
> > unnecessary variables, helps prevent misuse of EMUL_F().
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 36 +++++++++++++++++++++---------------
> >  1 file changed, 21 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 1064e4d68718..33e3e77de1b7 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -94,6 +94,16 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
> >  	F(name);						\
> >  })
> >  
> > +/*
> > + * Emulated Feature - For features that KVM emulates in software irrespective
> > + * of host CPU/kernel support.
> > + */
> > +#define EMUL_F(name)						\
> > +({								\
> > +	kvm_cpu_cap_emulated |= F(name);			\
> > +	F(name);						\
> > +})
> 
> To me it feels more and more that this patch series doesn't go into the right
> direction.
> 
> How about we just abandon the whole concept of masks and instead just have a
> list of statements
> 
> Pretty much the opposite of the patch series I confess:

FWIW, I think it's actually largely the same code under the hood.  The code for
each concept/flavor ends up being very similar, it's mostly just handling the
bitwise-OR in the callers vs. in the helpers.

> #define CAP_PASSTHOUGH		0x01
> #define CAP_EMULATED		0x02
> #define CAP_AMD_ALIASED		0x04 // for AMD aliased features
> #define CAP_SCATTERED		0x08
> #define CAP_X86_64		0x10 // supported only on 64 bit hypervisors
> ...
> 
> 
> /* CPUID_1_ECX*/
> 
> 				/* TMA is not passed though because: xyz*/
> kvm_cpu_cap_init(TMA,           0);
> 
> kvm_cpu_cap_init(SSSE3,         CAP_PASSTHOUGH);
> 				/* CNXT_ID is not passed though because: xyz*/
> kvm_cpu_cap_init(CNXT_ID,       0);
> kvm_cpu_cap_init(RESERVED,      0);
> kvm_cpu_cap_init(FMA,           CAP_PASSTHOUGH);
> ...
> 				/* KVM always emulates TSC_ADJUST */
> kvm_cpu_cap_init(TSC_ADJUST,    CAP_EMULATED | CAP_SCATTERED);
> 
> ...
> 
> /* CPUID_D_1_EAX*/
> 				/* XFD is disabled on 32 bit systems because: xyz*/
> kvm_cpu_cap_init(XFD, 		CAP_PASSTHOUGH | CAP_X86_64)
> 
> 
> 'kvm_cpu_cap_init' can be a macro if needed to have the compile checks.
> 
> There are several advantages to this:
> 
> - more readability, plus if needed each statement can be amended with a comment.
> - No weird hacks in 'F*' macros, which additionally eventually evaluate into a bit,
>   which is confusing.
>   In fact no need to even have them at all.
> - No need to verify that bitmask belongs to a feature word.

Yes, but the downside is that there is no enforcement of features in a word being
bundled together.

> - Merge friendly - each capability has its own line.

That's almost entirely convention though.  Other than inertia, nothing is stopping
us from doing:

	kvm_cpu_cap_init(CPUID_12_EAX,
		SF(SGX1) |
		SF(SGX2) |
		SF(SGX_EDECCSSA)
	);

I don't see a clean way of avoiding the addition of " |" on the last existing
line, but in practice I highly doubt that will ever be a source of meaningful pain.

Same goes for the point about adding comments.  We could do that with either
approach, we just don't do so today.

> Disadvantages:
> 
> - Longer list - IMHO not a problem, since it is very easy to read / search
>   and can have as much comments as needed.
>   For example this is how the kernel lists the CPUID features and this list IMHO
>   is very manageable.

There's one big difference: KVM would need to have a line for every feature that
KVM _doesn't_ support.  For densely populated words, that's not a huge issue,
but it's problematic for sparsely populated words, e.g. CPUID_12_EAX would have
29 reserved/unsupport entries, which IMO ends up being a big net negative for
code readability and ongoing maintenance.

We could avoid that cost (and the danger of a missed bit) by collecting the set
of features that have been initialized for each word, and then masking off the
uninitialized/unsupported at the end.  But then we're back to the bitwise-OR and
mask logic.

And while I agree that having the F*() macros set state _and_ evaulate to a bit
is imperfect, it does have its advantages.  E.g. to avoid evaluating to a value,
we could have F() modify a local variable that is scoped to kvm_cpu_cap_init(),
a las kvm_cpu_cap_emulated.  But then we'd need explicit code and/or comments
to call out that VMM_F() and the like intentionally don't set kvm_cpu_cap_supported,
whereas evualating to a value is a relatively self-documenting "0;".

> - Slower - kvm_set_cpu_caps is called exactly once per KVM module load, thus
>   performance is the last thing I would care about in this function.
> 
> Another note about this patch: It is somewhat confusing that EMUL_F just
> forces a feature in kvm caps, regardless of CPU support, because KVM also has
> KVM_GET_EMULATED_CPUID and it has a different meaning.

Yeah, but IMO that's a problem with KVM_GET_EMULATED_CPUID being poorly defined.

> Users can easily confuse the EMUL_F for something that sets a feature bit in
> the KVM_GET_EMULATED_CPUID.

I'll see if I can find a good spot for a comment to try and convenient

