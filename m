Return-Path: <kvm+bounces-39588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 127F5A481C0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44E313A2911
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5711E23BF9E;
	Thu, 27 Feb 2025 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="35xqrGF4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211ED238146
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740667187; cv=none; b=AtZKBOWWFx/H6A3FARNSn1HF9tPFKGV3V42mlWMtd3hzMialcYWULGqv4VR6UYtqhGfN/ISDJ6BMkIuiGIeST7skYYeF3T32/lHAznUsNp0FU655G7GAa2AIdW3CWhAY7cDINiStsHbu+lrLOQ75Qzn83P6NEpIsA98ZFHboyv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740667187; c=relaxed/simple;
	bh=C42kb8jZYl09xjQISSvxQc2ob3/FWGQuxy1rlAyDRgo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iHec+10IagdcPG8ua84qvVxXUsWJP3/MGlkqGJ+C/PKujHJdmCmpVRl6lG3e+ELtBmRmJXv17rxCOOQnX+C8Srh5cFWg2Ihg5PF18HtctudFNJtO/ri4XU4ehax5gaRE1U+aFNEWJ05bCtc+hIkW8iWDLrt5SAWo2i2kIsJ+L+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=35xqrGF4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe8fa38f6eso2266888a91.2
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 06:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740667185; x=1741271985; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BxH+On3rOFzz2SdFAE8SEry5Nrx+QsPGCIQtGhiP8po=;
        b=35xqrGF4JmSollVj8v6VmwqKWC2sC13040OWTzu9qYwqilPSaXQskv8CH9KBEps29X
         Mp/SYRuA7KwzesRDzAE8J8WQTU3BzFQMsYYcB7P8mc05fNZ/VN4W0iRBhW7FUuAm8QLi
         QKyPXqEGpZ8PaMWJ9jDraoHndvKrMmsYyIjrNqbaUmI7hLjNrv178C8obyq2P7D25U/3
         /5C9x8BIWWpuDUgV5LzJ/bQ0bV5EafJQ9SMg2ku0hNF6Isdttq2Buc9xL67glaeBtf3Q
         39uR8m59WdglqMr2AIlUPJWk/O/U1DRM0estyqLyuH7LRjARQnoB6Yh1q1XHN1Md27DU
         6Vcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740667185; x=1741271985;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BxH+On3rOFzz2SdFAE8SEry5Nrx+QsPGCIQtGhiP8po=;
        b=u0e0KuRA0i4xzqAk67n7oU2RzHke5akQzaIR/i/qpVhdKuAl+4SCO6p5mJu5jGMl85
         D63v8DpEb3KAmCCu3LSkz9Neuttk+vxprQVxCwNblgqp46ZqKpWPgN9RIdcUCU1xRaMt
         EOVrcqze4F+d6VduhOLPK5r+k3UMWUaVYetRtr2JxntyvhPRei3HwmPX7U3yD84UaB4c
         xIDhE954JWsxkN6Yiobnq0NM3i62JWbXdf07rHfOxkLYj+c7yaV11qZ2Xiq2h0cRiGws
         qqOdDU6YNRIuKIvTOkNfqR4F7qKnCNfQeVLRFYlDh6TF7r1HQI/TmooQus4PuVqY+O5j
         LnDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXXs8Bb0zH0VpCtSoLDI6LvOxbKnMTyxAt0JJ1LQo5xMQqaHOu2uFN4l02Q/Q00l+/fZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YySN+he1DzbS/F0Cb/dBMLV12jDNvLN7/5T77MRbt1Jls0jFvHO
	B0wLsGU4yAOcqN5CtPUTiwNZNe/UEv1svHYFjtpJRw207qNCJzCAsa+uunT9buNCHwx7kFzAlJs
	drQ==
X-Google-Smtp-Source: AGHT+IFJ3wN5DANqSer5hQVwE1SxZTBD0Lvfi1B1zqpxom5zbstWSZgZeTQEsaQZtulu7UPNR3qjkDRor8w=
X-Received: from pjbsh16.prod.google.com ([2002:a17:90b:5250:b0:2fb:fa62:d40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5407:b0:2ee:c91a:ad05
 with SMTP id 98e67ed59e1d1-2fe68ac9087mr16599772a91.3.1740667185442; Thu, 27
 Feb 2025 06:39:45 -0800 (PST)
Date: Thu, 27 Feb 2025 06:39:44 -0800
In-Reply-To: <f114eb3a8a21e1cd1a120db32258340504464458.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218202618.567363-1-sieberf@amazon.com> <Z755r4S_7BLbHlWa@google.com>
 <e8cd99b4c4f93a581203449db9caee29b9751373.camel@amazon.com>
 <Z7-A76KjcYB8HAP8@google.com> <f114eb3a8a21e1cd1a120db32258340504464458.camel@amazon.com>
Message-ID: <Z8B5MMCzBGwkTT0X@google.com>
Subject: Re: [RFC PATCH 0/3] kvm,sched: Add gtime halted
From: Sean Christopherson <seanjc@google.com>
To: Fernand Sieber <sieberf@amazon.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 27, 2025, Fernand Sieber wrote:
> On Wed, 2025-02-26 at 13:00 -0800, Sean Christopherson wrote:
> > On Wed, Feb 26, 2025, Fernand Sieber wrote:
> > > On Tue, 2025-02-25 at 18:17 -0800, Sean Christopherson wrote:
> > > > And if you're running vCPUs on tickless CPUs, and you're doing
> > > > HLT/MWAIT passthrough, *and* you want to schedule other tasks on those
> > > > CPUs, then IMO you're abusing all of those things and it's not KVM's
> > > > problem to solve, especially now that sched_ext is a thing.
> > > 
> > > We are running vCPUs with ticks, the rest of your observations are
> > > correct.
> > 
> > If there's a host tick, why do you need KVM's help to make scheduling
> > decisions?  It sounds like what you want is a scheduler that is primarily
> > driven by MPERF (and APERF?), and sched_tick() => arch_scale_freq_tick()
> > already knows about MPERF.
> 
> Having the measure around VM enter/exit makes it easy to attribute the
> unhalted cycles to a specific task (vCPU), which solves both our use
> cases of VM metrics and scheduling. That said we may be able to avoid
> it and achieve the same results.
> 
> i.e
> * the VM metrics use case can be solved by using /proc/cpuinfo from
> userspace.
> * for the scheduling use case, the tick based sampling of MPERF means
> we could potentially introduce a correcting factor on PELT accounting
> of pinned vCPU tasks based on its value (similar to what I do in the
> last patch of the series).
> 
> The combination of these would remove the requirement of adding any
> logic around VM entrer/exit to support our use cases.
> 
> I'm happy to prototype that if we think it's going in the right
> direction?

That's mostly a question for the scheduler folks.  That said, from a KVM perspective,
sampling MPERF around entry/exit for scheduling purposes is a non-starter.

