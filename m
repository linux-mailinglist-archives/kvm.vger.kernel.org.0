Return-Path: <kvm+bounces-30268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 05EBF9B8728
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 00:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 743AEB21469
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 23:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF1C1E47C3;
	Thu, 31 Oct 2024 23:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="itMjx3Zt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A21419923A
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 23:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417400; cv=none; b=AyjBZJSLZ4dox03TD94pMGBRCeUHbaHVjzHvxL4JLjexTVSR9c97GlU3dP/qEyXpTXx7qDO91SDqa8KsOu0kAUqbzr2U6Z9IZpI9yjEKovHZFhCGeCueW/KgsizGIqEMfU7G+p0jQ+NC/Uw9SPCvAROzpv5f8npbkYOazXz/Zkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417400; c=relaxed/simple;
	bh=1VCueJoW6Y3qaAC3Ke3k4tCCBclLoqT4bqgPJ2GF4Cs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tL6Nv5iXVvjJJw+CizK9IZ7l8lJHBRD1pLUmGY6HXAnEClJHjkjjoHYovSBObiNVm31colMsBNVGiE3vZ5XLVwlx7RX8XBe8Abt88Ay9SKT3vOItUgsYREsXX4rHFPxJIgHin665xv8eJ+tXdTHEQxMYn2BEcDcUHcO/cIU83J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=itMjx3Zt; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea33140094so34757607b3.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 16:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730417394; x=1731022194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+7cmHm3KCOtoSl6XET53ku1Hjn4fNo4XJ5RMlIsizQY=;
        b=itMjx3Ztgd/ucuOW9+M9rOk7LkfGAGGODOBnjgwfkY8P0PUqYa2voZvGU8ZPcw4UTL
         yIPO9E7aeJe491eKHUJLIBFT1keo5KQjPKejAU2JWOT8oEBBXHZSA9YIU1m6qdeToi7X
         SQ/YGiezENqtDCF/QB3gI8heSw2DndfaBIM3OynDHknaE7kQL1LK2fRmOCjq9U+jaSX9
         rjY2Qwlt4IB4mLBdWYEYOg3so0Xdvoi36l4sJ6frlNnqYuQpF3zqN+0lXrjHVtYR6Wbv
         SCPoz5N9qxyWJbj3tQI2II14x2sEUs0DuOUdVUfkMooSlrWpTXbvdZIpUmVTdbby4y4v
         WS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730417394; x=1731022194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+7cmHm3KCOtoSl6XET53ku1Hjn4fNo4XJ5RMlIsizQY=;
        b=Ex5eVQ+qdOPhV9yIVpMTmg7ahm1uxvp3rwjN5wZwsnuwy78nujANmj6ap9VbtVDJmt
         U2ZN9oawWPpiIQ7lORcqqR8sfEG1L6C1NsPzoQbo9CQ1diQPWSRCzqW1uHHBlqRV0bXt
         DbwF69hSWmX3ko+m7T/3/dwkZXPrAEYvFAeUazM2bnadqTNjV2++KbvNlUKdb25iiyCj
         tktw2lWIZzKplhvmLBUIhUQm85BGEu8qQ1EyWwzcl44Bd315qfB38oUElGKlCL/FP8H0
         NKIDdIVYKKJ90dVV2OVce+sGuXtQbh+Z0IAyfGupg7Cne2v7N+PgK6ePDJGk/kjj3o/6
         J32Q==
X-Gm-Message-State: AOJu0Yzvyy+FaivL+toHHNrFKTbNzyW7XC7GcVP2EOxAJhd5fXNmhWW5
	DHl2eZ/2zet6YHPgl/WLf1s5BJNONmA6IICoSS/9TA3YTMY5V+Tuh/YiO37YB/AB5LQdn8dBqiC
	jIQ==
X-Google-Smtp-Source: AGHT+IH6SxVSBOtTMkDyIlVvRhRjofo38/XFpDF2KgCtKUck/hxEI/3CHxi6gl4ZLF1CRsKFGlXG1C0G144=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:aa12:0:b0:e30:cdd0:fc14 with SMTP id
 3f1490d57ef6-e30e5b44ba2mr2370276.9.1730417393985; Thu, 31 Oct 2024 16:29:53
 -0700 (PDT)
Date: Thu, 31 Oct 2024 16:29:52 -0700
In-Reply-To: <ZyPjwW55n0JHg0pu@mias.mediconcil.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241018100919.33814-1-bk@alpico.io> <Zxfhy9uifey4wShq@google.com>
 <Zxf4FeRtA3xzdZG3@mias.mediconcil.de> <ZyOvPYHrpgPbxUtX@google.com> <ZyPjwW55n0JHg0pu@mias.mediconcil.de>
Message-ID: <ZyQS8AhrBFS6nZuq@google.com>
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Bernhard Kauer wrote:
> > > > In practice, this almost never happens though.  Do you have a use case for
> > > > creating VMs without in-kernel local APICs?
> > >
> > > I switched from "full irqchip" to "no irqchip" due to a significant
> > > performance gain
> >
> > Signifcant performance gain for what path?  I'm genuinely curious.
> 
> I have this really slow PREEMPT_RT kernel (Debian 6.11.4-rt-amd64).
> The hello-world benchmark takes on average 100ms.  With IRQCHIP it goes
> up to 220ms.  An strace gives 83ms for the extra ioctl:
> 
>         ioctl(4, KVM_CREATE_IRQCHIP, 0)         = 0 <0.083242>
> 
> My current theory is that RCU takes ages on this kernel.  And creating an
> IOAPIC uses SRCU to synchronize the bus array...
> 
> However, in my latest benchmark runs the overhead for IRQCHIP is down to 15
> microseconds.  So no big deal anymore.

Assuming you're running a recent kernel, that's likely thanks to commit
fbe4a7e881d4 ("KVM: Setup empty IRQ routing when creating a VM").

> > Unless your VM doesn't need a timer and doesn't need interrupts of
> > any kind, emulating the local APIC in userspace is going to be much
> > less performant.
> 
> Do you have any performance numbers?

Heh, nope.  I actually tried to grab some, mostly out of curiosity again, but
recent (last few years) versions of QEMU don't even support a userspace APIC.

A single EOI is a great example though.  On a remotely modern CPU, an in-kernel
APIC allows KVM to enable hardware acceleration so that the EOI is virtualized by
hardware, i.e. doesn't take a VM-Exit and so the latency is basically the same as
a native EOI (tens of cycles, maybe less).

With a userspace APIC, the roundtrip to userspace to emulate the EOI is measured
in tens of thousands of cycles.  IIRC, last I played around with userspace exits
the average turnaround time was ~50k cycles.

