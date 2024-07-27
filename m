Return-Path: <kvm+bounces-22448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 442B093DC6D
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CE0FB2B021
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5B115BB;
	Sat, 27 Jul 2024 00:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Me5oqkNG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D67195
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 00:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038801; cv=none; b=GE43yvWf9upGoZREKvPzgavwaAjnTjbbCtY7RnoZCmOWSUg69b4weThrljAJp6NpIMhCzMVq7KQhA+7rEel4n9ZUZcOAdW7TosXMJgk/39zACnvEgRDFcSX3rHaeOvy35ZZHyQMSsKAw7ljzhNPs42fGLF62uXx25EE4NoR0kV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038801; c=relaxed/simple;
	bh=clGgwaThq7CrSz1vGebpyTV6G8p+QKZkor0wZ+7eg5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ga9zGHOLDOlDS3OEQC23LXdA2A+KYznkTbmuh/1svjdD+Y2hRzkfjP5kl0edyRNYixga+0PsuP8M+BkszWEfjDiXbEpJP24WlGoEYqo7hJUqUr92PUMrlFBwncGSlXAW0mKD0vnfaE3jKv2icvO8h405ldTDd1Y2TtIOBPmSL2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Me5oqkNG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7163489149fso1436371a12.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 17:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038799; x=1722643599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TYFTf2gvPk70qhiNuy0y1/EVQ4Xy1vYcEPYyOPCAl+o=;
        b=Me5oqkNGGYa9Vs0ClpJhtSk2AMed00/DPQ9gTetb5nYyyugM1++s0UUjb1i50DIdsM
         epd62yLOTj5l9rrG9gBAD9B3aMytmu0+BaLcLJXhycjpsXILdZ8lEi5HWcqjJW0wHltV
         WiNRWoZS1SXUvAJKy68m/+OORi8pS598c0bh5dhylviPYOjNYcjH1jld3W1lCWW910Uw
         3lYJ2lrDrmzCdm9EdcLgdqVaQg7eg+u2t3+34wOZlQETe6UH7kBVdhHW2cqkx3nzqyhc
         XXxuFBHCScFHA+trWY67YluywlWytaXZo3VaMxOeIcRh1Q3nVEqqAxxtAkkphmYs3kJw
         +AhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038799; x=1722643599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYFTf2gvPk70qhiNuy0y1/EVQ4Xy1vYcEPYyOPCAl+o=;
        b=aRsG18EdHUsSBXVr68aIsFAgMULVGlq7PS6ZGZXDvYryxgJ3GgEii7tdCBdasV0ctX
         liyInUzfYFQa4Bi/ZyZCa5el3JcxWM20lkCrUMXK8DojQZ/gmkvul6/axq0neCxoQVf/
         CDEbBWMdlOQ3bT0Yo1TA28+dWBSCmhYnkI5uv8FXxyX8z9JmNg1DoWHc7YBa6giAzbl0
         rT4E79qUrg5fSH1QT19DzzeoqTJG4kxRpUAydfu5l7BYdPQ6G3sXVrHhiqiq0X1IZicL
         nTc5Lqkn3LF6tZCbzRflxRK+n7uJoHUGSWNQpDmOAAGq7R6a8FCPM7YotxXwupolkrzK
         mVSg==
X-Forwarded-Encrypted: i=1; AJvYcCV3Sto7gkfUt2JB6y94iw3hSDiUwZxbYCbPR2HfEETyLcNKeat55hFQ0tAyIJszEDm6BEiQxwXQY+deEQHIBwJMY2Kh
X-Gm-Message-State: AOJu0YwCIQBSbg8sOrup09Y42CZsnhxcFQv5rW6Km4/MUGYYsVrvSJFx
	LwRcW60WqUzNUEdogWyMujaduursW9/IQGqzDwOCHAG2+/TATgTGnioxilCbUzn1bR3izcISFVS
	5aQ==
X-Google-Smtp-Source: AGHT+IHRLn6X/3YQ2HHqsOw+80PDOfGcWeXsdrPLJ+UYpZu0hqZ+ortJBIDhkLrR0/WGfl3sAoAsnArH88U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6918:0:b0:75d:16f9:c075 with SMTP id
 41be03b00d2f7-7ac8fe31243mr2147a12.9.1722038799164; Fri, 26 Jul 2024 17:06:39
 -0700 (PDT)
Date: Fri, 26 Jul 2024 17:06:37 -0700
In-Reply-To: <2e531204c32c05c96e852748d490424a6f69a018.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-27-seanjc@google.com>
 <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
 <ZoxooTvO5vIEnS5V@google.com> <2e531204c32c05c96e852748d490424a6f69a018.camel@redhat.com>
Message-ID: <ZqQ6DWUou8hvu0qE@google.com>
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

