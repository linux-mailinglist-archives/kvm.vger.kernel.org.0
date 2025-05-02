Return-Path: <kvm+bounces-45233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1D3AA7441
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A21D99C704B
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75889255F43;
	Fri,  2 May 2025 13:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="svyma4WU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37752253B65
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746194096; cv=none; b=O0rvL0sVwpEMHwoX3wFttVpXaKLYpjjgkxnsgN4kmT7DTdXVaggNPNDshovsv8nRLMmu+iTcgx0F+UtnOrtxiKiMSVBUL1zYmaJYiLV8XySNufMdVY7zootYRIl+kqlBlfjWCJqz3HeHpuuew/d3Qziu2kMLlUbJ+quUOnT3GKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746194096; c=relaxed/simple;
	bh=PO/DGv1ua/tJ9AG0VM9nqz7GIeYWxKWbuYypf+en/Fc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p7pItKWBLY0mFNNiz6Es7ayFEHCm7LDpuAycRLz3I22jUrp3dxfuHOCNM0HJXhRnFVKF2h95LGpyslxFUO7QBLHf5rRGwVMM6vl8gX7rTH+EYGxHGEgUq9LyzS6PdvSeCTOW8zB02otsnJB1v36t+WKy/6Hr7SEsiZFNudY6y+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=svyma4WU; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-739515de999so1724510b3a.1
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 06:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746194094; x=1746798894; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oKIkDR8VPdGQ3cXTlzlQw2GO9+H41szxfEt6j3maiFc=;
        b=svyma4WUuTmJGcNNpw8d1HmMvisaSJpUVSjAimfJCPXgZILlD3sSViaVLirSQjHJFm
         uI5pe4eKIAmPVAhVKJkuu2IG9BdzL7GsDsDCVwoWNMrViyKFhVwTKINi+I74mX4KF1DY
         GX5TqIKDj+AzatGgJI98Ir4hwIOpK9WdOJ/A9yB8Dcw/SUQDgciVwWjZwgfIzZK+z6NB
         1/HgtWHOtmZGpVM17fLL7Gp/EZZlLQPIwLs29KYKrVQgTtEw2EnLwcJB3pu2JdjI2riX
         4+Irt4scxDWz61Qz2IYGbT1ogB/k5eFm7yS3gpC50fzcyiQKgC1FyZo2FGyyd7jv1Mxm
         bcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746194094; x=1746798894;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oKIkDR8VPdGQ3cXTlzlQw2GO9+H41szxfEt6j3maiFc=;
        b=sNXhR7Meni5Ik0F8L60Ja4eHLEuu27DWeVLXoWCGw3Nv6W6dfIpAXUoTdtAkKo4d6h
         dqf5qQvTbu0vxqJRIkT+qJwDyvaSf16JuT5HbHutBvF49wOJ338CsgLJdOW/k9WBXKBQ
         7Yvn7SZQjE+0UxJUe3eBPSKuicGJUcrSTwqzp3F/zIog94Od326aJhgud6GYFrLdTqLj
         5GgNKpfZqRkdRvhwdkPJWFiegeKldoArBZ/gebjH4e1O98xxa63Y4cVVRq/MtIB8AoRA
         18YUCdxLEru+TtQoLNYTsSk9yta2rkfaZyM+80AofsORA3jry6/89ZOqM9defvM9wziv
         rDRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV8yzvbA8kTbvJqaMPtieGEjYvhQxzn2VA6lTO98gn8FqcdIzX0jfbdWUJW60UB6Qidlo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1Joz79bhtktsTRlrPF7pEjCvT5CwhnsZNiLlOpsHwMoxyeNEh
	nJdNTw7LjMYugdpHgiu7+Pg3LjEf93YbJzxFRg2mo/oczu7aaP4R95m7YkT7YhO9PbawqJW0+KN
	bIA==
X-Google-Smtp-Source: AGHT+IFgrO6VTMdc64vrbyZjzcrS3Ya4F3L7qniths/tilgs0lc7yTtLPk9TVEkolAQhjIwHCQpt9zmlQRQ=
X-Received: from pja4.prod.google.com ([2002:a17:90b:5484:b0:2fa:a101:755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:582e:b0:309:ffa5:d526
 with SMTP id 98e67ed59e1d1-30a4e5cdcbbmr5833453a91.16.1746194094426; Fri, 02
 May 2025 06:54:54 -0700 (PDT)
Date: Fri, 2 May 2025 06:54:51 -0700
In-Reply-To: <20250502-6ff7655f7f51e12791535815@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250425220557.989650-1-seanjc@google.com> <20250426-8f1b81cc50c34db23f34110b@orel>
 <aBP3HHroTm6hPK7F@google.com> <20250502-6ff7655f7f51e12791535815@orel>
Message-ID: <aBTOq5qkpeIdl0G7@google.com>
Subject: Re: [kvm-unit-tests PATCH] scripts: Search the entire string for the
 correct accelerator
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, May 02, 2025, Andrew Jones wrote:
> On Thu, May 01, 2025 at 03:35:08PM -0700, Sean Christopherson wrote:
> > On Sat, Apr 26, 2025, Andrew Jones wrote:
> > > On Fri, Apr 25, 2025 at 03:05:57PM -0700, Sean Christopherson wrote:
> > > > Search the entire ACCEL string for the required accelerator as searching
> > > > for an exact match incorrectly rejects ACCEL when additional accelerator
> > > > specific options are provided, e.g.
> > > > 
> > > >   SKIP pmu (kvm only, but ACCEL=kvm,kernel_irqchip=on)
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  scripts/runtime.bash | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > > > index 4b9c7d6b..59d1727c 100644
> > > > --- a/scripts/runtime.bash
> > > > +++ b/scripts/runtime.bash
> > > > @@ -126,7 +126,7 @@ function run()
> > > >          machine="$MACHINE"
> > > >      fi
> > > >  
> > > > -    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
> > > > +    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [[ ! "$ACCEL" =~ $accel ]]; then
> > > 
> > > Let's use
> > > 
> > >  [[ ! $ACCEL =~ ^$accel(,.*|$) ]]
> > > 
> > > to be a bit more precise.
> > 
> > Sadist.  :-)
> 
> Hehe
> 
> > 
> > Why the ".*"?  Isn't that the same as:
> > 
> >   [[ ! "$ACCEL" =~ ^$accel(,|$) ]]
> > 
> > Or are my regex skills worse than I realize (and I fully realize they're really,
> > really bad)?
> 
> Oops, that ".*" should have been a ".+" since the intention was to avoid
> accepting 'kvm,', but, of course you're right, that .* still allows it,
> making it equivalent to nothing at all.
> 
> We can either just drop the .* and accept 'kvm,' (because why not) or
> change that * to +.

I'll drop the .*, as QEMU accepts "kvm,", i.e. it actually works.

