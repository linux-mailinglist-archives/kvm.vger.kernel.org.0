Return-Path: <kvm+bounces-8446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C604384F909
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9D182902A1
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 16:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC49762E1;
	Fri,  9 Feb 2024 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wvdBaQRI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7A76047
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707494478; cv=none; b=IXdR2J0pkUtOQGdjSEEUIDoRh9s7Ohrn28QOWaNp2eHu0DmDKDXltu+YQoRRVHburYUTpi7nDHRuE8clf44wJ+a3reiw9hkDlP8fHO3slrvGsgP3j/ZrNUm9P9TVgSCtuEWPW0pspS+wk+7Gxzjt0SX1X6X26Ta/CMkMZK+yT0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707494478; c=relaxed/simple;
	bh=sZbVkNtpn1w0i1ViEpr+FIeqIBQSGHtq8nwGuW84VGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LxuIhMpgXEIyzOYyP0545vG344ABF/EA/fPeSwrvKtLQpwMby4NLnosnybHm2xiPsJ9YXuAp+uSu0TYSq1wXnPThgMU4POj1YWSsUR0LbMNEI54+8LBt6Rt8AB5GUq4LRfx3sGtcddjsioiSEA8ytshyj3bxfXeZZSA5yVwzXpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wvdBaQRI; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3bda4bd14e2so754147b6e.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 08:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707494476; x=1708099276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZbVkNtpn1w0i1ViEpr+FIeqIBQSGHtq8nwGuW84VGU=;
        b=wvdBaQRItZryLPJz+TELLzvTKJdIBlNWCSsfOWnqtyWMPNeYRBeqiChrMPCYvkSABr
         PDRYFb4Iq41YZs1Nk8vBNETd8aAXXF5xibVnnguCniC1pHVubEi9AY3754i8qexcSGt8
         qzA4BYZYbMgNcr1x4HqZofBUbAmT+ANTUOiA5E9hfZrs4JZTPhohROooiqSwdvlf2gmy
         YgyMgKugvZTd8ChwtCVo8rvt4M9pavq2so2eVqsLsjjtvmXMVFgSmw9foVv6jyt0XP+d
         KdrEyiD6gKdu4HCUWUcl8PZhlza3gcZ6lt48SPDbmTCjHFybqNYEFAh/bN2E4ZIEdgEo
         7iug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707494476; x=1708099276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZbVkNtpn1w0i1ViEpr+FIeqIBQSGHtq8nwGuW84VGU=;
        b=P0si4s4rjtcBjJVhTrccrBPNp3xPDk4Wd2RJdbYiFmGTcl2TrkKWsBEnz6LsfQHWiC
         Ady1ddFGjVWkogzeGwXXkBrDyNBhje1q8ck/dkrYT7oltZKOzM8sIwUyOoB0EAfCi3yK
         b81ygODUbp3mRR3JGqt99YLabFvgzQW0THBa7rf4cResbZuYw0Xh4GYgA1l8kbbE4WeD
         i7iReoXvxxAJ8NpE6Sll8YkNBtQonp5Kogq8Mnvsrrqr0Y3Aqm2hfqxVu1fEYQofmW8H
         3xPitdeceqQQgoFmhM6BcXl0Uld+0teQOdJ8cUf16lQh8dS5aBgHsypvthUNVPWU7ruV
         eeLA==
X-Gm-Message-State: AOJu0YyLjqcJNwyMS8p1rYapiXJRPqfyadvDPmJsImMa456qxeLEq0Nd
	QRcTBc4XdFUQ68G6NZJRPqnaIyVHVInf47ynzA1bQljWWK9iDn4o3DYSBx5NfN/mP4256wPVEU5
	Dmc6YyO3L/HNSVPCcXb2Z/lsTYm0Zp4ANoxjM
X-Google-Smtp-Source: AGHT+IGMzobIrEgwax9OJLArVtPMh63+jV60hRyd1mTmkkI5+jbhHei18a99n8eXpND7phU8QcXSWqNBdUQ2ajSqokc=
X-Received: by 2002:a05:6870:414b:b0:214:44cf:a824 with SMTP id
 r11-20020a056870414b00b0021444cfa824mr2454691oad.32.1707494476045; Fri, 09
 Feb 2024 08:01:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <ZcOl4PTbobZTsuNW@google.com>
In-Reply-To: <ZcOl4PTbobZTsuNW@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 9 Feb 2024 08:00:00 -0800
Message-ID: <CAF7b7mp=oUzDtD6Kph3fEGAo1KAHKF6RipyfSEd3SvxGW8K4VA@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] Improve KVM + userfaultfd performance via
 KVM_MEMORY_FAULT_EXITs on stage-2 faults
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, dmatlack@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 7:46=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> A few nits throughout, but this is looking good for 6.9.
>
> Oliver / Marc,
>
> Any objection to taking this through kvm-x86? (when you feel it's ready, =
obviously)
> My plan is to put it in a dedicated topic branch, with a massaged cover l=
etter as
> the tag used for the pull request so that we can capture the motivation/b=
enefits.

Oliver and Marc,

I have a v7 ready based on the feedback I've received so far- please
let me know if I should send it or wait for you to take a look at this
version first.

On the one hand I obviously want to incorporate any feedback you have
for the next version, but on the other I suspect that if/when you look
at this you'll want to see a version with as few (known) flaws as
possible

