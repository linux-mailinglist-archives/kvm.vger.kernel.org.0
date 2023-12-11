Return-Path: <kvm+bounces-4116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9476180DEB0
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 23:57:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 452BE1F21AD2
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 22:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671DA5644C;
	Mon, 11 Dec 2023 22:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jQbXGPOb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F21CF
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 14:57:03 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5e03f0ede64so20336767b3.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 14:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702335422; x=1702940222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLiTtRRqM+qNBV6tYcuiNPBMTUo4FdzTRXinHk4XXSY=;
        b=jQbXGPOb4aUz9h/DCAaYw7yu4FgckKWiK+UtCid96tFmLgd1DsXM1Nlg70/QJAgWsg
         dMahWtxfn21P0gLevEhrT4stbX+G9LgIJb2xHzz65KsFXxG4LoNvMy4psC8j2UNmT4fj
         pDpbB8+2zOwEUWd4UbKgezZ3mIoTUJzY1QpoCyVK3nxn0HgmAoIfcVCFvIVHy9wWJT1+
         8qOL94SzQGnpyi+G8/RZZnUc/1DtscA5UgcHiyy5RZYsurcyfPlxW5UfrTwLEycq2zTL
         /0ZrNfsidk4ihm5yEwsYfoFAmsgaFUIokvfc5mLHHoWeIuIlUf27vK0h/eR7iFdLbIy8
         Ip+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702335422; x=1702940222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XLiTtRRqM+qNBV6tYcuiNPBMTUo4FdzTRXinHk4XXSY=;
        b=hD5vDAVTItwu7AV8qhyM9jEP28GyeFfK3EWg/E01OECLkLISxylcIdpAdqIbVtVonv
         k7OFHzkao1iXseZLSrE86F0HFV1N37eS5fntCes7IiznRcc5mHXAxxEWU3aj5isIS3m2
         3aeT1ZvBrvFU0W51t2j5pDMXFlDZUuLxixWrr023U1OdrJ7N9QLo9jsUL7PM9f6OOS+t
         +cV8KmPZ8q3jcE/nKB0o4a9YOU3IsrcsioCkzxqyL4Yo8C7a+6ElJdn2Gub9giKnnRnl
         tAMzewr0lzXem6SE01PcfixqLWWjsrfMIeTPidicZG6OdCv8nq0t12AHuoGvow7vgsvT
         7lPg==
X-Gm-Message-State: AOJu0YzdzUr1RSStHANqhv+3A+tnWb+APGPGiOP1zqPD16YOLR7/fJa/
	voYKeSql6t+5rjyDqaok5M7vixTqnOg=
X-Google-Smtp-Source: AGHT+IEhhypj7D/PwqeFaL95W7v5NUceMg/HzzkyowCvBZn3QIeqdswnpmg0GcBg4W9bI7RZryt2AT+W5iM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c01:b0:5d1:104a:acb5 with SMTP id
 cl1-20020a05690c0c0100b005d1104aacb5mr53522ywb.2.1702335422457; Mon, 11 Dec
 2023 14:57:02 -0800 (PST)
Date: Mon, 11 Dec 2023 14:57:00 -0800
In-Reply-To: <865y16b6cf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
 <SYBPR01MB6870FDFBB88F879C735198F39D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
 <865y16b6cf.wl-maz@kernel.org>
Message-ID: <ZXeTvCLURmwzpDkP@google.com>
Subject: Re: [PATCH v3 1/5] KVM: Add arch specific interfaces for sampling
 guest callchains
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Tianyi Liu <i.pear@outlook.com>, pbonzini@redhat.com, peterz@infradead.org, 
	mingo@redhat.com, acme@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	mark.rutland@arm.com, mlevitsk@redhat.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, namhyung@kernel.org, irogers@google.com, 
	adrian.hunter@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Dec 10, 2023, Marc Zyngier wrote:
> On Sun, 10 Dec 2023 08:12:18 +0000, Tianyi Liu <i.pear@outlook.com> wrote:
> > +bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, gva_t addr, void *dest, unsigned int length)
> > +{
> > +	/* TODO: implement */
> > +	return false;
> > +}
> 
> I don't do it very often, but the only thing I can say about this is
> *NAK*.
> 
> You have decided to ignore the previous review comments, which is your
> prerogative. However, I absolutely refuse to add half baked and
> *dangerous* stuff to the arm64's version of KVM.
> 
> If you can convince the x86 folks that they absolutely want this, fine
> by me. But this need to be a buy-in interface, not something that is
> required for each and every architecture to have stubs, wrongly
> suggesting that extra work is needed.
> 
> For arm64, the way to go is to have this in userspace. Which is both
> easy to implement and safe. And until we have such a userspace
> implementation as a baseline, I will not consider a kernel
> version.

I too want more justification of why this needs to be handled in the kernel[*].
The usefulness of this is dubious for many modern setups/workloads, and outright
undesirable for some, e.g. many (most?) cloud providers want to make it all but
impossible to access customer data.

[*] https://lore.kernel.org/all/ZSlNsn-f1j2bB8pW@FVFF77S0Q05N.cambridge.arm.com

