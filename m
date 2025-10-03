Return-Path: <kvm+bounces-59451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA2BBB5B2C
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 03:02:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A41C04A7E14
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 01:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243FB199230;
	Fri,  3 Oct 2025 01:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W9iT2T0w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACA310F1
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 01:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759453335; cv=none; b=RVn1nq0F9NRwmPVl0ssoLMp6/ym4EblQy8gnpEsP3Kfapr18j/c0ED9X4xUCZhL60dhyi/fYC8m1rT9XHqKpu/QvVgGLW7UzhRG6NGWl+jXFyodYwXXoNhb0karMgyzNEsRwjhqlDl79GHDs4FEfrj6t+M5H2OeewxaRKW3X7eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759453335; c=relaxed/simple;
	bh=jqE3376I8gSsa7WU72LhrXs1ZvXwcQ0QX2XY+V7sWTE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=geRmhkdOIwG8XCfw3xj4HyabeR1OP+R5Ox465AcMck7mks1VMmuFLUvsMg3dPn8DM6gssUmDYGE7Xqi5W3vns3Od8EqVvf654sD4c1E+vvbZProkYaQgr195jcvAuxwkNSmGBxPk+yu6ECNme2Jjh02kZC8+1NTwIdexAq8t+Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W9iT2T0w; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec67fcb88so1400629a91.3
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 18:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759453329; x=1760058129; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Jhsi/hyS7a38NhT2Hqz3OM4Bzlch84UkK/Xe3cm3J0=;
        b=W9iT2T0wqnQSYozo/MOXPSpjbvncZU2ciRXiqkTU4o7YJTboYhvINuQe9G0So7R5of
         a+ujBonqD+aLYYX7qxqngrHtjE9c9Dk+eTLj7AYXtSR27WvYjH0vsJTVGtH1fnbyxrjn
         9ybxHEgpGORtax5JatQb9C4Kg+9CNV280Hrc+mmL0XIsjOnbbv/uYK934vgvOC0pXQPx
         07S7AI66PxWU9wUef5BQXZIAreeG8OtHX+9PGoAIWKtP6iBbq7iIDhgWA78mWitMdBG5
         /MmwSz7LZb8KRXq3w03jGTA9ouzEqb3gzqwxx8eXxEeVDp+ZE9/Nq2tyab7NqE7S0GvR
         t3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759453329; x=1760058129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Jhsi/hyS7a38NhT2Hqz3OM4Bzlch84UkK/Xe3cm3J0=;
        b=MvTOZ5AVGoGp2uh8hgnd701jQIonB8XwSmOm22wMXlqPIZeGP0hpwH+hZF5mfER+Om
         IGV2upMXSlYXFxjT5kRQnXjbhNBIDhOxVRIs9mHqWAZC5Z3Qt7lP7MUAjQrhP3f404Ng
         +XeJkVk7xUj2eSiBRT0kZwd3PYU5+KI6xsLqml0RAAlDEBxr2cJFoQRZM0xnNhWyA5BY
         4q5Ghay4N1eDCSSHvxyRyratwiOm8WSli4F6GmXCeX7RN4vWB/3SApEXiqF5uzJnavT5
         6S41OG8SnPeTLLM19WI8W9cq23Jwfg6IjRWsRh9aH5sTx4U5Nj6BKrn+5/AffH6Oy3oY
         PR5g==
X-Forwarded-Encrypted: i=1; AJvYcCW4zZJvED0ExycH/rpk3p1ypiMCRYxtWasgBsfvikls6StMOdPP6sNarpTARt4WzPGuC0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnP8xxwCUDQ+SGC+GpgbMRYcBhHMpfOzKbIYAQkrdMvZh7XLco
	acC7Xl52EZ0kXkYr/sB0RdpOpUBVEHYXNVcUCs+KElBAFd0+U6k6mBjFpRfV2pHgNXs8Pabpc8O
	gCggUXw==
