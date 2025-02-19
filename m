Return-Path: <kvm+bounces-38520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F75A3AD59
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 569DA7A48B2
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2E81C28E;
	Wed, 19 Feb 2025 00:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KB6aLtoS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB9D18E25
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739925926; cv=none; b=nt/NCjQkqVGCFuJ6T/lzDg+uBPnIirqLiYqBFXkz2TffsHFR1jbw7kOdnXPT0crCLMQJwIrlSc2MwilanVFyL+V78mPHaxeEk2Okmuua5hpU3mBN1DbxJy8Ac8Ovyujl9GnZIMP2saQTw+fW4uH8BaXYKO73PaVxtfwJLNz8hl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739925926; c=relaxed/simple;
	bh=3M5UDQfg0sp9lQXr0KjmgRQd5FJZVJKKkiFAVoFbtO8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JcysHbOqmOsOjw2PuwBZbDhka5PwSvnFNchtscBVApqgxLt9hdZDqIn7i26FTboHLcoMumovZDIvtRaB6/s8jChOHY8V3n/YGQE/bHSPb7V7SwFbKIAefH0aw9xjlueFRdW4HUvwICwqDdxQKo2vp1pj8h0Pa/y0dBTviL8Oge4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KB6aLtoS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220c1f88eb4so97541985ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 16:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739925924; x=1740530724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sBRMaCn5o1DpxcSOQS/VRERdVleuCYVww7nQ6v8c5zE=;
        b=KB6aLtoSSzpTP/rpOl2eQzd8GIBfmiWGFfuan9bgdUWdc9z9HqqTvdkHVOnaKA87cD
         zwDnbkXsaECOrGoBuFvgRGqTdflho1I+C08vCzCpeQO1O5ysNxkVTRo5Bby590mXBWR2
         90DUAn+Ko+kWAevYEjb1yGDt6kIuoCWZssvFRVc2EPs9dirt/r8ouFJRrCW2UfsuMQMB
         bZdZ0eTqNWTDNAObHh4fYGpZQAx7vbImmG7hFIGdI2Gzp0pcfc91rH2P4IDFRZPmoLdY
         0vdp98EwTFYrsECGD/UXAXCgDGXU9gFygUuX2nkQmIhBfrFIBxq3TgQ06yUuH1UdV+DW
         cMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739925924; x=1740530724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sBRMaCn5o1DpxcSOQS/VRERdVleuCYVww7nQ6v8c5zE=;
        b=KxuUx2lqF0t333pwPr+Vm87tyHOqcLVu5pj38IpxAetarVP0REYE4sfnwNqRepkzuj
         7ht0hFVyKTRCfYwYu+x8acscS0EYu5rI2f8LIRld818Hxjhif/MGl4FzGQInckOi5fuu
         m0NT+TbxXLn1+n0WGuWXgMUUUtwggMosSd+adcj1ELQhU9tesu0LFZd5MmInkaSgLgZw
         OSZQd7KfRRCQmWD9EpyRYAcQ6acya9Axmj3dbf3D9467vJmorNWohJ7WD1KzHYhI33Xw
         5TpVDRiYw8WAPeAlwG1XSHDFuQB1tGpZA2f3VlNO6ZB965hMsdMYt3cx/2L/aB3UjHrE
         Um8g==
X-Gm-Message-State: AOJu0YyvHtnebxJvH/tOgyMmA/WRp5tzdmqxG49Ltu6aiB5ohI27tgsD
	9kmPkUPV59Rb8jxnfxAeyS9JPvyvXTdDGTB213ezoUcmFiudLaI1nTZZNH0uV1qEflBBnoJ18pK
	GOg==
X-Google-Smtp-Source: AGHT+IHBr3WVUE0ntZOA12RfNWs7lRIHJhiglgS3OKjbhHt/2g5JIXQEORMMT93hudi8sgzbfHYK3QUPJXs=
X-Received: from pge8.prod.google.com ([2002:a05:6a02:2d08:b0:ad8:838f:18fa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d74d:b0:1ee:62e4:78cc
 with SMTP id adf61e73a8af0-1eed4fd3c50mr3189859637.36.1739925924636; Tue, 18
 Feb 2025 16:45:24 -0800 (PST)
Date: Tue, 18 Feb 2025 16:45:23 -0800
In-Reply-To: <186facf21094071fef085a7b5bad477271b0be8f.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241002235658.215903-1-mlevitsk@redhat.com> <186facf21094071fef085a7b5bad477271b0be8f.camel@redhat.com>
Message-ID: <Z7Upo-tRPav0rJ4T@google.com>
Subject: Re: [kvm-unit-tests PATCH] pmu_lbr: drop check for MSR_LBR_TOS != 0
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 18, 2025, Maxim Levitsky wrote:
> On Wed, 2024-10-02 at 19:56 -0400, Maxim Levitsky wrote:
> > While this is not likely, it is valid for the MSR_LBR_TOS
> > to contain 0 value, after a test which issues a series of branches, if the
> > number of branches recorded was divisible by the number of LBR msrs.
> > 
> > This unfortunately depends on the compiler, the number of LBR registers,
> > and it is not even deterministic between different runs of the test,
> > because interrupts, rescheduling, and various other events can affect total
> > number of branches done.
> > 
> > Therefore drop the check, instead of trying to fix it.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  x86/pmu_lbr.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
> > index c6f010847..8ca8ed044 100644
> > --- a/x86/pmu_lbr.c
> > +++ b/x86/pmu_lbr.c
> > @@ -98,7 +98,6 @@ int main(int ac, char **av)
> >  	lbr_test();
> >  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
> >  
> > -	report(rdmsr(MSR_LBR_TOS) != 0, "The guest LBR MSR_LBR_TOS value is good.");
> >  	for (i = 0; i < max; ++i) {
> >  		if (!rdmsr(lbr_to + i) || !rdmsr(lbr_from + i))
> >  			break;
> 
> Hi,
> 
> This is the other kvm-unit-tests patch that I have a ticket open for,
> and I would like to get this merged and close the ticket.

I'll grab it.  I'm hoping to get the pull request put together tomorrow, but I
might not get to it until Thusrday.

