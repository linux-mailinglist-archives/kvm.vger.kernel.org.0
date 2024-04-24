Return-Path: <kvm+bounces-15817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CAC18B0E79
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDC7128D9D4
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99FB1635DD;
	Wed, 24 Apr 2024 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yO6QmJH1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A2F161311
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713972826; cv=none; b=kmIZ43cALShYJ1DLKrQyzpXbDxDjKvp66Nq729JnstXXB2ZRS2Gq/99DnNkj6cQyKwGNaEQXcnR6yqFb1vIgltONdoA4G1lUW/f5ZDX1GUhP+BTJ6S9Bu3LSqNUo5aKsETJPwPEg1qEcOzDwUtEY82giQ4Bj+rkG751R0L09zdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713972826; c=relaxed/simple;
	bh=im0LsoyR5JmTX5bx25GWvAq7Yqdo2jJ09USxUYdotcs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NpIqUmaoo547uhtSSVDNCieRjKaUOFqHSHtYb2GY0DIBQ5Ax7/iJQbf/2f6pinKpjhtTwHae+V/7h3I4xpmIhQLml7Qw3UPFRSN5vm8MgjZ8OHPnBxsQQhl5eJqrouokbDcfu0P+3AUirfRE25K4Ou/JXh0OA8OgWBKOrog14Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yO6QmJH1; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ed2e00aa22so52061b3a.0
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 08:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713972825; x=1714577625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oBLx3rLWfM6jLhh3E0yucJs5ITLpqaNVOm7HyYGxb9Q=;
        b=yO6QmJH1YwzX+MlB+3RQSSVdK/xVc3Oe4Zikek33sH7gVqxkS9P9cLvG1xPxwIMxpo
         +IXHmA24K+/Jg/9hNWRiou5Y9AtI3xcLjRk/bO2QkfNHKjAfbeyBN8C01hKDbK4xXH4i
         /gpvaNQpiXR72YyUFaqxRffRrL+O/srtGhUq6clqCgnUypPofzDYcYdHQKjIwJPRs15Z
         t6FS+7NV/SAMsYtH+GjtC+Qz46VHXTiUfMzRsuISEma6TJbuAqFdAdU0ZmlqCqJw8Vjc
         FdwwRwvIWRrzWbKO+4lHwmdJRy00U8ng2Id5QwH4Pxu5fNDDw3QhQGIXQuJuFrx1XY8a
         3lXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713972825; x=1714577625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBLx3rLWfM6jLhh3E0yucJs5ITLpqaNVOm7HyYGxb9Q=;
        b=aDcUtjFG0zqo1PE4EVXuvgNOS1kgaTaWvw9hwT8kdmKJx4iqXOFUmXJBvcATA37qFm
         r35bN7KildVQp64ru0Hy1K4ozUldv7KxTS9Xj6G8tFTRqKSquVkE6y/5QIXvDV1Rqcfl
         YfHd0eJfsmChhftzyLA5XKZoHLxf5zJJqZRGjRGivhMRaTN8450UbrR2ups58d7SPvQg
         xU+W5PRxbcPbl8fdJtC7wkH4aFa5B4vR2qkTNq5f4QNjuiFXg2nG6Tbx1YKqDUQ5aHhw
         H3qDjkwaKSkMMYPD62MSlUvxoZmowyfXKxb9fGC4HmKJYdC0pqqPy//xXnvefK/DMX4I
         JVsA==
X-Forwarded-Encrypted: i=1; AJvYcCUscCypYl3WnmRvB3OVLVsS7JAxT37B3mq06if8r/W0lL0KWjDqqnnuZtXorK40gf7l/SCeL+r9F+TjkKZwEqLQGY2D
X-Gm-Message-State: AOJu0YyW422sjSMqbYUw7pMpIaEbOxEIekcKNiG3mjdze6IO87T5r0zQ
	2MbNI+7U4YkBPzBydKIyNEQMuWYelujAPv9FUgs/c5w0u5cH0edftc60f1UDURkBUK6DcqGXy9j
	4iA==
X-Google-Smtp-Source: AGHT+IHRanNh8UKAP+r6FBzngsdsjXfKbEZNiE2LG/2ILik1bz7zM80jiWtBZGL7REkWCtfkC4u7AGdexeA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:14d0:b0:6ea:be19:3efb with SMTP id
 w16-20020a056a0014d000b006eabe193efbmr378768pfu.3.1713972824837; Wed, 24 Apr
 2024 08:33:44 -0700 (PDT)
Date: Wed, 24 Apr 2024 08:33:43 -0700
In-Reply-To: <8e3ad8fa55a26d8726ef0b68e40f59cbcdac1f6c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423165328.2853870-1-seanjc@google.com> <20240423165328.2853870-4-seanjc@google.com>
 <8e3ad8fa55a26d8726ef0b68e40f59cbcdac1f6c.camel@intel.com>
Message-ID: <ZikmVzsvV-tt_pSs@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Explicitly zero kvm_caps during vendor
 module load
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 24, 2024, Kai Huang wrote:
> On Tue, 2024-04-23 at 09:53 -0700, Sean Christopherson wrote:
> > Zero out all of kvm_caps when loading a new vendor module to ensure that
> > KVM can't inadvertently rely on global initialization of a field, and add
> > a comment above the definition of kvm_caps to call out that all fields
> > needs to be explicitly computed during vendor module load.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 44ce187bad89..8f3979d5fc80 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -92,6 +92,11 @@
> >  #define MAX_IO_MSRS 256
> >  #define KVM_MAX_MCE_BANKS 32
> >  
> > +/*
> > + * Note, kvm_caps fields should *never* have default values, all fields must be
> > + * recomputed from scratch during vendor module load, e.g. to account for a
> > + * vendor module being reloaded with different module parameters.
> > + */
> >  struct kvm_caps kvm_caps __read_mostly;
> >  EXPORT_SYMBOL_GPL(kvm_caps);
> >  
> > @@ -9755,6 +9760,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >  		return -EIO;
> >  	}
> >  
> > +	memset(&kvm_caps, 0, sizeof(kvm_caps));
> > +
> >  	x86_emulator_cache = kvm_alloc_emulator_cache();
> >  	if (!x86_emulator_cache) {
> >  		pr_err("failed to allocate cache for x86 emulator\n");
> 
> Why do the memset() here particularly?

So that it happens as early as possible, e.g. in case kvm_mmu_vendor_module_init()
or some other function comes along and modifies kvm_caps.

> Isn't it better to put ...
> 
> 	memset(&kvm_caps, 0, sizeof(kvm_caps));
> 	kvm_caps.supported_vm_types = BIT(KVM_X86_DEFAULT_VM);
> 	kvm_caps.supported_mce_cap = MCG_CTL_P | MCG_SER_P;
> 
> ... together so it can be easily seen?
> 
> We can even have a helper to do above to "reset kvm_caps to default
> values" I think.

Hmm, I don't think a helper is necessary, but I do agree that having all of the
explicit initialization in one place would be better.  The alternative would be
to use |= for BIT(KVM_X86_DEFAULT_VM), and MCG_CTL_P | MCG_SER_P, but I don't
think that would be an improvement.  I'll tweak the first two patches to set the
hardcoded caps earlier.

The main reason I don't want to add a helper is that coming up with a name would
be tricky.  E.g. "kvm_reset_caps()" isn't a great fit because the caps are "reset"
throughout module loading.  "kvm_set_default_caps()" kinda fits, but they aren't
so much that they are KVM's defaults, rather they are the caps that KVM can always
support regardless of hardware support, e.g. supported_xcr0 isn't optional, it
just depends on hardware.

