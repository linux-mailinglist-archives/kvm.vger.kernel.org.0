Return-Path: <kvm+bounces-36217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 333C8A18B25
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 05:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DCB33A4055
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 04:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1233B170A15;
	Wed, 22 Jan 2025 04:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UWbjwMjE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94375139CEF
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 04:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737521491; cv=none; b=d1qyJ0YD4fySq+JpkVO41MEjgBIgWBkqj8vjE9wr0J/6Yi1vbmbOCDKs6FlhLtXuYc3jz7dicMomU7UUJi+gxykB7BX6SH+P+2lV1rvgiQ4JeiXdR11P+xYk2rBqvhZu/pjkWl8O887Sh3pktSMw1qzU14datZy4NDPlTbbx8ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737521491; c=relaxed/simple;
	bh=tiEhZ5b/vN54FtKJHlFwj89cugqdL7OpW23JZIQ5VXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPLQbFzTO0LsXgWFxRHAclfY3FXciZ246A9P0y2d+bt+7lssIT71W3482Fi3BJPykrrtHnBBcEX8XAdnJTOSVYm5nVL7MEQrG2V3y/KBRIfrngFiAgDDP1ZZfxz9ctlF819OON26jmoYhmnePpGdJGOiMsk1Jy+ucQsy9YPWgP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UWbjwMjE; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21675fd60feso136167575ad.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 20:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737521489; x=1738126289; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LMg7IzwAs7aWlfSxL9hyXSFF6jyQL3kZ9U9+E66mlfI=;
        b=UWbjwMjE1JMgLUwJtoIFomDGewyqir2yPwYA1YV6Mz0U6nqjWwRKU9cctK4w17a6aY
         iuJEVOEHmBx3Nw5yXgKR3z09bQU/h0dR6y7unr1fb2BZ+n5lDtuaOfVjrgElKI5DEz3K
         rnbl1cKsah8iSxHbwrmUXBZxy1/4YMDHZP9SJ8qPLBYO8nIT3oWKP4xLSCih6xiqbare
         nHuMlda4/o2n9LcYuyEiRADvWdFTJh7GLx6trS6UmkcCJD8AccZpcMEyfvbixo53G7o5
         DSK3nuPxRxWAN+pYQtYTVX6o2sBQPDdWHMzjHj1c1XZ1QSyJ/PGFhXlWtdfhNpR4ZAAL
         GnhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737521489; x=1738126289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LMg7IzwAs7aWlfSxL9hyXSFF6jyQL3kZ9U9+E66mlfI=;
        b=h3Kd/Ia/hFFJ4IJwC0t45GKnCaa6uTo0mc19tj3Rt40Aq41jotO5CVPpHGgPU2fTg6
         52pZyUkkv5jglWWV5yWs6LGuwO9+/7tX04wHxWPcX0yhxkuGw2JNXdhtiOcFhlzqlipg
         NW++cyKtM63aJK4VW4uyOnx0cgEmmjIstehOob8A/+YNqa6g4XlVOwAKSeykh4w3xe9U
         gzJ/53Lf3ak3luQbBYWw1RIZtPQMN58adKnpXWmM26et2QN0OuVrrBiBVBRRNVZ9TPTS
         fppUFv+ZQYr1x27BMeFgRhjOIUHIWS2U3NGN94b7N/V2Fm0lb6uKuUXDZncbjdNXeMP3
         VYJw==
X-Forwarded-Encrypted: i=1; AJvYcCU9N/bpsoReYarFrh6y4s8CTUcvX0R74gBBezETRft1cx66cGmZkrCtV3cX9GNVQ9EyzCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0At61dDEoYPoJWLD/Gdn2xzYsQLbTPvJHNRQTORe37bkjEmMe
	Sru36PWfZC6yCdvabqSPPmGD7ImEtCHk/2WhA+wSHXXgDJoeCISkK39u6dO8fA==
X-Gm-Gg: ASbGncvnNWVyNOKP57ZGqcQdKULUz6btiwfAgTdRFaMXQjJf+0RwyuvkveuaAHqN8BL
	HozT/kmTIQCk8TLpHndxEaX1AZW7r3A4yfU9zZ4oKZpMcTy8WUZKcEFA6GbnqSaaakzz5HuSiUB
	X/Zpr3KH8fHydd2Lg8j4IBi2r4rd4IRyWAKHGrIit9AhqNUi68ZJQ6C6zj56is1Vvj9OT28OAK+
	SjqG3Yggps92JJVcAsBsDhc0AMyZvwu9vvGhJ8W6f7BtyZ3PkgOfDCEIuonsGVo+58xJmlTTjiH
	Dj4+9ere1n1sgDksZNz+quIFCoLr
X-Google-Smtp-Source: AGHT+IFQO0Jt1MhnXWhN0szgzeJ4BxO+OCtdmpo+HsajIDuoe3rMArsLvTn7qtJ4Ya6Vd7VkjorKDA==
X-Received: by 2002:a05:6a20:6a0a:b0:1e0:c5d2:f215 with SMTP id adf61e73a8af0-1eb2147ea3amr28191314637.12.1737521488479;
        Tue, 21 Jan 2025 20:51:28 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab7f1776sm9783735b3a.7.2025.01.21.20.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 20:51:27 -0800 (PST)
