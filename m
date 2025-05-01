Return-Path: <kvm+bounces-45181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF939AA664A
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 00:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AED73A3500
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 22:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4908A264A90;
	Thu,  1 May 2025 22:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hMy9qMcK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1805E3D6A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746138912; cv=none; b=Oz9uYkEEHFvm9v3+c4yQ5MEyMSgXRR+He+qmI2J0AlOrU5dnEuh1XAd8/MC3Dr9RsV6JuTn0MA9EZukbAB3KxZc7ORRHYtVzjA+BbsSPO1cm2mksEHP2tGaEPXLfDI60ETlrZ/fJn9f2OZ0ipQ5u040U3+qawyhAUG2uJ4T7sx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746138912; c=relaxed/simple;
	bh=JOA4NgO3Ii4UWKSUhp8W01USJkC7OyuX5+/5+0vaeAM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CzCxIr7CC3gB7OuzuQbfAFZcWEvXrAlFCpC1JAAGo9AXUJNB/4C4f0TbFCHd5ZWhD3i5QrSJooHC2S7PJtB1rhhLes7GCT4RR8OknkCDRHeRg9wP4ezuCk+8V4mOv6C3wZFn6rVcWGQY+h2Z2md2radECzjGIMIfkw5FsbY6qt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hMy9qMcK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3087a703066so1469075a91.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 15:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746138910; x=1746743710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cOKBeFAnspSmI8/EgdCosCfU1xil82vtk65EF1UCMH0=;
        b=hMy9qMcKZ3mE8qWHgwIKnwVoxAsP2hIpOelQWEeFujMemHCTxY/8RCjTS1Z2iLrXpx
         HCC0W1kLLTbAt8aCV7iZjw4Mm8yTWimnroY3bX1xYIXCfIS4t48Hd5kp+lsp5FdOAGnA
         Fue2ICNwHrQaRA4IDkfFaVdpsPZgNi+30klfvyua8/xXbwKKASGXr8miQtkix3Ju3wIM
         QgDiqgM1wZgaXz98q9ONs0U1Ty0lmYqDWQxOsdtVTaIkMZ1pkgquVR5d4eocZ3XfZyc8
         8jH/UE/PIwQOhQx8FM8j+djsc+6vB9bAdgx27PYCkNc07CY4jfMCX5GqVYIGQevCSI51
         xSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746138910; x=1746743710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cOKBeFAnspSmI8/EgdCosCfU1xil82vtk65EF1UCMH0=;
        b=GUqP+98PQw5UGDiBy3+diGceS0vjpFahEi0cFNXXBiGzT3RSq5xWracrt4lynesCdw
         +cGs0WuC4lVDRVHQS/IE6xcmh5MeE51hPATSgxD0p42jA6sm/1KBBTO9KpQP1TMsH6n5
         WgtujOnpvy92REsmH21M7f9xWgQ5TUTMPOtUhVYp7DZtNe+YN6cBXLsIsEY9QfjxC+6k
         GhysMVbiuRnNqlGg924Y+0/4AC2EdLzhBskSJY4k2jmMUf0t8oLyYtXYYOBO5ptOMxjD
         h8I4xbJir1ORw+pJSs7sDqmv3kdVM5DOFR4x2sKYZWZxYA4s4oRnFpc2URMiY5h+x/2O
         HUDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlVJy6DE6hxVFOnyycxBivaxOCE0ZsCqI47g7XJtJWt6kYMrzDDxYDPLBOo/kFMWHuROo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/IRS7bMjeu+WCjiVIw2MjRrrpwupZRPKG+dWGYfDU8tpFWZp7
	SLl+PuMQmxIR87tdodFRDrCqzzJ5+x7JBmOwsllgDzmT97LHBE/hfpxwcOqoutN5TndcXcvM9rX
	8Wg==
X-Google-Smtp-Source: AGHT+IEkbe/gNShM7t2XnYeRJueh4eSt38bihT3NBLNk5+LsOGK/lrxEnZoCDCS1/50XzTliJA7IML7Gi8M=
X-Received: from pjbqa17.prod.google.com ([2002:a17:90b:4fd1:b0:2fc:2e92:6cf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f82:b0:2ff:58a4:9db3
 with SMTP id 98e67ed59e1d1-30a4e694ab3mr1137299a91.35.1746138910357; Thu, 01
 May 2025 15:35:10 -0700 (PDT)
Date: Thu, 1 May 2025 15:35:08 -0700
In-Reply-To: <20250426-8f1b81cc50c34db23f34110b@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250425220557.989650-1-seanjc@google.com> <20250426-8f1b81cc50c34db23f34110b@orel>
Message-ID: <aBP3HHroTm6hPK7F@google.com>
Subject: Re: [kvm-unit-tests PATCH] scripts: Search the entire string for the
 correct accelerator
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Apr 26, 2025, Andrew Jones wrote:
> On Fri, Apr 25, 2025 at 03:05:57PM -0700, Sean Christopherson wrote:
> > Search the entire ACCEL string for the required accelerator as searching
> > for an exact match incorrectly rejects ACCEL when additional accelerator
> > specific options are provided, e.g.
> > 
> >   SKIP pmu (kvm only, but ACCEL=kvm,kernel_irqchip=on)
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  scripts/runtime.bash | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 4b9c7d6b..59d1727c 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -126,7 +126,7 @@ function run()
> >          machine="$MACHINE"
> >      fi
> >  
> > -    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
> > +    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [[ ! "$ACCEL" =~ $accel ]]; then
> 
> Let's use
> 
>  [[ ! $ACCEL =~ ^$accel(,.*|$) ]]
> 
> to be a bit more precise.

Sadist.  :-)

Why the ".*"?  Isn't that the same as:

  [[ ! "$ACCEL" =~ ^$accel(,|$) ]]

Or are my regex skills worse than I realize (and I fully realize they're really,
really bad)?

