Return-Path: <kvm+bounces-36547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8D2A1B9CE
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5867162391
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 15:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1A316190B;
	Fri, 24 Jan 2025 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="izvesjLK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225D714D430
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737734259; cv=none; b=iR8oyH1pwH6q5F/Tzxp8V+2plT/vMqSnULyir/iUR9lT+vgWqI1fdz3OdedOgu0jQjNeJoBNwkyL9d1CuzUb+0MWR7LgLCyiWNDfEEbwy6Lp7skzERVjf6OYZ976XcGHG8v2UGTduXhPUe3TAclolhk/WX5VXdO1wkFtK8ihq80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737734259; c=relaxed/simple;
	bh=MCFC8LwOSdqenQJ6mD9M2wEf/jfkjOqhZgOKTdpa/Hc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FkRzj7fBbxjKYmCLxLB3nEdyVWhm6emGCBjvl4dhAiUlZl25xsuUAV+kVVnumRr9a1QENKwEknTJdnnl1I3kflHNMhoJL8FwndZBF447rcO+55+D3+LgbSUHWawfIJ14csfp+G2zs6+o5D5HLSN9wAyyw/NBfQJ/XE5JaUPnwpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=izvesjLK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21638389f63so34496505ad.1
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 07:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737734257; x=1738339057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldRJ9lDQzBkTYhlUwBS5PtcuGQGyOG6AjPsYZmKonB0=;
        b=izvesjLKiD8Fd04Mq1hZmPnxCl/MCew6h64Azg324YE8o8svZrHFYH840a0KXT1zJo
         xTH1KnMbEaUkj/IS2J4hJXHj+zkGATXnNIWKU4odgL69ZuQPEJGVI4HszdW5/XNjAqOM
         DCut3A3Rr720MgdOvnPbWXyxTnbv2zq1UuBSNDP2IFQakHw+4EhhqgRLqbKcDhyX3c8M
         wN9wrF8ID0Q5KVTmBQoRUDQGdTbwjbZqsfUNymc91b/30gxEPmO9q2h0zk5EA1vorpnE
         72lOcfUZ0pkUR8oeuGTswDi6IUfTidsmbsuppcsVXgXjpmYtThJ1W8mUvVKlzFfLQi5A
         ZFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737734257; x=1738339057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldRJ9lDQzBkTYhlUwBS5PtcuGQGyOG6AjPsYZmKonB0=;
        b=BWC+MT74wlFYm3rJgXE+0I5HokS5f/sY526DBlkpFfS3VYhnAlB+9c3aFyel67w00W
         S6MzpYb8BLPvTbhNCV2a4ANK6hfQkPNvVwjFqMQCD46KRKymTPCQ+TB/q/BZHUhB//rG
         S722KPu/BS7yvlp1XWTgaw7LzmUs3PlcTGo/kME/XribwJPx/6yl9D3cT9hbYfEgWl2j
         M0IOWpdeTv3huDWHMW4NKaqK9LkNFbSToU7Z/a51vWgMSWuUrVg1+CEdZlob8w5JCAsW
         +Jg8+CUkcd4hmB1ErVmjHcH1BbQllHtU8yyg9VGLhnJ0YjYVQUStdicogWPRo4ubgnG/
         i33g==
X-Forwarded-Encrypted: i=1; AJvYcCXhCJAaa71o3gEauhm+0I+030nNN6r6tzMzdENErSYVVhl4aFttihCR7P72aSNDY6MVAFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH+719L9g+ippD03VH5iw4+WwABs2j+X0u1hUmxeFwk8WC7V8e
	n/p8s+TeWad/+BXP23sQYAx/min0ePrre48pxZsoYdBS3Lrxd5B34a33m8KP1yz+cf+d5PyZY6D
	q7A==
