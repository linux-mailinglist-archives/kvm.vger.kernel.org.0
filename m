Return-Path: <kvm+bounces-35901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EADEA15A68
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B1B6168815
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 695F5BE4E;
	Sat, 18 Jan 2025 00:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXc7Rqre"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2753DB644
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737160789; cv=none; b=L/X+q+9B9ZvlbdiGqz/0Eyw81PDMbVxOlqNryyaW5YRVc3Ou3OLZeCilniZGvhjVdZA6y0C5wyApYIqzImA2NQw1aRrOuKu+KZ2ANFLL8milWFr1VPRYQUcAFheGZdRLEgKgTtuxFRvXPJ+ULR0SnQIwwodMe6Oxn+NgUSFw+O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737160789; c=relaxed/simple;
	bh=X1QOEMlRy7IG6bFUKOXH62leF4VvUd14g5J1Cm+jrXw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IKQzmifdKN1H7ksmoEF8ab7tHDgSat1v/1EfJy8EDExqET4prTmeHJ5GM9cvPwObXW1Cd18CKT+jtgTUSinNzG1w+4aJZS/wlk0EKWitebOirXkB/BdL+GQaGs8ye5kW5nja6culpXemxBGJI5Ay6vY79aqI0KFjHXUvfJlmFBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uXc7Rqre; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21632eacb31so35778565ad.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737160787; x=1737765587; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dY9GAAJ+JHiCoxpZUVXkSj3sHJx6fM6tLXfjGhbs4wY=;
        b=uXc7RqrenMkAC9SX2XA6nsQhqlK9cWmwgFNdS3L4E64yx4JdzJFjpA+rSnYdq8s5rN
         UHkRXxaxWt1HWcBEYugMhy8zVif6N6S5OzKxmN2s9pvD4AhzckcUudUMUnfVRYz/lWp4
         F1fRJdNi5PXHpIbgXIn8qEK/iItE50bfgz+BJdRAqyxUCNLMqhyOt8nDHhI7uCOo7yju
         ZGXkcTq07glUybhZEx5kt5ocpKmwva8HPhjSCJe3iN2OiSLWjiLVs6lfXMeSoayompUE
         XaULh4B2/NxplO1/ObCwil+GNVH+G80cDujGKjVKVFiYzLBPfnK04/T+XStGKSz5VZRR
         wr0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737160787; x=1737765587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dY9GAAJ+JHiCoxpZUVXkSj3sHJx6fM6tLXfjGhbs4wY=;
        b=eO0ZSXaWif7ydTuChqtJdSmrDh5SK7LaNzEOIi/GH1tTesiCzq/Sl4U3geReNf3uJB
         J0HjPFAHcav85Rxjs5Yr2hIIb+LmshFv+m23pjoOZobIrLSHJ3ukRZUXX+71gJBHcEA1
         qL5fy2rGQ4tAkE2FuJeWljZrQqlrw19Eid5EsRYLg1nagzVQGPpOiMkuGnVWjBcHIKNL
         xRpryqB98Wc4/DgqLXoXthmT5+rHEBJ7hVNYT5GHU3b+ebWxd+MgoLJlFqRyLboI5D4n
         dJmjorpXaOTdh0NXlsSNMJA1l+pgBEHOiuFe1e6Sn34YtWXjF4J1pKH3mPMZDTjvSC6P
         NdUg==
X-Forwarded-Encrypted: i=1; AJvYcCVRif33rZ1K1Bo+QXdFUXaWedC0StayOp4VWew/x+ECjRBCXyHMhZDOOTwR9WYZTZ1rC9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwORKHrdjjI2QfjBCjXORzuMfVI39bcNLiYIcQ68dZA8mgtPivu
	UiWQ8uIQpQz4aLrppnAYWPUaCOSSfIVZkXUuAAVa9JrjxboGVYfpabPiBPnTjpMEo4DQZHPI8Wt
	HkA==