X-Google-Smtp-Source: AGHT+IFwurIZ5wEQactgz/Wb47f7lyl+S//nCwqNIeLCXTOqPn/FvG0AeALewYCWSg5yph5QxPM5itarytY=
X-Received: from pjpo10.prod.google.com ([2002:a17:90a:9f8a:b0:32e:a3c3:df27])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a91:b0:32e:c6b6:956b
 with SMTP id 98e67ed59e1d1-339c2765e06mr1319063a91.4.1759453329295; Thu, 02
 Oct 2025 18:02:09 -0700 (PDT)
Date: Thu, 2 Oct 2025 18:02:08 -0700
In-Reply-To: <86a529z7qh.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com> <20250930163635.4035866-10-vipinsh@google.com>
 <86qzvnypsp.wl-maz@kernel.org> <20251001173225.GA420255.vipinsh@google.com> <86a529z7qh.wl-maz@kernel.org>
Message-ID: <aN8gkEMHuvIVPcCt@google.com>
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 02, 2025, Marc Zyngier wrote:
> On Wed, 01 Oct 2025 18:32:25 +0100,
> > One can run these non-default tests as (assuming current directory is
> > kvm selftests):
> > 
> >   python3 runner -d ./tests
> > 
> > Over the time we will add more of these non-default interesting
> > testcases. One can then run:
> > 
> >   python3 runner -d ./tests ./testcases_default_gen
> 
> That's not what I am complaining about. What you call "configuration"
> seems to just be "random set of parameters for a random test".

Hopefully s/random/interesting, but yes, the design of the runner is specifically
to support running tests with different parameters, and not much more (from a
configuration perspective).

> In practice, your runner does not seem configurable at all. You just
> treat all possible configurations of a single test as different tests.
> 
> My (admittedly very personal) view of what a configuration should be
> is "run this single test with these parameters varying in these
> ranges, for this long".

Ya, but personal preference is precisely why we kept the runner fairly minimal.
The goal is to provide:

 1. A way to upstream non-standard test invocations so that they can be shared
    with others, and to improve the coverage provided when developers just run
    whatever tests are upstream (which probably covers most contributions?).

 2. Provide "basic" functionality so that each developer doesn't have to reinvent
    the wheel.

    E.g. I have a (horrific) bash script to run selftests in parallel, and while
    it works well enough for my purposes, it's far from perfect, e.g. there's no
    timeouts, it's super hard to see what tests are still running, the logging is
    hacky, etc.
 
    The idea with this runner is to deal with those low-level details that are
    painful to implement from scratch, and that generally don't require foisting
    a highly opinionated view on anyone.  E.g. if someone really doesn't want to
    see certain output, or wants to fully serialize tests, it's easy to do so.
   
 3. Tooling that power users (and hoepfully CI?) can build on, e.g. via wrapper
    scripts, or something even fancier, again without having to be too opinionated.

    E.g. thanks to the myraid module params in x86, I run all selftests with 5-6
    different versions of KVM (by unloading and reloading KVM modules).  We
    deliberately chose not to allow specifying module params of sysfs knobs as
    part of the runner, because:

        (a) Handling system-wide changes in a runner gets nasty because of the
            need to express and track dependencies/conflicts.
        (b) It's easy (or should be easy) to query dependencies in selftests.
        (c) Selftests need to query them anyways, e.g. to avoid failure when
            run with a "bad configuration".
        (d) Permuting on system-wide things outside of the runner isn't terribly
            difficult (and often requires elevated privileges).

So yeah, there are definitely limitations, but for the most part they are self-
imposed.  Partly to avoid boiling the ocean in the initial version (e.g. many
tests won't benefit from running with a range of values/parameters), but also so
that we don't end up in a situation where the runner only suits the needs of a
few people, e.g. because it's too opinionated and/or tailored to certain use cases.

I'm definitely not against providing more functionality/flexibility in the future,
but for a first go I'd like to stick to a relatively minimal implementation.

