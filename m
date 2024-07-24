Return-Path: <kvm+bounces-22187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9286793B650
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF2E2B22F2E
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7C415FA9E;
	Wed, 24 Jul 2024 17:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GHjuwRfs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472212E639
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843937; cv=none; b=dJbyyqomkK4ZUzV+BA5WFOxk3T6jNEEGy1iG6omeBQzoFryCAAnMfJpvorzxow1ZXml5gwbbD4EEal4dGi0F7gd/ubKKRvaw4cE08kronbmUjx4rdHFSgynOzbPWUICTZw47GQfgUSsSqzyBNmHL/DFgX91oiCQfkIdt25E772Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843937; c=relaxed/simple;
	bh=zrvZSCzQqqsG7YHRX0OKAe3JyxQzkecxpP5x1BpC++Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mCtmKJM51OyM/cjVDAsCbL3M9K8lS8Ifje2Ix63/UMvoTFcTUtaZNQqyyTbDWuTGzQUQPWScb1ivf4RihEgEibKpEPKF1xlOCu5iNYtNDv/Y3bOWo6ZZc33LX69XRqrWt+kGpSoKv+Z34VfNhU4XOTfxyrcWhlxgFzPFaVtLsE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GHjuwRfs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721843934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=12KhlajV+NJl0/ULt5L95ZmPmciLnbPLur97YZsNQU4=;
	b=GHjuwRfsxSjxQU5UF6BOgzMKAUYD68gKHl6BvBQEwn44p0DVhe/sNy0oA/kmhFgovxrEy2
	kQteogn2ln7uDW+/Au83zfrdpZ/dHEgBnPZ8rB4SElaahksMA5Jzr1eABU9FGFKwZ39yi4
	vbqAVSGfSfXH9+qI1m0r1l/63FbZugY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-3kiV9J9dO6GvYxNMmCMmNw-1; Wed, 24 Jul 2024 13:58:50 -0400
X-MC-Unique: 3kiV9J9dO6GvYxNMmCMmNw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-447dc559df8so400421cf.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721843930; x=1722448730;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=12KhlajV+NJl0/ULt5L95ZmPmciLnbPLur97YZsNQU4=;
        b=lxRHmI7t5Eod5il9QJHd0jrTIppN4RLVGA1hW5JsQEyWp2CpefyWnveoaxjZ3Ht9WW
         RbP0gS8kKIdcjyytwzW9zfp4t6dchvihNUWrVX5WOCUHFAM+RYsaPDs4PlB4H0TA+CBw
         JGYHRsgFI08y8mG3R/pqSxsP8UyZgrMVCJis8HijlayeUOC3lx6vM90sgTZQ8FKCUBBi
         UigQN03WjHFvjIfPIbcQVBzlOiEaMaB8PP+1RS5xktogs6yZsjxoVKkPXXHPWtdDQdXW
         jSO7SbXJA01YmxBbXLOhjQxvnH1bEOYMMV9I6hryF+SdNRnSxZH4d3S343SUdq8euQrt
         /xBg==
X-Forwarded-Encrypted: i=1; AJvYcCWQ+zcjxM+naBI1wKZgh+J8bAeWQfkCi0EWfWNqujUYLtx0+jaRYoGxgBDXRhwhF/OPwLXZbCRDCYthageXuhmOXt1o
X-Gm-Message-State: AOJu0YxHvz3thw/38323DMz30XdXpN8YN5a0VL7sOpoOsuKh+177J7Je
	xugfQLMfufXg+NewZ/ynDFDi18wj51I8m0000eP7DF9o803GZKzbit+IqlcPeIpKkRu2TsZh9xa
	IMDgMMBF6hCUcNrdYnr2cINZPDRr39C7CoTr5PQjxCCGZkI0bZw==
X-Received: by 2002:ac8:5e4f:0:b0:447:e40a:f61a with SMTP id d75a77b69052e-44fe32d2877mr4959961cf.18.1721843930100;
        Wed, 24 Jul 2024 10:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpa/oJOMF1ngHZpzHrA7Mx5P4Gsjlhq+oo6TdhTx7cxaRgbMFliza+MBP/XCkTOK4eFviTWw==
