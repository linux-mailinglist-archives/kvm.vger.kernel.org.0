Return-Path: <kvm+bounces-43099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61ED1A84B02
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 19:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548811B874AB
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 17:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F0628C5D0;
	Thu, 10 Apr 2025 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wj4aK967"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60741EF397
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744306191; cv=none; b=kjJt96A9aZcyxLstanUPsLHlDNU8jFMEN8fTwEEgkolrK4NhNbBaIZ/ESJwgO4+K1DHsrgHYun4+qCecsQ2P2dZAoO/KFQssLKA+g8j916FUB82ke7dlR699xna4VFm7OYVHY10hBMTNMEYKj1Z4nAVjDjQQf+TDQMeiQ0B/7dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744306191; c=relaxed/simple;
	bh=8RGWQcgCimLPvpiAlk+5F2R9ep2gNgiJpKOuy3wGtDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pX2MAPFzqZVDlVVhw3cJ6i8Th3rOl/Iwuy8/Hklh7C80NMPwqSeN2I2WOGnZJeMuLnmiwjJ8jsBHVRjcgCFnHY7QHIoP0r1PQXLvFylLotm83SxLfV1JvyLiSz83+DHjTSL4txEUBJJwoRvCbDpi0wgWzecYBPEILm6SB+7uKcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wj4aK967; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73009f59215so1187729b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744306189; x=1744910989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=THh7USP0TMmHVXYAIYVxQL6srWNoxeq+S60T+Iuc4Go=;
        b=wj4aK9678it8BCAa+8f0A9aZxmuyaW+GbO0T1Giv+DEkRSTVTVxNzEXrCwT640/8hH
         dM2nCDYpTjZjCCzsbkqnCBV7NLqTqwXUIhIqomh3I71Ha1b74Gw47UVlFdZje0Dy5CxU
         PMzh+2+Y3Z4O34luUXJcqWfczc+9hl+7Dr98Z0dq2sWkES6qXPAPNdfAxJ/upufOUcSZ
         sPEgwsd3A9r2U9dE1BcI7wLiiPlLIFUgNfd2MxIsBTzBlhvp/OWeiHLI/g6hxjvJUEV2
         0CGPn9i0LC4UtIZe1JX060cbCWqsjZdRuFIQ9dVirjD7AsmxFhtwfFupMgVAa+fzrYY7
         Uf5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744306189; x=1744910989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=THh7USP0TMmHVXYAIYVxQL6srWNoxeq+S60T+Iuc4Go=;
        b=keDZ99/gdtZqvFdTNzblRyF8gXXGaO/AL0+qpStFSTMVL7ENowrgMkZUOsdimI8ZW0
         dcm9GNb0X8kWZhn6GjGq81swO5V+o1DJeVIuDnDRAS4UMAFQzvLUF2I/xLM6tklVgYEI
         I/4TtwVQsnH8pbWdjNjiUpwFaPJXrz6M7vtl7BgbQX585RI+A1iozh0bVLAYoGpIKhTY
         gRAcoITcsLvbvVempm+B6xBw1Cmkm/IO6lEIweo01cf30ryOWT8resa0BAjuzYzFmvnX
         srVKnbFa3wMGLFdmNCwuWmmlztQRI9p8Ii38RsDzpMuN6rH8eG8281l6VnCrw9wRajsD
         DWfA==
X-Gm-Message-State: AOJu0YzC0cO8sw9SgbkaH/TM6EREhGOG/P62PtmhCZJSvA3qvSq/MBLz
	DbG319wSQgHgb7mG02UlirmjiKfa0DnE2XS7AAzBDtBrSOjm3HZ5WQYXcsFtd+2SltceKQmO9EH
	CUQ==
X-Google-Smtp-Source: AGHT+IEzEm4pFNJ9RE2IrAYwwiomzZvMX+btxSqy0ddwSL3trJyRQq2fiWUm5uHQQn8B4/4qgmhNau+bVpY=
X-Received: from pfbcw22.prod.google.com ([2002:a05:6a00:4516:b0:736:79d0:fd28])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:891:b0:736:34ca:dee2
 with SMTP id d2e1a72fcca58-73bc0a15157mr4684403b3a.4.1744306189171; Thu, 10
 Apr 2025 10:29:49 -0700 (PDT)
Date: Thu, 10 Apr 2025 10:29:47 -0700
In-Reply-To: <bba773d0-1ef9-4c9f-8728-9cf0888033ad@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-65-seanjc@google.com>
 <9b7ceea3-8c47-4383-ad9c-1a9bbdc9044a@oracle.com> <Z_fnrP4e77mKjdX9@google.com>
 <bba773d0-1ef9-4c9f-8728-9cf0888033ad@oracle.com>
Message-ID: <Z_gAC9DLG-q9poGV@google.com>
Subject: Re: [PATCH 64/67] iommu/amd: KVM: SVM: Allow KVM to control need for
 GA log interrupts
From: Sean Christopherson <seanjc@google.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, David Matlack <dmatlack@google.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 10, 2025, Joao Martins wrote:
> On 10/04/2025 16:45, Sean Christopherson wrote:
> > On Wed, Apr 09, 2025, Joao Martins wrote:
> >> On 04/04/2025 20:39, Sean Christopherson wrote:
> >> I would suggest holding off on this and the next one, while progressing with
> >> the rest of the series.
> > 
> > Agreed, though I think there's a "pure win" alternative that can be safely
> > implemented (but it definitely should be done separately).
> > 
> > If HLT-exiting is disabled for the VM, and the VM doesn't have access to the
> > various paravirtual features that can put it into a synthetic HLT state (PV async
> > #PF and/or Xen support), then I'm pretty sure GALogIntr can be disabled entirely,
> > i.e. disabled during the initial irq_set_vcpu_affinity() and never enabled.  KVM
> > doesn't emulate HLT via its full emulator for AMD (just non-unrestricted Intel
> > guests), so I'm pretty sure there would be no need for KVM to ever wake a vCPU in
> > response to a device interrupt.
> > 
> 
> Done via IRQ affinity changes already a significant portion of the IRTE and it's
> already on a slowpath that performs an invalidation, so via
> irq_set_vcpu_affinity is definitely safe.
> 
> But even with HLT exits disabled; there's still preemption though?

Even with involuntary preemption (which would be nonsensical to pair with HLT
passthrough), KVM doesn't rely on the GALogIntr to schedule in the vCPU task.

The _only_ use of the notification is to wake the task and make it runnable.  If
the vCPU task is already runnable, when and where the task is run is fully
controlled by the scheduler (and/or userspace).

> But I guess that's a bit more rare if it's conditional to HLT exiting being
> enabled or not, and whether there's only a single task running.