On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> On Mon, 2024-07-08 at 15:30 -0700, Sean Christopherson wrote:
> > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > There are several advantages to this:
> > > 
> > > - more readability, plus if needed each statement can be amended with a comment.
> > > - No weird hacks in 'F*' macros, which additionally eventually evaluate into a bit,
> > >   which is confusing.
> > >   In fact no need to even have them at all.
> > > - No need to verify that bitmask belongs to a feature word.
> > 
> > Yes, but the downside is that there is no enforcement of features in a word being
> > bundled together.
> 
> As I explained earlier, this is not an issue in principle, even if the caps are not
> grouped together, the code will still work just fine.

I agree that functionally it'll all be fine, but I also want the code to bunch
things together for readers.  We can force that with functions, though it means
passing in more state to kvm_cpu_cap_init_{begin,end}().

> kvm_cpu_cap_init_begin(CPUID_1_ECX);
>                                 /* TMA is not passed though because: xyz*/
> kvm_cpu_cap_init(TMA,           0);
> kvm_cpu_cap_init(SSSE3,         CAP_PASSTHOUGH);
>                                 /* CNXT_ID is not passed though because: xyz*/
> kvm_cpu_cap_init(CNXT_ID,       0);
> kvm_cpu_cap_init(RESERVED,      0);
> kvm_cpu_cap_init(FMA,           CAP_PASSTHOUGH);
> ...
>                                 /* KVM always emulates TSC_ADJUST */
> kvm_cpu_cap_init(TSC_ADJUST,    CAP_EMULATED | CAP_SCATTERED);
> 
> kvm_cpu_cap_init_end(CPUID_1_ECX);
> 
> ...
> 
> ...
> 
> And kvm_cpu_cap_init_begin, can set some cap_in_progress variable.

Ya, but then compile-time asserts become run-time asserts.

> > > - Merge friendly - each capability has its own line.
> > 
> > That's almost entirely convention though.  Other than inertia, nothing is stopping
> > us from doing:
> > 
> > 	kvm_cpu_cap_init(CPUID_12_EAX,
> > 		SF(SGX1) |
> > 		SF(SGX2) |
> > 		SF(SGX_EDECCSSA)
> 
> That trivial change is already an improvement, although it still leaves the problem
> of thinking that this is one bit 'or', which was reasonable before this patch series,
> because it was indeed one big 'or' but now there is lots of things going on behind
> the scenes and that violates the principle of the least surprise.
> 
> My suggestion fixes this, because when the user sees a series of function calls,
> and nobody will assume anything about these functions calls in contrast with series
> of 'ors'. It's just how I look at it.

If it's the macro styling that's misleading, we could do what we did for the
static_call() wrappers and make them look like functions.  E.g.

	kvm_cpu_cap_init(CPUID_12_EAX,
		scattered_f(SGX1) |
		scattered_f(SGX2) |
		scattered_f(SGX_EDECCSSA)
	);

though that probably doesn't help much and is misleading in its own right.  Does
it help if the names are more verbose? 
 
> > 	);
> > 
> > I don't see a clean way of avoiding the addition of " |" on the last existing
> > line, but in practice I highly doubt that will ever be a source of meaningful pain.
> > 
> > Same goes for the point about adding comments.  We could do that with either
> > approach, we just don't do so today.
> 
> Yes, from the syntax POV there is indeed no problem, and I do agree that putting
> each feature on its own line, together with comments for the features that need it
> is a win-win improvement over what we have after this patch series.
> 
> > 
> > > Disadvantages:
> > > 
> > > - Longer list - IMHO not a problem, since it is very easy to read / search
> > >   and can have as much comments as needed.
> > >   For example this is how the kernel lists the CPUID features and this list IMHO
> > >   is very manageable.
> > 
> > There's one big difference: KVM would need to have a line for every feature that
> > KVM _doesn't_ support.
> 
> Could you elaborate on why?
> If we zero the whole leaf and then set specific bits there, one bit per kvm_cpu_cap_init.

Ah, if we move the the handling of boot_cpu_data[*] into the helpers, then yes,
there's no need to explicitly initialize features that aren't supported by KVM.

That said, I still don't like using functions instead of macros, mainly because
a number of compile-assertions become run-time assertions.  To provide equivalent
functionality, we also would need to pass in extra state to begin/end() (as
mentioned earlier).  Getting compile-time assertions on usage, e.g. via
guest_cpu_cap_has(), would also be trickier, though still doable, I think.
Lastly, it adds an extra step (calling _end()) to each flow, i.e. adds one more
thing for developers to mess up.  But that's a very minor concern and definitely
not a sticking point.

I agree that the macro shenanigans are aggressively clever, but for me, the
benefits of compile-time asserts make it worth dealing with the cleverness.

[*] https://lore.kernel.org/all/ZqKlDC11gItH1uj9@google.com