X-Received: by 2002:ac8:5e4f:0:b0:447:e40a:f61a with SMTP id d75a77b69052e-44fe32d2877mr4959721cf.18.1721843929655;
        Wed, 24 Jul 2024 10:58:49 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44f9cd04062sm57043621cf.40.2024.07.24.10.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:58:49 -0700 (PDT)
Message-ID: <2e531204c32c05c96e852748d490424a6f69a018.camel@redhat.com>
Subject: Re: [PATCH v2 26/49] KVM: x86: Add a macro to init CPUID features
 that KVM emulates in software
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:58:48 -0400
In-Reply-To: <ZoxooTvO5vIEnS5V@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-27-seanjc@google.com>
	 <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
	 <ZoxooTvO5vIEnS5V@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 15:30 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > Now that kvm_cpu_cap_init() is a macro with its own scope, add EMUL_F() to
> > > OR-in features that KVM emulates in software, i.e. that don't depend on
> > > the feature being available in hardware.  The contained scope
> > > of kvm_cpu_cap_init() allows using a local variable to track the set of
> > > emulated leaves, which in addition to avoiding confusing and/or
> > > unnecessary variables, helps prevent misuse of EMUL_F().
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c | 36 +++++++++++++++++++++---------------
> > >  1 file changed, 21 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 1064e4d68718..33e3e77de1b7 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -94,6 +94,16 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
> > >  	F(name);						\
> > >  })
> > >  
> > > +/*
> > > + * Emulated Feature - For features that KVM emulates in software irrespective
> > > + * of host CPU/kernel support.
> > > + */
> > > +#define EMUL_F(name)						\
> > > +({								\
> > > +	kvm_cpu_cap_emulated |= F(name);			\
> > > +	F(name);						\
> > > +})
> > 
> > To me it feels more and more that this patch series doesn't go into the right
> > direction.
> > 
> > How about we just abandon the whole concept of masks and instead just have a
> > list of statements
> > 
> > Pretty much the opposite of the patch series I confess:
> 
> FWIW, I think it's actually largely the same code under the hood.  The code for
> each concept/flavor ends up being very similar, it's mostly just handling the
> bitwise-OR in the callers vs. in the helpers.
> 
> > #define CAP_PASSTHOUGH		0x01
> > #define CAP_EMULATED		0x02
> > #define CAP_AMD_ALIASED		0x04 // for AMD aliased features
> > #define CAP_SCATTERED		0x08
> > #define CAP_X86_64		0x10 // supported only on 64 bit hypervisors
> > ...
> > 
> > 
> > /* CPUID_1_ECX*/
> > 
> > 				/* TMA is not passed though because: xyz*/
> > kvm_cpu_cap_init(TMA,           0);
> > 
> > kvm_cpu_cap_init(SSSE3,         CAP_PASSTHOUGH);
> > 				/* CNXT_ID is not passed though because: xyz*/
> > kvm_cpu_cap_init(CNXT_ID,       0);
> > kvm_cpu_cap_init(RESERVED,      0);
> > kvm_cpu_cap_init(FMA,           CAP_PASSTHOUGH);
> > ...
> > 				/* KVM always emulates TSC_ADJUST */
> > kvm_cpu_cap_init(TSC_ADJUST,    CAP_EMULATED | CAP_SCATTERED);
> > 
> > ...
> > 
> > /* CPUID_D_1_EAX*/
> > 				/* XFD is disabled on 32 bit systems because: xyz*/
> > kvm_cpu_cap_init(XFD, 		CAP_PASSTHOUGH | CAP_X86_64)
> > 
> > 
> > 'kvm_cpu_cap_init' can be a macro if needed to have the compile checks.
> > 
> > There are several advantages to this:
> > 
> > - more readability, plus if needed each statement can be amended with a comment.
> > - No weird hacks in 'F*' macros, which additionally eventually evaluate into a bit,
> >   which is confusing.
> >   In fact no need to even have them at all.
> > - No need to verify that bitmask belongs to a feature word.
> 
> Yes, but the downside is that there is no enforcement of features in a word being
> bundled together.

As I explained earlier, this is not an issue in principle, even if the caps are not
grouped together, the code will still work just fine.


