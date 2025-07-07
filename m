Return-Path: <kvm+bounces-51714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 443ACAFBE8A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 01:22:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FD357AFD62
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 23:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A226A2877FE;
	Mon,  7 Jul 2025 23:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mDaZu2l6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBBD2566DF
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 23:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751930516; cv=none; b=Gh79etuMXNP0zpA/EbrKeGdKmyN39kyzuID/gXUM/7D6Wb1ZqTKScOK4dhBnFL7wNvjq3Nvg8RV+ILIzZ/TxiHuhZ6BZE14wm0Iaz/vLjYA+ueMt8CXmLGdw4sSonrVKW2cSFEUnT7ODzfUhe21iFitATX29UnNtUkAlIkEWhZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751930516; c=relaxed/simple;
	bh=pqF96f4IuUcJ+Kaedcxh3yV4BwEHjP0qBZxEyBdKMRw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IPQX8LgDc0uf+gz1Ko+JWe1Ec1rhyAo6m/DI8LcHOQGyhK6JJ8YTQgKT0KtB4M/o44D1fImjepSMCeCbBQislZ8S5Gdnct2nQHxGdyY02pqg5n18geTI3F+bUvdkiGZSe2YMDJeMH07x8YyWhzP8jGxU860HYRlpYagLYm01J/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mDaZu2l6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso3574284a91.2
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 16:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751930515; x=1752535315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hj1vACpIMNtLTMWL6hg/ogIsM5e3V5q++OQzP3RM6XQ=;
        b=mDaZu2l6C8H0S7GMdp8tCwLIUAGA03iTpXDWhclbHfVs4XOM4p6r6I8UEA1YrQ7mMB
         h3WRgWV5L1auR/Sa9z6irL1ZYUoBanrCTAGW9XpHwzN0MZQQWJLIWGSiLpbeHmgP2iG8
         1Ib+HEqrDAcjrXQHoLnA6Z6G7Ry9Vxv7Mw3Blr8kTbt6KMV4AQvc8vQg2YRlZ4qAyN58
         GDDEwNTShHThJdLrtSNHhKgeJfa4jLUQ4XKuS51UiIZmcjjzm+tZSTG5ZLLiHs7OGxqC
         Z0QkhtDjDL9uKiJFE+A4YwNObinhStWw3ML59Y6jyNCtJDhclDMJaMsNAySV+vuCUNoI
         jXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751930515; x=1752535315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hj1vACpIMNtLTMWL6hg/ogIsM5e3V5q++OQzP3RM6XQ=;
        b=IE3PcK/ZHar074fWzZnjXrG7MCwsVcq4svD5DZcg2+AQSvbLd0y/Opeet+bygOeJap
         MEjIvcKG1L+cKcjChdmwZ5NCZE7WMTZ+Uc05X9+lqOPEANXav3kXqJZJf4E1FyDDpjGH
         bsWXa5pD+alVSci4oKbfQs7oVF3p0CUqf3rF1UkPYHeMc/sNcoribuegA3M5u7fTcNMw
         8FBmQ+vUUrz+utLXLYxroT4E/NJmBz3s/mBNWcZaQX8cOfS8CEgIkrP09pTP8YlLulyd
         aRl34rtN6H499ThQXibkhLuxjmaMNGBma5cRKjMgaDONt+qPV1qlocEJPR8nFw0UXK0C
         hASg==
X-Forwarded-Encrypted: i=1; AJvYcCWqVJELeU8pava/3+dvPLQWOIWhkG4e9xQL/Bj+Zt3k7uo9ZSTwPiTnSSIQIkBfx/Jbus4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWMV4gj/Rgz4Z+F+Ju2/rssaSRrQdEbb9Qym5Q2LOwSsHXsw0P
	tlmTHm9MkJ2R+2hs0+veYgG4795CwozdhWJQeb5WWgaRq2OHyJacNgu3XvL5LX4pRtfmnfW2ro3
	rPavKEw==
X-Google-Smtp-Source: AGHT+IHbncMLWrVgzE6SD0IyPR2uUJ8WUdu6nwmeNiLLHHVAc6yCAhYcUqHODi7AZvQKvlplm9LydfIo/7M=
X-Received: from pjbsv15.prod.google.com ([2002:a17:90b:538f:b0:311:46e:8c26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b4f:b0:315:9cae:bd8
 with SMTP id 98e67ed59e1d1-31c20e58391mr1415731a91.23.1751930514857; Mon, 07
 Jul 2025 16:21:54 -0700 (PDT)
Date: Mon, 7 Jul 2025 16:21:53 -0700
In-Reply-To: <bp7gjrbq2xzgirehv6emtst2kywjgmcee5ktvpiooffhl36stx@bemru6qqrnsf>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626145122.2228258-1-naveen@kernel.org> <66bab47847aa378216c39f46e072d1b2039c3e0e.camel@redhat.com>
 <aF2VCQyeXULVEl7b@google.com> <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>
 <bp7gjrbq2xzgirehv6emtst2kywjgmcee5ktvpiooffhl36stx@bemru6qqrnsf>
Message-ID: <aGxWkVu5qnWkZxqz@google.com>
Subject: Re: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: mlevitsk@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 27, 2025, Naveen N Rao wrote:
> > Back when I implemented this, I just wanted to be a bit safer, a bit more explicit that
> > this uses an undocumented feature.
> > 
> > It doesn't matter much though.
> > 
> > > 
> > > I don't see any reason to do major surgery, just give "avic" auto -1/0/1 behavior:
> 
> I am wary of breaking existing users/deployments on Zen4/Zen5 enabling 
> AVIC by specifying avic=on, or avic=true today. That's primarily the 
> reason I chose not to change 'avic' into an integer. Also, post module 
> load, sysfs reports the value for 'avic' as a 'Y' or 'N' today. So if 
> there are scripts relying on that, those will break if we change 'avic' 
> into an integer.

That's easy enough to handle, e.g. see nx_huge_pages_ops for a very similar case
where KVM has "auto" behavior (and a "never" case too), but otherwise treats the
param like a bool.

> For Zen1/Zen2, as I mentioned, it is unlikely that anyone today is 
> enabling AVIC and expecting it to work since the workaround is only just 
> hitting upstream. So, I'm hoping requiring force_avic=1 should be ok 
> with the taint removed.

But if that's the motivation, changing the semantics of force_avic doesn't make
any sense.  Once the workaround lands, the only reason for force_avic to exist
is to allow forcing KVM to enable AVIC even when it's not supported.

> Longer term, once we get wider testing with the workaround on Zen1/Zen2, 
> we can consider relaxing the need for force_avic, at which point AVIC 
> can be default enabled

I don't see why the default value for "avic" needs to be tied to force_avic.
If we're not confident that AVIC is 100% functional and a net positive for the
vast majority of setups/workloads on Zen1/Zen2, then simply leave "avic" off by
default for those CPUs.  If we ever want to enable AVIC by default across the
board, we can simply change the default value of "avic".

But to be honest, I don't see any reason to bother trying to enable AVIC by default
for Zen1/Zen2.  There's a very real risk that doing so would regress existing users
that have been running setups for ~6 years, and we can't fudge around AVIC being
hidden on Zen3 (and the IOMMU not supporting it at all), i.e. enabling AVIC by
default only for Zen4+ provides a cleaner story for end users.

> and force_avic can be limited to scenarios where AVIC support is not
> advertised.
> 
> 
> Thanks,
> Naveen
> 