X-Google-Smtp-Source: AGHT+IF7cWJvitveW7PxhwCFPD8smjqtOrfKXudEXX9R7O6MK16dckcWo2sUvTcAtkgvvmxZ2SsVzm3d2n8=
X-Received: from pfwy36.prod.google.com ([2002:a05:6a00:1ca4:b0:72a:9fce:4f44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3391:b0:1e0:d123:7166
 with SMTP id adf61e73a8af0-1eb2148de80mr49217980637.14.1737734257383; Fri, 24
 Jan 2025 07:57:37 -0800 (PST)
Date: Fri, 24 Jan 2025 07:57:35 -0800
In-Reply-To: <Z5B5TJz9vn43AFcT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com> <20250117234204.2600624-3-seanjc@google.com>
 <Z4rwlyysGukXBBw4@google.com> <Z4r4UtpAIVe-EGeI@google.com> <Z5B5TJz9vn43AFcT@google.com>
Message-ID: <Z5O4b3c2gfdr9inN@google.com>
Subject: Re: [PATCH 2/5] KVM: selftests: Only validate counts for
 hardware-supported arch events
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 22, 2025, Mingwei Zhang wrote:
> On Fri, Jan 17, 2025, Sean Christopherson wrote:
> > On Sat, Jan 18, 2025, Mingwei Zhang wrote:
> > > On Fri, Jan 17, 2025, Sean Christopherson wrote:
> > > > @@ -582,18 +585,26 @@ static void test_intel_counters(void)
> > > >  
> > > >  	/*
> > > >  	 * Detect the existence of events that aren't supported by selftests.
> > > > -	 * This will (obviously) fail any time the kernel adds support for a
> > > > -	 * new event, but it's worth paying that price to keep the test fresh.
> > > > +	 * This will (obviously) fail any time hardware adds support for a new
> > > > +	 * event, but it's worth paying that price to keep the test fresh.
> > > >  	 */
> > > >  	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
> > > >  		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
> > > > -		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
> > > > +		    nr_arch_events, this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
> > > 
> > > This is where it would make troubles for us (all companies that might be
> > > using the selftest in upstream kernel and having a new hardware). In
> > > this case when we get new hardware, the test will fail in the downstream
> > > kernel. We will have to wait until the fix is ready, and backport it
> > > downstream, re-test it.... It takes lots of extra work.
> > 
> > If Intel can't upstream what should be a *very* simple patch to enumerate the
> > new encoding and its expected count in advance of hardware being shipped to
> > partners, then we have bigger problems.  I don't know what level of pre-silicon
> > and FPGA-based emulation testing Intel does these days, but I wouldn't be at all
> > surprised if KVM tests are being run well before silicon arrives.
> 
> Right, Intel folks will be the 1st one that is impacted. But it should
> be easy to fix on their end. But upstreaming the change may come very
> late.

And I'm saying we do what we can to motivate upstreaming the "fix" sooner than
later.

> > I am not at all convinced that this will ever affect anyone besides the Intel
> > engineers doing early enablement, and I am definitely not convinced it will ever
> > take significant effort above beyond what would be required irrespective of what
> > approach we take.  E.g. figuring out what the expected count is might be time
> > consuming, but I don't expect updating the test to be difficult.
> 
> It will affect the downstream kernels, I think? Like Paolo mentioned,
> old distro kernel may run on new hardware. In usual cases, Intel HW has
> already come out for a while, and the upstream software update is still
> there under review.

This isn't a usual case.  Or at least, it shouldn't be.  The effort required
should be more on par with adding Family/Model/Stepping information, and Intel
is quite capable of landing those types of changes well in advance of general
availability.

E.g. commit 7beade0dd41d ("x86/cpu: Add several Intel server CPU model numbers")
added Sierra Forest and Granite Rapids two years before they launched.  I don't
know when third parties first got silicion, but I would be surprised if it was
much, if at all, before that commit.

> Fixing the problem is never difficult. But we need a minor fix for each new
> generation of HW that adds a new architecture event. I can imagine fixing
> that needs a simple patch, but each of them has to cc stable tree

Yes, but sending patches to LTS kernels isn't inherently bad.  If the changes end
up conflicting regularly, then we can certainly reconsider the cost vs. benefit
of the assert.

> and with "Fixes" tag.

Nit, it doesn't need a Fixes, just Cc: stable@.

> > > Perhaps we can just putting nr_arch_events = NR_INTEL_ARCH_EVENTS
> > > if the former is larger than or equal to the latter? So that the "test"
> > > only test what it knows. It does not test what it does not know, i.e.,
> > > it does not "assume" it knows everything. We can always a warning or
> > > info log at the moment. Then expanding the capability of the test should
> > > be added smoothly later by either maintainers of SWEs from CPU vendors
> > > without causing failures.
> > 
> > If we just "warn", we're effectively relying on a future Intel engineer to run
> > the test *and* check the logs *and* actually act on the warning.  Given that tests
> > are rarely run manually with a human pouring over the output, I highly doubt that
> > will pan out.
> 
> In reality, we may not even need to warn. If the test only covers what
> it knows, then there is no alarm to report.

The assertion/warn isn't about test correctness, it's about ensuring test coverage
and distributing maintenance burden.  I don't want to have to chase down someone
at Intel that can provide the gory details on whatever architectural event comes
along next.