kvm_cpu_cap_init_begin(CPUID_1_ECX);
                                /* TMA is not passed though because: xyz*/
kvm_cpu_cap_init(TMA,           0);
kvm_cpu_cap_init(SSSE3,         CAP_PASSTHOUGH);
                                /* CNXT_ID is not passed though because: xyz*/
kvm_cpu_cap_init(CNXT_ID,       0);
kvm_cpu_cap_init(RESERVED,      0);
kvm_cpu_cap_init(FMA,           CAP_PASSTHOUGH);
...
                                /* KVM always emulates TSC_ADJUST */
kvm_cpu_cap_init(TSC_ADJUST,    CAP_EMULATED | CAP_SCATTERED);

kvm_cpu_cap_init_end(CPUID_1_ECX);

...

...

And kvm_cpu_cap_init_begin, can set some cap_in_progress variable.



> 
> > - Merge friendly - each capability has its own line.
> 
> That's almost entirely convention though.  Other than inertia, nothing is stopping
> us from doing:
> 
> 	kvm_cpu_cap_init(CPUID_12_EAX,
> 		SF(SGX1) |
> 		SF(SGX2) |
> 		SF(SGX_EDECCSSA)

That trivial change is already an improvement, although it still leaves the problem
of thinking that this is one bit 'or', which was reasonable before this patch series,
because it was indeed one big 'or' but now there is lots of things going on behind
the scenes and that violates the principle of the least surprise.

My suggestion fixes this, because when the user sees a series of function calls,
and nobody will assume anything about these functions calls in contrast with series
of 'ors'. It's just how I look at it.

> 	);
> 
> I don't see a clean way of avoiding the addition of " |" on the last existing
> line, but in practice I highly doubt that will ever be a source of meaningful pain.
> 
> Same goes for the point about adding comments.  We could do that with either
> approach, we just don't do so today.

Yes, from the syntax POV there is indeed no problem, and I do agree that putting
each feature on its own line, together with comments for the features that need it
is a win-win improvement over what we have after this patch series.

> 
> > Disadvantages:
> > 
> > - Longer list - IMHO not a problem, since it is very easy to read / search
> >   and can have as much comments as needed.
> >   For example this is how the kernel lists the CPUID features and this list IMHO
> >   is very manageable.
> 
> There's one big difference: KVM would need to have a line for every feature that
> KVM _doesn't_ support.

Could you elaborate on why?
If we zero the whole leaf and then set specific bits there, one bit per kvm_cpu_cap_init.



>   For densely populated words, that's not a huge issue,
> but it's problematic for sparsely populated words, e.g. CPUID_12_EAX would have
> 29 reserved/unsupport entries, which IMO ends up being a big net negative for
> code readability and ongoing maintenance.
> 
> We could avoid that cost (and the danger of a missed bit) by collecting the set
> of features that have been initialized for each word, and then masking off the
> uninitialized/unsupported at the end.  But then we're back to the bitwise-OR and
> mask logic.
> 
> And while I agree that having the F*() macros set state _and_ evaulate to a bit
> is imperfect, it does have its advantages.  E.g. to avoid evaluating to a value,
> we could have F() modify a local variable that is scoped to kvm_cpu_cap_init(),
> a las kvm_cpu_cap_emulated.  But then we'd need explicit code and/or comments
> to call out that VMM_F() and the like intentionally don't set kvm_cpu_cap_supported,
> whereas evualating to a value is a relatively self-documenting "0;".
> 
> > - Slower - kvm_set_cpu_caps is called exactly once per KVM module load, thus
> >   performance is the last thing I would care about in this function.
> > 
> > Another note about this patch: It is somewhat confusing that EMUL_F just
> > forces a feature in kvm caps, regardless of CPU support, because KVM also has
> > KVM_GET_EMULATED_CPUID and it has a different meaning.
> 
> Yeah, but IMO that's a problem with KVM_GET_EMULATED_CPUID being poorly defined.
> 
> > Users can easily confuse the EMUL_F for something that sets a feature bit in
> > the KVM_GET_EMULATED_CPUID.
> 
> I'll see if I can find a good spot for a comment to try and convenient


Best regards,
	Maxim Levitsky
> 



