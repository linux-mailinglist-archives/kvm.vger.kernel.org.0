Return-Path: <kvm+bounces-48228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA67ACBDB2
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2B3116E1C1
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 23:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30AB2522BE;
	Mon,  2 Jun 2025 23:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nVCICnCS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6206A13C8EA
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 23:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748907016; cv=none; b=kHAFi/sJEuq9gnJSwasSF8kc03ejXuZK68so7nvCmmgM6+Ubezwr1Mb+T63yBcpL4qQfLJXzl6shJnQiEp0Tpn3vkBSCpX7qJNvga88k60/+28jmIAcbHllq3ldVLyqoZlsBrWQBZn21CNsYtAbZ5K6b1D2wbQ4la4YLNxWXBV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748907016; c=relaxed/simple;
	bh=ERPVRkIbILIUcIjfV+EhBnHrMs9fZ3Q4qRlPwExSKOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UwBSWFw9qaw0iuyd5e6Ck8/4sPQ9rZo7n5LA3W1x0naAy1HuMEukIzPOuXZTDiIywkm4Ga9PAjF+IZkFKRue/D6k0pKgUrMcHeTgKm4zG4hncN2foigBjmf14lxewOvtAImuu5qqj5Dj6KfMdOJSYHOuZ3D35WDdF66Fam7WTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nVCICnCS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234fedd3e51so45112445ad.1
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 16:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748907014; x=1749511814; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yve1ZiL8T7g84JmBt/tikyI/6Bv4C2Bg0e+B1xxTdfo=;
        b=nVCICnCSv8PFaqj6xzacChw/19sZEJ9ICfvHD/3vvqcx8uhcJXX1e5ZVebDJB+EiPn
         LPJQmdVcpPklwAc8muYkO/XrGAMb+LlXlkeo+HzRGIl+MXi2azyCjA6RUecTv39xQOyi
         1cL/JCbAZF7m12ei7fq2u+3CQFjZ33YveYTlHnrhvOJe1K+mNKuxWra0NiCnE74p1rI/
         UIkO7nwGfKjYy3Fl9LTm8G0Z6oG2i+jryuGjW4yCNInKtddTnYxWKJCWvlYs8XA+0QnG
         Y425XJ5/wl/mfyJoJjj+hvZANLCUV0FyJE5sx6lGCWSLtOhtXo5sdhTVotw0qt7Giat9
         3qsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748907014; x=1749511814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yve1ZiL8T7g84JmBt/tikyI/6Bv4C2Bg0e+B1xxTdfo=;
        b=Oj+ET1O1hmIMIXF/OR0Zde8oEn0r85t+jI7rpj2ALMuH9lwnuRSXJ6CqcpevHhzbWi
         g4tRGziYfptrgKvJZBxnJjCf5GE9sn9a+uzGKcB3dedbCbbd+uEr3HO2XZt5qPfAWO9x
         JY00PZ2DfxQUzAs50LjPlogabJn5ufd3bUXr2oYBlh0QWv12tRfuSZE6/LVOPO2gaOk7
         J44JXF099dldByMwOGoHGoBgycWGf413VL13RJGn1Azt5skUBqhtsFpim2jkKEpF/26f
         gJcyEkJmYtmmakLHmLdaRj49MIALw4ZgzS5zoV5poirIlyPWeZf+z2L8pOjjWnfs852W
         r1ng==
X-Forwarded-Encrypted: i=1; AJvYcCVu4Gb1ZZtymD/2LxOkKsZjRh8lib+WJLgkCSzNnUVSBE5D84wi07boSVh6WNVCVlMXBNY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHALZIeGFPFh2/W4hwx/X8Aedo3Tk1KkQSoT/NcfUbCZtY40Li
	ruYwIuop9Dyp1smH0HEEftiRx0f5nk67jUy35B/N/QGJxVT1Wc2Tp8ULmq/y1JodQmZRPmSS+iy
	D5lcnAQ==