X-Google-Smtp-Source: AGHT+IHBzj6Kv1fB+rUsFSp8uEWqCknZg3b6mFEvpazwHafSarx+1W9nugyev7mJ56+gWBsGvCttVCCHEN4=
X-Received: from pfl3.prod.google.com ([2002:a05:6a00:703:b0:725:d8bc:33e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7897:b0:1e1:af70:a30b
 with SMTP id adf61e73a8af0-1eb215855b7mr9211285637.34.1737160787518; Fri, 17
 Jan 2025 16:39:47 -0800 (PST)
Date: Fri, 17 Jan 2025 16:39:46 -0800
In-Reply-To: <Z4rwlyysGukXBBw4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com> <20250117234204.2600624-3-seanjc@google.com>
 <Z4rwlyysGukXBBw4@google.com>
Message-ID: <Z4r4UtpAIVe-EGeI@google.com>
Subject: Re: [PATCH 2/5] KVM: selftests: Only validate counts for
 hardware-supported arch events
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 18, 2025, Mingwei Zhang wrote:
> On Fri, Jan 17, 2025, Sean Christopherson wrote:
> > @@ -582,18 +585,26 @@ static void test_intel_counters(void)
> >  
> >  	/*
> >  	 * Detect the existence of events that aren't supported by selftests.
> > -	 * This will (obviously) fail any time the kernel adds support for a
> > -	 * new event, but it's worth paying that price to keep the test fresh.
> > +	 * This will (obviously) fail any time hardware adds support for a new
> > +	 * event, but it's worth paying that price to keep the test fresh.
> >  	 */
> >  	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
> >  		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
> > -		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
> > +		    nr_arch_events, this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
> 
> This is where it would make troubles for us (all companies that might be
> using the selftest in upstream kernel and having a new hardware). In
> this case when we get new hardware, the test will fail in the downstream
> kernel. We will have to wait until the fix is ready, and backport it
> downstream, re-test it.... It takes lots of extra work.

If Intel can't upstream what should be a *very* simple patch to enumerate the
new encoding and its expected count in advance of hardware being shipped to
partners, then we have bigger problems.  I don't know what level of pre-silicon
and FPGA-based emulation testing Intel does these days, but I wouldn't be at all
surprised if KVM tests are being run well before silicon arrives.

I am not at all convinced that this will ever affect anyone besides the Intel
engineers doing early enablement, and I am definitely not convinced it will ever
take significant effort above beyond what would be required irrespective of what
approach we take.  E.g. figuring out what the expected count is might be time
consuming, but I don't expect updating the test to be difficult.

> Perhaps we can just putting nr_arch_events = NR_INTEL_ARCH_EVENTS
> if the former is larger than or equal to the latter? So that the "test"
> only test what it knows. It does not test what it does not know, i.e.,
> it does not "assume" it knows everything. We can always a warning or
> info log at the moment. Then expanding the capability of the test should
> be added smoothly later by either maintainers of SWEs from CPU vendors
> without causing failures.

If we just "warn", we're effectively relying on a future Intel engineer to run
the test *and* check the logs *and* actually act on the warning.  Given that tests
are rarely run manually with a human pouring over the output, I highly doubt that
will pan out.

The more likely scenario is that the warn go unnoticed until some random person
sees the warn and files a bug somewhere.  At that point, odds are good that someone
who knows nothing about Intel's new hardware/event will get saddled with hunting
down the appropriate specs, digging into the details of the event, submitting a
patch upstream, etc.

And if multiple someones detect the warn, e.g. at different companines, then we've
collectively wasted even more time.  Which is a pretty likely scenario, because I
know with 100% certainly that people carry out-of-tree fixes :-)

By failing the test, pretty much the only assumption we're making is that Intel
cares about upstream KVM.  All evidence suggests that's a very safe assumption.
And as shown by my fumbling with Top-Down Slots, Intel engineers are absolutely
the right people to tackle this sort of thing, as they have accesses to resources
about uarch/CPU behavior that others don't.

If this approach turns out to be a huge pain, then we can certainly revisit things.
But I truly expect this will be less work for everyone, Intel included.