Date: Wed, 22 Jan 2025 04:51:24 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 2/5] KVM: selftests: Only validate counts for
 hardware-supported arch events
Message-ID: <Z5B5TJz9vn43AFcT@google.com>
References: <20250117234204.2600624-1-seanjc@google.com>
 <20250117234204.2600624-3-seanjc@google.com>
 <Z4rwlyysGukXBBw4@google.com>
 <Z4r4UtpAIVe-EGeI@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4r4UtpAIVe-EGeI@google.com>

On Fri, Jan 17, 2025, Sean Christopherson wrote:
> On Sat, Jan 18, 2025, Mingwei Zhang wrote:
> > On Fri, Jan 17, 2025, Sean Christopherson wrote:
> > > @@ -582,18 +585,26 @@ static void test_intel_counters(void)
> > >  
> > >  	/*
> > >  	 * Detect the existence of events that aren't supported by selftests.
> > > -	 * This will (obviously) fail any time the kernel adds support for a
> > > -	 * new event, but it's worth paying that price to keep the test fresh.
> > > +	 * This will (obviously) fail any time hardware adds support for a new
> > > +	 * event, but it's worth paying that price to keep the test fresh.
> > >  	 */
> > >  	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
> > >  		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
> > > -		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
> > > +		    nr_arch_events, this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
> > 
> > This is where it would make troubles for us (all companies that might be
> > using the selftest in upstream kernel and having a new hardware). In
> > this case when we get new hardware, the test will fail in the downstream
> > kernel. We will have to wait until the fix is ready, and backport it
> > downstream, re-test it.... It takes lots of extra work.
> 
> If Intel can't upstream what should be a *very* simple patch to enumerate the
> new encoding and its expected count in advance of hardware being shipped to
> partners, then we have bigger problems.  I don't know what level of pre-silicon
> and FPGA-based emulation testing Intel does these days, but I wouldn't be at all
> surprised if KVM tests are being run well before silicon arrives.

Right, Intel folks will be the 1st one that is impacted. But it should
be easy to fix on their end. But upstreaming the change may come very
late.

> 
> I am not at all convinced that this will ever affect anyone besides the Intel
> engineers doing early enablement, and I am definitely not convinced it will ever
> take significant effort above beyond what would be required irrespective of what
> approach we take.  E.g. figuring out what the expected count is might be time
> consuming, but I don't expect updating the test to be difficult.

It will affect the downstream kernels, I think? Like Paolo mentioned,
old distro kernel may run on new hardware. In usual cases, Intel HW has
already come out for a while, and the upstream software update is still
there under review. Fixing the problem is never difficult. But we need a
minor fix for each new generation of HW that adds a new architecture
event. I can imagine fixing that needs a simple patch, but each of them
has to cc stable tree and with "Fixes" tag.

> 
> > Perhaps we can just putting nr_arch_events = NR_INTEL_ARCH_EVENTS
> > if the former is larger than or equal to the latter? So that the "test"
> > only test what it knows. It does not test what it does not know, i.e.,
> > it does not "assume" it knows everything. We can always a warning or
> > info log at the moment. Then expanding the capability of the test should
> > be added smoothly later by either maintainers of SWEs from CPU vendors
> > without causing failures.
> 
> If we just "warn", we're effectively relying on a future Intel engineer to run
> the test *and* check the logs *and* actually act on the warning.  Given that tests
> are rarely run manually with a human pouring over the output, I highly doubt that
> will pan out.

In reality, we may not even need to warn. If the test only covers what
it knows, then there is no alarm to report. On the other hand, CPU
vendor who is doing the development will have selftest series to
update it. It will not just increase the array size, but also add more
meaningful testcases to the new events. The assumption is CPU vendors
care about upstream, which I think is true.
> 
> The more likely scenario is that the warn go unnoticed until some random person
> sees the warn and files a bug somewhere.  At that point, odds are good that someone
> who knows nothing about Intel's new hardware/event will get saddled with hunting
> down the appropriate specs, digging into the details of the event, submitting a
> patch upstream, etc.
> 
> And if multiple someones detect the warn, e.g. at different companines, then we've
> collectively wasted even more time.  Which is a pretty likely scenario, because I
> know with 100% certainly that people carry out-of-tree fixes :-)

Right, so a warning is not necessary here.
> 
> By failing the test, pretty much the only assumption we're making is that Intel
> cares about upstream KVM.  All evidence suggests that's a very safe assumption.
> And as shown by my fumbling with Top-Down Slots, Intel engineers are absolutely
> the right people to tackle this sort of thing, as they have accesses to resources
> about uarch/CPU behavior that others don't.

Well, yes. I believe Intel cares about it. I see Dapeng's effort, which
is really great. But often the effort is not just to fix that simple
bug, there are other parts that need to be done to test Top-Down slots
and other fixes. For instance, Dapeng's series for kvm-unit-tests/pmu is
still under review after 12+ months?

https://lore.kernel.org/all/20240914101728.33148-8-dapeng1.mi@linux.intel.com/

I think this is a minor pain for us, since we are strictly following the
upstream version on kut. Maybe that is something we need to change?

Thanks.
-Mingwei
>
> If this approach turns out to be a huge pain, then we can certainly revisit things.
> But I truly expect this will be less work for everyone, Intel included.