X-Google-Smtp-Source: AGHT+IE14BFeGM0J7uhuk33V5fPG5r1MtBBSniKvSePrbW7/nzVp1S6VXU7zoEWKiW8wpnHDPojK7VzfMl4=
X-Received: from pjur7.prod.google.com ([2002:a17:90a:d407:b0:311:ea2a:3919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f4d:b0:312:1cd7:b337
 with SMTP id 98e67ed59e1d1-3125034a47amr19482649a91.5.1748907013702; Mon, 02
 Jun 2025 16:30:13 -0700 (PDT)
Date: Mon, 2 Jun 2025 16:30:12 -0700
In-Reply-To: <20250602125442.19d41098.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com> <20250602125442.19d41098.alex.williamson@redhat.com>
Message-ID: <aD40BIYA1ecnbX73@google.com>
Subject: Re: [PATCH v2 0/8] irqbypass: Cleanups and a perf improvement
From: Sean Christopherson <seanjc@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 02, 2025, Alex Williamson wrote:
> On Fri, 16 May 2025 16:07:26 -0700
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > The two primary goals of this series are to make the irqbypass concept
> > easier to understand, and to address the terrible performance that can
> > result from using a list to track connections.
> > 
> > For the first goal, track the producer/consumer "tokens" as eventfd context
> > pointers instead of opaque "void *".  Supporting arbitrary token types was
> > dead infrastructure when it was added 10 years ago, and nothing has changed
> > since.  Taking an opaque token makes a very simple concept (device signals
> > eventfd; KVM listens to eventfd) unnecessarily difficult to understand.
> > 
> > Burying that simple behind a layer of obfuscation also makes the overall
> > code more brittle, as callers can pass in literally anything. I.e. passing
> > in a token that will never be paired would go unnoticed.
> > 
> > For the performance issue, use an xarray.  I'm definitely not wedded to an
> > xarray, but IMO it doesn't add meaningful complexity (even requires less
> > code), and pretty much Just Works.  Like tried this a while back[1], but
> > the implementation had undesirable behavior changes and stalled out.
> > 
> > Note, I want to do more aggressive cleanups of irqbypass at some point,
> > e.g. not reporting an error to userspace if connect() fails is awful
> > behavior for environments that want/need irqbypass to always work.  And
> > KVM shold probably have a KVM_IRQFD_FLAG_NO_IRQBYPASS if a VM is never going
> > to use device posted interrupts.  But those are future problems.
> > 
> > v2:
> >  - Collect reviews. [Kevin, Michael]
> >  - Track the pointer as "struct eventfd_ctx *eventfd" instead of "void *token".
> >    [Alex]
> >  - Fix typos and stale comments. [Kevin, Binbin]
> >  - Use "trigger" instead of the null token/eventfd pointer on failure in
> >    vfio_msi_set_vector_signal(). [Kevin]
> >  - Drop a redundant "tmp == consumer" check from patch 3. [Kevin]
> >  - Require producers to pass in the line IRQ number.
> > 
> > v1: https://lore.kernel.org/all/20250404211449.1443336-1-seanjc@google.com
> > 
> > [1] https://lore.kernel.org/all/20230801115646.33990-1-likexu@tencent.com
> > [2] https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com
> > 
> > Sean Christopherson (8):
> >   irqbypass: Drop pointless and misleading THIS_MODULE get/put
> >   irqbypass: Drop superfluous might_sleep() annotations
> >   irqbypass: Take ownership of producer/consumer token tracking
> >   irqbypass: Explicitly track producer and consumer bindings
> >   irqbypass: Use paired consumer/producer to disconnect during
> >     unregister
> >   irqbypass: Use guard(mutex) in lieu of manual lock+unlock
> >   irqbypass: Use xarray to track producers and consumers
> >   irqbypass: Require producers to pass in Linux IRQ number during
> >     registration
> > 
> >  arch/x86/kvm/x86.c                |   4 +-
> >  drivers/vfio/pci/vfio_pci_intrs.c |  10 +-
> >  drivers/vhost/vdpa.c              |  10 +-
> >  include/linux/irqbypass.h         |  46 ++++----
> >  virt/kvm/eventfd.c                |   7 +-
> >  virt/lib/irqbypass.c              | 190 +++++++++++-------------------
> >  6 files changed, 107 insertions(+), 160 deletions(-)
> > 
> > 
> > base-commit: 7ef51a41466bc846ad794d505e2e34ff97157f7f
> 
> Sorry for the delay.

Heh, no worries.  ~2 weeks is downright prompt by my standards ;-)

> Do you intend to take this through your trees?

Yes, ideally, it would go into Paolo's kvm/next sooner than later (I'll start
poking him if necessary).  The s/token/eventfd rename creates an annoying conflict
in kvm/x86.c with an in-flight patch (significant code movement between files).
It would be nice to be able to rebase the in-flight patch instead of having to
resolve a merge confict (the conflict itself isn't difficult to resolve, I just
find it hard to visually review/audit the resolution due to the code movement).

